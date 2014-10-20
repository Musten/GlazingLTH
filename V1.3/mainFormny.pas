unit mainFormny;
          //Testar
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox, FMX.Colors, FMX.Menus, FMX.TreeView,
  System.Actions, FMX.ActnList, FMX.Objects, FMX.Edit, ShellApi, Windows,
  constructionForm, internalheatForm, AbsorptionEmissionForm, derob,
  diagramForm,
  FMX.Controls3D, FMX.Objects3D, FMX.Viewport3D, FMX.MaterialSources,
  FMX.MagnifierGlass, derobConvert, System.IOUtils,
  Winapi.Messages;

type

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    TreeView1: TTreeView;
    Geometry: TTreeViewItem;
    EnergyBalance: TTreeViewItem;
    Climate: TTreeViewItem;
    Properties: TTreeViewItem;
    mainMenuFile: TMenuItem;
    resultMenuChart: TMenuItem;
    simulateMenuCalculate: TMenuItem;
    fileMenuNew: TMenuItem;
    fileMenuSave: TMenuItem;
    fileMenuLoad: TMenuItem;
    ImagePanel: TPanel;
    GeometryPanel: TPanel;
    Image2: TImage;
    GeoHouseLabel: TLabel;
    GeoWindowLabel: TLabel;
    GeoGlazeLabel: TLabel;
    HouseLabel1: TLabel;
    HouseLabel2: TLabel;
    HouseLabel3: TLabel;
    HouseNumberBox1: TNumberBox;
    HouseNumberBox2: TNumberBox;
    HouseNumberBox3: TNumberBox;
    HousemLabel1: TLabel;
    HousemLabel2: TLabel;
    HousemLabel3: TLabel;
    PropertiesPanel: TPanel;
    WindowCheckBox1: TCheckBox;
    WindowCheckBox2: TCheckBox;
    WindowCheckBox3: TCheckBox;
    WindowCheckBox4: TCheckBox;
    GlazeCheckBox1: TCheckBox;
    GlazeCheckBox2: TCheckBox;
    GlazeCheckBox3: TCheckBox;
    GlazeCheckBox4: TCheckBox;
    WindowNumberBox1: TNumberBox;
    WindowNumberBox3: TNumberBox;
    WindowNumberBox5: TNumberBox;
    WindowNumberBox7: TNumberBox;
    WindowNumberBox2: TNumberBox;
    WindowNumberBox4: TNumberBox;
    WindowNumberBox6: TNumberBox;
    WindowNumberBox8: TNumberBox;
    GlazeNumberBox1: TNumberBox;
    GlazeNumberBox2: TNumberBox;
    GlazeNumberBox3: TNumberBox;
    GlazeNumberBox4: TNumberBox;
    WindowmLabel1: TLabel;
    WindowmLabel2: TLabel;
    WindowmLabel3: TLabel;
    WindowmLabel4: TLabel;
    GlazemLabel1: TLabel;
    GlazemLabel2: TLabel;
    GlazemLabel3: TLabel;
    GlazemLabel4: TLabel;
    WindowLabel2: TLabel;
    WindowLabel4: TLabel;
    WindowLabel6: TLabel;
    WindowLabel8: TLabel;
    WindowLabel1: TLabel;
    WindowLabel3: TLabel;
    WindowLabel5: TLabel;
    WindowLabel7: TLabel;
    GlazeLabel1: TLabel;
    GlazeLabel2: TLabel;
    GlazeLabel3: TLabel;
    GlazeLabel4: TLabel;
    PropRoofLabel: TLabel;
    RoofLabel: TLabel;
    FloorLabel: TLabel;
    WallLabel: TLabel;
    GlazeLabel: TLabel;
    WindowLabel: TLabel;
    RoofComboBox: TComboBox;
    FloorComboBox: TComboBox;
    WallComboBox: TComboBox;
    GlazeComboBox: TComboBox;
    WindowComboBox: TComboBox;
    PropWallLabel: TLabel;
    PropConstrButton: TButton;
    PropSaveButton: TButton;
    fileMenuClose: TMenuItem;
    GeoSaveButton: TButton;
    GeoClearButton: TButton;
    Viewport3D1: TViewport3D;
    ColorMaterialSource3: TColorMaterialSource;
    ColorMaterialSource4: TColorMaterialSource;
    Rectangle3D6: TRectangle3D;
    ColorMaterialSource6: TColorMaterialSource;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    PropAbsLabel: TLabel;
    AbsComboBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    AbsNumberBox1: TNumberBox;
    AbsNumberBox2: TNumberBox;
    EmittNumberBox1: TNumberBox;
    EmittNumberBox2: TNumberBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    FloorListBoxItem: TListBoxItem;
    NWallListBoxItem: TListBoxItem;
    EWallListBoxItem: TListBoxItem;
    SWallListBoxItem: TListBoxItem;
    WWallListBoxItem: TListBoxItem;
    RoofListBoxItem: TListBoxItem;
    EnergyPanel: TPanel;
    TempMaxNumberBox: TNumberBox;
    TempMinNumberBox: TNumberBox;
    IntHeatNumberBox: TNumberBox;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    InternalHeatButton: TButton;
    Label16: TLabel;
    Label17: TLabel;
    FlowNumberBox: TNumberBox;
    Label18: TLabel;
    ClimatePanel: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    OrientationTrackBar: TTrackBar;
    Label23: TLabel;
    Label24: TLabel;
    OrientationNumberBox: TNumberBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    LatitudeNumberBox: TNumberBox;
    LongitudeNumberBox: TNumberBox;
    TimeMeridianNumberBox: TNumberBox;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    AbsorptionButton: TButton;
    RoomTempRadioButton: TRadioButton;
    GlazeTempRadioButton: TRadioButton;
    Label9: TLabel;
    EfficiencyNumberBox: TNumberBox;
    Label19: TLabel;
    Label20: TLabel;
    Label39: TLabel;
    LeakNumberBox1: TNumberBox;
    LeakNumberBox2: TNumberBox;
    LeakNumberBox3: TNumberBox;
    LeakNumberBox4: TNumberBox;
    LeakNumberBox5: TNumberBox;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    IntGlazeCheckBox1: TCheckBox;
    Label49: TLabel;
    IntGlazeCheckBox2: TCheckBox;
    EnergySaveButton: TButton;
    ClimateSaveButton: TButton;
    Image1: TImage;
    Label51: TLabel;
    Button1: TButton;
    Viewport3D2: TViewport3D;
    Rectangle1: TRectangle;
    Button2: TButton;
    FromYearLabel: TLabel;
    FromMonthLabel: TLabel;
    FromDayLabel: TLabel;
    ToYearLabel: TLabel;
    ToMonthLabel: TLabel;
    ToDayLabel: TLabel;
    Label25: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    resultMenuVisualization: TMenuItem;
    Label55: TLabel;
    GlazeControlComboBox: TComboBox;
    ClimateComboBox: TComboBox;
    mainMenuSimulate: TMenuItem;
    mainMenuResult: TMenuItem;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    procedure WindowCheckBox1Change(Sender: TObject);
    procedure WindowCheckBox2Change(Sender: TObject);
    procedure WindowCheckBox3Change(Sender: TObject);
    procedure WindowCheckBox4Change(Sender: TObject);
    procedure GlazeCheckBox1Change(Sender: TObject);
    procedure GlazeCheckBox2Change(Sender: TObject);
    procedure GlazeCheckBox3Change(Sender: TObject);
    procedure GlazeCheckBox4Change(Sender: TObject);
    procedure GeometryClick(Sender: TObject);
    procedure PropertiesClick(Sender: TObject);
    procedure PropConstrButtonClick(Sender: TObject);
    procedure fileMenuCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GeoSaveButtonClick(Sender: TObject);
    procedure fileMenuSaveClick(Sender: TObject);
    procedure fileMenuLoadClick(Sender: TObject);
    procedure resultMenuChartClick(Sender: TObject);
    procedure simulateMenuCalculateClick(Sender: TObject);
    procedure PropSaveButtonClick(Sender: TObject);
    procedure GeoClearButtonClick(Sender: TObject);
    procedure EnergyBalanceClick(Sender: TObject);
    procedure InternalHeatButtonClick(Sender: TObject);
    procedure ClimateClick(Sender: TObject);
    procedure OrientationTrackBarChange(Sender: TObject);
    procedure AbsorptionButtonClick(Sender: TObject);
    procedure EnergySaveButtonClick(Sender: TObject);
    procedure AbsComboBoxChange(Sender: TObject);
    procedure ClimateSaveButtonClick(Sender: TObject);
    procedure fileMenuNewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure resultMenuVisualizationClick(Sender: TObject);
    procedure mainMenuDeleteFilesClick(Sender: TObject);
    procedure GlazeTempRadioButtonChange(Sender: TObject);
    procedure ClimateComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
    FDerobModel: TDerobModel;
    FRoofProperties: TRoofProperties;
    FFloorProperties: TFloorProperties;
    FWallProperties: TWallProperties;
    FWindowProperties: TWindowProperties;
    FSurface: TSurface;
    FExecThread: TExecThread;
    FCurrentCategory: string;
    FConvertDerob: TDerobConvert;
    procedure SetDerobModel(const Value: TDerobModel);
    procedure SetFloorProperties(const Value: TFloorProperties);
    procedure SetRoofProperties(const Value: TRoofProperties);
    procedure SetWallProperties(const Value: TWallProperties);
    procedure SetWindowProperties(const Value: TWindowProperties);
    procedure UpdateGeometryPanel;
    procedure SetSurface(const Value: TSurface);
    procedure UpdatePropertiesPanel;
    procedure UpdateConstructionList;
    procedure UpdateLayerList;
    procedure UpdateMaterialList;
    procedure UpdateEnergyPanel;
    procedure UpdateAbsorption;
    procedure UpdateClimatePanel;
    procedure LoadGlasses;
    procedure LoadGas;
    procedure LoadMaterials;
    procedure LoadGlassConstructions;
    procedure SetCurrentCategory(const Value: string);
    procedure VolumeCount;
    procedure UpdateClimate;
    procedure SaveConstructionNames;
    procedure OnExecute;
    procedure OnExecuteFinished;
    procedure mainHide;
    procedure mainUpdateComboBox;
    procedure mainGeometrySave;
    procedure mainPropertiesSave;
    procedure GeometryClear;
    procedure mainClimateSave;
    procedure IntheatVent;
    procedure mainEnergySave;
    procedure ChangeAbsCombo;
    procedure ClearGlaze;
    procedure DefaultAbsorption;
    procedure LoadClimateFiles;
    procedure SetConvertDerob(const Value: TDerobConvert);
  public
    pressed: boolean;
    nvol, advec: integer;
    StartDir, CaseDir, ClimateFile: string;
    { Public declarations }
    property DerobModel: TDerobModel read FDerobModel write SetDerobModel;
    property FloorProperties: TFloorProperties read FFloorProperties
      write SetFloorProperties;
    property WallProperties: TWallProperties read FWallProperties
      write SetWallProperties;
    property RoofProperties: TRoofProperties read FRoofProperties
      write SetRoofProperties;
    property WindowProperties: TWindowProperties read FWindowProperties
      write SetWindowProperties;
    property CurrentCategory: string read FCurrentCategory
      write SetCurrentCategory;
    property Surface: TSurface read FSurface write SetSurface;
    property ConvertDerob: TDerobConvert read FConvertDerob
      write SetConvertDerob;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.mainHide;
begin
  GeometryPanel.Visible := False;
  PropertiesPanel.Visible := False;
  EnergyPanel.Visible := False;
  ClimatePanel.Visible := False;
  Label51.Visible := False;
  Image1.Visible := False;
end;

procedure TForm1.mainPropertiesSave;
begin
  DerobModel.HouseProperties.IntValue['RoofHolder'] := RoofComboBox.ItemIndex;
  DerobModel.HouseProperties.IntValue['FloorHolder'] := FloorComboBox.ItemIndex;

  DerobModel.HouseProperties.IntValue['WallHolder'] := WallComboBox.ItemIndex;
  DerobModel.HouseProperties.IntValue['GlazeHolder'] := GlazeComboBox.ItemIndex;
  DerobModel.HouseProperties.IntValue['WindowHolder'] :=
    WindowComboBox.ItemIndex;
end;

procedure TForm1.GeometryClear;
begin
  // Clearing all variables and setting them to zero

  Surface.Length := 0;
  Surface.Width := 0;
  Surface.Height := 0;

  HouseNumberBox1.Value := Surface.Length;
  HouseNumberBox2.Value := Surface.Width;
  HouseNumberBox3.Value := Surface.Height;
  WindowNumberBox1.Value := 0;
  WindowNumberBox2.Value := 0;
  GlazeNumberBox1.Value := 0;
  WindowNumberBox3.Value := 0;
  WindowNumberBox4.Value := 0;
  GlazeNumberBox2.Value := 0;
  WindowNumberBox5.Value := 0;
  WindowNumberBox6.Value := 0;
  GlazeNumberBox3.Value := 0;
  WindowNumberBox7.Value := 0;
  WindowNumberBox8.Value := 0;
  GlazeNumberBox4.Value := 0;

  WindowCheckBox1.IsChecked := False;
  WindowCheckBox2.IsChecked := False;
  WindowCheckBox3.IsChecked := False;
  WindowCheckBox4.IsChecked := False;
  GlazeCheckBox1.IsChecked := False;
  GlazeCheckBox2.IsChecked := False;
  GlazeCheckBox3.IsChecked := False;
  GlazeCheckBox4.IsChecked := False;

  Rectangle3D6.Visible := False;
  Rectangle3D6.Width := HouseNumberBox1.Value;
  Rectangle3D6.Depth := HouseNumberBox2.Value;
  Rectangle3D6.Height := HouseNumberBox3.Value;

  mainGeometrySave;

end;

procedure TForm1.mainClimateSave;
begin
  DerobModel.HouseProperties.IntValue['LocationIndex'] :=
    ClimateComboBox.ItemIndex;
  DerobModel.HouseProperties.IntValue['Rotation'] :=
    Round(OrientationNumberBox.Value);
  DerobModel.HouseProperties.DoubleValue['Latitude'] := LatitudeNumberBox.Value;
  DerobModel.HouseProperties.IntValue['FromYear'] :=
    StrToInt(FromYearLabel.Text);
  DerobModel.HouseProperties.IntValue['FromMonth'] :=
    StrToInt(FromMonthLabel.Text);
  DerobModel.HouseProperties.IntValue['FromDay'] := StrToInt(FromDayLabel.Text);
  DerobModel.HouseProperties.IntValue['ToYear'] := StrToInt(ToYearLabel.Text);
  DerobModel.HouseProperties.IntValue['ToMonth'] := StrToInt(ToMonthLabel.Text);
  DerobModel.HouseProperties.IntValue['ToDay'] := StrToInt(ToDayLabel.Text);
  // OBS t�nk p� att m�nader och dagar b�rjar p� 0. ItemIndex 0 = Januari
  // ItemIndex 30 = 31:a

end;

procedure TForm1.mainEnergySave;
begin
  DerobModel.HouseProperties.IntValue['TMinRoom'] :=
    Round(TempMinNumberBox.Value);
  // Om innetemperatur i volym 1 v�ljs
  if RoomTempRadioButton.IsChecked then
  begin
    DerobModel.HouseProperties.BoolValue['RoomTemp'] := True;
    DerobModel.HouseProperties.IntValue['TMaxRoom'] :=
      Round(TempMaxNumberBox.Value);
  end
  else
  begin
    DerobModel.HouseProperties.BoolValue['RoomTemp'] := False;
  end;
  // annars �r det volym i inglasning
  if (GlazeTempRadioButton.IsChecked) and (GlazeControlComboBox.ItemIndex > -1)
  then
  begin
    DerobModel.HouseProperties.IntValue['ChosenGlaze'] :=
      GlazeControlComboBox.ItemIndex + 2;
    DerobModel.HouseProperties.BoolValue['GlazeTemp'] := True;
    DerobModel.HouseProperties.IntValue['TMaxGlaze'] :=
      Round(TempMaxNumberBox.Value);
  end
  else
  begin
    DerobModel.HouseProperties.BoolValue['GlazeTemp'] := False;
  end;

  DerobModel.HouseProperties.IntValue['IntHeat'] :=
    Round(IntHeatNumberBox.Value);
  DerobModel.HouseProperties.IntValue['Persons'] :=
    Round(Form3.PersonSpinBox.Value);
  DerobModel.HouseProperties.IntValue['Appliances'] :=
    Round(Form3.AppliancesSpinBox.Value);
  DerobModel.HouseProperties.IntValue['Lamps'] :=
    Round(Form3.OthersNumberBox.Value);

  if FlowNumberBox.Value <> 0 then
  begin
    DerobModel.VentilationProperties.DoubleValue['Flow'] := FlowNumberBox.Value;
  end;

  DerobModel.VentilationProperties.DoubleValue['Eta'] :=
    EfficiencyNumberBox.Value;

  if IntGlazeCheckBox1.IsChecked then
  begin
    DerobModel.VentilationProperties.BoolValue['AutoOpening'] := True;
  end
  else
  begin
    DerobModel.VentilationProperties.BoolValue['AutoOpening'] := False;
  end;

  if IntGlazeCheckBox2.IsChecked then
  begin
    DerobModel.VentilationProperties.BoolValue['AdvectionConnection'] := True;
  end
  else
  begin
    DerobModel.VentilationProperties.BoolValue['AdvectionConnection'] := False;
  end;

  DerobModel.VentilationProperties.DoubleValue['Leak1'] := LeakNumberBox1.Value;

  if LeakNumberBox2.Enabled = True then
  begin
    DerobModel.VentilationProperties.DoubleValue['Leak2'] :=
      LeakNumberBox2.Value;
  end;
  if LeakNumberBox3.Enabled = True then
  begin
    DerobModel.VentilationProperties.DoubleValue['Leak3'] :=
      LeakNumberBox3.Value;
  end;
  if LeakNumberBox4.Enabled = True then
  begin
    DerobModel.VentilationProperties.DoubleValue['Leak4'] :=
      LeakNumberBox4.Value;
  end;
  if LeakNumberBox5.Enabled = True then
  begin
    DerobModel.VentilationProperties.DoubleValue['Leak5'] :=
      LeakNumberBox5.Value;
  end;
end;

procedure TForm1.mainGeometrySave;
var
  i: integer;
begin
  ClearGlaze;
  if (HouseNumberBox1.Value <> 0) and (HouseNumberBox2.Value <> 0) and
    (HouseNumberBox3.Value <> 0) then
  begin

    Surface.Length := HouseNumberBox1.Value;
    Surface.Width := HouseNumberBox2.Value;
    Surface.Height := HouseNumberBox3.Value;
  end;

  { ---------------------
    ------North Wall-----
    --------------------- }
  DerobModel.Walls[0].Name := 'NorthWall';
  DerobModel.Walls[0].Width := HouseNumberBox2.Value;
  DerobModel.Walls[0].Height := HouseNumberBox3.Value;

  if WindowCheckBox1.IsChecked and (WindowNumberBox1.Value <> 0) and
    (WindowNumberBox2.Value <> 0) then
  begin
    DerobModel.Walls[0].Properties.BoolValue['HoleNorth'] := True;
    DerobModel.Windows[0].Name := 'NorthWindow';
    DerobModel.Windows[0].Width := WindowNumberBox1.Value;
    DerobModel.Windows[0].Height := WindowNumberBox2.Value;
  end
  else
  begin
    DerobModel.Walls[0].Properties.BoolValue['HoleNorth'] := False;
  end;

  if GlazeCheckBox1.IsChecked and (GlazeNumberBox1.Value <> 0) then
  begin
    DerobModel.GlazingProperties.BoolValue['GlazingNorth'] := True;
    for i := DerobModel.GlazingCount to DerobModel.GlazingCount + 4 do
    begin
      DerobModel.AddGlazing(TGlazing.Create); // Skapar Nordinglasning 5st
      DerobModel.Glazing[i].Name := 'North' + IntToStr(i); // Namnger samtliga
    end;
    DerobModel.GlazingProperties.DoubleValue['CavityNorth'] :=
      GlazeNumberBox1.Value;
    // Sparar Luftspaltens dimension f�r vald inglasning
  end
  else
  begin
    DerobModel.GlazingProperties.BoolValue['GlazingNorth'] := False;
  end;

  { ---------------------
    ------East Wall-----
    --------------------- }
  DerobModel.Walls[1].Name := 'EastWall';
  DerobModel.Walls[1].Length := HouseNumberBox1.Value;
  DerobModel.Walls[1].Height := HouseNumberBox3.Value;

  if WindowCheckBox2.IsChecked and (WindowNumberBox3.Value <> 0) and
    (WindowNumberBox4.Value <> 0) then
  begin
    DerobModel.Walls[1].Properties.BoolValue['HoleEast'] := True;
    DerobModel.Windows[1].Name := 'EastWindow';
    DerobModel.Windows[1].Width := WindowNumberBox3.Value;
    DerobModel.Windows[1].Height := WindowNumberBox4.Value;
  end
  else
  begin
    DerobModel.Walls[1].Properties.BoolValue['HoleEast'] := False;
  end;

  if GlazeCheckBox2.IsChecked and (GlazeNumberBox2.Value <> 0) then
  begin
    DerobModel.GlazingProperties.BoolValue['GlazingEast'] := True;
    for i := DerobModel.GlazingCount to DerobModel.GlazingCount + 4 do
    begin
      DerobModel.AddGlazing(TGlazing.Create);
      DerobModel.Glazing[i].Name := 'East' + IntToStr(i);
    end;
    DerobModel.GlazingProperties.DoubleValue['CavityEast'] :=
      GlazeNumberBox2.Value;
  end
  else
  begin
    DerobModel.GlazingProperties.BoolValue['GlazingEast'] := False;
  end;

  { ---------------------
    ------South Wall-----
    --------------------- }

  DerobModel.Walls[2].Name := 'SouthWall';
  DerobModel.Walls[2].Width := HouseNumberBox2.Value;
  DerobModel.Walls[2].Height := HouseNumberBox3.Value;

  if WindowCheckBox3.IsChecked and (WindowNumberBox5.Value <> 0) and
    (WindowNumberBox6.Value <> 0) then
  begin
    DerobModel.Walls[2].Properties.BoolValue['HoleSouth'] := True;
    DerobModel.Windows[2].Name := 'SouthWindow';
    DerobModel.Windows[2].Width := WindowNumberBox5.Value;
    DerobModel.Windows[2].Height := WindowNumberBox6.Value;
  end
  else
  begin
    DerobModel.Walls[2].Properties.BoolValue['HoleSouth'] := False;
  end;

  if GlazeCheckBox3.IsChecked and (GlazeNumberBox3.Value <> 0) then
  begin
    DerobModel.GlazingProperties.BoolValue['GlazingSouth'] := True;
    for i := DerobModel.GlazingCount to DerobModel.GlazingCount + 4 do
    begin
      DerobModel.AddGlazing(TGlazing.Create);
      DerobModel.Glazing[i].Name := 'South' + IntToStr(i);
    end;
    DerobModel.GlazingProperties.DoubleValue['CavitySouth'] :=
      GlazeNumberBox3.Value;
  end
  else
  begin
    DerobModel.GlazingProperties.BoolValue['GlazingSouth'] := False;
  end;

  { ---------------------
    ------West Wall------
    --------------------- }

  DerobModel.Walls[3].Name := 'WestWall';
  DerobModel.Walls[3].Length := HouseNumberBox1.Value;
  DerobModel.Walls[3].Height := HouseNumberBox3.Value;

  if WindowCheckBox4.IsChecked and (WindowNumberBox7.Value <> 0) and
    (WindowNumberBox8.Value <> 0) then
  begin
    DerobModel.Walls[3].Properties.BoolValue['HoleWest'] := True;
    DerobModel.Windows[3].Name := 'WestWindow';
    DerobModel.Windows[3].Width := WindowNumberBox7.Value;
    DerobModel.Windows[3].Height := WindowNumberBox8.Value;
  end
  else
  begin
    DerobModel.Walls[3].Properties.BoolValue['HoleWest'] := False;
  end;

  if GlazeCheckBox4.IsChecked and (GlazeNumberBox4.Value <> 0) then
  begin
    DerobModel.GlazingProperties.BoolValue['GlazingWest'] := True;
    for i := DerobModel.GlazingCount to DerobModel.GlazingCount + 4 do
    begin
      DerobModel.AddGlazing(TGlazing.Create);
      DerobModel.Glazing[i].Name := 'West' + IntToStr(i);
    end;
    DerobModel.GlazingProperties.DoubleValue['CavityWest'] :=
      GlazeNumberBox4.Value;
  end
  else
  begin
    DerobModel.GlazingProperties.BoolValue['GlazingWest'] := False;
  end;

  if (GlazeCheckBox1.IsChecked and (GlazeNumberBox1.Value <> 0)) and
    (GlazeCheckBox2.IsChecked and (GlazeNumberBox2.Value <> 0)) then
  begin
    DerobModel.GlazingProperties.BoolValue['NorthEast'] := True;
    DerobModel.RemoveGlazing(DerobModel.Glazing[2]);
    // DerobModel.GlazingProperties.BoolValue['GlazingNorth']:=False;
    // DerobModel.GlazingProperties.BoolValue['GlazingEast']:=False;
    for i := DerobModel.GlazingCount to DerobModel.GlazingCount + 3 do
    begin
      DerobModel.AddGlazing(TGlazing.Create);
      DerobModel.Glazing[i].Name := 'NorthEast' + IntToStr(i);
    end;
  end;

  if (GlazeCheckBox2.IsChecked and (GlazeNumberBox2.Value <> 0)) and
    (GlazeCheckBox3.IsChecked and (GlazeNumberBox3.Value <> 0)) then
  begin
    DerobModel.GlazingProperties.BoolValue['EastSouth'] := True;
    if DerobModel.GlazingProperties.BoolValue['GlazingNorth'] = True then
    begin
      DerobModel.RemoveGlazing(DerobModel.Glazing[7]);
    end
    else
    begin
      DerobModel.RemoveGlazing(DerobModel.Glazing[2]);
    end;
    // DerobModel.GlazingProperties.BoolValue['GlazingEast']:=False;
    // DerobModel.GlazingProperties.BoolValue['GlazingSouth']:=False;
    for i := DerobModel.GlazingCount to DerobModel.GlazingCount + 3 do
    begin
      DerobModel.AddGlazing(TGlazing.Create);
      DerobModel.Glazing[i].Name := 'EastSouth' + IntToStr(i);
    end;
  end;

  if (GlazeCheckBox3.IsChecked and (GlazeNumberBox3.Value <> 0)) and
    (GlazeCheckBox4.IsChecked and (GlazeNumberBox4.Value <> 0)) then
  begin
    DerobModel.GlazingProperties.BoolValue['SouthWest'] := True;
    if DerobModel.GlazingProperties.BoolValue['NorthEast'] = True then
    begin

      DerobModel.RemoveGlazing(DerobModel.Glazing[12]);
    end
    else if (DerobModel.GlazingProperties.BoolValue['GlazingNorth'] = True) or
      (DerobModel.GlazingProperties.BoolValue['GlazingEast'] = True) then
    begin
      DerobModel.RemoveGlazing(DerobModel.Glazing[7]);
    end
    else
    begin
      DerobModel.RemoveGlazing(DerobModel.Glazing[2]);
    end;

    // DerobModel.GlazingProperties.BoolValue['GlazingSouth']:=False;
    // DerobModel.GlazingProperties.BoolValue['GlazingWest']:=False;
    for i := DerobModel.GlazingCount to DerobModel.GlazingCount + 3 do
    begin
      DerobModel.AddGlazing(TGlazing.Create);
      DerobModel.Glazing[i].Name := 'SouthWest' + IntToStr(i);
    end;
  end;

  if (GlazeCheckBox4.IsChecked and (GlazeNumberBox4.Value <> 0)) and
    (GlazeCheckBox1.IsChecked and (GlazeNumberBox1.Value <> 0)) then
  begin
    DerobModel.GlazingProperties.BoolValue['WestNorth'] := True;
    DerobModel.RemoveGlazing(DerobModel.Glazing[17]);
    for i := DerobModel.GlazingCount to DerobModel.GlazingCount + 3 do
    begin
      DerobModel.AddGlazing(TGlazing.Create);
      DerobModel.Glazing[i].Name := 'WestNorth' + IntToStr(i);
    end;
  end;

  { ---------------------
    --------Roof---------
    --------------------- }

  DerobModel.Roofs[0].Name := 'Roof';
  DerobModel.Roofs[0].Length := HouseNumberBox1.Value;
  DerobModel.Roofs[0].Width := HouseNumberBox2.Value;

  { ---------------------
    --------Floor--------
    --------------------- }

  DerobModel.Floors[0].Name := 'Floor';
  DerobModel.Floors[0].Length := HouseNumberBox1.Value;
  DerobModel.Floors[0].Width := HouseNumberBox2.Value;

  { 3D drawing }
  // Draw solid cube (even though it's hollow, just for looks)   //KHOAN
  Rectangle3D6.Visible := True;
  Rectangle3D6.Width := HouseNumberBox1.Value;
  Rectangle3D6.Depth := HouseNumberBox2.Value;
  Rectangle3D6.Height := HouseNumberBox3.Value;

  Viewport3D1.Visible := True;

end;

procedure TForm1.mainUpdateComboBox;
var
  Construction: TConstruction;
  i: integer;
begin

  Self.RoofComboBox.Clear;
  Self.FloorComboBox.Clear;
  Self.WallComboBox.Clear;
  Self.GlazeComboBox.Clear;
  Self.WindowComboBox.Clear;

  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    Construction := DerobModel.Constructions[i];
    if Construction.StringValue['ConstructionType'] = 'Roof' then
    begin
      Self.RoofComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
    if Construction.StringValue['ConstructionType'] = 'Floor' then
    begin
      Self.FloorComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
    if Construction.StringValue['ConstructionType'] = 'Wall' then
    begin
      Self.WallComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
    if Construction.StringValue['ConstructionType'] = 'Window' then
    // Glaze same constructions as window
    begin
      Self.GlazeComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
    if Construction.StringValue['ConstructionType'] = 'Window' then
    begin
      Self.WindowComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
  end;
end;

procedure TForm1.resultMenuChartClick(Sender: TObject);
begin
  SetCurrentDir(StartDir);
  Form5.DerobModel := Self.DerobModel;
  Form5.Show;
end;

procedure TForm1.simulateMenuCalculateClick(Sender: TObject);
begin
  SetCurrentDir(StartDir); // NY
  DerobModel.HouseProperties.BoolValue['KGK'] := False;
  mainGeometrySave;
  VolumeCount;
  mainPropertiesSave;
  mainEnergySave;
  mainClimateSave;
  SaveConstructionNames;
  // Spara filen i aktuellt case-mapp
  SetCurrentDir('Cases/' + DerobModel.HouseProperties.StringValue['CaseName']);
  // Skapa en tempor�r sparfil om det blir n�got fel vid sparning
  DerobModel.Filename := 'Sparfil.bak';
  DerobModel.Save;
  // Ta bort den gamla filen om det inte �r n�got fel
  DeleteFile('Sparfil.dat');
  // D�p om den tempor�ra filen till r�tt format
  RenameFile('Sparfil.bak', 'Sparfil.dat');
  SetCurrentDir(StartDir);
  DerobModel.HouseProperties.StringValue['StartDir'] := StartDir;
  ConvertDerob.DerobModel := Self.DerobModel;
  ConvertDerob.Surface := Self.Surface;
  ConvertDerob.ConvertForLib;
  ConvertDerob.writeLibFile;
  ConvertDerob.ConvertForInput;
  ConvertDerob.writeInputFile;

  // Khoan, k�rning av exe filer

  // Start an execution thread instance

  FExecThread := TExecThread.Create;

  // Assign main execution method. Must not interact with forms or UI

  FExecThread.OnExecute := Self.OnExecute;

  // Assign callback function to be called when execution completes

  FExecThread.OnExecuteFinished := Self.OnExecuteFinished;

  // Start actual thread execution

  FExecThread.Start;

  // Disable start button     }

end;

procedure TForm1.fileMenuNewClick(Sender: TObject);
begin
  TreeView1.Enabled := True;
  TreeView1.HitTest := True;
  DerobModel.Destroy;
  FDerobModel := TDerobModel.Create;
  DefaultAbsorption;
  // �ndrad av Musten 17/7 - Ser till att man inte kan skapa ett Case som redan finns
  try
    DerobModel.HouseProperties.StringValue['CaseName'] :=
      InputBox('Ber�kningsfall', 'Namn:', DerobModel.HouseProperties.StringValue
      ['CaseName']);
    SetCurrentDir('Cases');
  finally
    if DirectoryExists(DerobModel.HouseProperties.StringValue['CaseName']) then
    begin
      ShowMessage('Fallet existerar redan, v.v. ladda fallet ist�llet.');
    end
    else
      DerobModel.HouseProperties.StringValue['CaseDir'] := GetCurrentDir;
    CreateDir(DerobModel.HouseProperties.StringValue['CaseName']);
    SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
    SetCurrentDir(StartDir);
  end;

  // ---------------------------------

  Rectangle3D6.Visible := False;
  Formatsettings.DecimalSeparator := '.';
  LoadGlasses;
  LoadGas;
  LoadMaterials;
  LoadGlassConstructions;
  mainUpdateComboBox;
end;

procedure TForm1.fileMenuSaveClick(Sender: TObject);
begin
  // �ndrad av Musten 17/7 - Sparar filerna i mappen f�r caset i "Cases" mappen
  SetCurrentDir(StartDir);
  SetCurrentDir('Cases');
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  SaveDialog.InitialDir := GetCurrentDir;
  SaveDialog.Filter := 'Sparfiler (.dat)|*.dat';
  // ------------------------------------

  mainGeometrySave;
  mainPropertiesSave;
  mainEnergySave;
  mainClimateSave;
  IntheatVent;
  DerobModel.Filename := 'Sparfil.dat';
  DerobModel.Save;

end;

procedure TForm1.fileMenuLoadClick(Sender: TObject);
begin
  // �ndrad av Musten 17/7 - �ppnar "Cases" mappen och kan endast v�lja .dat filer
  SetCurrentDir(StartDir);
  SetCurrentDir('Cases');
  OpenDialog.Filename := '';
  OpenDialog.InitialDir := GetCurrentDir;
  OpenDialog.Filter := 'Sparfiler (.dat)|*.dat';
  // -------------------------------
  if OpenDialog.Execute then
  begin
    GeometryClear;
    DerobModel.Filename := OpenDialog.Filename;
    DerobModel.Open;
    pressed := True;
    SetCurrentDir('../');
    DerobModel.HouseProperties.StringValue['CaseDir'] := GetCurrentDir;
    DerobModel.HouseProperties.StringValue['StartDir'] := StartDir;
    SetCurrentDir(StartDir);
    UpdateGeometryPanel;
    mainUpdateComboBox;
    LoadClimateFiles;
    UpdatePropertiesPanel;
    UpdateEnergyPanel;
    UpdateAbsorption;
    UpdateClimatePanel;
    UpdateClimate;
    mainHide;
    Geometry.IsSelected := True;
    GeometryPanel.Visible := True;
    TreeView1.Enabled := True;
    TreeView1.HitTest := True;
    DerobModel.HouseProperties.BoolValue['GlazeChange'] := False;
  end;

end;

procedure TForm1.fileMenuCloseClick(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.resultMenuVisualizationClick(Sender: TObject);
var
  ArgPath, KGKPath: String;
  iniFile: TextFile;
begin
  // Nytt Musten 19/7 - K�r KGKShow med Indata1.txt
  SetCurrentDir(StartDir);
  mainGeometrySave;
  VolumeCount;
  mainPropertiesSave;
  mainEnergySave;
  mainClimateSave;
  SaveConstructionNames;
  DerobModel.HouseProperties.StringValue['StartDir'] := StartDir;
  if DerobModel.HouseProperties.BoolValue['KGK'] <> False then
  begin
    DerobModel.HouseProperties.BoolValue['KGK'] := True;
    ConvertDerob.DerobModel := Self.DerobModel;
    ConvertDerob.Surface := Self.Surface;
    ConvertDerob.ConvertForLib;
    ConvertDerob.writeLibFile;
    ConvertDerob.ConvertForInput;
    ConvertDerob.writeInputFile;
  end;
  DerobModel.HouseProperties.BoolValue['KGK'] := False;
  SetCurrentDir(StartDir);
  SetCurrentDir('Cases/');
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseName']);
  ArgPath := GetCurrentDir + '\Winter\Indata1.txt';
  SetCurrentDir(StartDir);
  SetCurrentDir('Derob');
  KGKPath := GetCurrentDir + '\KGK_Show.exe';

  // Skriver om .ini filen till KGK_Show s� att den l�ser in r�tt datafil till programmet.
  AssignFile(iniFile, 'KGK_Show.ini');
  ReWrite(iniFile);
  WriteLn(iniFile, 'This file is created by the KGK_Show program.');
  WriteLn(iniFile, 'Changing the content may result in serious error!');
  WriteLn(iniFile, ArgPath); // Path till datafilen all annat �r 'standard'
  WriteLn(iniFile, ' F F T T');
  WriteLn(iniFile, ' 420 175 1260 875');
  WriteLn(iniFile, ' 0 0 0 0');
  WriteLn(iniFile, ' 0 0 0 0');
  WriteLn(iniFile, ' 0 0 0 0');
  WriteLn(iniFile, ' 0 0 0 0');
  CloseFile(iniFile);

  ExecProcess(KGKPath, '', True);
  DeleteFile('KGK_Show.ini');
end;

procedure TForm1.mainMenuDeleteFilesClick(Sender: TObject);
begin
  SetCurrentDir(DerobModel.HouseProperties.StringValue['CaseDir']);
  DeleteFile('1.dat');
  DeleteFile('2.dat');
  DeleteFile('3.dat');
  DeleteFile('4.dat');
  DeleteFile('5.dat');
  DeleteFile('6.dat');
  DeleteFile('7.dat');
  DeleteFile('8.dat');
  DeleteFile('9.dat');
  DeleteFile('Indata1.txt');
  DeleteFile('Indata2.txt');
  DeleteFile('Indata3.txt');
  DeleteFile('Vol_Load.txt');
  DeleteFile('Libraryfile.txt');
end;

procedure TForm1.PropertiesClick(Sender: TObject);
begin
  Form1.Caption := 'Egenskaper';
  mainHide;
  IntheatVent;
  PropertiesPanel.Visible := True;
end;

procedure TForm1.PropSaveButtonClick(Sender: TObject);
begin
  mainGeometrySave;
  mainPropertiesSave;
  mainEnergySave;
  mainClimateSave;
end;

procedure TForm1.AbsComboBoxChange(Sender: TObject);
begin
  ChangeAbsCombo;
end;

procedure TForm1.AbsorptionButtonClick(Sender: TObject);
begin
  Form4.Show;
  Form4.DerobModel := Self.DerobModel;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  OrientationTrackBar.Value := OrientationTrackBar.Value + 1;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  OrientationTrackBar.Value := OrientationTrackBar.Value - 1;
end;

procedure TForm1.ChangeAbsCombo;
begin
  if AbsComboBox.ItemIndex = 0 then
  begin
    AbsNumberBox1.Value := Form4.RoofAbs1.Value;
    AbsNumberBox2.Value := Form4.RoofAbs2.Value;
  end;

  if AbsComboBox.ItemIndex = 1 then
  begin
    AbsNumberBox1.Value := Form4.FloorAbs1.Value;
    AbsNumberBox2.Value := Form4.FloorAbs2.Value;

  end;
  if AbsComboBox.ItemIndex = 2 then
  begin
    AbsNumberBox1.Value := Form4.NWallAbs1.Value;
    AbsNumberBox2.Value := Form4.NWallAbs2.Value;

  end;
  if AbsComboBox.ItemIndex = 3 then
  begin
    AbsNumberBox1.Value := Form4.EWallAbs1.Value;
    AbsNumberBox2.Value := Form4.EWallAbs2.Value;

  end;
  if AbsComboBox.ItemIndex = 4 then
  begin
    AbsNumberBox1.Value := Form4.SWallAbs1.Value;
    AbsNumberBox2.Value := Form4.SWallAbs2.Value;

  end;
  if AbsComboBox.ItemIndex = 5 then
  begin
    AbsNumberBox1.Value := Form4.WWallAbs1.Value;
    AbsNumberBox2.Value := Form4.WWallAbs2.Value;
  end;
end;

procedure TForm1.ClearGlaze;
begin
  DerobModel.GlazingProperties.Clear;
  DerobModel.ClearGlazing;
end;

procedure TForm1.ClimateClick(Sender: TObject);

begin
  Form1.Caption := 'Klimat och Period';
  mainHide;
  ClimatePanel.Visible := True;
  LoadClimateFiles;
end;

procedure TForm1.ClimateSaveButtonClick(Sender: TObject);
begin
  mainGeometrySave;
  mainPropertiesSave;
  mainEnergySave;
  mainClimateSave;
end;

procedure TForm1.ClimateComboBoxChange(Sender: TObject);
begin
  UpdateClimate;
end;

procedure TForm1.DefaultAbsorption;
begin
  DerobModel.Roofs[0].Properties.IntValue['AbsorptionFront'] := 70;
  DerobModel.Roofs[0].Properties.IntValue['AbsorptionBack'] := 70;
  DerobModel.Floors[0].Properties.IntValue['AbsorptionFront'] := 0;
  DerobModel.Floors[0].Properties.IntValue['AbsorptionBack'] := 70;
  DerobModel.Walls[0].Properties.IntValue['AbsorptionFront'] := 70;
  DerobModel.Walls[0].Properties.IntValue['AbsorptionBack'] := 70;
  DerobModel.Walls[1].Properties.IntValue['AbsorptionFront'] := 70;
  DerobModel.Walls[1].Properties.IntValue['AbsorptionBack'] := 70;
  DerobModel.Walls[2].Properties.IntValue['AbsorptionFront'] := 70;
  DerobModel.Walls[2].Properties.IntValue['AbsorptionBack'] := 70;
  DerobModel.Walls[3].Properties.IntValue['AbsorptionFront'] := 70;
  DerobModel.Walls[3].Properties.IntValue['AbsorptionBack'] := 70;
end;

procedure TForm1.SaveConstructionNames;
var
  Roof, Floor, Wall, Glaze, Window: String;
begin
  Wall := WallComboBox.Selected.Text;
  if (DerobModel.GlazingProperties.BoolValue['GlazingNorth']) or
    (DerobModel.GlazingProperties.BoolValue['GlazingEast']) or
    (DerobModel.GlazingProperties.BoolValue['GlazingSouth']) or
    (DerobModel.GlazingProperties.BoolValue['GlazingWest']) = True then
  begin
    Glaze := GlazeComboBox.Selected.Text;
  end;

  if (DerobModel.Walls[0].Properties.BoolValue['HoleNorth']) or
    (DerobModel.Walls[1].Properties.BoolValue['HoleEast']) or
    (DerobModel.Walls[2].Properties.BoolValue['HoleSouth']) or
    (DerobModel.Walls[3].Properties.BoolValue['HoleWest']) = True then
  begin
    Window := WindowComboBox.Selected.Text;
  end;
  // if DerobModel.Walls[1].Properties.BoolValue['HoleEast'] = True then
  // begin
  // EWindow := EWindowComboBox.Selected.Text;
  // end;
  // if DerobModel.Walls[2].Properties.BoolValue['HoleSouth'] = True then
  // begin
  // SWindow := SWindowComboBox.Selected.Text;
  // end;
  // if DerobModel.Walls[3].Properties.BoolValue['HoleWest'] = True then
  // begin
  // WWindow := WWindowComboBox.Selected.Text;
  // end;

  Roof := RoofComboBox.Selected.Text;
  Floor := FloorComboBox.Selected.Text;

  DerobModel.HouseProperties.StringValue['Roof'] := trim(Roof);
  DerobModel.HouseProperties.StringValue['Floor'] := trim(Floor);
  DerobModel.HouseProperties.StringValue['Wall'] := trim(Wall);
  DerobModel.HouseProperties.StringValue['Glaze'] := trim(Glaze);
  DerobModel.HouseProperties.StringValue['Window'] := trim(Window);
end;

procedure TForm1.SetConvertDerob(const Value: TDerobConvert);
begin
  FConvertDerob := Value;
end;

procedure TForm1.SetCurrentCategory(const Value: string);
begin
  FCurrentCategory := Value;
end;

procedure TForm1.SetDerobModel(const Value: TDerobModel);
begin
  FDerobModel := Value;
end;

procedure TForm1.SetFloorProperties(const Value: TFloorProperties);
begin
  FFloorProperties := Value;
end;

procedure TForm1.SetRoofProperties(const Value: TRoofProperties);
begin
  FRoofProperties := Value;
end;

procedure TForm1.SetSurface(const Value: TSurface);
begin
  FSurface := Value;
end;

procedure TForm1.SetWallProperties(const Value: TWallProperties);
begin
  FWallProperties := Value;
end;

procedure TForm1.SetWindowProperties(const Value: TWindowProperties);
begin
  FWindowProperties := Value;
end;

procedure TForm1.OnExecute;
var
  ExitCode: integer;
  dig, wal, gf, lum, sol, tl: string;
  CaseDir, season, datanumber: String;
  i, Idx: integer;
begin
  CaseDir := DerobModel.HouseProperties.StringValue['CaseDir'];
  SetCurrentDir(StartDir);
  SetCurrentDir('Derob');

  for Idx := 1 to 3 do // Khoan
  begin
    if Idx = 1 then
    begin
      season := 'Winter';
      datanumber := 'Indata1.txt';
    end
    else if Idx = 2 then
    begin
      season := 'Summer';
      datanumber := 'Indata2.txt';
    end
    else if Idx = 3 then
    begin
      season := 'NoGlaze';
      datanumber := 'Indata3.txt';
    end;
    dig := GetCurrentDir + '\DIG.exe ' + '"' + CaseDir + '\' +
      DerobModel.HouseProperties.StringValue['CaseName'] + '\' + season + '\' +
      datanumber + '"';
    wal := GetCurrentDir + '\WAL.exe ' + '"' + CaseDir + '\' +
      DerobModel.HouseProperties.StringValue['CaseName'] + '\' + season + '\' +
      datanumber + '"';
    gf := GetCurrentDir + '\GF.exe ' + '"' + CaseDir + '\' +
      DerobModel.HouseProperties.StringValue['CaseName'] + '\' + season + '\' +
      datanumber + '"';
    lum := GetCurrentDir + '\LUM.exe ' + '"' + CaseDir + '\' +
      DerobModel.HouseProperties.StringValue['CaseName'] + '\' + season + '\' +
      datanumber + '"';
    sol := GetCurrentDir + '\SOL.exe ' + '"' + CaseDir + '\' +
      DerobModel.HouseProperties.StringValue['CaseName'] + '\' + season + '\' +
      datanumber + '"';
    tl := GetCurrentDir + '\TL.exe ' + '"' + CaseDir + '\' +
      DerobModel.HouseProperties.StringValue['CaseName'] + '\' + season + '\' +
      datanumber + '"';
    // FR�GA JONAS OM ATT G� TILL EXECUTE FINISHED
    ExitCode := ExecProcess(dig, '', True);
    if ExitCode <> 0 then
    begin
      ShowMessage('Fel i DIG');
    end;
    ExitCode := ExecProcess(wal, '', True);
    if ExitCode <> 0 then
    begin
      ShowMessage('Fel i WAL');
    end;
    ExitCode := ExecProcess(gf, '', True);
    if ExitCode <> 0 then
    begin
      ShowMessage('Fel i GF');
    end;
    ExitCode := ExecProcess(lum, '', True);
    if ExitCode <> 0 then
    begin
      ShowMessage('Fel i LUM');
    end;
    ExitCode := ExecProcess(sol, '', True);
    if ExitCode <> 0 then
    begin
      ShowMessage('Fel i SOL');
    end;
    ExitCode := ExecProcess(tl, '', True);
    if ExitCode <> 0 then
    begin
      ShowMessage('Fel i TL');
    end;
  end;
end;

procedure TForm1.OnExecuteFinished;
begin
  // Enable start button after thread execution

  if ExitCode = 0 then
    resultMenuChart.Enabled := True;
end;

procedure TForm1.OrientationTrackBarChange(Sender: TObject);
begin
  OrientationNumberBox.Value := OrientationTrackBar.Value;
  Rectangle1.RotationAngle := OrientationTrackBar.Value / 2;
  Viewport3D2.RotationAngle := OrientationTrackBar.Value / 2;
end;

procedure TForm1.UpdateAbsorption;
begin
  Form4.RoofAbs1.Value := DerobModel.Roofs[0].Properties.IntValue
    ['AbsorptionFront'];
  Form4.RoofAbs2.Value := DerobModel.Roofs[0].Properties.IntValue
    ['AbsorptionBack'];
  Form4.FloorAbs1.Value := DerobModel.Floors[0].Properties.IntValue
    ['AbsorptionFront'];
  Form4.FloorAbs2.Value := DerobModel.Floors[0].Properties.IntValue
    ['AbsorptionBack'];
  Form4.NWallAbs1.Value := DerobModel.Walls[0].Properties.IntValue
    ['AbsorptionFront'];
  Form4.NWallAbs2.Value := DerobModel.Walls[0].Properties.IntValue
    ['AbsorptionBack'];
  Form4.EWallAbs1.Value := DerobModel.Walls[1].Properties.IntValue
    ['AbsorptionFront'];
  Form4.EWallAbs2.Value := DerobModel.Walls[1].Properties.IntValue
    ['AbsorptionBack'];
  Form4.SWallAbs1.Value := DerobModel.Walls[2].Properties.IntValue
    ['AbsorptionFront'];
  Form4.SWallAbs2.Value := DerobModel.Walls[2].Properties.IntValue
    ['AbsorptionBack'];
  Form4.WWallAbs1.Value := DerobModel.Walls[3].Properties.IntValue
    ['AbsorptionFront'];
  Form4.WWallAbs2.Value := DerobModel.Walls[3].Properties.IntValue
    ['AbsorptionBack'];
  AbsComboBox.ItemIndex := 0;
  AbsNumberBox1.Value := Form4.RoofAbs1.Value;
  AbsNumberBox2.Value := Form4.RoofAbs2.Value;
end;

procedure TForm1.UpdateClimate;
var
  sl: TStringList;
  Latitude, Longitude, TimeMeridian: string;
  Year: string;
  i: integer;
begin
  sl := TStringList.Create;
  try
    DerobModel.HouseProperties.StringValue['LocationPath'] := GetCurrentDir +
      '\' + ClimateComboBox.Selected.Text;
    sl.LoadFromFile(ClimateComboBox.Selected.Text);
    Latitude := sl[11]; // line 12
    Latitude := Copy(Latitude, 19, 24);
    Latitude := Copy(Latitude, 1, 6);
    Longitude := sl[12]; // line 13
    Longitude := Copy(Longitude, 19, 24);
    Longitude := Copy(Longitude, 1, 6);
    TimeMeridian := sl[13]; // line 14
    TimeMeridian := Copy(TimeMeridian, 19, 24);
    TimeMeridian := Copy(TimeMeridian, 1, 6);
    Year := sl[18];
    Year := Copy(Year, 0, 4);
    trim(Year);

    // If Climate file hasn't been modified the lines moves
    if TimeMeridian = '' then
    begin
      Latitude := sl[10]; // line 11
      Latitude := Copy(Latitude, 19, 24);
      Latitude := Copy(Latitude, 1, 6);
      Longitude := sl[11]; // line 12
      Longitude := Copy(Longitude, 19, 24);
      Longitude := Copy(Longitude, 1, 6);
      TimeMeridian := sl[12]; // line 13
      TimeMeridian := Copy(TimeMeridian, 19, 24);
      TimeMeridian := Copy(TimeMeridian, 1, 6);
      Year := sl[17];
      Year := Copy(Year, 0, 4);
      trim(Year);
    end;

    LatitudeNumberBox.Value := StrToFloat(Latitude);
    LongitudeNumberBox.Value := StrToFloat(Longitude);
    TimeMeridianNumberBox.Value := StrToFloat(TimeMeridian);

    FromYearLabel.Text := Year;
    ToYearLabel.Text := Year;

    FromYearLabel.Visible := True;
    FromMonthLabel.Visible := True;
    FromDayLabel.Visible := True;
    ToYearLabel.Visible := True;
    ToMonthLabel.Visible := True;
    ToDayLabel.Visible := True;
    Label25.Visible := True;
    Label52.Visible := True;
    Label53.Visible := True;
    Label54.Visible := True;

  finally
    sl.Free;
  end;
end;

procedure TForm1.UpdateClimatePanel;
begin
  LoadClimateFiles;
  ClimateComboBox.ItemIndex := DerobModel.HouseProperties.IntValue
    ['LocationIndex'];
  UpdateClimate;
  OrientationNumberBox.Value := DerobModel.HouseProperties.IntValue['Rotation'];
  OrientationTrackBar.Value := OrientationNumberBox.Value;
  // FromMonthComboBox.ItemIndex := DerobModel.HouseProperties.IntValue
  // ['FromMonth'];
  // FromMonthComboBox.ItemIndex := DerobModel.HouseProperties.IntValue
  // ['FromMonth'];
  // FromDayComboBox.ItemIndex := DerobModel.HouseProperties.IntValue['FromDay'];
  // ToMonthComboBox.ItemIndex := DerobModel.HouseProperties.IntValue['ToMonth'];
  // ToDayComboBox.ItemIndex := DerobModel.HouseProperties.IntValue['ToDay'];
end;

procedure TForm1.UpdateConstructionList;
var
  i: integer;
  Construction: TConstruction;
begin

  // Clear all items in the list box

  Form2.ConstructionListBox.Clear;

  // Loop over walls in derob model

  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    Construction := DerobModel.Constructions[i];
    if Construction.StringValue['ConstructionType'] = CurrentCategory then
      Form2.ConstructionListBox.Items.AddObject
        (DerobModel.Constructions[i].Name, DerobModel.Constructions[i]);
  end;
end;

procedure TForm1.UpdateEnergyPanel;
begin
  if DerobModel.HouseProperties.BoolValue['RoomTemp'] = True then
  begin
    RoomTempRadioButton.IsChecked := True;
    TempMaxNumberBox.Value := DerobModel.HouseProperties.IntValue['TMaxRoom'];
    TempMinNumberBox.Value := DerobModel.HouseProperties.IntValue['TMinRoom'];
  end;

  if DerobModel.HouseProperties.BoolValue['GlazeTemp'] = True then
  begin
    GlazeTempRadioButton.IsChecked := True;
    TempMaxNumberBox.Value := DerobModel.HouseProperties.IntValue['TMaxGlaze'];
    TempMinNumberBox.Value := DerobModel.HouseProperties.IntValue['TMinGlaze'];
  end;
  TempMinNumberBox.Value := DerobModel.HouseProperties.IntValue['TMinRoom'];
  IntHeatNumberBox.Value := DerobModel.HouseProperties.IntValue['IntHeat'];

  Form3.PersonSpinBox.Value := DerobModel.HouseProperties.IntValue['Persons'];
  Form3.PersonNumberBox.Value := Form3.PersonSpinBox.Value * 117;

  Form3.AppliancesSpinBox.Value := DerobModel.HouseProperties.IntValue
    ['Appliances'];
  Form3.AppliancesNumberBox.Value := Form3.AppliancesSpinBox.Value * 120;

  Form3.OthersNumberBox.Value := DerobModel.HouseProperties.IntValue['Lamps'];

  FlowNumberBox.Value := DerobModel.VentilationProperties.DoubleValue['Flow'];
  EfficiencyNumberBox.Value := DerobModel.VentilationProperties.
    DoubleValue['Eta'];

  if DerobModel.VentilationProperties.BoolValue['AutoOpening'] = True then
  begin
    IntGlazeCheckBox1.IsChecked := True;
  end;
  if DerobModel.VentilationProperties.BoolValue['AdvectionConnection'] = True then
  begin
    IntGlazeCheckBox2.IsChecked := True;
  end;

  LeakNumberBox1.Value := DerobModel.VentilationProperties.DoubleValue['Leak1'];
  LeakNumberBox2.Value := DerobModel.VentilationProperties.DoubleValue['Leak2'];
  LeakNumberBox3.Value := DerobModel.VentilationProperties.DoubleValue['Leak3'];
  LeakNumberBox4.Value := DerobModel.VentilationProperties.DoubleValue['Leak4'];
  LeakNumberBox5.Value := DerobModel.VentilationProperties.DoubleValue['Leak5'];

end;

procedure TForm1.UpdateGeometryPanel;
begin
  HouseNumberBox1.Value := DerobModel.Floors[0].Length;
  HouseNumberBox2.Value := DerobModel.Floors[0].Width;
  HouseNumberBox3.Value := DerobModel.Walls[0].Height;

  Rectangle3D6.Visible := True;
  Rectangle3D6.Width := HouseNumberBox1.Value;
  Rectangle3D6.Depth := HouseNumberBox2.Value;
  Rectangle3D6.Height := HouseNumberBox3.Value;

  if DerobModel.Walls[0].Properties.BoolValue['HoleNorth'] = True then
  begin
    WindowCheckBox1.IsChecked := True;
    WindowNumberBox1.Value := DerobModel.Windows[0].Width;
    WindowNumberBox2.Value := DerobModel.Windows[0].Height;
  end;

  if DerobModel.Walls[1].Properties.BoolValue['HoleEast'] = True then
  begin
    WindowCheckBox2.IsChecked := True;
    WindowNumberBox3.Value := DerobModel.Windows[1].Width;
    WindowNumberBox4.Value := DerobModel.Windows[1].Height;
  end;

  if DerobModel.Walls[2].Properties.BoolValue['HoleSouth'] = True then
  begin
    WindowCheckBox3.IsChecked := True;
    WindowNumberBox5.Value := DerobModel.Windows[2].Width;
    WindowNumberBox6.Value := DerobModel.Windows[2].Height;
  end;

  if DerobModel.Walls[3].Properties.BoolValue['HoleWest'] = True then
  begin
    WindowCheckBox4.IsChecked := True;
    WindowNumberBox7.Value := DerobModel.Windows[3].Width;
    WindowNumberBox8.Value := DerobModel.Windows[3].Height;
  end;

  if DerobModel.GlazingProperties.BoolValue['GlazingNorth'] = True then
  begin
    GlazeCheckBox1.IsChecked := True;
    GlazeNumberBox1.Value := DerobModel.GlazingProperties.DoubleValue
      ['CavityNorth'];
  end;

  if DerobModel.GlazingProperties.BoolValue['GlazingEast'] = True then
  begin
    GlazeCheckBox2.IsChecked := True;
    GlazeNumberBox2.Value := DerobModel.GlazingProperties.DoubleValue
      ['CavityEast'];
  end;

  if DerobModel.GlazingProperties.BoolValue['GlazingSouth'] = True then
  begin
    GlazeCheckBox3.IsChecked := True;
    GlazeNumberBox3.Value := DerobModel.GlazingProperties.DoubleValue
      ['CavitySouth'];
  end;

  if DerobModel.GlazingProperties.BoolValue['GlazingWest'] = True then
  begin
    GlazeCheckBox4.IsChecked := True;
    GlazeNumberBox4.Value := DerobModel.GlazingProperties.DoubleValue
      ['CavityWest'];
  end;

end;

procedure TForm1.UpdateLayerList;
var
  i: integer;
  Construction: TConstruction;
begin

  // Clear all items in the list box

  Form2.LayerListBox.Clear;

  // Is a construction instance selected?

  if Form2.ConstructionListBox.ItemIndex <> -1 then
  begin

    // Loop over layers in construction

    Construction := Form2.ConstructionListBox.Items.Objects
      [Form2.ConstructionListBox.ItemIndex] as TConstruction;

    for i := 0 to Construction.LayerCount - 1 do
      Form2.LayerListBox.Items.AddObject(Construction.Layers[i].Name,
        Construction.Layers[i]);
  end;
end;

procedure TForm1.UpdateMaterialList;
var
  i: integer;
begin
  // Clear all items in the list box

  Form2.MaterialListBox.Clear;

  // Fill list box with material instances

  for i := 0 to DerobModel.MaterialCount - 1 do
  begin
    if ((CurrentCategory = 'Glaze') or (CurrentCategory = 'Window')) and
      (DerobModel.Materials[i].StringValue['MaterialType'] = 'Glass') then
    begin
      Form2.MaterialListBox.Items.AddObject(DerobModel.Materials[i].Name,
        DerobModel.Materials[i]);
    end
    else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Opaque' then
    begin
      Form2.MaterialListBox.Items.AddObject(DerobModel.Materials[i].Name,
        DerobModel.Materials[i]);
    end;
  end;

end;

procedure TForm1.UpdatePropertiesPanel;
begin

  RoofComboBox.ItemIndex := DerobModel.HouseProperties.IntValue['RoofHolder'];
  FloorComboBox.ItemIndex := DerobModel.HouseProperties.IntValue['FloorHolder'];

  WallComboBox.ItemIndex := DerobModel.HouseProperties.IntValue['WallHolder'];
  GlazeComboBox.ItemIndex := DerobModel.HouseProperties.IntValue['GlazeHolder'];
  WindowComboBox.ItemIndex := DerobModel.HouseProperties.IntValue
    ['WindowHolder'];
end;

procedure TForm1.VolumeCount;
begin
  nvol := 1;
  advec := 0;

  if DerobModel.GlazingProperties.BoolValue['GlazingNorth'] = True then
  begin
    nvol := nvol + 1;
    DerobModel.HouseProperties.IntValue['VolumeNorth'] := 1;
  end
  else
  begin
    DerobModel.HouseProperties.IntValue['VolumeNorth'] := 0;
    nvol := nvol;
  end;

  if DerobModel.GlazingProperties.BoolValue['GlazingEast'] = True then
  begin
    nvol := nvol + 1;
    DerobModel.HouseProperties.IntValue['VolumeEast'] := 1;
  end
  else
  begin
    DerobModel.HouseProperties.IntValue['VolumeEast'] := 0;
    nvol := nvol;
  end;

  if DerobModel.GlazingProperties.BoolValue['GlazingSouth'] = True then
  begin
    nvol := nvol + 1;
    DerobModel.HouseProperties.IntValue['VolumeSouth'] := 1;
  end
  else
  begin
    DerobModel.HouseProperties.IntValue['VolumeSouth'] := 0;
    nvol := nvol;
  end;

  if DerobModel.GlazingProperties.BoolValue['GlazingWest'] = True then
  begin
    nvol := nvol + 1;
    DerobModel.HouseProperties.IntValue['VolumeWest'] := 1;
  end
  else
  begin
    nvol := nvol;
    DerobModel.HouseProperties.IntValue['VolumeWest'] := 0;
  end;
  if DerobModel.GlazingProperties.BoolValue['NorthEast'] = True then
  begin
    advec := advec + 1;
  end;
  if DerobModel.GlazingProperties.BoolValue['EastSouth'] = True then
  begin
    advec := advec + 1;
  end;
  if DerobModel.GlazingProperties.BoolValue['SouthWest'] = True then
  begin
    advec := advec + 1;
  end;
  if DerobModel.GlazingProperties.BoolValue['WestNorth'] = True then
  begin
    advec := advec + 1;
  end;

  // end;
  // if (DerobModel.Glazing[0].Properties.BoolValue['GlazeNorth']=true)
  // and (DerobModel.Glazing[5].Properties.BoolValue['GlazeEast']=true) then
  // begin
  // advec:=advec+1;
  // end;
  // if (DerobModel.Glazing[10].Properties.BoolValue['GlazeSouth']=true)
  // and (DerobModel.Glazing[5].Properties.BoolValue['GlazeEast']=true) then
  // begin
  // advec:=advec+1;
  // end;
  // if (DerobModel.Glazing[10].Properties.BoolValue['GlazeSouth']=true)
  // and (DerobModel.Glazing[15].Properties.BoolValue['GlazeWest']=true) then
  // begin
  // advec:=advec+1;
  // end;
  // if (DerobModel.Glazing[0].Properties.BoolValue['GlazeNorth']=true)
  // and (DerobModel.Glazing[15].Properties.BoolValue['GlazeWest']=true) then
  // begin
  // advec:=advec+1;
  // end;
  DerobModel.HouseProperties.IntValue['nvol'] := nvol;
  DerobModel.HouseProperties.IntValue['advec'] := advec;

end;

procedure TForm1.PropConstrButtonClick(Sender: TObject);
begin
  Form2.DerobModel := Self.DerobModel;
  CurrentCategory := 'Wall';
  Form2.CMenuItem1.IsSelected := True;
  Form2.CMenuItem1.IsChecked := True;
  UpdateConstructionList;
  UpdateLayerList;
  UpdateMaterialList;
  Form2.Show;
end;

procedure TForm1.LoadClimateFiles;
var
  searchResult: TSearchRec;
begin
  SetCurrentDir(StartDir);
  SetCurrentDir('Climate');
  // Letar efter filer i aktuell mapp
  if FindFirst('*.*', faReadOnly, searchResult) = 0 then
  begin
    repeat
    begin
      // L�gger till filnamnen i Comboboxen
      ClimateComboBox.Items.Add(searchResult.Name);
    end;
    until FindNext(searchResult) <> 0;
    // Must free up resources used by these successful finds
    // FindClose(searchResult); FUNKAR INTE?     FR�GA JONAS
  end;
end;

procedure TForm1.LoadGas;
var
  SomeTxtFile: TextFile;
  buffer: string;
  Idx: integer;
  holder: TStringList;
  Material: TMaterial;
begin
  SetCurrentDir(StartDir);
  Idx := 0;
  holder := TStringList.Create;
  AssignFile(SomeTxtFile, 'Library\Gas.lib');
  Reset(SomeTxtFile);
  while not EOF(SomeTxtFile) do
  begin
    Material := TMaterial.Create;
    ReadLn(SomeTxtFile, buffer);
    holder.Delimiter := '|';
    holder.StrictDelimiter := True;
    holder.DelimitedText := buffer;
    Material.Name := holder[0];
    Material.StringValue['MaterialType'] := 'Gas';
    Idx := Idx + 1; // Make sure that all the Materials are added
    Material.DoubleValue['Conductivity'] := StrToFloat(holder[1]);
    // Assign the proper values for the Material
    Material.DoubleValue['dC/dT'] := StrToFloat(holder[2]);
    Material.DoubleValue['Viscosity'] := StrToFloat(holder[3]);
    Material.DoubleValue['dV/dT'] := StrToFloat(holder[4]);
    Material.DoubleValue['GasDensity'] := StrToFloat(holder[5]);
    Material.DoubleValue['dD/dT'] := StrToFloat(holder[6]);
    Material.DoubleValue['Prandtl'] := StrToFloat(holder[7]);
    Material.DoubleValue['dP/dT'] := StrToFloat(holder[8]);
    DerobModel.AddMaterial(Material);
  end;
  CloseFile(SomeTxtFile);
end;

procedure TForm1.LoadGlassConstructions;
var
  SomeTxtFile: TextFile;
  buffer: string;
  Idx: integer;
  holder: TStringList;
  Construction: TConstruction;
  Material: TMaterial;
  i: integer;
begin
  SetCurrentDir(StartDir);
  Idx := 0;
  holder := TStringList.Create;
  AssignFile(SomeTxtFile, 'Library\WindowConstructions.lib');
  Reset(SomeTxtFile);
  while not EOF(SomeTxtFile) do
  begin
    SetCurrentDir(StartDir);
    Construction := TConstruction.Create;
    Construction.StringValue['ConstructionType'] := 'Window';
    ReadLn(SomeTxtFile, buffer);
    holder.Delimiter := '|';
    holder.StrictDelimiter := True;
    holder.DelimitedText := buffer;
    Construction.Name := holder[1];

    if holder[2] = '1' then
    begin
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[3] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], 0);
        end;
      end;
      if holder[4] = 'No' then
      begin
        Construction.IntValue['iflip1'] := 0;
      end
      else
      begin
        Construction.IntValue['iflip1'] := 1;
      end;

      Construction.IntValue['F�nsterskikt'] := 1;
      // holder[2] + (holder[2]-1) <-- Gasspalter
      Construction.IntValue['AntalGlas'] := 1;
      DerobModel.AddConstruction(Construction);
    end;

    if holder[2] = '2' then
    begin
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[3] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], 0);
        end;
      end;
      if holder[4] = 'No' then
      begin
        Construction.IntValue['iflip1'] := 0;
      end
      else
      begin
        Construction.IntValue['iflip1'] := 1;
      end;
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[6] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], StrToFloat(holder[5]));
        end;
      end;
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[7] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], 0);
        end;
      end;
      if holder[8] = 'No' then
      begin
        Construction.IntValue['iflip2'] := 0;
      end
      else
      begin
        Construction.IntValue['iflip2'] := 1;
      end;

      Construction.IntValue['F�nsterskikt'] := 3;
      // holder[2] + (holder[2]-1) <-- Gasspalter
      Construction.IntValue['AntalGlas'] := 2;
      DerobModel.AddConstruction(Construction);
    end;

    if holder[2] = '3' then
    begin
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[3] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], 0);
        end;
      end;
      if holder[4] = 'No' then
      begin
        Construction.IntValue['iflip1'] := 0;
      end
      else
      begin
        Construction.IntValue['iflip1'] := 1;
      end;
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[6] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], StrToFloat(holder[5]));
        end;
      end;
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[7] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], 0);
        end;
      end;
      if holder[8] = 'No' then
      begin
        Construction.IntValue['iflip2'] := 0;
      end
      else
      begin
        Construction.IntValue['iflip2'] := 1;
      end;
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[10] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], StrToFloat(holder[9]));
        end;
      end;
      for i := 0 to DerobModel.MaterialCount - 1 do
      begin
        if holder[11] = DerobModel.Materials[i].Name then
        begin
          Construction.AddLayer(DerobModel.Materials[i], 0);
        end;
      end;
      if holder[12] = 'No' then
      begin
        Construction.IntValue['iflip3'] := 0;
      end
      else
      begin
        Construction.IntValue['iflip3'] := 1;
      end;
      Construction.IntValue['F�nsterskikt'] := 5;
      // holder[2] + (holder[2]-1) <- Gasspalter
      Construction.IntValue['AntalGlas'] := 3;
      DerobModel.AddConstruction(Construction);
    end;

  end;

  CloseFile(SomeTxtFile);

end;

procedure TForm1.LoadGlasses;
var
  SomeTxtFile: TextFile;
  buffer: string;
  Idx: integer;
  holder: TStringList;
  Material: TMaterial;
begin
  SetCurrentDir(StartDir);
  Idx := 0;
  holder := TStringList.Create;
  AssignFile(SomeTxtFile, 'Library/Glass.lib');
  Reset(SomeTxtFile);
  while not EOF(SomeTxtFile) do
  begin
    Material := TMaterial.Create;
    ReadLn(SomeTxtFile, buffer);
    holder.Delimiter := '|';
    holder.StrictDelimiter := True;
    holder.DelimitedText := buffer;
    Material.Name := holder[0];
    Material.StringValue['MaterialType'] := 'Glass';
    Idx := Idx + 1; // Make sure that all the Materials are added
    Material.DoubleValue['FrontEmittance'] := StrToFloat(holder[1]);
    // Assign the proper values for the Material
    Material.DoubleValue['BackEmittance'] := StrToFloat(holder[2]);
    Material.DoubleValue['Transmission'] := StrToFloat(holder[4]);
    Material.DoubleValue['Reflection'] := StrToFloat(holder[5]);
    DerobModel.AddMaterial(Material);
  end;
  CloseFile(SomeTxtFile);
end;

procedure TForm1.LoadMaterials;
var
  SomeTxtFile: TextFile;
  buffer: string;
  Idx: integer;
  holder: TStringList;
  Material: TMaterial;
begin
  Idx := 0;
  holder := TStringList.Create;
  SetCurrentDir(StartDir);
  AssignFile(SomeTxtFile, 'Library/WallMaterial.lib');
  Reset(SomeTxtFile);
  while not EOF(SomeTxtFile) do
  begin
    Material := TMaterial.Create;
    ReadLn(SomeTxtFile, buffer);
    holder.Delimiter := '|';
    holder.StrictDelimiter := True;
    holder.DelimitedText := buffer;
    Material.Name := holder[1];
    Material.StringValue['MaterialType'] := 'Opaque';
    Idx := Idx + 1; // Make sure that all the materials are added
    Material.DoubleValue['Density'] := StrToFloat(holder[4]);
    // Assign the proper values for the material
    Material.DoubleValue['Lambda'] := StrToFloat(holder[2]);
    Material.DoubleValue['HeatCapacity'] := StrToFloat(holder[3]);
    DerobModel.AddMaterial(Material);
  end;
  CloseFile(SomeTxtFile);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form2.Free;
  Form3.Free;
  Form4.Free;
  Form5.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDerobModel := TDerobModel.Create;
  FConvertDerob := TDerobConvert.Create;
  FSurface := TSurface.Create;
  // F�r att v�lja annan mapp �n 'C:\Users\Public\Documents\' se l�nk
  // http://docwiki.embarcadero.com/RADStudio/XE7/en/Standard_RTL_Path_Functions_across_the_Supported_Target_Platforms
  SetCurrentDir(TPath.GetSharedDocumentsPath);
  SetCurrentDir('Glazing-LTH');
  StartDir := GetCurrentDir;
  DerobModel.HouseProperties.StringValue['StartDir'] := StartDir;
  Rectangle3D6.Visible := False;
  Formatsettings.DecimalSeparator := '.';
end;

procedure TForm1.GeoClearButtonClick(Sender: TObject);
begin
  GeometryClear;
end;

procedure TForm1.GeometryClick(Sender: TObject);
begin
  Form1.Caption := 'Geometri';
  mainHide;
  GeometryPanel.Visible := True;
end;

procedure TForm1.GeoSaveButtonClick(Sender: TObject);
begin
  mainGeometrySave;
  mainPropertiesSave;
  mainEnergySave;
  mainClimateSave;
  VolumeCount;
end;

procedure TForm1.GlazeCheckBox1Change(Sender: TObject);
begin
  DerobModel.HouseProperties.BoolValue['GlazeChange'] := True;
  if GlazeCheckBox1.IsChecked then
  begin
    GlazeLabel1.Enabled := True;
    GlazemLabel1.Enabled := True;
    GlazeNumberBox1.Enabled := True;
  end
  else
  begin
    GlazeLabel1.Enabled := False;
    GlazemLabel1.Enabled := False;
    GlazeNumberBox1.Enabled := False;
  end;
end;

procedure TForm1.GlazeCheckBox2Change(Sender: TObject);
begin
  DerobModel.HouseProperties.BoolValue['GlazeChange'] := True;
  if GlazeCheckBox2.IsChecked then
  begin
    GlazeLabel2.Enabled := True;
    GlazemLabel2.Enabled := True;
    GlazeNumberBox2.Enabled := True;
  end
  else
  begin
    GlazeLabel2.Enabled := False;
    GlazemLabel2.Enabled := False;
    GlazeNumberBox2.Enabled := False;
  end;
end;

procedure TForm1.GlazeCheckBox3Change(Sender: TObject);
begin
  DerobModel.HouseProperties.BoolValue['GlazeChange'] := True;
  if GlazeCheckBox3.IsChecked then
  begin
    GlazeLabel3.Enabled := True;
    GlazemLabel3.Enabled := True;
    GlazeNumberBox3.Enabled := True;
  end
  else
  begin
    GlazeLabel3.Enabled := False;
    GlazemLabel3.Enabled := False;
    GlazeNumberBox3.Enabled := False;
  end;
end;

procedure TForm1.GlazeCheckBox4Change(Sender: TObject);
begin
  DerobModel.HouseProperties.BoolValue['GlazeChange'] := True;
  if GlazeCheckBox4.IsChecked then
  begin
    GlazeLabel4.Enabled := True;
    GlazemLabel4.Enabled := True;
    GlazeNumberBox4.Enabled := True;
  end
  else
  begin
    GlazeLabel4.Enabled := False;
    GlazemLabel4.Enabled := False;
    GlazeNumberBox4.Enabled := False;
  end;
end;

procedure TForm1.GlazeTempRadioButtonChange(Sender: TObject);
begin
  if GlazeTempRadioButton.IsChecked then
  begin
    GlazeControlComboBox.Enabled := True;
  end
  else
  begin
    GlazeControlComboBox.Enabled := False;
  end;
end;

procedure TForm1.InternalHeatButtonClick(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.IntheatVent;
begin
  GlazeControlComboBox.Items.Clear;
  GlazeControlComboBox.ItemIndex := -3;
  if WindowCheckBox1.IsChecked or WindowCheckBox2.IsChecked or
    WindowCheckBox3.IsChecked or WindowCheckBox4.IsChecked then
  begin
    WindowComboBox.Enabled := True;
  end
  else
  begin
    WindowComboBox.Enabled := False;
  end;

  if GlazeCheckBox1.IsChecked then
  begin
    LeakNumberBox2.Enabled := True;
    GlazeControlComboBox.Items.Add('Inglasning N');
  end
  else
  begin
    LeakNumberBox2.Enabled := False;
  end;

  if GlazeCheckBox2.IsChecked then
  begin
    LeakNumberBox3.Enabled := True;
    GlazeControlComboBox.Items.Add('Inglasning �');
  end
  else
  begin
    LeakNumberBox3.Enabled := False;
  end;

  if GlazeCheckBox3.IsChecked then
  begin
    LeakNumberBox4.Enabled := True;
    GlazeControlComboBox.Items.Add('Inglasning S');
  end
  else
  begin
    LeakNumberBox4.Enabled := False;
  end;

  if GlazeCheckBox4.IsChecked then
  begin
    LeakNumberBox5.Enabled := True;
    GlazeControlComboBox.Items.Add('Inglasning V');
  end
  else
  begin
    LeakNumberBox5.Enabled := False;
  end;

  if GlazeCheckBox1.IsChecked or GlazeCheckBox2.IsChecked or
    GlazeCheckBox3.IsChecked or GlazeCheckBox4.IsChecked then
  begin
    IntGlazeCheckBox1.Enabled := False; //Inte implementerat
    GlazeComboBox.Enabled := True;
  end
  else
  begin
    IntGlazeCheckBox1.Enabled := False;
    GlazeComboBox.Enabled := False;
  end;

  if (GlazeCheckBox1.IsChecked and GlazeCheckBox2.IsChecked) or
    (GlazeCheckBox2.IsChecked and GlazeCheckBox3.IsChecked) or
    (GlazeCheckBox3.IsChecked and GlazeCheckBox4.IsChecked) or
    (GlazeCheckBox4.IsChecked and GlazeCheckBox1.IsChecked) then
  begin
    IntGlazeCheckBox2.Enabled := True;
  end
  else
  begin
    IntGlazeCheckBox2.Enabled := False;
  end;

  if (GlazeCheckBox1.IsChecked) or (GlazeCheckBox2.IsChecked) or
    (GlazeCheckBox3.IsChecked) or (GlazeCheckBox4.IsChecked) then
  begin
    GlazeTempRadioButton.Enabled := True;
  end
  else
  begin
    GlazeTempRadioButton.Enabled := False;
  end;

  if (DerobModel.HouseProperties.IntValue['ChosenGlaze'] > 1) and
    (DerobModel.HouseProperties.BoolValue['GlazeChange'] = False) then
  begin
    GlazeControlComboBox.ItemIndex := DerobModel.HouseProperties.IntValue
      ['ChosenGlaze'] - 2;
  end
  else
  begin
    DerobModel.HouseProperties.IntValue['ChosenGlaze'] := 0;
    DerobModel.HouseProperties.BoolValue['GlazeChange'] := False;
  end;

end;

procedure TForm1.EnergyBalanceClick(Sender: TObject);
begin
  Form1.Caption := 'Internv�rme och Ventilation';
  mainHide;
  IntheatVent;
  EnergyPanel.Visible := True;
end;

procedure TForm1.EnergySaveButtonClick(Sender: TObject);
begin
  mainGeometrySave;
  mainPropertiesSave;
  mainEnergySave;
  mainClimateSave;
end;

procedure TForm1.WindowCheckBox1Change(Sender: TObject);
begin
  if WindowCheckBox1.IsChecked then
  begin
    WindowNumberBox1.Enabled := True;
    WindowNumberBox2.Enabled := True;
  end
  else
  begin
    WindowNumberBox1.Enabled := False;
    WindowNumberBox2.Enabled := False;
  end;
end;

procedure TForm1.WindowCheckBox2Change(Sender: TObject);
begin
  if WindowCheckBox2.IsChecked then
  begin
    WindowNumberBox3.Enabled := True;
    WindowNumberBox4.Enabled := True;
  end
  else
  begin
    WindowNumberBox3.Enabled := False;
    WindowNumberBox4.Enabled := False;
  end;
end;

procedure TForm1.WindowCheckBox3Change(Sender: TObject);
begin
  if WindowCheckBox3.IsChecked then
  begin
    WindowNumberBox5.Enabled := True;
    WindowNumberBox6.Enabled := True;
  end
  else
  begin
    WindowNumberBox5.Enabled := False;
    WindowNumberBox6.Enabled := False;
  end;
end;

procedure TForm1.WindowCheckBox4Change(Sender: TObject);
begin
  if WindowCheckBox4.IsChecked then
  begin
    WindowNumberBox7.Enabled := True;
    WindowNumberBox8.Enabled := True;
  end
  else
  begin
    WindowNumberBox7.Enabled := False;
    WindowNumberBox8.Enabled := False;
  end;
end;

end.
