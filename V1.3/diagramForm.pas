unit diagramForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Engine, FMXTee.Procs, FMXTee.Chart, derob, FMXTee.Series, Math;

type
  TForm5 = class(TForm)
    Chart1: TChart;
    GlazeDiagramButton: TButton;
    TempRadioButton: TRadioButton;
    HeatRadioButton: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Series2: TLineSeries;
    Series1: TLineSeries;
    procedure GlazeDiagramButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDerobModel: TDerobModel;
    procedure SetDerobModel(const Value: TDerobModel);
    procedure GlazeHistogram;
    procedure NoGlazeChart;
    procedure NoGlazeHistogram;
    { Private declarations }
  public
    { Public declarations }
    property DerobModel: TDerobModel read FDerobModel write SetDerobModel;
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Chart1.Series[0].Clear;
  Chart1.Series[1].Clear;
  Label2.Text := '';
  Label4.Text := '';
  HeatRadioButton.IsChecked := False;
  TempRadioButton.IsChecked := False;
  Chart1.LeftAxis.Title.Caption:='';
  Chart1.BottomAxis.Title.Caption:='';
end;

procedure TForm5.GlazeDiagramButtonClick(Sender: TObject);
begin
  GlazeHistogram;
  NoGlazeHistogram;
  Chart1.BottomAxis.Increment := 1;
end;

procedure TForm5.GlazeHistogram;
var
  Summer, Winter, NoGlaze: TextFile;
  DataFile: TStringList;
  VolPath: String;
  buffer: String;
  OutTempSummer, GlobalRadiationSummer, Temp1Summer, OpTemp1Summer, Heat1Summer,
    Cool1Summer, Sun1Summer, Temp2Summer, OpTemp2Summer, Heat2Summer,
    Cool2Summer, Sun2Summer, Temp3Summer, OpTemp3Summer, Heat3Summer,
    Cool3Summer, Sun3Summer, Temp4Summer, OpTemp4Summer, Heat4Summer,
    Cool4Summer, Sun4Summer, Temp5Summer, OpTemp5Summer, Heat5Summer,
    Cool5Summer, Sun5Summer: array of Real;
  OutTempWinter, GlobalRadiationWinter, Temp1Winter, OpTemp1Winter, Heat1Winter,
    Cool1Winter, Sun1Winter, Temp2Winter, OpTemp2Winter, Heat2Winter,
    Cool2Winter, Sun2Winter, Temp3Winter, OpTemp3Winter, Heat3Winter,
    Cool3Winter, Sun3Winter, Temp4Winter, OpTemp4Winter, Heat4Winter,
    Cool4Winter, Sun4Winter, Temp5Winter, OpTemp5Winter, Heat5Winter,
    Cool5Winter, Sun5Winter: array of Real;
  i, SkipLine, intervall: integer;
  IgnoreText: Boolean;

  TempAprSummer, TempAprWinter, TempJunSummer, TempJunWinter, TempSepWinter,
    TempSepSummer, TempNovWinter, TempNovSummer: array of Real;

  HeatJanSummer, HeatMarSummer, HeatJanWinter, HeatMarWinter, HeatMaySummer,
    HeatMayWinter, HeatJulSummer, HeatJulWinter, HeatAugWinter, HeatAugSummer,
    HeatOctSummer, HeatOctWinter, HeatDecSummer, HeatDecWinter: array of Real;

  HeatFebSummer, HeatFebWinter: array of Real;

  HeatAprSummer, HeatAprWinter, HeatJunSummer, HeatJunWinter, HeatSepWinter,
    HeatSepSummer, HeatNovWinter, HeatNovSummer: array of Real;
  Temp: Array of double;
  Hour, Time, YearlyTemp, Heat, TempSummer, TempWinter: array of Real;

  meanJan, meanFeb, meanMar, meanApr, meanMay, meanJun, meanJul, meanAug,
    meanSep, meanOct, meanNov, meanDec: Real;

  HeatJan, HeatFeb, HeatMar, HeatApr, HeatMay, HeatJun, HeatJul, HeatAug,
    HeatSep, HeatOct, HeatNov, HeatDec, totalHeat: Real;
  j: integer;
begin
  intervall := (40 - DerobModel.HouseProperties.IntValue['TMinRoom']) * 10;
  SkipLine := 12;
  SetLength(YearlyTemp, 8760);
  SetLength(Hour, 8760);
  SetLength(TempSummer, 8760);
  SetLength(TempWinter, 8760);
  SetLength(OutTempSummer, 8760);
  SetLength(OutTempWinter, 8760);
  SetLength(GlobalRadiationSummer, 8760);
  SetLength(GlobalRadiationWinter, 8760);

  SetLength(Temp1Summer, 8760);
  SetLength(OpTemp1Summer, 8760);
  SetLength(Heat1Summer, 8760);
  SetLength(Cool1Summer, 8760);
  SetLength(Sun1Summer, 8760);

  SetLength(Temp1Winter, 8760);
  SetLength(OpTemp1Winter, 8760);
  SetLength(Heat1Winter, 8760);
  SetLength(Cool1Winter, 8760);
  SetLength(Sun1Winter, 8760);

  SetLength(Temp2Summer, 8760);
  SetLength(OpTemp2Summer, 8760);
  SetLength(Heat2Summer, 8760);
  SetLength(Cool2Summer, 8760);
  SetLength(Sun2Summer, 8760);

  SetLength(Temp2Winter, 8760);
  SetLength(OpTemp2Winter, 8760);
  SetLength(Heat2Winter, 8760);
  SetLength(Cool2Winter, 8760);
  SetLength(Sun2Winter, 8760);

  SetLength(Temp3Summer, 8760);
  SetLength(OpTemp3Summer, 8760);
  SetLength(Heat3Summer, 8760);
  SetLength(Cool3Summer, 8760);
  SetLength(Sun3Summer, 8760);

  SetLength(Temp3Winter, 8760);
  SetLength(OpTemp3Winter, 8760);
  SetLength(Heat3Winter, 8760);
  SetLength(Cool3Winter, 8760);
  SetLength(Sun3Winter, 8760);

  SetLength(Temp4Summer, 8760);
  SetLength(OpTemp4Summer, 8760);
  SetLength(Heat4Summer, 8760);
  SetLength(Cool4Summer, 8760);
  SetLength(Sun4Summer, 8760);

  SetLength(Temp4Winter, 8760);
  SetLength(OpTemp4Winter, 8760);
  SetLength(Heat4Winter, 8760);
  SetLength(Cool4Winter, 8760);
  SetLength(Sun4Winter, 8760);

  SetLength(Temp5Summer, 8760);
  SetLength(OpTemp5Summer, 8760);
  SetLength(Heat5Summer, 8760);
  SetLength(Cool5Summer, 8760);
  SetLength(Sun5Summer, 8760);

  SetLength(Temp5Winter, 8760);
  SetLength(OpTemp5Winter, 8760);
  SetLength(Heat5Winter, 8760);
  SetLength(Cool5Winter, 8760);
  SetLength(Sun5Winter, 8760);

  SetLength(Temp, intervall);
  SetLength(Time, intervall);
  SetLength(Heat, 8760);

  SetLength(HeatJanSummer, 744);
  SetLength(HeatFebSummer, 672);
  SetLength(HeatMarSummer, 744);
  SetLength(HeatAprSummer, 720);
  SetLength(HeatMaySummer, 744);
  SetLength(HeatJunSummer, 720);
  SetLength(HeatJulSummer, 744);
  SetLength(HeatAugSummer, 744);
  SetLength(HeatSepSummer, 720);
  SetLength(HeatOctSummer, 744);
  SetLength(HeatNovSummer, 720);
  SetLength(HeatDecSummer, 744);
  SetLength(HeatJanWinter, 744);
  SetLength(HeatFebWinter, 672);
  SetLength(HeatMarWinter, 744);
  SetLength(HeatAprWinter, 720);
  SetLength(HeatMayWinter, 744);
  SetLength(HeatJunWinter, 720);
  SetLength(HeatJulWinter, 744);
  SetLength(HeatAugWinter, 744);
  SetLength(HeatSepWinter, 720);
  SetLength(HeatOctWinter, 744);
  SetLength(HeatNovWinter, 720);
  SetLength(HeatDecWinter, 744);

  HeatJan := 0;
  HeatFeb := 0;
  HeatMar := 0;
  HeatApr := 0;
  HeatMay := 0;
  HeatJun := 0;
  HeatJul := 0;
  HeatAug := 0;
  HeatSep := 0;
  HeatOct := 0;
  HeatNov := 0;
  HeatDec := 0;

  Temp[0] := DerobModel.HouseProperties.IntValue['TMinRoom'];
  for i := 1 to intervall do
  begin
    Temp[i] := Round(Temp[i - 1] * 10) / 10 + 0.1;
  end;

  IgnoreText := False;
  Chart1.Series[0].Clear;
  SetCurrentDir(DerobModel.HouseProperties.StringValue['StartDir']);
  SetCurrentDir('Cases/');
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  SetCurrentDir('Summer');
  VolPath := GetCurrentDir + '\Vol_Load.txt';
  AssignFile(Summer, VolPath);
  Reset(Summer);
  SetCurrentDir('../Winter');
  VolPath := GetCurrentDir + '\Vol_Load.txt';
  AssignFile(Winter, VolPath);
  Reset(Winter);
  while not Eof(Summer) do
  begin
    // Pass the first 12 lines that describes the variables in the text files
    if IgnoreText = False then
    begin
      for i := 0 to 11 do
      begin
        ReadLn(Summer, buffer);
        ReadLn(Winter, buffer);
      end;
      IgnoreText := true;
    end;
    for i := 12 to 8772 do
    begin
      // Inl�sning av variablerna i Vol_load.txt
      // Beroende p� antalet volymer �r det olika antal kolumner
      // Varf�r man beh�ver flera olika inl�sningsalternativ
      if DerobModel.HouseProperties.IntValue['nvol'] = 1 then
      begin
        ReadLn(Summer, Hour[i - SkipLine], OutTempSummer[i - SkipLine],
          GlobalRadiationSummer[i - SkipLine], Temp1Summer[i - SkipLine],
          OpTemp1Summer[i - SkipLine], Heat1Summer[i - SkipLine],
          Cool1Summer[i - SkipLine], Sun1Summer[i - SkipLine]);
        ReadLn(Winter, Hour[i - SkipLine], OutTempWinter[i - SkipLine],
          GlobalRadiationWinter[i - SkipLine], Temp1Winter[i - SkipLine],
          OpTemp1Winter[i - SkipLine], Heat1Winter[i - SkipLine],
          Cool1Winter[i - SkipLine], Sun1Winter[i - SkipLine]);
      end;
      if DerobModel.HouseProperties.IntValue['nvol'] = 2 then
      begin
        ReadLn(Summer, Hour[i - SkipLine], OutTempSummer[i - SkipLine],
          GlobalRadiationSummer[i - SkipLine], Temp1Summer[i - SkipLine],
          OpTemp1Summer[i - SkipLine], Heat1Summer[i - SkipLine],
          Cool1Summer[i - SkipLine], Sun1Summer[i - SkipLine],
          Temp2Summer[i - SkipLine], OpTemp2Summer[i - SkipLine],
          Heat2Summer[i - SkipLine], Cool2Summer[i - SkipLine],
          Sun2Summer[i - SkipLine]);

        ReadLn(Winter, Hour[i - SkipLine], OutTempWinter[i - SkipLine],
          GlobalRadiationWinter[i - SkipLine], Temp1Winter[i - SkipLine],
          OpTemp1Winter[i - SkipLine], Heat1Winter[i - SkipLine],
          Cool1Winter[i - SkipLine], Sun1Winter[i - SkipLine],
          Temp2Winter[i - SkipLine], OpTemp2Winter[i - SkipLine],
          Heat2Winter[i - SkipLine], Cool2Winter[i - SkipLine],
          Sun2Winter[i - SkipLine]);
      end;
      if DerobModel.HouseProperties.IntValue['nvol'] = 3 then
      begin
        ReadLn(Summer, Hour[i - SkipLine], OutTempSummer[i - SkipLine],
          GlobalRadiationSummer[i - SkipLine], Temp1Summer[i - SkipLine],
          OpTemp1Summer[i - SkipLine], Heat1Summer[i - SkipLine],
          Cool1Summer[i - SkipLine], Sun1Summer[i - SkipLine],
          Temp2Summer[i - SkipLine], OpTemp2Summer[i - SkipLine],
          Heat2Summer[i - SkipLine], Cool2Summer[i - SkipLine],
          Sun2Summer[i - SkipLine], Temp3Summer[i - SkipLine],
          OpTemp3Summer[i - SkipLine], Heat3Summer[i - SkipLine],
          Cool3Summer[i - SkipLine], Sun3Summer[i - SkipLine]);

        ReadLn(Winter, Hour[i - SkipLine], OutTempWinter[i - SkipLine],
          GlobalRadiationWinter[i - SkipLine], Temp1Winter[i - SkipLine],
          OpTemp1Winter[i - SkipLine], Heat1Winter[i - SkipLine],
          Cool1Winter[i - SkipLine], Sun1Winter[i - SkipLine],
          Temp2Winter[i - SkipLine], OpTemp2Winter[i - SkipLine],
          Heat2Winter[i - SkipLine], Cool2Winter[i - SkipLine],
          Sun2Winter[i - SkipLine], Temp3Winter[i - SkipLine],
          OpTemp3Winter[i - SkipLine], Heat3Winter[i - SkipLine],
          Cool3Winter[i - SkipLine], Sun3Winter[i - SkipLine]);
      end;
      if DerobModel.HouseProperties.IntValue['nvol'] = 4 then
      begin
        ReadLn(Summer, Hour[i - SkipLine], OutTempSummer[i - SkipLine],
          GlobalRadiationSummer[i - SkipLine], Temp1Summer[i - SkipLine],
          OpTemp1Summer[i - SkipLine], Heat1Summer[i - SkipLine],
          Cool1Summer[i - SkipLine], Sun1Summer[i - SkipLine],
          Temp2Summer[i - SkipLine], OpTemp2Summer[i - SkipLine],
          Heat2Summer[i - SkipLine], Cool2Summer[i - SkipLine],
          Sun2Summer[i - SkipLine], Temp3Summer[i - SkipLine],
          OpTemp3Summer[i - SkipLine], Heat3Summer[i - SkipLine],
          Cool3Summer[i - SkipLine], Sun3Summer[i - SkipLine],
          Temp4Summer[i - SkipLine], OpTemp4Summer[i - SkipLine],
          Heat4Summer[i - SkipLine], Cool4Summer[i - SkipLine],
          Sun4Summer[i - SkipLine]);

        ReadLn(Winter, Hour[i - SkipLine], OutTempWinter[i - SkipLine],
          GlobalRadiationWinter[i - SkipLine], Temp1Winter[i - SkipLine],
          OpTemp1Winter[i - SkipLine], Heat1Winter[i - SkipLine],
          Cool1Winter[i - SkipLine], Sun1Winter[i - SkipLine],
          Temp2Winter[i - SkipLine], OpTemp2Winter[i - SkipLine],
          Heat2Winter[i - SkipLine], Cool2Winter[i - SkipLine],
          Sun2Winter[i - SkipLine], Temp3Winter[i - SkipLine],
          OpTemp3Winter[i - SkipLine], Heat3Winter[i - SkipLine],
          Cool3Winter[i - SkipLine], Sun3Winter[i - SkipLine],
          Temp4Winter[i - SkipLine], OpTemp4Winter[i - SkipLine],
          Heat4Winter[i - SkipLine], Cool4Winter[i - SkipLine],
          Sun4Winter[i - SkipLine]);
      end;
      if DerobModel.HouseProperties.IntValue['nvol'] = 5 then
      begin
        ReadLn(Summer, Hour[i - SkipLine], OutTempSummer[i - SkipLine],
          GlobalRadiationSummer[i - SkipLine], Temp1Summer[i - SkipLine],
          OpTemp1Summer[i - SkipLine], Heat1Summer[i - SkipLine],
          Cool1Summer[i - SkipLine], Sun1Summer[i - SkipLine],
          Temp2Summer[i - SkipLine], OpTemp2Summer[i - SkipLine],
          Heat2Summer[i - SkipLine], Cool2Summer[i - SkipLine],
          Sun2Summer[i - SkipLine], Temp3Summer[i - SkipLine],
          OpTemp3Summer[i - SkipLine], Heat3Summer[i - SkipLine],
          Cool3Summer[i - SkipLine], Sun3Summer[i - SkipLine],
          Temp4Summer[i - SkipLine], OpTemp4Summer[i - SkipLine],
          Heat4Summer[i - SkipLine], Cool4Summer[i - SkipLine],
          Sun4Summer[i - SkipLine], Temp5Summer[i - SkipLine],
          OpTemp5Summer[i - SkipLine], Heat5Summer[i - SkipLine],
          Cool5Summer[i - SkipLine], Sun5Summer[i - SkipLine]);

        ReadLn(Winter, Hour[i - SkipLine], OutTempWinter[i - SkipLine],
          GlobalRadiationWinter[i - SkipLine], Temp1Winter[i - SkipLine],
          OpTemp1Winter[i - SkipLine], Heat1Winter[i - SkipLine],
          Cool1Winter[i - SkipLine], Sun1Winter[i - SkipLine],
          Temp2Winter[i - SkipLine], OpTemp2Winter[i - SkipLine],
          Heat2Winter[i - SkipLine], Cool2Winter[i - SkipLine],
          Sun2Winter[i - SkipLine], Temp3Winter[i - SkipLine],
          OpTemp3Winter[i - SkipLine], Heat3Winter[i - SkipLine],
          Cool3Winter[i - SkipLine], Sun3Winter[i - SkipLine],
          Temp4Winter[i - SkipLine], OpTemp4Winter[i - SkipLine],
          Heat4Winter[i - SkipLine], Cool4Winter[i - SkipLine],
          Sun4Winter[i - SkipLine], Temp5Winter[i - SkipLine],
          OpTemp5Winter[i - SkipLine], Heat5Winter[i - SkipLine],
          Cool5Winter[i - SkipLine], Sun5Winter[i - SkipLine]);
      end;
      if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = true then
      begin
        if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 2 then
        begin
          TempSummer[i - SkipLine] := Temp2Summer[i - SkipLine];
          TempWinter[i - SkipLine] := Temp2Winter[i - SkipLine];
        end;
        if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 3 then
        begin
          TempSummer[i - SkipLine] := Temp3Summer[i - SkipLine];
          TempWinter[i - SkipLine] := Temp3Winter[i - SkipLine];
        end;
        if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 4 then
        begin
          TempSummer[i - SkipLine] := Temp4Summer[i - SkipLine];
          TempWinter[i - SkipLine] := Temp4Winter[i - SkipLine];
        end;
        if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 5 then
        begin
          TempSummer[i - SkipLine] := Temp5Summer[i - SkipLine];
          TempWinter[i - SkipLine] := Temp5Winter[i - SkipLine];
        end;
      end
      else
      begin
        TempSummer[i - SkipLine] := Temp1Summer[i - SkipLine];
        TempWinter[i - SkipLine] := Temp1Winter[i - SkipLine];
      end;
    end;

  end;
  CloseFile(Summer);
  CloseFile(Winter);
  for i := 0 to 8759 do
  begin
    if TempWinter[i] > DerobModel.HouseProperties.IntValue['TMaxRoom'] then
    begin
      YearlyTemp[i] := TempSummer[i];
      Heat[i] := Heat1Summer[i];
    end
    else
    begin
      YearlyTemp[i] := TempWinter[i];
      Heat[i] := Heat1Winter[i];
    end;
  end;

  for i := 0 to 743 do
  begin
    HeatJan := HeatJan + Heat[i];
  end;
  for i := 744 to 1415 do
  begin
    HeatFeb := HeatFeb + Heat[i];
  end;
  for i := 1416 to 2159 do
  begin
    HeatMar := HeatMar + Heat[i];
  end;
  for i := 2160 to 2879 do
  begin
    HeatApr := HeatApr + Heat[i];
  end;
  for i := 2880 to 3623 do
  begin
    HeatMay := HeatMay + Heat[i];
  end;
  for i := 3624 to 4343 do
  begin
    HeatJun := HeatJun + Heat[i];
  end;
  for i := 4344 to 5087 do
  begin
    HeatJul := HeatJul + Heat[i];
  end;
  for i := 5088 to 5831 do
  begin
    HeatAug := HeatAug + Heat[i];
  end;
  for i := 5832 to 6551 do
  begin
    HeatSep := HeatSep + Heat[i];
  end;
  for i := 6552 to 7295 do
  begin
    HeatOct := HeatOct + Heat[i];
  end;
  for i := 7296 to 8015 do
  begin
    HeatNov := HeatNov + Heat[i];
  end;
  for i := 8016 to 8759 do
  begin
    HeatDec := HeatDec + Heat[i];
  end;

  for i := 0 to intervall do
  begin
    for j := 0 to 8759 do
    begin
      if YearlyTemp[j] >= Temp[i] then
      begin
        Time[i] := Time[i] + 1;
      end;
    end;
  end;
  totalHeat := HeatJan + HeatFeb + HeatMar + HeatApr + HeatMay + HeatJun +
    HeatJul + HeatAug + HeatSep + HeatOct + HeatNov + HeatDec;

  if HeatRadioButton.IsChecked = true then
  begin
    Chart1.LeftAxis.Title.Caption :='Energibehov'; //'Energibehov/dag (kWh)';
    Chart1.BottomAxis.Title.Caption := 'M�nad';
    HeatJan := (HeatJan / 744)/1000;
    HeatFeb := (HeatFeb / 672)/1000;
    HeatMar := (HeatMar / 744)/1000;
    HeatApr := (HeatApr / 720)/1000;
    HeatMay := (HeatMay / 744)/1000;
    HeatJun := (HeatJun / 720)/1000;
    HeatJul := (HeatJul / 744)/1000;
    HeatAug := (HeatAug / 744)/1000;
    HeatSep := (HeatSep / 720)/1000;
    HeatOct := (HeatOct / 744)/1000;
    HeatNov := (HeatNov / 720)/1000;
    HeatDec := (HeatDec / 744)/1000;

    With Chart1.Series[0] Do
    Begin
      AddXY(1, HeatJan, '', clTeeColor);
      AddXY(2, HeatFeb, '', clTeeColor);
      AddXY(3, HeatMar, '', clTeeColor);
      AddXY(4, HeatApr, '', clTeeColor);
      AddXY(5, HeatMay, '', clTeeColor);
      AddXY(6, HeatJun, '', clTeeColor);
      AddXY(7, HeatJul, '', clTeeColor);
      AddXY(8, HeatAug, '', clTeeColor);
      AddXY(9, HeatSep, '', clTeeColor);
      AddXY(10, HeatOct, '', clTeeColor);
      AddXY(11, HeatNov, '', clTeeColor);
      AddXY(12, HeatDec, '', clTeeColor);
    end;
  end
  else if TempRadioButton.IsChecked = true then
  begin
    Chart1.LeftAxis.Title.Caption := 'Timmar';
    Chart1.BottomAxis.Title.Caption := 'Temperatur';
    With Chart1.Series[0] Do
    Begin
      for i := 0 to intervall do
      begin
        AddXY(Temp[i], Time[i], '', clTeeColor);
      end;
    end;
  end;
  Label2.Text := FloatToStr(Round(totalHeat / 1000)) + ' kWh/�r';

end;

procedure TForm5.NoGlazeChart;
var
  NoGlaze: TextFile;
  DataFile: TStringList;
  VolPath, StartDir: String;
  buffer: String;
  Hour, OutTemp, GlobalRadiation, Temp1, OpTemp1, Heat1: array of Real;
  Temp: Array of double;
  i: integer;
  IgnoreText: Boolean;
  meanJan, meanFeb, meanMar, meanApr, meanMay, meanJun, meanJul, meanAug,
    meanSep, meanOct, meanNov, meanDec: Real;
  HeatJan, HeatFeb, HeatMar, HeatApr, HeatMay, HeatJun, HeatJul, HeatAug,
    HeatSep, HeatOct, HeatNov, HeatDec, totalHeat: Real;
begin
  // Definering av vektorer och variabler
  SetLength(Hour, 8760);
  SetLength(OutTemp, 8760);
  SetLength(GlobalRadiation, 8760);
  SetLength(Temp1, 8760);
  SetLength(OpTemp1, 8760);
  SetLength(Heat1, 8760);
  IgnoreText := False;
  // Flagga f�r att inte l�sa texten som finns i b�rjan av filen
  Chart1.Series[1].Clear; // Ta bort tidigare v�rden i diagramet
  SetCurrentDir('../NoGlaze/');
  VolPath := GetCurrentDir + '\Vol_Load.txt';
  AssignFile(NoGlaze, VolPath);
  Reset(NoGlaze);
  // While-loop �ver hela Vol_Load-filen
  while not Eof(NoGlaze) do
  begin
    // Koll ifall while-loopen befinner sig �ver de 12 f�rsta raderna som inte ska l�sas in
    if IgnoreText = False then
    begin
      for i := 0 to 11 do
      begin
        ReadLn(NoGlaze, buffer);
      end;
      IgnoreText := true;
    end;
    // Loopar �ver v�rdena i filen
    for i := 12 to 8772 do
    begin
      ReadLn(NoGlaze, Hour[i - 12], OutTemp[i - 12], GlobalRadiation[i - 12],
        Temp1[i - 12], OpTemp1[i - 12], Heat1[i - 12]);
    end;
  end;
  CloseFile(NoGlaze);
  for i := 0 to 743 do
  begin
    meanJan := meanJan + Temp1[i];
    HeatJan := HeatJan + Heat1[i];
  end;
  for i := 744 to 1415 do
  begin
    meanFeb := meanFeb + Temp1[i];
    HeatFeb := HeatFeb + Heat1[i];
  end;
  for i := 1416 to 2159 do
  begin
    meanMar := meanMar + Temp1[i];
    HeatMar := HeatMar + Heat1[i];
  end;
  for i := 2160 to 2879 do
  begin
    meanApr := meanApr + Temp1[i];
    HeatApr := HeatApr + Heat1[i];
  end;
  for i := 2880 to 3623 do
  begin
    meanMay := meanMay + Temp1[i];
    HeatMay := HeatMay + Heat1[i];
  end;
  for i := 3624 to 4343 do
  begin
    meanJun := meanJun + Temp1[i];
    HeatJun := HeatJun + Heat1[i];
  end;
  for i := 4344 to 5087 do
  begin
    meanJul := meanJul + Temp1[i];
    HeatJul := HeatJul + Heat1[i];
  end;
  for i := 5088 to 5831 do
  begin
    meanAug := meanAug + Temp1[i];
    HeatAug := HeatAug + Heat1[i];
  end;
  for i := 5832 to 6551 do
  begin
    meanSep := meanSep + Temp1[i];
    HeatSep := HeatSep + Heat1[i];
  end;
  for i := 6552 to 7295 do
  begin
    meanOct := meanOct + Temp1[i];
    HeatOct := HeatOct + Heat1[i];
  end;
  for i := 7296 to 8015 do
  begin
    meanNov := meanNov + Temp1[i];
    HeatNov := HeatNov + Heat1[i];
  end;
  for i := 8016 to 8759 do
  begin
    meanDec := meanDec + Temp1[i];
    HeatDec := HeatDec + Heat1[i];
  end;

  totalHeat := HeatJan + HeatFeb + HeatMar + HeatApr + HeatMay + HeatJun +
    HeatJul + HeatAug + HeatSep + HeatOct + HeatNov + HeatDec;

  if TempRadioButton.IsChecked = true then
  begin
    meanJan := meanJan / 744;
    meanFeb := meanFeb / 672;
    meanMar := meanMar / 744;
    meanApr := meanApr / 720;
    meanMay := meanMay / 744;
    meanJun := meanJun / 720;
    meanJul := meanJul / 744;
    meanAug := meanAug / 744;
    meanSep := meanSep / 720;
    meanOct := meanOct / 744;
    meanNov := meanNov / 720;
    meanDec := meanDec / 744;
    With Chart1.Series[1] Do
    Begin
      AddXY(1, meanJan, '', clTeeColor);
      AddXY(2, meanFeb, '', clTeeColor);
      AddXY(3, meanMar, '', clTeeColor);
      AddXY(4, meanApr, '', clTeeColor);
      AddXY(5, meanMay, '', clTeeColor);
      AddXY(6, meanJun, '', clTeeColor);
      AddXY(7, meanJul, '', clTeeColor);
      AddXY(8, meanAug, '', clTeeColor);
      AddXY(9, meanSep, '', clTeeColor);
      AddXY(10, meanOct, '', clTeeColor);
      AddXY(11, meanNov, '', clTeeColor);
      AddXY(12, meanDec, '', clTeeColor);
    end;
  end
  else if HeatRadioButton.IsChecked = true then
  begin
    HeatJan := HeatJan / 744;
    HeatFeb := HeatFeb / 672;
    HeatMar := HeatMar / 744;
    HeatApr := HeatApr / 720;
    HeatMay := HeatMay / 744;
    HeatJun := HeatJun / 720;
    HeatJul := HeatJul / 744;
    HeatAug := HeatAug / 744;
    HeatSep := HeatSep / 720;
    HeatOct := HeatOct / 744;
    HeatNov := HeatNov / 720;
    HeatDec := HeatDec / 744;

    With Chart1.Series[1] Do
    Begin
      AddXY(1, HeatJan, '', clTeeColor);
      AddXY(2, HeatFeb, '', clTeeColor);
      AddXY(3, HeatMar, '', clTeeColor);
      AddXY(4, HeatApr, '', clTeeColor);
      AddXY(5, HeatMay, '', clTeeColor);
      AddXY(6, HeatJun, '', clTeeColor);
      AddXY(7, HeatJul, '', clTeeColor);
      AddXY(8, HeatAug, '', clTeeColor);
      AddXY(9, HeatSep, '', clTeeColor);
      AddXY(10, HeatOct, '', clTeeColor);
      AddXY(11, HeatNov, '', clTeeColor);
      AddXY(12, HeatDec, '', clTeeColor);
    end;
  end;

end;

procedure TForm5.NoGlazeHistogram;
var
  NoGlaze: TextFile;
  DataFile: TStringList;
  VolPath, StartDir: String;
  buffer: String;
  Hour, OutTemp, GlobalRadiation, Temp1, OpTemp1, Heat1, Time: array of Real;
  Temp: array of double;
  i, intervall: integer;
  IgnoreText: Boolean;
  meanJan, meanFeb, meanMar, meanApr, meanMay, meanJun, meanJul, meanAug,
    meanSep, meanOct, meanNov, meanDec: Real;
  HeatJan, HeatFeb, HeatMar, HeatApr, HeatMay, HeatJun, HeatJul, HeatAug,
    HeatSep, HeatOct, HeatNov, HeatDec, totalHeat: Real;
  j: integer;
begin
  // Definering av vektorer och variabler
  intervall := (40 - DerobModel.HouseProperties.IntValue['TMinRoom']) * 10;
  SetLength(Hour, 8760);
  SetLength(OutTemp, 8760);
  SetLength(GlobalRadiation, 8760);
  SetLength(Temp1, 8760);
  SetLength(OpTemp1, 8760);
  SetLength(Heat1, 8760);
  SetLength(Time, intervall);
  SetLength(Temp, intervall);
  Temp[0] := DerobModel.HouseProperties.IntValue['TMinRoom'];
  for i := 1 to intervall do
  begin
    Temp[i] := Round(Temp[i - 1] * 10) / 10 + 0.1;
  end;

  IgnoreText := False;
  SetCurrentDir(DerobModel.HouseProperties.StringValue['StartDir']);
  SetCurrentDir('Cases/');
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  // Flagga f�r att inte l�sa texten som finns i b�rjan av filen
  Chart1.Series[1].Clear; // Ta bort tidigare v�rden i diagramet
  SetCurrentDir('NoGlaze/');
  VolPath := GetCurrentDir + '\Vol_Load.txt';
  AssignFile(NoGlaze, VolPath);
  Reset(NoGlaze);
  // While-loop �ver hela Vol_Load-filen
  while not Eof(NoGlaze) do
  begin
    // Koll ifall while-loopen befinner sig �ver de 12 f�rsta raderna som inte ska l�sas in
    if IgnoreText = False then
    begin
      for i := 0 to 11 do
      begin
        ReadLn(NoGlaze, buffer);
      end;
      IgnoreText := true;
    end;
    // Loopar �ver v�rdena i filen
    for i := 12 to 8772 do
    begin
      ReadLn(NoGlaze, Hour[i - 12], OutTemp[i - 12], GlobalRadiation[i - 12],
        Temp1[i - 12], OpTemp1[i - 12], Heat1[i - 12]);
    end;
  end;
  for j := 0 to intervall do
  begin
    for i := 0 to 8759 do
    begin
      if Temp1[i] >= Temp[j] then
      begin
        Time[j] := Time[j] + 1;
      end;

    end;
  end;
  CloseFile(NoGlaze);
  for i := 0 to 743 do
  begin
    HeatJan := HeatJan + Heat1[i];
  end;
  for i := 744 to 1415 do
  begin
    HeatFeb := HeatFeb + Heat1[i];
  end;
  for i := 1416 to 2159 do
  begin
    HeatMar := HeatMar + Heat1[i];
  end;
  for i := 2160 to 2879 do
  begin
    HeatApr := HeatApr + Heat1[i];
  end;
  for i := 2880 to 3623 do
  begin
    HeatMay := HeatMay + Heat1[i];
  end;
  for i := 3624 to 4343 do
  begin
    HeatJun := HeatJun + Heat1[i];
  end;
  for i := 4344 to 5087 do
  begin
    HeatJul := HeatJul + Heat1[i];
  end;
  for i := 5088 to 5831 do
  begin
    HeatAug := HeatAug + Heat1[i];
  end;
  for i := 5832 to 6551 do
  begin
    HeatSep := HeatSep + Heat1[i];
  end;
  for i := 6552 to 7295 do
  begin
    HeatOct := HeatOct + Heat1[i];
  end;
  for i := 7296 to 8015 do
  begin
    HeatNov := HeatNov + Heat1[i];
  end;
  for i := 8016 to 8759 do
  begin
    HeatDec := HeatDec + Heat1[i];
  end;

  totalHeat := HeatJan + HeatFeb + HeatMar + HeatApr + HeatMay + HeatJun +
    HeatJul + HeatAug + HeatSep + HeatOct + HeatNov + HeatDec;

  if HeatRadioButton.IsChecked = true then
  begin
    HeatJan := (HeatJan / 744)/1000;
    HeatFeb := (HeatFeb / 672)/1000;
    HeatMar := (HeatMar / 744)/1000;
    HeatApr := (HeatApr / 720)/1000;
    HeatMay := (HeatMay / 744)/1000;
    HeatJun := (HeatJun / 720)/1000;
    HeatJul := (HeatJul / 744)/1000;
    HeatAug := (HeatAug / 744)/1000;
    HeatSep := (HeatSep / 720)/1000;
    HeatOct := (HeatOct / 744)/1000;
    HeatNov := (HeatNov / 720)/1000;
    HeatDec := (HeatDec / 744)/1000;

    With Chart1.Series[1] Do
    Begin
      AddXY(1, HeatJan, '', clTeeColor);
      AddXY(2, HeatFeb, '', clTeeColor);
      AddXY(3, HeatMar, '', clTeeColor);
      AddXY(4, HeatApr, '', clTeeColor);
      AddXY(5, HeatMay, '', clTeeColor);
      AddXY(6, HeatJun, '', clTeeColor);
      AddXY(7, HeatJul, '', clTeeColor);
      AddXY(8, HeatAug, '', clTeeColor);
      AddXY(9, HeatSep, '', clTeeColor);
      AddXY(10, HeatOct, '', clTeeColor);
      AddXY(11, HeatNov, '', clTeeColor);
      AddXY(12, HeatDec, '', clTeeColor);
    end;
  end
  else if TempRadioButton.IsChecked = true then
  begin
    With Chart1.Series[1] Do
    Begin
      for i := 0 to intervall do
      begin
        AddXY(Temp[i], Time[i], '', clTeeColor);
      end;
    end;
  end;
  Label4.Text := FloatToStr(Round(totalHeat / 1000)) + ' kWh/�r';
end;

procedure TForm5.SetDerobModel(const Value: TDerobModel);
begin
  FDerobModel := Value;
end;

end.
