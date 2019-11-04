unit colorpicker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormColPick = class(TForm)
    ColorMap: TImage;
    LumMap: TImage;
    Selected: TImage;
    ColorR: TEdit;
    ColorG: TEdit;
    ColorB: TEdit;
    R: TLabel;
    ButtonCancel: TButton;
    ButtonUse: TButton;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormColPick: TFormColPick;

implementation

{$R *.dfm}

end.
