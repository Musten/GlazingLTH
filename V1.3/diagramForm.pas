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
    Series2: TFastLineSeries;
    Series1: TFastLineSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure GlazeDiagramButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDerobModel: TDerobModel;
    procedure SetDerobModel(const Value: TDerobModel);
    procedure GlazeChart;
    procedure NoGlazeChart;
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
Label2.Text:='';
Label4.Text:='';
HeatRadioButton.IsChecked:=False;
TempRadioButton.IsChecked:=False;
end;

procedure TForm5.GlazeChart;
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
  i, SkipLine: integer;
  IgnoreText: Boolean;
  TempJanSummer, TempMarSummer, TempJanWinter, TempMarWinter, TempMaySummer,
    TempMayWinter, TempJulSummer, TempJulWinter, TempAugWinter, TempAugSummer,
    TempOctSummer, TempOctWinter, TempDecSummer, TempDecWinter: array of Real;
  TempFebSummer, TempFebWinter: array of Real;

  TempAprSummer, TempAprWinter, TempJunSummer, TempJunWinter, TempSepWinter,
    TempSepSummer, TempNovWinter, TempNovSummer: array of Real;

  HeatJanSummer, HeatMarSummer, HeatJanWinter, HeatMarWinter, HeatMaySummer,
    HeatMayWinter, HeatJulSummer, HeatJulWinter, HeatAugWinter, HeatAugSummer,
    HeatOctSummer, HeatOctWinter, HeatDecSummer, HeatDecWinter: array of Real;

  HeatFebSummer, HeatFebWinter: array of Real;

  HeatAprSummer, HeatAprWinter, HeatJunSummer, HeatJunWinter, HeatSepWinter,
    HeatSepSummer, HeatNovWinter, HeatNovSummer: array of Real;

  Hour, Temp, Heat, TempSummer, TempWinter: array of Real;

  meanJan, meanFeb, meanMar, meanApr, meanMay, meanJun, meanJul, meanAug,
    meanSep, meanOct, meanNov, meanDec: Real;

  HeatJan, HeatFeb, HeatMar, HeatApr, HeatMay, HeatJun, HeatJul, HeatAug,
    HeatSep, HeatOct, HeatNov, HeatDec, totalHeat: Real;
begin
  SkipLine := 12;
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

  SetLength(Temp, 8760);
  SetLength(Heat, 8760);

  SetLength(TempJanSummer, 744);
  SetLength(TempFebSummer, 672);
  SetLength(TempMarSummer, 744);
  SetLength(TempAprSummer, 720);
  SetLength(TempMaySummer, 744);
  SetLength(TempJunSummer, 720);
  SetLength(TempJulSummer, 744);
  SetLength(TempAugSummer, 744);
  SetLength(TempSepSummer, 720);
  SetLength(TempOctSummer, 744);
  SetLength(TempNovSummer, 720);
  SetLength(TempDecSummer, 744);
  SetLength(TempJanWinter, 744);
  SetLength(TempFebWinter, 672);
  SetLength(TempMarWinter, 744);
  SetLength(TempAprWinter, 720);
  SetLength(TempMayWinter, 744);
  SetLength(TempJunWinter, 720);
  SetLength(TempJulWinter, 744);
  SetLength(TempAugWinter, 744);
  SetLength(TempSepWinter, 720);
  SetLength(TempOctWinter, 744);
  SetLength(TempNovWinter, 720);
  SetLength(TempDecWinter, 744);
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
        TempSummer[i-SkipLine] := Temp2Summer[i-SkipLine];
        TempWinter[i-SkipLine] := Temp2Winter[i-SkipLine];
      end;
      if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 3 then
      begin
        TempSummer[i-SkipLine] := Temp3Summer[i-SkipLine];
        TempWinter[i-SkipLine] := Temp3Winter[i-SkipLine];
      end;
      if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 4 then
      begin
        TempSummer[i-SkipLine] := Temp4Summer[i-SkipLine];
        TempWinter[i-SkipLine] := Temp4Winter[i-SkipLine];
      end;
      if DerobModel.HouseProperties.IntValue['ChosenGlaze'] = 5 then
      begin
        TempSummer[i-SkipLine] := Temp5Summer[i-SkipLine];
        TempWinter[i-SkipLine] := Temp5Winter[i-SkipLine];
      end;
    end
    else
    begin
      TempSummer[i-SkipLine]:=Temp1Summer[i-SkipLine];
      TempWinter[i-SkipLine]:=Temp1Winter[i-SkipLine];
    end;
    end;



  end;
  CloseFile(Summer);
  CloseFile(Winter);

  // Sparar ner temperaturer och v�rmeanv�ndning m�nadsvis
  for i := 0 to 743 do
  begin
    TempJanSummer[i] := TempSummer[i];
    TempJanWinter[i] := TempWinter[i];
    HeatJanSummer[i] := Heat1Summer[i];
    HeatJanWinter[i] := Heat1Winter[i];
  end;
  for i := 744 to 1415 do
  begin
    TempFebSummer[i - 744] := TempSummer[i];
    TempFebWinter[i - 744] := TempWinter[i];
    HeatFebSummer[i - 744] := Heat1Summer[i];
    HeatFebWinter[i - 744] := Heat1Winter[i];
  end;
  for i := 1416 to 2159 do
  begin
    TempMarSummer[i - 1416] := TempSummer[i];
    TempMarWinter[i - 1416] := TempWinter[i];
    HeatMarSummer[i - 1416] := Heat1Summer[i];
    HeatMarWinter[i - 1416] := Heat1Winter[i];
  end;
  for i := 2160 to 2879 do
  begin
    TempAprSummer[i - 2160] := TempSummer[i];
    TempAprWinter[i - 2160] := TempWinter[i];
    HeatAprSummer[i - 2160] := Heat1Summer[i];
    HeatAprWinter[i - 2160] := Heat1Winter[i];
  end;
  for i := 2880 to 3623 do
  begin
    TempMaySummer[i - 2880] := TempSummer[i];
    TempMayWinter[i - 2880] := TempWinter[i];
    HeatMaySummer[i - 2880] := Heat1Summer[i];
    HeatMayWinter[i - 2880] := Heat1Winter[i];
  end;
  for i := 3624 to 4343 do
  begin
    TempJunSummer[i - 3624] := TempSummer[i];
    TempJunWinter[i - 3624] := TempWinter[i];
    HeatJunSummer[i - 3624] := Heat1Summer[i];
    HeatJunWinter[i - 3624] := Heat1Winter[i];
  end;
  for i := 4344 to 5087 do
  begin
    TempJulSummer[i - 4344] := TempSummer[i];
    TempJulWinter[i - 4344] := TempWinter[i];
    HeatJulSummer[i - 4344] := Heat1Summer[i];
    HeatJulWinter[i - 4344] := Heat1Winter[i];
  end;
  for i := 5088 to 5831 do
  begin
    TempAugSummer[i - 5088] := TempSummer[i];
    TempAugWinter[i - 5088] := TempWinter[i];
    HeatAugSummer[i - 5088] := Heat1Summer[i];
    HeatAugWinter[i - 5088] := Heat1Winter[i];
  end;
  for i := 5832 to 6551 do
  begin
    TempSepSummer[i - 5832] := TempSummer[i];
    TempSepWinter[i - 5832] := TempWinter[i];
    HeatSepSummer[i - 5832] := Heat1Summer[i];
    HeatSepWinter[i - 5832] := Heat1Winter[i];
  end;
  for i := 6552 to 7295 do
  begin
    TempOctSummer[i - 6552] := TempSummer[i];
    TempOctWinter[i - 6552] := TempWinter[i];
    HeatOctSummer[i - 6552] := Heat1Summer[i];
    HeatOctWinter[i - 6552] := Heat1Winter[i];
  end;
  for i := 7296 to 8015 do
  begin
    TempNovSummer[i - 7296] := TempSummer[i];
    TempNovWinter[i - 7296] := TempWinter[i];
    HeatNovSummer[i - 7296] := Heat1Summer[i];
    HeatNovWinter[i - 7296] := Heat1Winter[i];
  end;
  for i := 8016 to 8759 do
  begin
    TempDecSummer[i - 8016] := TempSummer[i];
    TempDecWinter[i - 8016] := TempWinter[i];
    HeatDecSummer[i - 8016] := Heat1Summer[i];
    HeatDecWinter[i - 8016] := Heat1Winter[i];
  end;
  // Loop �ver alla timmar med koll f�r vilket fall som skall anv�ndas
  for i := 0 to 8759 do
  begin
    if TempWinter[i] > DerobModel.HouseProperties.IntValue['TMaxRoom'] then
    begin
      Temp[i] := TempSummer[i];
      Heat[i] := Heat1Summer[i];
    end
    else
    begin
      Temp[i] := TempWinter[i];
      Heat[i] := Heat1Winter[i];
    end;

    // Sparar ner temperaturer f�r 'r�tt' fall m�nadsvis
    if i < 744 then
    begin
      meanJan := meanJan + Temp[i];
      HeatJan := HeatJan + Heat[i];
    end;
    if (i > 743) and (i < 1416) then
    begin
      meanFeb := meanFeb + Temp[i];
      HeatFeb := HeatFeb + Heat[i];
    end;
    if (i > 1415) and (i < 2160) then
    begin
      meanMar := meanMar + Temp[i];
      HeatMar := HeatMar + Heat[i];
    end;
    if (i > 2159) and (i < 2880) then
    begin
      meanApr := meanApr + Temp[i];
      HeatApr := HeatApr + Heat[i];
    end;
    if (i > 2879) and (i < 3624) then
    begin
      meanMay := meanMay + Temp[i];
      HeatMay := HeatMay + Heat[i];
    end;
    if (i > 3623) and (i < 4344) then
    begin
      meanJun := meanJun + Temp[i];
      HeatJun := HeatJun + Heat[i];
    end;
    if (i > 4343) and (i < 5088) then
    begin
      meanJul := meanJul + Temp[i];
      HeatJul := HeatJul + Heat[i];
    end;
    if (i > 5087) and (i < 5832) then
    begin
      meanAug := meanAug + Temp[i];
      HeatAug := HeatAug + Heat[i];
    end;
    if (i > 5831) and (i < 6552) then
    begin
      meanSep := meanSep + Temp[i];
      HeatSep := HeatSep + Heat[i];
    end;
    if (i > 6551) and (i < 7296) then
    begin
      meanOct := meanOct + Temp[i];
      HeatOct := HeatOct + Heat[i];
    end;
    if (i > 7295) and (i < 8016) then
    begin
      meanNov := meanNov + Temp[i];
      HeatNov := HeatNov + Heat[i];
    end;
    if i > 8015 then
    begin
      meanDec := meanDec + Temp[i];
      HeatDec := HeatDec + Heat[i];
    end;
  end;
  totalHeat := HeatJan + HeatFeb + HeatMar + HeatApr + HeatMay + HeatJun +
    HeatJul + HeatAug + HeatSep + HeatOct + HeatNov + HeatDec;
  // Uppritning av temperatur- eller v�rmediagram
  if TempRadioButton.IsChecked = true then
  begin
Chart1.LeftAxis.Title.Caption := 'Temperatur';
  Chart1.BottomAxis.Title.Caption:='M�nad';
    // Medelv�rden f�r de olika m�naderna
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
    With Chart1.Series[0] Do
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
Chart1.LeftAxis.Title.Caption := 'Energi';
  Chart1.BottomAxis.Title.Caption:='M�nad';
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
  end;
  Label2.Text :=  FloatToStr(Round(totalHeat/1000))+ ' kWh/�r';

end;

procedure TForm5.GlazeDiagramButtonClick(Sender: TObject);
begin
  GlazeChart;
  NoGlazeChart;
end;

procedure TForm5.NoGlazeChart;
var
  NoGlaze: TextFile;
  DataFile: TStringList;
  VolPath, StartDir: String;
  buffer: String;
  Hour, OutTemp, GlobalRadiation, Temp1, OpTemp1, Heat1, Temp: array of Real;
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

  Label4.Text := FloatToStr(Round(totalHeat/1000))+ ' kWh/�r';
end;

procedure TForm5.SetDerobModel(const Value: TDerobModel);
begin
  FDerobModel := Value;
end;

end.
