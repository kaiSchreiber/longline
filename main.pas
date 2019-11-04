unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, options, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, math, Jpeg, Buttons,
  ComCtrls, clipbrd, ShellAPI;

procedure Init;
procedure Cleanup;
procedure DoAutoUpdates;
procedure RemoveTile(index:Integer);
procedure UpdateButtonState;
procedure DrawTile(x,y,imsize: Integer;imext: string; dx,dy: Integer; exporting: Boolean);
function TileIsUsable(i: Integer): Boolean;
function GetNewTile(x,y:Integer): Integer;
function FindType(tag: string): Integer;
function GetValue(s,n: string): string;
procedure DisplayImage;
procedure AverageColor(i: Integer);
procedure AssignColorTarget;
function typecheck(k, t: Integer): Boolean;
function AddConnector(x,y,t: Integer): Boolean;

var  currentImage: TJpegImage;
     godmode: Boolean = true;
     version: string = 'v2.1.1 build 13';

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    Admin1: TMenuItem;
    Options1: TMenuItem;
    SynchGroup: TMenuItem;
    MakeLarge: TMenuItem;
    MakeImage: TMenuItem;
    ImageDisplay: TImage;
    Navigator: TImage;
    NavLeft: TButton;
    NavRight: TButton;
    MainMemo: TMemo;
    Brause: TIdHTTP;
    SaveDialog: TSaveDialog;
    BReject: TButton;
    BTag: TButton;
    SZoom: TScrollBar;
    ButPan: TPanel;
    SP1: TSpeedButton;
    SP2: TSpeedButton;
    SP3: TSpeedButton;
    SP13: TSpeedButton;
    SP12: TSpeedButton;
    SP11: TSpeedButton;
    SP8: TSpeedButton;
    SP7: TSpeedButton;
    SP6: TSpeedButton;
    SP4: TSpeedButton;
    SP14: TSpeedButton;
    SP9: TSpeedButton;
    SP5: TSpeedButton;
    SP15: TSpeedButton;
    SP10: TSpeedButton;
    SP19: TSpeedButton;
    NavMode: TRadioGroup;
    MakeEmpty: TMenuItem;
    Exit1: TMenuItem;
    SP0: TSpeedButton;
    SaveDesign: TMenuItem;
    LoadDesign1: TMenuItem;
    OpenDialog: TOpenDialog;
    SavePattern: TMenuItem;
    SaveImage: TMenuItem;
    Design1: TMenuItem;
    Image1: TMenuItem;
    N3: TMenuItem;
    FillCurrent: TMenuItem;
    N1: TMenuItem;
    LoadMeta: TMenuItem;
    N2: TMenuItem;
    SynchUser: TMenuItem;
    BExclude: TButton;
    SynchAll: TMenuItem;
    PostToGroup: TMenuItem;
    ClearBlacklist1: TMenuItem;
    Repopulate1: TMenuItem;
    N4: TMenuItem;
    DownloadTile: TMenuItem;
    Switch: TMenuItem;
    SP20: TSpeedButton;
    SP21: TSpeedButton;
    SP22: TSpeedButton;
    SP16: TSpeedButton;
    SP17: TSpeedButton;
    SP18: TSpeedButton;
    UpdatecurrentImage1: TMenuItem;
    SP23: TSpeedButton;
    OpenDesigner: TMenuItem;
    Main1: TMenuItem;
    Switchto1: TMenuItem;
    N5: TMenuItem;
    DrawSlow1: TMenuItem;
    N6: TMenuItem;
    SP24: TSpeedButton;
    ShowTally: TMenuItem;
    N7: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SynchGroupClick(Sender: TObject);
    procedure MakeImageClick(Sender: TObject);
    procedure MakeLargeClick(Sender: TObject);
    procedure NavModeChange(Sender: TObject);
    procedure SZoomChange(Sender: TObject);
    procedure NavigatorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Exit1Click(Sender: TObject);
    procedure ImageDisplayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SaveDesignClick(Sender: TObject);
    procedure LoadDesign1Click(Sender: TObject);
    procedure SaveImageDoIt;
    procedure LoadMetaClick(Sender: TObject);
    procedure BRejectClick(Sender: TObject);
    procedure BExcludeClick(Sender: TObject);
    procedure PostToGroupClick(Sender: TObject);
    procedure BTagClick(Sender: TObject);
    procedure ClearBlacklist1Click(Sender: TObject);
    procedure Repopulate1Click(Sender: TObject);
    procedure SwitchClick(Sender: TObject);
    procedure k(Sender: TObject);
    procedure NavigatorDblClick(Sender: TObject);
    procedure ImageDisplayMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SP22Click(Sender: TObject);
    procedure SP23Click(Sender: TObject);
    procedure SaveImageClick(Sender: TObject);
    procedure OpenDesignerClick(Sender: TObject);
    procedure DrawSlow1Click(Sender: TObject);
    procedure NavRightMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NavLeftMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowTallyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TRGBColor = record
    case Integer of
     0 : (Color : TColor) ;
     1 : (Red, Green, Blue, Intensity : Byte) ;
     2 : (Colors : array[0..3] of Byte) ;
    end;
  image = record
    id: string;
    userid: string;
    typ: Integer;
    title: string;
    owner: string;
    excluded: Boolean;
    inpool: Boolean;
    license: Integer;
    color: TRGBColor;
  end;
  griditem = record
    id: string;
    index: Integer;
    target: TRGBColor;
    typ: Integer;
  end;
  TChooselist = array of Integer;

function GradientColorDistance(a,b: TRGBColor):Double;

var
  FormMain: TFormMain;
  Images: array of image;
  currentImageIndex: Integer;
  zx,zy: Integer;
  swapx: Integer = -1;
  swapy: Integer = -1;
  drawx: Integer = -1;
  drawy: Integer = -1;
  grid: array of array of griditem;
  used: array of Boolean;
  gridImage: TBitmap;
  typestring: array[0..18] of string;
  pageselect: Integer = 0;
  imageState: Integer =-1;
  speedButtons: array[0..24] of TSpeedButton;
  licensestr: array[0..6] of string;
  postingstring: string;
  blacklist: array of string;
  fileprefix,tagprefix,tiletag,groupid: string;
  doingautoupdate: Boolean = false;
  displayList: TStringList;
  ColorTargetLoaded: Boolean = false;
  BGLoaded: Boolean = false;
  GradientTargetLoaded: Boolean = false;
  LineMacros: array of array of Integer;
  OldBGArea: TRect;

implementation

uses reject, progress, saveoptions, designer, colortally;

{$R *.dfm}

function GetBGArea: TRect;
var i,j: Integer;
begin
  if FormOptions.BGExtent.ItemIndex=0 then
    begin
      Result:=Rect(1,1,High(grid)-1,High(grid[0])-1);
      Exit;
    end;
  Result:=Rect(High(grid),High(grid[0]),-1,-1);
  for i:=1 to High(grid)-1 do
    for j:=1 to High(grid[0])-1 do
      if grid[i,j].typ=-2 then
        begin
          Result.Left:=min(Result.Left,i);
          Result.Top:=min(Result.Top,j);
          Result.Right:=max(Result.Right,i);
          Result.Bottom:=max(Result.Bottom,j);
        end;
end;

procedure CheckBGArea;
var i,j: Integer;
    NewBGArea: TRect;

begin
  NewBGArea:=GetBGArea;
  if (NewBGArea.Top<>OldBGArea.Top) or
     (NewBGArea.Left<>OldBGArea.Left) or
     (NewBGArea.Bottom<>OldBGArea.Bottom) or
     (NewBGArea.Right<>OldBGArea.Right) then
    for i:=1 to High(grid)-1 do
      for j:=1 to High(grid[0])-1 do
        if grid[i,j].typ=-2 then
          DrawTile(i,j,75,'.sq.jpg',75,75,false);
  OldBGArea:=NewBGArea;
end;

procedure AssignColorTarget;
var i,j,x,y,r,g,b,t,n: Integer;
    Pcolor: TRGBColor;
    bmp: TBitmap;

begin
  if not ColorTargetLoaded then Exit;
  bmp:=TBitmap.Create;
  bmp.Assign(FormOptions.ColorTarget.Picture.Bitmap);
  for i:=1 to High(grid)-1 do
   for j:=1 to High(grid[0])-1 do
    begin
     r:=0; b:=0; g:=0; t:=0; n:=0;
     for x:=Floor((i-1)*bmp.Width/(High(grid)-1))+1 to max(Floor(i*bmp.Width/(High(grid)-1))-1,Floor((i-1)*bmp.Width/(High(grid)-1))+1) do
      for y:=Floor((j-1)*bmp.Height/(High(grid[0])-1))+1 to max(Floor((j-1)*bmp.Height/(High(grid[0])-1))+1,Floor(j*bmp.Height/(High(grid[0])-1))-1) do
       begin
        PColor.Color:=bmp.Canvas.Pixels[x,y];
        r:=r+PColor.Red;
        b:=b+PColor.Blue;
        g:=g+PColor.Green;
        t:=t+PColor.Intensity;
        n:=n+1;
       end;
     if n=0 then n:=1;
     grid[i,j].target.Red:=Floor(r/n);
     grid[i,j].target.Blue:=Floor(b/n);
     grid[i,j].target.Green:=Floor(g/n);
     grid[i,j].target.Intensity:=Floor(t/n);
    end;
  bmp.Free;
end;

procedure AssignGradientTarget;
var i,j,k,x,y,n: Integer;
    d: Double;
    lx,ly,rx,ry: Integer;
    typstr: String;
    C1, C2: TRGBColor;
    bmp: TBitmap;

begin
  if not GradientTargetLoaded then Exit;
  bmp:=TBitmap.Create;
  bmp.Assign(FormOptions.GradientTarget.Picture.Bitmap);
  // cycle through all the tiles in the grid
  for i:=1 to High(grid)-1 do
   for j:=1 to High(grid[0])-1 do
    begin
     // now get the four components: connect or not?
     lx:=Floor((i-1)*bmp.Width/(High(grid)-1))+1;
     ly:=Floor((j-1)*bmp.Height/(High(grid[0])-1))+1;
     rx:=Floor(i*bmp.Width/(High(grid)-1))-1;
     ry:=Floor(j*bmp.Height/(High(grid[0])-1))-1;
     typstr:='';
     // top half
     d:=0; n:=0;
     for x:=lx to rx do
      for y:=ly to Floor((ly+ry)/2) do
       begin
        C1.Color:=bmp.Canvas.Pixels[x,y];
        C2.Color:=bmp.Canvas.Pixels[x,y+1];
        d:=d+GradientColorDistance(C1,C2);
        n:=n+1;
       end;
     if abs(d/n)*100>StrToFloat(FormOptions.GradientCutoff.Text) then
       typstr:='1';
     // right half
     d:=0; n:=0;
     for x:=Floor((lx+rx)/2) to rx do
      for y:=ly to ry do
       begin
        C1.Color:=bmp.Canvas.Pixels[x,y];
        C2.Color:=bmp.Canvas.Pixels[x+1,y];
        d:=d+GradientColorDistance(C1,C2);
        n:=n+1;
       end;
     if abs(d/n)*100>StrToFloat(FormOptions.GradientCutoff.Text) then
       typstr:=typstr+'2';
     // bottom half
     d:=0; n:=0;
     for x:=lx to rx do
      for y:=Floor((ly+ry)/2) to ry do
       begin
        C1.Color:=bmp.Canvas.Pixels[x,y];
        C2.Color:=bmp.Canvas.Pixels[x+1,y];
        d:=d+GradientColorDistance(C1,C2);
        n:=n+1;
       end;
     if abs(d/n)*100>StrToFloat(FormOptions.GradientCutoff.Text) then
       typstr:=typstr+'3';
     // left half
     d:=0; n:=0;
     for x:=lx to Floor((lx+rx)/2) do
      for y:=ly to ry do
       begin
        C1.Color:=bmp.Canvas.Pixels[x,y];
        C2.Color:=bmp.Canvas.Pixels[x+1,y];
        d:=d+GradientColorDistance(C1,C2);
        n:=n+1;
       end;
     if abs(d/n)*100>StrToFloat(FormOptions.GradientCutoff.Text) then
       typstr:=typstr+'4';
     for k:=0 to 15 do
       if typestring[k]=typstr then
         grid[i,j].typ:=k;
    end;
  bmp.Free;
end;

function GradientColorDistance(a,b: TRGBColor):Double;
var maxa,mina,maxb,minb: Integer;

begin
  Result:=-1; // just to silence the compiler's warning message
  case FormOptions.GradientTargetMode.ItemIndex of
   // color distance, euclidean in RGB coordinates and normalized
   0: Result:=sqrt(Power(a.Red-b.red,2)+Power(a.Green-b.Green,2)+Power(a.Blue-b.Blue,2))/444;
   // luminance distance, sum of components, normalized to black-white
   1: Result:=abs(0.3*a.red+0.59*a.Green+0.11*a.Blue-0.3*b.red-0.59*b.Green-0.11*b.blue)/256;
   // saturation distance
   2: begin
       maxa:=max(1,max(max(a.red,a.green),a.blue));
       mina:=min(min(a.red,a.green),a.blue);
       maxb:=max(1,max(max(b.red,b.green),b.blue));
       minb:=min(min(b.red,b.green),b.blue);
       Result:=abs((maxa-mina)/maxa-(maxb-minb)/maxb);
      end;
  end;
end;

function ColorDistance(a,b: TRGBColor):Double;
var maxa,mina,maxb,minb: Integer;
    ha,hb: Double;

begin
  Result:=-1; // just to silence the compiler's warning message
  // return distance zero for all comparisons if
  // the target color matches the neutral color
  case FormOptions.ColorTargetNeutral.ItemIndex of
   1: if a.Color = clWhite then begin Result:=0; Exit; end;
   2: if a.Color = clBlack then begin Result:=0; Exit; end;
  end;
  case FormOptions.ColorTargetMode.ItemIndex of
   // color distance, euclidean in RGB coordinates and normalized
   0: Result:=sqrt(Power(a.Red-b.red,2)+Power(a.Green-b.Green,2)+Power(a.Blue-b.Blue,2))/444;
   // luminance distance, sum of components, normalized to black-white
   1: Result:=abs(0.3*a.red+0.59*a.Green+0.11*a.Blue-0.3*b.red-0.59*b.Green-0.11*b.blue)/256;
   // saturation and hue distance
   2,3: begin
       maxa:=max(1,max(max(a.red,a.green),a.blue));
       mina:=min(min(a.red,a.green),a.blue);
       maxb:=max(1,max(max(b.red,b.green),b.blue));
       minb:=min(min(b.red,b.green),b.blue);
       if FormOptions.ColorTargetMode.ItemIndex=2 then
         Result:=abs((maxa-mina)/maxa-(maxb-minb)/maxb)
       else
         begin
           if maxa=mina then
             ha:=0
           else if a.red=maxa then
             ha:=     (a.green - a.blue)/(maxa-mina)
           else if a.green=maxa then
             ha := 2 + (a.blue  -  a.red)/(maxa-mina)
           else
             ha:= 4 + (a.red -  a.green)/(maxa-mina);
           if ha<0 then ha:=ha+6;
           if maxb=minb then
             hb:=0
           else if b.red=maxb then
             hb:=     (b.green - b.blue)/(maxb-minb)
           else if b.green=maxb then
             hb := 2 + (b.blue  -  b.red)/(maxb-minb)
           else
             hb:= 4 + (b.red -  b.green)/(maxb-minb);
           if hb<0 then hb:=hb+6;
           Result:=abs(ha-hb)/6;
           // hue wraps
           if Result>0.5 then Result:=1-Result;
         end;
      end;
  end;
end;

procedure AverageColor(i: Integer);
var x,y,r,g,b,t: Integer;
    jpg: TJPEGImage;
    bmp: TBitMap;
    PColor: TRGBColor;

begin
  bmp:=TBitmap.Create;
  jpg:=TJPEGImage.Create;
  jpg.LoadFromFile(ExtractFilePath(Application.ExeName)+'images\'+Images[i].id+'.sq.jpg');
  //bmp.Width:=jpg.Width;
  //bmp.Height:=jpg.Height;
  //Bitmap.Canvas.Draw(0,0,jpg);
  bmp.Assign(jpg);
  r:=0; b:=0; g:=0; t:=0;
  for x:=1 to bmp.Width do
   for y:=1 to bmp.Height do
    begin
     PColor.Color:=bmp.Canvas.Pixels[x,y];
     r:=r+PColor.Red;
     b:=b+PColor.Blue;
     g:=g+PColor.Green;
     t:=t+PColor.Intensity;
    end;
  Images[i].color.Red:=Floor(r/(bmp.Width*bmp.Height));
  Images[i].color.Blue:=Floor(b/(bmp.Width*bmp.Height));
  Images[i].color.Green:=Floor(g/(bmp.Width*bmp.Height));
  Images[i].color.Intensity:=Floor(t/(bmp.Width*bmp.Height));
  bmp.Free;
  jpg.Free;
end;

procedure CleanList(var c: TChooselist; x,y: Integer);
var flag: Boolean;
    maxindex, i,j: Integer;
    users: TStringList;
    tilecount: array of Integer;
    distance: array of Double;

begin
  // we'll do the color check first, since this is likely to be quite
  // restrictive and we need as many tiles as we can grab for this
  flag:=false;
  if FormOptions.ApplyColor.Checked then
   begin
    SetLength(distance,Length(c));
    for i:=0 to High(c) do
     begin
      distance[i]:=ColorDistance(grid[x,y].target,Images[c[i]].color);
      if distance[i]<StrToInt(FormOptions.ColorTolerance.Text)/100 then flag:=true;
     end;
    if flag then
     begin
      for i:=High(c) downto 0 do
       if distance[i]>StrToInt(FormOptions.ColorTolerance.Text)/100 then
        begin
         for j:=i to High(c)-1 do
          begin c[j]:=c[j+1]; distance[j]:=distance[j+1]; end;
         SetLength(c,High(c));
         SetLength(distance,High(distance));
        end;
     end
    else // none of the tiles are below the limit. eliminate the worst matches
     while Length(c)>StrToInt(FormOptions.UseBest.Text) do
      begin
       maxindex:=0;
       for i:=0 to High(c) do
        if distance[i]>distance[maxindex] then maxindex:=i;
       for i:=maxindex to High(c)-1 do
        begin c[i]:=c[i+1]; distance[i]:=distance[i+1]; end;
       SetLength(c,High(c));
       SetLength(distance,High(distance));
      end
   end;

  // remove end tiles, if there are non-end tiles
  flag:=false;
  if FormOptions.AvoidEndings.Checked then
   begin
    for i:=0 to High(c) do
     if (Images[c[i]].typ=0) or (Images[c[i]].typ>4) then
      flag:=true;
    if flag then
     for i:=High(c) downto 0 do
      if (Images[c[i]].typ>0) and (Images[c[i]].typ<5) then
       begin
        for j:=i to High(c)-1 do c[j]:=c[j+1];
        SetLength(c,High(c));
       end;
   end;

  // remove used tiles if at least one is unused
  flag:=false;
  if FormOptions.PreferUnused.Checked then
   begin
    for i:=0 to High(c) do
     if not used[c[i]] then flag:=true;
    if flag then
     for i:=High(c) downto 0 do
      if used[c[i]] then
       begin
        for j:=i to High(c)-1 do c[j]:=c[j+1];
        SetLength(c,High(c));
       end;
   end;

  // remove rotated tiles if at least one is not
  flag:=false;
  if FormOptions.PreferUpright.Checked then
   begin
    for i:=0 to High(c) do
     if Images[c[i]].typ=grid[x,y].typ then
      flag:=true;
    if flag then
     for i:=High(c) downto 0 do
      if (Images[c[i]].typ<>grid[x,y].typ) then
       begin
        for j:=i to High(c)-1 do c[j]:=c[j+1];
        SetLength(c,High(c));
       end;
   end;

  // apply the limits
  if FormOptions.Limit.Checked then
   begin
     users:=TStringList.Create;
     // count tiles by each user
     for i:=0 to High(grid) do
      for j:=0 to High(grid[0]) do
       if grid[i,j].index<>-1 then
        begin
         if users.IndexOf(Images[grid[i,j].index].owner)=-1 then
          begin
           users.Add(Images[grid[i,j].index].owner);
           SetLength(tilecount,Length(tilecount)+1);
           tilecount[High(tilecount)]:=1;
          end
         else
          tilecount[users.IndexOf(Images[grid[i,j].index].owner)]:=
            tilecount[users.IndexOf(Images[grid[i,j].index].owner)]+1;
        end;
     // now we have a list of tiles and users already on the mosaic

     if StrToInt(FormOptions.LimitLow.Text)>0 then
     begin
      // remove tiles from users above or on the lower limit, if there are ones below
      flag:=false;
      for i:=0 to High(c) do
       if users.IndexOf(Images[c[i]].owner)=-1 then flag:=true
        else if tilecount[users.IndexOf(Images[c[i]].owner)]<StrToInt(FormOptions.LimitLow.Text) then
         flag:=true;
      if flag then
       for i:=High(c) downto 0 do
        // are they in the userlist at all
        if users.IndexOf(Images[c[i]].owner)<>-1 then
         // if so, are they above or on the limit?
         if tilecount[users.IndexOf(Images[c[i]].owner)]>=StrToInt(FormOptions.LimitLow.Text) then
          // yup, get rid of the tile
          begin
           for j:=i to High(c)-1 do c[j]:=c[j+1];
           SetLength(c,High(c));
          end;
     end;

     if StrToInt(FormOptions.LimitHigh.Text)>0 then
     begin
      // remove tiles from users above the upper limit, if there are ones below
      flag:=false;
      for i:=0 to High(c) do
       if users.IndexOf(Images[c[i]].owner)=-1 then flag:=true
        else if tilecount[users.IndexOf(Images[c[i]].owner)]<StrToInt(FormOptions.LimitHigh.Text) then
         flag:=true;
      if flag then
       for i:=High(c) downto 0 do
        // are they in the userlist at all
        if users.IndexOf(Images[c[i]].owner)<>-1 then
         // if so, are they above or on the limit?
         if tilecount[users.IndexOf(Images[c[i]].owner)]>=StrToInt(FormOptions.LimitHigh.Text) then
          // yup, get rid of the tile
          begin
           for j:=i to High(c)-1 do c[j]:=c[j+1];
           SetLength(c,High(c));
          end;
     end;

     users.Free;
   end;

end;

function GetNewNumber(var S: string): Integer;
begin
  Result := -1;
  if Pos(',',S)>0 then
    begin
     Result:=StrToInt(Copy(S,0,Pos(',',S)-1) );
     S := Copy(S,Pos(',',S)+1,Length(S));
    end;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  //FormMain.ImageDisplay.Width:=FormMain.ClientWidth-179;
  //FormMain.ImageDisplay.Height:=FormMain.ClientHeight-7;
  //FormMain.MainMemo.Height:=FormMain.ClientHeight-340;
  //ButPan.Top:=FormMain.ClientHeight-120;
  DisplayImage;
end;

procedure TFormMain.Options1Click(Sender: TObject);
begin
  FormOptions.Show;
  FormMain.Enabled:=false;
end;

procedure Init;
var LoadFile: TStringList;
    i,n: Integer;
    readline: string;

begin
  OldBGArea:=Rect(0,0,0,0);
  if FileExists(ExtractFilePath(Application.ExeName)+'dopatches') then
   begin
    fileprefix:='patches';
    groupid:='88772684@N00';
    tiletag:='patchtile';
    tagprefix:='pt';
    FormMain.Caption:='Patches Tool '+version;
    if godmode then FormMain.Caption:=FormMain.Caption+' | godmode';
    FormReject.NoLines.Caption:='Not enough contrast.';
    FormReject.NoConnect.Caption:='Boundaries don''t connect.';
    FormReject.ExtraLines.Caption:='Not homogeneous.';
    FormMain.Switch.Caption:='Longline';
   end
  else
   begin
    fileprefix:='longline';
    groupid:='92826858@N00';
    tiletag:='longline';
    tagprefix:='ll';
    FormMain.Caption:='Longline Tool '+version;
    if godmode then FormMain.Caption:=FormMain.Caption+' | godmode';
    FormReject.NoLines.Caption:='Lines not visible..';
    FormReject.NoConnect.Caption:='Lines don''t connect.';
    FormReject.ExtraLines.Caption:='Extra lines.';
    FormMain.Switch.Caption:='Patches';
   end;

  LoadFile:=TStringList.Create;
  if FileExists(ExtractFilePath(Application.ExeName)+'macros.llf') then
    begin
      // read in the line macros and store in the LineMacros array
      LoadFile.LoadFromFile(ExtractFilePath(Application.ExeName)+'macros.llf');
      SetLength(LineMacros,LoadFile.Count);
      for i:=0 to LoadFile.Count-1 do
        begin
          readline:=LoadFile.Strings[i];
          n:=GetNewNumber(readline);
          while n>-1 do
            begin
              SetLength(LineMacros[i],Length(LineMacros[i])+1);
              LineMacros[i,High(LineMacros[i])]:=n;
              n:=GetNewNumber(readline);
            end;
        end;
    end;

  //if not godmode then FormOptions.Apikey.PasswordChar:='*';
  //FormOptions.Apikey.Enabled:=godmode;
  FormOptions.Apikey.PasswordChar:='*';
  FormOptions.Apikey.Enabled:=false;
  FormReject.ButtonReject.Enabled:=godmode;
  FormReject.KeepImage.Visible:=godmode;
  FormReject.KeepImage.Enabled:=godmode;
  FormReject.NoLines.Enabled:=godmode;
  FormReject.NoConnect.Enabled:=godmode;
  FormReject.NoLicense.Enabled:=godmode;
  FormReject.ExtraLines.Enabled:=godmode;
  FormReject.Comment.Enabled:=godmode;

  // setup stuff
  FormMain.DoubleBuffered:=true;
  currentImage:=TJpegImage.Create;
  gridImage:=TBitmap.Create;
  displayList:=TStringList.Create;
  LoadFile.Add('gridwidth=5');
  LoadFile.Add('gridheight=5');
  if not FileExists(ExtractFilePath(Application.ExeName)+fileprefix+'.opt') then
    LoadFile.SaveToFile(ExtractFilePath(Application.ExeName)+fileprefix+'.opt');
  LoadFile.Clear;
  LoadFile.Add('-1');
  LoadFile.Add('0');
  if not FileExists(ExtractFilePath(Application.ExeName)+fileprefix+'.db') then
    LoadFile.SaveToFile(ExtractFilePath(Application.ExeName)+fileprefix+'.db');
  LoadFile.Clear;
  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'images') then
    CreateDir(ExtractFilePath(Application.ExeName)+'images');
  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'designs') then
    CreateDir(ExtractFilePath(Application.ExeName)+'designs');
  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'output') then
    CreateDir(ExtractFilePath(Application.ExeName)+'output');
  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'targets') then
    CreateDir(ExtractFilePath(Application.ExeName)+'targets');

  zx:=0; zy:=0; // position of the zoom window

  typestring[0]:='';
  typestring[1]:='1';
  typestring[2]:='2';
  typestring[3]:='3';
  typestring[4]:='4';
  typestring[5]:='12';
  typestring[6]:='13';
  typestring[7]:='14';
  typestring[8]:='23';
  typestring[9]:='24';
  typestring[10]:='34';
  typestring[11]:='123';
  typestring[12]:='124';
  typestring[13]:='134';
  typestring[14]:='234';
  typestring[15]:='1234';
  typestring[16]:='1234r';
  typestring[17]:='1234f';
  typestring[18]:='';

  licensestr[0]:='No license';
  licensestr[1]:='BY-NC-SA';
  licensestr[2]:='BY-NC';
  licensestr[3]:='BY-NC-ND';
  licensestr[4]:='BY';
  licensestr[5]:='BY-SA';
  licensestr[6]:='BY-ND';

  speedbuttons[0]:=FormMain.SP0;
  speedbuttons[1]:=FormMain.SP1;
  speedbuttons[2]:=FormMain.SP2;
  speedbuttons[3]:=FormMain.SP3;
  speedbuttons[4]:=FormMain.SP4;
  speedbuttons[5]:=FormMain.SP5;
  speedbuttons[6]:=FormMain.SP6;
  speedbuttons[7]:=FormMain.SP7;
  speedbuttons[8]:=FormMain.SP8;
  speedbuttons[9]:=FormMain.SP9;
  speedbuttons[10]:=FormMain.SP10;
  speedbuttons[11]:=FormMain.SP11;
  speedbuttons[12]:=FormMain.SP12;
  speedbuttons[13]:=FormMain.SP13;
  speedbuttons[14]:=FormMain.SP14;
  speedbuttons[15]:=FormMain.SP15;
  speedbuttons[16]:=FormMain.SP16;
  speedbuttons[17]:=FormMain.SP17;
  speedbuttons[18]:=FormMain.SP18;
  speedbuttons[19]:=FormMain.SP19;
  speedbuttons[20]:=FormMain.SP20;
  speedbuttons[21]:=FormMain.SP21;
  speedbuttons[22]:=FormMain.SP22;
  speedbuttons[23]:=FormMain.SP23;
  speedbuttons[24]:=FormMain.SP24;

  usabletypecheck[0]:=FormOptions.UT0;
  usabletypecheck[1]:=FormOptions.UT1;
  usabletypecheck[2]:=FormOptions.UT2;
  usabletypecheck[3]:=FormOptions.UT3;
  usabletypecheck[4]:=FormOptions.UT4;
  usabletypecheck[5]:=FormOptions.UT5;
  usabletypecheck[6]:=FormOptions.UT6;
  usabletypecheck[7]:=FormOptions.UT7;
  usabletypecheck[8]:=FormOptions.UT8;
  usabletypecheck[9]:=FormOptions.UT9;
  usabletypecheck[10]:=FormOptions.UT10;
  usabletypecheck[11]:=FormOptions.UT11;
  usabletypecheck[12]:=FormOptions.UT12;
  usabletypecheck[13]:=FormOptions.UT13;
  usabletypecheck[14]:=FormOptions.UT14;
  usabletypecheck[15]:=FormOptions.UT15;
  usabletypecheck[16]:=FormOptions.UT16;
  usabletypecheck[17]:=FormOptions.UT17;

  // first load the database
  LoadFile.LoadFromFile(ExtractFilePath(Application.ExeName)+fileprefix+'.db');
  n:=1;
  if LoadFile[0]='build11' then n:=2;
  SetLength(Images,StrToInt(LoadFile[n-1])+1);
  SetLength(used,Length(Images));
  for i:=0 to StrToInt(LoadFile[n-1]) do
   begin
     used[i]:=false;
     Images[i].id:=LoadFile[n];
     Images[i].userid:=LoadFile[n+1];
     Images[i].typ:=StrToInt(LoadFile[n+2]);
     Images[i].title:=LoadFile[n+3];
     Images[i].owner:=LoadFile[n+4];
     Images[i].excluded:=StrToBool(LoadFile[n+5]);
     Images[i].inpool:=StrToBool(LoadFile[n+6]);
     Images[i].license:=StrToInt(LoadFile[n+7]);
     if Loadfile[0]='build11' then
      begin
       Images[i].color.Color:=StrToInt(LoadFile[n+8]);
       n:=n+9;
      end
     else
      begin
       // determine the color value
       AverageColor(i);
       n:=n+8;
      end;
   end;

  currentImageIndex:=High(Images);
  pageselect:=min(pageselect,Floor(Length(Images)/49));

  SetLength(blacklist,StrToInt(LoadFile[n]));
  for i:=0 to StrToInt(LoadFile[n])-1 do
    blacklist[i]:=LoadFile[n+1+i];

  // load the options
  LoadFile.LoadFromFile(ExtractFilePath(Application.ExeName)+fileprefix+'.opt');
  //if godmode then FormOptions.Apikey.Text:=LoadFile.Values['apikey'];
  FormOptions.BGFileName.Text:=LoadFile.Values['bgfilename'];
  if FileExists(FormOptions.BGFileName.Text) then
   begin
    FormMain.OpenDialog.FileName:=FormOptions.BGFileName.Text;
    FormOptions.LoadBGImageClick(FormMain);
   end;
  FormOptions.BGFormat.ItemIndex:=StrToInt('0'+LoadFile.Values['bgformat']);
  FormOptions.BGExtent.ItemIndex:=StrToInt('0'+LoadFile.Values['bgextent']);
  FormOptions.SetWidthTo.Text:=LoadFile.Values['setwidthto'];
  FormOptions.User.Text:=LoadFile.Values['username'];
  FormOptions.Pass.Text:=LoadFile.Values['password'];
  FormOptions.UserName.Text:=LoadFile.Values['singleusername'];
  FormOptions.GridWidth.Text:=LoadFile.Values['gridwidth'];
  FormOptions.CheckUserName.Text:=LoadFile.Values['checkusername'];
  FormOptions.GridHeight.Text:=LoadFile.Values['gridheight'];
  FormOptions.LimitLow.Text:=LoadFile.Values['limitlow'];
  FormOptions.LimitHigh.Text:=LoadFile.Values['limithigh'];
  FormOptions.ColorTolerance.Text:=LoadFile.Values['colortolerance'];
  FormOptions.UseBest.Text:=LoadFile.Values['colorusebest'];
  FormOptions.ColorTargetFilename.Text:=LoadFile.Values['colortargetfilename'];
  FormOptions.LineWidth.Text:=LoadFile.Values['tileborderlinewidth'];
  FormOptions.BackContrast.Text:=LoadFile.Values['backgroundcontrast'];
  FormOptions.LowLineWidth.Text:=LoadFile.Values['lowlinewidth'];
  if FileExists(FormOptions.ColorTargetFilename.Text) then
   begin
    FormMain.OpenDialog.FileName:=FormOptions.ColorTargetFilename.Text;
    FormOptions.LoadColorClick(FormMain);
   end;
  FormOptions.GradientTargetFilename.Text:=LoadFile.Values['gradienttargetfilename'];
  if FileExists(FormOptions.GradientTargetFilename.Text) then
   begin
    FormMain.OpenDialog.FileName:=FormOptions.GradientTargetFilename.Text;
    FormOptions.LoadGradientClick(FormMain);
   end;

  FormOptions.ColorDistanceReduction.Text:= LoadFile.Values['colordistancereduction'];
  FormOptions.PushColor.Checked:=(LoadFile.Values['pushtargetcolor']='true');
  FormOptions.ColorTargetMode.ItemIndex:=StrToInt('0'+LoadFile.Values['colortargetmode']);
  FormOptions.GradientTargetMode.ItemIndex:=StrToInt('0'+LoadFile.Values['gradienttargetmode']);

  FormOptions.MakeCommercial.Checked := (LoadFile.Values['makecommercial']='true');
  FormOptions.UseDrawSettings.Checked := (LoadFile.Values['usedrawsettings']='true');
  FormOptions.UseOnlyOnce.Checked := (LoadFile.Values['useonlyonce']='true');
  FormOptions.CopyToSave.Checked := (LoadFile.Values['copytosave']='true');
  FormOptions.ColorTargetNeutral.ItemIndex:=StrToInt('0'+LoadFile.Values['colortargetneutral']);
  FormOptions.FillPattern.Checked:=(LoadFile.Values['fillpatternonload']='true');
  FormOptions.AllowRotate.Checked:=(LoadFile.Values['allowrotate']='true');
  FormOptions.PreferUpright.Checked:=(LoadFile.Values['preferupright']='true');
  FormOptions.AutoUpdate.Checked:=(LoadFile.Values['autoupdate']='true');
  FormOptions.ApplyColor.Checked:=(LoadFile.Values['applycolor']='true');
  FormOptions.ApplyGradient.Checked:=(LoadFile.Values['applygradient']='true');
  FormOptions.FullUpdate.Checked:=(LoadFile.Values['fullupdate']='true');
  FormOptions.Multiples.Checked:=(LoadFile.Values['multiples']='true');
  FormOptions.AutoSetSize.Checked:=(LoadFile.Values['autosetsize']='true');
  FormOptions.NoExclude.Checked:=(LoadFile.Values['noexclude']='true');
  FormOptions.NoOutside.Checked:=(LoadFile.Values['nooutside']='true');
  FormOptions.SingleLine.Checked:=(LoadFile.Values['singleline']='true');
  FormOptions.PoolOnly.Checked:=(LoadFile.Values['poolonly']='true');
  FormOptions.AutoUpdateAll.Checked:=(LoadFile.Values['autopoolupdate']='true');
  FormOptions.IgnoreLicense.Checked:=(LoadFile.Values['ignorelicense']='true');
  FormOptions.CheckUser.Checked:=(LoadFile.Values['checkuser']='true');
  FormOptions.SkipConfirm.Checked:=(LoadFile.Values['skipconfirm']='true');
  FormOptions.PreferUnused.Checked:=(LoadFile.Values['preferunused']='true');
  FormOptions.ApplyUsability.Checked:=(LoadFile.Values['applyusability']='true');
  FormOptions.Limit.Checked:=(LoadFile.Values['limit']='true');
  FormOptions.SetMosaicWidth.Checked:=(LoadFile.Values['setmosaicwidth']='true');
  FormOptions.LowerContrast.Checked:=(LoadFile.Values['lowercontrast']='true');
  FormOptions.Separators.Checked :=(LoadFile.Values['drawtileborders']='true');
  for i:=0 to 17 do
    usabletypecheck[i].Checked:=(LoadFile.Values['usabletype'+IntToStr(i)]='true');

  LoadFile.Free;
  DoAutoUpdates;
  UpdateButtonState;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  Init;
end;

procedure DoAutoUpdates;

begin
  // then, if the option is set, connect to flickr
  doingautoupdate:=true;
  if FormOptions.AutoUpdate.Checked then FormMain.SynchGroupClick(FormMain.SynchGroup);
  if FormOptions.AutoUpdateAll.Checked then FormMain.SynchGroupClick(FormMain.SynchAll);
  if FormOptions.CheckUser.Checked then FormMain.SynchGroupClick(FormOptions.CheckUser);
  doingautoupdate:=false;

  // if autosize is set, set the grid size to the largest possible square
  if FormOptions.AutoSetSize.Checked then
   begin
     FormOptions.GridWidth.Text:=IntToStr(Floor(sqrt(Length(Images))));
     FormOptions.GridHeight.Text:=IntToStr(Floor(sqrt(Length(Images))));
   end;
  UpdateButtonState;
  currentImageIndex:=max(High(Images),-1);
  DisplayImage;
end;

procedure DisplayImage;
var sc,zoom: Double;
    size,zx0,zy0: Integer;

begin
  if FormMain.NavMode.ItemIndex=0 then
   begin
    if currentImageIndex>-1 then
     begin
      currentImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'images/'+Images[currentImageIndex].id+'.sm.jpg');
      FormMain.Navigator.Canvas.StretchDraw(Rect(0,0,162,162),currentImage);
      currentImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'images/'+Images[currentImageIndex].id+'.lg.jpg');
      size:=min(FormMain.ImageDisplay.Width,FormMain.ImageDisplay.Height);
      FormMain.ImageDisplay.Canvas.Brush.Color:=clWhite;
      FormMain.ImageDisplay.Canvas.Rectangle(0,0,FormMain.ImageDisplay.Width,FormMain.ImageDisplay.Height);
      FormMain.ImageDisplay.Canvas.StretchDraw(Rect(0,0,size,size),currentImage);
      if Images[currentImageIndex].excluded then
       begin
        FormMain.Navigator.Canvas.Pen.Width:=1;
        FormMain.Navigator.Canvas.Brush.Color:=clWhite;
        FormMain.Navigator.Canvas.Pen.Color:=clWhite;
        FormMain.Navigator.Canvas.Rectangle(0,0,32,32);
        FormMain.Navigator.Canvas.Pen.Color:=clRed;
        if FormOptions.NoExclude.Checked then FormMain.Navigator.Canvas.Pen.Color:=clGreen;
        FormMain.Navigator.Canvas.Ellipse(4,4,28,28);
        FormMain.Navigator.Canvas.MoveTo(7,7);
        FormMain.Navigator.Canvas.LineTo(25,25);
       end;
      if not Images[currentImageIndex].inpool then
       begin
        FormMain.Navigator.Canvas.Pen.Width:=1;
        FormMain.Navigator.Canvas.Brush.Color:=clWhite;
        FormMain.Navigator.Canvas.Pen.Color:=clWhite;
        FormMain.Navigator.Canvas.Rectangle(33,0,65,32);
        FormMain.Navigator.Canvas.Pen.Color:=clRed;
        if not FormOptions.PoolOnly.Checked then FormMain.Navigator.Canvas.Pen.Color:=clGreen;
        FormMain.Navigator.Canvas.Ellipse(37,4,61,28);
        FormMain.Navigator.Canvas.MoveTo(40,7);
        FormMain.Navigator.Canvas.LineTo(58,25);
       end;
      if (Images[currentImageIndex].license=6) or (Images[currentImageIndex].license=3) or (Images[currentImageIndex].license=0) then
       begin
        FormMain.Navigator.Canvas.Pen.Width:=1;
        FormMain.Navigator.Canvas.Brush.Color:=clWhite;
        FormMain.Navigator.Canvas.Pen.Color:=clWhite;
        FormMain.Navigator.Canvas.Rectangle(66,0,98,32);
        FormMain.Navigator.Canvas.Pen.Color:=clRed;
        if FormOptions.IgnoreLicense.Checked then FormMain.Navigator.Canvas.Pen.Color:=clGreen;
        FormMain.Navigator.Canvas.Ellipse(70,4,94,28);
        FormMain.Navigator.Canvas.MoveTo(73,7);
        FormMain.Navigator.Canvas.LineTo(91,25);
       end;
      FormMain.Navigator.Canvas.Pen.Width:=4;
      FormMain.Navigator.Canvas.Pen.Color:=clRed;
      if Pos('1',typestring[Images[currentImageIndex].typ])>0 then
       begin FormMain.Navigator.Canvas.MoveTo(81,0); FormMain.Navigator.Canvas.LineTo(81,10); end;
      if Pos('2',typestring[Images[currentImageIndex].typ])>0 then
       begin FormMain.Navigator.Canvas.MoveTo(162,81); FormMain.Navigator.Canvas.LineTo(152,81); end;
      if Pos('3',typestring[Images[currentImageIndex].typ])>0 then
       begin FormMain.Navigator.Canvas.MoveTo(81,162); FormMain.Navigator.Canvas.LineTo(81,152); end;
      if Pos('4',typestring[Images[currentImageIndex].typ])>0 then
       begin FormMain.Navigator.Canvas.MoveTo(0,81); FormMain.Navigator.Canvas.LineTo(10,81); end;
      FormMain.MainMemo.Clear;
      FormMain.MainMemo.Lines.Add(IntToStr(currentImageIndex+1)+' '+Images[currentImageIndex].title);
      FormMain.MainMemo.Lines.Add(' Owner: '+Images[currentImageIndex].owner);
      if Images[currentImageIndex].typ=0 then
        FormMain.MainMemo.Lines.Add(' Sides: none')
      else
        FormMain.MainMemo.Lines.Add(' Sides: '+typestring[Images[currentImageIndex].typ]);
      if not Images[currentImageIndex].inpool then FormMain.MainMemo.Lines.Add(' not in pool');
      if Images[currentImageIndex].excluded then FormMain.MainMemo.Lines.Add(' on exclusion list');
      FormMain.MainMemo.Lines.Add(' License: '+licensestr[Images[currentImageIndex].license]);
      if Images[currentImageIndex].typ=18 then FormMain.MainMemo.Lines.Add('WARNING. NO SIDES DEFINED.');
     end;
   end
  else if (FormMain.NavMode.ItemIndex=1) or (FormMain.NavMode.ItemIndex=3) then
   begin
     zoom:=(max(Length(grid),Length(grid[0]))-1)*FormMain.SZoom.Position/100+1;
     zx:=min(zx,162-Floor(162/zoom));
     zy:=min(zy,162-Floor(162/zoom));
     sc:=gridImage.Width/gridImage.Height;
     zx0:=Floor(-zx/162*FormMain.ImageDisplay.Width*zoom);
     zy0:=Floor(-zy/162*FormMain.ImageDisplay.Height*zoom);
     FormMain.Navigator.Canvas.Brush.Color:=clWhite;
     FormMain.Navigator.Canvas.Pen.Color:=clWhite;
     FormMain.Navigator.Canvas.Rectangle(0,0,162,162);
     if sc<1 then
       FormMain.Navigator.Canvas.StretchDraw(Rect(0,0,Floor(162*sc),162),gridImage)
     else
       FormMain.Navigator.Canvas.StretchDraw(Rect(0,0,162,Floor(162/sc)),gridImage);
     FormMain.Navigator.Canvas.Brush.Color:=clRed;
     FormMain.Navigator.Canvas.FrameRect(Rect(zx,zy,Floor(zx+162/zoom),Floor(zy+162/zoom)));
     FormMain.ImageDisplay.Canvas.Brush.Color:=clWhite;
     FormMain.ImageDisplay.Canvas.Pen.Color:=clWhite;
     FormMain.ImageDisplay.Canvas.Rectangle(0,0,FormMain.ImageDisplay.Width,FormMain.ImageDisplay.Height+2);
     if sc<1 then
       FormMain.ImageDisplay.Canvas.StretchDraw(Rect(zx0,zy0,zx0+Floor(zoom*sc*FormMain.ImageDisplay.Width),zy0+Floor(zoom*FormMain.ImageDisplay.Height)),gridImage)
     else
       FormMain.ImageDisplay.Canvas.StretchDraw(Rect(zx0,zy0,zx0+Floor(zoom*FormMain.ImageDisplay.Width),zy0+Floor(zoom*FormMain.ImageDisplay.Height/sc)),gridImage);
   end
  else if FormMain.NavMode.ItemIndex=2 then
   begin
     // display the current Image in the navigator
     if currentImageIndex>-1 then
      begin
       currentImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'images/'+Images[currentImageIndex].id+'.sm.jpg');
       FormMain.Navigator.Canvas.StretchDraw(Rect(0,0,162,162),currentImage);
      if Images[currentImageIndex].excluded then
       begin
        FormMain.Navigator.Canvas.Pen.Width:=1;
        FormMain.Navigator.Canvas.Brush.Color:=clWhite;
        FormMain.Navigator.Canvas.Pen.Color:=clWhite;
        FormMain.Navigator.Canvas.Rectangle(0,0,32,32);
        FormMain.Navigator.Canvas.Pen.Color:=clRed;
        if FormOptions.NoExclude.Checked then FormMain.Navigator.Canvas.Pen.Color:=clGreen;
        FormMain.Navigator.Canvas.Ellipse(4,4,28,28);
        FormMain.Navigator.Canvas.MoveTo(7,7);
        FormMain.Navigator.Canvas.LineTo(25,25);
       end;
      if not Images[currentImageIndex].inpool then
       begin
        FormMain.Navigator.Canvas.Pen.Width:=1;
        FormMain.Navigator.Canvas.Brush.Color:=clWhite;
        FormMain.Navigator.Canvas.Pen.Color:=clWhite;
        FormMain.Navigator.Canvas.Rectangle(33,0,65,32);
        FormMain.Navigator.Canvas.Pen.Color:=clRed;
        if not FormOptions.PoolOnly.Checked then FormMain.Navigator.Canvas.Pen.Color:=clGreen;
        FormMain.Navigator.Canvas.Ellipse(37,4,61,28);
        FormMain.Navigator.Canvas.MoveTo(40,7);
        FormMain.Navigator.Canvas.LineTo(58,25);
       end;
      if (Images[currentImageIndex].license=6) or (Images[currentImageIndex].license=3) or (Images[currentImageIndex].license=0) then
       begin
        FormMain.Navigator.Canvas.Pen.Width:=1;
        FormMain.Navigator.Canvas.Brush.Color:=clWhite;
        FormMain.Navigator.Canvas.Pen.Color:=clWhite;
        FormMain.Navigator.Canvas.Rectangle(66,0,98,32);
        FormMain.Navigator.Canvas.Pen.Color:=clRed;
        if FormOptions.IgnoreLicense.Checked then FormMain.Navigator.Canvas.Pen.Color:=clGreen;
        FormMain.Navigator.Canvas.Ellipse(70,4,94,28);
        FormMain.Navigator.Canvas.MoveTo(73,7);
        FormMain.Navigator.Canvas.LineTo(91,25);
       end;
       FormMain.Navigator.Canvas.Pen.Width:=4;
       FormMain.Navigator.Canvas.Pen.Color:=clRed;
       if Pos('1',typestring[Images[currentImageIndex].typ])>0 then
        begin FormMain.Navigator.Canvas.MoveTo(81,0); FormMain.Navigator.Canvas.LineTo(81,10); end;
       if Pos('2',typestring[Images[currentImageIndex].typ])>0 then
        begin FormMain.Navigator.Canvas.MoveTo(162,81); FormMain.Navigator.Canvas.LineTo(152,81); end;
       if Pos('3',typestring[Images[currentImageIndex].typ])>0 then
        begin FormMain.Navigator.Canvas.MoveTo(81,162); FormMain.Navigator.Canvas.LineTo(81,152); end;
       if Pos('4',typestring[Images[currentImageIndex].typ])>0 then
        begin FormMain.Navigator.Canvas.MoveTo(0,81); FormMain.Navigator.Canvas.LineTo(10,81); end;
       FormMain.MainMemo.Clear;
       FormMain.MainMemo.Lines.Add(IntToStr(currentImageIndex+1)+' '+Images[currentImageIndex].title);
       FormMain.MainMemo.Lines.Add(' Owner: '+Images[currentImageIndex].owner);
       if Images[currentImageIndex].typ=0 then
        FormMain.MainMemo.Lines.Add(' Sides: none')
       else
        FormMain.MainMemo.Lines.Add(' Sides: '+typestring[Images[currentImageIndex].typ]);
       if not Images[currentImageIndex].inpool then FormMain.MainMemo.Lines.Add(' not in pool');
       if Images[currentImageIndex].excluded then FormMain.MainMemo.Lines.Add(' on exclusion list');
       FormMain.MainMemo.Lines.Add(' License: '+licensestr[Images[currentImageIndex].license]);
       if Images[currentImageIndex].typ=18 then FormMain.MainMemo.Lines.Add('WARNING. NO SIDES DEFINED.');
       FormMain.MainMemo.Lines.Add(' Page '+IntToStr(pageselect+1)+', Image '+IntToStr(pageselect*49+1)+'-'+IntToStr(min(displayList.Count,pageselect*49+49)));
      end;
     FormMain.ImageDisplay.Canvas.Brush.Color:=clWhite;
     FormMain.ImageDisplay.Canvas.Pen.Color:=clWhite;
     FormMain.ImageDisplay.Canvas.Rectangle(0,0,FormMain.ImageDisplay.Width,FormMain.ImageDisplay.Height+2);
     FormMain.ImageDisplay.Canvas.StretchDraw(Rect(1,1,FormMain.ImageDisplay.Width,FormMain.ImageDisplay.Height),gridImage)
   end;
  UpdateDropList;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Cleanup;
end;


procedure Cleanup;
var SaveFile: TStringList;
    i: Integer;

begin
  FormMain.OnResize:=nil;
  SaveFile:=TStringList.Create;
  SaveFile.Add('build11');
  SaveFile.Add(IntToStr(High(Images)));
  for i:=0 to High(Images) do
   begin
    SaveFile.Add(Images[i].id);
    SaveFile.Add(Images[i].userid);
    SaveFile.Add(IntToStr(Images[i].typ));
    SaveFile.Add(Images[i].title);
    SaveFile.Add(Images[i].owner);
    SaveFile.Add(BoolToStr(Images[i].excluded));
    SaveFile.Add(BoolToStr(Images[i].inpool));
    SaveFile.Add(IntToStr(Images[i].license));
    SaveFile.Add(IntToStr(Images[i].color.Color));
   end;
  SaveFile.Add(IntToStr(Length(blacklist)));
  for i:=0 to High(blacklist) do
    SaveFile.Add(blacklist[i]);
  SaveFile.SaveToFile(ExtractFilePath(Application.ExeName)+fileprefix+'.db');
  SaveFile.Free;
  displayList.Free;
  currentImage.Free;
  gridImage.Free;
end;

procedure TFormMain.SynchGroupClick(Sender: TObject);
var  val,rq,re,p,id,title,owner,ownerid,tag: string;
     im: TStringList;
     s,e,i,curpic,w,h,found,new: Integer;
     isnew,rejected: Boolean;
     fs: TFileStream;
     total: Integer;
     tempImage: TJpegImage;

begin
  FormMain.Enabled:=false;
  tempImage:=TJpegImage.Create;
  im:=TStringList.Create;
  val:='&email='+FormOptions.User.Text+'&password='+FormOptions.Pass.Text;
  val:=val+'&api_key='+FormOptions.Apikey.Text;
  rq:='';
  if Sender=SynchGroup then
   begin
    FormProgress.Caption:='Updating '+fileprefix;
    rq:='http://www.flickr.com/services/rest/?method=flickr.groups.pools.getPhotos'+val;
    rq:=rq+'&group_id='+groupid;
    for i:=0 to High(Images) do
      Images[i].inpool:=false;
   end;
  if Sender=SynchAll then
   begin
    FormProgress.Caption:='Updating everyone''s';
    rq:='http://www.flickr.com/services/rest/?method=flickr.photos.search'+val;
    rq:=rq+'&tags='+tiletag;
   end;
  if Sender=DownloadTile then
   begin
    id:=InputBox('Import single tile','Enter photo ID or URL','');
    if Copy(id,1,29)='http://www.flickr.com/photos/' then
      id:=Copy(Copy(id,30,Length(id)-29),Pos('/',Copy(id,30,Length(id)-29))+1,20);
    if Pos('/in/',id)>0 then
      id:=Copy(id,1,Pos('/in/',id)-1);
    if Copy(id,Length(id),1)='/' then id:=Copy(id,1,Length(id)-1);
    if id='' then begin FormMain.Enabled:=true; tempImage.Free; im.Free; Exit; end;
    rq:='http://www.flickr.com/services/rest/?method=flickr.photos.getInfo&photo_id='+id+val;
    re:=Brause.Get(rq);
    p:=Brause.Get(rq);
   end;
  if (Sender=SynchUser) or (Sender=FormOptions.CheckUser) then
   begin
    FormProgress.Caption:='Updating user''s';
    if Sender=SynchUser then
      re:=InputBox('Import user''s tiles','Username','')
    else
      re:=FormOptions.CheckUserName.Text;
    if re='' then begin FormMain.Enabled:=true; tempImage.Free; im.Free; Exit; end;
    rq:='http://www.flickr.com/services/rest/?method=flickr.people.findByUsername'+val;
    rq:=rq+'&username='+re;
    re:=Brause.Get(rq);

    rq:='http://www.flickr.com/services/rest/?method=flickr.photos.search'+val;
    if GetValue(re,'nsid')='' then begin MessageDlg('User not found',mtWarning,[mbOK],0); Exit; end;
    rq:=rq+'&tags='+tiletag+'&user_id='+GetValue(re,'nsid');
   end;

  FormProgress.Show;
  FormProgress.ProgressMemo.Clear;
  FormProgress.ProgressBar.Max:=100;
  Application.ProcessMessages;
  if Sender=DownloadTile then
    FormProgress.ProgressMemo.Lines.Add('Requesting tile.')
  else
   begin
    FormProgress.ProgressMemo.Lines.Add('Requesting picture list.');
    try
     re:=Brause.Get(rq);
    except
     re:='stat="fail"';
    end;
    if Pos('stat="fail"',re)>0 then
     begin
      MessageDlg('Failure to connect.',mtError,[mbOK],0);
      FormProgress.Hide;
      FormMain.Enabled:=true;
      tempImage.Free;
      FormMain.NavMode.ItemIndex:=2;
      pageselect:=Floor(High(Images)/49);
      FormMain.NavModeChange(NavMode);
      im.Free;
      Exit;
     end;
   end;
  if Sender<>DownloadTile then
   begin
    Application.ProcessMessages;
    for i:=2 to StrToInt(GetValue(re,'pages')) do
     begin
       re:=re+Brause.Get(rq+'&page='+IntToStr(i));
       FormProgress.ProgressBar.Position:=Floor(i/StrToInt(GetValue(re,'pages'))*100);
       Application.ProcessMessages;
     end;
    total:=StrToInt(GetValue(re,'total'));
   end
  else
   total:=1;
  found:=0; new:=0;

  FormProgress.ProgressMemo.Lines.Add('Checking photos.');
  Application.ProcessMessages;

  while Pos('<photo ',re)>0 do
   begin
     //detect the next photo
     s:=Pos('<photo ',re);
     if Sender=DownloadTile then
      e:=Pos('</photo>',Copy(re,s,Length(re)-s))
     else
      e:=Pos(' />',Copy(re,s,Length(re)-s));
     // extract it
     p:=Copy(re,s,e);
     re:=Copy(re,s+e+3,Length(re)-e-s+10);
     // process it
     if Sender<>DownloadTile then
      begin
       id:=GetValue(p,'id');
       title:=GetValue(p,'title');
       ownerid:=GetValue(p,'owner');
       owner:=GetValue(p,'ownername');
      end
     else
      begin
       title:=Copy(p,Pos('<title>',p)+7,Pos('</title>',p)-Pos('<title>',p)-7);
       ownerid:=GetValue(p,'nsid');
       owner:=GetValue(p,'username');
      end;
     found:=found+1;
     FormProgress.ProgressBar.Position:=Floor(found/total*100);
     Application.ProcessMessages;

     // check database for this picture
     curpic:=-1;
     for i:=0 to High(Images) do
       if Images[i].id=id then curpic:=i;

     // not present? create an entry
     isnew:=false;
     rejected:=false;

     if curpic=-1 then
      begin
       for i:=0 to High(blacklist) do
         if blacklist[i]=id then rejected:=true;
       if not rejected then
        begin
         isnew:=true;
         new:=new+1;
         SetLength(Images,Length(Images)+1);
         SetLength(used,Length(used)+1);
         used[High(used)]:=true;
         curpic:=High(Images);
         Images[curpic].inpool:=false;
         FormProgress.ProgressMemo.Lines.Add('new: '+Copy(title,1,20));
         Application.ProcessMessages;
        end
       else
        begin
         FormProgress.ProgressMemo.Lines.Add('blacklisted: '+Copy(title,1,20));
         Application.ProcessMessages;
        end;
      end;

     if not rejected then
      begin
       // update the info we've downloaded already
       // note that for DownloadTile we only have id yet,
       // and we don't really know if it exists, yet
       Images[curpic].id:=id;
       if Sender<>DownloadTile then
        begin
         Images[curpic].title:=title;
         Images[curpic].userid:=ownerid;
        end;
       if Sender=SynchGroup then
        begin
         Images[curpic].owner:=owner;
         Images[curpic].inpool:=true;
        end;
      end;

     // if this is a new picture or we are updating all, do it
     if isnew and not rejected then
      begin
       // is it square?
       rq:='http://www.flickr.com/services/rest/?method=flickr.photos.getSizes&photo_id='+id+val;
       p:=Brause.Get(rq);
       w:=StrToInt(GetValue(Copy(p,Pos('Thumbnail',p),300),'width'));
       h:=StrToInt(GetValue(Copy(p,Pos('Thumbnail',p),300),'height'));
       rejected:=false;
       if (w/h<0.98) or (w/h>1.03) then
        begin
         if godmode and (Sender=SynchGroup) then
          begin
           if postingstring<>'' then postingstring:=postingstring+#13#10;
           postingstring:=postingstring+'<a href="http://www.flickr.com/photos/'+Images[curpic].userid+'/'+Images[curpic].id+'">';
           postingstring:=postingstring+'<img src="'+GetValue(Copy(p,Pos('Square',p),200),'source')+'"></a>'#13#10;
           postingstring:=postingstring+'Not square.';
           rq:='http://www.flickr.com/services/rest/?method=flickr.groups.pools.remove&photo_id='+Images[curpic].id+val;
           rq:=rq+'&group_id='+groupid;
           p:=Brause.Get(rq);
           PostToGroup.Enabled:=true;
           PostToGroup.Visible:=true;
          end;
         FormProgress.ProgressMemo.Lines.Add('REJECTED: not square.');
         SetLength(Images,Length(Images)-1);
         SetLength(used,Length(used)-1);
         new:=new-1;
         rejected:=true;
        end
       else
        begin
         // download the images
         if not FileExists(ExtractFilePath(Application.ExeName)+'images/'+id+'.sq.jpg') then
          begin
           fs:=TFileStream.Create(ExtractFilePath(Application.ExeName)+'images/'+id+'.sq.jpg',fmCreate);
           Brause.Get(GetValue(Copy(p,Pos('Square',p),200),'source'),fs);
           fs.Free;
          end;
         if not FileExists(ExtractFilePath(Application.ExeName)+'images/'+id+'.sm.jpg') then
          begin
           fs:=TFileStream.Create(ExtractFilePath(Application.ExeName)+'images/'+id+'.sm.jpg',fmCreate);
           Brause.Get(GetValue(Copy(p,Pos('Small',p),200),'source'),fs);
           fs.Free;
          end;
         if not FileExists(ExtractFilePath(Application.ExeName)+'images/'+id+'.lg.jpg') then
          begin
           fs:=TFileStream.Create(ExtractFilePath(Application.ExeName)+'images/'+id+'.lg.jpg',fmCreate);
           Brause.Get(GetValue(Copy(p,Pos('Medium',p),200),'source'),fs);
           fs.Free;
          end;
         AverageColor(curpic);
        end;
      end;

     if (isnew or (FormOptions.FullUpdate.Checked)) and not rejected then
      // load the tags and license info
      begin
       rq:='http://www.flickr.com/services/rest/?method=flickr.photos.getInfo&photo_id='+id+val;
       p:=Brause.Get(rq);
       Images[curpic].owner:=GetValue(p,'username');
       Images[curpic].license:=StrToInt(GetValue(p,'license'));
       // now find a tag that starts with ll
       // select the tags section
       p:=Copy(p,Pos('<tags>',p),Length(p));
       if (Pos(tiletag,p)=0) and godmode and (Sender=SynchGroup) then
        begin
         // tag it
         rq:='http://www.flickr.com/services/rest/?method=flickr.photos.addTags&photo_id='+id+val;
         rq:=rq+'&tags='+tiletag;
         rq:=Brause.Get(rq);
        end;
       // now go through it tag by tag
       Images[curpic].typ:=18;
       while Pos('>'+tagprefix,p)>0 do
        begin
         s:=Pos('>'+tagprefix,p);
         e:=Pos('</tag>',Copy(p,s,Length(p)));
         tag:=Copy(p,s+1,e-2);
         if Images[curpic].typ=18 then
           Images[curpic].typ:=FindType(Copy(tag,3,Length(tag)));
         p:=Copy(p,s+e+2,Length(p));
        end;
       if Images[curpic].typ=16 then
         FormProgress.ProgressMemo.Lines.Add('WARNING. Not tagged.');
      end;
   end;
 if currentImageIndex=-1 then currentImageIndex:=High(Images);
 FormProgress.ProgressMemo.Lines.Add('Found '+IntToStr(found)+' images, '+IntToStr(new)+' new ones.');
 if new>0 then
   begin
     FormProgress.ProgOK.Enabled:=true;
     while ((not FormOptions.SkipConfirm.Checked) or (not doingautoupdate)) and (FormProgress.Visible) do Application.ProcessMessages;
   end
 else
   begin
     FormProgress.Hide;
     FormMain.Enabled:=true;
   end;
 tempImage.Free;
 if FormProgress.Visible then FormProgress.Close;
 FormMain.NavMode.ItemIndex:=2;
 pageselect:=Floor(High(Images)/49);
 FormMain.NavModeChange(NavMode);
 im.Free;
end;

procedure RemoveTile(index:Integer);
var i,j:Integer;

begin
  // look if the deleted tile is referenced in the grid and remove it
  for i:=0 to High(grid) do
    for j:=0 to High(grid[0]) do
      if grid[i,j].index=index then grid[i,j].index:=-1;
  //DeleteFile(ExtractFilePath(Application.ExeName)+'images/'+Images[index].id+'.sq.jpg');
  //DeleteFile(ExtractFilePath(Application.ExeName)+'images/'+Images[index].id+'.sm.jpg');
  //DeleteFile(ExtractFilePath(Application.ExeName)+'images/'+Images[index].id+'.lg.jpg');
  for i:=index to High(Images)-1 do
    Images[i]:=Images[i+1];
  SetLength(Images,Length(Images)-1);
  currentImageIndex:=min(currentImageIndex,High(Images));
end;

function FindType(tag: string): Integer;
var i,j: Integer;
    match: Boolean;

begin
  FindType:=-1;
  if Length(tag)=0 then Exit;
  if tag='0' then FindType:=0;
  for i:=0 to 17 do
   if Length(typestring[i])=Length(tag) then
    begin
     match:=true;
      for j:=1 to Length(tag) do
       if Pos(Copy(tag,j,1),typestring[i])=0 then match:=false;
     if match then FindType:=i;
    end;
end;

function GetValue(s, n: string): string;
var st,en: Integer;

begin
  GetValue:='';
  st:=Pos(n,s);
  if st=0 then exit;
  st:=st+Length(n)+2;
  en:=Pos('"',Copy(s,st,Length(s)-st+1));
  GetValue:=Copy(s,st,en-1);
end;

procedure TFormMain.MakeImageClick(Sender: TObject);
var i,s,j: Integer;
    finished, donesome, connected, newplaced: Boolean;
    nx,ny,ni: Integer;

begin
  // initialize stuff
  SetLength(used,Length(Images));
  if Sender<>FillCurrent then
   begin
    for i:=0 to High(used) do used[i]:=false;
    SetLength(grid,StrToInt(FormOptions.GridWidth.Text)+2);
    for i:=0 to High(grid) do
     SetLength(grid[i],StrToInt(FormOptions.GridHeight.Text)+2);
    AssignColorTarget;
    for i:=0 to High(grid) do
     for j:=0 to High(grid[0]) do
      begin
       grid[i,j].index:=-1;
       grid[i,j].typ:=-1;
      end;
    if FormOptions.ApplyGradient.Checked then
     begin
      AssignGradientTarget;
      FormMain.Repopulate1Click(Repopulate1);
      Exit;
     end;
   end;

  if (Sender=MakeEmpty) or (Length(Images)=0) then
    begin
     FormMain.MakeLargeClick(MakeImage);
     FormMain.MakeLarge.Enabled:=true;
     Exit;
    end;

  // make a new line structure, if we're required to
  if Sender<>FillCurrent then
    begin
     // pick a random seed
     Randomize;
     repeat
      s:=Random(Length(Images));
     until TileIsUsable(s) and (Images[s].typ>0);
     used[s]:=true;
     grid[Floor(Length(grid)/2),Floor(Length(grid[0])/2)].index:=s;
     grid[Floor(Length(grid)/2),Floor(Length(grid[0])/2)].id:=Images[s].id;
     grid[Floor(Length(grid)/2),Floor(Length(grid[0])/2)].typ:=Images[s].typ;
    end;

  // now fill in the grid as much as possible with the current settings
  finished:=false;
  newplaced:=false;
  donesome:=true;
  while not finished do
   begin
     // fill in all connected grid elements as long as that is possible
     while donesome do
      begin
       donesome:=false;
       for i:=1 to High(grid)-1 do
         for j:=1 to High(grid[0])-1 do
          if grid[i,j].index=-1 then
           begin
             // this is an empty tile
             // does it have any neighbors that connect?
             connected:=false;
             if grid[i,j-1].index>-1 then
              if Pos('3',typestring[grid[i,j-1].typ])>0 then connected:=true;
             if grid[i+1,j].index>-1 then
              if Pos('4',typestring[grid[i+1,j].typ])>0 then connected:=true;
             if grid[i,j+1].index>-1 then
              if Pos('1',typestring[grid[i,j+1].typ])>0 then connected:=true;
             if grid[i-1,j].index>-1 then
              if Pos('2',typestring[grid[i-1,j].typ])>0 then connected:=true;
             if connected then
              // get a tile that fits here if there is one left
              begin
               s:=GetNewTile(i,j);
               if s>-1 then
                // now put up the tile and mark it used, if multiple use is disallowed
                begin
                 donesome:=true;
                 newplaced:=true;
                end;
              end;
           end;
      end;
     // now we went through the whole grid and can't find a connected tile to fill
     // find an empty grid element that can be filled
     donesome:=false;
      for i:=1 to High(grid)-1 do
       for j:=1 to High(grid[0])-1 do
         if not donesome and newplaced then
          if grid[i,j].index=-1 then
            begin
             // empty tile. does it have any neighbors?
             connected:=false;
             if grid[i,j-1].index>-1 then connected:=true;
             if grid[i+1,j].index>-1 then connected:=true;
             if grid[i,j+1].index>-1 then connected:=true;
             if grid[i-1,j].index>-1 then connected:=true;
             if connected then
              // if we're allowed, try to place the start of a new line here
              if not FormOptions.SingleLine.Checked then
                begin
                  if GetNewTile(i,j)>-1 then
                    donesome:=true;
                end
              else
               // we have to make a single line
               // SOMETHING'S FISHY HERE. FIX.
               //if FormOptions.Multiples.Checked then
                begin
                 repeat
                  s:=Random(4)+1;
                  nx:=i; ny:=j;
                  case s of
                   1: begin nx:=i; ny:=j+1; end;
                   2: begin nx:=i-1; ny:=j; end;
                   3: begin nx:=i; ny:=j-1; end;
                   4: begin nx:=i+1; ny:=j; end;
                  end;
                  ni:=grid[nx,ny].index;
                 until ni<>-1;
                 // now we have the neighbor. add a connector to this tile
                 if AddConnector(nx,ny,s) then
                  begin
                   donesome:=true;
                   newplaced:=false; // this prevents us from doing this again
                                     // if this attempt doesn't work
                                     // that's conservative, since it might work
                                     // next time, but that's better than an
                                     // indefinite loop caused by no available
                                     // connecting tiles
                  end;
                end;
            end;
     // if we were unable to do that as well, we're done
     if not donesome then finished:=true;
   end;

  // now we got ourselves a grid, send it to render
  UpdateButtonState;
  imageState:=0;
  if NavMode.ItemIndex<>3 then
    if NavMode.ItemIndex<>1 then
      NavMode.ItemIndex:=1
    else NavModeChange(NavMode)
  else
    NavModeChange(NavMode);
end;

function GetNewTile(x,y:Integer): Integer;
var i: Integer;
    legaltype: array[0..18] of Boolean;
    chooselist: TChooselist;
    canbeused: Boolean;

begin
  // this function randomly selects an available tile that can be used at a
  // certain grid position

  GetNewTile:=-1;
  for i:=0 to 17 do legaltype[i]:=true;
  // do not use tiles without a tag
  legaltype[18]:=false;

  // is there a downward connector from above?
  if grid[x,y-1].index<>-1 then
   begin
    if Pos('3',typestring[grid[x,y-1].typ])>0 then
     // if so, disable all types that don't have one going up
     begin
      for i:=0 to 17 do
        if Pos('1',typestring[i])=0 then
          legaltype[i]:=false;
     end
    else
     // if not, disable all that do
      for i:=0 to 17 do
        if Pos('1',typestring[i])>0 then
          legaltype[i]:=false;
   end;

  // if this is a border tile and we don't want outside connection
  // remove upward connectors
  if (y=1) and FormOptions.NoOutside.Checked then
    for i:=0 to 17 do
      if Pos('1',typestring[i])>0 then
        legaltype[i]:=false;

  // is there a leftward connector from the right?
  if grid[x+1,y].index<>-1 then
   begin
    if Pos('4',typestring[grid[x+1,y].typ])>0 then
     begin
      for i:=0 to 17 do
        if Pos('2',typestring[i])=0 then
          legaltype[i]:=false;
     end
    else
      for i:=0 to 17 do
        if Pos('2',typestring[i])>0 then
          legaltype[i]:=false;
   end;

  if (x=High(grid)-1) and FormOptions.NoOutside.Checked then
    for i:=0 to 17 do
      if Pos('2',typestring[i])>0 then
        legaltype[i]:=false;

  // is there an upward connector from below?
  if grid[x,y+1].index<>-1 then
   begin
    if Pos('1',typestring[grid[x,y+1].typ])>0 then
     begin
      for i:=0 to 17 do
        if Pos('3',typestring[i])=0 then
          legaltype[i]:=false;
     end
    else
      for i:=0 to 17 do
        if Pos('3',typestring[i])>0 then
          legaltype[i]:=false;
   end;

  if (y=High(grid[0])-1) and FormOptions.NoOutside.Checked then
    for i:=0 to 17 do
      if Pos('3',typestring[i])>0 then
        legaltype[i]:=false;

  // is there a rightward connector from the left?
  if grid[x-1,y].index<>-1 then
   begin
    if Pos('2',typestring[grid[x-1,y].typ])>0 then
     begin
      for i:=0 to 17 do
        if Pos('4',typestring[i])=0 then
          legaltype[i]:=false;
     end
    else
      for i:=0 to 17 do
        if Pos('4',typestring[i])>0 then
          legaltype[i]:=false;
   end;

  if (x=1) and FormOptions.NoOutside.Checked then
    for i:=0 to 17 do
      if Pos('4',typestring[i])>0 then
        legaltype[i]:=false;

  // now make a list of all tiles that conform to the list of
  // allowed types

  // this needs modification:
  // if rotation is allowed, if one of a group of types is legal,
  // all of them are
  // but if one of a group is selected, the type stored must be
  // the legal one, even if different from the type of the tile
  // used

  for i:=0 to High(Images) do
    if TileIsUsable(i)
     then
      begin
       canbeused:=false;
       if FormOptions.AllowRotate.Checked then
        begin
         case Images[i].typ of
          0: canbeused:=legaltype[0];
          1..4: canbeused:=legaltype[1] or legaltype[2] or legaltype[3] or legaltype[4];
          6,9: canbeused:=legaltype[6] or legaltype[9];
          5,7,8,10: canbeused:=legaltype[5] or legaltype[7] or legaltype[8] or legaltype[10];
          11..14: canbeused:=legaltype[11] or legaltype[12] or legaltype[13] or legaltype[14];
          15: canbeused:=legaltype[15];
          16, 17: canbeused:=legaltype[16] or legaltype[17];
         end;
        end
       else
        canbeused:=legaltype[Images[i].typ];
       if canbeused then
        begin
         SetLength(chooselist,Length(chooselist)+1);
         chooselist[High(chooselist)]:=i;
        end;
      end;
  if Length(chooselist)=0 then Exit;
  CleanList(chooselist,x,y);
  i:=Random(Length(chooselist));
  GetNewTile:=chooselist[i];
  grid[x,y].index:=chooselist[i];
  used[chooselist[i]]:=true;
  grid[x,y].id:=Images[chooselist[i]].id;
  if legaltype[Images[chooselist[i]].typ] then grid[x,y].typ:=Images[chooselist[i]].typ else
  case Images[chooselist[i]].typ of
   0: grid[x,y].typ:=0;
   1..4: repeat grid[x,y].typ:=Random(4)+1; until legaltype[grid[x,y].typ];
   6,9: repeat grid[x,y].typ:=6+3*Random(2); until legaltype[grid[x,y].typ];
   5,7,8,10: repeat
              case Random(4) of
               0: grid[x,y].typ:=5;
               1: grid[x,y].typ:=7;
               2: grid[x,y].typ:=8;
               3: grid[x,y].typ:=10;
              end;
             until legaltype[grid[x,y].typ];
   11..14: repeat grid[x,y].typ:=Random(4)+11; until legaltype[grid[x,y].typ];
   15: grid[x,y].typ:=15;
   16,17: repeat grid[x,y].typ:=Random(2)+16; until legaltype[grid[x,y].typ];
  end;
end;

function TileIsUsable(i:integer): Boolean;

begin
  if (Images[i].typ=-1) or (Images[i].typ=18) then Result:=false else
   Result:= ( (not used[i]) or FormOptions.Multiples.Checked)
    and ((not Images[i].excluded) or (FormOptions.NoExclude.Checked))
    and ((Images[i].inpool) or (not FormOptions.PoolOnly.Checked))
    and ((FormOptions.UserName.ItemIndex=0)
       or ((FormOptions.UserName.ItemIndex=1) and ( (Images[i].owner='Genista') or (Images[i].owner='dotpolka')   ) )
       or (FormOptions.UserName.Text=Images[i].owner+'''s'))
    and ( FormOptions.IgnoreLicense.Checked
         or (Images[i].license=4) or (Images[i].license=5)
         or (Images[i].owner='Genista') or (Images[i].owner='dotpolka')
         or ( (not FormOptions.MakeCommercial.Checked) and ((Images[i].license=1) or (Images[i].license=2)) ) )
    and ((usabletypecheck[Images[i].typ].Checked) or (not FormOptions.ApplyUsability.Checked));
end;

procedure TFormMain.MakeLargeClick(Sender: TObject);
var imsize,i,j: Integer;
    imext: string;

begin
  // this renders the grid

  imsize:=75;
  imext:='.sq.jpg';

  gridImage.PixelFormat:=pf24bit;
  gridImage.Width:=imsize*Length(grid);
  gridImage.Height:=imsize*Length(grid[0]);

  gridImage.Canvas.Pen.Color:=clWhite;
  gridImage.Canvas.Brush.Color:=clWhite;
  gridImage.Canvas.Rectangle(0,0,gridImage.Width,gridImage.Height);

  FormProgress.ProgressBar.Max:=(high(grid)+1)*(high(grid[0])+1);
  FormProgress.ProgressMemo.Text:='Rendering...';
  FormProgress.Show;
  FormMain.Enabled:=false;

  for i:=0 to high(grid) do
    for j:=0 to high(grid[0]) do
      begin
        FormProgress.ProgressBar.Position:=i*(high(grid[0])+1)+j+1;
        Application.ProcessMessages;
        DrawTile(i,j,imsize,imext,imsize,imsize,false);
      end;

  FormProgress.Hide;
  FormMain.Enabled:=true;
  
  if FormOptions.UseOnlyOnce.Checked then
    FormOptions.UseDrawSettings.Checked:=false;

  if Sender=MakeImage then
   begin
    if FormMain.NavMode.ItemIndex<>3 then FormMain.NavMode.ItemIndex:=1;
    FormMain.NavModeChange(NavMode);
   end;
  imageState:=FormMain.NavMode.ItemIndex;
end;

procedure DrawTile(x,y,imsize: Integer;imext: string; dx,dy: Integer; exporting: Boolean);
var tempJPG: TJPEGImage;
    tempBMP: TBitmap;
    it,gt,an, px, py, tx, ty: Integer;
    rf,gf,bf,nf,rb,gb,bb,nb: Integer;
    attamp, target, offset, pushamp,  bgscx, bgscy: Double;
    targetmix: array of Double;
    ReduceContrast, DrawLines, PushColor, isback: Boolean;
    BorderWidth, LineWidth: Integer;
    Back,Fore: TColor;
    Pixel: TRGBColor;
    i: Integer;
    BGArea: TRect;

begin
  tempJPG:=TJPEGImage.Create;
  SetLength(targetmix,imsize);

  if exporting then
    begin
      PushColor:=FormSaveOptions.PushColor.Checked;
      pushamp:=StrToInt(FormSaveOptions.ColorDistanceReduction.Text)/100;
      ReduceContrast := FormSaveOptions.SOLowerContrast.Checked;
      DrawLines := FormSaveOptions.SOSeparators.Checked;
      attamp := 1 - StrToInt(FormSaveOptions.SOBackContrast.Text)/100;
      LineWidth := ceil( StrToInt(FormSaveOptions.SOLowLineWidth.Text)/2000 * imsize);
      BorderWidth := ceil( StrToInt(FormSaveOptions.SOLineWidth.Text)/2000 * imsize);
    end
  else
    begin
      PushColor:=(FormOptions.PushColor.Checked and FormOptions.ApplyColor.Checked and FormOptions.UseDrawSettings.Checked);
      pushamp:=StrToInt(FormOptions.ColorDistanceReduction.Text)/100;
      ReduceContrast := FormOptions.LowerContrast.Checked and FormOptions.UseDrawSettings.Checked;
      DrawLines := FormOptions.Separators.Checked and FormOptions.UseDrawSettings.Checked;
      attamp := 1 - StrToInt(FormOptions.BackContrast.Text)/100;
      LineWidth := ceil( StrToInt(FormOptions.LowLineWidth.Text)/2000 * imsize);
      BorderWidth := ceil( StrToInt(FormOptions.LineWidth.Text)/2000 * imsize);
    end;
  if grid[x,y].typ>-1 then
   begin
    if FormMain.NavMode.ItemIndex=3 then
     begin
      with gridImage.Canvas do
       begin
        Pen.Color:=clGreen;
        Pen.Width:=2;
        if not ColorTargetLoaded then
          Brush.Color:=clWhite
        else
          Brush.Color:=grid[x,y].target.Color;
        Rectangle(Rect( (x-1)*imsize+dx,(y-1)*imsize+dy,x*imsize+dx,y*imsize+dy));
        Pen.Color:=clRed;
        Pen.Width:=7;
       end;

      offset:=0;

      if Pos('f',typestring[grid[x,y].typ])>0 then
       offset:=0.1;

      if Pos('r',typestring[grid[x,y].typ])>0 then
       offset:=-0.1;

      with gridImage.Canvas do
      begin
       MoveTo(Floor((x-0.5+offset)*imsize+dx),Floor((y-0.5-abs(offset))*imsize+dy));
       if Pos('1',typestring[grid[x,y].typ])>0 then
        LineTo(Floor((x-0.5)*imsize+dx),(y-1)*imsize+dy);

       MoveTo(Floor((x-0.5+abs(offset))*imsize+dx),Floor((y-0.5-offset)*imsize+dy));
       if Pos('2',typestring[grid[x,y].typ])>0 then
        LineTo(x*imsize+dx,Floor((y-0.5)*imsize+dy));

       MoveTo(Floor((x-0.5-offset)*imsize+dx),Floor((y-0.5+abs(offset))*imsize+dy));
       if Pos('3',typestring[grid[x,y].typ])>0 then
        LineTo(Floor((x-0.5)*imsize+dx),y*imsize+dy);

       MoveTo(Floor((x-0.5-abs(offset))*imsize+dx),Floor((y-0.5+offset)*imsize+dy));
       if Pos('4',typestring[grid[x,y].typ])>0 then
        LineTo((x-1)*imsize+dx,Floor((y-0.5)*imsize+dy));
      end;

      imageState:=3;
     end
    else
     begin
      tempBMP:=TBitmap.Create;
      tempBMP.Width:=imsize;
      tempBMP.Height:=imsize;
      if grid[x,y].index=-1 then begin tempJPG.Free; Exit; end;
      // load the image
      tempJPG.LoadFromFile(ExtractFilePath(Application.ExeName)+'images/'+Images[grid[x,y].index].id+imext);
      // determine the rotation angle
      it:=Images[grid[x,y].index].typ;
      gt:=grid[x,y].typ;
      an:=0;
      if it<>gt then
       case it of
        0: an:=0;
        1..4: an:=gt-it;
        6: if gt=9 then an:=1;
        9: if gt=6 then an:=1;
        5: case gt of
            7: an:=3;
            8: an:=1;
            10: an:=2;
           end;
        7: case gt of
            5: an:=1;
            8: an:=2;
            10: an:=3;
           end;
        8: case gt of
            5: an:=3;
            7: an:=2;
            10: an:=1;
           end;
        10: case gt of
            5: an:=2;
            7: an:=1;
            8: an:=3;
           end;
        11..14: an:=it-gt;
        16: if gt=17 then an:=2;
        17: if gt=16 then an:=2;
       end;
       if an<0 then an:=an+4;
       if an>3 then an:=an-4;
      if (an=0) and (not ReduceContrast) and (not DrawLines) and (not PushColor) then
        // lucky! we can just stretchdraw and be done
        gridImage.Canvas.StretchDraw(Bounds((x-1)*imsize+dx,(y-1)*imsize+dy,imsize,imsize),tempJPG)
      else
       begin
         // we need to do this pixel by pixel. might take a while
         // start by making a bmp out of the jpg
         tempBMP.Canvas.StretchDraw(Bounds(0,0,imsize,imsize),tempJPG);
         // reset the averages
         nf:=0; rf:=0; bf:=0; gf:=0;
         nb:=0; rb:=0; bb:=0; gb:=0;
         if ReduceContrast then
          begin
           // construct attenuator function: bands with sine modulation between
           // do this outside once instead of here for every tile to optimize code
           for i:=0 to imsize-1 do
               if  abs(i-imsize/2)>1.5 * LineWidth then
                 // background, full attenuation
                 targetmix[i] := 0
               else if abs(i-imsize/2)<LineWidth/2 then
                 // foreground, full attenuation
                 targetmix[i] := 1
               else
                 // change one to the other. this is symmetric, therefore same
                 // formula for the increase and decrease part
                 targetmix[i] :=  0.5 - sin( ( abs(i-imsize/2)/LineWidth-1)*Pi )/2;
           // determine the average colors
           for px:=0 to imsize-1 do
             for py:=0 to imsize-1 do
               begin
                // get the coordinates in the target
                tx:=0; ty:=0;
                case an of
                 3: begin tx:=py; ty:=imsize-px-1; end;
                 2: begin tx:=imsize-px-1; ty:=imsize-py-1; end;
                 1: begin tx:=imsize-py-1; ty:=px; end;
                 0: begin tx:=px; ty:=py; end;
                end;
                // read the pixel color from the picture position
                Pixel.Color := tempBMP.Canvas.Pixels[px,py];
                // where are we in the target image? line or background?
                if ( (ty<imsize/2) and (Pos('1',typestring[grid[x,y].typ])>0)
                   and (abs(tx-imsize/2)<LineWidth) ) or
                 ( (tx>=imsize/2) and (Pos('2',typestring[grid[x,y].typ])>0)
                   and (abs(ty-imsize/2)<LineWidth) ) or
                 ( (ty>=imsize/2) and (Pos('3',typestring[grid[x,y].typ])>0)
                   and (abs(tx-imsize/2)<LineWidth) ) or
                 ( (tx<imsize/2) and (Pos('4',typestring[grid[x,y].typ])>0)
                   and (abs(ty-imsize/2)<LineWidth) ) then
                 begin
                   // this is foreground / a line
                   rf := rf + Pixel.Red;
                   bf := bf + Pixel.Blue;
                   gf := gf + Pixel.Green;
                   nf := nf + 1;
                 end
                else
                 begin
                   // this is background
                   rb := rb + Pixel.Red;
                   bb := bb + Pixel.Blue;
                   gb := gb + Pixel.Green;
                   nb := nb + 1;
                 end;
             end;
           // average, if we have anything to average
           if nf>0 then
             begin
               rf:=round(rf/nf);
               gf:=round(gf/nf);
               bf:=round(bf/nf);
             end;
           // no check for nb=0, there is always background pixels
           rb:=round(rb/nb);
           gb:=round(gb/nb);
           bb:=round(bb/nb);
          end;
         // now do the actual drawing
         for px:=0 to imsize-1 do
          for py:=0 to imsize-1 do
           begin
            tx:=0; ty:=0;
            case an of
             3: begin tx:=py; ty:=imsize-px-1; end;
             2: begin tx:=imsize-px-1; ty:=imsize-py-1; end;
             1: begin tx:=imsize-py-1; ty:=px; end;
             0: begin tx:=px; ty:=py; end;
            end;
           // read the source pixel
           Pixel.Color := tempBMP.Canvas.Pixels[px,py];
           // if we reduce contrast, do it based on where we want to be
           // in the target
           if ReduceContrast then
             begin
               // default: background, maximum attenuation
               target := 0;
               // if we have a vertical line along the row we're in, attenuate
               if ((ty<imsize/2) and (Pos('1',typestring[grid[x,y].typ])>0)) or
                  ((ty>=imsize/2) and (Pos('3',typestring[grid[x,y].typ])>0)) then
                    target:=max(target,targetmix[tx]);
               // if we have a horizontal line along the column we're in, attenuate
               if ((tx<imsize/2) and (Pos('4',typestring[grid[x,y].typ])>0)) or
                  ((tx>=imsize/2) and (Pos('2',typestring[grid[x,y].typ])>0)) then
                    target:=max(target,targetmix[ty]);
               // now shift toward target
               Pixel.Red   := round((1-attamp) * Pixel.Red   + attamp * ( (1-target) * rb + target * rf ) );
               Pixel.Green := round((1-attamp) * Pixel.Green + attamp * ( (1-target) * gb + target * gf ) );
               Pixel.Blue  := round((1-attamp) * Pixel.Blue  + attamp * ( (1-target) * bb + target * bf ) );
             end;
           if PushColor then
             // push every pixel in the tile toward the color target
             if  (FormOptions.ColorTargetNeutral.ItemIndex=0) or
                ((FormOptions.ColorTargetNeutral.ItemIndex=1) and (grid[x,y].target.Color<>clWhite) ) or
                ((FormOptions.ColorTargetNeutral.ItemIndex=2) and (grid[x,y].target.Color<>clBlack) ) then
             begin
               Pixel.Red   := round( pushamp * Pixel.Red   + (1-pushamp) * grid[x,y].target.Red );
               Pixel.Blue  := round( pushamp * Pixel.Blue  + (1-pushamp) * grid[x,y].target.Blue );
               Pixel.Green := round( pushamp * Pixel.Green + (1-pushamp) * grid[x,y].target.Green );
             end;
           // draw the borders, if we're meant to
           if DrawLines then
             if (tx<BorderWidth) or (imsize-tx-1<BorderWidth) or
                (ty<BorderWidth) or (imsize-ty-1<BorderWidth) then
               Pixel.Color := clWhite;
           // finally we assign the manipulated color to the target
           gridImage.Canvas.Pixels[(x-1)*imsize+dx+tx,(y-1)*imsize+dy+ty]:=Pixel.color;
          end;
       end;
      imageState:=1;
      tempBMP.Free;
     end;
   end
  else
   begin
    // draw an empty tile
    if (grid[x,y].typ=-2) and (FormMain.NavMode.ItemIndex=1) and BGLoaded then
      begin
        // determine scale
        BGArea:=GetBGArea;
        BGArea.Left:=(BGArea.Left-1)*imsize+dx;
        BGArea.Right:=BGArea.Right*imsize+dx;
        BGArea.Top:=(BGArea.Top-1)*imsize+dy;
        BGArea.Bottom:=BGArea.Bottom*imsize+dy;
        if FormOptions.BGFormat.ItemIndex=0 then
          // stretch: leave origin at BGArea.TopLeft, stretch to width and height
          begin
            bgscx := FormOptions.BGImage.Picture.Width / (BGArea.Right-BGArea.Left+1);
            bgscy := FormOptions.BGImage.Picture.Height / (BGArea.Bottom-BGArea.Top+1);
          end
        else
          // crop: shift origin to left if BGimage is wider, up if it's taller
          begin
            if FormOptions.BGImage.Picture.Width/FormOptions.BGImage.Picture.Height>
              (BGArea.Right-BGArea.Left+1)/(BGArea.Bottom-BGArea.Top+1) then
              // BGImage is wider
              begin
                bgscy := FormOptions.BGImage.Picture.Height / (BGArea.Bottom-BGArea.Top+1);
                bgscx := bgscy;
                BGArea.Left:=BGArea.Left + Floor((BGArea.Right - BGArea.Left + 1 - FormOptions.BGImage.Picture.Width/bgscx) /2);
              end
            else
              // BGImage is taller
              begin
                bgscx := FormOptions.BGImage.Picture.Width / (BGArea.right-BGArea.Left+1);
                bgscy := bgscx;
                BGArea.Top:=BGArea.Top + Floor((BGArea.Bottom - BGArea.Top + 1 - FormOptions.BGImage.Picture.Height/bgscy) /2);
              end
          end;
        // now we have the top left anchor for the bgimage within gridImage
        // and the x and y scale
        // extract the correct rectangle and paint onto the tile square
        gridImage.Canvas.CopyRect(Bounds((x-1)*imsize+dx,(y-1)*imsize+dy,imsize,imsize),
          FormOptions.BGImage.Picture.Bitmap.Canvas,
          Bounds( Floor(((x-1)*imsize+dx-BGArea.Left)*bgscx),Floor(((y-1)*imsize+dy-BGArea.Top)*bgscy),
            Floor(75*bgscx), Floor(75*bgscy) ));
        tempJPG.Free;
        Exit;
      end;
    if ColorTargetLoaded and (x>0) and (x<high(grid)) and (y>0) and (y<high(grid[0])) then
      gridImage.Canvas.Brush.Color:=grid[x,y].target.Color
    else
      gridImage.Canvas.Brush.Color:=clWhite;
    if FormMain.NavMode.ItemIndex=3 then
      gridImage.Canvas.Pen.Color:=clBlue
    else
      begin
       gridImage.Canvas.Pen.Color:=clWhite;
       gridImage.Canvas.Brush.Color:=clWhite;
      end;
    if grid[x,y].typ=-2 then gridImage.Canvas.Brush.Color:=clBlack;
    gridImage.Canvas.Pen.Width:=1;
    gridImage.Canvas.Rectangle(Rect((x-1)*imsize+dx+1,(y-1)*imsize+dy+1,x*imsize+dx+1,y*imsize+dy+1));
    gridImage.Canvas.Pen.Color:=clBlue;
    if grid[x,y].typ=-2 then gridImage.Canvas.Pen.Color:=clRed;
    gridImage.Canvas.Pen.Width:=4;
    if FormMain.NavMode.ItemIndex=3 then
      begin
       gridImage.Canvas.MoveTo((x-1)*imsize+dx,(y-1)*imsize+dy);
       gridImage.Canvas.LineTo(x*imsize+dx,y*imsize+dy);
       gridImage.Canvas.MoveTo(x*imsize+dx,(y-1)*imsize+dy);
       gridImage.Canvas.LineTo((x-1)*imsize+dx,y*imsize+dy);
      end;
   end;
  tempJPG.Free;
end;

procedure UpdateButtonState;
var i: Integer;
    imagecount: array[0..18] of Integer;

begin
  for i:=0 to 18 do imagecount[i]:=0;
  for i:=0 to High(Images) do
   if TileIsUsable(i) then imagecount[Images[i].typ]:=imagecount[Images[i].typ]+1;
  for i:=0 to 17 do
   begin
    if imagecount[i]<>1 then
      speedbuttons[i].Hint:=IntToStr(imagecount[i])+' images available.'
    else
      speedbuttons[i].Hint:='1 image available.';
    if imagecount[i]=0 then
     begin
      speedbuttons[i].Enabled:=false;
      speedbuttons[i].Down:=false;
     end
    else
     speedbuttons[i].Enabled:=true;
   end;
  i:=imagecount[15]+imagecount[16]+imagecount[17];
  if i<>1 then
   speedbuttons[18].Hint:=IntToStr(i)+' images available.'
  else
   speedbuttons[18].Hint:='1 image available.';
  if i=0 then
   begin
    speedbuttons[18].Enabled:=false;
    speedbuttons[18].Down:=false;
   end
  else
   speedbuttons[18].Enabled:=true;
end;

procedure TFormMain.NavModeChange(Sender: TObject);
var x,y,i,t,ii: Integer;
    tempImage: TJPEGImage;

begin
  if (Length(grid)=0) and (NavMode.ItemIndex<>0) and (NavMode.ItemIndex<>2) then
   begin
    NavMode.ItemIndex:=0;
    Exit;
   end;
  case NavMode.ItemIndex of
   0: begin BExclude.Visible:=true; BReject.Visible:=true; BTag.Visible:=true; SZoom.Visible:=false; end;
   1: begin BExclude.Visible:=false; BReject.Visible:=false; BTag.Visible:=false; SZoom.Visible:=true; if imageState<>1 then FormMain.MakeLargeClick(Sender); end;
   2: begin
       displayList.Clear;
       tempImage:=TJPEGImage.Create;
       BExclude.Visible:=true; BReject.Visible:=true;
       BTag.Visible:=true; SZoom.Visible:=false;
       // first, collect all the images we can see right now
       t:=-1;
       for i:=0 to 18 do
        if speedbuttons[i].Down then t:=i;

       for i:=0 to High(Images) do
         if (t=-1) or (Images[i].typ=t) or
           ( (t=18) and ((Images[i].typ>14) and (Images[i].typ<18)) )
           then
             begin
              // it's the right type. is it problematic or usable? does it matter?
              if SP23.Down then
                if (Images[i].typ =18) or (Images[i].typ=-1) or (Images[i].license mod 3 =0) then
                  displayList.Add(IntToStr(i));
              if not SP23.Down then
                if (not SP22.Down) or (TileIsUsable(i)) then
                  displayList.Add(IntToStr(i));
             end;

       pageselect:=min(Floor(displayList.Count/49),pageselect);

       // we need to make the overview image here
       gridImage.Width:=518; gridImage.Height:=518;
       gridImage.Canvas.Brush.Color:=clWhite;
       gridImage.Canvas.Pen.Color:=clWhite;
       gridImage.Canvas.Rectangle(Rect(0,0,520,520));
       x:=0; y:=0;
       for i:=0+49*pageselect to min(displayList.Count-1,48+49*pageselect) do
        begin
          ii:=StrToInt(displayList[i]);
          tempImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'images/'+Images[ii].id+'.sq.jpg');
          gridImage.Canvas.StretchDraw(Rect(x*74+1,y*74+1,(x+1)*74,(y+1)*74),tempImage);
          if Images[ii].excluded then
           begin
             gridImage.Canvas.Pen.Width:=1;
             gridImage.Canvas.Brush.Color:=clWhite;
             gridImage.Canvas.Pen.Color:=clWhite;
             gridImage.Canvas.Rectangle(x*74,y*74,x*74+15,y*74+15);
             gridImage.Canvas.Pen.Color:=clRed;
             if FormOptions.NoExclude.Checked then gridImage.Canvas.Pen.Color:=clGreen;
             gridImage.Canvas.Ellipse(x*74+2,y*74+2,x*74+13,y*74+13);
             gridImage.Canvas.MoveTo(x*74+5,y*74+5);
             gridImage.Canvas.LineTo(x*74+11,y*74+11);
           end;
          if not Images[ii].inpool then
           begin
             gridImage.Canvas.Pen.Width:=1;
             gridImage.Canvas.Brush.Color:=clWhite;
             gridImage.Canvas.Pen.Color:=clWhite;
             gridImage.Canvas.Rectangle(x*74+16,y*74,x*74+31,y*74+15);
             gridImage.Canvas.Pen.Color:=clRed;
             if not FormOptions.PoolOnly.Checked then gridImage.Canvas.Pen.Color:=clGreen;
             gridImage.Canvas.Ellipse(x*74+18,y*74+2,x*74+29,y*74+13);
             gridImage.Canvas.MoveTo(x*74+21,y*74+5);
             gridImage.Canvas.LineTo(x*74+27,y*74+11);
           end;
          if (Images[ii].license=6) or (Images[ii].license=3) or (Images[ii].license=0) then
           begin
             gridImage.Canvas.Pen.Width:=1;
             gridImage.Canvas.Brush.Color:=clWhite;
             gridImage.Canvas.Pen.Color:=clWhite;
             gridImage.Canvas.Rectangle(x*74+32,y*74,x*74+47,y*74+15);
             gridImage.Canvas.Pen.Color:=clRed;
             if FormOptions.IgnoreLicense.Checked then gridImage.Canvas.Pen.Color:=clGreen;
             gridImage.Canvas.Ellipse(x*74+34,y*74+2,x*74+45,y*74+13);
             gridImage.Canvas.MoveTo(x*74+37,y*74+5);
             gridImage.Canvas.LineTo(x*74+43,y*74+11);
           end;
          gridImage.Canvas.Pen.Width:=1;
          gridImage.Canvas.Brush.Color:=Images[ii].color.Color;
          gridImage.Canvas.Pen.Color:=clWhite;
          gridImage.Canvas.Rectangle(x*74,y*74+59,x*74+15,y*74+75);

          gridImage.Canvas.Pen.Color:=clRed;
          gridImage.Canvas.Pen.Width:=4;
          if Pos('1',typestring[Images[ii].typ])>0 then
           begin gridImage.Canvas.MoveTo(x*74+37,y*74+2); gridImage.Canvas.LineTo(x*74+37,y*74+10); end;
          if Pos('2',typestring[Images[ii].typ])>0 then
           begin gridImage.Canvas.MoveTo(x*74+72,y*74+37); gridImage.Canvas.LineTo(x*74+64,y*74+37); end;
          if Pos('3',typestring[Images[ii].typ])>0 then
           begin gridImage.Canvas.MoveTo(x*74+37,y*74+64); gridImage.Canvas.LineTo(x*74+37,y*74+72); end;
          if Pos('4',typestring[Images[ii].typ])>0 then
           begin gridImage.Canvas.MoveTo(x*74+2,y*74+37); gridImage.Canvas.LineTo(x*74+10,y*74+37); end;
          x:=x+1;
          if x=7 then begin x:=0; y:=y+1; end;
        end;
       tempImage.Free;
       imageState:=2;
      end;
    3: begin BExclude.Visible:=false; BReject.Visible:=false; BTag.Visible:=false; SZoom.Visible:=true; if imageState<>3 then MakeLargeClick(Sender); end;
  end;
  DisplayImage;
end;

procedure TFormMain.SZoomChange(Sender: TObject);
begin

  DisplayImage;
end;

procedure TFormMain.NavigatorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

var w: Double;

begin
  if (FormMain.NavMode.ItemIndex=0) or (FormMain.NavMode.ItemIndex=2) then Exit;
  w:=162/((max(Length(grid),Length(grid[0])-1)*FormMain.SZoom.Position/100+1));
  zx:=max(0,Floor(x-w/2));
  zy:=max(0,Floor(y-w/2));
  DisplayImage;
end;

procedure TFormMain.Exit1Click(Sender: TObject);
begin
  if postingstring<>'' then PostToGroup.Click;
  FormMain.Close;
end;

function AddConnector(x,y,t: Integer): Boolean;
var  k,nt: Integer;
     ntype: String;
     chooselist: TChooselist;

begin
  if grid[x,y].typ=-1 then
    ntype:=IntToStr(t)
  else
    ntype:=typestring[grid[x,y].typ]+IntToStr(t);
  nt:=-1;
  for k:=0 to 15 do
   if (Pos('1',ntype)>0)=(Pos('1',typestring[k])>0) then
    if (Pos('2',ntype)>0)=(Pos('2',typestring[k])>0) then
     if (Pos('3',ntype)>0)=(Pos('3',typestring[k])>0) then
      if (Pos('4',ntype)>0)=(Pos('4',typestring[k])>0) then
       nt:=k;

  SetLength(chooselist,0);
  for k:=0 to High(Images) do
   if (typecheck(k,nt) and TileIsUsable(k)) then
     begin
      SetLength(chooselist,Length(chooselist)+1);
      chooselist[High(chooselist)]:=k;
     end;

  CleanList(chooselist,x,y);
  Result:=false;
  if Length(chooselist)>0 then
   begin
    if grid[x,y].index>-1 then used[grid[x,y].index]:=false;
    grid[x,y].index:=chooselist[Random(Length(chooselist))];
    used[grid[x,y].index]:=true;
    grid[x,y].id:=Images[grid[x,y].index].id;
    grid[x,y].typ:=nt;
    Result:=true;
   end;
end;

procedure TFormMain.ImageDisplayMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var t,i,j: Integer;
    IList: TStringList;
    zx0,zy0: Integer;
    zoom,sc: Double;
    redraw, flag: Boolean;

begin
  redraw:=false;
  IList:=TStringList.Create;
  if NavMode.ItemIndex=2 then
   begin
    t:=7*(Floor(7*y/ImageDisplay.ClientHeight))+Floor(7*x/ImageDisplay.ClientWidth)+49*pageselect;
    if t>displayList.Count-1 then Exit;
    currentImageIndex:=StrToInt(displayList[t]);
    DisplayImage;
   end;
  if (NavMode.ItemIndex=3) or (NavMode.ItemIndex=1) then
   begin
    t:=-1;
    for i:=0 to 21 do
      if speedbuttons[i].Down then t:=i;
    if speedbuttons[24].Down then t:=24;

    // find grid coordinates
    zoom:=(max(Length(grid),Length(grid[0]))-1)*FormMain.SZoom.Position/100+1;
    zx:=min(zx,162-Floor(162/zoom));
    zy:=min(zy,162-Floor(162/zoom));
    sc:=gridImage.Width/gridImage.Height;
    zx0:=Floor(zx/162*FormMain.ImageDisplay.Width*zoom);
    zy0:=Floor(zy/162*FormMain.ImageDisplay.Height*zoom);

    if sc<1 then
     begin
      x:=Floor((Length(grid))*(x+zx0)/(ImageDisplay.Width*zoom*sc));
      y:=Floor((Length(grid[0]))*(y+zy0)/ImageDisplay.Height*zoom);
     end
    else
     begin
      x:=Floor((Length(grid))*(x+zx0)/(ImageDisplay.Width*zoom));
      y:=Floor((Length(grid[0]))*(y+zy0)/(ImageDisplay.Height*zoom)*sc);
     end;

    if (x>High(grid)) or (y>High(grid[0])) then Exit;
    
    if Button=mbRight then
     // delete the current tile
     begin
       // if there is none, ignore the click
       if grid[x,y].typ=-1 then Exit;
       // reset used state
       if grid[x,y].index<>-1 then
         used[grid[x,y].index]:=false;
       grid[x,y].index:=-1;
       grid[x,y].typ:=-1;
       UpdateButtonState;
       DrawTile(x,y,75,'.sq.jpg',75,75,false);

       // now check if a full row or column is empty
       flag:=false;
       for i:=1 to High(grid)-1 do
         if (grid[i,1].index<>-1) or (grid[i,1].typ<>-1) then flag:=true;
       if not flag then
        begin
         // row 2 is empty. collapse.
         gridImage.Canvas.Draw(0,-74,gridImage);
         gridImage.Height:=gridImage.Height-74;
         for i:=0 to High(grid) do
          begin
           for j:=0 to High(grid[i])-1 do
             grid[i,j]:=grid[i,j+1];
           SetLength(grid[i],Length(grid[i])-1);
          end;
         AssignColorTarget;
        end;

       flag:=false;
       for i:=1 to High(grid)-1 do
         if (grid[i,High(grid[i])-1].index<>-1) or (grid[i,High(grid[i])-1].typ<>-1) then flag:=true;
       if not flag then
        begin
         // last row is empty. collapse.
         gridImage.Height:=gridImage.Height-74;
         for i:=0 to High(grid) do
           SetLength(grid[i],Length(grid[i])-1);
         AssignColorTarget;
        end;

       flag:=false;
       for j:=1 to High(grid[0])-1 do
         if (grid[1,j].index<>-1) or (grid[1,j].typ<>-1) then flag:=true;
       if not flag then
        begin
         // column 2 is empty. collapse.
         gridImage.Canvas.Draw(-74,0,gridImage);
         gridImage.Width:=gridImage.Width-74;
         for j:=0 to High(grid[0]) do
           for i:=0 to High(grid)-1 do
             grid[i,j]:=grid[i+1,j];
         SetLength(grid,Length(grid)-1);
         AssignColorTarget;
        end;

       flag:=false;
       for j:=1 to High(grid[0]) do
         if (grid[High(grid)-1,j].index<>-1) or (grid[High(grid)-1,j].typ<>-1) then flag:=true;
       if not flag then
        begin
         // last column is empty. collapse.
         gridImage.Width:=gridImage.Width-74;
         SetLength(grid,Length(grid)-1);
         AssignColorTarget;
        end;

       CheckBGArea;
       DisplayImage;
       IList.Free;
       Exit;
     end;

    // no mode selected
    if t=-1 then
     begin
      if grid[x,y].index=-1 then Exit;
      currentImageIndex:=grid[x,y].index;
      currentImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'images/'+Images[currentImageIndex].id+'.sm.jpg');
      FormMain.Navigator.Canvas.StretchDraw(Rect(0,0,162,162),currentImage);
      Exit;
     end;

    // make this a background tile
    if t=24 then
      begin
        grid[x,y].typ:=-2;
        CheckBGArea;
        DrawTile(x,y,75,'.sq.jpg',75,75,false);
        DisplayImage;
        Exit;
      end;

    // swap mode
    if t=19 then
     if (swapx=-1) or (swapx>High(grid)) or (swapy>High(grid[0])) then
      begin
       swapx:=x; swapy:=y; Exit;
      end
     else
      begin
       t:=grid[x,y].index;
       grid[x,y].index:=grid[swapx,swapy].index;
       grid[swapx,swapy].index:=t;
       t:=grid[x,y].typ;
       grid[x,y].typ:=grid[swapx,swapy].typ;
       grid[swapx,swapy].typ:=t;
       DrawTile(swapx,swapy,75,'.sq.jpg',75,75,false);
       DrawTile(x,y,75,'.sq.jpg',75,75,false);
       swapx:=-1;
       DisplayImage;
       IList.Free;
       Exit;
      end;

    // repaint mode
    if t=20 then
      if grid[x,y].index=-1 then Exit else t:=grid[x,y].typ;

    // draw mode
    if t=21 then
      if drawx=-1 then
       begin
        // remember the last location
        drawx:=x; drawy:=y; Exit;
       end
      else
       begin
        // now we need to add connectors to this and the last
        // tile to connect them up
        // determine the connector needed for the previous tile
        t:=-1;
        if (drawx=x) and (drawy=y-1) then t:=3;
        if (drawx=x-1) and (drawy=y) then t:=2;
        if (drawx=x) and (drawy=y+1) then t:=1;
        if (drawx=x+1) and (drawy=y) then t:=4;
        // if we don't have two neighbors, starts fresh with
        // the current
        if t=-1 then
         begin
          drawx:=x; drawy:=y; Exit;
         end;
        // insert the new connector
        AddConnector(drawx,drawy,t);
        DrawTile(drawx,drawy,75,'.sq.jpg',75,75,false);

        // which connector do we want to add to the other tile?
        t:=t+2; if t>4 then t:=t-4;

        //add it
        AddConnector(x,y,t);
        DrawTile(x,y,75,'.sq.jpg',75,75,false);

        DisplayImage;
        drawx:=x; drawy:=y;
       end
    else // t<>21
      begin
        // find the replacement tile
        // pick either one of the selected type
        // or, if type 18 is selected, pick any
        // of types 15,16,17
        for i:=0 to High(Images) do
         if ( typecheck(i,t) and (t<>18))
          or ( (t=18) and (Images[i].typ>14) and (Images[i].typ<18))
           and TileIsUsable(i) then
            IList.Add(IntToStr(i));

        // is the target nonempty?
        if grid[x,y].index<>-1 then
          // if the new type is compatible with the old
          // assume we just want to turn the tile
          if typecheck(grid[x,y].index,t) and (grid[x,y].typ<>t)  then
            begin
             grid[x,y].typ:=t;
             DrawTile(x,y,75,'.sq.jpg',75,75,false);
             IList.Free;
             UpdateButtonState;
             DisplayImage;
             Exit;
            end;

        // select the next one in the list, if the current
        // one is also in the list, select one at random, if not
        // but first, store the type
        grid[x,y].typ:=t;

        i:=IList.IndexOf(IntToStr(grid[x,y].index));
        if i=-1 then
          t:=StrToInt(IList[Random(IList.Count)])
        else if i=IList.Count-1 then
          t:=StrToInt(IList[0])
        else t:=StrToInt(IList[i+1]);
        // now place the new tile

        if grid[x,y].index>-1 then used[grid[x,y].index]:=false;
        grid[x,y].index:=t;
        grid[x,y].id:=Images[t].id;
        DrawTile(x,y,75,'.sq.jpg',75,75,false);
        used[t]:=true;
      end;

    if x=High(grid) then
     begin
      redraw:=true;
      SetLength(grid,Length(grid)+1);
      SetLength(grid[High(grid)],Length(grid[0]));
      for i:=0 to High(grid[0]) do
       begin
        grid[x+1,i].index:=-1;
        grid[x+1,i].typ:=-1;
       end;
     end;

    if y=High(grid[0]) then
     begin
      redraw:=true;
      for i:=0 to High(grid) do
       begin
        SetLength(grid[i],Length(grid[i])+1);
        grid[i,y+1].index:=-1;
        grid[i,y+1].typ:=-1;
       end;
     end;

    if x=0 then
     begin
      redraw:=true;
      SetLength(grid,Length(grid)+1);
      SetLength(grid[High(grid)],Length(grid[0]));
      for i:=High(grid) downto 1 do
       for j:=0 to High(grid[0]) do
         grid[i,j]:=grid[i-1,j];
      for i:=0 to high(grid[0]) do
       begin
        grid[0,i].index:=-1;
        grid[0,i].typ:=-1;
       end;
     end;

    if y=0 then
     begin
      redraw:=true;
      for i:=0 to High(grid) do
       begin
        SetLength(grid[i],Length(grid[i])+1);
        for j:=High(grid[i]) downto 1 do
          grid[i,j]:=grid[i,j-1];
        grid[i,0].index:=-1;
        grid[i,0].typ:=-1;
       end;
     end;

    IList.Free;
    UpdateButtonState;
    CheckBGArea;
    if redraw then MakeLargeClick(Sender);
    DisplayImage;
   end;
end;

procedure TFormMain.SaveDesignClick(Sender: TObject);
var tempFile: TStringList;
    i,j, oldstate: Integer;
    jpg: TJPEGImage;

begin
  SaveDialog.InitialDir := ExtractFilePath(Application.ExeName)+'designs';
  SaveDialog.FileName:=Copy(ExtractFileName(SaveDialog.FileName),1,Pos('.',ExtractFileName(SaveDialog.FileName))-1);
  if Sender=SaveDesign then
   begin
    SaveDialog.DefaultExt:='mos';
    SaveDialog.Filter:='Long line mosaic|*.mos';
   end
  else
   begin
    SaveDialog.Filter:='Long line pattern|*.pat';
    SaveDialog.DefaultExt:='pat';
   end;
  if not SaveDialog.Execute then Exit;
  tempFile:=TStringList.Create;
  if Sender=SaveDesign then
    tempFile.Add('mosaic2')
  else
    tempFile.Add('pattern');
  tempFile.Add(IntToStr(Length(grid)));
  tempFile.Add(IntToStr(Length(grid[0])));
  for i:=0 to High(grid) do
    for j:=0 to High(grid[0]) do
     begin
      if Sender=SaveDesign then
       if grid[i,j].index=-1 then
        tempFile.Add('')
       else
        tempFile.Add(Images[grid[i,j].index].id);
      tempFile.Add(IntToStr(grid[i,j].typ));
     end;

  imagestate:=3;
  oldstate:=NavMode.ItemIndex;
  NavMode.ItemIndex:=3;
  gridImage.Width:=20*(Length(grid)-2);
  gridImage.Height:=20*(Length(grid[0])-2);
  gridImage.Canvas.Pen.Color:=clWhite;
  gridImage.Canvas.Brush.Color:=clWhite;
  gridImage.Canvas.Rectangle(0,0,gridImage.Width,gridImage.Height);
  for i:=1 to high(grid)-1 do
   for j:=1 to high(grid[0])-1 do
    DrawTile(i,j,20,'.sq.jpg',0,0,false);
  jpg:=TJPEGImage.Create;
  jpg.Assign(gridImage);
  jpg.CompressionQuality:=90;
  jpg.SaveToFile(SaveDialog.FileName+'.jpg');
  jpg.Free;
  tempFile.SaveToFile(SaveDialog.FileName);
  tempFile.Free;
  NavMode.ItemIndex:=oldstate;
end;

procedure TFormMain.LoadDesign1Click(Sender: TObject);
var tempFile: TStringList;
    i,j,k,n: Integer;
    chooselist: TChooselist;

begin
  OpenDialog.InitialDir := ExtractFilePath(Application.ExeName)+'designs';
  OpenDialog.FileName:='';
  OpenDialog.Filter:='Long Line layout files|*.mos;*.pat';
  if not OpenDialog.Execute then Exit;
  tempFile:=TStringList.Create;
  tempFile.LoadFromFile(OpenDialog.FileName);
  if tempFile.Count=0 then Exit;
  if not ( (tempFile[0]='mosaic') or (tempFile[0]='pattern') or (tempFile[0]='mosaic2')) then Exit;
  SetLength(grid,StrToInt(tempFile[1]));
  for i:=0 to High(grid) do
   SetLength(grid[i],StrToInt(tempFile[2]));
  AssignColorTarget;
  if tempFile[0]='pattern' then
   for i:=0 to High(Images) do
    used[i]:=false;

  n:=3;
  for i:=0 to High(grid) do
    for j:=0 to High(grid[0]) do
     if tempFile[0]='mosaic' then
      begin
       grid[i,j].id:=tempFile[n];
       grid[i,j].index:=-1;
       grid[i,j].typ:=-1;
       for k:=0 to High(Images) do
        if Images[k].id=grid[i,j].id then grid[i,j].index:=k;
       if grid[i,j].index<>-1 then grid[i,j].typ:=Images[grid[i,j].index].typ;
       n:=n+1;
      end
     else if tempfile[0]='pattern' then
      begin
       grid[i,j].typ:=-1;
       grid[i,j].index:=-1;
       grid[i,j].typ:=StrToInt(tempfile[n]);

       if (tempFile[n]<>'') and (FormOptions.FillPattern.Checked) then
        begin
         SetLength(chooseList,0);
         for k:=0 to High(Images) do
          if typecheck(k,StrToInt(tempFile[n])) and TileIsUsable(k) then
           begin
            SetLength(chooselist,Length(chooselist)+1);
            chooselist[High(chooselist)]:=k;
           end;
         if Length(chooselist)>0 then
          begin
           CleanList(chooselist,i,j);
           grid[i,j].index:=chooseList[Random(Length(chooseList))];
           used[grid[i,j].index]:=true;
          end;
        end;
       n:=n+1;
      end
     else if tempfile[0]='mosaic2' then
      begin
       grid[i,j].id:=tempFile[n];
       grid[i,j].typ:=StrToInt(tempFile[n+1]);
       grid[i,j].index:=-1;
       for k:=0 to High(Images) do
        if Images[k].id=grid[i,j].id then grid[i,j].index:=k;
       n:=n+2;
      end;

   NavMode.ItemIndex:=3;
   imageState:=1;
   tempFile.Free;
   NavModeChange(Sender);
end;

procedure TFormMain.LoadMetaClick(Sender: TObject);
var i,s,e: Integer;
    val, p, rq, tag: string;
    fs: TFileStream;


begin
 FormProgress.Caption:='Updating metadata';
 FormProgress.ProgressMemo.Clear;
 FormProgress.ProgOK.Enabled:=false;
 FormProgress.Show;
 for i:=0 to High(Images) do
  if (i=currentImageIndex) or (Sender=LoadMeta) then 
   begin
    Application.ProcessMessages;
    FormProgress.ProgressBar.Position:=Floor(i/High(Images)*100);
    val:='&email='+FormOptions.User.Text+'&password='+FormOptions.Pass.Text;
    val:=val+'&api_key='+FormOptions.Apikey.Text;
    rq:='http://www.flickr.com/services/rest/?method=flickr.photos.getSizes&photo_id='+Images[i].id+val;
    p:=Brause.Get(rq);
    // download the images if necessary
    if not FileExists(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.sq.jpg') or
      not FileExists(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.sm.jpg') or
      not FileExists(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.lg.jpg') then
        FormProgress.ProgressMemo.Lines.Add('downloading file(s) for '+Images[i].title);
    if not FileExists(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.sq.jpg') then
     begin
      fs:=TFileStream.Create(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.sq.jpg',fmCreate);
      Brause.Get(GetValue(Copy(p,Pos('Square',p),200),'source'),fs);
      fs.Free;
     end;
    if not FileExists(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.sm.jpg') then
     begin
      fs:=TFileStream.Create(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.sm.jpg',fmCreate);
      Brause.Get(GetValue(Copy(p,Pos('Small',p),200),'source'),fs);
      fs.Free;
     end;
    if not FileExists(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.lg.jpg') then
     begin
      fs:=TFileStream.Create(ExtractFilePath(Application.ExeName)+'images/'+Images[i].id+'.lg.jpg',fmCreate);
      Brause.Get(GetValue(Copy(p,Pos('Medium',p),200),'source'),fs);
      fs.Free;
     end;
    AverageColor(i);
    rq:='http://www.flickr.com/services/rest/?method=flickr.photos.getInfo&photo_id='+Images[i].id+val;
    p:=Brause.Get(rq);
    Images[i].owner:=GetValue(p,'username');
    Images[i].license:=StrToInt(GetValue(p,'license'));
    // now find a tag that starts with ll
    // select the tags section
    p:=Copy(p,Pos('<tags>',p),Length(p));
    // now go through it tag by tag
    Images[i].typ:=16;
    while Pos('>'+tagprefix,p)>0 do
     begin
      s:=Pos('>'+tagprefix,p);
      e:=Pos('</tag>',Copy(p,s,Length(p)));
      tag:=Copy(p,s+1,e-2);
      if Images[i].typ=16 then
      Images[i].typ:=FindType(Copy(tag,3,Length(tag)));
      p:=Copy(p,s+e+2,Length(p));
     end;
    if Images[i].typ=16 then
    MainMemo.Lines.Add('WARNING. '+Images[i].title+' has no tag.');
   end;
 FormProgress.ProgOK.Enabled:=true;
 FormProgress.Hide;
 UpdateButtonState;
 imageState:=-1;
 FormMain.NavMode.ItemIndex:=2;
 FormMain.NavModeChange(NavMode);
end;

procedure TFormMain.BRejectClick(Sender: TObject);
begin
  FormMain.Enabled:=false;
  FormReject.Tag:=currentImageIndex;
  FormReject.Show;
end;

procedure TFormMain.BExcludeClick(Sender: TObject);
begin
  Images[currentImageIndex].excluded:=not Images[currentImageIndex].excluded;
  if NavMode.ItemIndex=2 then NavModeChange(NavMode);
  DisplayImage;
end;

procedure TFormMain.PostToGroupClick(Sender: TObject);
var  Clip: TClipboard;

begin
  Clip:=TClipboard.Create;
  Clip.AsText:=postingstring;
  if fileprefix='patches' then
    ShellExecute(self.WindowHandle,'open',PChar('http://www.flickr.com/groups/patches/discuss/15922/'),nil,nil, SW_SHOWNORMAL)
  else
    ShellExecute(self.WindowHandle,'open',PChar('http://www.flickr.com/groups/longline/discuss/15009/'),nil,nil, SW_SHOWNORMAL);
  if MessageDlg('Click OK when done posting',mtWarning,[mbOK, mbCancel],0) = mrOK then
   begin
    postingstring:='';
    PostToGroup.Enabled:=false;
    PostToGroup.Visible:=false;
   end;
  Clip.Free;
end;

procedure TFormMain.BTagClick(Sender: TObject);
var tag,rq,val: string;

begin
  // add a tag to a picture
  val:='&email='+FormOptions.User.Text+'&password='+FormOptions.Pass.Text;
  val:=val+'&api_key='+FormOptions.Apikey.Text;
  tag:=InputBox('Add tag','Tag:',tagprefix);
  if (tag='') or (tag=tagprefix) then Exit;
  rq:='http://www.flickr.com/services/rest/?method=flickr.photos.addTags&photo_id='+Images[currentImageIndex].id+val;
  rq:=rq+'&tags='+tag;
  rq:=Brause.Get(rq);
end;

procedure TFormMain.ClearBlacklist1Click(Sender: TObject);
begin
  if MessageDlg('This will erase your complete blacklist. Proceed?',mtWarning,[mbOK, mbCancel],0)=mrOK then
    SetLength(blacklist,0);
end;

procedure TFormMain.Repopulate1Click(Sender: TObject);
var i,j,rep,nrep,k: Integer;
    chooselist: TChooselist;
    neutral: TColor;

begin
  for i:=0 to High(Images) do used[i]:=false;
  nrep:=1;
  // if we're targeting the color, do it in two sweeps
  // first the ones with a set target, then the rest
  if not FormOptions.ApplyColor.Checked and (FormOptions.ColorTargetMode.ItemIndex>0) then nrep:=2;
  if FormOptions.ColorTargetNeutral.ItemIndex = 1 then neutral:=clWhite else neutral:=clBlack;
  for rep:=1 to nrep do
  for i:=0 to high(grid) do
   for j:=0 to High(grid[0]) do
    if (nrep=1) or
      ( (grid[i,j].target.Color =neutral) and (nrep=2) ) or
      ( (grid[i,j].target.Color<>neutral) and (nrep=1) ) then
    begin
     SetLength(chooselist,0);
     if grid[i,j].typ<>-1 then
      for k:=0 to High(Images) do
       if typecheck(k,grid[i,j].typ) and TileIsUsable(k) then
        begin
         SetLength(chooselist,Length(chooselist)+1);
         chooselist[High(chooselist)]:=k;
        end;
       CleanList(chooselist,i,j);
       if Length(chooseList)=0 then
         grid[i,j].index:=-1
       else
        begin
         grid[i,j].index:=chooseList[Random(Length(chooseList))];
         grid[i,j].id:=Images[grid[i,j].index].id;
         used[grid[i,j].index]:=true;
        end;
    end;
  imageState:=0;
  NavModeChange(NavMode);
end;

procedure TFormMain.SwitchClick(Sender: TObject);
var SaveFile: TStringList;

begin
  if postingstring<>'' then PostToGroup.Click;
  SaveFile:=TStringlist.Create;
  SaveFile.Add('mode file');
  if fileprefix='patches' then
   begin
    if FileExists(ExtractFilePath(Application.ExeName)+'dopatches') then
     DeleteFile(ExtractFilePath(Application.ExeName)+'dopatches');
    SaveFile.SaveToFile(ExtractFilePath(Application.ExeName)+'dolongline');
   end
  else
   begin
    if FileExists(ExtractFilePath(Application.ExeName)+'dolongline') then
     DeleteFile(ExtractFilePath(Application.ExeName)+'dolongline');
    SaveFile.SaveToFile(ExtractFilePath(Application.ExeName)+'dopatches');
   end;
  SaveFile.Clear;
  Cleanup;
  Init;
  Repopulate1Click(Repopulate1);
end;

procedure TFormMain.k(Sender: TObject);
begin
  if NavMode.ItemIndex=2 then
   begin
    imageState:=-1;
    NavModeChange(NavMode);
   end;
end;

procedure TFormMain.NavigatorDblClick(Sender: TObject);
begin
  if (NavMode.ItemIndex=1) or (NavMode.ItemIndex=3) then Exit;
  ShellExecute(self.WindowHandle,'open',PChar('http://www.flickr.com/photos/'+Images[currentImageIndex].userid+'/'+Images[currentImageIndex].id),nil,nil, SW_SHOWNORMAL);
end;


function typecheck(k, t: Integer): Boolean;

begin
  Result:=false;
  if FormOptions.AllowRotate.Checked then
   begin
    case Images[k].typ of
     0: Result:=(t=0);
     1..4: Result:=((t>0) and (t<5));
     6,9: Result:=(t=6) or (t=9);
     5,7,8,10: Result:=(t=5) or (t=7) or (t=8) or (t=10);
     11..14: Result:=((t>10) and (t<15));
     15: Result:=(t=15);
     16, 17: Result:=((t>15) and (t<18));
    end;
   end
  else
   if (Images[k].typ = t) then Result:=true;
end;

procedure TFormMain.ImageDisplayMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var zx0,zy0,xx,yy: Integer;
    zoom,sc: Double;

begin
  if not speedbuttons[21].Down then Exit;
  if not(ssLeft in Shift) then Exit;

  // find grid coordinates
  zoom:=(max(Length(grid),Length(grid[0]))-1)*FormMain.SZoom.Position/100+1;
  zx:=min(zx,162-Floor(162/zoom));
  zy:=min(zy,162-Floor(162/zoom));
  sc:=gridImage.Width/gridImage.Height;
  zx0:=Floor(zx/162*FormMain.ImageDisplay.Width*zoom);
  zy0:=Floor(zy/162*FormMain.ImageDisplay.Height*zoom);

  if sc<1 then
   begin
    xx:=Floor((Length(grid))*(x+zx0)/(ImageDisplay.Width*zoom*sc));
    yy:=Floor((Length(grid[0]))*(y+zy0)/ImageDisplay.Height*zoom);
   end
  else
   begin
    xx:=Floor((Length(grid))*(x+zx0)/(ImageDisplay.Width*zoom));
    yy:=Floor((Length(grid[0]))*(y+zy0)/(ImageDisplay.Height*zoom)*sc);
   end;
  if (xx<>drawx) or (yy<>drawy) then FormMain.ImageDisplayMouseDown(Sender,mbLeft,Shift,x,y);
end;

procedure TFormMain.SP22Click(Sender: TObject);
begin
  if SP22.Down and SP23.Down then
    SP23.Down:=false;
  if NavMode.ItemIndex=2 then
   begin
    imageState:=-1;
    NavModeChange(NavMode);
   end;
end;

procedure TFormMain.SP23Click(Sender: TObject);
begin
 if SP23.Down and SP22.Down then
   SP22.Down := false;
  if NavMode.ItemIndex=2 then
   begin
    imageState:=-1;
    NavModeChange(NavMode);
   end;
end;

procedure TFormMain.SaveImageClick(Sender: TObject);
begin
  SaveDialog.FileName:=Copy(ExtractFileName(SaveDialog.FileName),1,Pos('.',SaveDialog.FileName)-1);
  SaveDialog.InitialDir := ExtractFilePath(Application.ExeName)+'output';
  SaveDialog.Filter:='JPG|*.jpg';
  SaveDialog.DefaultExt:='jpg';
  if SaveDialog.Execute then
    begin
      FormMain.Enabled := false;
      FormSaveOptions.Show;
    end;
end;

procedure TFormMain.SaveImageDoIt;
var imsize,i,j,n,m,x,y,w,h,dx,dy: Integer;
    author,ext: string;
    authorlist: TStringList;
    authorcount: array of Integer;
    saveImage: TJPEGImage;
    tmpImage: TBitmap;
    ratio: Double;

begin
     FormProgress.Show;
     FormProgress.ProgOK.Enabled:=false;
     FormProgress.ProgressMemo.Clear;
     FormProgress.ProgressMemo.Lines.Add('Writing image file');
     imsize:=StrToInt(FormSaveOptions.SOTileSize.Text);
     if FormSaveOptions.SOSplitImage.Checked then
       begin
         m := StrToInt(FormSaveOptions.SOSplitX.Text);
         n := StrToInt(FormSaveOptions.SOSplitY.Text);
       end
     else
       begin
         m:=1; n:=1;
       end;
     ext:='.lg.jpg';
     if imsize<=200 then
       ext:='.sm.jpg';
     if imsize<=75 then
       ext:='.sq.jpg';
     gridImage.Width:=imsize*(Length(grid)-2);
     gridImage.Height:=imsize*(Length(grid[0])-2);
     // start with assuming no offset
     dx:=0; dy:=0;
     // now add a border, if requested
     if FormSaveOptions.SOAddBorder.Checked then
       begin
         // set the offset to half the border
         dx := round(gridImage.Width * StrToInt(FormSaveOptions.SOBorder.Text)/200);
         dy := round(gridImage.Height * StrToInt(FormSaveOptions.SOBorder.Text)/200);
         // add twice the offset to the image size
         gridImage.Width := gridImage.Width + 2 * dx;
         gridImage.Height := gridImage.Height + 2* dy;
       end;
     if FormSaveOptions.SOPadding.Checked then
       begin
         ratio := StrToInt(FormSaveOptions.SORatioX.Text)/StrToInt(FormSaveOptions.SORatioY.Text);
         if (gridImage.Width/gridImage.Height < ratio) then
           begin
             dx := dx + round((gridImage.Height * ratio - gridImage.Width) / 2);
             gridImage.Width := round(gridImage.Height * ratio);
           end
         else
           begin
             dy := dy + round( (gridImage.Width / ratio - gridImage.Height) /2);
             gridImage.Height := round(gridImage.Width / ratio);
           end;
       end;
     gridImage.Canvas.Pen.Color:=clWhite;
     gridImage.Canvas.Brush.Color:=clWhite;
     gridImage.Canvas.Rectangle(0,0,gridImage.Width,gridImage.Height);
     authorlist:=TStringList.Create;
     FormProgress.ProgressBar.Max:=100;
     for i:=1 to high(grid)-1 do
      for j:=1 to high(grid[0])-1 do
       begin
        FormProgress.ProgressBar.Position:=Floor(100*((i-1)*Length(grid[0])+j)/(Length(grid)*Length(grid[0])));
        Application.ProcessMessages;
        DrawTile(i,j,imsize,ext,dx,dy,true);
        if grid[i,j].index<>-1 then
         begin
          author:='<a href="http://www.flickr.com/photos/'+Images[grid[i,j].index].userid+'">'+Images[grid[i,j].index].owner+'</a>';
          if authorlist.IndexOf(author)=-1 then
           begin
            authorlist.Add(author);
            SetLength(authorcount,Length(authorcount)+1);
            authorcount[High(authorcount)]:=1;
           end
          else
           authorcount[authorlist.IndexOf(author)]:=authorcount[authorlist.IndexOf(author)]+1;
         end;
       end;
     for i:=0 to High(authorcount) do
       authorlist[i]:=authorlist[i]+' ('+IntToStr(authorcount[i])+')';
     authorlist.Insert(0,'<html><body>');
     if fileprefix='patches' then
       authorlist.Insert(1,'This mosaic was made from tiles in the <a href="http://www.flickr.com/groups/patches/">Patches</a> group pool.')
     else
       authorlist.Insert(1,'This mosaic was made from tiles in the <a href="http://www.flickr.com/groups/longline/">Long Line</a> group pool.');
     authorlist.Insert(2,'');
     authorlist.Insert(3,'<br>Tiles by:<br>');
     authorlist.Add('</body></html>');
     authorlist.SaveToFile(Copy(SaveDialog.FileName,1,Pos('.',SaveDialog.FileName)-1)+'.html');
     authorlist.Free;
     saveImage:=TJPEGImage.Create;
     if (m=1) and (n=1) then
      begin
       saveImage.Assign(gridImage);
       saveImage.CompressionQuality:=90;
       saveImage.SaveToFile(SaveDialog.FileName);
      end
     else
      begin
       tmpImage:=TBitmap.Create;
       for i:=1 to m do
        for j:=1 to n do
         begin
          x:=Floor(gridImage.Width/m*(i-1))+1;
          y:=Floor(gridImage.Height/n*(j-1))+1;
          w:=Floor(gridImage.Width/m*i)-x+1;
          h:=Floor(gridImage.Height/n*j)-y+1;
          tmpImage.Width:=w;
          tmpImage.Height:=h;
          tmpImage.Canvas.CopyRect(Bounds(0,0,w,h),gridImage.Canvas,Bounds(x,y,w,h));
          saveImage.Assign(tmpImage);
          saveImage.CompressionQuality:=90;
          saveImage.SaveToFile(Copy(SaveDialog.FileName,1,Pos('.',SaveDialog.FileName)-1)+IntToStr(i)+'x'+IntToStr(j)+'.jpg');
         end;
       tmpImage.Free;
      end;
     saveImage.Free;
     FormMain.Enabled:=true;
     FormProgress.Hide;
     imageState:=0;
     NavModeChange(NavMode);
end;

procedure TFormMain.OpenDesignerClick(Sender: TObject);
begin
  if FormOptions.ColorTarget.Picture.Bitmap.Height>0 then
    FormDesign.SizeRatio.Text:=FormatFloat('#0.000',FormOptions.ColorTarget.Picture.Bitmap.Width/FormOptions.ColorTarget.Picture.Bitmap.Height);
  FormMain.Enabled:=false;
  FormDesign.Show;
end;

procedure TFormMain.DrawSlow1Click(Sender: TObject);
begin
  FormOptions.UseDrawSettings.Checked:=true;
  imageState:=3;
  NavMode.ItemIndex:=1;
  NavModeChange(NavMode);
end;

procedure TFormMain.NavRightMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then
   case NavMode.ItemIndex of
    0: begin if currentImageIndex>-1 then currentImageIndex:=min(High(Images),currentImageIndex+1) end;
    2: begin pageselect:=min(Floor( High(Images)/49),pageselect+1); NavModeChange(NavMode); end;
    1,3: SZoom.Position:=min(100,SZoom.Position+10);
   end
  else
   case NavMode.ItemIndex of
    0: begin if currentImageIndex>-1 then currentImageIndex:=High(Images) end;
    2: begin pageselect:=Floor( High(Images)/49); NavModeChange(NavMode); end;
    1,3: SZoom.Position:=min(100,SZoom.Position+10);
   end;
  DisplayImage;
end;

procedure TFormMain.NavLeftMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IF Button = mbLeft then
   case NavMode.ItemIndex of
    0: begin if currentImageIndex>-1 then currentImageIndex:=max(0,currentImageIndex-1) end;
    2: begin pageselect:=max(0,pageselect-1);  NavModeChange(NavMode); end;
    1,3: SZoom.Position:=max(0,SZoom.Position-10);
   end
  else
   case NavMode.ItemIndex of
    0: begin if currentImageIndex>-1 then currentImageIndex:=0; end;
    2: begin pageselect:=0; NavModeChange(NavMode); end;
    1,3: SZoom.Position:=max(0,SZoom.Position-10);
   end;
  DisplayImage;
end;

procedure TFormMain.ShowTallyClick(Sender: TObject);
begin
  FormMain.Enabled:=false;
  FormTally.Show;
end;

end.

