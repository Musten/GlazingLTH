unit constructionForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Layouts, FMX.ListBox, System.Actions, FMX.ActnList, FMX.Menus,
  derob,
  System.Rtti, FMX.Grid, Math;

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
    UNumberBox: TNumberBox;
    CLabel5: TLabel;
    CLabel6: TLabel;
    CLabel7: TLabel;
    CLabel8: TLabel;
    Label1: TLabel;
    LayerThicknessNumberBox: TNumberBox;
    Label2: TLabel;
    procedure ConstrExitButtonClick(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    procedure LayerListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
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

    procedure SetData;
    procedure GetData;
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

procedure TForm2.ConstrExitButtonClick(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.ConstrSaveButtonClick(Sender: TObject);
begin
  CUpdateComboBox;
  SetData;
  Form2.Close;
end;

procedure TForm2.CUpdateComboBox;
var
  Construction: TConstruction;
  i: Integer;
begin

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
  UNumberBox.Value := 0.00;
  CWallNumberBox1.Value := 0.00;
  CWallNumberBox2.Value := 0.00;
  CWallNumberBox3.Value := 0.00;

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
  UNumberBox.Value := 0.00;
  CWallNumberBox1.Value := 0.00;
  CWallNumberBox2.Value := 0.00;
  CWallNumberBox3.Value := 0.00;
end;

procedure TForm2.CreateConstructionButtonClick(Sender: TObject);
var
  Construction: TConstruction;
begin

  // Create new construction instance

  Construction := TConstruction.Create;
  Construction.StringValue['ConstructionType'] := CurrentCategory;

  // Assign a sensible name to the new instance

  Construction.Name := InputBox('Skapa konstruktion', 'Namn: ',
    Construction.Name);

  // Add instance to DerobModel

  if Construction.Name <> '' then
  begin
    DerobModel.AddConstruction(Construction);
  end;

  // Update list boxes to reflect changes

  UpdateConstructionList;
  UpdateLayerList;
  SetData;

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
    UpdateLayerList;
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
  end
  else
  begin
    ShowMessage('Välj lager att ta bort för konstruktionen');
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

    Thickness := InputBox('Lagertjocklek', 'Tjocklek (mm):', Thickness);
    Construction.AddLayer(Material, StrToFloat(Thickness));
    // Update layer list box

    UpdateLayerList;
    UpdateUValue;
  end
  else
  begin
  ShowMessage('Välj en konstruktion och det material ni vill lägga till');
  end;
end;

procedure TForm2.AddMaterialButtonClick(Sender: TObject);
var
  Material: TMaterial;
begin

  // Create a new material instance

  Material := TMaterial.Create;

  Material.StringValue['MaterialType'] := 'Opaque';

  // Set name to a sensible default
  Material.Name := InputBox('Nytt Material', 'Namn:', Material.Name);
  Material.DoubleValue['Lambda'] :=
    StrToFloat(InputBox('Nytt Material', 'Lambdavärde (W/m*K):', '0'));
  Material.DoubleValue['Density'] :=
    StrToFloat(InputBox('Nytt Material', 'Densitet (kg/m3):', '0'));
  Material.DoubleValue['HeatCapacity'] :=
    (StrToFloat(InputBox('Nytt Material', 'Spec.Värmekap (J/kg*K):',
    '0'))) / 3600;

  // Add material to the DerobModel
  if (Material.Name <> '') and (Material.DoubleValue['Lambda'] > 0) and
    (Material.DoubleValue['Density'] > 0) and
    (Material.DoubleValue['HeatCapacity'] > 0) then
  begin
    DerobModel.AddMaterial(Material);
  end
  else
  begin
    ShowMessage('Var god och fyll i all information om materialet');
  end;

  // Update the material list box

  UpdateMaterialList;
end;

procedure TForm2.RemoveMaterialButtonClick(Sender: TObject);
var
  Material: TMaterial;
begin
  if MaterialListBox.ItemIndex <> -1 then
  begin

    // Extract selected material instance

    Material := DerobModel.Materials[MaterialListBox.ItemIndex +
      (GlassMatCount + GasMatCount)];

    // Remove material from DerobModel

    DerobModel.RemoveMaterial(Material);

    // Update list boxes to reflect changes in the model

    UpdateMaterialList;
  end;
end;

procedure TForm2.ConstructionListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  // Update layer list

  UpdateLayerList;
  UpdateUValue;

  SetData;
end;

procedure TForm2.MaterialListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  Material: TMaterial;
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

procedure TForm2.FormCreate(Sender: TObject);
begin
  CurrentCategory := 'Wall';
end;

procedure TForm2.GetData;
begin
end;

procedure TForm2.LayerListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  i: Integer;
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

procedure TForm2.SetCurrentCategory(const Value: string);
begin
  FCurrentCategory := Value;
end;

procedure TForm2.SetData;
var
  Construction: TConstruction;
  Material: TMaterial;

begin

  // Is there a construction selected?

  if ConstructionListBox.ItemIndex <> -1 then
  begin

    // Is there a layer selected?

    if LayerListBox.ItemIndex <> -1 then
    begin

      // Extract selected construction and material

      Construction := ConstructionListBox.Items.Objects
        [ConstructionListBox.ItemIndex] as TConstruction;
      Material := Construction.Layers[LayerListBox.ItemIndex];

      // Convert value in edit box to a double and assign to
      // layer thickness.

      Construction.LayerThickness[LayerListBox.ItemIndex] :=
        (Self.CWallNumberBox3.Value);
    end;
  end;

  // Is there a material selected?

  if MaterialListBox.ItemIndex <> -1 then
  begin

    // Extract material instance

    Material := DerobModel.Materials[MaterialListBox.ItemIndex];

    // Assign material properties from edit boxes.

    Material.DoubleValue['Density'] := Self.CWallNumberBox2.Value;
    Material.DoubleValue['Lambda'] := Self.CWallNumberBox1.Value;
  end;
end;

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

    for i := 0 to Construction.LayerCount - 1 do
      Self.LayerListBox.Items.AddObject(Construction.Layers[i].Name,
        Construction.Layers[i]);
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
  UNumberBox.Value := 999;
  for i := 0 to DerobModel.ConstructionCount - 1 do
  begin
    if trim(ConstructionListBox.Selected.Text) = DerobModel.Constructions[i].Name
    then
    begin
      if DerobModel.Constructions[i].LayerCount > 0 then
      begin
        SetLength(RValue, DerobModel.Constructions[i].LayerCount);
        for j := 0 to DerobModel.Constructions[i].LayerCount - 1 do
        begin
          RValue[j] := DerobModel.Constructions[i].LayerThickness[j] / 1000 /
            DerobModel.Constructions[i].Layers[j].DoubleValue['Lambda'];
        end;
        UNumberBox.Value := 1 / (0.04 + 0.13 + Sum(RValue));
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
  UpdateLayerList;
  UpdateMaterialList;
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
  UpdateLayerList;
  UpdateMaterialList;
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
  UpdateLayerList;
  UpdateMaterialList;
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
  UpdateLayerList;
  UpdateMaterialList;
  CWallLabel.Text := 'Fönster';
  LayerListBox.Enabled := False;
  CMenuItem5.IsSelected := True;
  CMenuItem5.IsChecked := True;

end;

end.
