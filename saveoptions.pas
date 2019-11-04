unit saveoptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormSaveOptions = class(TForm)
    SOCancel: TButton;
    SOGo: TButton;
    SOTileSize: TEdit;
    Label1: TLabel;
    SOPadding: TCheckBox;
    SOBorder: TEdit;
    SORatioX: TEdit;
    Label3: TLabel;
    SORatioY: TEdit;
    SOSeparators: TCheckBox;
    SOLineWidth: TEdit;
    LabelSO: TLabel;
    SOLowerContrast: TCheckBox;
    SOBackContrast: TEdit;
    Label4: TLabel;
    SOSplitImage: TCheckBox;
    SOSplitX: TEdit;
    Label5: TLabel;
    SOSplitY: TEdit;
    Label6: TLabel;
    SOLowLineWidth: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    SOAddBorder: TCheckBox;
    Label2: TLabel;
    PushColor: TCheckBox;
    ColorDistanceReduction: TEdit;
    Label23: TLabel;
    procedure SOCancelClick(Sender: TObject);
    procedure SOGoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSaveOptions: TFormSaveOptions;

implementation

uses main, options;

{$R *.dfm}

procedure TFormSaveOptions.SOCancelClick(Sender: TObject);
begin
  FormMain.Enabled:=true;
  FormSaveOptions.Hide;
end;

procedure TFormSaveOptions.SOGoClick(Sender: TObject);
begin
  FormSaveOptions.Hide;
  FormMain.SaveImageDoIt;
end;

procedure TFormSaveOptions.FormShow(Sender: TObject);
begin
  if FormOptions.CopyToSave.Checked then
    begin
      SOSeparators.Checked:=FormOptions.Separators.Checked;
      SOLineWidth.Text := FormOptions.LineWidth.Text;
      SOLowerContrast.Checked := FormOptions.LowerContrast.Checked;
      SOBackContrast.Text := FormOptions.BackContrast.Text;
      SOLineWidth.Text:=FormOptions.LineWidth.Text;
      PushColor.Checked:=FormOptions.PushColor.Checked;
      ColorDistanceReduction.Text:=FormOptions.ColorDistanceReduction.Text;
    end;
end;

end.
