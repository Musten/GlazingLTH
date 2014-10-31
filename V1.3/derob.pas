unit derob;

// ---------------------------------------------------------------------------
// DEROB Data model unit
// ---------------------------------------------------------------------------

interface

uses
  Generics.Collections, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type

  // Exekvering av moduler
  TExecFinishedFunction = procedure of object;
  TExecFunction = procedure of object;

  TExecThread = class(TThread)
  private
    FOnExecuteFinished: TExecFinishedFunction;
    FOnExecute: TExecFunction;

    procedure CallExecute;
    procedure CallExecuteFinished;
  protected
    procedure Execute; override;
  public
    constructor Create;

    property OnExecuteFinished: TExecFinishedFunction read FOnExecuteFinished
      write FOnExecuteFinished;
    property OnExecute: TExecFunction read FOnExecute write FOnExecute;
  end;


  //
  // Base DEROB class
  //
  // Defined the basic functionality available to
  // all derived classes.
  //

  TDerobBase = class
  private
    FName: string;
    FIdx: integer;
    procedure SetName(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToFile(var f: TextFile); virtual;
    procedure ReadFromFile(var f: TextFile); virtual;

    property Name: string read FName write SetName;
    property Idx: integer read FIdx write FIdx;
  end;

  //
  // Derob property class
  //
  // Implements a base class for implementing property/value pairs.
  // The class implements a dictionary like data structure for
  // storing the property value pairs. Loading and saving of
  // properties is also implemented.
  //

  // Anger vilka egenskapstyper som är tillgängliga
  TDerobPropertyType = (ptString, ptDouble, ptInteger, ptBoolean, ptNone);

  TDerobProperties = class(TDerobBase)
  private
    // Namnen på de olika egenskaperna man kan använda
    FProperties: TDictionary<string, TDerobPropertyType>;
    FStringProperties: TDictionary<string, string>;
    FDoubleProperties: TDictionary<string, double>;
    FIntProperties: TDictionary<string, integer>;
    FBoolProperties: TDictionary<string, boolean>;
    FKeys: TDictionary<string, TDerobPropertyType>.TKeyCollection;
    FCount: integer;
    function GetDoubleValue(Name: string): double;
    function GetIntValue(Name: string): integer;
    function GetStringValue(Name: string): string;
    function GetValueType(Name: string): TDerobPropertyType;
    function GetBoolValue(Name: string): boolean;
    procedure SetDoubleValue(Name: string; const Value: double);
    procedure SetIntValue(Name: string; const Value: integer);
    procedure SetStringValue(Name: string; const Value: string);
    procedure SetValueType(Name: string; const Value: TDerobPropertyType);
    procedure SetBoolValue(Name: string; const Value: boolean);
    function GetKeys: TDictionary<string, TDerobPropertyType>.TKeyCollection;
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    // Sparar ner egenskaperna i minnet (OSÄKER)
    procedure Add(Name: string; PropertyType: TDerobPropertyType);
    procedure Remove(Name: string);
    procedure Clear;

    procedure AssignFrom(DerobProperty: TDerobProperties);
    // Funktioner för att spara och ladda de olika egenskaperna som anges i modellen
    procedure SaveToFile(var f: TextFile); override;
    procedure ReadFromFile(var f: TextFile); override;

    property Keys: TDictionary<string, TDerobPropertyType>.TKeyCollection
      read GetKeys;
    property Count: integer read GetCount;

    property ValueType[Name: string]: TDerobPropertyType read GetValueType
      write SetValueType;
    property DoubleValue[Name: string]: double read GetDoubleValue
      write SetDoubleValue;
    property StringValue[Name: string]: string read GetStringValue
      write SetStringValue;
    property IntValue[Name: string]: integer read GetIntValue write SetIntValue;
    property BoolValue[Name: string]: boolean read GetBoolValue
      write SetBoolValue;
  end;

  //
  // Material class
  //
  // Stores material information
  //

  TMaterial = class(TDerobProperties)
  private

  public
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // Construction class
  //
  // Describes a construction consisting of material "Layers"
  //

  TConstruction = class(TDerobProperties)
  private
    // Listor för de olika lagrena och vilket klass/egenskap de tillhör
    FLayers: TList<TMaterial>;
    FLayerIdx: TList<integer>;
    FLayerThickness: TList<double>;
    function GetLayers(Idx: integer): TMaterial;
    function GetLayerThickness(Idx: integer): double;
    procedure SetLayers(Idx: integer; const Value: TMaterial);
    procedure SetLayerThickness(Idx: integer; const Value: double);
    function GetLayerIdx(Idx: integer): integer;
    procedure SetLayerIdx(Idx: integer; const Value: integer);
    function GetLayerCount: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToFile(var f: TextFile); override;
    procedure ReadFromFile(var f: TextFile); override;
    procedure ReConnect(var Materials: TObjectList<TMaterial>);
    // Lägga till/Ta bort materiallager till konstruktionen
    procedure AddLayer(Material: TMaterial; Thickness: double);
    procedure RemoveLayer(Material: TMaterial);

    property Layers[Idx: integer]: TMaterial read GetLayers write SetLayers;
    property LayerThickness[Idx: integer]: double read GetLayerThickness
      write SetLayerThickness;
    property LayerIdx[Idx: integer]: integer read GetLayerIdx write SetLayerIdx;
    property LayerCount: integer read GetLayerCount;
  end;

  //
  // Surface base class
  //
  // Geometric base class for roof, floor and wall classes.
  // Contains generic geometry properties for surfaces.
  //

  TSurface = class(TDerobBase)
  private
    FX: double;
    FY: double;
    FZ: double;
    FWidth: double;
    FHeight: double;
    FLength: double;
    FConstruction: TConstruction;
    FConstructionIdx: integer;

    // Rotationsvariablerna används ej, istället används HouseProperties klassen
    FRotationX: double;
    FRotationY: double;
    FRotationZ: double;

    procedure SetRotationX(const Value: double);
    procedure SetRotationY(const Value: double);
    procedure SetX(const Value: double);
    procedure SetY(const Value: double);
    procedure SetZ(const Value: double);
    procedure SetRotationZ(const Value: double);
    procedure SetHeight(const Value: double);
    procedure SetWidth(const Value: double);
    procedure SetConstruction(const Value: TConstruction);
    procedure SetLength(const Value: double);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToFile(var f: TextFile); override;
    procedure ReadFromFile(var f: TextFile); override;
    procedure ReConnect(var Constructions: TObjectList<TConstruction>);

    property X: double read FX write SetX;
    property Y: double read FY write SetY;
    property Z: double read FZ write SetZ;
    property RotationX: double read FRotationX write SetRotationX;
    property RotationY: double read FRotationY write SetRotationY;
    property RotationZ: double read FRotationZ write SetRotationZ;
    property Width: double read FWidth write SetWidth;
    property Height: double read FHeight write SetHeight;
    property Length: double read FLength write SetLength;
    property Construction: TConstruction read FConstruction
      write SetConstruction;
  end;

  //
  // Floor properties class
  // Skapar Floorproperties klassen som kan använda biblioteket för att spara värden

  TFloorProperties = class(TDerobProperties)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // Floor class
  //

  TFloor = class(TSurface)
  private
    // Kopplar ihop Floorproperties med TFloor klassen.
    FProperties: TFloorProperties;
    procedure SetProperties(const Value: TFloorProperties);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToFile(var f: TextFile); override;
    procedure ReadFromFile(var f: TextFile); override;

    property Properties: TFloorProperties read FProperties write SetProperties;
  end;

  // *NEW*
  // Window properties class
  //

  TWindowProperties = class(TDerobProperties)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // *NEW*
  // Window class
  //

  TWindow = class(TSurface)
  private
    FProperties: TWindowProperties;
    procedure SetProperties(const Value: TWindowProperties);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToFile(var f: TextFile); override;
    procedure ReadFromFile(var f: TextFile); override;

    property Properties: TWindowProperties read FProperties write SetProperties;
  end;

  // *NEW*
  // Glazing Properties class
  //
  TGlazingProperties = class(TDerobProperties)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  // *NEW*
  // Glazing class
  //

  TGlazing = class(TSurface)
  private
    FProperties: TGlazingProperties;
    procedure SetProperties(const Value: TGlazingProperties);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToFile(var f: TextFile); override;
    procedure ReadFromFile(var f: TextFile); override;

    property Properties: TGlazingProperties read FProperties
      write SetProperties;
  end;


  //
  // Wall properties class
  //

  TWallProperties = class(TDerobProperties)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // Wall class
  //

  TWall = class(TSurface)
  private
    FProperties: TWallProperties;
    procedure SetProperties(const Value: TWallProperties);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToFile(var f: TextFile); override;
    procedure ReadFromFile(var f: TextFile); override;

    property Properties: TWallProperties read FProperties write SetProperties;
  end;

  //
  // Roof properties class
  //

  TRoofProperties = class(TDerobProperties)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // Roof class
  //

  TRoof = class(TSurface)
  private
    FProperties: TRoofProperties;
    procedure SetProperties(const Value: TRoofProperties);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveToFile(var f: TextFile); override;
    procedure ReadFromFile(var f: TextFile); override;

    property Properties: TRoofProperties read FProperties write SetProperties;
  end;

  //
  // House properties class
  //

  THouseProperties = class(TDerobProperties)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // Location properties class
  //

  TLocationProperties = class(TDerobProperties)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // Ventilation properties class
  //

  TVentilationProperties = class(TDerobProperties)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // DEROB Model class
  //
  // Class implements the DEROB data model
  //

  TDerobModel = class
  private
    FFilename: string;
    // Listor med de olika objekten
    FWalls: TObjectList<TWall>;
    FFloors: TObjectList<TFloor>;
    FRoofs: TObjectList<TRoof>;
    FWindows: TObjectList<TWindow>;
    FGlazing: TObjectList<TGlazing>;

    FMaterials: TObjectList<TMaterial>;
    FConstructions: TObjectList<TConstruction>;

    // De olika egenskaperna som finns tillgängliga i DerobModel
    FHouseProperties: THouseProperties;
    FVentilationProperties: TVentilationProperties;
    FLocationProperties: TLocationProperties;
    FMaterialCount: integer;
    FConstructionCount: integer;
    FWindowCount: integer;
    FGlazeCount: integer;
    FGlazingCount: integer;

    FWallProperties: TWallProperties;
    FGlazingProperties: TGlazingProperties;
    FSurface: TSurface;
    FWindowProperties: TWindowProperties;

    procedure SetFilename(const Value: string);
    function GetWalls(Idx: integer): TWall;
    procedure SetWalls(Idx: integer; const Value: TWall);
    function GetWallCount: integer;
    function GetFloors(Idx: integer): TFloor;
    function GetRoofs(Idx: integer): TRoof;
    procedure SetFloors(Idx: integer; const Value: TFloor);
    procedure SetRoofs(Idx: integer; const Value: TRoof);
    function GetFloorCount: integer;
    function GetRoofCount: integer;
    procedure SetHouseProperties(const Value: THouseProperties);
    procedure SetLocationProperties(const Value: TLocationProperties);
    procedure SetVentilationProperties(const Value: TVentilationProperties);
    function GetConstructions(Idx: integer): TConstruction;
    function GetMaterials(Idx: integer): TMaterial;
    procedure SetConstructionCount(const Value: integer);
    procedure SetConstructions(Idx: integer; const Value: TConstruction);
    procedure SetMaterialCount(const Value: integer);
    procedure SetMaterials(Idx: integer; const Value: TMaterial);
    function GetConstructionCount: integer;
    function GetMaterialCount: integer;
    function GetWindows(Idx: integer): TWindow;
    procedure SetWindowCount(const Value: integer);
    procedure SetWindows(Idx: integer; const Value: TWindow);
    function GetWindowCount: integer;
    function GetGlazing(Idx: integer): TGlazing;
    procedure SetGlazing(Idx: integer; const Value: TGlazing);
    procedure SetGlazingCount(const Value: integer);
    function GetGlazingCount: integer;
    procedure SetGlazingProperties(const Value: TGlazingProperties);
    procedure SetSurface(const Value: TSurface);
    procedure SetWindowProperties(const Value: TWindowProperties);

  public
    constructor Create;
    destructor Destroy; override;

    // Funktioner för att lägga till och ta bort objekt i DerobModel
    procedure AddWall(Wall: TWall);
    procedure RemoveWall(Wall: TWall); overload;
    procedure RemoveWall(Idx: integer); overload;
    procedure ClearWalls;

    procedure AddRoof(Roof: TRoof);
    procedure RemoveRoof(Roof: TRoof); overload;
    procedure RemoveRoof(Idx: integer); overload;
    procedure ClearRoofs;

    procedure AddFloor(Floor: TFloor);
    procedure RemoveFloor(Floor: TFloor); overload;
    procedure RemoveFloor(Idx: integer); overload;
    procedure ClearFloors;

    procedure AddWindow(Window: TWindow);
    procedure RemoveWindow(Window: TWindow); overload;
    procedure RemoveWindow(Idx: integer); overload;
    procedure ClearWindows;

    procedure AddGlazing(Glazing: TGlazing);
    procedure RemoveGlazing(Glazing: TGlazing); overload;
    procedure RemoveGlazing(Idx: integer); overload;
    procedure ClearGlazing;

    procedure AddMaterial(Material: TMaterial);
    procedure RemoveMaterial(Material: TMaterial); overload;
    procedure RemoveMaterial(Idx: integer); overload;
    procedure ClearMaterials;

    procedure AddConstruction(Construction: TConstruction);
    procedure RemoveConstruction(Construction: TConstruction); overload;
    procedure RemoveConstruction(Idx: integer); overload;
    procedure ClearConstructions;

    // Spara och ladda funktionen i DerobModel
    procedure Save;
    procedure Open;

    // Egenskaper för att använda de olika klasserna och dess objekt
    property Filename: string read FFilename write SetFilename;
    property Walls[Idx: integer]: TWall read GetWalls write SetWalls;
    property WallCount: integer read GetWallCount;
    property Roofs[Idx: integer]: TRoof read GetRoofs write SetRoofs;
    property RoofCount: integer read GetRoofCount;
    property Floors[Idx: integer]: TFloor read GetFloors write SetFloors;
    property FloorCount: integer read GetFloorCount;

    property Windows[Idx: integer]: TWindow read GetWindows write SetWindows;
    property WindowCount: integer read GetWindowCount;

    property Glazing[Idx: integer]: TGlazing read GetGlazing write SetGlazing;
    property GlazingCount: integer read GetGlazingCount;

    property Materials[Idx: integer]: TMaterial read GetMaterials
      write SetMaterials;
    property MaterialCount: integer read GetMaterialCount;
    property Constructions[Idx: integer]: TConstruction read GetConstructions
      write SetConstructions;
    property ConstructionCount: integer read GetConstructionCount;

    property HouseProperties: THouseProperties read FHouseProperties
      write SetHouseProperties;
    property LocationProperties: TLocationProperties read FLocationProperties
      write SetLocationProperties;
    property VentilationProperties: TVentilationProperties
      read FVentilationProperties write SetVentilationProperties;
    property Surface: TSurface read FSurface write SetSurface;
    property GlazingProperties: TGlazingProperties read FGlazingProperties
      write SetGlazingProperties;
    property WindowProperties: TWindowProperties read FWindowProperties
      write SetWindowProperties;
  end;

function ExecProcess(ProgramName: String; WorkDir: string;
  Wait: boolean): integer;

implementation

{ TDerobBase }

constructor TDerobBase.Create;
begin
  inherited;
  FName := '';
end;

destructor TDerobBase.Destroy;
begin

  inherited;
end;

procedure TDerobBase.ReadFromFile(var f: TextFile);
begin
  ReadLn(f, FName);
end;

procedure TDerobBase.SaveToFile(var f: TextFile);
begin
  Writeln(f, FName);
end;

procedure TDerobBase.SetName(const Value: string);
begin
  FName := Value;
end;

{ TDerobProperty }

constructor TDerobProperties.Create;
begin
  inherited;
  // Skapar ett bibliotek som kan läsa olika egenskaper
  FProperties := TDictionary<string, TDerobPropertyType>.Create;
  FStringProperties := TDictionary<string, string>.Create;
  FDoubleProperties := TDictionary<string, double>.Create;
  FIntProperties := TDictionary<string, integer>.Create;
  FBoolProperties := TDictionary<string, boolean>.Create;
end;

destructor TDerobProperties.Destroy;
begin
  FProperties.Free;
  FStringProperties.Free;
  FDoubleProperties.Free;
  FIntProperties.Free;
  FBoolProperties.Free;
  inherited;
end;

procedure TDerobProperties.Add(Name: string; PropertyType: TDerobPropertyType);
begin
  if not FProperties.ContainsKey(Name) then
  begin
    FProperties.Add(Name, PropertyType);
    FStringProperties.Add(Name, '');
    FDoubleProperties.Add(Name, 0.0);
    FIntProperties.Add(Name, 0);
    FBoolProperties.Add(Name, True);
  end;
end;

procedure TDerobProperties.Remove(Name: string);
begin
  if FProperties.ContainsKey(Name) then
  begin
    FProperties.Remove(Name);
    FStringProperties.Remove(Name);
    FIntProperties.Remove(Name);
    FDoubleProperties.Remove(Name);
    FBoolProperties.Remove(Name);
  end;
end;

procedure TDerobProperties.AssignFrom(DerobProperty: TDerobProperties);
var
  Name: string;
begin
  Self.Clear;

  for Name in DerobProperty.Keys do
  begin
    case DerobProperty.ValueType[Name] of
      ptString:
        begin
          Self.StringValue[Name] := DerobProperty.StringValue[Name];
        end;
      ptDouble:
        begin
          Self.DoubleValue[Name] := DerobProperty.DoubleValue[Name];
        end;
      ptInteger:
        begin
          Self.IntValue[Name] := DerobProperty.IntValue[Name];
        end;
      ptBoolean:
        begin
          Self.BoolValue[Name] := DerobProperty.BoolValue[Name];
        end;
    end;
  end;
end;

procedure TDerobProperties.Clear;
begin
  FProperties.Clear;
  FStringProperties.Clear;
  FIntProperties.Clear;
  FDoubleProperties.Clear;
  FBoolProperties.Clear;
end;

procedure TDerobProperties.ReadFromFile(var f: TextFile);
var
  i: integer;
  PropCount: integer;
  Name: string;
  PropType: integer;
  StringVal: string;
  DoubleVal: double;
  IntVal: integer;
  BoolVal: integer;
begin
  inherited ReadFromFile(f);

  Self.Clear;

  ReadLn(f, PropCount);

  for i := 1 to PropCount do
  begin
    ReadLn(f, Name);
    ReadLn(f, PropType);
    // Kontroll av vilken typ av property som läses in
    // 0 för strängar, 1 för flyttal, 2 för heltal, 3 för boolesk
    case PropType of
      0:
        begin
          ReadLn(f, StringVal);
          Self.StringValue[Name] := StringVal;
        end;
      1:
        begin
          ReadLn(f, DoubleVal);
          Self.DoubleValue[Name] := DoubleVal;
        end;
      2:
        begin
          ReadLn(f, IntVal);
          Self.IntValue[Name] := IntVal;
        end;
      3:
        begin
          ReadLn(f, BoolVal);
          if BoolVal = 1 then
            Self.BoolValue[Name] := True
          else
            Self.BoolValue[Name] := false
        end;
    end;
  end;
end;

procedure TDerobProperties.SaveToFile(var f: TextFile);
var
  Name: string;
begin
  inherited SaveToFile(f);

  // Write number of properties to file

  Writeln(f, Self.Count);
  for Name in Self.Keys do
  begin

    // Write property name

    Writeln(f, Name);

    // Write property type and value
    // De olika värdena som skrivs är 0 för sträng, 1 för flyttal, 2 för heltal och 3 för boolesk

    case FProperties[Name] of
      ptString:
        begin
          Writeln(f, 0);
          Writeln(f, FStringProperties[Name]);
        end;
      ptDouble:
        begin
          Writeln(f, 1);
          Writeln(f, FDoubleProperties[Name]);
        end;
      ptInteger:
        begin
          Writeln(f, 2);
          Writeln(f, FIntProperties[Name]);
        end;
      ptBoolean:
        begin
          Writeln(f, 3);
          if FBoolProperties[Name] then
            Writeln(f, 1)
          else
            Writeln(f, 0)
        end;
    end;
  end;
end;

function TDerobProperties.GetBoolValue(Name: string): boolean;
begin
  if FProperties.ContainsKey(Name) then
    Result := FBoolProperties.Items[Name]
  else
    Result := false;
end;

function TDerobProperties.GetCount: integer;
begin
  Result := FProperties.Keys.Count;
end;

function TDerobProperties.GetDoubleValue(Name: string): double;
begin
  if FProperties.ContainsKey(Name) then
    Result := FDoubleProperties.Items[Name]
  else
    Result := 0.0;
end;

function TDerobProperties.GetIntValue(Name: string): integer;
begin
  if FProperties.ContainsKey(Name) then
    Result := FIntProperties.Items[Name]
  else
    Result := 0;
end;

function TDerobProperties.GetKeys: TDictionary<string, TDerobPropertyType>.
  TKeyCollection;
begin
  Result := Self.FProperties.Keys;
end;

function TDerobProperties.GetStringValue(Name: string): string;
begin
  if FProperties.ContainsKey(Name) then
    Result := FStringProperties.Items[Name]
  else
    Result := '';
end;

function TDerobProperties.GetValueType(Name: string): TDerobPropertyType;
begin
  if FProperties.ContainsKey(Name) then
    Result := FProperties.Items[Name]
  else
    Result := ptNone;
end;

procedure TDerobProperties.SetBoolValue(Name: string; const Value: boolean);
begin
  if FProperties.ContainsKey(Name) then
  begin
    FBoolProperties.Items[Name] := Value;
  end
  else
  begin
    Add(Name, ptBoolean);
    FBoolProperties.Items[Name] := Value;
  end;
end;

procedure TDerobProperties.SetDoubleValue(Name: string; const Value: double);
begin
  if FProperties.ContainsKey(Name) then
  begin
    FDoubleProperties.Items[Name] := Value;
  end
  else
  begin
    Add(Name, ptDouble);
    FDoubleProperties.Items[Name] := Value;
  end;
end;

procedure TDerobProperties.SetIntValue(Name: string; const Value: integer);
begin
  if FProperties.ContainsKey(Name) then
  begin
    FIntProperties.Items[Name] := Value;
  end
  else
  begin
    Add(Name, ptInteger);
    FIntProperties.Items[Name] := Value;
  end;
end;

procedure TDerobProperties.SetStringValue(Name: string; const Value: string);
begin
  if FProperties.ContainsKey(Name) then
  begin
    FStringProperties.Items[Name] := Value;
  end
  else
  begin
    Add(Name, ptString);
    FStringProperties.Items[Name] := Value;
  end;

end;

procedure TDerobProperties.SetValueType(Name: string;
  const Value: TDerobPropertyType);
begin
  if FProperties.ContainsKey(Name) then
  begin
    FProperties.Items[Name] := Value;
  end
  else
  begin
    Add(Name, Value);
  end;
end;

{ TConstruction }

procedure TConstruction.AddLayer(Material: TMaterial; Thickness: double);
begin
  // Lägg till materialet som ett lager i konstruktionen
  FLayers.Add(Material);
  // Lägg till materialets tjocklek i konstruktionen
  FLayerThickness.Add(Thickness);
  // Lägg materialet sist i konstruktionen OSÄKER
  FLayerIdx.Add(-1);
end;

// Skapa objektet för konstruktionen
constructor TConstruction.Create;
begin
  inherited;
  FLayers := TList<TMaterial>.Create;
  FLayerThickness := TList<double>.Create;
  FLayerIdx := TList<integer>.Create;
  StringValue['ConstructionType'] := 'Generic';
end;

destructor TConstruction.Destroy;
begin
  FLayers.Free;
  FLayerThickness.Free;
  FLayerIdx.Free;
  inherited;
end;

function TConstruction.GetLayerCount: integer;
begin
  Result := FLayers.Count;
end;

function TConstruction.GetLayerIdx(Idx: integer): integer;
begin
  if (Idx >= 0) and (Idx < FLayerIdx.Count) then
    Result := FLayerIdx[Idx]
  else
    Result := -1;
end;

function TConstruction.GetLayers(Idx: integer): TMaterial;
begin
  if (Idx >= 0) and (Idx < FLayers.Count) then
    Result := FLayers[Idx]
  else
    Result := nil;
end;

function TConstruction.GetLayerThickness(Idx: integer): double;
begin
  if (Idx >= 0) and (Idx < FLayerThickness.Count) then
    Result := FLayerThickness[Idx]
  else
    Result := 0.0;
end;

procedure TConstruction.ReadFromFile(var f: TextFile);
var
  i: integer;
  ItemCount: integer;
  Value: integer;
  Thickness: double;
begin
  inherited ReadFromFile(f);
  FLayerIdx.Clear;
  FLayerThickness.Clear;
  ReadLn(f, ItemCount);
  for i := 0 to ItemCount - 1 do
  begin
    ReadLn(f, Value, Thickness);
    FLayerIdx.Add(Value);
    FLayerThickness.Add(Thickness);
  end;
end;

procedure TConstruction.ReConnect(var Materials: TObjectList<TMaterial>);
var
  i: integer;
begin
  FLayers.Clear;
  for i := 0 to FLayerIdx.Count - 1 do
    FLayers.Add(Materials[FLayerIdx[i]]);
end;

procedure TConstruction.RemoveLayer(Material: TMaterial);
var
  Idx: integer;
begin
  Idx := FLayers.IndexOf(Material);
  FLayers.Delete(Idx);
  FLayerThickness.Delete(Idx);
  FLayerIdx.Delete(Idx);
end;

procedure TConstruction.SaveToFile(var f: TextFile);
var
  i: integer;
begin
  inherited SaveToFile(f);
  Writeln(f, FLayers.Count);
  for i := 0 to FLayers.Count - 1 do
    Writeln(f, FLayers[i].Idx, FLayerThickness[i]);
end;

procedure TConstruction.SetLayerIdx(Idx: integer; const Value: integer);
begin
  if (Idx >= 0) and (Idx < FLayerIdx.Count) then
    FLayerIdx[Idx] := Value;
end;

procedure TConstruction.SetLayers(Idx: integer; const Value: TMaterial);
begin
  if (Idx >= 0) and (Idx < FLayers.Count) then
    FLayers[Idx] := Value;
end;

procedure TConstruction.SetLayerThickness(Idx: integer; const Value: double);
begin
  if (Idx >= 0) and (Idx < FLayerThickness.Count) then
    FLayerThickness[Idx] := Value;
end;

{ TMaterial }

constructor TMaterial.Create;
begin
  inherited;

  // Initierar egenskaperna för materialet

  DoubleValue['Density'] := 1.0;
  DoubleValue['Lambda'] := 1.0;
  DoubleValue['HeatCapacity'] := 1.0;
end;

destructor TMaterial.Destroy;
begin

  inherited;
end;

{ TSurface }

constructor TSurface.Create;
begin
  inherited;
  FConstruction := nil;
  FX := 0;
  FY := 0;
  FZ := 0;
  FRotationX := 0;
  FRotationY := 0;
  FRotationZ := 0;
end;

destructor TSurface.Destroy;
begin

  inherited;
end;

procedure TSurface.ReadFromFile(var f: TextFile);
begin
  inherited ReadFromFile(f);
  ReadLn(f, FX, FY, FZ);
  ReadLn(f, FRotationX, FRotationY, FRotationZ);
  ReadLn(f, FLength, FWidth, FHeight); // Ändrat
  // ReadLn(f, FConstructionIdx);                        Ändrat
end;

procedure TSurface.ReConnect(var Constructions: TObjectList<TConstruction>);
begin
  FConstruction := Constructions[FConstructionIdx];
end;

procedure TSurface.SaveToFile(var f: TextFile);
begin
  inherited SaveToFile(f);
  // Sparar ner X,Y,Z-värden för ytan
  Writeln(f, FX, FY, FZ);
  // Sparar ner rotationen för ytan (Används ej)
  Writeln(f, FRotationX, FRotationY, FRotationZ);
  // Sparar ner längd bredd och höjd för ytan
  Writeln(f, FLength, FWidth, FHeight);
  // WriteLn(f, FConstruction.Idx);    Används ej och skapar problem
end;

procedure TSurface.SetConstruction(const Value: TConstruction);
begin
  FConstruction := Value;
end;

procedure TSurface.SetHeight(const Value: double);
begin
  FHeight := Value;
end;

procedure TSurface.SetLength(const Value: double);
begin
  FLength := Value;
end;

procedure TSurface.SetRotationX(const Value: double);
begin
  FRotationX := Value;
end;

procedure TSurface.SetRotationY(const Value: double);
begin
  FRotationY := Value;
end;

procedure TSurface.SetRotationZ(const Value: double);
begin
  Self.FRotationZ := Value;
end;

procedure TSurface.SetWidth(const Value: double);
begin
  FWidth := Value;
end;

procedure TSurface.SetX(const Value: double);
begin
  FX := Value;
end;

procedure TSurface.SetY(const Value: double);
begin
  FY := Value;
end;

procedure TSurface.SetZ(const Value: double);
begin
  FZ := Value;
end;

{ TWallProperty }

constructor TWallProperties.Create;
begin
  inherited;

  // Tillsätter värden på de olika egenskaperna för väggen

  Self.DoubleValue['Thickness'] := 0.2;
  Self.DoubleValue['Length'] := 1.0;
  Self.DoubleValue['Height'] := 1.0;
  Self.BoolValue['Hole'] := false;
  Self.IntValue['Zenith'] := 0;
  Self.IntValue['Azimuth'] := 0;
end;

destructor TWallProperties.Destroy;
begin

  inherited;
end;

{ TWall }

constructor TWall.Create;
begin
  inherited;

  // Initiera namn och egenskaperna för väggarna

  Self.Name := 'Wall';
  FProperties := TWallProperties.Create;
end;

destructor TWall.Destroy;
begin

  // Rensa minnet på egenskaperna för väggen

  FProperties.Destroy;
  inherited;
end;

procedure TWall.ReadFromFile(var f: TextFile);
begin
  inherited ReadFromFile(f);
  FProperties.ReadFromFile(f);
end;

procedure TWall.SaveToFile(var f: TextFile);
begin
  inherited SaveToFile(f);
  FProperties.SaveToFile(f);
end;

procedure TWall.SetProperties(const Value: TWallProperties);
begin

end;

{ TFloorProperty }

constructor TFloorProperties.Create;
begin
  inherited;

  // ACTION : Add floor properties here with default values

  DoubleValue['Thickness'] := 0.2;
  DoubleValue['Length'] := 1.0;
  DoubleValue['Width'] := 1.0;
  IntValue['Zenith'] := 180;
  IntValue['Azimuth'] := 0;
end;

destructor TFloorProperties.Destroy;
begin

  inherited;
end;

{ TFloor }

constructor TFloor.Create;
begin
  inherited;
  Name := 'Floor';
  FProperties := TFloorProperties.Create;
end;

destructor TFloor.Destroy;
begin
  FProperties.Free;
  inherited;
end;

procedure TFloor.ReadFromFile(var f: TextFile);
begin
  inherited ReadFromFile(f);
  FProperties.ReadFromFile(f);
end;

procedure TFloor.SaveToFile(var f: TextFile);
begin
  inherited SaveToFile(f);
  FProperties.SaveToFile(f);
end;

procedure TFloor.SetProperties(const Value: TFloorProperties);
begin
  FProperties := Value;
end;

{ TRoofProperty }

constructor TRoofProperties.Create;
begin
  inherited;

  // ACTION : Add roof properties here with default values

  DoubleValue['Thickness'] := 0.2;
  DoubleValue['Length'] := 1.0;
  DoubleValue['Width'] := 1.0;
  IntValue['Zenith'] := 0;
  IntValue['Azimuth'] := 0;
end;

destructor TRoofProperties.Destroy;
begin

  inherited;
end;

{ TRoof }

constructor TRoof.Create;
begin
  inherited;
  Name := 'Roof';
  FProperties := TRoofProperties.Create;
end;

destructor TRoof.Destroy;
begin
  FProperties.Free;
  inherited;
end;

procedure TRoof.ReadFromFile(var f: TextFile);
begin
  inherited ReadFromFile(f);
  FProperties.ReadFromFile(f);
end;

procedure TRoof.SaveToFile(var f: TextFile);
begin
  inherited SaveToFile(f);
  FProperties.SaveToFile(f);
end;

procedure TRoof.SetProperties(const Value: TRoofProperties);
begin
  FProperties := Value;
end;

{ THouseProperties }

constructor THouseProperties.Create;
begin
  inherited;

  // ACTION : Add house properties here with default values

  StringValue['Description'] := 'Huset Huset';
end;

destructor THouseProperties.Destroy;
begin

  inherited;
end;

{ TLocationProperties }

constructor TLocationProperties.Create;
begin
  inherited;

  // ACTION : Add house properties here with default values

end;

destructor TLocationProperties.Destroy;
begin

  inherited;
end;

{ TVentilationProperties }

constructor TVentilationProperties.Create;
begin
  inherited;

  // ACTION : Add house properties here with default values

end;

destructor TVentilationProperties.Destroy;
begin

  inherited;
end;

{ TDerobModel }

constructor TDerobModel.Create;
begin
  inherited;
  FFilename := 'Noname.dat';
  FWalls := TObjectList<TWall>.Create;
  FRoofs := TObjectList<TRoof>.Create;
  FFloors := TObjectList<TFloor>.Create;
  FWindows := TObjectList<TWindow>.Create;
  FGlazing := TObjectList<TGlazing>.Create;

  FConstructions := TObjectList<TConstruction>.Create;
  FMaterials := TObjectList<TMaterial>.Create;

  // Sets ownership of objects to FWalls
  // FWalls.Free -> destroys contained objects.

  FWalls.OwnsObjects := True;
  FRoofs.OwnsObjects := True;
  FFloors.OwnsObjects := True;
  FWindows.OwnsObjects := True;
  FGlazing.OwnsObjects := True;

  // Create global model properties
  FSurface := TSurface.Create;
  FHouseProperties := THouseProperties.Create;
  FLocationProperties := TLocationProperties.Create;
  FVentilationProperties := TVentilationProperties.Create;
  FGlazingProperties := TGlazingProperties.Create;
  FWindowProperties := TWindowProperties.Create;

  // TODO: Create walls

  FWalls.Add(TWall.Create);
  FWalls.Add(TWall.Create);
  FWalls.Add(TWall.Create);
  FWalls.Add(TWall.Create);

  // TODO: Floor and roof.

  FFloors.Add(TFloor.Create);
  FRoofs.Add(TRoof.Create);
  // Create Windows *NEW*

  FWindows.Add(TWindow.Create);
  FWindows.Add(TWindow.Create);
  FWindows.Add(TWindow.Create);
  FWindows.Add(TWindow.Create);

  { I ordningen: Nord - Öst - Syd - Väst
    Stora Ytan, Lilla yta 1 (Högra ytan sett framifrån),
    Lilla yta 2,  Takyta,  Golvyta }

end;

destructor TDerobModel.Destroy;
begin

  // Make sure created walls are deallocated.

  FLocationProperties.Free;
  FVentilationProperties.Free;
  FHouseProperties.Free;
  FWalls.Free;
  FRoofs.Free;
  FFloors.Free;
  FMaterials.Free;
  FConstructions.Free;
  inherited;
end;

procedure TDerobModel.AddConstruction(Construction: TConstruction);
begin
  FConstructions.Add(Construction);
end;

procedure TDerobModel.AddFloor(Floor: TFloor);
begin
  FFloors.Add(Floor);
end;

procedure TDerobModel.AddGlazing(Glazing: TGlazing);
begin
  FGlazing.Add(Glazing);
end;

procedure TDerobModel.AddMaterial(Material: TMaterial);
begin
  FMaterials.Add(Material);
end;

procedure TDerobModel.AddRoof(Roof: TRoof);
begin
  FRoofs.Add(Roof);
end;

procedure TDerobModel.AddWall(Wall: TWall);
begin
  FWalls.Add(Wall);
end;

procedure TDerobModel.AddWindow(Window: TWindow);
begin
  FWindows.Add(Window);
end;

procedure TDerobModel.ClearConstructions;
begin
  FConstructions.Clear;
end;

procedure TDerobModel.ClearFloors;
begin
  FFloors.Clear;
end;

procedure TDerobModel.ClearGlazing;
begin
  FGlazing.Clear;
end;

procedure TDerobModel.ClearMaterials;
begin
  FMaterials.Clear;
end;

procedure TDerobModel.ClearRoofs;
begin
  FRoofs.Clear;
end;

procedure TDerobModel.ClearWalls;
begin
  FWalls.Clear;
end;

procedure TDerobModel.ClearWindows;
begin
  FWindows.Clear;
end;

function TDerobModel.GetWallCount: integer;
begin
  Result := FWalls.Count;
end;

function TDerobModel.GetWalls(Idx: integer): TWall;
begin

  // Make sure idx is in a valid range,
  // return nil otherwise.

  if (Idx >= 0) and (Idx < FWalls.Count) then
    Result := FWalls[Idx]
  else
    Result := nil;
end;

function TDerobModel.GetWindowCount: integer;
begin
  Result := FWindows.Count;
end;

function TDerobModel.GetWindows(Idx: integer): TWindow;
begin
  if (Idx >= 0) and (Idx < FWindows.Count) then
    Result := FWindows[Idx]
  else
    Result := nil;
end;

procedure TDerobModel.RemoveWall(Wall: TWall);
begin

  // Here we use the TList built-in function remove

  FWalls.Remove(Wall);
end;

procedure TDerobModel.RemoveFloor(Floor: TFloor);
begin
  FFloors.Remove(Floor);
end;

procedure TDerobModel.RemoveConstruction(Idx: integer);
begin
  FConstructions.Delete(Idx);
end;

procedure TDerobModel.RemoveConstruction(Construction: TConstruction);
begin
  FConstructions.Remove(Construction);
end;

procedure TDerobModel.RemoveFloor(Idx: integer);
begin
  FFloors.Delete(Idx);
end;

procedure TDerobModel.RemoveGlazing(Idx: integer);
begin
  FGlazing.Delete(Idx);
end;

procedure TDerobModel.RemoveGlazing(Glazing: TGlazing);
begin
  FGlazing.Remove(Glazing);
end;

procedure TDerobModel.RemoveMaterial(Material: TMaterial);
begin
  FMaterials.Remove(Material);
end;

procedure TDerobModel.RemoveMaterial(Idx: integer);
begin
  FMaterials.Delete(Idx);
end;

procedure TDerobModel.RemoveRoof(Idx: integer);
begin
  FRoofs.Delete(Idx);
end;

procedure TDerobModel.RemoveRoof(Roof: TRoof);
begin
  FRoofs.Remove(Roof);
end;

procedure TDerobModel.RemoveWall(Idx: integer);
begin

  // Her we use the TList built-in function delete.

  FWalls.Delete(Idx);
end;

procedure TDerobModel.RemoveWindow(Window: TWindow);
begin
  FWindows.Remove(Window);
end;

procedure TDerobModel.RemoveWindow(Idx: integer);
begin
  FWindows.Delete(Idx);
end;

procedure TDerobModel.Save;
var
  f: TextFile;
  Wall: TWall;
  Roof: TRoof;
  Floor: TFloor;
  Material: TMaterial;
  Construction: TConstruction;
  Window: TWindow; // Ändrat
  Glaze: TGlazing; // Ändrat
  i: integer;
begin

  // Save derob model to file

  AssignFile(f, FFilename);
  Rewrite(f);

  i := 0;

  Writeln(f, FMaterials.Count);
  for Material in FMaterials do
  begin
    Material.Idx := i;
    Material.SaveToFile(f);
    inc(i);
  end;

  i := 0;

  Writeln(f, FConstructions.Count);
  for Construction in FConstructions do
  begin
    Construction.Idx := i;
    Construction.SaveToFile(f);
  end;
  if HouseProperties.BoolValue['ConstructionLib'] = false then
  begin
    Writeln(f, FWalls.Count);
    for Wall in FWalls do
      Wall.SaveToFile(f);

    Writeln(f, FRoofs.Count);
    for Roof in FRoofs do
      Roof.SaveToFile(f);

    Writeln(f, FFloors.Count);
    for Floor in FFloors do
      Floor.SaveToFile(f);

    { Ändrat }
    Writeln(f, FWindows.Count);
    for Window in FWindows do
      Window.SaveToFile(f);

    { Ändrat }
    Writeln(f, FGlazing.Count);
    for Glaze in FGlazing do
      Glaze.SaveToFile(f);

    FSurface.SaveToFile(f);
    FHouseProperties.SaveToFile(f);
    FLocationProperties.SaveToFile(f);
    FVentilationProperties.SaveToFile(f);

    FGlazingProperties.SaveToFile(f); // Ändrat
  end;

  CloseFile(f);
end;

procedure TDerobModel.Open;
var
  f: TextFile;
  DerobModel: TDerobModel;
  Wall: TWall;
  Roof: TRoof;
  Floor: TFloor;
  Material: TMaterial;
  Construction: TConstruction;
  Window: TWindow; // Ändrat
  Glaze: TGlazing; // Ändrat
  ItemCount: integer;
  i: integer;
begin

  // Read derob model from file

  AssignFile(f, FFilename);
  Reset(f);
  if HouseProperties.BoolValue['ConstructionLib'] = false then
  begin
    Self.ClearWalls;
    Self.ClearRoofs;
    Self.ClearFloors;
    Self.ClearWindows;
    Self.ClearGlazing;
  end;
  Self.ClearMaterials;
  Self.ClearConstructions;

  ReadLn(f, ItemCount);
  for i := 1 to ItemCount do
  begin
    Material := TMaterial.Create;
    Material.ReadFromFile(f);
    Self.AddMaterial(Material);
  end;

  ReadLn(f, ItemCount);
  for i := 1 to ItemCount do
  begin
    Construction := TConstruction.Create;
    Construction.ReadFromFile(f);
    AddConstruction(Construction);
    Construction.ReConnect(FMaterials);
  end;
  if HouseProperties.BoolValue['ConstructionLib'] = false then
  begin
    ReadLn(f, ItemCount);
    for i := 1 to ItemCount do
    begin
      Wall := TWall.Create;
      Wall.ReadFromFile(f);
      AddWall(Wall);
      // Wall.ReConnect(FConstructions);  Senare
    end;

    ReadLn(f, ItemCount);
    for i := 1 to ItemCount do
    begin
      Roof := TRoof.Create;
      Roof.ReadFromFile(f);
      AddRoof(Roof);
      // Roof.ReConnect(FConstructions);           Senare
    end;

    ReadLn(f, ItemCount);
    for i := 1 to ItemCount do
    begin
      Floor := TFloor.Create;
      Floor.ReadFromFile(f);
      AddFloor(Floor);
      // Floor.ReConnect(FConstructions);       Senare
    end;

    { Ändrat }
    ReadLn(f, ItemCount);
    for i := 1 to ItemCount do
    begin
      Window := TWindow.Create;
      Window.ReadFromFile(f);
      AddWindow(Window);
    end;

    { Ändrat }
    ReadLn(f, ItemCount);
    for i := 1 to ItemCount do
    begin
      Glaze := TGlazing.Create;
      Glaze.ReadFromFile(f);
      AddGlazing(Glaze);
    end;
    Self.Surface.ReadFromFile(f);
    Self.HouseProperties.ReadFromFile(f);
    Self.LocationProperties.ReadFromFile(f);
    Self.VentilationProperties.ReadFromFile(f);
    Self.GlazingProperties.ReadFromFile(f);
  end;

  CloseFile(f);
end;

procedure TDerobModel.SetConstructionCount(const Value: integer);
begin
  FConstructionCount := Value;
end;

procedure TDerobModel.SetConstructions(Idx: integer;
  const Value: TConstruction);
begin

end;

procedure TDerobModel.SetFilename(const Value: string);
begin
  FFilename := Value;
end;

function TDerobModel.GetConstructionCount: integer;
begin
  Result := FConstructions.Count;
end;

function TDerobModel.GetConstructions(Idx: integer): TConstruction;
begin
  if (Idx >= 0) and (Idx < FConstructions.Count) then
    Result := FConstructions[Idx]
  else
    Result := nil;
end;

function TDerobModel.GetFloorCount: integer;
begin
  Result := FFloors.Count;
end;

function TDerobModel.GetFloors(Idx: integer): TFloor;
begin
  if (Idx >= 0) and (Idx < FFloors.Count) then
    Result := FFloors[Idx]
  else
    Result := nil;
end;

function TDerobModel.GetGlazing(Idx: integer): TGlazing;
begin
  if (Idx >= 0) and (Idx < FGlazing.Count) then
    Result := FGlazing[Idx]
  else
    Result := nil;
end;

function TDerobModel.GetGlazingCount: integer;
begin
  Result := FGlazing.Count;
end;

function TDerobModel.GetMaterialCount: integer;
begin
  Result := FMaterials.Count;
end;

function TDerobModel.GetMaterials(Idx: integer): TMaterial;
begin
  if (Idx >= 0) and (Idx < FMaterials.Count) then
    Result := FMaterials[Idx]
  else
    Result := nil;
end;

function TDerobModel.GetRoofCount: integer;
begin
  Result := FRoofs.Count;
end;

function TDerobModel.GetRoofs(Idx: integer): TRoof;
begin
  if (Idx >= 0) and (Idx < FRoofs.Count) then
    Result := FRoofs[Idx]
  else
    Result := nil;
end;

procedure TDerobModel.SetFloors(Idx: integer; const Value: TFloor);
begin

end;

procedure TDerobModel.SetGlazing(Idx: integer; const Value: TGlazing);
begin

end;

procedure TDerobModel.SetGlazingCount(const Value: integer);
begin
  FGlazingCount := Value;
end;

procedure TDerobModel.SetGlazingProperties(const Value: TGlazingProperties);
begin
  FGlazingProperties := Value;
end;

procedure TDerobModel.SetHouseProperties(const Value: THouseProperties);
begin
  FHouseProperties := Value;
end;

procedure TDerobModel.SetLocationProperties(const Value: TLocationProperties);
begin
  FLocationProperties := Value;
end;

procedure TDerobModel.SetMaterialCount(const Value: integer);
begin
  FMaterialCount := Value;
end;

procedure TDerobModel.SetMaterials(Idx: integer; const Value: TMaterial);
begin

end;

procedure TDerobModel.SetRoofs(Idx: integer; const Value: TRoof);
begin

end;

procedure TDerobModel.SetSurface(const Value: TSurface);
begin
  FSurface := Value;
end;

procedure TDerobModel.SetVentilationProperties(const Value
  : TVentilationProperties);
begin
  FVentilationProperties := Value;
end;

procedure TDerobModel.SetWalls(Idx: integer; const Value: TWall);
begin
  // TODO: Implement DerobModel.Walls[n]:=Wall
end;

procedure TDerobModel.SetWindowCount(const Value: integer);
begin
  FWindowCount := Value;
end;

procedure TDerobModel.SetWindowProperties(const Value: TWindowProperties);
begin
  FWindowProperties := Value;
end;

procedure TDerobModel.SetWindows(Idx: integer; const Value: TWindow);
begin

end;

{ TWindow }

constructor TWindow.Create;
begin
  inherited;
  Name := 'Window';
  FProperties := TWindowProperties.Create;
end;

destructor TWindow.Destroy;
begin

  inherited;
end;

procedure TWindow.ReadFromFile(var f: TextFile);
begin
  inherited ReadFromFile(f);
  FProperties.ReadFromFile(f);
end;

procedure TWindow.SaveToFile(var f: TextFile);
begin
  inherited SaveToFile(f);
  FProperties.SaveToFile(f);
end;

procedure TWindow.SetProperties(const Value: TWindowProperties);
begin
  FProperties := Value;
end;

{ TWindowProperties }

constructor TWindowProperties.Create;
begin
  inherited;

  DoubleValue['Thickness'] := 0.2;
  DoubleValue['Length'] := 1.0;
  DoubleValue['Height'] := 1.0;
  BoolValue['Hole'] := false;
  IntValue['Zenith'] := 0;
  IntValue['Azimuth'] := 0;
end;

destructor TWindowProperties.Destroy;
begin

  inherited;
end;

{ TGlazingProperties }

constructor TGlazingProperties.Create;
begin
  inherited;
end;

destructor TGlazingProperties.Destroy;
begin

  inherited;
end;

{ TGlazing }

constructor TGlazing.Create;
begin
  inherited;
  Name := 'Glazing';
  FProperties := TGlazingProperties.Create;
end;

destructor TGlazing.Destroy;
begin

  inherited;
end;

procedure TGlazing.ReadFromFile(var f: TextFile);
begin
  inherited ReadFromFile(f);
  FProperties.ReadFromFile(f);
end;

procedure TGlazing.SaveToFile(var f: TextFile);
begin
  inherited SaveToFile(f);
  FProperties.SaveToFile(f);

end;

procedure TGlazing.SetProperties(const Value: TGlazingProperties);
begin
end;

{ TExecThread }

procedure TExecThread.CallExecute;
begin
  if assigned(Self.FOnExecute) then
    FOnExecute;
end;

procedure TExecThread.CallExecuteFinished;
begin
  if assigned(Self.FOnExecuteFinished) then
    FOnExecuteFinished;
end;

constructor TExecThread.Create;
begin
  inherited Create(True);
  Self.FOnExecuteFinished := nil;
  Self.FOnExecute := nil;
end;

function ExecProcess(ProgramName, WorkDir: string; Wait: boolean): integer;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CreateOK: boolean;
  ExitCode: integer;
  dwExitCode: DWORD;
begin
  ExitCode := -1;

  FillChar(StartInfo, SizeOf(TStartupInfo), #0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), #0);
  StartInfo.cb := SizeOf(TStartupInfo);

  if WorkDir <> '' then
  begin
    CreateOK := CreateProcess(nil, Addr(ProgramName[1]), nil, Addr(WorkDir[1]),
      false, CREATE_NEW_PROCESS_GROUP + NORMAL_PRIORITY_CLASS, nil, nil,
      StartInfo, ProcInfo);
  end
  else
  begin
    CreateOK := CreateProcess(nil, Addr(ProgramName[1]), nil, nil, false,
      CREATE_NEW_PROCESS_GROUP + NORMAL_PRIORITY_CLASS, nil, Addr(WorkDir[1]),
      StartInfo, ProcInfo);
  end;

  { check to see if successful }

  if CreateOK then
  begin
    // may or may not be needed. Usually wait for child processes
    if Wait then
    begin
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
      GetExitCodeProcess(ProcInfo.hProcess, dwExitCode);
      ExitCode := dwExitCode;
    end;
  end
  else
  begin
    ShowMessage('Unable to run ' + ProgramName);
  end;

  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);

  Result := ExitCode;

end;

procedure TExecThread.Execute;
begin
  inherited;
  CallExecute;
  Self.Synchronize(CallExecuteFinished);

end;

end.
