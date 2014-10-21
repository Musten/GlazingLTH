unit internalheatForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, derob;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    PersonSpinBox: TSpinBox;
    PersonNumberBox: TNumberBox;
    Label2: TLabel;
    Label3: TLabel;
    AppliancesSpinBox: TSpinBox;
    AppliancesNumberBox: TNumberBox;
    Label4: TLabel;
    ElectronicButton: TButton;
    Label5: TLabel;
    OthersNumberBox: TNumberBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SumNumberBox: TNumberBox;
    Label9: TLabel;
    internalheatOkButton: TButton;
    internalheatCancelButton: TButton;
    RefreshSumButton: TButton;
    procedure ElectronicButtonClick(Sender: TObject);
    procedure PersonSpinBoxChange(Sender: TObject);
    procedure AppliancesSpinBoxChange(Sender: TObject);
    procedure OthersNumberBoxChange(Sender: TObject);
    procedure RefreshSumButtonClick(Sender: TObject);
    procedure internalheatCancelButtonClick(Sender: TObject);
    procedure internalheatOkButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

uses mainFormny;

procedure TForm3.AppliancesSpinBoxChange(Sender: TObject);
begin
AppliancesNumberBox.Value:=AppliancesSpinBox.Value*120; //Ta reda på ett bättre värde!
SumNumberBox.Value:= PersonNumberBox.Value+AppliancesNumberBox.Value+OthersNumberBox.Value;
end;

procedure TForm3.ElectronicButtonClick(Sender: TObject);
begin
ShowMessage('Antal hushållsapparater som Tvätt- och Diskmaskiner, Datorer och TVn');
end;

procedure TForm3.internalheatCancelButtonClick(Sender: TObject);
begin
Form3.Close;
end;

procedure TForm3.internalheatOkButtonClick(Sender: TObject);
begin
   SumNumberBox.Value:= PersonNumberBox.Value+AppliancesNumberBox.Value+OthersNumberBox.Value;
   Form1.IntHeatNumberBox.Value:=PersonNumberBox.Value+AppliancesNumberBox.Value+OthersNumberBox.Value;
   Form3.Close;
end;

procedure TForm3.OthersNumberBoxChange(Sender: TObject);
begin
SumNumberBox.Value:= PersonNumberBox.Value+AppliancesNumberBox.Value+OthersNumberBox.Value;
end;


procedure TForm3.PersonSpinBoxChange(Sender: TObject);
begin
PersonNumberBox.Value:=PersonSpinBox.Value*117;
SumNumberBox.Value:= PersonNumberBox.Value+AppliancesNumberBox.Value+OthersNumberBox.Value;
end;

procedure TForm3.RefreshSumButtonClick(Sender: TObject);
begin
SumNumberBox.Value:= PersonNumberBox.Value+AppliancesNumberBox.Value+OthersNumberBox.Value;
end;

end.
