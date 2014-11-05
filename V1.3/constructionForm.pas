unit constructionForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Layouts, FMX.ListBox, System.Actions, FMX.ActnList, FMX.Menus,
  derob, System.Rtti, FMX.Grid, Math, FMX.ExtCtrls;

type
  TForm2 = class(TForm)
    ConstrMenuBar: TMenuBar;
    CMenuItem1: TMenuItem;
    CMenuItem2: TMenuItem;
    CMenuItem3: TMenuItem;
    ConstrSaveButton: TButton;
    WallPanel1: TPanel;
    ConstructionListBox: TListBox;
    CWallLabel: TLabel;
    LayerListBox: TListBox;
    CLayerLabel: TLabel;
    RemoveConstructionButton: TButton;
    WallPanel2: TPanel;
    MaterialListBox: TListBox;
    CMaterialLabel: TLabel;
    AddMaterialButton: TButton;
    RemoveMaterialButton: TButton;
    AddLayerButton: TButton;
    RemoveLayerButton: TButton;
    CWallNumberBox1: TNumberBox;
    CWallNumberBox2: TNumberBox;
    CWallNumberBox3: TNumberBox;
    CLabel1: TLabel;
    CLabel2: TLabel;
    CLabel3: TLabel;
    CreateConstructionButton: TButton;
    CMenuItem4: TMenuItem;
    CMenuItem5: TMenuItem;
    CLabel4: TLabel;
    CLabel5: TLabel;
    CLabel6: TLabel;
    CLabel7: TLabel;
    CLabel8: TLabel;
    Label1: TLabel;
    LayerThicknessNumberBox: TNumberBox;
    Label2: TLabel;
    UNumberBox: TNumberBox;
    Button1: TButton;
    PopupBox1: TPopupBox;
    Label3: TLabel;
    procedure CMenuItem1Click(Sender: TObject);
    procedure CMenuItem2Click(Sender: TObject);
    procedure CMenuItem3Click(Sender: TObject);
    procedure ConstrSaveButtonClick(Sender: TObject);
    procedure CreateConstructionButtonClick(Sender: TObject);
    procedure RemoveConstructionButtonClick(Sender: TObject);
    procedure AddMaterialButtonClick(Sender: TObject);
    procedure RemoveMaterialButtonClick(Sender: TObject);
    procedure MaterialListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure AddLayerButtonClick(Sender: TObject);
    procedure ConstructionListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure RemoveLayerButtonClick(Sender: TObject);
    procedure CMenuItem4Click(Sender: TObject);
    procedure CMenuItem5Click(Sender: TObject);
    procedure LayerListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PopupBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FDerobModel: TDerobModel;
    FCurrentCategory: string;
    procedure SetDerobModel(const Value: TDerobModel);

    procedure UpdateConstructionList;
    procedure UpdateMaterialList;
    procedure UpdateLayerList;
    procedure CUpdateComboBox;
    procedure DisableButton;
    procedure EnableButton;
    procedure UpdateUValue;
    procedure UpdateMaterialConstants;
    procedure UpdateLayerThicknessBox;
    procedure SaveBeforeExit;

    // procedure SetData;
    procedure SetCurrentCategory(const Value: string);
    procedure menuSelected;
  public
    { Public declarations }
    property DerobModel: TDerobModel read FDerobModel write SetDerobModel;
    property CurrentCategory: string read FCurrentCategory
      write SetCurrentCategory;
  end;

var
  Form2: TForm2;
  i, GlassMatCount, GasMatCount, OpaqueMatCount: Integer;

implementation

{$R *.fmx}

uses mainFormny;

procedure TForm2.ConstrSaveButtonClick(Sender: TObject);
begin
  Form2.Close;

end;

procedure TForm2.CUpdateComboBox;
var
  Construction: TConstruction;
  i: Integer;
  ItemIndex: array of Integer;
begin

  SetLength(ItemIndex, 5);
  ItemIndex[0] := Form1.RoofComboBox.ItemIndex;
  ItemIndex[1] := Form1.FloorComboBox.ItemIndex;
  ItemIndex[2] := Form1.WallComboBox.ItemIndex;
  ItemIndex[3] := Form1.GlazeComboBox.ItemIndex;
  ItemIndex[4] := Form1.WindowComboBox.ItemIndex;

  Form1.RoofComboBox.Clear;
  Form1.FloorComboBox.Clear;
  Form1.WallComboBox.Clear;
  Form1.GlazeComboBox.Clear;
  Form1.WindowComboBox.Clear;

  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    Construction := DerobModel.Constructions[i];
    if Construction.StringValue['ConstructionType'] = 'Roof' then
    begin
      Form1.RoofComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
    if Construction.StringValue['ConstructionType'] = 'Floor' then
    begin
      Form1.FloorComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
    if Construction.StringValue['ConstructionType'] = 'Wall' then
    begin
      Form1.WallComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
    if Construction.StringValue['ConstructionType'] = 'Window' then
    begin
      Form1.GlazeComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
    if Construction.StringValue['ConstructionType'] = 'Window' then
    begin
      Form1.WindowComboBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
    end;
  end;

  Form1.RoofComboBox.ItemIndex := ItemIndex[0];
  Form1.FloorComboBox.ItemIndex := ItemIndex[1];
  Form1.WallComboBox.ItemIndex := ItemIndex[2];
  Form1.GlazeComboBox.ItemIndex := ItemIndex[3];
  Form1.WindowComboBox.ItemIndex := ItemIndex[4];

end;

procedure TForm2.DisableButton;
begin
  CreateConstructionButton.Enabled := False;
  RemoveConstructionButton.Enabled := False;
  AddLayerButton.Enabled := False;
  RemoveLayerButton.Enabled := False;
  AddMaterialButton.Enabled := False;
  RemoveMaterialButton.Enabled := False;
  MaterialListBox.Enabled := False;
  UNumberBox.Value := -999;
  LayerThicknessNumberBox.Value := -999;
  CWallNumberBox1.Value := -999;
  CWallNumberBox2.Value := -999;
  CWallNumberBox3.Value := -999;

end;

procedure TForm2.EnableButton;
begin
  CreateConstructionButton.Enabled := True;
  RemoveConstructionButton.Enabled := True;
  AddLayerButton.Enabled := True;
  RemoveLayerButton.Enabled := True;
  AddMaterialButton.Enabled := True;
  RemoveMaterialButton.Enabled := True;
  MaterialListBox.Enabled := True;
  UNumberBox.Value := -999;
  LayerThicknessNumberBox.Value := -999;
  CWallNumberBox1.Value := -999;
  CWallNumberBox2.Value := -999;
  CWallNumberBox3.Value := -999;
end;

procedure TForm2.CreateConstructionButtonClick(Sender: TObject);
var
  Construction: TConstruction;
  ConstructionName: String;
  ConstructionExists: Boolean;
begin
  DerobModel.HouseProperties.BoolValue['ConstructionChange'] := False;
  ConstructionExists := False;
  // Create new construction instance

  Construction := TConstruction.Create;
  Construction.StringValue['ConstructionType'] := CurrentCategory;

  // Assign a sensible name to the new instance
  if InputQuery('Skapa konstruktion', 'Namn: ', ConstructionName) then
  begin
    Construction.Name := ConstructionName;
    // Loopar genom befintliga konstruktioner
    for i := 0 to DerobModel.ConstructionCount - 1 do
    begin
      // Kollar om den nya konstruktionens namn redan är använt
      if Construction.Name = DerobModel.Constructions[i].Name then
      begin
        ShowMessage('Konstruktionen existerar redan, välj nytt namn');
        ConstructionExists := True;
        break;
      end;
    end;
    // Lägger till den nya konstruktionen om den har ett unikt namn
    if (Construction.Name <> '') and (ConstructionExists = False) then
    begin
      DerobModel.AddConstruction(Construction);
      DerobModel.HouseProperties.BoolValue['ConstructionChange'] := True;
    end;
  end;





  // Update list boxes to reflect changes

  UpdateConstructionList;
  ConstructionListBox.ItemIndex := ConstructionListBox.Count - 1;
  UpdateLayerList;
  // SetData;

end;

procedure TForm2.RemoveConstructionButtonClick(Sender: TObject);
var
  Construction: TConstruction;
begin
  if ConstructionListBox.ItemIndex <> -1 then
  begin

    // Extract selected construction index

    // Construction := DerobModel.Constructions[CWallListBox1.ItemIndex];
    Construction := ConstructionListBox.Items.Objects
      [ConstructionListBox.ItemIndex] as TConstruction;

    // Remove instance from DerobModel

    DerobModel.RemoveConstruction(Construction);

    // Update list boxes to reflect changes in the DerobModel

    UpdateConstructionList;
    ConstructionListBox.ItemIndex := ConstructionListBox.Count - 1;
    UpdateLayerList;
    if (ConstructionListBox.Count > 0) then
    begin
      LayerListBox.ItemIndex := 0;
      UpdateLayerThicknessBox;
    end;
  end;
end;

procedure TForm2.RemoveLayerButtonClick(Sender: TObject);
var
  Material: TMaterial;
  Construction: TConstruction;
begin

  if (LayerListBox.ItemIndex <> -1) and (ConstructionListBox.ItemIndex <> -1)
  then
  begin
    Construction := ConstructionListBox.Items.Objects
      [ConstructionListBox.ItemIndex] as TConstruction;
    Material := Construction.Layers[LayerListBox.ItemIndex];
    Construction.RemoveLayer(Material);

    UpdateLayerList;
    UpdateUValue;
    UpdateLayerThicknessBox;
  end
  else
  begin
    ShowMessage('Välj lager och konstruktion');
  end;

end;

procedure TForm2.AddLayerButtonClick(Sender: TObject);
var
  Material: TMaterial;
  Construction: TConstruction;
  Thickness: String;

begin

  // Make sure a material and a construction is selected.

  if (MaterialListBox.ItemIndex <> -1) and (ConstructionListBox.ItemIndex <> -1)
  then
  begin

    // Extract selected material and construction.

    Material := DerobModel.Materials[MaterialListBox.ItemIndex +
      (GlassMatCount + GasMatCount)];
    Construction := ConstructionListBox.Items.Objects
      [ConstructionListBox.ItemIndex] as TConstruction;

    // Add material as a layer in the construction instance.
    Thickness := '';
    if InputQuery('Lagertjocklek', 'Tjocklek (mm):', Thickness) then
    begin
      if Thickness <> '' then
      begin
        Construction.AddLayer(Material, StrToFloat(Thickness));
      end;
    end;
    // Update layer list box

    UpdateLayerList;
    UpdateUValue;
    UpdateLayerThicknessBox;
  end
  else
  begin
    ShowMessage('Välj en konstruktion och det material ni vill lägga till');
  end;
end;

procedure TForm2.AddMaterialButtonClick(Sender: TObject);
var
  Material: TMaterial;
  MaterialName, Lambda, Density, HeatCapacity: string;
  MaterialExists: Boolean;
begin
  // Tillsätter standard värden
  Lambda := '1';
  Density := '1';
  HeatCapacity := '1';
  MaterialExists := False;

  // Create a new material instance

  Material := TMaterial.Create;

  Material.StringValue['MaterialType'] := 'Opaque';

  // Set name to a sensible default
  if InputQuery('Nytt Material', 'Namn:', MaterialName) and
    (InputQuery('Nytt Material', 'Lambdavärde (W/m*K):', Lambda)) and
    (InputQuery('Nytt Material', 'Densitet (kg/m3):', Density)) and
    (InputQuery('Nytt Material', 'Spec.Värmekap (J/kg*K):', HeatCapacity)) then
  begin
    Material.Name := MaterialName;
    Material.DoubleValue['Lambda'] := StrToFloat(Lambda);
    Material.DoubleValue['Density'] := StrToFloat(Density);
    Material.DoubleValue['  HeatCapacity'] := StrToFloat(HeatCapacity) / 3600;
    // Loopar över materialen
    for i := 0 to DerobModel.MaterialCount - 1 do
    begin
      // Kollar om materialnamnet är unikt
      if Material.Name = DerobModel.Materials[i].Name then
      begin
        ShowMessage('Konstruktionen existerar redan, välj nytt namn');
        MaterialExists := True;
        break;
      end;
    end;
    // Försöker ej lägga till materialet om det inte har ett unikt namn
    if (MaterialExists = False) then
    begin
      if (Material.Name <> '') and (Material.DoubleValue['Lambda'] > 0) and
        (Material.DoubleValue['Density'] > 0) and
        (Material.DoubleValue['HeatCapacity'] > 0) then
      begin
        DerobModel.AddMaterial(Material);
        DerobModel.HouseProperties.BoolValue['ConstructionChange'] := True;
      end
      else
      begin
        ShowMessage('Var god och fyll i all information om materialet');
      end;
    end;
  end;

  // Add material to the DerobModel


  // Update the material list box

  UpdateMaterialList;
  MaterialListBox.ItemIndex := MaterialListBox.Count - 1;
  UpdateMaterialConstants;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  val, FileReWrite: Integer;
  FileName: string;
begin
  val := 0;
  SetCurrentDir(DerobModel.HouseProperties.StringValue['StartDir']);
  SetCurrentDir('Constructions');
  DerobModel.HouseProperties.BoolValue['ConstructionLib'] := True;
  if InputQuery('Spara konstruktionsbibliotek', 'Biblioteksnamn: ', FileName)
  then
  begin
    DerobModel.FileName := FileName;
    // Sparar konstruktionsbiblioteket med namnet användaren har fyllt i
    if DerobModel.FileName <> '' then
    begin
      DerobModel.FileName := DerobModel.FileName + '.con';
      if FileExists(DerobModel.FileName) then
      begin
        FileReWrite :=
          MessageDlg('Konstruktionsbibliotek existerar redan, skriv över?',
          TMsgDlgType.mtWarning, mbYesNo, 0);
        if FileReWrite = mrYes then
        begin

          DerobModel.Save;
          DerobModel.HouseProperties.BoolValue['ConstructionChange'] := False;
        end;
      end
      else
      begin

        DerobModel.Save;
        DerobModel.HouseProperties.BoolValue['ConstructionChange'] := False;
      end;
    end
    // Om användaren inte fyller i något
    else
    begin
      DerobModel.FileName := DateToStr(Now) + '.con';
      repeat
        if FileExists(DerobModel.FileName) then
          inc(val);
        DerobModel.FileName := DateToStr(Now) + '(' + IntToStr(val) + ').con';

      until FileExists(DerobModel.FileName) = False;

      DerobModel.Save;
      DerobModel.HouseProperties.BoolValue['ConstructionChange'] := False;
    end;
  end;
end;

procedure TForm2.RemoveMaterialButtonClick(Sender: TObject);
var
  Material: TMaterial;
  j: Integer;
begin
  if MaterialListBox.ItemIndex <> -1 then
  begin

    // Extract selected material instance

    Material := DerobModel.Materials[MaterialListBox.ItemIndex +
      (GlassMatCount + GasMatCount)];

    // Kollar om det borttagna materialet finns i någon konstruktion och tar då bort det materiallagret
    for i := 0 to DerobModel.ConstructionCount - 1 do
    begin
      for j := 0 to DerobModel.Constructions[i].LayerCount - 1 do
      begin
        if DerobModel.Constructions[i].Layers[j].Name = Material.Name then
        begin
          DerobModel.Constructions[i].RemoveLayer(Material);
          break;
        end;
      end;
    end;

    // Remove material from DerobModel

    DerobModel.RemoveMaterial(Material);

    // Update list boxes to reflect changes in the model

    UpdateMaterialList;
    MaterialListBox.ItemIndex := MaterialListBox.Count - 1;
    UpdateMaterialConstants;
    UpdateLayerList;
  end;
end;

procedure TForm2.ConstructionListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  UpdateLayerList;
  UpdateLayerThicknessBox;
  // SetData;
end;

procedure TForm2.MaterialListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  UpdateMaterialConstants;
  if MaterialListBox.ItemIndex < 10 then
  begin
    RemoveMaterialButton.Enabled := False;
  end
  else
  begin
    RemoveMaterialButton.Enabled := True;
  end;
end;

procedure TForm2.menuSelected;
begin
  CMenuItem1.IsSelected := False;
  CMenuItem1.IsChecked := False;
  CMenuItem2.IsSelected := False;
  CMenuItem2.IsChecked := False;
  CMenuItem3.IsSelected := False;
  CMenuItem3.IsChecked := False;
  CMenuItem4.IsSelected := False;
  CMenuItem4.IsChecked := False;
  CMenuItem5.IsSelected := False;
  CMenuItem5.IsChecked := False;

end;

procedure TForm2.PopupBox1Change(Sender: TObject);
begin
  // If-sats för att programmet inte ska crasha när listan tömms och fylls om på nytt.
  if PopupBox1.Items.Count > 0 then
  begin
    DerobModel.HouseProperties.BoolValue['ConstructionLib'] := True;
    DerobModel.FileName := PopupBox1.Text;
    DerobModel.Open;
    UpdateMaterialList;
    UpdateConstructionList;
    if ConstructionListBox.Count > 0 then
    begin
      ConstructionListBox.ItemIndex := 0;
      UpdateLayerList;
      if DerobModel.Constructions[23].LayerCount > 0 then
      begin
        Form2.LayerListBox.ItemIndex := 0;
        UpdateLayerThicknessBox;
      end;
    end;
    MaterialListBox.ItemIndex := 0;
    UpdateMaterialConstants;
  end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveBeforeExit;
end;

procedure TForm2.FormShow(Sender: TObject);
var
  searchResult: TSearchRec;
begin
  CurrentCategory := 'Wall';
  if ConstructionListBox.Count > 0 then
  begin
    ConstructionListBox.ItemIndex := 0;
    UpdateLayerList;
    if DerobModel.Constructions[23].LayerCount > 0 then
    begin
      Form2.LayerListBox.ItemIndex := 0;
      UpdateLayerThicknessBox;
    end;
  end;
  MaterialListBox.ItemIndex := 0;
  UpdateMaterialConstants;
  SetCurrentDir(DerobModel.HouseProperties.StringValue['StartDir']);
  SetCurrentDir('Constructions');
  PopupBox1.Items.Clear;
  if FindFirst('*.con', faReadOnly, searchResult) = 0 then
  begin
    repeat
    begin
      // Lägger till filnamnen i Popupboxen
      PopupBox1.Items.Add(searchResult.Name);
    end;
    until FindNext(searchResult) <> 0;
    findClose(searchResult);
  end;
  DerobModel.HouseProperties.BoolValue['ConstructionChange'] := False;
end;

procedure TForm2.LayerListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  UpdateLayerThicknessBox;
end;

procedure TForm2.SaveBeforeExit;
var
  SaveChange, FileReWrite, val: Integer;
  FileName: String;
begin
  // Kollar om det har skett ändringar
  if DerobModel.HouseProperties.BoolValue['ConstructionChange'] = True then
  begin
    // Visar ruta som frågar om man vill spara ändringarna
    SaveChange := MessageDlg
      ('Ändringar har skett, spara konstruktionsbibliotek?',
      TMsgDlgType.mtWarning, mbYesNo, 0);
    // Om användaren vill spara...
    if SaveChange = mrYes then
    begin
      // Namnet på biblioteket användaren vill spara
      if InputQuery('Spara konstruktionsbibliotek', 'Biblioteksnamn: ', FileName)
      then
      begin
        DerobModel.FileName := FileName + '.con';
        // Kollar om det redan finns ett sparat konstruktionsbibliotek med det namnet
        if FileExists(DerobModel.FileName) then
        begin
          // Frågar användaren om man vill skriva över biblioteket
          FileReWrite :=
            MessageDlg('Konstruktionsbibliotek existerar redan, skriv över?',
            TMsgDlgType.mtWarning, mbYesNo, 0);
          // Sparar om biblioteket
          if FileReWrite = mrYes then
          begin
            DerobModel.Save;
            DerobModel.HouseProperties.BoolValue['ConstructionLib'] := False;
          end
          // Om användaren inte vill spara över filen så sparas den som "aktuellt datum.con"
          else
          begin
            DerobModel.FileName := DateToStr(Now) + '.con';
            repeat
              if FileExists(DerobModel.FileName) then
                inc(val);
              DerobModel.FileName := DateToStr(Now) + '(' + IntToStr(val)
                + ').con';
            until FileExists(DerobModel.FileName) = False;
            DerobModel.Save;
            DerobModel.HouseProperties.BoolValue['ConstructionLib'] := False;
          end;
        end;
      end;
    end;
  end;
  DerobModel.HouseProperties.BoolValue['ConstructionChange'] := False;
  CUpdateComboBox;
end;

procedure TForm2.SetCurrentCategory(const Value: string);
begin
  FCurrentCategory := Value;
end;

// procedure TForm2.SetData;
// var
// Construction: TConstruction;
// Material: TMaterial;
//
// begin
//
// // Is there a construction selected?
//
// if ConstructionListBox.ItemIndex <> -1 then
// begin
//
// // Is there a layer selected?
//
// if LayerListBox.ItemIndex <> -1 then
// begin
//
// // Extract selected construction and material
//
// Construction := ConstructionListBox.Items.Objects
// [ConstructionListBox.ItemIndex] as TConstruction;
// Material := Construction.Layers[LayerListBox.ItemIndex];
//
// // Convert value in edit box to a double and assign to
// // layer thickness.
//
// Construction.LayerThickness[LayerListBox.ItemIndex] :=
// (Self.CWallNumberBox3.Value);
// end;
// end;
//
// // Is there a material selected?
//
// if MaterialListBox.ItemIndex <> -1 then
// begin
//
// // Extract material instance
//
// Material := DerobModel.Materials[MaterialListBox.ItemIndex];
//
// // Assign material properties from edit boxes.
//
// Material.DoubleValue['Density'] := Self.CWallNumberBox2.Value;
// Material.DoubleValue['Lambda'] := Self.CWallNumberBox1.Value;
// end;
// end;

procedure TForm2.SetDerobModel(const Value: TDerobModel);
begin
  FDerobModel := Value;
end;

procedure TForm2.UpdateConstructionList;
var
  i: Integer;
  Construction: TConstruction;
begin

  // Clear all items in the list box

  Self.ConstructionListBox.Clear;
  if CurrentCategory = 'Glaze' then
    CurrentCategory := 'Window';
  // Loop over walls in derob model

  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    Construction := DerobModel.Constructions[i];
    if Construction.StringValue['ConstructionType'] = CurrentCategory then
      Self.ConstructionListBox.Items.AddObject(DerobModel.Constructions[i].Name,
        DerobModel.Constructions[i]);
  end;
end;

procedure TForm2.UpdateLayerList;
var
  i: Integer;
  Construction: TConstruction;
begin

  // Clear all items in the list box

  Self.LayerListBox.Clear;

  // Is a construction instance selected?

  if ConstructionListBox.ItemIndex <> -1 then
  begin

    // Loop over layers in construction

    Construction := ConstructionListBox.Items.Objects
      [ConstructionListBox.ItemIndex] as TConstruction;

    UNumberBox.Value := -999;
    LayerThicknessNumberBox.Value := -999;
    if Construction.LayerCount > 0 then
    begin
      for i := 0 to Construction.LayerCount - 1 do
        Self.LayerListBox.Items.AddObject(Construction.Layers[i].Name,
          Construction.Layers[i]);
      if CurrentCategory <> 'Window' then
      begin
        LayerListBox.ItemIndex := Construction.LayerCount - 1;
      end;
      UpdateUValue;
    end;
  end;
end;

procedure TForm2.UpdateLayerThicknessBox;
var
  i: Integer;
begin
  LayerThicknessNumberBox.Value := -999;
  if (CurrentCategory = 'Wall') or (CurrentCategory = 'Roof') or
    (CurrentCategory = 'Floor') then
  begin
    for i := 0 to DerobModel.ConstructionCount - 1 do
    begin
      if trim(ConstructionListBox.Selected.Text) = DerobModel.Constructions[i].Name
      then
      begin
        LayerThicknessNumberBox.Value := DerobModel.Constructions[i]
          .LayerThickness[LayerListBox.ItemIndex];
      end;
    end;
  end;
end;

procedure TForm2.UpdateMaterialConstants;
var
  Material: TMaterial;
  i: Integer;
begin
  CWallNumberBox1.Value := 0.00;
  CWallNumberBox2.Value := 0.00;
  CWallNumberBox3.Value := 0.00;

  if MaterialListBox.ItemIndex > -1 then
  begin

    GlassMatCount := 0;
    GasMatCount := 0;
    OpaqueMatCount := 0;
    // Ta reda på hur många det finns av varje materialtyp
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
      else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Opaque'
      then
      begin
        OpaqueMatCount := OpaqueMatCount + 1;
      end;
    end;

    Material := DerobModel.Materials[MaterialListBox.ItemIndex +
      (GlassMatCount + GasMatCount)];
    CWallNumberBox1.Value := Material.DoubleValue['Lambda'];
    CWallNumberBox2.Value := Material.DoubleValue['Density'];
    CWallNumberBox3.Value := 3600 * Material.DoubleValue['HeatCapacity'];
  end;
end;

procedure TForm2.UpdateMaterialList;
var
  i: Integer;
begin
  // Clear all items in the list box

  Self.MaterialListBox.Clear;

  // Fill list box with material instances

  for i := 0 to DerobModel.MaterialCount - 1 do
  begin
    if ((CurrentCategory = 'Glaze') or (CurrentCategory = 'Window')) and
      (DerobModel.Materials[i].StringValue['MaterialType'] = 'Glass') then
    begin
      MaterialListBox.Items.AddObject(DerobModel.Materials[i].Name,
        DerobModel.Materials[i]);
    end
    else if DerobModel.Materials[i].StringValue['MaterialType'] = 'Opaque' then
    begin
      MaterialListBox.Items.AddObject(DerobModel.Materials[i].Name,
        DerobModel.Materials[i]);
    end;
  end;
end;

procedure TForm2.UpdateUValue;
var
  i, j: Integer;
  RValue: array of double;

begin
  UNumberBox.Value := -999;
  if (CurrentCategory = 'Wall') or (CurrentCategory = 'Roof') or
    (CurrentCategory = 'Floor') then
  begin
    for i := 0 to DerobModel.ConstructionCount - 1 do
    begin
        if DerobModel.Constructions[i].LayerCount > 0 then
        begin
          SetLength(RValue, DerobModel.Constructions[i].LayerCount);
          for j := 0 to DerobModel.Constructions[i].LayerCount - 1 do
          begin
            RValue[j] := DerobModel.Constructions[i].LayerThickness[j] / 1000 /
              DerobModel.Constructions[i].Layers[j].DoubleValue['Lambda'];
          end;
          DerobModel.Constructions[i].DoubleValue['UValue'] :=
          1 / (0.04 + 0.13 + Sum(RValue));
        end;
    end;
    for i := 0 to DerobModel.ConstructionCount - 1 do
      begin
        if trim(ConstructionListBox.Selected.Text) = DerobModel.Constructions[i].Name then
          begin
             UNumberBox.Value := DerobModel.Constructions[i].DoubleValue['UValue'];
          end;
      end;
  end;
end;

procedure TForm2.CMenuItem1Click(Sender: TObject);
begin
  menuSelected;
  EnableButton;
  CurrentCategory := 'Wall';
  Form2.Caption := 'Konstruktioner - Väggar';
  UpdateConstructionList;
  if ConstructionListBox.Count > 0 then
  begin
    ConstructionListBox.ItemIndex := 0;
  end;
  UpdateLayerList;
  if LayerListBox.Count > 0 then
  begin
    LayerListBox.ItemIndex := 0;
    UpdateLayerThicknessBox;
  end;
  UpdateMaterialList;
  MaterialListBox.ItemIndex := 0;
  UpdateMaterialConstants;
  CWallLabel.Text := 'Väggar';
  LayerListBox.Enabled := True;
  CMenuItem1.IsSelected := True;
  CMenuItem1.IsChecked := True;

end;

procedure TForm2.CMenuItem2Click(Sender: TObject);
begin
  menuSelected;
  EnableButton;
  CurrentCategory := 'Roof';
  Form2.Caption := 'Konstruktioner - Tak';
  UpdateConstructionList;
  if ConstructionListBox.Count > 0 then
  begin
    ConstructionListBox.ItemIndex := 0;
  end;
  UpdateLayerList;
  if LayerListBox.Count > 0 then
  begin
    LayerListBox.ItemIndex := 0;
    UpdateLayerThicknessBox;
  end;
  UpdateMaterialList;
  MaterialListBox.ItemIndex := 0;
  UpdateMaterialConstants;
  CWallLabel.Text := 'Tak';
  LayerListBox.Enabled := True;
  CMenuItem2.IsSelected := True;
  CMenuItem2.IsChecked := True;

end;

procedure TForm2.CMenuItem3Click(Sender: TObject);
begin
  menuSelected;
  EnableButton;
  CurrentCategory := 'Floor';
  Form2.Caption := 'Konstruktioner - Golv';
  UpdateConstructionList;
  if ConstructionListBox.Count > 0 then
  begin
    ConstructionListBox.ItemIndex := 0;
  end;
  UpdateLayerList;
  if LayerListBox.Count > 0 then
  begin
    LayerListBox.ItemIndex := 0;
    UpdateLayerThicknessBox;
  end;
  UpdateMaterialList;
  MaterialListBox.ItemIndex := 0;
  UpdateMaterialConstants;
  CWallLabel.Text := 'Golv';
  LayerListBox.Enabled := True;
  CMenuItem3.IsSelected := True;
  CMenuItem3.IsChecked := True;

end;

procedure TForm2.CMenuItem4Click(Sender: TObject);
begin
  menuSelected;
  DisableButton;
  CurrentCategory := 'Glaze';
  Form2.Caption := 'Konstruktioner - Inglasningar';
  UpdateConstructionList;
  ConstructionListBox.ItemIndex := 0;
  UpdateLayerList;
  UpdateMaterialList;
  CWallLabel.Text := 'Inglasning';
  LayerListBox.Enabled := False;
  CMenuItem4.IsSelected := True;
  CMenuItem4.IsChecked := True;

end;

procedure TForm2.CMenuItem5Click(Sender: TObject);
begin
  menuSelected;
  DisableButton;
  CurrentCategory := 'Window';
  Form2.Caption := 'Konstruktioner - Fönster';
  UpdateConstructionList;
  ConstructionListBox.ItemIndex := 0;
  UpdateLayerList;
  UpdateMaterialList;
  CWallLabel.Text := 'Fönster';
  LayerListBox.Enabled := False;
  CMenuItem5.IsSelected := True;
  CMenuItem5.IsChecked := True;

end;

end.
