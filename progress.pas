unit progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormProgress = class(TForm)
    ProgressBar: TProgressBar;
    ProgOK: TButton;
    ProgressMemo: TMemo;
    procedure ProgOKClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormProgress: TFormProgress;

implementation

uses main;

{$R *.dfm}

procedure TFormProgress.ProgOKClick(Sender: TObject);
begin
 FormProgress.Close;
 FormProgress.ProgOK.Enabled:=false;
end;

procedure TFormProgress.FormHide(Sender: TObject);
begin
 FormMain.Enabled:=true;
end;

end.
