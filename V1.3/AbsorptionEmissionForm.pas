unit AbsorptionEmissionForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Layouts, derob, FMX.Edit, System.Actions, FMX.ActnList;

type
  TForm4 = class(TForm)
    ListBox1: TListBox;
    RoofItem: TListBoxItem;
    FloorItem: TListBoxItem;
    NWallItem: TListBoxItem;
    EWallItem: TListBoxItem;
    SWallItem: TListBoxItem;
    WWallItem: TListBoxItem;
    RoofAbs1: TNumberBox;
    RoofAbs2: TNumberBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    AbsSaveButton: TButton;
    FloorAbs1: TNumberBox;
    FloorAbs2: TNumberBox;
    NWallAbs1: TNumberBox;
    NWallAbs2: TNumberBox;
    EWallAbs1: TNumberBox;
    EWallAbs2: TNumberBox;
    Em1: TNumberBox;
    Em2: TNumberBox;
    SWallAbs1: TNumberBox;
    SWallAbs2: TNumberBox;
    WWallAbs1: TNumberBox;
    WWallAbs2: TNumberBox;
    procedure RoofItemClick(Sender: TObject);
    procedure FloorItemClick(Sender: TObject);
    procedure NWallItemClick(Sender: TObject);
    procedure EWallItemClick(Sender: TObject);
    procedure SWallItemClick(Sender: TObject);
    procedure WWallItemClick(Sender: TObject);
    procedure AbsCancelButtonClick(Sender: TObject);
    procedure AbsSaveButtonClick(Sender: TObject);

  private
    { Private declarations }
    FDerobModel : TDerobModel;
    procedure SetDerobModel(const Value: TDerobModel);
    procedure AbsHide;
    procedure AbsSave;
  public
    { Public declarations }
    property DerobModel : TDerobModel read FDerobModel write SetDerobModel;
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

uses mainFormny;

{ TForm4 }

procedure TForm4.RoofItemClick(Sender: TObject);
begin
Form4.Caption:= 'Absorption/Emittans - Tak';
AbsHide;
RoofAbs1.Visible:=True;
RoofAbs2.Visible:=True;
end;

procedure TForm4.FloorItemClick(Sender: TObject);
begin
Form4.Caption:= 'Absorption/Emittans - Golv';
AbsHide;
FloorAbs1.Visible:=True;
FloorAbs2.Visible:=True;
end;

procedure TForm4.NWallItemClick(Sender: TObject);
begin
Form4.Caption:= 'Absorption/Emittans - V�gg Nord';
AbsHide;
NWallAbs1.Visible:=True;
NWallAbs2.Visible:=True;
end;

procedure TForm4.EWallItemClick(Sender: TObject);
begin
Form4.Caption:= 'Absorption/Emittans - V�gg �st';
AbsHide;
EWallAbs1.Visible:=True;
EWallAbs2.Visible:=True;
end;

procedure TForm4.SWallItemClick(Sender: TObject);
begin
Form4.Caption:= 'Absorption/Emittans - V�gg Syd';
AbsHide;
SWallAbs1.Visible:=True;
SWallAbs2.Visible:=True;
end;

procedure TForm4.WWallItemClick(Sender: TObject);
begin
Form4.Caption:= 'Absorption/Emittans - V�gg V�st';
AbsHide;
WWallAbs1.Visible:=True;
WWallAbs2.Visible:=True;
end;

procedure TForm4.AbsCancelButtonClick(Sender: TObject);
begin
Form4.Close;
end;

procedure TForm4.AbsHide;
begin
  RoofAbs1.Visible:=False;
  RoofAbs2.Visible:=False;
  FloorAbs1.Visible:=False;
  FloorAbs2.Visible:=False;
  NWallAbs1.Visible:=False;
  NWallAbs2.Visible:=False;
  EWallAbs1.Visible:=False;
  EWallAbs2.Visible:=False;
  SWallAbs1.Visible:=False;
  SWallAbs2.Visible:=False;
  WWallAbs1.Visible:=False;
  WWallAbs2.Visible:=False;
end;

procedure TForm4.AbsSave;
begin
  DerobModel.Roofs[0].Properties.IntValue['AbsorptionFront']:=Round(RoofAbs1.Value);
  DerobModel.Roofs[0].Properties.IntValue['AbsorptionBack']:=Round(RoofAbs2.Value);
  DerobModel.Roofs[0].Properties.IntValue['Emittance']:=87;

  DerobModel.Floors[0].Properties.IntValue['AbsorptionFront']:=Round(FloorAbs1.Value);
  DerobModel.Floors[0].Properties.IntValue['AbsorptionBack']:=Round(FloorAbs2.Value);
  DerobModel.Floors[0].Properties.IntValue['Emittance']:=87;

  DerobModel.Walls[0].Properties.IntValue['AbsorptionFront']:=Round(NWallAbs1.Value);
  DerobModel.Walls[0].Properties.IntValue['AbsorptionBack']:=Round(NWallAbs2.Value);
  DerobModel.Walls[0].Properties.IntValue['Emittance']:=87;

  DerobModel.Walls[1].Properties.IntValue['AbsorptionFront']:=Round(EWallAbs1.Value);
  DerobModel.Walls[1].Properties.IntValue['AbsorptionBack']:=Round(EWallAbs2.Value);
  DerobModel.Walls[1].Properties.IntValue['Emittance']:=87;

  DerobModel.Walls[2].Properties.IntValue['AbsorptionFront']:=Round(SWallAbs1.Value);
  DerobModel.Walls[2].Properties.IntValue['AbsorptionBack']:=Round(SWallAbs2.Value);
  DerobModel.Walls[2].Properties.IntValue['Emittance']:=87;

  DerobModel.Walls[3].Properties.IntValue['AbsorptionFront']:=Round(WWallAbs1.Value);
  DerobModel.Walls[3].Properties.IntValue['AbsorptionBack']:=Round(WWallAbs2.Value);
  DerobModel.Walls[3].Properties.IntValue['Emittance']:=87;

  Form1.AbsComboBox.ItemIndex:=0;
  Form1.AbsNumberBox1.Value:= Round(RoofAbs1.Value);
  Form1.AbsNumberBox2.Value:= Round(RoofAbs2.Value);
end;

procedure TForm4.AbsSaveButtonClick(Sender: TObject);
begin
AbsSave;
end;

procedure TForm4.SetDerobModel(const Value: TDerobModel);
begin
  FDerobModel := Value;
end;

end.
