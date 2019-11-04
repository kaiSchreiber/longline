unit reject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg;

function Encode(i: string): string;

type
  TFormReject = class(TForm)
    Image1: TImage;
    ExtraLines: TCheckBox;
    NoLines: TCheckBox;
    NoConnect: TCheckBox;
    NoLicense: TCheckBox;
    Comment: TEdit;
    ButtonReject: TButton;
    ButtonCancel: TButton;
    ButtonRemove: TButton;
    KeepImage: TCheckBox;
    DoBlacklist: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure ButtonRejectClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormReject: TFormReject;

implementation

uses main, options;

{$R *.dfm}

procedure TFormReject.FormShow(Sender: TObject);

begin
  currentImage:=TJPEGImage.Create;
  currentImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'images/'+Images[FormReject.Tag].id+'.sm.jpg');
  Image1.Canvas.StretchDraw(Rect(0,0,169,169),currentImage);
  Comment.Text:='';
  if not Images[FormReject.Tag].inpool then ButtonReject.Enabled:=false else ButtonReject.Enabled:=godmode;
end;

procedure TFormReject.ButtonRejectClick(Sender: TObject);
var rq,p,val: string;

begin
  if Sender=ButtonReject then
   // reject from the group, as well
   begin
    // we'll need the image thumbnail's URL
    val:='&email='+FormOptions.User.Text+'&password='+FormOptions.Pass.Text;
    val:=val+'&api_key='+FormOptions.Apikey.Text;
    rq:='http://www.flickr.com/services/rest/?method=flickr.photos.getSizes&photo_id='+Images[FormReject.Tag].id+val;
    p:=FormMain.Brause.Get(rq);
    // image url
    if postingstring<>'' then postingstring:=postingstring+#13#10;
    postingstring:=postingstring+'<a href="http://www.flickr.com/photos/'+Images[FormReject.Tag].owner+'/'+Images[FormReject.Tag].id+'">';
    postingstring:=postingstring+'<img src="'+GetValue(Copy(p,Pos('Square',p),200),'source')+'"></a>'#13#10;
    if fileprefix='longline' then
     begin
      if ExtraLines.Checked then postingstring:=postingstring+'Contains extra lines.'#13#10;
      if NoLines.Checked then postingstring:=postingstring+'Lines not visible enough.'#13#10;
      if NoConnect.Checked then postingstring:=postingstring+'Lines do not connect to sides.'#13#10;
     end
    else
     begin
      if ExtraLines.Checked then postingstring:=postingstring+'Areas not homogenous.'#13#10;
      if NoLines.Checked then postingstring:=postingstring+'Not enough contrast.'#13#10;
      if NoConnect.Checked then postingstring:=postingstring+'Boundaries do not connect.'#13#10;
     end;
    if NoLicense.Checked then postingstring:=postingstring+'Incorrect or no license. Please change and resubmit.'#13#10;
    if Comment.Text<>'' then postingstring:=postingstring+Comment.Text+#13#10;
    FormMain.PostToGroup.Enabled:=true;
    FormMain.PostToGroup.Visible:=true;
    rq:='http://www.flickr.com/services/rest/?method=flickr.groups.pools.remove&photo_id='+Images[FormReject.tag].id+val;
    rq:=rq+'&group_id='+groupid;
    p:=FormMain.Brause.Get(rq);
   end;

  if DoBlacklist.Checked then
   begin
    SetLength(blacklist,Length(blacklist)+1);
    blacklist[High(blacklist)]:=Images[FormReject.tag].id;
   end;
  if not KeepImage.Checked then RemoveTile(FormReject.Tag);
  if FormMain.NavMode.ItemIndex=2 then FormMain.NavModeChange(FormMain.NavMode)
    else if Length(grid)>0 then FormMain.MakeLargeClick(Sender);
  FormMain.Enabled:=true;
  FormReject.tag:=-1;
  FormReject.Hide;
end;

function Encode(i: string): string;

begin
  while Pos(' ',i)>0 do
    i:=Copy(i,1,Pos(' ',i)-1)+'%20'+Copy(i,Pos(' ',i)+1,Length(i));
  Encode:=i+'%0D';
end;

procedure TFormReject.ButtonCancelClick(Sender: TObject);
begin
  FormMain.Enabled:=true;
  FormReject.Hide;
end;

end.
