unit diagramForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Engine, FMXTee.Procs, FMXTee.Chart, derob, FMXTee.Series, Math,
  ShellApi, FMX.Layouts, FMX.Memo, System.Rtti, FMX.Grid;

type
  TForm5 = class(TForm)
    Chart1: TChart;
    TempRadioButton: TRadioButton;
    HeatRadioButton: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Series2: TLineSeries;
    Series1: TLineSeries;
    ResultTxtBtn: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    ResultGrid: TStringGrid;
    StringColumn1: TStringColumn;
    URadioButton: TRadioButton;
    EtaRadioButton: TRadioButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TempRadioButtonChange(Sender: TObject);
    procedure HeatRadioButtonChange(Sender: TObject);
    procedure ResultTxtBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure URadioButtonChange(Sender: TObject);
    procedure EtaRadioButtonChange(Sender: TObject);
  private
    FDerobModel: TDerobModel;
    procedure SetDerobModel(const Value: TDerobModel);
    procedure GlazeHistogram;
    procedure NoGlazeHistogram;
    procedure TLSumValues;
    procedure UpdateChart;
    procedure Compare;
    { Private declarations }
  public
    { Public declarations }
    property DerobModel: TDerobModel read FDerobModel write SetDerobModel;
  end;

var
  Form5: TForm5;
  Resultat, ResVolLoad, ResNoGlaze, Comparefile: TStrings;
  GlazeTemp, ULine, EtaLine: TLineSeries;
  HeatJan, HeatFeb, HeatMar, HeatApr, HeatMay, HeatJun, HeatJul, HeatAug,
    HeatSep, HeatOct, HeatNov, HeatDec, totalHeat, HeatJanNoGl, HeatFebNoGl,
    HeatMarNoGl, HeatAprNoGl, HeatMayNoGl, HeatJunNoGl, HeatJulNoGl,
    HeatAugNoGl, HeatSepNoGl, HeatOctNoGl, HeatNovNoGl, HeatDecNoGl: Real;
  Temp, EtaPrim, UPrim, UTime, EtaTime, UIntervall, EtaIntervall
    : array of double;
  TimeGlaze, Time, TimeNoGl: array of Real;
  intervall, USteg, EtaSteg: Integer;

implementation

{$R *.fmx}

// TEstar här
procedure TForm5.Button1Click(Sender: TObject);
var
  FileName: String;
  VolLoadFileStream: TFilestream;
  i, LineCount, TempLine, colCount: Integer;
  TLStrings: TStringList;
  val: array of Real;
  j, VolLine: Integer;
  col: TStringColumn;
begin
  colCount := ResultGrid.ColumnCount;
  for i := colCount - 1 downto 1 do
  begin
    ResultGrid.Columns[i].Free;
  end;

  SetLength(val, DerobModel.HouseProperties.IntValue['nvol'] * 8);
  ResVolLoad := TStringList.Create;
  TLStrings := TStringList.Create;
  SetCurrentDir(DerobModel.HouseProperties.StringValue['StartDir']);
  SetCurrentDir('Cases/');
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  SetCurrentDir('Winter');
  FileName := 'TL.log';
  VolLoadFileStream := TFilestream.Create(FileName, fmShareDenyNone);
  ResVolLoad.LoadFromStream(VolLoadFileStream);

  ResultGrid.Cells[0, 0] := 'MedelTemp';
  ResultGrid.Cells[0, 1] := 'MinTemp';
  ResultGrid.Cells[0, 2] := 'MaxTemp';
  ResultGrid.Cells[0, 3] := 'MedelEnergi';
  ResultGrid.Cells[0, 4] := 'MinEnergi';
  ResultGrid.Cells[0, 5] := 'MaxEnergi';
  for i := ResVolLoad.Count - 1 downto 0 do
  begin
    if ResVolLoad.Strings[i] = '   Yearly summary :' then
    begin
      TempLine := i;
      Break;
    end;
  end;
  for j := 0 to DerobModel.HouseProperties.IntValue['nvol'] - 1 do
  begin
    col := TStringColumn.Create(self);
    if j = 0 then
    begin
      col.Header := 'Referens';
    end
    else if j = 1 then
    begin
      col.Header := 'Rum';
    end;
    begin
      col.Header := 'Vol ' + IntToStr(j + 1);
    end;
    ResultGrid.AddObject(col);
    VolLine := TempLine + (j * 9);
    LineCount := 0;
    for i := VolLine + 1 to VolLine + 6 do
    begin
      LineCount := LineCount + 1;
      TLStrings.Delimiter := ':';
      TLStrings.StrictDelimiter := True;
      TLStrings.DelimitedText := ResVolLoad.Strings[i];
      case LineCount of
        1:
          begin
            ResultGrid.Cells[j + 1, 0] := TLStrings[2];
          end;
        2:
          begin
            ResultGrid.Cells[j + 1, 1] := TLStrings[1];
          end;
        3:
          begin
            ResultGrid.Cells[j + 1, 2] := TLStrings[1];
          end;
        4:
          begin
            ResultGrid.Cells[j + 1, 3] := TLStrings[1];
          end;
        5:
          begin
            ResultGrid.Cells[j + 1, 4] := TLStrings[1];
          end;
        6:
          begin
            ResultGrid.Cells[j + 1, 5] := TLStrings[1];
          end;
      end;
    end;
  end;
end;

procedure TForm5.Button2Click(Sender: TObject);
var
  Grid: TGrid;
begin
  Grid := TGrid.Create(self);
  Grid.Visible := True;
end;

procedure TForm5.Compare;
// Procedur som visar vad icke-inglasningsfallet behöver för värmeväxlare
// alterntivt U-värde för att motsvara inglasningsfallet
var
  i, Skipper: Integer;
  TLPath, buffer: string;
  TLResult: TextFile;
  TInne, TUte, TotEnergi, TotEnergiGlas, Ball, Area, WindowH, WindowW,
    DeltaT: array of double;
  ATot, Langd, Bredd, Hojd, Dens, SpecVarme, Flode, UVal: double;
  j: Integer;
  k: Integer;
  // Total area för fyra väggar (Tak,Golv exkl.)
begin
  SetLength(TInne, 8760); // Inomhustemperatur (NoGlaze)
  SetLength(TUte, 8760); // Utomhustemperatur (NoGlaze)
  SetLength(Ball, 8760); // Skräpvektor
  SetLength(TotEnergi, 8760); // Total energianvändning per år (NoGlaze)
  SetLength(TotEnergiGlas, 8760); // Total energianvändning per år (Glaze)
  SetLength(EtaPrim, 8760); // Ny effektivitet på värmeväxlare på NoGlaze-Fall
  SetLength(UPrim, 8760); // Nytt U-Värde för väggar på NoGlaze-Fall
  SetLength(Area, 4);
  // Area för de fyra väggarna på varsin plats (exkl fönster)
  SetLength(WindowW, 4); // Fönsterbredd för de fyra väggarna på varsin plats
  SetLength(WindowH, 4); // Fönsterhöjd --"--"--
  SetLength(DeltaT, 8760); // Temperaturskillnad mellan ute och inne

  // EtaTime = Antal timmar EtaPrim behöver ökas med ett visst värde
  USteg := 250;
  EtaSteg := 150;
   SetLength(UTime, USteg);
  // UTime = Antal timmar UPrim behöver vara under ett visst värde
  SetLength(EtaTime, EtaSteg);
  SetLength(UIntervall, USteg);
  SetLength(EtaIntervall, EtaSteg);
  UIntervall[0] := -0.5;
  EtaIntervall[0] := 0;

  for i := 1 to USteg do
  begin
    UIntervall[i] := UIntervall[i - 1] + 0.01;
  end;

  for i := 1 to EtaSteg do
  begin
    EtaIntervall[i] := EtaIntervall[i - 1] + 0.01;
  end;

  Langd := DerobModel.Surface.Length;
  Bredd := DerobModel.Surface.Width;
  Hojd := DerobModel.Surface.Height;

  // Räkna ut total area för väggarna genom att ta bort eventuell fönsterarea
  if DerobModel.Walls[0].Properties.BoolValue['HoleNorth'] = True then
  begin
    Area[0] := Bredd * Hojd - DerobModel.Windows[0].Width * DerobModel.Windows
      [0].Height;
  end
  else
  begin
    Area[0] := Bredd * Hojd;
  end;

  if DerobModel.Walls[1].Properties.BoolValue['HoleEast'] = True then
  begin
    Area[1] := Langd * Hojd - DerobModel.Windows[1].Width * DerobModel.Windows
      [1].Height;
  end
  else
  begin
    Area[1] := Langd * Hojd;
  end;
  if DerobModel.Walls[2].Properties.BoolValue['HoleSouth'] = True then
  begin
    Area[2] := Bredd * Hojd - DerobModel.Windows[2].Width * DerobModel.Windows
      [2].Height;
  end
  else
  begin
    Area[2] := Bredd * Hojd;
  end;
  if DerobModel.Walls[3].Properties.BoolValue['HoleWest'] = True then
  begin
    Area[3] := Langd * Hojd - DerobModel.Windows[3].Width * DerobModel.Windows
      [3].Height;
  end
  else
  begin
    Area[3] := Langd * Hojd;
  end;

  ATot := Sum(Area);
  Dens := 1.2; // Densitet för luft vid 21 grader
  SpecVarme := 1000; // För luft, [J/kgK];
  Flode := ((1 - DerobModel.VentilationProperties.DoubleValue['Eta'] / 100) *
    DerobModel.VentilationProperties.DoubleValue['Flow']) / 1000;
  // Ventilationsflöde q i [m^3/s];

  // Hitta konstruktion som används i väggarna och ta fram U-värdet
  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    if DerobModel.Constructions[i].Name = DerobModel.HouseProperties.StringValue
      ['Wall'] then
    begin
      UVal := DerobModel.Constructions[i].DoubleValue['UValue'];
    end;
  end;

  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseDir']);
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  TLPath := GetCurrentDir + '\Resultat.txt';
  AssignFile(TLResult, TLPath);
  Reset(TLResult);
  for i := 0 to 14 do // Hoppa över de första 15 raderna (text)
  begin
    ReadLn(TLResult, buffer);
  end;
  Skipper := 15;
  for i := Skipper to 8774 do
  begin
    ReadLn(TLResult, Ball[i - Skipper], Ball[i - Skipper], Ball[i - Skipper],
      // Hämta energianvändning timme för timme från Resultat.txt
      Ball[i - Skipper], Ball[i - Skipper], TotEnergiGlas[i - Skipper]);
  end;
  CloseFile(TLResult);

  // In i rätt mapp där Vol_Load för referensfallet NoGlaze finns
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseDir']);
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  SetCurrentDir('NoGlaze');

  TLPath := GetCurrentDir + '\Vol_Load.txt';
  AssignFile(TLResult, TLPath);
  Reset(TLResult);

  for i := 0 to 11 do // Hoppa över de första 12 raderna (text)
  begin
    ReadLn(TLResult, buffer);
  end;

  for i := 12 to 8771 do
  begin
    ReadLn(TLResult, Ball[i - 12], TUte[i - 12], Ball[i - 12], TInne[i - 12],
      Ball[i - 12], TotEnergi[i - 12]);
  end;
  CloseFile(TLResult);
  Comparefile := TStringList.Create;
  // Räkna ut de nya värdena på EtaPrim och UPrim och skriv ned till fil
  Comparefile.Add('h  Timme [h]');
  Comparefile.Add('dT Temperaturskillnad  [°C]');
  Comparefile.Add('EnergiG  Energianvändning för fall med inglasning  [Wh/h]');
  Comparefile.Add('Energi Energianvändning för fall utan inglasning [Wh/h]');
  Comparefile.Add('U  U-Värde [W/m^2]');
  Comparefile.Add('Eta  Värmeväxlarens effektivitet [-]');
  Comparefile.Add('');
  Comparefile.Add('h  dT  EnergiG  Energi U Eta');
  for i := 0 to 8759 do
  begin
    DeltaT[i] := TInne[i] - TUte[i];
    if DeltaT[i] > 0.1 then
    begin
      EtaPrim[i] := (TotEnergi[i] - TotEnergiGlas[i]) /
        (Flode * Dens * SpecVarme * (TInne[i] - TUte[i]));
      UPrim[i] := (TotEnergiGlas[i] - TotEnergi[i] + UVal * ATot *
        (TInne[i] - TUte[i])) / (ATot * DeltaT[i]);
    end
    else
    begin
      UPrim[i] := UVal;
      EtaPrim[i] := 0;
    end;
    Comparefile.Add(FloatToStr(i + 1) + ' ' + FloatToStr(DeltaT[i]) + ' ' +
      FloatToStr(TotEnergiGlas[i]) + ' ' + FloatToStr(TotEnergi[i]) + '  ' +
      FloatToStr(UPrim[i]) + '  ' + FloatToStr(EtaPrim[i]));
  end;

  for i := 0 to USteg - 1 do
  begin
    for j := 0 to 8759 do
    begin
      if UPrim[j] < UIntervall[i] then
      begin
        UTime[i] := UTime[i] + 1;
      end;
    end;
  end;

  for i := 0 to EtaSteg - 1 do
  begin
    for j := 0 to 8759 do
    begin
      if EtaPrim[j] > EtaIntervall[i] then
      begin
        EtaTime[i] := EtaTime[i] + 1;
      end;
    end;
  end;

  Label5.Text := FloatToStr(Round(1000 * Sum(UPrim) / 8760) / 1000) + ' W/m^2';
  Label7.Text := FloatToStr(Round(100 * Sum(EtaPrim) / 8760)) + ' %';
  Label12.Text := FloatToStr(Round(1000 * UVal) / 1000) + ' W/m^2';;
  Label9.Text := FloatToStr(DerobModel.VentilationProperties.DoubleValue
    ['Eta']) + ' %';

  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseDir']);
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  Comparefile.SaveToFile('Comparison.txt');
  Comparefile.Free;

end;

procedure TForm5.EtaRadioButtonChange(Sender: TObject);
begin
  if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
  begin

    GlazeTemp.ShowInLegend := False;
  end;
  Chart1.Series[0].ShowInLegend := False;
  Chart1.Series[1].ShowInLegend := False;
  ULine.ShowInLegend := False;
  EtaLine.ShowInLegend := True;
  UpdateChart;
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Chart1.Series[0].Clear;
  Chart1.Series[1].Clear;
  Label2.Text := '';
  Label4.Text := '';
  HeatRadioButton.IsChecked := False;
  TempRadioButton.IsChecked := False;
  Chart1.LeftAxis.Title.Caption := '';
  Chart1.BottomAxis.Title.Caption := '';
  if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
  begin
    GlazeTemp.Free;
  end;
  ULine.Free;
  EtaLine.Free;
  SetCurrentDir(DerobModel.HouseProperties.StringValue['StartDir']);
end;

procedure TForm5.FormShow(Sender: TObject);
var
  i: Integer;
begin
  if DerobModel.HouseProperties.BoolValue['Simulated'] = True then
  begin
    DerobModel.HouseProperties.BoolValue['Simulated'] := True;
  end
  else
  begin
    DerobModel.HouseProperties.BoolValue['Simulated'] := False;
  end;
  Chart1.Legend.Visible := True;
  ULine := TLineSeries.Create(Chart1);
  Chart1.AddSeries(ULine); // Skapa linjer för U', Eta'
  EtaLine := TLineSeries.Create(Chart1);
  Chart1.AddSeries(EtaLine);
  Chart1.Series[2].Color := TAlphaColorRec.Purple;
  Chart1.Series[3].Color := TAlphaColorRec.Black;
  ULine.Title := 'U* [W/m^2]';
  EtaLine.Title := 'Eta* [%]';

  if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
  begin
    GlazeTemp := TLineSeries.Create(Chart1);
    GlazeTemp.ShowInLegend := True;
    Chart1.AddSeries(GlazeTemp);
    GlazeTemp.Title := 'Vald Inglasning';
    Chart1.Series[4].Color := TAlphaColorRec.Green;
  end;

  ULine.ShowInLegend := False;
  EtaLine.ShowInLegend := False;
  if DerobModel.HouseProperties.BoolValue['Simulated'] = False then
  begin
    SetLength(Time, 8760);
    SetLength(TimeNoGl, 8760);
    SetLength(UTime, 8760);
    SetLength(EtaTime, 8760);
    if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
    begin
      SetLength(TimeGlaze, 8760);
    end;
    for i := 0 to 8759 do
    begin
      Time[i] := 0;
      TimeNoGl[i] := 0;
      UTime[i] := 0;
      EtaTime[i] := 0;
      if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
      begin
        TimeGlaze[i] := 0;
      end;
    end;

    GlazeHistogram;
    NoGlazeHistogram;
    TempRadioButton.IsChecked := True;

    Compare;
    UpdateChart;
    TLSumValues;
    DerobModel.HouseProperties.BoolValue['Simulated'] := True;
  end;
  TempRadioButton.IsChecked := True;
end;

procedure TForm5.GlazeHistogram;
var
  Summer, Winter, SummerOpen, WinterOpen: TextFile;
  DataFile: TStringList;
  VolPath, ResultPath: String;
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
  OutTempSummerOpen, GlobalRadiationSummerOpen, Temp1SummerOpen,
    OpTemp1SummerOpen, Heat1SummerOpen, Cool1SummerOpen, Sun1SummerOpen,
    Temp2SummerOpen, OpTemp2SummerOpen, Heat2SummerOpen, Cool2SummerOpen,
    Sun2SummerOpen, Temp3SummerOpen, OpTemp3SummerOpen, Heat3SummerOpen,
    Cool3SummerOpen, Sun3SummerOpen, Temp4SummerOpen, OpTemp4SummerOpen,
    Heat4SummerOpen, Cool4SummerOpen, Sun4SummerOpen, Temp5SummerOpen,
    OpTemp5SummerOpen, Heat5SummerOpen, Cool5SummerOpen, Sun5SummerOpen
    : array of Real;
  OutTempWinterOpen, GlobalRadiationWinterOpen, Temp1WinterOpen,
    OpTemp1WinterOpen, Heat1WinterOpen, Cool1WinterOpen, Sun1WinterOpen,
    Temp2WinterOpen, OpTemp2WinterOpen, Heat2WinterOpen, Cool2WinterOpen,
    Sun2WinterOpen, Temp3WinterOpen, OpTemp3WinterOpen, Heat3WinterOpen,
    Cool3WinterOpen, Sun3WinterOpen, Temp4WinterOpen, OpTemp4WinterOpen,
    Heat4WinterOpen, Cool4WinterOpen, Sun4WinterOpen, Temp5WinterOpen,
    OpTemp5WinterOpen, Heat5WinterOpen, Cool5WinterOpen, Sun5WinterOpen
    : array of Real;

  TempSummerOpen, TempWinterOpen, OpTempSummerOpen, OpTempWinterOpen,
    SunSummerOpen, SunWinterOpen: Array of Real;

  i, j, SkipLine: Integer;
  IgnoreText: boolean;

  Temp, Hour, YearlyTemp, YearlyTempGlaze, Heat, TempSummer, TempWinter,
    OpTempSummer, OpTempWinter, SunSummer, SunWinter: Array of Real;

begin
  intervall := (40 - DerobModel.HouseProperties.IntValue['TMinRoom']) * 10;
  SkipLine := 12;
  SetLength(YearlyTemp, 8760);
  SetLength(YearlyTempGlaze, 8760);
  SetLength(Hour, 8760);

  SetLength(TempSummer, 8760);
  SetLength(TempWinter, 8760);
  SetLength(OutTempSummer, 8760);
  SetLength(OutTempWinter, 8760);
  SetLength(GlobalRadiationSummer, 8760);
  SetLength(GlobalRadiationWinter, 8760);
  SetLength(OpTempSummer, 8760);
  SetLength(OpTempWinter, 8760);
  SetLength(SunSummer, 8760);
  SetLength(SunWinter, 8760);

  SetLength(TempSummerOpen, 8760);
  SetLength(TempWinterOpen, 8760);
  SetLength(OutTempSummerOpen, 8760);
  SetLength(OutTempWinterOpen, 8760);
  SetLength(GlobalRadiationSummerOpen, 8760);
  SetLength(GlobalRadiationWinterOpen, 8760);
  SetLength(OpTempSummerOpen, 8760);
  SetLength(OpTempWinterOpen, 8760);
  SetLength(SunSummerOpen, 8760);
  SetLength(SunWinterOpen, 8760);

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

  SetLength(Temp1SummerOpen, 8760);
  SetLength(OpTemp1SummerOpen, 8760);
  SetLength(Heat1SummerOpen, 8760);
  SetLength(Cool1SummerOpen, 8760);
  SetLength(Sun1SummerOpen, 8760);

  SetLength(Temp1WinterOpen, 8760);
  SetLength(OpTemp1WinterOpen, 8760);
  SetLength(Heat1WinterOpen, 8760);
  SetLength(Cool1WinterOpen, 8760);
  SetLength(Sun1WinterOpen, 8760);

  SetLength(Temp2SummerOpen, 8760);
  SetLength(OpTemp2SummerOpen, 8760);
  SetLength(Heat2SummerOpen, 8760);
  SetLength(Cool2SummerOpen, 8760);
  SetLength(Sun2SummerOpen, 8760);

  SetLength(Temp2WinterOpen, 8760);
  SetLength(OpTemp2WinterOpen, 8760);
  SetLength(Heat2WinterOpen, 8760);
  SetLength(Cool2WinterOpen, 8760);
  SetLength(Sun2WinterOpen, 8760);

  SetLength(Temp3SummerOpen, 8760);
  SetLength(OpTemp3SummerOpen, 8760);
  SetLength(Heat3SummerOpen, 8760);
  SetLength(Cool3SummerOpen, 8760);
  SetLength(Sun3SummerOpen, 8760);

  SetLength(Temp3WinterOpen, 8760);
  SetLength(OpTemp3WinterOpen, 8760);
  SetLength(Heat3WinterOpen, 8760);
  SetLength(Cool3WinterOpen, 8760);
  SetLength(Sun3WinterOpen, 8760);

  SetLength(Temp4SummerOpen, 8760);
  SetLength(OpTemp4SummerOpen, 8760);
  SetLength(Heat4SummerOpen, 8760);
  SetLength(Cool4SummerOpen, 8760);
  SetLength(Sun4SummerOpen, 8760);

  SetLength(Temp4WinterOpen, 8760);
  SetLength(OpTemp4WinterOpen, 8760);
  SetLength(Heat4WinterOpen, 8760);
  SetLength(Cool4WinterOpen, 8760);
  SetLength(Sun4WinterOpen, 8760);

  SetLength(Temp5SummerOpen, 8760);
  SetLength(OpTemp5SummerOpen, 8760);
  SetLength(Heat5SummerOpen, 8760);
  SetLength(Cool5SummerOpen, 8760);
  SetLength(Sun5SummerOpen, 8760);

  SetLength(Temp5WinterOpen, 8760);
  SetLength(OpTemp5WinterOpen, 8760);
  SetLength(Heat5WinterOpen, 8760);
  SetLength(Cool5WinterOpen, 8760);
  SetLength(Sun5WinterOpen, 8760);

  SetLength(Temp, intervall);
  SetLength(Time, intervall);
  SetLength(TimeGlaze, intervall);
  SetLength(Heat, 8760);

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
  if DerobModel.VentilationProperties.BoolValue['AutoOpening'] = True then
  begin
    SetCurrentDir('../SummerOpen');
    VolPath := GetCurrentDir + '\Vol_Load.txt';
    AssignFile(SummerOpen, VolPath);
    Reset(SummerOpen);
    SetCurrentDir('../WinterOpen');
    VolPath := GetCurrentDir + '\Vol_Load.txt';
    AssignFile(WinterOpen, VolPath);
    Reset(WinterOpen);
  end;
  while not EOF(Summer) do
  begin
    // Pass the first 12 lines that describes the variables in the text files
    if IgnoreText = False then
    begin
      for i := 0 to 11 do
      begin
        ReadLn(Summer, buffer);
        ReadLn(Winter, buffer);
        if DerobModel.VentilationProperties.BoolValue['AutoOpening'] = True then
        begin
          ReadLn(SummerOpen, buffer);
          ReadLn(WinterOpen, buffer);
        end;
      end;
      IgnoreText := True;
    end;
    for i := 12 to 8772 do
    begin
      // Inläsning av variablerna i Vol_load.txt
      // Beroende på antalet volymer är det olika antal kolumner
      // Varför man behöver flera olika inläsningsalternativ
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
      // Inläsning av indata för automatisk öppning
      if DerobModel.VentilationProperties.BoolValue['AutoOpening'] = True then
      begin
        if DerobModel.HouseProperties.IntValue['nvol'] = 1 then
        begin
          ReadLn(SummerOpen, Hour[i - SkipLine],
            OutTempSummerOpen[i - SkipLine],
            GlobalRadiationSummerOpen[i - SkipLine],
            Temp1SummerOpen[i - SkipLine], OpTemp1SummerOpen[i - SkipLine],
            Heat1SummerOpen[i - SkipLine], Cool1SummerOpen[i - SkipLine],
            Sun1SummerOpen[i - SkipLine]);
          ReadLn(WinterOpen, Hour[i - SkipLine],
            OutTempWinterOpen[i - SkipLine],
            GlobalRadiationWinterOpen[i - SkipLine],
            Temp1WinterOpen[i - SkipLine], OpTemp1WinterOpen[i - SkipLine],
            Heat1WinterOpen[i - SkipLine], Cool1WinterOpen[i - SkipLine],
            Sun1WinterOpen[i - SkipLine]);
        end;
        if DerobModel.HouseProperties.IntValue['nvol'] = 2 then
        begin
          ReadLn(SummerOpen, Hour[i - SkipLine],
            OutTempSummerOpen[i - SkipLine],
            GlobalRadiationSummerOpen[i - SkipLine],
            Temp1SummerOpen[i - SkipLine], OpTemp1SummerOpen[i - SkipLine],
            Heat1SummerOpen[i - SkipLine], Cool1SummerOpen[i - SkipLine],
            Sun1SummerOpen[i - SkipLine], Temp2SummerOpen[i - SkipLine],
            OpTemp2SummerOpen[i - SkipLine], Heat2SummerOpen[i - SkipLine],
            Cool2SummerOpen[i - SkipLine], Sun2SummerOpen[i - SkipLine]);

          ReadLn(WinterOpen, Hour[i - SkipLine],
            OutTempWinterOpen[i - SkipLine],
            GlobalRadiationWinterOpen[i - SkipLine],
            Temp1WinterOpen[i - SkipLine], OpTemp1WinterOpen[i - SkipLine],
            Heat1WinterOpen[i - SkipLine], Cool1WinterOpen[i - SkipLine],
            Sun1WinterOpen[i - SkipLine], Temp2WinterOpen[i - SkipLine],
            OpTemp2WinterOpen[i - SkipLine], Heat2WinterOpen[i - SkipLine],
            Cool2WinterOpen[i - SkipLine], Sun2WinterOpen[i - SkipLine]);
        end;
        if DerobModel.HouseProperties.IntValue['nvol'] = 3 then
        begin
          ReadLn(SummerOpen, Hour[i - SkipLine],
            OutTempSummerOpen[i - SkipLine],
            GlobalRadiationSummerOpen[i - SkipLine],
            Temp1SummerOpen[i - SkipLine], OpTemp1SummerOpen[i - SkipLine],
            Heat1SummerOpen[i - SkipLine], Cool1SummerOpen[i - SkipLine],
            Sun1SummerOpen[i - SkipLine], Temp2SummerOpen[i - SkipLine],
            OpTemp2SummerOpen[i - SkipLine], Heat2SummerOpen[i - SkipLine],
            Cool2SummerOpen[i - SkipLine], Sun2SummerOpen[i - SkipLine],
            Temp3SummerOpen[i - SkipLine], OpTemp3SummerOpen[i - SkipLine],
            Heat3SummerOpen[i - SkipLine], Cool3SummerOpen[i - SkipLine],
            Sun3SummerOpen[i - SkipLine]);

          ReadLn(WinterOpen, Hour[i - SkipLine],
            OutTempWinterOpen[i - SkipLine],
            GlobalRadiationWinterOpen[i - SkipLine],
            Temp1WinterOpen[i - SkipLine], OpTemp1WinterOpen[i - SkipLine],
            Heat1WinterOpen[i - SkipLine], Cool1WinterOpen[i - SkipLine],
            Sun1WinterOpen[i - SkipLine], Temp2WinterOpen[i - SkipLine],
            OpTemp2WinterOpen[i - SkipLine], Heat2WinterOpen[i - SkipLine],
            Cool2WinterOpen[i - SkipLine], Sun2WinterOpen[i - SkipLine],
            Temp3WinterOpen[i - SkipLine], OpTemp3WinterOpen[i - SkipLine],
            Heat3WinterOpen[i - SkipLine], Cool3WinterOpen[i - SkipLine],
            Sun3WinterOpen[i - SkipLine]);
        end;
        if DerobModel.HouseProperties.IntValue['nvol'] = 4 then
        begin
          ReadLn(SummerOpen, Hour[i - SkipLine],
            OutTempSummerOpen[i - SkipLine],
            GlobalRadiationSummerOpen[i - SkipLine],
            Temp1SummerOpen[i - SkipLine], OpTemp1SummerOpen[i - SkipLine],
            Heat1SummerOpen[i - SkipLine], Cool1SummerOpen[i - SkipLine],
            Sun1SummerOpen[i - SkipLine], Temp2SummerOpen[i - SkipLine],
            OpTemp2SummerOpen[i - SkipLine], Heat2SummerOpen[i - SkipLine],
            Cool2SummerOpen[i - SkipLine], Sun2SummerOpen[i - SkipLine],
            Temp3SummerOpen[i - SkipLine], OpTemp3SummerOpen[i - SkipLine],
            Heat3SummerOpen[i - SkipLine], Cool3SummerOpen[i - SkipLine],
            Sun3SummerOpen[i - SkipLine], Temp4SummerOpen[i - SkipLine],
            OpTemp4SummerOpen[i - SkipLine], Heat4SummerOpen[i - SkipLine],
            Cool4SummerOpen[i - SkipLine], Sun4SummerOpen[i - SkipLine]);

          ReadLn(WinterOpen, Hour[i - SkipLine],
            OutTempWinterOpen[i - SkipLine],
            GlobalRadiationWinterOpen[i - SkipLine],
            Temp1WinterOpen[i - SkipLine], OpTemp1WinterOpen[i - SkipLine],
            Heat1WinterOpen[i - SkipLine], Cool1WinterOpen[i - SkipLine],
            Sun1WinterOpen[i - SkipLine], Temp2WinterOpen[i - SkipLine],
            OpTemp2WinterOpen[i - SkipLine], Heat2WinterOpen[i - SkipLine],
            Cool2WinterOpen[i - SkipLine], Sun2WinterOpen[i - SkipLine],
            Temp3WinterOpen[i - SkipLine], OpTemp3WinterOpen[i - SkipLine],
            Heat3WinterOpen[i - SkipLine], Cool3WinterOpen[i - SkipLine],
            Sun3WinterOpen[i - SkipLine], Temp4WinterOpen[i - SkipLine],
            OpTemp4WinterOpen[i - SkipLine], Heat4WinterOpen[i - SkipLine],
            Cool4WinterOpen[i - SkipLine], Sun4WinterOpen[i - SkipLine]);
        end;
        if DerobModel.HouseProperties.IntValue['nvol'] = 5 then
        begin
          ReadLn(SummerOpen, Hour[i - SkipLine],
            OutTempSummerOpen[i - SkipLine],
            GlobalRadiationSummerOpen[i - SkipLine],
            Temp1SummerOpen[i - SkipLine], OpTemp1SummerOpen[i - SkipLine],
            Heat1SummerOpen[i - SkipLine], Cool1SummerOpen[i - SkipLine],
            Sun1SummerOpen[i - SkipLine], Temp2SummerOpen[i - SkipLine],
            OpTemp2SummerOpen[i - SkipLine], Heat2SummerOpen[i - SkipLine],
            Cool2SummerOpen[i - SkipLine], Sun2SummerOpen[i - SkipLine],
            Temp3SummerOpen[i - SkipLine], OpTemp3SummerOpen[i - SkipLine],
            Heat3SummerOpen[i - SkipLine], Cool3SummerOpen[i - SkipLine],
            Sun3SummerOpen[i - SkipLine], Temp4SummerOpen[i - SkipLine],
            OpTemp4SummerOpen[i - SkipLine], Heat4SummerOpen[i - SkipLine],
            Cool4SummerOpen[i - SkipLine], Sun4SummerOpen[i - SkipLine],
            Temp5SummerOpen[i - SkipLine], OpTemp5SummerOpen[i - SkipLine],
            Heat5SummerOpen[i - SkipLine], Cool5SummerOpen[i - SkipLine],
            Sun5SummerOpen[i - SkipLine]);

          ReadLn(WinterOpen, Hour[i - SkipLine],
            OutTempWinterOpen[i - SkipLine],
            GlobalRadiationWinterOpen[i - SkipLine],
            Temp1WinterOpen[i - SkipLine], OpTemp1WinterOpen[i - SkipLine],
            Heat1WinterOpen[i - SkipLine], Cool1WinterOpen[i - SkipLine],
            Sun1WinterOpen[i - SkipLine], Temp2WinterOpen[i - SkipLine],
            OpTemp2WinterOpen[i - SkipLine], Heat2WinterOpen[i - SkipLine],
            Cool2WinterOpen[i - SkipLine], Sun2WinterOpen[i - SkipLine],
            Temp3WinterOpen[i - SkipLine], OpTemp3WinterOpen[i - SkipLine],
            Heat3WinterOpen[i - SkipLine], Cool3WinterOpen[i - SkipLine],
            Sun3WinterOpen[i - SkipLine], Temp4WinterOpen[i - SkipLine],
            OpTemp4WinterOpen[i - SkipLine], Heat4WinterOpen[i - SkipLine],
            Cool4WinterOpen[i - SkipLine], Sun4WinterOpen[i - SkipLine],
            Temp5WinterOpen[i - SkipLine], OpTemp5WinterOpen[i - SkipLine],
            Heat5WinterOpen[i - SkipLine], Cool5WinterOpen[i - SkipLine],
            Sun5WinterOpen[i - SkipLine]);
        end;

      end;
      // Koll om temperaturen regleras med avseende på inglasningen
      if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
      begin
        if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 2 then
        begin
          TempSummer[i - SkipLine] := Temp2Summer[i - SkipLine];
          TempWinter[i - SkipLine] := Temp2Winter[i - SkipLine];
          TempSummerOpen[i - SkipLine] := Temp2SummerOpen[i - SkipLine];
          TempWinterOpen[i - SkipLine] := Temp2WinterOpen[i - SkipLine];
        end;
        if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 3 then
        begin
          TempSummer[i - SkipLine] := Temp3Summer[i - SkipLine];
          TempWinter[i - SkipLine] := Temp3Winter[i - SkipLine];
          TempSummerOpen[i - SkipLine] := Temp3SummerOpen[i - SkipLine];
          TempWinterOpen[i - SkipLine] := Temp3WinterOpen[i - SkipLine];
        end;
        if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 4 then
        begin
          TempSummer[i - SkipLine] := Temp4Summer[i - SkipLine];
          TempWinter[i - SkipLine] := Temp4Winter[i - SkipLine];
          TempSummerOpen[i - SkipLine] := Temp4SummerOpen[i - SkipLine];
          TempWinterOpen[i - SkipLine] := Temp4WinterOpen[i - SkipLine];
        end;
        if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 5 then
        begin
          TempSummer[i - SkipLine] := Temp5Summer[i - SkipLine];
          TempWinter[i - SkipLine] := Temp5Winter[i - SkipLine];
          TempSummerOpen[i - SkipLine] := Temp5SummerOpen[i - SkipLine];
          TempWinterOpen[i - SkipLine] := Temp5WinterOpen[i - SkipLine];
        end;
      end
      else
      begin
        TempSummer[i - SkipLine] := Temp1Summer[i - SkipLine];
        TempWinter[i - SkipLine] := Temp1Winter[i - SkipLine];
        TempSummerOpen[i - SkipLine] := Temp1SummerOpen[i - SkipLine];
        TempWinterOpen[i - SkipLine] := Temp1WinterOpen[i - SkipLine];
      end;
    end;

  end;
  CloseFile(Summer);
  CloseFile(Winter);
  if DerobModel.VentilationProperties.BoolValue['AutoOpening'] = True then
  begin
    CloseFile(SummerOpen);
    CloseFile(WinterOpen);
  end;
  Resultat := TStringList.Create;
  Resultat.Add('  Hour  From start of calculation period  [hr]');
  Resultat.Add(' Tmp_O  Outdoor temperature               [DegreeC]');
  Resultat.Add('   Igl  Global radiation                  [W/m2]');
  Resultat.Add(' Tmp_i  Temperature in volume i           [DegreeC]');
  Resultat.Add(' Opt_i  Operative temperature in volume i [DegreeC]');
  Resultat.Add('Heat_i  Heating load in volume i          [Wh/h]');
  Resultat.Add('Cool_i  Cooling load in volume i          [Wh/h]');
  Resultat.Add(' Sun_i  Sun absorbed in volume i          [Wh/h]');
  Resultat.Add('  Case  Denotes which case is used           [-]');
  Resultat.Add('S - Summer case');
  Resultat.Add('SO - Opened glaze, summer case');
  Resultat.Add('W - Winter case');
  Resultat.Add('WO - Opened glaze, winter case');
  Resultat.Add('');
  if (DerobModel.HouseProperties.IntValue['nvol'] = 2) then
  begin
    Resultat.Add
      ('Hour  Tmp_O Igl Tmp_1 Opt_1 Heat_1  Sun_1 Tmp_2 Opt_2 Sun_2 Case');
  end
  else if (DerobModel.HouseProperties.IntValue['nvol'] = 3) then
  begin
    Resultat.Add
      ('Hour  Tmp_O Igl Tmp_1 Opt_1 Heat_1  Sun_1 Tmp_2 Opt_2 Sun_2 Tmp_3 Opt_3 Sun_3 Case');
  end
  else if (DerobModel.HouseProperties.IntValue['nvol'] = 4) then
  begin
    Resultat.Add
      ('Hour  Tmp_O Igl Tmp_1 Opt_1 Heat_1  Sun_1 Tmp_2 Opt_2 Sun_2 Tmp_3 Opt_3 Sun_3 Tmp_4 Opt_4 Sun_4 Case')
  end
  else if (DerobModel.HouseProperties.IntValue['nvol'] = 5) then
  begin
    Resultat.Add
      ('Hour  Tmp_O Igl Tmp_1 Opt_1 Heat_1  Sun_1 Tmp_2 Opt_2 Sun_2 Tmp_3 Opt_3 Sun_3 Tmp_4 Opt_4 Sun_4 Tmp_5 Opt_5 Sun_5 Case')
  end
  else
  begin
    Resultat.Add('Hour  Tmp_O Igl Tmp_1 Opt_1 Heat_1  Sun_1 Case');
  end;

  for i := 0 to 8759 do
  begin
    // Kollar om det är temperaturen i rummet som används för reglering
    if DerobModel.HouseProperties.BoolValue['RoomTemp'] = True then
    begin
      // Kollar om temperaturen för vinterfallet är högre än max tillåten temperatur
      if TempWinter[i] > DerobModel.HouseProperties.IntValue['TMaxRoom'] then
      begin
        // Kollar antalet volymer
        if (DerobModel.HouseProperties.IntValue['nvol'] = 2) then
        begin
          // Kollar om någon av inglasningarna överstiger maxtemperaturen i inglasningen
          if (Temp2Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) then
          begin
            YearlyTemp[i] := TempSummerOpen[i];
            Heat[i] := Heat1SummerOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempSummerOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationSummerOpen[i]) + '  ' +
              FloatToStr(Temp1SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp1SummerOpen[i]) + ' ' +
              FloatToStr(Heat1SummerOpen[i]) + '  ' +
              FloatToStr(Sun1SummerOpen[i]) + ' ' +
              FloatToStr(Temp2SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp2SummerOpen[i]) + '  ' +
              FloatToStr(Sun2SummerOpen[i]) + ' SO');
          end
          else
          begin
            YearlyTemp[i] := TempSummer[i];
            Heat[i] := Heat1Summer[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i])
              + '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
              FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
              ' ' + FloatToStr(Heat1Summer[i]) + '  ' + FloatToStr(Sun1Summer[i]
              ) + ' ' + FloatToStr(Temp2Summer[i]) + '  ' +
              FloatToStr(OpTemp2Summer[i]) + '  ' +
              FloatToStr(Sun2Summer[i]) + ' S');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 3) then
        begin
          if ((Temp2Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTemp[i] := TempSummerOpen[i];
            Heat[i] := Heat1SummerOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempSummerOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationSummerOpen[i]) + '  ' +
              FloatToStr(Temp1SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp1SummerOpen[i]) + ' ' +
              FloatToStr(Heat1SummerOpen[i]) + '  ' +
              FloatToStr(Sun1SummerOpen[i]) + ' ' +
              FloatToStr(Temp2SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp2SummerOpen[i]) + '  ' +
              FloatToStr(Sun2SummerOpen[i]) + ' ' +
              FloatToStr(Temp3SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp3SummerOpen[i]) + '  ' +
              FloatToStr(Sun3SummerOpen[i]) + ' SO');
          end
          else
          begin
            YearlyTemp[i] := TempSummer[i];
            Heat[i] := Heat1Summer[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i])
              + '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
              FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
              ' ' + FloatToStr(Heat1Summer[i]) + '  ' + FloatToStr(Sun1Summer[i]
              ) + ' ' + FloatToStr(Temp2Summer[i]) + '  ' +
              FloatToStr(OpTemp2Summer[i]) + '  ' + FloatToStr(Sun2Summer[i]) +
              ' ' + FloatToStr(Temp3Summer[i]) + '  ' +
              FloatToStr(OpTemp3Summer[i]) + '  ' +
              FloatToStr(Sun3Summer[i]) + ' S');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 4) then
        begin
          if ((Temp2Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp4Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTemp[i] := TempSummerOpen[i];
            Heat[i] := Heat1SummerOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempSummerOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationSummerOpen[i]) + '  ' +
              FloatToStr(Temp1SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp1SummerOpen[i]) + ' ' +
              FloatToStr(Heat1SummerOpen[i]) + '  ' +
              FloatToStr(Sun1SummerOpen[i]) + ' ' +
              FloatToStr(Temp2SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp2SummerOpen[i]) + '  ' +
              FloatToStr(Sun2SummerOpen[i]) + ' ' +
              FloatToStr(Temp3SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp3SummerOpen[i]) + '  ' +
              FloatToStr(Sun3SummerOpen[i]) + ' ' +
              FloatToStr(Temp4SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp4SummerOpen[i]) + '  ' +
              FloatToStr(Sun4SummerOpen[i]) + ' SO');
          end
          else
          begin
            YearlyTemp[i] := TempSummer[i];
            Heat[i] := Heat1Summer[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i])
              + '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
              FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
              ' ' + FloatToStr(Heat1Summer[i]) + '  ' + FloatToStr(Sun1Summer[i]
              ) + ' ' + FloatToStr(Temp2Summer[i]) + '  ' +
              FloatToStr(OpTemp2Summer[i]) + '  ' + FloatToStr(Sun2Summer[i]) +
              ' ' + FloatToStr(Temp3Summer[i]) + '  ' +
              FloatToStr(OpTemp3Summer[i]) + '  ' + FloatToStr(Sun3Summer[i]) +
              ' ' + FloatToStr(Temp4Summer[i]) + '  ' +
              FloatToStr(OpTemp4Summer[i]) + '  ' +
              FloatToStr(Sun4Summer[i]) + ' S');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 5) then
        begin
          if ((Temp2Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp4Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp5Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTemp[i] := TempSummerOpen[i];
            Heat[i] := Heat1SummerOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempSummerOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationSummerOpen[i]) + '  ' +
              FloatToStr(Temp1SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp1SummerOpen[i]) + ' ' +
              FloatToStr(Heat1SummerOpen[i]) + '  ' +
              FloatToStr(Sun1SummerOpen[i]) + ' ' +
              FloatToStr(Temp2SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp2SummerOpen[i]) + '  ' +
              FloatToStr(Sun2SummerOpen[i]) + ' ' +
              FloatToStr(Temp3SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp3SummerOpen[i]) + '  ' +
              FloatToStr(Sun3SummerOpen[i]) + ' ' +
              FloatToStr(Temp4SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp4SummerOpen[i]) + '  ' +
              FloatToStr(Sun4SummerOpen[i]) + ' ' +
              FloatToStr(Temp5SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp5SummerOpen[i]) + '  ' +
              FloatToStr(Sun5SummerOpen[i]) + ' SO');
          end
          else
          begin
            YearlyTemp[i] := TempSummer[i];
            Heat[i] := Heat1Summer[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i])
              + '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
              FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
              ' ' + FloatToStr(Heat1Summer[i]) + '  ' + FloatToStr(Sun1Summer[i]
              ) + ' ' + FloatToStr(Temp2Summer[i]) + '  ' +
              FloatToStr(OpTemp2Summer[i]) + '  ' + FloatToStr(Sun2Summer[i]) +
              ' ' + FloatToStr(Temp3Summer[i]) + '  ' +
              FloatToStr(OpTemp3Summer[i]) + '  ' + FloatToStr(Sun3Summer[i]) +
              ' ' + FloatToStr(Temp4Summer[i]) + '  ' +
              FloatToStr(OpTemp4Summer[i]) + '  ' + FloatToStr(Sun4Summer[i]) +
              ' ' + FloatToStr(Temp5Summer[i]) + '  ' +
              FloatToStr(OpTemp5Summer[i]) + '  ' +
              FloatToStr(Sun5Summer[i]) + ' S');
          end;
        end
        else
        begin
          YearlyTemp[i] := TempSummer[i];
          Heat[i] := Heat1Summer[i];
          Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i]) +
            '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
            FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
            ' ' + FloatToStr(Heat1Summer[i]) + '  ' +
            FloatToStr(Sun1Summer[i]) + ' S');
        end;

      end
      // Om vintertfallets temperatur inte är högre än max tillåtna
      else
      begin
        // Kollar antalet volymer
        if (DerobModel.HouseProperties.IntValue['nvol'] = 2) then
        begin
          // Kollar om någon av inglasningarna överstiger maxtemperaturen i inglasningen
          if (Temp2Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) then
          begin
            YearlyTemp[i] := TempWinterOpen[i];
            Heat[i] := Heat1WinterOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempWinterOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationWinterOpen[i]) + '  ' +
              FloatToStr(Temp1WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp1WinterOpen[i]) + ' ' +
              FloatToStr(Heat1WinterOpen[i]) + '  ' +
              FloatToStr(Sun1WinterOpen[i]) + ' ' +
              FloatToStr(Temp2WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp2WinterOpen[i]) + '  ' +
              FloatToStr(Sun2WinterOpen[i]) + ' WO');
          end
          else
          begin
            YearlyTemp[i] := TempWinter[i];
            Heat[i] := Heat1Winter[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i])
              + '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
              FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
              ' ' + FloatToStr(Heat1Winter[i]) + '  ' + FloatToStr(Sun1Winter[i]
              ) + ' ' + FloatToStr(Temp2Winter[i]) + '  ' +
              FloatToStr(OpTemp2Winter[i]) + '  ' +
              FloatToStr(Sun2Winter[i]) + ' W');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 3) then
        begin
          if ((Temp2Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTemp[i] := TempWinterOpen[i];
            Heat[i] := Heat1WinterOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempWinterOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationWinterOpen[i]) + '  ' +
              FloatToStr(Temp1WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp1WinterOpen[i]) + ' ' +
              FloatToStr(Heat1WinterOpen[i]) + '  ' +
              FloatToStr(Sun1WinterOpen[i]) + ' ' +
              FloatToStr(Temp2WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp2WinterOpen[i]) + '  ' +
              FloatToStr(Sun2WinterOpen[i]) + ' ' +
              FloatToStr(Temp3WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp3WinterOpen[i]) + '  ' +
              FloatToStr(Sun3WinterOpen[i]) + ' WO');
          end
          else
          begin
            YearlyTemp[i] := TempWinter[i];
            Heat[i] := Heat1Winter[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i])
              + '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
              FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
              ' ' + FloatToStr(Heat1Winter[i]) + '  ' + FloatToStr(Sun1Winter[i]
              ) + ' ' + FloatToStr(Temp2Winter[i]) + '  ' +
              FloatToStr(OpTemp2Winter[i]) + '  ' + FloatToStr(Sun2Winter[i]) +
              ' ' + FloatToStr(Temp3Winter[i]) + '  ' +
              FloatToStr(OpTemp3Winter[i]) + '  ' +
              FloatToStr(Sun3Winter[i]) + ' W');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 4) then
        begin
          if ((Temp2Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp4Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTemp[i] := TempWinterOpen[i];
            Heat[i] := Heat1WinterOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempWinterOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationWinterOpen[i]) + '  ' +
              FloatToStr(Temp1WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp1WinterOpen[i]) + ' ' +
              FloatToStr(Heat1WinterOpen[i]) + '  ' +
              FloatToStr(Sun1WinterOpen[i]) + ' ' +
              FloatToStr(Temp2WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp2WinterOpen[i]) + '  ' +
              FloatToStr(Sun2WinterOpen[i]) + ' ' +
              FloatToStr(Temp3WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp3WinterOpen[i]) + '  ' +
              FloatToStr(Sun3WinterOpen[i]) + ' ' +
              FloatToStr(Temp4WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp4WinterOpen[i]) + '  ' +
              FloatToStr(Sun4WinterOpen[i]) + ' WO');
          end
          else
          begin
            YearlyTemp[i] := TempWinter[i];
            Heat[i] := Heat1Winter[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i])
              + '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
              FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
              ' ' + FloatToStr(Heat1Winter[i]) + '  ' + FloatToStr(Sun1Winter[i]
              ) + ' ' + FloatToStr(Temp2Winter[i]) + '  ' +
              FloatToStr(OpTemp2Winter[i]) + '  ' + FloatToStr(Sun2Winter[i]) +
              ' ' + FloatToStr(Temp3Winter[i]) + '  ' +
              FloatToStr(OpTemp3Winter[i]) + '  ' + FloatToStr(Sun3Winter[i]) +
              ' ' + FloatToStr(Temp4Winter[i]) + '  ' +
              FloatToStr(OpTemp4Winter[i]) + '  ' +
              FloatToStr(Sun4Winter[i]) + ' W');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 5) then
        begin
          if ((Temp2Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp4Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp5Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTemp[i] := TempWinterOpen[i];
            Heat[i] := Heat1WinterOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempWinterOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationWinterOpen[i]) + '  ' +
              FloatToStr(Temp1WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp1WinterOpen[i]) + ' ' +
              FloatToStr(Heat1WinterOpen[i]) + '  ' +
              FloatToStr(Sun1WinterOpen[i]) + ' ' +
              FloatToStr(Temp2WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp2WinterOpen[i]) + '  ' +
              FloatToStr(Sun2WinterOpen[i]) + ' ' +
              FloatToStr(Temp3WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp3WinterOpen[i]) + '  ' +
              FloatToStr(Sun3WinterOpen[i]) + ' ' +
              FloatToStr(Temp4WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp4WinterOpen[i]) + '  ' +
              FloatToStr(Sun4WinterOpen[i]) + ' ' +
              FloatToStr(Temp5WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp5WinterOpen[i]) + '  ' +
              FloatToStr(Sun5WinterOpen[i]) + ' WO');
          end
          else
          begin
            YearlyTemp[i] := TempWinter[i];
            Heat[i] := Heat1Winter[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i])
              + '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
              FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
              ' ' + FloatToStr(Heat1Winter[i]) + '  ' + FloatToStr(Sun1Winter[i]
              ) + ' ' + FloatToStr(Temp2Winter[i]) + '  ' +
              FloatToStr(OpTemp2Winter[i]) + '  ' + FloatToStr(Sun2Winter[i]) +
              ' ' + FloatToStr(Temp3Winter[i]) + '  ' +
              FloatToStr(OpTemp3Winter[i]) + '  ' + FloatToStr(Sun3Winter[i]) +
              ' ' + FloatToStr(Temp4Winter[i]) + '  ' +
              FloatToStr(OpTemp4Winter[i]) + '  ' + FloatToStr(Sun4Winter[i]) +
              ' ' + FloatToStr(Temp5Winter[i]) + '  ' +
              FloatToStr(OpTemp5Winter[i]) + '  ' +
              FloatToStr(Sun5Winter[i]) + ' W');
          end;
        end
        else
        begin
          YearlyTemp[i] := TempWinter[i];
          Heat[i] := Heat1Winter[i];
          Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i]) +
            '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
            FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
            ' ' + FloatToStr(Heat1Winter[i]) + '  ' +
            FloatToStr(Sun1Winter[i]) + ' W');
        end;
      end;
    end
    // Kollar om det regleras med avseende på inglasningstemperatur
    else if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
    begin
      // Kollar om temperaturen för vinterfallet överstiger temperaturen i inglasningen
      if TempWinter[i] > DerobModel.HouseProperties.IntValue['TMaxGlaze'] then
      begin
        if (DerobModel.HouseProperties.IntValue['nvol'] = 2) then
        begin
          if (Temp2Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) then
          begin
            YearlyTempGlaze[i] := TempSummerOpen[i];
            YearlyTemp[i] := Temp1SummerOpen[i];
            Heat[i] := Heat1SummerOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempSummerOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationSummerOpen[i]) + '  ' +
              FloatToStr(Temp1SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp1SummerOpen[i]) + ' ' +
              FloatToStr(Heat1SummerOpen[i]) + '  ' +
              FloatToStr(Sun1SummerOpen[i]) + ' ' +
              FloatToStr(Temp2SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp2SummerOpen[i]) + '  ' +
              FloatToStr(Sun2SummerOpen[i]) + ' SO');
          end
          else
          begin
            YearlyTempGlaze[i] := TempSummer[i];
            YearlyTemp[i] := Temp1Summer[i];
            Heat[i] := Heat1Summer[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i])
              + '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
              FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
              ' ' + FloatToStr(Heat1Summer[i]) + '  ' + FloatToStr(Sun1Summer[i]
              ) + ' ' + FloatToStr(Temp2Summer[i]) + '  ' +
              FloatToStr(OpTemp2Summer[i]) + '  ' +
              FloatToStr(Sun2Summer[i]) + ' S');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 3) then
        begin
          if ((Temp2Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTempGlaze[i] := TempSummerOpen[i];
            YearlyTemp[i] := Temp1SummerOpen[i];
            Heat[i] := Heat1SummerOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempSummerOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationSummerOpen[i]) + '  ' +
              FloatToStr(Temp1SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp1SummerOpen[i]) + ' ' +
              FloatToStr(Heat1SummerOpen[i]) + '  ' +
              FloatToStr(Sun1SummerOpen[i]) + ' ' +
              FloatToStr(Temp2SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp2SummerOpen[i]) + '  ' +
              FloatToStr(Sun2SummerOpen[i]) + ' ' +
              FloatToStr(Temp3SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp3SummerOpen[i]) + '  ' +
              FloatToStr(Sun3SummerOpen[i]) + ' SO');
          end
          else
          begin
            YearlyTempGlaze[i] := TempSummer[i];
            YearlyTemp[i] := Temp1Summer[i];
            Heat[i] := Heat1Summer[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i])
              + '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
              FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
              ' ' + FloatToStr(Heat1Summer[i]) + '  ' + FloatToStr(Sun1Summer[i]
              ) + ' ' + FloatToStr(Temp2Summer[i]) + '  ' +
              FloatToStr(OpTemp2Summer[i]) + '  ' + FloatToStr(Sun2Summer[i]) +
              ' ' + FloatToStr(Temp3Summer[i]) + '  ' +
              FloatToStr(OpTemp3Summer[i]) + '  ' +
              FloatToStr(Sun3Summer[i]) + ' S');

          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 4) then
        begin
          if ((Temp2Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp4Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTempGlaze[i] := TempSummerOpen[i];
            YearlyTemp[i] := Temp1SummerOpen[i];
            Heat[i] := Heat1SummerOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempSummerOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationSummerOpen[i]) + '  ' +
              FloatToStr(Temp1SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp1SummerOpen[i]) + ' ' +
              FloatToStr(Heat1SummerOpen[i]) + '  ' +
              FloatToStr(Sun1SummerOpen[i]) + ' ' +
              FloatToStr(Temp2SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp2SummerOpen[i]) + '  ' +
              FloatToStr(Sun2SummerOpen[i]) + ' ' +
              FloatToStr(Temp3SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp3SummerOpen[i]) + '  ' +
              FloatToStr(Sun3SummerOpen[i]) + ' ' +
              FloatToStr(Temp4SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp4SummerOpen[i]) + '  ' +
              FloatToStr(Sun4SummerOpen[i]) + ' SO');
          end
          else
          begin
            YearlyTempGlaze[i] := TempSummer[i];
            YearlyTemp[i] := Temp1Summer[i];
            Heat[i] := Heat1Summer[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i])
              + '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
              FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
              ' ' + FloatToStr(Heat1Summer[i]) + '  ' + FloatToStr(Sun1Summer[i]
              ) + ' ' + FloatToStr(Temp2Summer[i]) + '  ' +
              FloatToStr(OpTemp2Summer[i]) + '  ' + FloatToStr(Sun2Summer[i]) +
              ' ' + FloatToStr(Temp3Summer[i]) + '  ' +
              FloatToStr(OpTemp3Summer[i]) + '  ' + FloatToStr(Sun3Summer[i]) +
              ' ' + FloatToStr(Temp4Summer[i]) + '  ' +
              FloatToStr(OpTemp4Summer[i]) + '  ' +
              FloatToStr(Sun4Summer[i]) + ' S');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 5) then
        begin
          if ((Temp2Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp4Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp5Summer[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTempGlaze[i] := TempSummerOpen[i];
            YearlyTemp[i] := Temp1SummerOpen[i];
            Heat[i] := Heat1SummerOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempSummerOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationSummerOpen[i]) + '  ' +
              FloatToStr(Temp1SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp1SummerOpen[i]) + ' ' +
              FloatToStr(Heat1SummerOpen[i]) + '  ' +
              FloatToStr(Sun1SummerOpen[i]) + ' ' +
              FloatToStr(Temp2SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp2SummerOpen[i]) + '  ' +
              FloatToStr(Sun2SummerOpen[i]) + ' ' +
              FloatToStr(Temp3SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp3SummerOpen[i]) + '  ' +
              FloatToStr(Sun3SummerOpen[i]) + ' ' +
              FloatToStr(Temp4SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp4SummerOpen[i]) + '  ' +
              FloatToStr(Sun4SummerOpen[i]) + ' ' +
              FloatToStr(Temp5SummerOpen[i]) + '  ' +
              FloatToStr(OpTemp5SummerOpen[i]) + '  ' +
              FloatToStr(Sun5SummerOpen[i]) + ' SO');
          end
          else
          begin
            YearlyTempGlaze[i] := TempSummer[i];
            YearlyTemp[i] := Temp1Summer[i];
            Heat[i] := Heat1Summer[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i])
              + '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
              FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
              ' ' + FloatToStr(Heat1Summer[i]) + '  ' + FloatToStr(Sun1Summer[i]
              ) + ' ' + FloatToStr(Temp2Summer[i]) + '  ' +
              FloatToStr(OpTemp2Summer[i]) + '  ' + FloatToStr(Sun2Summer[i]) +
              ' ' + FloatToStr(Temp3Summer[i]) + '  ' +
              FloatToStr(OpTemp3Summer[i]) + '  ' + FloatToStr(Sun3Summer[i]) +
              ' ' + FloatToStr(Temp4Summer[i]) + '  ' +
              FloatToStr(OpTemp4Summer[i]) + '  ' + FloatToStr(Sun4Summer[i]) +
              ' ' + FloatToStr(Temp5Summer[i]) + '  ' +
              FloatToStr(OpTemp5Summer[i]) + '  ' +
              FloatToStr(Sun5Summer[i]) + ' S');
          end;
        end
        else
        begin
          YearlyTemp[i] := Temp1Summer[i];
          Heat[i] := Heat1Summer[i];
          Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempSummer[i]) +
            '  ' + FloatToStr(GlobalRadiationSummer[i]) + '  ' +
            FloatToStr(Temp1Summer[i]) + '  ' + FloatToStr(OpTemp1Summer[i]) +
            ' ' + FloatToStr(Heat1Summer[i]) + '  ' +
            FloatToStr(Sun1Summer[i]) + ' S');
        end;
      end
      // Om vinter temperaturen inte överstiger det angivna värdet
      else
      begin
        if (DerobModel.HouseProperties.IntValue['nvol'] = 2) then
        begin
          if (Temp2Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) then
          begin
            YearlyTempGlaze[i] := TempWinterOpen[i];
            YearlyTemp[i] := Temp1WinterOpen[i];
            Heat[i] := Heat1WinterOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempWinterOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationWinterOpen[i]) + '  ' +
              FloatToStr(Temp1WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp1WinterOpen[i]) + ' ' +
              FloatToStr(Heat1WinterOpen[i]) + '  ' +
              FloatToStr(Sun1WinterOpen[i]) + ' ' +
              FloatToStr(Temp2WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp2WinterOpen[i]) + '  ' +
              FloatToStr(Sun2WinterOpen[i]) + ' WO');
          end
          else
          begin
            YearlyTempGlaze[i] := TempWinter[i];
            YearlyTemp[i] := Temp1Winter[i];
            Heat[i] := Heat1Winter[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i])
              + '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
              FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
              ' ' + FloatToStr(Heat1Winter[i]) + '  ' + FloatToStr(Sun1Winter[i]
              ) + ' ' + FloatToStr(Temp2Winter[i]) + '  ' +
              FloatToStr(OpTemp2Winter[i]) + '  ' +
              FloatToStr(Sun2Winter[i]) + ' W');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 3) then
        begin
          if ((Temp2Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTempGlaze[i] := TempWinterOpen[i];
            YearlyTemp[i] := Temp1WinterOpen[i];
            Heat[i] := Heat1WinterOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempWinterOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationWinterOpen[i]) + '  ' +
              FloatToStr(Temp1WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp1WinterOpen[i]) + ' ' +
              FloatToStr(Heat1WinterOpen[i]) + '  ' +
              FloatToStr(Sun1WinterOpen[i]) + ' ' +
              FloatToStr(Temp2WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp2WinterOpen[i]) + '  ' +
              FloatToStr(Sun2WinterOpen[i]) + ' ' +
              FloatToStr(Temp3WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp3WinterOpen[i]) + '  ' +
              FloatToStr(Sun3WinterOpen[i]) + ' WO');
          end
          else
          begin
            YearlyTempGlaze[i] := TempWinter[i];
            YearlyTemp[i] := Temp1Winter[i];
            Heat[i] := Heat1Winter[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i])
              + '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
              FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
              ' ' + FloatToStr(Heat1Winter[i]) + '  ' + FloatToStr(Sun1Winter[i]
              ) + ' ' + FloatToStr(Temp2Winter[i]) + '  ' +
              FloatToStr(OpTemp2Winter[i]) + '  ' + FloatToStr(Sun2Winter[i]) +
              ' ' + FloatToStr(Temp3Winter[i]) + '  ' +
              FloatToStr(OpTemp3Winter[i]) + '  ' +
              FloatToStr(Sun3Winter[i]) + ' W');

          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 4) then
        begin
          if ((Temp2Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp4Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTempGlaze[i] := TempWinterOpen[i];
            YearlyTemp[i] := Temp1WinterOpen[i];
            Heat[i] := Heat1WinterOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempWinterOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationWinterOpen[i]) + '  ' +
              FloatToStr(Temp1WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp1WinterOpen[i]) + ' ' +
              FloatToStr(Heat1WinterOpen[i]) + '  ' +
              FloatToStr(Sun1WinterOpen[i]) + ' ' +
              FloatToStr(Temp2WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp2WinterOpen[i]) + '  ' +
              FloatToStr(Sun2WinterOpen[i]) + ' ' +
              FloatToStr(Temp3WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp3WinterOpen[i]) + '  ' +
              FloatToStr(Sun3WinterOpen[i]) + ' ' +
              FloatToStr(Temp4WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp4WinterOpen[i]) + '  ' +
              FloatToStr(Sun4WinterOpen[i]) + ' WO');
          end
          else
          begin
            YearlyTempGlaze[i] := TempWinter[i];
            YearlyTemp[i] := Temp1Winter[i];
            Heat[i] := Heat1Winter[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i])
              + '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
              FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
              ' ' + FloatToStr(Heat1Winter[i]) + '  ' + FloatToStr(Sun1Winter[i]
              ) + ' ' + FloatToStr(Temp2Winter[i]) + '  ' +
              FloatToStr(OpTemp2Winter[i]) + '  ' + FloatToStr(Sun2Winter[i]) +
              ' ' + FloatToStr(Temp3Winter[i]) + '  ' +
              FloatToStr(OpTemp3Winter[i]) + '  ' + FloatToStr(Sun3Winter[i]) +
              ' ' + FloatToStr(Temp4Winter[i]) + '  ' +
              FloatToStr(OpTemp4Winter[i]) + '  ' +
              FloatToStr(Sun4Winter[i]) + ' W');
          end;
        end
        else if (DerobModel.HouseProperties.IntValue['nvol'] = 5) then
        begin
          if ((Temp2Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp3Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp4Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp']) or
            (Temp5Winter[i] >= DerobModel.VentilationProperties.DoubleValue
            ['OpeningMaxTemp'])) then
          begin
            YearlyTempGlaze[i] := TempWinterOpen[i];
            YearlyTemp[i] := Temp1WinterOpen[i];
            Heat[i] := Heat1WinterOpen[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' +
              FloatToStr(OutTempWinterOpen[i]) + '  ' +
              FloatToStr(GlobalRadiationWinterOpen[i]) + '  ' +
              FloatToStr(Temp1WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp1WinterOpen[i]) + ' ' +
              FloatToStr(Heat1WinterOpen[i]) + '  ' +
              FloatToStr(Sun1WinterOpen[i]) + ' ' +
              FloatToStr(Temp2WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp2WinterOpen[i]) + '  ' +
              FloatToStr(Sun2WinterOpen[i]) + ' ' +
              FloatToStr(Temp3WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp3WinterOpen[i]) + '  ' +
              FloatToStr(Sun3WinterOpen[i]) + ' ' +
              FloatToStr(Temp4WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp4WinterOpen[i]) + '  ' +
              FloatToStr(Sun4WinterOpen[i]) + ' ' +
              FloatToStr(Temp5WinterOpen[i]) + '  ' +
              FloatToStr(OpTemp5WinterOpen[i]) + '  ' +
              FloatToStr(Sun5WinterOpen[i]) + ' WO');
          end
          else
          begin
            YearlyTempGlaze[i] := TempWinter[i];
            YearlyTemp[i] := Temp1Winter[i];
            Heat[i] := Heat1Winter[i];
            Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i])
              + '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
              FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
              ' ' + FloatToStr(Heat1Winter[i]) + '  ' + FloatToStr(Sun1Winter[i]
              ) + ' ' + FloatToStr(Temp2Winter[i]) + '  ' +
              FloatToStr(OpTemp2Winter[i]) + '  ' + FloatToStr(Sun2Winter[i]) +
              ' ' + FloatToStr(Temp3Winter[i]) + '  ' +
              FloatToStr(OpTemp3Winter[i]) + '  ' + FloatToStr(Sun3Winter[i]) +
              ' ' + FloatToStr(Temp4Winter[i]) + '  ' +
              FloatToStr(OpTemp4Winter[i]) + '  ' + FloatToStr(Sun4Winter[i]) +
              ' ' + FloatToStr(Temp5Winter[i]) + '  ' +
              FloatToStr(OpTemp5Winter[i]) + '  ' +
              FloatToStr(Sun5Winter[i]) + ' W');
          end;
        end
        else
        begin
          YearlyTemp[i] := Temp1Winter[i];
          Heat[i] := Heat1Winter[i];
          Resultat.Add(FloatToStr(i + 1) + '  ' + FloatToStr(OutTempWinter[i]) +
            '  ' + FloatToStr(GlobalRadiationWinter[i]) + '  ' +
            FloatToStr(Temp1Winter[i]) + '  ' + FloatToStr(OpTemp1Winter[i]) +
            ' ' + FloatToStr(Heat1Winter[i]) + '  ' +
            FloatToStr(Sun1Winter[i]) + ' W');
        end;

      end;
    end;
  end;
  ResultPath := DerobModel.HouseProperties.StringValue['CaseDir'] + '\' +
    DerobModel.HouseProperties.StringValue['CaseName'];
  Resultat.SaveToFile(ResultPath + '/Resultat.txt');
  Resultat.Free;
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
      if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
      begin
        if YearlyTempGlaze[j] >= Temp[i] then
        begin
          TimeGlaze[i] := TimeGlaze[i] + 1;
        end;
      end;
    end;
  end;
  totalHeat := HeatJan + HeatFeb + HeatMar + HeatApr + HeatMay + HeatJun +
    HeatJul + HeatAug + HeatSep + HeatOct + HeatNov + HeatDec;

  Label2.Text := FloatToStr(Round(totalHeat / 1000)) + ' kWh/år';

  HeatJan := (HeatJan / 744) / 1000;
  HeatFeb := (HeatFeb / 672) / 1000;
  HeatMar := (HeatMar / 744) / 1000;
  HeatApr := (HeatApr / 720) / 1000;
  HeatMay := (HeatMay / 744) / 1000;
  HeatJun := (HeatJun / 720) / 1000;
  HeatJul := (HeatJul / 744) / 1000;
  HeatAug := (HeatAug / 744) / 1000;
  HeatSep := (HeatSep / 720) / 1000;
  HeatOct := (HeatOct / 744) / 1000;
  HeatNov := (HeatNov / 720) / 1000;
  HeatDec := (HeatDec / 744) / 1000;

end;

procedure TForm5.HeatRadioButtonChange(Sender: TObject);
begin
  Chart1.Legend.Visible := True;
  if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
  begin
    Chart1.Series[4].Clear;
    GlazeTemp.ShowInLegend := False;
  end;
  UpdateChart;
  Chart1.Series[0].ShowInLegend := True;
  Chart1.Series[1].ShowInLegend := True;
  ULine.ShowInLegend := False;
  EtaLine.ShowInLegend := False;
end;

procedure TForm5.NoGlazeHistogram;
var
  NoGlaze: TextFile;
  VolPath: String;
  buffer: String;
  Hour, OutTemp, GlobalRadiation, Temp1, OpTemp1, Heat1, Time: array of Real;
  IgnoreText: boolean;
  i, j: Integer;
begin
  // Definering av vektorer och variabler
  intervall := (40 - DerobModel.HouseProperties.IntValue['TMinRoom']) * 10;
  intervall := intervall + 1; // Lösning endast för estetik
  SetLength(Hour, 8760);
  SetLength(OutTemp, 8760);
  SetLength(GlobalRadiation, 8760);
  SetLength(Temp1, 8760);
  SetLength(OpTemp1, 8760);
  SetLength(Heat1, 8760);
  SetLength(Time, intervall);
  SetLength(Temp, intervall);
  SetLength(TimeNoGl, 8760);
  Temp[0] := DerobModel.HouseProperties.IntValue['TMinRoom'];
  for i := 1 to intervall do
  begin
    Temp[i] := Round(Temp[i - 1] * 10) / 10 + 0.1;
  end;
  // Flagga för att inte läsa texten som finns i början av filen
  IgnoreText := False;
  SetCurrentDir(DerobModel.HouseProperties.StringValue['StartDir']);
  SetCurrentDir('Cases/');
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  Chart1.Series[1].Clear; // Ta bort tidigare värden i diagramet
  SetCurrentDir('NoGlaze/');
  VolPath := GetCurrentDir + '\Vol_Load.txt';
  AssignFile(NoGlaze, VolPath);
  Reset(NoGlaze);
  // While-loop över hela Vol_Load-filen
  while not EOF(NoGlaze) do
  begin
    // Koll ifall while-loopen befinner sig över de 12 första raderna som inte ska läsas in
    if IgnoreText = False then
    begin
      for i := 0 to 11 do
      begin
        ReadLn(NoGlaze, buffer);
      end;
      IgnoreText := True;
    end;
    // Loopar över värdena i filen
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
        TimeNoGl[j] := TimeNoGl[j] + 1;
      end;

    end;
  end;
  CloseFile(NoGlaze);
  for i := 0 to 743 do
  begin
    HeatJanNoGl := HeatJanNoGl + Heat1[i];
  end;
  for i := 744 to 1415 do
  begin
    HeatFebNoGl := HeatFebNoGl + Heat1[i];
  end;
  for i := 1416 to 2159 do
  begin
    HeatMarNoGl := HeatMarNoGl + Heat1[i];
  end;
  for i := 2160 to 2879 do
  begin
    HeatAprNoGl := HeatAprNoGl + Heat1[i];
  end;
  for i := 2880 to 3623 do
  begin
    HeatMayNoGl := HeatMayNoGl + Heat1[i];
  end;
  for i := 3624 to 4343 do
  begin
    HeatJunNoGl := HeatJunNoGl + Heat1[i];
  end;
  for i := 4344 to 5087 do
  begin
    HeatJulNoGl := HeatJulNoGl + Heat1[i];
  end;
  for i := 5088 to 5831 do
  begin
    HeatAugNoGl := HeatAugNoGl + Heat1[i];
  end;
  for i := 5832 to 6551 do
  begin
    HeatSepNoGl := HeatSepNoGl + Heat1[i];
  end;
  for i := 6552 to 7295 do
  begin
    HeatOctNoGl := HeatOctNoGl + Heat1[i];
  end;
  for i := 7296 to 8015 do
  begin
    HeatNovNoGl := HeatNovNoGl + Heat1[i];
  end;
  for i := 8016 to 8759 do
  begin
    HeatDecNoGl := HeatDecNoGl + Heat1[i];
  end;

  totalHeat := HeatJanNoGl + HeatFebNoGl + HeatMarNoGl + HeatAprNoGl +
    HeatMayNoGl + HeatJunNoGl + HeatJulNoGl + HeatAugNoGl + HeatSepNoGl +
    HeatOctNoGl + HeatNovNoGl + HeatDecNoGl;

  Label4.Text := FloatToStr(Round(totalHeat / 1000)) + ' kWh/år';

  HeatJanNoGl := (HeatJanNoGl / 744) / 1000;
  HeatFebNoGl := (HeatFebNoGl / 672) / 1000;
  HeatMarNoGl := (HeatMarNoGl / 744) / 1000;
  HeatAprNoGl := (HeatAprNoGl / 720) / 1000;
  HeatMayNoGl := (HeatMayNoGl / 744) / 1000;
  HeatJunNoGl := (HeatJunNoGl / 720) / 1000;
  HeatJulNoGl := (HeatJulNoGl / 744) / 1000;
  HeatAugNoGl := (HeatAugNoGl / 744) / 1000;
  HeatSepNoGl := (HeatSepNoGl / 720) / 1000;
  HeatOctNoGl := (HeatOctNoGl / 744) / 1000;
  HeatNovNoGl := (HeatNovNoGl / 720) / 1000;
  HeatDecNoGl := (HeatDecNoGl / 744) / 1000;
end;

procedure TForm5.ResultTxtBtnClick(Sender: TObject);
var
  ResultatPath: String;
begin
  ResultatPath := DerobModel.HouseProperties.StringValue['CaseDir'] + '\' +
    DerobModel.HouseProperties.StringValue['CaseName'] + '\Resultat.txt';
  ShellExecute(0, 'open', PChar(ResultatPath), nil, '', 1);
end;

procedure TForm5.SetDerobModel(const Value: TDerobModel);
begin
  FDerobModel := Value;
end;

procedure TForm5.TempRadioButtonChange(Sender: TObject);
begin
  Chart1.Legend.Visible := True;
  if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
  begin
    GlazeTemp.ShowInLegend := True;
  end;
  UpdateChart;
  Chart1.Series[0].ShowInLegend := True;
  Chart1.Series[1].ShowInLegend := True;
  ULine.ShowInLegend := False;
  EtaLine.ShowInLegend := False;
end;

procedure TForm5.TLSumValues;
// Procedur som skall ge användaren värden som medelT, max- och minT, Energianvändning

var

  i, Skipper, colCount: Integer;
  TLPath, buffer: string;
  TLResult: TextFile;
  UteT, RumT, RumEnergi, Ball, Vol5T, Vol2T, Vol3T, Vol4T, RefT,
    RefEnergi: array of double;
  col: TStringColumn;
  Ball2: array of string;

begin
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseDir']);
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  // In i rätt mapp där Resultat.txt finns
  SetLength(UteT, 8760);
  SetLength(RumT, 8760);
  SetLength(RumEnergi, 8760);
  // Definiera vektorernas storlekar, 8760 timvärden
  SetLength(Ball, 8760);
  SetLength(Ball2, 8760);
  // Vektorer som tillfälligt håller värden som ej ska visas i denna procedur, Ball (double) och Ball2 (Strings)
  SetLength(Vol2T, 8760);
  SetLength(Vol3T, 8760);
  SetLength(Vol4T, 8760);
  SetLength(Vol5T, 8760);
  SetLength(RefT, 8760);
  SetLength(RefEnergi, 8760);

  colCount := ResultGrid.ColumnCount;
  for i := colCount - 1 downto 1 do // Rensa i tabellerna
  begin
    ResultGrid.Columns[i].Free;
  end;

  for i := 0 to 3 do // Skapa rubriker i tabellen
  begin
    col := TStringColumn.Create(self);
    col.Width := 47;
    case i of
      0:
        begin
          col.Header := 'MedelT';
        end;
      1:
        begin
          col.Header := 'Tot.Energi';
          col.Width := 85
        end;
      2:
        begin
          col.Header := 'Min.T';
        end;
      3:
        begin
          col.Header := 'Max.T';
        end;
    end;
    ResultGrid.AddObject(col);
  end;
  //
  TLPath := GetCurrentDir + '\Resultat.txt';
  AssignFile(TLResult, TLPath);
  Reset(TLResult);
  for i := 0 to 14 do // Hoppa över de första 15 raderna (text)
  begin
    ReadLn(TLResult, buffer);
  end;
  Skipper := 15;
  for i := Skipper to 8774 do
  // Beroende på hur många volymer, läs in temperaturer och energianvändning för rum
  // Ball-vektorn får innehålla variabler vi inte vill visa, ex. Solabsorptans
  begin
    case DerobModel.HouseProperties.IntValue['nvol'] of
      1:
        begin
          ReadLn(TLResult, Ball[i - Skipper], UteT[i - Skipper],
            Ball[i - Skipper], RumT[i - Skipper], Ball[i - Skipper],
            RumEnergi[i - Skipper], Ball2[i - Skipper]);
        end;
      2:
        begin
          ReadLn(TLResult, Ball[i - Skipper], UteT[i - Skipper],
            Ball[i - Skipper], RumT[i - Skipper], Ball[i - Skipper],
            RumEnergi[i - Skipper], Ball[i - Skipper], Vol2T[i - Skipper],
            Ball2[i - Skipper]);
        end;
      3:
        begin
          ReadLn(TLResult, Ball[i - Skipper], UteT[i - Skipper],
            Ball[i - Skipper], RumT[i - Skipper], Ball[i - Skipper],
            RumEnergi[i - Skipper], Ball[i - Skipper], Vol2T[i - Skipper],
            Ball[i - Skipper], Ball[i - Skipper], Vol3T[i - Skipper],
            Ball2[i - Skipper]);
        end;
      4:
        begin
          ReadLn(TLResult, Ball[i - Skipper], UteT[i - Skipper],
            Ball[i - Skipper], RumT[i - Skipper], Ball[i - Skipper],
            RumEnergi[i - Skipper], Ball[i - Skipper], Vol2T[i - Skipper],
            Ball[i - Skipper], Ball[i - Skipper], Vol3T[i - Skipper],
            Ball[i - Skipper], Ball[i - Skipper], Vol4T[i - Skipper],
            Ball2[i - Skipper]);
        end;
      5:
        begin
          ReadLn(TLResult, Ball[i - Skipper], UteT[i - Skipper],
            Ball[i - Skipper], RumT[i - Skipper], Ball[i - Skipper],
            RumEnergi[i - Skipper], Ball[i - Skipper], Vol2T[i - Skipper],
            Ball[i - Skipper], Ball[i - Skipper], Vol3T[i - Skipper],
            Ball[i - Skipper], Ball[i - Skipper], Vol4T[i - Skipper],
            Ball[i - Skipper], Ball[i - Skipper], Vol5T[i - Skipper],
            Ball2[i - Skipper]);

        end;
    end;
  end;
  CloseFile(TLResult);

  // In i rätt mapp där Vol_Load för referensfallet NoGlaze finns
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseDir']);
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  SetCurrentDir('NoGlaze');

  TLPath := GetCurrentDir + '\Vol_Load.txt';
  AssignFile(TLResult, TLPath);
  Reset(TLResult);

  for i := 0 to 11 do // Hoppa över de första 10 raderna (text)
  begin
    ReadLn(TLResult, buffer);
  end;

  for i := 12 to 8771 do
  begin
    ReadLn(TLResult, Ball[i - 12], Ball[i - 12], Ball[i - 12], RefT[i - 12],
      Ball[i - 12], RefEnergi[i - 12]);
  end;
  CloseFile(TLResult);

  // Rumsvolym i aktuell byggnad och referensbyggnad finns alltid i tabellen
  ResultGrid.Cells[0, 0] := 'ReferensRum';
  ResultGrid.Cells[1, 0] := FloatToStr(Round(Mean(RefT) * 10) / 10) + ' °C';
  ResultGrid.Cells[2, 0] := FloatToStr(Round(Sum(RefEnergi) / 100) / 10) +
    ' kWh/år';
  ResultGrid.Cells[3, 0] := FloatToStr(MinValue(RefT)) + ' °C';
  ResultGrid.Cells[4, 0] := FloatToStr(MaxValue(RefT)) + ' °C';

  ResultGrid.Cells[0, 1] := 'Rumsvolym';
  ResultGrid.Cells[1, 1] := FloatToStr(Round(Mean(RumT) * 10) / 10) + ' °C';
  ResultGrid.Cells[2, 1] := FloatToStr(Round(Sum(RumEnergi) / 100) / 10) +
    ' kWh/år';
  ResultGrid.Cells[3, 1] := FloatToStr(MinValue(RumT)) + ' °C';
  ResultGrid.Cells[4, 1] := FloatToStr(MaxValue(RumT)) + ' °C';

  if DerobModel.HouseProperties.IntValue['nvol'] > 1 then
  begin
    ResultGrid.Cells[0, 2] := 'Volym 2';
    ResultGrid.Cells[1, 2] := FloatToStr(Round(Mean(Vol2T) * 10) / 10) + ' °C';
    ResultGrid.Cells[2, 2] := '------';
    ResultGrid.Cells[3, 2] := FloatToStr(MinValue(Vol2T)) + ' °C';
    ResultGrid.Cells[4, 2] := FloatToStr(MaxValue(Vol2T)) + ' °C';
    // Beroende på hur många volymer vi har fylls tabellen på
    if DerobModel.HouseProperties.IntValue['nvol'] > 2 then
    begin
      ResultGrid.Cells[0, 3] := 'Volym 3';
      ResultGrid.Cells[1, 3] :=
        FloatToStr(Round(Mean(Vol3T) * 10) / 10) + ' °C';
      ResultGrid.Cells[2, 3] := '------';
      ResultGrid.Cells[3, 3] := FloatToStr(MinValue(Vol3T)) + ' °C';
      ResultGrid.Cells[4, 3] := FloatToStr(MaxValue(Vol3T)) + ' °C';
    end;
    if DerobModel.HouseProperties.IntValue['nvol'] > 3 then
    begin
      ResultGrid.Cells[0, 4] := 'Volym 4';
      ResultGrid.Cells[1, 4] :=
        FloatToStr(Round(Mean(Vol4T) * 10) / 10) + ' °C';
      ResultGrid.Cells[2, 4] := '------';
      ResultGrid.Cells[3, 4] := FloatToStr(MinValue(Vol4T)) + ' °C';
      ResultGrid.Cells[4, 4] := FloatToStr(MaxValue(Vol4T)) + ' °C';
    end;
    if DerobModel.HouseProperties.IntValue['nvol'] = 5 then
    begin
      ResultGrid.Cells[0, 5] := 'Volym 5';
      ResultGrid.Cells[1, 5] :=
        FloatToStr(Round(Mean(Vol5T) * 10) / 10) + ' °C';
      ResultGrid.Cells[2, 5] := '------';
      ResultGrid.Cells[3, 5] := FloatToStr(MinValue(Vol5T)) + ' °C';
      ResultGrid.Cells[4, 5] := FloatToStr(MaxValue(Vol5T)) + ' °C';
    end;
  end;
end;

procedure TForm5.UpdateChart;

var

  i: Integer;

begin // Med inglasning- linje
  Chart1.Series[0].Clear;
  Chart1.Series[1].Clear;
  Chart1.Series[2].Clear;
  Chart1.Series[3].Clear;
  if DerobModel.VentilationProperties.BoolValue['GlazeTemp'] = True then
  begin
    Chart1.Series[4].Clear;
  end;

  if URadioButton.IsChecked = True then
  begin
    Chart1.LeftAxis.Title.Caption := 'Timmar';
    Chart1.RightAxis.Title.Caption := 'U*';

    With Chart1.Series[2] Do
    begin
      for i := 0 to USteg - 1 do
      begin
        AddXY(UIntervall[i], UTime[i], '', clTeeColor);
      end;
    end;
  end
  else if EtaRadioButton.IsChecked = True then
  begin
    Chart1.LeftAxis.Title.Caption := 'Timmar';
    Chart1.RightAxis.Title.Caption := 'Eta*';

    With Chart1.Series[3] Do
    begin
      for i := 0 to EtaSteg - 1 do
      begin
        AddXY(EtaIntervall[i], EtaTime[i], '', clTeeColor);
      end;
    end;
  end
  else if HeatRadioButton.IsChecked = True then
  begin
    Chart1.LeftAxis.Title.Caption := 'Energibehov';
    Chart1.BottomAxis.Title.Caption := 'Månad';

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
  else if TempRadioButton.IsChecked = True then
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
    if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
    begin

      With Chart1.Series[4] Do
      Begin
        for i := 0 to intervall do
        begin
          AddXY(Temp[i], TimeGlaze[i], '', clTeeColor);
        end;
      end;
    end;
  end;
  // Utan inglasning-linjen
  if DerobModel.VentilationProperties.BoolValue['GlazeTemp'] = True then
  begin
    Chart1.Series[4].Clear;
  end;
  if HeatRadioButton.IsChecked = True then
  begin

    With Chart1.Series[1] Do
    Begin
      AddXY(1, HeatJanNoGl, '', clTeeColor);
      AddXY(2, HeatFebNoGl, '', clTeeColor);
      AddXY(3, HeatMarNoGl, '', clTeeColor);
      AddXY(4, HeatAprNoGl, '', clTeeColor);
      AddXY(5, HeatMayNoGl, '', clTeeColor);
      AddXY(6, HeatJunNoGl, '', clTeeColor);
      AddXY(7, HeatJulNoGl, '', clTeeColor);
      AddXY(8, HeatAugNoGl, '', clTeeColor);
      AddXY(9, HeatSepNoGl, '', clTeeColor);
      AddXY(10, HeatOctNoGl, '', clTeeColor);
      AddXY(11, HeatNovNoGl, '', clTeeColor);
      AddXY(12, HeatDecNoGl, '', clTeeColor);
    end;
  end
  else if TempRadioButton.IsChecked = True then
  begin
    With Chart1.Series[1] Do
    Begin
      for i := 0 to intervall do
      begin
        AddXY(Temp[i], TimeNoGl[i], '', clTeeColor);
      end;
    end;
  end;
end;

procedure TForm5.URadioButtonChange(Sender: TObject);
begin
  if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
  begin

    GlazeTemp.ShowInLegend := False;
  end;
  Chart1.Series[0].ShowInLegend := False;
  Chart1.Series[1].ShowInLegend := False;
  UpdateChart;
  ULine.ShowInLegend := True;
  EtaLine.ShowInLegend := False;

end;

end.
