unit derobConvert;

interface

uses
  Generics.Collections, derob, System.SysUtils, FMX.Dialogs, Windows,
  System.Types, System.UITypes,
  System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.StdCtrls,
  FMX.ListBox, FMX.Layouts, FMX.Edit, Math;

type
  TDerobConvert = class
  private
    FFilename: string;
    FDerobModel: TDerobModel;
    FSurface: TSurface;
    procedure SetFilename(const Value: string);
    procedure SetDerobModel(const Value: TDerobModel);
    procedure SetSurface(const Value: TSurface);
  public
    procedure ConvertForInput;
    procedure ConvertForLib;
    procedure writeLibFile;
    procedure writeInputFile;
    property Filename: string read FFilename write SetFilename;

    constructor Create;
    destructor Destroy;

    property DerobModel: TDerobModel read FDerobModel write SetDerobModel;
    property Surface: TSurface read FSurface write SetSurface;

  end;

implementation

uses mainFormny;

var
  Name: array of string;
  A, B, C, D, E, F, X, Y, Z: array of double;
  Zenith, Azimuth, AbsorptionFront, AbsorptionBack, EmittanceFront,
    EmittanceBack: array of integer;
  Lambda, Conduct, Dens, FrontEmittance, BackEmittance, Reflection,
    Transmission, GasCond, GasdCdT, GasVisc, GasdVdT, GasDens, GasdDdT,
    GasPrand, GasdPdT: array of double;
  ivol1, ivol2, id, ig, idWallMat, idGasMat, idGlassMat, idWallCon, idGasCon,
    idGlassCon, idnr, igSurf, idSurf, ShapeIndex: array of integer;
  WallCount, nel, nvol, advec, GlazeIndex: integer;
  MaterialName, ConstructionName: array of string;
  LayerCount, GlassCount, GlazeRoofA, GlazeRoofB: array of integer;
  NorthVol, EastVol, SouthVol, WestVol, VolCount: integer;
  DistanceNorth, DistanceEast, DistanceWest, DistanceSouth: double;
  AreaNorth, AreaEast, AreaSouth, AreaWest: double;
  idGlaze, GroundConstruction, igGlaze, idGlass: integer;

  vent, lat, rsoil, gvr, caph, v2, LeakRoom, LeakNorth, LeakEast, LeakSouth,
    LeakWest, LeakOpening, NLeakOpening, ELeakOpening, SLeakOpening, WLeakOpening, summervent, v1: double;
  rot, iy1, im1, id1, iy2, im2, id2, imuse, iacc, isun, iout, temp, inclw, nrpm,
    hco, hci, intld, ityp, ndp, nhp, ih1, ih2, v3, v5, v6, nventsummer,
    nventwinter, capc, v4, GlassMatCount, GasMatCount, OpaqueMatCount,
    GlassConCount, OpaqueConCount: integer;
  MARK1, MARK2, climafile, hvacname, CaseName, StartDir: string;

  { TWriteDerob }

procedure TDerobConvert.ConvertForLib;
var
  i: integer;
  j: integer;
begin
  nel := (DerobModel.WallCount + DerobModel.RoofCount + DerobModel.FloorCount +
    DerobModel.GlazingCount);
  CaseName := DerobModel.HouseProperties.StringValue['CaseName'];
  StartDir := DerobModel.HouseProperties.StringValue['StartDir'];
  SetLength(idSurf, nel);

  GlassMatCount := 0;
  GasMatCount := 0;
  OpaqueMatCount := 0;
  GlassConCount := 0;
  OpaqueConCount := 0;
  // Ta reda p� hur m�nga det finns av varje materialtyp
  for i := 0 to DerobModel.MaterialCount - 1 do
  begin
    if DerobModel.Materials[i].StringValue['MaterialType'] = 'Glass' then
    begin
      GlassMatCount := GlassMatCount + 1;
    end
    else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Gas' then
    begin
      GasMatCount := GasMatCount + 1;
    end
    else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Opaque' then
    begin
      OpaqueMatCount := OpaqueMatCount + 1;
    end;
  end;
  // Hur m�nga det finns av varje konstruktionstyp
  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    if DerobModel.Constructions[i].StringValue['ConstructionType'] = 'Window'
    then
    begin
      GlassConCount := GlassConCount + 1;
    end
    else
    begin
      OpaqueConCount := OpaqueConCount + 1;
    end;
  end;

  SetLength(Lambda, DerobModel.MaterialCount - (GlassMatCount + GasMatCount));
  SetLength(Conduct, DerobModel.MaterialCount - (GlassMatCount + GasMatCount));
  SetLength(Dens, DerobModel.MaterialCount - (GlassMatCount + GasMatCount));
  SetLength(FrontEmittance, GlassMatCount);
  SetLength(BackEmittance, GlassMatCount);
  SetLength(Reflection, GlassMatCount);
  SetLength(Transmission, GlassMatCount);
  SetLength(GasCond, GasMatCount);
  SetLength(GasdCdT, GasMatCount);
  SetLength(GasVisc, GasMatCount);
  SetLength(GasdVdT, GasMatCount);
  SetLength(GasDens, GasMatCount);
  SetLength(GasdDdT, GasMatCount);
  SetLength(GasPrand, GasMatCount);
  SetLength(GasdPdT, GasMatCount);
  SetLength(idWallMat, DerobModel.MaterialCount -
    (GlassMatCount + GasMatCount));
  SetLength(idGasMat, GasMatCount);
  SetLength(idGlassMat, GlassMatCount);
  SetLength(ig, 5);
  ig[2] := 11; // Opaque materials
  ig[0] := 22; // Glass materials
  ig[1] := 41; // Gas materials
  ig[4] := 1; // Opaque constructions
  ig[3] := 6; // Transparent constructions
  SetLength(MaterialName, DerobModel.MaterialCount);

  SetLength(idWallCon, DerobModel.ConstructionCount - GlassConCount);
  SetLength(idGlassCon, GlassConCount);
  SetLength(ConstructionName, DerobModel.ConstructionCount);
  SetLength(LayerCount, DerobModel.ConstructionCount);
  SetLength(GlassCount, GlassConCount);

  // F�rbereder alla typer av material f�r nedskrivning till indatafil
  for i := 0 to DerobModel.MaterialCount - 1 do
  begin
    if DerobModel.Materials[i].StringValue['MaterialType'] = 'Glass' then
    begin
      MaterialName[i] := DerobModel.Materials[i].Name;
      FrontEmittance[i] := DerobModel.Materials[i].DoubleValue
        ['FrontEmittance'];
      BackEmittance[i] := DerobModel.Materials[i].DoubleValue['BackEmittance'];
      Transmission[i] := DerobModel.Materials[i].DoubleValue['Transmission'];
      Reflection[i] := DerobModel.Materials[i].DoubleValue['Reflection'];
      idGlassMat[i] := i + 1;
    end
    else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Gas' then
    begin
      MaterialName[i] := DerobModel.Materials[i].Name;
      GasCond[i] := DerobModel.Materials[i].DoubleValue['Conductivity'];
      GasdCdT[i] := DerobModel.Materials[i].DoubleValue['dC/dT'];
      GasVisc[i] := DerobModel.Materials[i].DoubleValue['Viscosity'];
      GasdVdT[i] := DerobModel.Materials[i].DoubleValue['dV/dT'];
      GasDens[i] := DerobModel.Materials[i].DoubleValue['GasDensity'];
      GasdDdT[i] := DerobModel.Materials[i].DoubleValue['dD/dT'];
      GasPrand[i] := DerobModel.Materials[i].DoubleValue['Prandtl'];
      GasdPdT[i] := DerobModel.Materials[i].DoubleValue['dP/dT'];
      idGasMat[i - GlassMatCount] := (i - GlassMatCount) + 1;
    end
    else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Opaque' then
    begin
      MaterialName[i] := DerobModel.Materials[i].Name;
      Lambda[i - GlassMatCount - GasMatCount] := DerobModel.Materials[i]
        .DoubleValue['Lambda'];
      Conduct[i - GlassMatCount - GasMatCount] := DerobModel.Materials[i]
        .DoubleValue['HeatCapacity'];
      Dens[i - GlassMatCount - GasMatCount] := DerobModel.Materials[i]
        .DoubleValue['Density'];
      idWallMat[i - GlassMatCount - GasMatCount] :=
        (i - GlassMatCount - GasMatCount) + 1;
    end;
  end;

  // F�rbereder alla typer av konstruktioner f�r nedskrivning till indatafil
  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    if DerobModel.Constructions[i].StringValue['ConstructionType'] = 'Window'
    then
    begin
      ConstructionName[i] := DerobModel.Constructions[i].Name;
      LayerCount[i] := DerobModel.Constructions[i].IntValue['F�nsterskikt'];
      GlassCount[i] := DerobModel.Constructions[i].IntValue['AntalGlas'];
      idGlassCon[i] := i + 1;
      if ConstructionName[i] = DerobModel.HouseProperties.StringValue['Window']
      then
      begin
        idGlass := idGlassCon[i];
      end;
      if ConstructionName[i] = DerobModel.HouseProperties.StringValue['Glaze']
      then
      begin
        idGlaze := idGlassCon[i];
        igGlaze := 6;
      end;
    end
    else if (DerobModel.Constructions[i].StringValue['ConstructionType']
      = 'Wall') or (DerobModel.Constructions[i].StringValue['ConstructionType']
      = 'Floor') or (DerobModel.Constructions[i].StringValue['ConstructionType']
      = 'Roof') then
    begin
      ConstructionName[i] := DerobModel.Constructions[i].Name;
      LayerCount[i] := DerobModel.Constructions[i].LayerCount;
      idWallCon[i - GlassConCount] := (i - GlassConCount) + 1;

      if ConstructionName[i] = DerobModel.HouseProperties.StringValue['Wall']
      then
      begin
        for j := 0 to 3 do
        begin
          idSurf[j] := idWallCon[i - GlassConCount];

        end;
      end;
      if ConstructionName[i] = DerobModel.HouseProperties.StringValue['Roof']
      then
      begin
        idSurf[4] := idWallCon[i - GlassConCount];
      end;
      if ConstructionName[i] = DerobModel.HouseProperties.StringValue['Floor']
      then
      begin
        idSurf[5] := idWallCon[i - GlassConCount];
      end;

    end;

  end;

end;

constructor TDerobConvert.Create;
begin
  FFilename := 'Noname.dat';
end;

destructor TDerobConvert.Destroy;
begin
end;

procedure TDerobConvert.writeLibFile;
var
  LibraryFile: TextFile;
  i: integer;
  j: integer;
begin
  AssignFile(LibraryFile, 'Cases/' + CaseName + '/Libraryfile.txt');
  // Lagt till /Cases
  ReWrite(LibraryFile);

  // Skriver ner alla material beroende p� typ
  for i := 0 to DerobModel.MaterialCount - 1 do
  begin
    if DerobModel.Materials[i].StringValue['MaterialType'] = 'Glass' then
    begin
      WriteLn(LibraryFile, ig[0], ' ', idGlassMat[i], ' ', MaterialName[i]);
      WriteLn(LibraryFile, '  ', FrontEmittance[i]:0:1, ' ', BackEmittance[i]:0
        :1, ' ', Transmission[i]:0:1, ' ', Reflection[i]:0:0);
    end
    else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Gas' then
    begin
      WriteLn(LibraryFile, ig[1], ' ', idGasMat[i - GlassMatCount], ' ',
        MaterialName[i]);
      WriteLn(LibraryFile, ' ', GasCond[i], ' ', GasdCdT[i], ' ', GasVisc[i],
        ' ', GasdVdT[i], ' ', GasDens[i], '  ', GasdDdT[i], ' ', GasPrand[i],
        ' ', GasdPdT[i]);
    end
    else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Opaque' then
    begin
      WriteLn(LibraryFile, ig[2], ' ',
        idWallMat[i - GlassMatCount - GasMatCount], ' ', MaterialName[i]);
      WriteLn(LibraryFile, '  ', Lambda[i - GlassMatCount - GasMatCount]:0:3,
        ' ', Conduct[i - GlassMatCount - GasMatCount]:0:3, ' ',
        Dens[i - GlassMatCount - GasMatCount]:0:1);
    end;
  end;

  // Skriver ner alla konstruktioner beroende p� typ
  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    if DerobModel.Constructions[i].StringValue['ConstructionType'] = 'Window'
    then
    begin
      WriteLn(LibraryFile, ig[3], ' ', idGlassCon[i], ' ', GlassCount[i], ' ',
        ConstructionName[i]);
      for j := 0 to LayerCount[i] - 1 do
        if ((DerobModel.Constructions[i].Layers[j].Idx + 1) > 0) and
          ((DerobModel.Constructions[i].Layers[j].Idx + 1) < GlassMatCount + 1)
        then
        begin
          WriteLn(LibraryFile, '  ', ig[0], ' ',
            DerobModel.Constructions[i].Layers[j].Idx + 1, ' ',
            DerobModel.Constructions[i].IntValue['iflip1'], ' ',
            MaterialName[DerobModel.Constructions[i].Layers[j].Idx]);
        end
        else if ((DerobModel.Constructions[i].Layers[j].Idx + 1) >
          GlassMatCount) and ((DerobModel.Constructions[i].Layers[j].Idx + 1) <
          GlassMatCount + GasMatCount + 1) then
        begin
          WriteLn(LibraryFile, '  ', ig[1], ' ',
            DerobModel.Constructions[i].Layers[j].Idx - 23, ' ',
            DerobModel.Constructions[i].LayerThickness[j]:0:0, ' ',
            MaterialName[DerobModel.Constructions[i].Layers[j].Idx]);
        end;
    end
    else
    begin
      WriteLn(LibraryFile, ig[4], ' ', idWallCon[i - GlassConCount], ' ',
        LayerCount[i], ' ', ConstructionName[i]);
      for j := 0 to LayerCount[i] - 1 do
      begin
        WriteLn(LibraryFile, '  ', ig[2], ' ',
          DerobModel.Constructions[i].Layers[j].Idx -
          (GlassMatCount + GasMatCount - 1), ' ',
          DerobModel.Constructions[i].LayerThickness[j]:0:3, ' ',
          MaterialName[DerobModel.Constructions[i].Layers[j].Idx]);
      end;
    end;
  end;
  // Manual construction
  // for glazingfloor
  WriteLn(LibraryFile, ig[4], ' ', OpaqueConCount + 1, ' ', '1', ' ',
    'Inglasningsgolv');
  WriteLn(LibraryFile, '  ', ig[2], ' ', '10', ' ', '1000.000', ' ', 'Mark');

  CloseFile(LibraryFile);

end;

procedure TDerobConvert.SetDerobModel(const Value: TDerobModel);
begin
  FDerobModel := Value;
end;

procedure TDerobConvert.SetFilename(const Value: string);
begin
  FFilename := Value;
end;

procedure TDerobConvert.SetSurface(const Value: TSurface);
begin
  FSurface := Value;
end;

procedure TDerobConvert.ConvertForInput;
var
  i: integer;
begin
  StartDir := DerobModel.HouseProperties.StringValue['StartDir'];
  advec := DerobModel.HouseProperties.IntValue['advec'];
  nvol := DerobModel.HouseProperties.IntValue['nvol'];
  WallCount := (DerobModel.WallCount + DerobModel.RoofCount +
    DerobModel.FloorCount);
  GlazeIndex := WallCount;
  GroundConstruction := 1;
  SetLength(Name, nel);
  SetLength(A, nel);
  SetLength(B, nel);
  SetLength(C, nel);
  SetLength(D, nel);
  SetLength(E, nel);
  SetLength(F, nel);
  SetLength(ShapeIndex, nel);
  SetLength(X, nel);
  SetLength(Y, nel);
  SetLength(Z, nel);
  SetLength(Zenith, nel);
  SetLength(Azimuth, nel);
  SetLength(ivol1, nel); // Frontside
  SetLength(ivol2, nel); // Backside
  SetLength(igSurf, nel);
  SetLength(GlazeRoofA, nel);
  SetLength(GlazeRoofB, nel);
  SetLength(AbsorptionFront, nel);
  SetLength(AbsorptionBack, nel);
  SetLength(EmittanceFront, nel);
  SetLength(EmittanceBack, nel);
  // Nollst�ll s� att den inte beh�ller gamla v�rden
  for i := 0 to nel - 1 do
  begin
    X[i] := 0;
    Y[i] := 0;
    Z[i] := 0;
    A[i] := 0;
    B[i] := 0;
    C[i] := 0;
    D[i] := 0;
    E[i] := 0;
    F[i] := 0;
    Zenith[i] := 0;
    Azimuth[i] := 0;
    ivol1[i] := 0;
    ivol2[i] := 0;
    ShapeIndex[i] := 0;
    GlazeRoofA[i] := 0;
    GlazeRoofB[i] := 0;
  end;

  // --------------

  for i := 0 to WallCount - 1 do
  begin
    if i < 4 then
    begin
      Name[i] := DerobModel.Walls[i].Name;
      ivol2[i] := 1;
      AbsorptionFront[i] := DerobModel.Walls[i].Properties.IntValue
        ['AbsorptionFront'];
      AbsorptionBack[i] := DerobModel.Walls[i].Properties.IntValue
        ['AbsorptionBack']
    end;
    if i = 4 then
    begin
      Name[i] := DerobModel.Roofs[0].Name;
      ivol2[i] := 1;
      AbsorptionFront[i] := DerobModel.Roofs[0].Properties.IntValue
        ['AbsorptionFront'];
      AbsorptionBack[i] := DerobModel.Roofs[0].Properties.IntValue
        ['AbsorptionBack'];
    end;
    if i = 5 then
    begin
      Name[i] := DerobModel.Floors[0].Name;
      ivol2[i] := 1;
      ivol1[i] := -1;
      AbsorptionFront[i] := DerobModel.Floors[0].Properties.IntValue
        ['AbsorptionFront'];
      AbsorptionBack[i] := DerobModel.Floors[0].Properties.IntValue
        ['AbsorptionBack']
    end;
    EmittanceFront[i] := 87;
    EmittanceBack[i] := 87;
  end;

  for i := 0 to WallCount - 1 do      //huhu
  begin
    if (i = 0) or (i = 2) then
    begin
      A[i] := DerobModel.Surface.Width;
      B[i] := DerobModel.Surface.Height;
    end;
    if (i = 1) or (i = 3) then
    begin
      A[i] := DerobModel.Surface.Length;
      B[i] := DerobModel.Surface.Height;
    end;
    if (i = 4) or (i = 5) then
    begin
      A[i] := DerobModel.Surface.Width;
      B[i] := DerobModel.Surface.Length;
    end;
    igSurf[i] := 1;
  end;

  if DerobModel.Walls[0].Properties.BoolValue['HoleNorth'] = true then
  begin
    ShapeIndex[0] := 3;
  end
  else
  begin
    ShapeIndex[0] := 1;
  end;

  if DerobModel.Walls[1].Properties.BoolValue['HoleEast'] = true then
  begin
    ShapeIndex[1] := 3;
  end
  else
  begin
    ShapeIndex[1] := 1;
  end;

  if DerobModel.Walls[2].Properties.BoolValue['HoleSouth'] = true then
  begin
    ShapeIndex[2] := 3;
  end
  else
  begin
    ShapeIndex[2] := 1;
  end;

  if DerobModel.Walls[3].Properties.BoolValue['HoleWest'] = true then
  begin
    ShapeIndex[3] := 3;
  end
  else
  begin
    ShapeIndex[3] := 1;
  end;

  for i := 0 to 3 do
  begin
    if ShapeIndex[i] = 3 then
    begin
      C[i] := (B[i] - DerobModel.Windows[i].Height) / 2;
      D[i] := (A[i] - DerobModel.Windows[i].Width) / 2;
      E[i] := C[i] + DerobModel.Windows[i].Height;
      F[i] := D[i] + DerobModel.Windows[i].Width;
    end;
  end;

  X[1] := DerobModel.Surface.Length;
  X[2] := DerobModel.Surface.Length;
  X[4] := DerobModel.Surface.Length;
  Y[0] := DerobModel.Surface.Width;
  Y[1] := DerobModel.Surface.Width;
  Z[4] := DerobModel.Surface.Height;
  Zenith[0] := 90;
  Zenith[1] := 90;
  Zenith[2] := 90;
  Zenith[3] := 90;
  Zenith[5] := 180;
  Azimuth[0] := 180;
  Azimuth[1] := 90;
  Azimuth[3] := 270;

  //
  // INGLASNING
  //
  VolCount := 1;

  // Determine volume numbers
  if DerobModel.HouseProperties.IntValue['VolumeNorth'] = 1 then
  begin
    ivol1[0] := VolCount + 1;
    VolCount := VolCount + 1;
    NorthVol := VolCount;
  end;

  if DerobModel.HouseProperties.IntValue['VolumeEast'] = 1 then
  begin
    ivol1[1] := VolCount + 1;
    VolCount := VolCount + 1;
    EastVol := VolCount;
  end;

  if DerobModel.HouseProperties.IntValue['VolumeSouth'] = 1 then
  begin
    ivol1[2] := VolCount + 1;
    VolCount := VolCount + 1;
    SouthVol := VolCount;
  end;

  if DerobModel.HouseProperties.IntValue['VolumeWest'] = 1 then
  begin
    ivol1[3] := VolCount + 1;
    VolCount := VolCount + 1;
    WestVol := VolCount;
  end;
  { ----------------------
    ----------NORD---------
    -------------------- }

  // �r det tv� anslutande volymer?
  if DerobModel.GlazingProperties.BoolValue['NorthEast'] = true then
  begin
    X[GlazeIndex] := -DerobModel.GlazingProperties.DoubleValue['CavityNorth'];
    X[GlazeIndex + 1] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    X[GlazeIndex + 3] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    Y[GlazeIndex] := DerobModel.Surface.Width;
    Z[GlazeIndex + 2] := DerobModel.Surface.Height;
    Z[GlazeIndex + 3] := 0;
    A[GlazeIndex] := DerobModel.Surface.Width;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    A[GlazeIndex + 2] := DerobModel.Surface.Width;
    A[GlazeIndex + 3] := DerobModel.Surface.Width;
    B[GlazeIndex] := DerobModel.Surface.Height;
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    B[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    B[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    Zenith[GlazeIndex] := 90;
    Zenith[GlazeIndex + 1] := 90;
    Zenith[GlazeIndex + 2] := 0;
    Zenith[GlazeIndex + 3] := 180;

    Azimuth[GlazeIndex] := 180;
    Azimuth[GlazeIndex + 1] := 270;
    Azimuth[GlazeIndex + 2] := 0;
    Azimuth[GlazeIndex + 3] := 0;
    ivol1[GlazeIndex + 3] := -1;
    ivol2[GlazeIndex] := NorthVol;
    ivol2[GlazeIndex + 1] := NorthVol;
    ivol2[GlazeIndex + 2] := NorthVol;
    ivol2[GlazeIndex + 3] := NorthVol;
    // Best�mmer vilken  inglasning som �r tak
    GlazeRoofB[GlazeIndex + 2] := 1;

    if DerobModel.GlazingProperties.BoolValue['WestNorth'] = true then
    begin
      ivol1[GlazeIndex + 1] := WestVol;
    end;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      Name[i] := 'North' + IntToStr(i);
    end;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;

    end;
    idSurf[GlazeIndex + 3] := GroundConstruction;
    igSurf[GlazeIndex + 3] := 1;
    GlazeIndex := GlazeIndex + 4;
    DistanceNorth := DerobModel.Surface.Height / 2;
    AreaNorth := (DerobModel.GlazingProperties.DoubleValue['CavityEast'] *
      DerobModel.Surface.Height) / 2;
    // NordExtra
    Name[GlazeIndex] := 'NorthEastExtra';
    X[GlazeIndex] := -DerobModel.GlazingProperties.DoubleValue['CavityNorth'];
    Y[GlazeIndex] := DerobModel.Surface.Width + DerobModel.GlazingProperties.DoubleValue
      ['CavityEast'];
    A[GlazeIndex] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    B[GlazeIndex] := DerobModel.Surface.Height;
    Zenith[GlazeIndex] := 90;
    Azimuth[GlazeIndex] := 180;
    ivol2[GlazeIndex] := NorthVol;
    // �stExtra
    Name[GlazeIndex + 1] := 'EastNorthExtra';
    Y[GlazeIndex + 1] := DerobModel.Surface.Width + DerobModel.GlazingProperties.
      DoubleValue['CavityEast'];
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    Zenith[GlazeIndex + 1] := 90;
    Azimuth[GlazeIndex + 1] := 90;
    ivol2[GlazeIndex + 1] := NorthVol;
    // H�rnTak
    Name[GlazeIndex + 2] := 'NorthEastRoof';
    Y[GlazeIndex + 2] := DerobModel.Surface.Width;
    Z[GlazeIndex + 2] := DerobModel.Surface.Height;
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    B[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    ivol2[GlazeIndex + 2] := NorthVol;
    // H�rnGolv
    Name[GlazeIndex + 3] := 'NorthEastFloor';
    X[GlazeIndex + 3] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    Y[GlazeIndex + 3] := DerobModel.Surface.Width;
    A[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    B[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    Zenith[GlazeIndex + 3] := 180;
    ivol1[GlazeIndex + 3] := -1;
    ivol2[GlazeIndex + 3] := NorthVol;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;
    end;
    idSurf[GlazeIndex + 3] := GroundConstruction;
    igSurf[GlazeIndex + 3] := 1;
    GlazeIndex := GlazeIndex + 4;

  end
  // Enbart norra sidan
  else if DerobModel.GlazingProperties.BoolValue['GlazingNorth'] = true then
  begin
    X[GlazeIndex] := -DerobModel.GlazingProperties.DoubleValue['CavityNorth'];
    X[GlazeIndex + 1] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    X[GlazeIndex + 4] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    Y[GlazeIndex] := DerobModel.Surface.Width;
    Y[GlazeIndex + 2] := DerobModel.Surface.Width;
    Z[GlazeIndex + 3] := DerobModel.Surface.Height;
    A[GlazeIndex] := DerobModel.Surface.Width;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    A[GlazeIndex + 3] := DerobModel.Surface.Width;
    A[GlazeIndex + 4] := DerobModel.Surface.Width;
    B[GlazeIndex] := DerobModel.Surface.Height;
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    B[GlazeIndex + 2] := DerobModel.Surface.Height;
    B[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    B[GlazeIndex + 4] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    Zenith[GlazeIndex] := 90;
    Zenith[GlazeIndex + 1] := 90;
    Zenith[GlazeIndex + 2] := 90;
    Zenith[GlazeIndex + 3] := 0;
    Zenith[GlazeIndex + 4] := 180;

    Azimuth[GlazeIndex] := 180;
    Azimuth[GlazeIndex + 1] := 270;
    Azimuth[GlazeIndex + 2] := 90;
    Azimuth[GlazeIndex + 3] := 0;
    Azimuth[GlazeIndex + 4] := 0;
    ivol1[GlazeIndex + 4] := -1;
    ivol2[GlazeIndex] := NorthVol;
    ivol2[GlazeIndex + 1] := NorthVol;
    ivol2[GlazeIndex + 2] := NorthVol;
    ivol2[GlazeIndex + 3] := NorthVol;
    ivol2[GlazeIndex + 4] := NorthVol;

    GlazeRoofB[GlazeIndex + 3] := 1;

    if DerobModel.GlazingProperties.BoolValue['WestNorth'] = true then
    begin
      ivol1[GlazeIndex + 1] := WestVol;
    end;

    for i := GlazeIndex to GlazeIndex + 4 do
    begin
      Name[i] := 'North' + IntToStr(i);
    end;
    for i := GlazeIndex to GlazeIndex + 4 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;

    end;
    idSurf[GlazeIndex + 4] := GroundConstruction;
    igSurf[GlazeIndex + 4] := 1;

    GlazeIndex := GlazeIndex + 5;
  end;

  { ----------------------
    ----------�ST---------
    -------------------- }

  if DerobModel.GlazingProperties.BoolValue['EastSouth'] = true then
  begin
    X[GlazeIndex] := DerobModel.Surface.Length;
    X[GlazeIndex + 2] := DerobModel.Surface.Length;
    Y[GlazeIndex] := DerobModel.Surface.Width + DerobModel.GlazingProperties.DoubleValue
      ['CavityEast'];
    Y[GlazeIndex + 1] := DerobModel.Surface.Width + DerobModel.GlazingProperties.
      DoubleValue['CavityEast'];
    Y[GlazeIndex + 2] := DerobModel.Surface.Width;
    Y[GlazeIndex + 3] := DerobModel.Surface.Width;
    Z[GlazeIndex + 2] := DerobModel.Surface.Height;
    Z[GlazeIndex + 3] := 0;
    A[GlazeIndex] := DerobModel.Surface.Length;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    A[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    B[GlazeIndex] := DerobModel.Surface.Height;
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    B[GlazeIndex + 2] := DerobModel.Surface.Length;
    B[GlazeIndex + 3] := DerobModel.Surface.Length;
    Zenith[GlazeIndex] := 90;
    Zenith[GlazeIndex + 1] := 90;
    Zenith[GlazeIndex + 2] := 0;
    Zenith[GlazeIndex + 3] := 180;

    Azimuth[GlazeIndex] := 90;
    Azimuth[GlazeIndex + 1] := 180;
    Azimuth[GlazeIndex + 2] := 0;
    Azimuth[GlazeIndex + 3] := 0;
    ivol1[GlazeIndex + 3] := -1;
    ivol2[GlazeIndex] := EastVol;
    ivol2[GlazeIndex + 1] := EastVol;

    GlazeRoofA[GlazeIndex + 2] := 1;

    if DerobModel.GlazingProperties.BoolValue['NorthEast'] = true then
    begin
      ivol1[GlazeIndex + 1] := NorthVol;
    end;
    ivol2[GlazeIndex + 2] := EastVol;
    ivol2[GlazeIndex + 3] := EastVol;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      Name[i] := 'East' + IntToStr(i);
    end;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;

    end;
    idSurf[GlazeIndex + 3] := GroundConstruction;
    igSurf[GlazeIndex + 3] := 1;

    GlazeIndex := GlazeIndex + 4;
    DistanceEast := DerobModel.Surface.Height / 2;
    AreaEast := (DerobModel.GlazingProperties.DoubleValue['CavitySouth'] *
      DerobModel.Surface.Height) / 2;
    // �stExtra
    Name[GlazeIndex] := 'EastSouthExtra';
    X[GlazeIndex] := DerobModel.Surface.Length + DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    Y[GlazeIndex] := DerobModel.Surface.Width + DerobModel.GlazingProperties.DoubleValue
      ['CavityEast'];
    A[GlazeIndex] := DerobModel.GlazingProperties.DoubleValue['CavitySouth'];
    B[GlazeIndex] := DerobModel.Surface.Height;
    Zenith[GlazeIndex] := 90;
    Azimuth[GlazeIndex] := 90;
    ivol2[GlazeIndex] := EastVol;
    // SydExtra
    Name[GlazeIndex + 1] := 'SouthEastExtra';
    X[GlazeIndex + 1] := DerobModel.Surface.Length +
      DerobModel.GlazingProperties.DoubleValue['CavitySouth'];
    Y[GlazeIndex + 1] := DerobModel.Surface.Width;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    Zenith[GlazeIndex + 1] := 90;
    ivol2[GlazeIndex + 1] := EastVol;
    // H�rnTak
    Name[GlazeIndex + 2] := 'EastSouthRoof';
    X[GlazeIndex + 2] := DerobModel.Surface.Length +
      DerobModel.GlazingProperties.DoubleValue['CavitySouth'];
    Y[GlazeIndex + 2] := DerobModel.Surface.Width;
    Z[GlazeIndex + 2] := DerobModel.Surface.Height;
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    B[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    ivol2[GlazeIndex + 2] := EastVol;
    // H�rnGolv
    Name[GlazeIndex + 3] := 'EastSouthFloor';
    X[GlazeIndex + 3] := DerobModel.Surface.Length;
    Y[GlazeIndex + 3] := DerobModel.Surface.Width;
    A[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    B[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    Zenith[GlazeIndex + 3] := 180;
    ivol1[GlazeIndex + 3] := -1;
    ivol2[GlazeIndex + 3] := EastVol;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;
    end;
    idSurf[GlazeIndex + 3] := GroundConstruction;
    igSurf[GlazeIndex + 3] := 1;

    GlazeIndex := GlazeIndex + 4;
  end
  else if DerobModel.GlazingProperties.BoolValue['GlazingEast'] = true then
  begin
    X[GlazeIndex] := DerobModel.Surface.Length;
    X[GlazeIndex + 2] := DerobModel.Surface.Length;
    X[GlazeIndex + 3] := DerobModel.Surface.Length;
    Y[GlazeIndex] := DerobModel.Surface.Width + DerobModel.GlazingProperties.DoubleValue
      ['CavityEast'];
    Y[GlazeIndex + 1] := DerobModel.Surface.Width + DerobModel.GlazingProperties.
      DoubleValue['CavityEast'];
    Y[GlazeIndex + 2] := DerobModel.Surface.Width;
    Y[GlazeIndex + 3] := DerobModel.Surface.Width;
    Y[GlazeIndex + 4] := DerobModel.Surface.Width;
    Z[GlazeIndex + 3] := DerobModel.Surface.Height;
    A[GlazeIndex] := DerobModel.Surface.Length;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    A[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    A[GlazeIndex + 4] := DerobModel.GlazingProperties.DoubleValue['CavityEast'];
    B[GlazeIndex] := DerobModel.Surface.Height;
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    B[GlazeIndex + 2] := DerobModel.Surface.Height;
    B[GlazeIndex + 3] := DerobModel.Surface.Length;
    B[GlazeIndex + 4] := DerobModel.Surface.Length;
    Zenith[GlazeIndex] := 90;
    Zenith[GlazeIndex + 1] := 90;
    Zenith[GlazeIndex + 2] := 90;
    Zenith[GlazeIndex + 3] := 0;
    Zenith[GlazeIndex + 4] := 180;

    Azimuth[GlazeIndex] := 90;
    Azimuth[GlazeIndex + 1] := 180;
    Azimuth[GlazeIndex + 2] := 0;
    Azimuth[GlazeIndex + 3] := 0;
    Azimuth[GlazeIndex + 4] := 0;
    ivol1[GlazeIndex + 4] := -1;
    ivol2[GlazeIndex] := EastVol;
    ivol2[GlazeIndex + 1] := EastVol;

    GlazeRoofA[GlazeIndex + 3] := 1;

    if DerobModel.GlazingProperties.BoolValue['NorthEast'] = true then
    begin
      ivol1[GlazeIndex + 1] := NorthVol;
    end;
    ivol2[GlazeIndex + 2] := EastVol;
    ivol2[GlazeIndex + 3] := EastVol;
    ivol2[GlazeIndex + 4] := EastVol;

    for i := GlazeIndex to GlazeIndex + 4 do
    begin
      Name[i] := 'East' + IntToStr(i);
    end;
    for i := GlazeIndex to GlazeIndex + 4 do
    begin
      idSurf[i] := idGlaze;
      idSurf[i] := idGlaze;
    end;
    idSurf[GlazeIndex + 4] := GroundConstruction;
    igSurf[GlazeIndex + 4] := 1;

    GlazeIndex := GlazeIndex + 5;
  end;

  { ----------------------
    ----------SYD---------
    -------------------- }

  if DerobModel.GlazingProperties.BoolValue['SouthWest'] = true then
  begin
    X[GlazeIndex] := DerobModel.Surface.Length + DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    X[GlazeIndex + 1] := DerobModel.Surface.Length +
      DerobModel.GlazingProperties.DoubleValue['CavitySouth'];
    X[GlazeIndex + 2] := DerobModel.Surface.Length +
      DerobModel.GlazingProperties.DoubleValue['CavitySouth'];
    X[GlazeIndex + 3] := DerobModel.Surface.Length;
    Y[GlazeIndex + 1] := DerobModel.Surface.Width;
    Z[GlazeIndex + 2] := DerobModel.Surface.Height;
    Z[GlazeIndex + 3] := 0;
    A[GlazeIndex] := DerobModel.Surface.Width;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    A[GlazeIndex + 2] := DerobModel.Surface.Width;
    A[GlazeIndex + 3] := DerobModel.Surface.Width;
    B[GlazeIndex] := DerobModel.Surface.Height;
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    B[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    B[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    Zenith[GlazeIndex] := 90;
    Zenith[GlazeIndex + 1] := 90;
    Zenith[GlazeIndex + 2] := 0;
    Zenith[GlazeIndex + 3] := 180;
    Azimuth[GlazeIndex] := 0;
    Azimuth[GlazeIndex + 1] := 90;
    Azimuth[GlazeIndex + 2] := 0;
    Azimuth[GlazeIndex + 3] := 0;
    ivol1[GlazeIndex + 3] := -1;
    ivol2[GlazeIndex] := SouthVol;

    GlazeRoofB[GlazeIndex + 2] := 1;

    if DerobModel.GlazingProperties.BoolValue['EastSouth'] = true then
    begin
      ivol1[GlazeIndex + 1] := EastVol;
    end;
    ivol2[GlazeIndex + 1] := SouthVol;
    ivol2[GlazeIndex + 2] := SouthVol;
    ivol2[GlazeIndex + 3] := SouthVol;

    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      Name[i] := 'South' + IntToStr(i);
    end;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;
    end;
    idSurf[GlazeIndex + 3] := GroundConstruction;
    igSurf[GlazeIndex + 3] := 1;

    GlazeIndex := GlazeIndex + 4;
    DistanceSouth := DerobModel.Surface.Height / 2;
    AreaSouth := (DerobModel.GlazingProperties.DoubleValue['CavityWest'] *
      DerobModel.Surface.Height) / 2;

    // SydExtra
    Name[GlazeIndex] := 'SouthWestExtra';
    X[GlazeIndex] := DerobModel.Surface.Length + DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    Y[GlazeIndex] := -DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    A[GlazeIndex] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    B[GlazeIndex] := DerobModel.Surface.Height;
    Zenith[GlazeIndex] := 90;
    ivol2[GlazeIndex] := SouthVol;
    // V�stExtra
    Name[GlazeIndex + 1] := 'WestSouthExtra';
    X[GlazeIndex + 1] := DerobModel.Surface.Length;
    Y[GlazeIndex + 1] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    Zenith[GlazeIndex + 1] := 90;
    Azimuth[GlazeIndex + 1] := 270;
    ivol2[GlazeIndex + 1] := SouthVol;
    // H�rnTak
    Name[GlazeIndex + 2] := 'SouthWestRoof';
    X[GlazeIndex + 2] := DerobModel.Surface.Length +
      DerobModel.GlazingProperties.DoubleValue['CavitySouth'];
    Y[GlazeIndex + 2] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    Z[GlazeIndex + 2] := DerobModel.Surface.Height;
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    B[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    ivol2[GlazeIndex + 2] := SouthVol;
    // H�rnGolv
    Name[GlazeIndex + 3] := 'SouthWestFloor';
    X[GlazeIndex + 3] := DerobModel.Surface.Length;
    Y[GlazeIndex + 3] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    A[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    B[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    Zenith[GlazeIndex + 3] := 180;
    ivol1[GlazeIndex + 3] := -1;
    ivol2[GlazeIndex + 3] := SouthVol;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;

    end;
    idSurf[GlazeIndex + 3] := GroundConstruction;
    igSurf[GlazeIndex + 3] := 1;

    GlazeIndex := GlazeIndex + 4;
  end
  else if DerobModel.GlazingProperties.BoolValue['GlazingSouth'] = true then
  begin
    X[GlazeIndex] := DerobModel.Surface.Length + DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    X[GlazeIndex + 1] := DerobModel.Surface.Length +
      DerobModel.GlazingProperties.DoubleValue['CavitySouth'];
    X[GlazeIndex + 2] := DerobModel.Surface.Length;
    X[GlazeIndex + 3] := DerobModel.Surface.Length +
      DerobModel.GlazingProperties.DoubleValue['CavitySouth'];
    X[GlazeIndex + 4] := DerobModel.Surface.Length;
    Y[GlazeIndex + 1] := DerobModel.Surface.Width;
    Y[GlazeIndex + 4] := 0;
    Z[GlazeIndex + 2] := 0;
    Z[GlazeIndex + 3] := DerobModel.Surface.Height;
    A[GlazeIndex] := DerobModel.Surface.Width;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    A[GlazeIndex + 3] := DerobModel.Surface.Width;
    A[GlazeIndex + 4] := DerobModel.Surface.Width;
    B[GlazeIndex] := DerobModel.Surface.Height;
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    B[GlazeIndex + 2] := DerobModel.Surface.Height;
    B[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    B[GlazeIndex + 4] := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
    Zenith[GlazeIndex] := 90;
    Zenith[GlazeIndex + 1] := 90;
    Zenith[GlazeIndex + 2] := 90;
    Zenith[GlazeIndex + 3] := 0;
    Zenith[GlazeIndex + 4] := 180;
    Azimuth[GlazeIndex] := 0;
    Azimuth[GlazeIndex + 1] := 90;
    Azimuth[GlazeIndex + 2] := 270;
    Azimuth[GlazeIndex + 3] := 0;
    Azimuth[GlazeIndex + 4] := 0;
    ivol1[GlazeIndex + 4] := -1;
    ivol2[GlazeIndex] := SouthVol;
    ivol2[GlazeIndex + 1] := SouthVol;
    ivol2[GlazeIndex + 2] := SouthVol;
    ivol2[GlazeIndex + 3] := SouthVol;
    ivol2[GlazeIndex + 4] := SouthVol;

    GlazeRoofB[GlazeIndex + 3] := 1;

    if DerobModel.GlazingProperties.BoolValue['SouthWest'] = true then
    begin
      ivol1[GlazeIndex + 1] := WestVol;
    end;

    for i := GlazeIndex to GlazeIndex + 4 do
    begin
      Name[i] := 'South' + IntToStr(i);
    end;
    for i := GlazeIndex to GlazeIndex + 4 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;

    end;
    idSurf[GlazeIndex + 4] := GroundConstruction;
    igSurf[GlazeIndex + 4] := 1;

    GlazeIndex := GlazeIndex + 5;
  end;

  { ----------------------
    ----------V�ST---------
    -------------------- }

  if DerobModel.GlazingProperties.BoolValue['WestNorth'] = true then
  begin
    X[GlazeIndex + 1] := DerobModel.Surface.Length;
    X[GlazeIndex + 2] := DerobModel.Surface.Length;
    Y[GlazeIndex] := -DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    Y[GlazeIndex + 1] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    Y[GlazeIndex + 2] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    Y[GlazeIndex + 3] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    Z[GlazeIndex + 2] := DerobModel.Surface.Height;
    Z[GlazeIndex + 3] := 0;
    A[GlazeIndex] := DerobModel.Surface.Length;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    A[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    B[GlazeIndex] := DerobModel.Surface.Height;
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    B[GlazeIndex + 2] := DerobModel.Surface.Length;
    B[GlazeIndex + 3] := DerobModel.Surface.Length;
    Zenith[GlazeIndex] := 90;
    Zenith[GlazeIndex + 1] := 90;
    Zenith[GlazeIndex + 2] := 0;
    Zenith[GlazeIndex + 3] := 180;

    Azimuth[GlazeIndex] := 270;
    Azimuth[GlazeIndex + 1] := 0;
    Azimuth[GlazeIndex + 2] := 0;
    Azimuth[GlazeIndex + 3] := 0;

    ivol1[GlazeIndex + 3] := -1;
    ivol2[GlazeIndex] := WestVol;
    ivol2[GlazeIndex + 1] := WestVol;
    ivol2[GlazeIndex + 2] := WestVol;
    ivol2[GlazeIndex + 3] := WestVol;

    GlazeRoofA[GlazeIndex + 2] := 1;

    if DerobModel.GlazingProperties.BoolValue['SouthWest'] = true then
    begin
      ivol1[GlazeIndex + 1] := SouthVol;
    end;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      Name[i] := 'West' + IntToStr(i);
    end;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;

    end;
    idSurf[GlazeIndex + 3] := GroundConstruction;
    igSurf[GlazeIndex + 3] := 1;

    GlazeIndex := GlazeIndex + 4;
    DistanceWest := DerobModel.Surface.Height / 2;
    AreaWest := (DerobModel.GlazingProperties.DoubleValue['CavityNorth'] *
      DerobModel.Surface.Height) / 2;

    // V�stExtra
    Name[GlazeIndex] := 'WestNorthExtra';
    X[GlazeIndex] := -DerobModel.GlazingProperties.DoubleValue['CavityNorth'];
    Y[GlazeIndex] := -DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    A[GlazeIndex] := DerobModel.GlazingProperties.DoubleValue['CavityNorth'];
    B[GlazeIndex] := DerobModel.Surface.Height;
    Zenith[GlazeIndex] := 90;
    Azimuth[GlazeIndex] := 270;
    ivol2[GlazeIndex] := WestVol;
    // NordExtra
    Name[GlazeIndex + 1] := 'NorthWestExtra';
    X[GlazeIndex + 1] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    Zenith[GlazeIndex + 1] := 90;
    Azimuth[GlazeIndex + 1] := 180;
    ivol2[GlazeIndex + 1] := WestVol;
    // H�rnTak
    Name[GlazeIndex + 2] := 'WestNorthRoof';
    Y[GlazeIndex + 2] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    Z[GlazeIndex + 2] := DerobModel.Surface.Height;
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    B[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    ivol2[GlazeIndex + 2] := WestVol;
    // H�rnGolv
    Name[GlazeIndex + 3] := 'NorthWestFloor';
    X[GlazeIndex + 3] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    Y[GlazeIndex + 3] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    A[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    B[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
    Zenith[GlazeIndex + 3] := 180;
    ivol1[GlazeIndex + 3] := -1;
    ivol2[GlazeIndex + 3] := WestVol;
    for i := GlazeIndex to GlazeIndex + 3 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;

    end;
    idSurf[GlazeIndex + 3] := GroundConstruction;
    igSurf[GlazeIndex + 3] := 1;
    GlazeIndex := GlazeIndex + 4;

  end
  else if DerobModel.GlazingProperties.BoolValue['GlazingWest'] = true then
  begin
    X[GlazeIndex + 1] := DerobModel.Surface.Length;
    X[GlazeIndex + 3] := DerobModel.Surface.Length;
    Y[GlazeIndex] := -DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    Y[GlazeIndex + 1] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    Y[GlazeIndex + 3] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    Y[GlazeIndex + 4] := -DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
    Z[GlazeIndex + 3] := DerobModel.Surface.Height;
    A[GlazeIndex] := DerobModel.Surface.Length;
    A[GlazeIndex + 1] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    A[GlazeIndex + 2] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    A[GlazeIndex + 3] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    A[GlazeIndex + 4] := DerobModel.GlazingProperties.DoubleValue['CavityWest'];
    B[GlazeIndex] := DerobModel.Surface.Height;
    B[GlazeIndex + 1] := DerobModel.Surface.Height;
    B[GlazeIndex + 2] := DerobModel.Surface.Height;
    B[GlazeIndex + 3] := DerobModel.Surface.Length;
    B[GlazeIndex + 4] := DerobModel.Surface.Length;
    Zenith[GlazeIndex] := 90;
    Zenith[GlazeIndex + 1] := 90;
    Zenith[GlazeIndex + 2] := 90;
    Zenith[GlazeIndex + 3] := 0;
    Zenith[GlazeIndex + 4] := 180;

    Azimuth[GlazeIndex] := 270;
    Azimuth[GlazeIndex + 1] := 0;
    Azimuth[GlazeIndex + 2] := 180;
    Azimuth[GlazeIndex + 3] := 0;
    Azimuth[GlazeIndex + 4] := 0;

    ivol1[GlazeIndex + 4] := -1;
    ivol2[GlazeIndex] := WestVol;
    ivol2[GlazeIndex + 1] := WestVol;
    ivol2[GlazeIndex + 2] := WestVol;
    ivol2[GlazeIndex + 3] := WestVol;
    ivol2[GlazeIndex + 4] := WestVol;

    GlazeRoofA[GlazeIndex + 3] := 1;

    if DerobModel.GlazingProperties.BoolValue['SouthWest'] = true then
    begin
      ivol1[GlazeIndex + 1] := SouthVol;
    end;
    for i := GlazeIndex to GlazeIndex + 4 do
    begin
      Name[i] := 'West' + IntToStr(i);
    end;
    for i := GlazeIndex to GlazeIndex + 4 do
    begin
      idSurf[i] := idGlaze;
      igSurf[i] := igGlaze;

    end;
    idSurf[GlazeIndex + 4] := GroundConstruction;
    igSurf[GlazeIndex + 4] := 1;
    GlazeIndex := GlazeIndex + 5;
  end;

  for i := 0 to nel - 1 do
  begin
    if ShapeIndex[i] = 0 then
    begin
      ShapeIndex[i] := 1;
    end;
    if igSurf[i] = 0 then
    begin
      igSurf[i] := 6;
    end;
  end;

  for i := WallCount to GlazeIndex do
  begin
    if igSurf[i] = 1 then
      AbsorptionBack[i] := 90;
    EmittanceBack[i] := 90;
  end;
  if DerobModel.HouseProperties.BoolValue['KGK'] = false then
  begin
    // MARK#1
    rot := DerobModel.HouseProperties.IntValue['Rotation'];
    lat := DerobModel.HouseProperties.DoubleValue['Latitude'];
    iy1 := DerobModel.HouseProperties.IntValue['FromYear'];
    iy2 := DerobModel.HouseProperties.IntValue['ToYear'];
    im1 := DerobModel.HouseProperties.IntValue['FromMonth'];
    im2 := DerobModel.HouseProperties.IntValue['ToMonth'];
    id1 := DerobModel.HouseProperties.IntValue['FromDay'];
    id2 := DerobModel.HouseProperties.IntValue['ToDay'];
    MARK1 := '#1';

    MARK2 := '#2';
    iacc := 2;
    isun := 0;
    iout := 0;
    temp := 15; // Doesn't matter
    climafile := DerobModel.HouseProperties.StringValue['LocationPath'];
    inclw := 1;
    nrpm := 20; // Default value,minimum
    rsoil := 1.87;
    hco := 11;
    hci := -1;
    gvr := 20;
    intld := 0;
    hvacname := 'HVAC-Schema';
    ityp := 1;
    caph := 1E+20;
    capc := 0;
    ndp := 1;
    nhp := 1;
    ih1 := 1;
    ih2 := 24;
    v3 := DerobModel.HouseProperties.IntValue['TMinRoom'];
    // Min. temp accepterad i rummet
    v4 := 0; // kylkapacitet
    v5 := 1000; // 1000 grader innan vi kyler(kylkapacitet 0)

    if nvol > 1 then
    begin
      vent := (1 - DerobModel.VentilationProperties.DoubleValue['Eta'] / 100) *
        DerobModel.VentilationProperties.DoubleValue['Flow'] / (nvol - 1);
      vent := Round(vent * 10) / 10;
    end
    else
    begin
      vent := (1 - DerobModel.VentilationProperties.DoubleValue['Eta'] / 100) *
        DerobModel.VentilationProperties.DoubleValue['Flow'];
    end;
    LeakRoom := DerobModel.VentilationProperties.DoubleValue['Leak1'];
    LeakNorth := DerobModel.VentilationProperties.DoubleValue['Leak2'];
    LeakEast := DerobModel.VentilationProperties.DoubleValue['Leak3'];
    LeakSouth := DerobModel.VentilationProperties.DoubleValue['Leak4'];
    LeakWest := DerobModel.VentilationProperties.DoubleValue['Leak5'];
    LeakOpening := DerobModel.VentilationProperties.DoubleValue['OpeningLeakage'];

    if Form1.nvol > 1 then
    begin
      nventwinter := 1 + 2 * (Form1.nvol - 1);
    end
    else
    begin
      nventwinter := 2;
    end;

    summervent := DerobModel.VentilationProperties.DoubleValue['Flow'];
    nventsummer := 2;

  end;
end;


procedure TDerobConvert.writeInputFile;
var
  T: TextFile;
  i, j: integer;
  Idx: integer;
begin
  SetCurrentDir('Cases');
  SetCurrentDir(CaseName);
  CreateDir('Winter');
  CreateDir('Summer');
  CreateDir('WinterOpen');
  CreateDir('SummerOpen');
  CreateDir('NoGlaze');
  for Idx := 1 to 5 do
  // IDX 1: Vinterfall, 2:3 Sommarfall, 3: Vinterfall med �ppning, 4: Sommarfall med �ppning, 5: Referensfall
  begin

    SetCurrentDir(StartDir);

    if Idx = 1 then
    begin
      AssignFile(T, 'Cases/' + CaseName + '/Winter/Indata' + IntToStr(Idx)
        + '.txt');
    end
    else if Idx = 2 then
    begin
      AssignFile(T, 'Cases/' + CaseName + '/Summer/Indata' + IntToStr(Idx)
        + '.txt');
    end
    else if Idx = 3 then
    begin
      AssignFile(T, 'Cases/' + CaseName + '/WinterOpen/Indata' + IntToStr(Idx)
        + '.txt');
    end
    else if Idx = 4 then
    begin
      AssignFile(T, 'Cases/' + CaseName + '/SummerOpen/Indata' + IntToStr(Idx)
        + '.txt');
    end
    else if Idx = 5 then
    begin
      AssignFile(T, 'Cases/' + CaseName + '/NoGlaze/Indata' + IntToStr(Idx)
        + '.txt');
    end;

    // Lagt till Cases
    ReWrite(T);
    WriteLn(T, 'Fall ' + IntToStr(Idx));
    SetCurrentDir('Cases');
    SetCurrentDir(CaseName);
    WriteLn(T, GetCurrentDir + '\Libraryfile.txt');

    if Idx = 5 then
    begin
      vent := (1 - DerobModel.VentilationProperties.DoubleValue['Eta'] / 100) *
        DerobModel.VentilationProperties.DoubleValue['Flow'];
      nvol := 1;
      nel := WallCount;
      for i := 0 to WallCount do
      begin
        if ivol1[i] <> -1 then
        begin
          ivol1[i] := 0;
        end;
      end;
    end;

    // Number of Volumues, number of elements
    WriteLn(T, nvol, '   ', nel);
    // Advection Connection if-sats
    if nvol > 1 then
    begin
      if DerobModel.VentilationProperties.BoolValue['AdvectionConnection'] = true
      then
      begin
        WriteLn(T, advec);

        if DerobModel.GlazingProperties.BoolValue['NorthEast'] = true then
          WriteLn(T, NorthVol, ' ', EastVol, ' ', DistanceNorth:0:3, ' ',
            AreaNorth:0:3);
        if DerobModel.GlazingProperties.BoolValue['EastSouth'] = true then
          WriteLn(T, EastVol, ' ', SouthVol, ' ', DistanceEast:0:3, ' ',
            AreaEast:0:3);
        if DerobModel.GlazingProperties.BoolValue['SouthWest'] = true then
          WriteLn(T, SouthVol, ' ', WestVol, ' ', DistanceSouth:0:3, ' ',
            AreaSouth:0:3);
        if DerobModel.GlazingProperties.BoolValue['WestNorth'] = true then
          WriteLn(T, WestVol, ' ', NorthVol, ' ', DistanceWest:0:3, ' ',
            AreaWest:0:3);
      end
      else
      begin
        WriteLn(T, '0');
      end;
    end;

    for j := 0 to nel - 1 do
    begin
      // Namn, Shape Index, Construction Group,Construction ID,Front Vol, Back Vol
      WriteLn(T, Name[j]);
      WriteLn(T, ShapeIndex[j], ' ', igSurf[j], ' ', idSurf[j], ' ', ivol1[j],
        ' ', ivol2[j]);
      WriteLn(T, '   ', A[j]:0:3, '   ', B[j]:0:3, '   ', C[j]:0:3, '   ',
        D[j]:0:3, '   ', E[j]:0:3, '   ', F[j]:0:3, ' ', Zenith[j], ' ',
        Azimuth[j], ' ', X[j]:0:3, '   ', Y[j]:0:3, '   ', Z[j]:0:3);

      if igSurf[j] = 1 then
      begin
        WriteLn(T, AbsorptionFront[j], ' ', AbsorptionBack[j], ' ',
          EmittanceFront[j], ' ', EmittanceBack[j]);
      end;
      if igSurf[j] = 6 then
      begin
        WriteLn(T, '0');
      end;
      if ShapeIndex[j] = 3 then
      begin
        WriteLn(T, '6', ' ', idGlass, ' ', '0');
      end;
    end;

    if DerobModel.HouseProperties.BoolValue['KGK'] = false then
    begin
      // MARK#1
      WriteLn(T, ' ');
      WriteLn(T, MARK1);
      WriteLn(T, ' ', rot);
      WriteLn(T, ' ', lat:0:2);
      WriteLn(T, ' ', iy1, ' ', im1, ' ', id1);
      WriteLn(T, ' ', iy2, ' ', im2, ' ', id2);

      // MARK#2
      WriteLn(T, ' ');
      WriteLn(T, MARK2);
      WriteLn(T, ' ', iacc, ' ', isun, ' ', iout, ' ', temp);
      // iacc isun iout temp from climatefile
      WriteLn(T, ' ', climafile);
      WriteLn(T, ' ', inclw); // inclw, LW-utbyte med himmel och mark beaktas
      WriteLn(T, ' ', nrpm);
      WriteLn(T, ' ', rsoil:0:2, ' ', hco, ' ', hci, ' ', gvr);
      WriteLn(T, ' ', intld);
      WriteLn(T, ' ', hvacname);

      for i := 0 to nvol - 1 do
      begin
        if i <> 0 then
        begin
          caph := 0;
          v2 := 0;
          v6 := 0;
        end
        else if i = 0 then
        begin
          caph := 1E+20;
          v2 := 1E+20;
          v6 := DerobModel.HouseProperties.IntValue['IntHeat'];
        end;

        NLeakOpening := 0;
        ELeakOpening := 0;
        SLeakOpening := 0;
        WLeakOpening := 0;

        if (DerobModel.VentilationProperties.BoolValue['AdvectionConnection'] = False) and ((Idx = 3) or (Idx = 4)) then
          begin
            NLeakOpening := LeakOpening;
            ELeakOpening := LeakOpening;
            SLeakOpening := LeakOpening;
            WLeakOpening := LeakOpening;
          end;

        if (DerobModel.VentilationProperties.BoolValue['AdvectionConnection'] = True) and ((Idx = 3) or (Idx = 4)) then
          begin
            if DerobModel.GlazingProperties.BoolValue['GlazingSouth'] = True then
              begin
                SLeakOpening := LeakOpening;
              end
            else if DerobModel.GlazingProperties.BoolValue['GlazingEast'] = True then
              begin
                ELeakOpening := LeakOpening;
              end
            else if DerobModel.GlazingProperties.BoolValue['GlazingWest'] = True then
              begin
                WLeakOpening := LeakOpening;
              end
            else if DerobModel.GlazingProperties.BoolValue['GlazingNorth'] = True then
              begin
                NLeakOpening := LeakOpening;
              end;
          end;


        v1 := 0;
        if (LeakRoom <> 0) and (i = 0) then
        begin
          v1 := LeakRoom;
        end;
        if (DerobModel.GlazingProperties.BoolValue['GlazingNorth'] = True) and (i = NorthVol-1) then
        begin
          v1 := LeakNorth + NLeakOpening;
        end;
        if (DerobModel.GlazingProperties.BoolValue['GlazingEast'] = True) and (i = EastVol-1) then
        begin
          v1 := LeakEast + ELeakOpening;
        end;
        if (DerobModel.GlazingProperties.BoolValue['GlazingSouth'] = True) and (i = SouthVol-1) then
        begin
          v1 := LeakSouth + SLeakOpening;
        end;
        if (DerobModel.GlazingProperties.BoolValue['GlazingWest'] = True) and (i = WestVol-1) then
        begin
          v1 := LeakWest + WLeakOpening;
        end;

        WriteLn(T, '   ', ityp, ' ', caph:0:1, ' ', capc);
        WriteLn(T, '   ', ndp);
        WriteLn(T, '     ', id1, ' ', im1, ' ', id2, ' ', im2);
        WriteLn(T, '     ', nhp);
        WriteLn(T, '       ', ih1, ' ', ih2, ' ', v1:0:2, ' ', v2:0:1, ' ', v3,
          ' ', v4, ' ', v5, ' ', v6);
      end;

      if (Idx = 1) or (Idx = 3) then
      begin
        WriteLn(T, ' ', nventwinter);

        if DerobModel.GlazingProperties.BoolValue['GlazingNorth'] = true then
        begin
          WriteLn(T, '   ', '0', ' ', NorthVol, ' ', vent:0:2);
          WriteLn(T, '   ', NorthVol, ' ', '1', ' ', vent:0:2);
        end;

        if DerobModel.GlazingProperties.BoolValue['GlazingEast'] = true then
        begin
          WriteLn(T, '   ', '0', ' ', EastVol, ' ', vent:0:2);
          WriteLn(T, '   ', EastVol, ' ', '1', ' ', vent:0:2);
        end;

        if DerobModel.GlazingProperties.BoolValue['GlazingSouth'] = true then
        begin
          WriteLn(T, '   ', '0', ' ', SouthVol, ' ', vent:0:2);
          WriteLn(T, '   ', SouthVol, ' ', '1', ' ', vent:0:2);
        end;

        if DerobModel.GlazingProperties.BoolValue['GlazingWest'] = true then
        begin
          WriteLn(T, '   ', '0', ' ', WestVol, ' ', vent:0:2);
          WriteLn(T, '   ', WestVol, ' ', '1', ' ', vent:0:2);
        end;

        // NY  fixar om det inte finns inglasning
        if (DerobModel.GlazingProperties.BoolValue['GlazingNorth'] <> true) and
          (DerobModel.GlazingProperties.BoolValue['GlazingEast'] <> true) and
          (DerobModel.GlazingProperties.BoolValue['GlazingSouth'] <> true) and
          (DerobModel.GlazingProperties.BoolValue['GlazingWest'] <> true) then
        begin
          WriteLn(T, '   ', '0', ' ', '1', ' ', vent:0:2);
        end;
      end;

      if (Idx = 2) or (Idx = 4) then
      begin
        WriteLn(T, ' ', nventsummer);
        WriteLn(T, '   ', '0', ' ', '1', ' ', summervent:0:2);
        WriteLn(T, '   ', '1', ' ', '0', ' ', summervent:0:2);
      end

      else if Idx = 5 then
      begin
        WriteLn(T, ' ', '2');
        WriteLn(T, '   ', '0', ' ', '1', ' ', vent:0:2);
        WriteLn(T, '   ', '1', ' ', '0', ' ', vent:0:2);
      end;

      if (Idx = 1) or (Idx = 3) then
      begin
        if nvol > 1 then
        begin
          WriteLn(T, '   ', '1', ' ', '0', ' ', vent * (nvol - 1):0:2);
        end
        else
        begin
          WriteLn(T, '   ', '1', ' ', '0', ' ', vent:0:2);
        end;
      end;
    end;
    CloseFile(T);
  end;
end;

end.
