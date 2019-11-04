unit options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, jpeg, Math;

var  usabletypecheck: array[0..17] of TCheckBox;

procedure UpdateDropList;

type
  TFormOptions = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    GridWidth: TEdit;
    GridHeight: TEdit;
    AutoSetSize: TCheckBox;
    NoOutside: TCheckBox;
    SingleLine: TCheckBox;
    Multiples: TCheckBox;
    PreferUnused: TCheckBox;
    AvoidEndings: TCheckBox;
    Limit: TCheckBox;
    LimitLow: TEdit;
    LimitHigh: TEdit;
    Select: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    UserName: TComboBox;
    NoExclude: TCheckBox;
    PoolOnly: TCheckBox;
    IgnoreLicense: TCheckBox;
    GroupBox4: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image19: TImage;
    Image20: TImage;
    UT8: TCheckBox;
    UT11: TCheckBox;
    UT5: TCheckBox;
    UT2: TCheckBox;
    UT14: TCheckBox;
    UT0: TCheckBox;
    UT12: TCheckBox;
    UT9: TCheckBox;
    UT10: TCheckBox;
    UT13: TCheckBox;
    UT7: TCheckBox;
    UT4: TCheckBox;
    UT3: TCheckBox;
    UT6: TCheckBox;
    UT1: TCheckBox;
    UT17: TCheckBox;
    UT15: TCheckBox;
    UT16: TCheckBox;
    ApplyUsability: TCheckBox;
    SetAll: TButton;
    SetNone: TButton;
    DoGame: TButton;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Apikey: TEdit;
    User: TEdit;
    Pass: TEdit;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    AutoUpdate: TCheckBox;
    FullUpdate: TCheckBox;
    AutoUpdateAll: TCheckBox;
    CheckUser: TCheckBox;
    CheckUserName: TEdit;
    SkipConfirm: TCheckBox;
    Button1: TButton;
    LoadColor: TButton;
    Label11: TLabel;
    ApplyColor: TCheckBox;
    ColorTolerance: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    UseBest: TEdit;
    ColorTargetMode: TRadioGroup;
    Label15: TLabel;
    Panel1: TPanel;
    ColorTarget: TImage;
    ColorTargetFilename: TEdit;
    AllowRotate: TCheckBox;
    PreferUpright: TCheckBox;
    SetMosaicWidth: TCheckBox;
    SetWidthTo: TEdit;
    ReportDim: TLabel;
    FillPattern: TCheckBox;
    TabSheet4: TTabSheet;
    ApplyGradient: TCheckBox;
    GradientTargetMode: TRadioGroup;
    Panel2: TPanel;
    GradientTarget: TImage;
    Label16: TLabel;
    LoadGradient: TButton;
    GradientTargetFilename: TEdit;
    UseColorTarget: TButton;
    GradientCutoff: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label22: TLabel;
    ColorTargetNeutral: TComboBox;
    TabSheet5: TTabSheet;
    GroupBox5: TGroupBox;
    SOSepWidth: TLabel;
    LineWidth: TEdit;
    Separators: TCheckBox;
    LowerContrast: TCheckBox;
    BackContrast: TEdit;
    Label20: TLabel;
    LowLineWidth: TEdit;
    Label21: TLabel;
    Label19: TLabel;
    GroupBox6: TGroupBox;
    PushColor: TCheckBox;
    ColorDistanceReduction: TEdit;
    Label23: TLabel;
    GroupBox7: TGroupBox;
    UseDrawSettings: TCheckBox;
    UseOnlyOnce: TCheckBox;
    CopyToSave: TCheckBox;
    GroupBox8: TGroupBox;
    LoadBGImage: TButton;
    BGFormat: TComboBox;
    BGExtent: TComboBox;
    BGFileName: TEdit;
    Panel3: TPanel;
    BGImage: TImage;
    MakeCommercial: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure AutoSetSizeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetAllClick(Sender: TObject);
    procedure SetNoneClick(Sender: TObject);
    procedure DoGameClick(Sender: TObject);
    procedure LoadColorClick(Sender: TObject);
    procedure ApplyColorClick(Sender: TObject);
    procedure SetWidthToChange(Sender: TObject);
    procedure LoadGradientClick(Sender: TObject);
    procedure UseColorTargetClick(Sender: TObject);
    procedure ApplyGradientClick(Sender: TObject);
    procedure LoadBGImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOptions: TFormOptions;

implementation

uses main;

{$R *.dfm}

procedure TFormOptions.Button1Click(Sender: TObject);
var SaveFile: TStringList;
    i,j: Integer;

begin
  SaveFile:=TStringList.Create;
  if GridWidth.Text='' then GridWidth.Text:='5';
  if GridHeight.Text='' then GridHeight.Text:='5';
  //if godmode then SaveFile.Values['apikey']:=Apikey.Text;
  SaveFile.Values['bgfilename']:=BGFileName.Text;
  SaveFile.Values['bgformat']:=IntToStr(BGFormat.ItemIndex);
  SaveFile.Values['bgextent']:=IntToStr(BGExtent.ItemIndex);
  SaveFile.Values['setwidthto']:=SetWidthTo.Text;
  SaveFile.Values['username']:=User.Text;
  SaveFile.Values['password']:=Pass.Text;
  SaveFile.Values['gridwidth']:=GridWidth.Text;
  SaveFile.Values['gridheight']:=GridHeight.Text;
  SaveFile.Values['singleusername']:=UserName.Text;
  SaveFile.Values['checkusername']:=CheckUserName.Text;
  SaveFile.Values['limitlow']:=LimitLow.Text;
  SaveFile.Values['limithigh']:=LimitHigh.Text;
  SaveFile.Values['colortolerance']:=ColorTolerance.Text;
  SaveFile.Values['colorusebest']:=UseBest.Text;
  SaveFile.Values['colortargetmode']:=IntToStr(ColorTargetMode.ItemIndex);
  SaveFile.Values['colortargetneutral']:=IntToStr(ColorTargetNeutral.ItemIndex);
  SaveFile.Values['colortargetfilename']:=ColorTargetFilename.Text;
  SaveFile.Values['gradienttargetmode']:=IntToStr(GradientTargetMode.ItemIndex);
  SaveFile.Values['gradienttargetfilename']:=GradientTargetFilename.Text;
  SaveFile.Values['tileborderlinewidth']:=LineWidth.Text;
  SaveFile.Values['backgroundcontrast']:=BackContrast.Text;
  SaveFile.Values['lowlinewidth']:=LowLineWidth.Text;
  SaveFile.Values['colordistancereduction']:=ColorDistanceReduction.Text;
  if MakeCommercial.Checked then SaveFile.Values['makecommercial']:='true' else SaveFile.Values['makecommercial']:='false';
  if UseDrawSettings.Checked then SaveFile.Values['usedrawsettings']:='true' else SaveFile.Values['usedrawsettings']:='false';
  if UseOnlyOnce.Checked then SaveFile.Values['useonlyonce']:='true' else SaveFile.Values['useonlyonce']:='false';
  if CopyToSave.Checked then SaveFile.Values['copytosave']:='true' else SaveFile.Values['copytosave']:='false';
  if PushColor.Checked then SaveFile.Values['pushtargetcolor']:='true' else SaveFile.Values['pushtargetcolor']:='false';
  if FillPattern.Checked then SaveFile.Values['fillpatternonload']:='true' else SaveFile.Values['fillpatternonload']:='false';
  if PreferUpright.Checked then SaveFile.Values['preferupright']:='true' else SaveFile.Values['preferupright']:='false';
  if AllowRotate.Checked then SaveFile.Values['allowrotate']:='true' else SaveFile.Values['allowrotate']:='false';
  if ApplyColor.Checked then SaveFile.Values['applycolor']:='true' else SaveFile.Values['applycolor']:='false';
  if ApplyGradient.Checked then SaveFile.Values['applygradient']:='true' else SaveFile.Values['applygradient']:='false';
  if AutoUpdate.Checked then SaveFile.Values['autoupdate']:='true' else SaveFile.Values['autoupdate']:='false';
  if FullUpdate.Checked then SaveFile.Values['fullupdate']:='true' else SaveFile.Values['fullupdate']:='false';
  if Multiples.Checked then SaveFile.Values['multiples']:='true' else SaveFile.Values['multiples']:='false';
  if AutoSetSize.Checked then SaveFile.Values['autosetsize']:='true' else SaveFile.Values['autosetsize']:='false';
  if NoOutside.Checked then SaveFile.Values['nooutside']:='true' else SaveFile.Values['nooutside']:='false';
  if SingleLine.Checked then SaveFile.Values['singleline']:='true' else SaveFile.Values['singleline']:='false';
  if NoExclude.Checked then SaveFile.Values['noexclude']:='true' else SaveFile.Values['noexclude']:='false';
  if PoolOnly.Checked then SaveFile.Values['poolonly']:='true' else SaveFile.Values['poolonly']:='false';
  if AutoUpdateAll.Checked then SaveFile.Values['autoupdateall']:='true' else SaveFile.Values['autoupdateall']:='false';
  if IgnoreLicense.Checked then SaveFile.Values['ignorelicense']:='true' else SaveFile.Values['ignorelicense']:='false';
  if CheckUser.Checked then SaveFile.Values['checkuser']:='true' else SaveFile.Values['checkuser']:='false';
  if SkipConfirm.Checked then SaveFile.Values['skipconfirm']:='true' else SaveFile.Values['skipconfirm']:='false';
  if PreferUnused.Checked then SaveFile.Values['preferunused']:='true' else SaveFile.Values['preferunused']:='false';
  if ApplyUsability.Checked then SaveFile.Values['applyusability']:='true' else SaveFile.Values['ignoreusability']:='false';
  if Limit.Checked then SaveFile.Values['limit']:='true' else SaveFile.Values['limit']:='false';
  if SetMosaicWidth.Checked then SaveFile.Values['setmosaicwidth']:='true' else SaveFile.Values['setmosaicwidth']:='false';
  if LowerContrast.Checked then SaveFile.Values['lowercontrast'] :='true' else SaveFile.Values['lowercontrast']:='false';
  if Separators.Checked then SaveFile.Values['drawtileborders'] := 'true' else SaveFile.Values['drawtileborders']:='false';
  for i:=0 to 17 do
   if usabletypecheck[i].Checked then SaveFile.Values['usabletype'+IntToStr(i)]:='true' else SaveFile.Values['usabletile'+IntToStr(i)]:='false';

  SaveFile.SaveToFile(ExtractFilePath(Application.ExeName)+fileprefix+'.opt');
  SaveFile.Free;
  if Multiples.Checked then for i:=0 to High(Images) do used[i]:=false
   else
     for i:=0 to High(grid) do
      for j:=0 to High(grid[0]) do
        if grid[i,j].index>-1 then
         used[grid[i,j].index]:=true;
  if FormMain.NavMode.ItemIndex=2 then FormMain.NavModeChange(FormMain.NavMode);
  FormMain.Enabled:=true;
  FormOptions.Hide;
  UpdateButtonState;
end;

procedure TFormOptions.AutoSetSizeClick(Sender: TObject);
begin
  GridWidth.Enabled:=not AutoSetSize.Checked;
  GridHeight.Enabled:=not AutoSetSize.Checked;
end;

procedure TFormOptions.FormShow(Sender: TObject);

begin
  UpdateDropList;
end;

procedure UpdateDropList;
var i: Integer;
    p: string;

begin
  p:=FormOptions.UserName.Text;
  FormOptions.UserName.Clear;
  FormOptions.UserName.AddItem('everyone''s',nil);
  FormOptions.UserName.AddItem('home team''s',nil);
  for i:=0 to High(Images) do
    if FormOptions.UserName.Items.IndexOf(Images[i].owner+'''s')=-1 then
      FormOptions.UserName.AddItem(Images[i].owner+'''s',nil);
  FormOptions.UserName.ItemIndex:=FormOptions.UserName.Items.IndexOf(p);
  if FormOptions.UserName.ItemIndex=-1 then FormOptions.UserName.ItemIndex:=0;
end;

procedure TFormOptions.SetAllClick(Sender: TObject);
var i: Integer;

begin
  for i:=0 to 17 do
    usabletypecheck[i].Checked:=true;
end;

procedure TFormOptions.SetNoneClick(Sender: TObject);
var i: Integer;

begin
  for i:=0 to 17 do
    usabletypecheck[i].Checked:=false;
end;

procedure TFormOptions.DoGameClick(Sender: TObject);
var i: Integer;
begin
  for i:=0 to 15 do
    usabletypecheck[i].Checked:=false;
  usabletypecheck[16].Checked:=true;
  usabletypecheck[17].Checked:=true;
end;

procedure TFormOptions.LoadColorClick(Sender: TObject);
var jpg: TJPEGImage;
    sc: Double;

begin
  if Sender=LoadColor then
   begin
    FormMain.OpenDialog.InitialDir := ExtractFilePath(Application.ExeName)+'targets';
    FormMain.OpenDialog.FileName:='';
    FormMain.OpenDialog.Filter:='Color target file|*.jpg;*.bmp';
    if not FormMain.OpenDialog.Execute then Exit;
   end;
  if Pos('.jpg',FormMain.OpenDialog.FileName)>0 then
   begin
    jpg:=TJPEGImage.Create;
    jpg.LoadFromFile(FormMain.OpenDialog.FileName);
    ColorTarget.Picture.Bitmap.Assign(jpg);
    jpg.Free;
   end
  else
   ColorTarget.Picture.LoadFromFile(FormMain.OpenDialog.FileName);
  ColorTarget.Width:=201; ColorTarget.Height:=201;                               
  if ColorTarget.Picture.Bitmap.Width>ColorTarget.Picture.Bitmap.Height then
    ColorTarget.Height:=Floor(201*ColorTarget.Picture.Bitmap.Height/ColorTarget.Picture.Bitmap.Width)
  else
    ColorTarget.Width:=Floor(201*ColorTarget.Picture.Bitmap.Width/ColorTarget.Picture.Bitmap.Height);
  ColorTargetFilename.Text:=FormMain.OpenDialog.FileName;
  ColorTargetLoaded:=true;
  ApplyColor.Checked:=true;
  AssignColorTarget;
  if SetMosaicWidth.Checked then
   begin
    sc:=Sqrt(ColorTarget.Picture.Width*ColorTarget.Picture.Height/StrToInt(SetWidthTo.Text));
    GridWidth.Text:=IntToStr(Round(ColorTarget.Picture.Width/sc));
    GridHeight.Text:=IntToStr(Round(ColorTarget.Picture.Height/sc));
    ReportDim.Caption:=GridWidth.Text+'x'+GridHeight.Text;
   end;
end;

procedure TFormOptions.ApplyColorClick(Sender: TObject);
begin
  if not ColorTargetLoaded then
    ApplyColor.Checked:=false;
end;

procedure TFormOptions.SetWidthToChange(Sender: TObject);
var sc: Double;

begin
  if SetMosaicWidth.Checked then
   begin
    sc:=Sqrt(ColorTarget.Picture.Width*ColorTarget.Picture.Height/StrToInt(SetWidthTo.Text));
    GridWidth.Text:=IntToStr(Round(ColorTarget.Picture.Width/sc));
    GridHeight.Text:=IntToStr(Round(ColorTarget.Picture.Height/sc));
    ReportDim.Caption:=GridWidth.Text+'x'+GridHeight.Text;
   end;
end;

procedure TFormOptions.LoadGradientClick(Sender: TObject);
var jpg: TJPEGImage;

begin
  if Sender=LoadGradient then
   begin
    FormMain.OpenDialog.InitialDir := ExtractFilePath(Application.ExeName)+'target';
    FormMain.OpenDialog.FileName:='';
    FormMain.OpenDialog.Filter:='Gradient target file|*.jpg;*.bmp';
    if not FormMain.OpenDialog.Execute then Exit;
   end;
  if Pos('.jpg',FormMain.OpenDialog.FileName)>0 then
   begin
    jpg:=TJPEGImage.Create;
    jpg.LoadFromFile(FormMain.OpenDialog.FileName);
    GradientTarget.Picture.Bitmap.Assign(jpg);
    jpg.Free;
   end
  else
   GradientTarget.Picture.LoadFromFile(FormMain.OpenDialog.FileName);
  if GradientTarget.Picture.Bitmap.Width>GradientTarget.Picture.Bitmap.Height then
    GradientTarget.Height:=Floor(201*GradientTarget.Picture.Bitmap.Height/GradientTarget.Picture.Bitmap.Width)
  else
    GradientTarget.Width:=Floor(201*GradientTarget.Picture.Bitmap.Width/GradientTarget.Picture.Bitmap.Height);
  GradientTargetFilename.Text:=FormMain.OpenDialog.FileName;
  GradientTargetLoaded:=true;
  ApplyGradient.Checked:=true;
end;

procedure TFormOptions.UseColorTargetClick(Sender: TObject);
begin
    FormOptions.GradientTargetFilename.Text:=FormOptions.ColorTargetFilename.Text;
    FormOptions.LoadGradientClick(FormMain);
end;

procedure TFormOptions.ApplyGradientClick(Sender: TObject);
begin
  if not GradientTargetLoaded then
    ApplyGradient.Checked:=false;
end;

procedure TFormOptions.LoadBGImageClick(Sender: TObject);
var jpg: TJPEGImage;

begin
  if Sender=LoadBGImage then
   begin
     FormMain.OpenDialog.InitialDir := ExtractFilePath(Application.ExeName);
     FormMain.OpenDialog.FileName:='';
     FormMain.OpenDialog.Filter:='Background image|*.jpg;*.bmp';
     if not FormMain.OpenDialog.Execute then Exit;
   end;
  if Pos('.jpg',FormMain.OpenDialog.FileName)>0 then
   begin
    jpg:=TJPEGImage.Create;
    jpg.LoadFromFile(FormMain.OpenDialog.FileName);
    BGImage.Picture.Bitmap.Assign(jpg);
    jpg.Free;
   end
  else
   BGImage.Picture.LoadFromFile(FormMain.OpenDialog.FileName);
  if BGImage.Picture.Bitmap.Width>BGImage.Picture.Bitmap.Height then
    BGImage.Height:=Floor(121*BGImage.Picture.Bitmap.Height/BGImage.Picture.Bitmap.Width)
  else
    BGImage.Width:=Floor(121*BGImage.Picture.Bitmap.Width/BGImage.Picture.Bitmap.Height);
  BGFileName.Text:=FormMain.OpenDialog.FileName;
  BGLoaded:=true;
end;

end.
