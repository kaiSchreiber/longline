unit designer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, main, Math, Buttons;

type
  TPhraseCoor = record
    X: Integer;
    Y: Integer;
    O: Integer;
    Color: TColor;
  end;
  TFormDesign = class(TForm)
    PhraseList: TListBox;
    ButtonSplit: TButton;
    ButtonFuse: TButton;
    ButtonAddPhrase: TButton;
    ButtonAddLetters: TButton;
    DesignImage: TImage;
    ButtonTransfer: TButton;
    ButtonCancel: TButton;
    AddPhrase: TMemo;
    ButtonDelete: TButton;
    DesignFillBlanks: TCheckBox;
    FillCell: TCheckBox;
    ButtonTransCol: TButton;
    ColorDialog: TColorDialog;
    ColorFG: TShape;
    ColorBG: TShape;
    Label1: TLabel;
    LineSpacing: TEdit;
    SBCCW: TSpeedButton;
    SBCW: TSpeedButton;
    DesignAddBorder: TCheckBox;
    DesignOutside: TCheckBox;
    ButtonFormat: TButton;
    Label2: TLabel;
    SizeRatio: TEdit;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonTransferClick(Sender: TObject);
    procedure ButtonAddPhraseClick(Sender: TObject);
    procedure ButtonAddLettersClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonFuseClick(Sender: TObject);
    procedure ButtonSplitClick(Sender: TObject);
    procedure PhraseListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ColorFGMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonTransColClick(Sender: TObject);
    procedure FillCellClick(Sender: TObject);
    procedure SBCCWClick(Sender: TObject);
    procedure SBCWClick(Sender: TObject);
    procedure ButtonFormatClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDesign: TFormDesign;
  PhraseCoor: array of array of TPhraseCoor;
  WriteCursor: TPoint;

const
  PDX: array[0..3] of TPoint =
    (
      (X:  1; Y:  0),
      (X:  0; Y:  1),
      (X: -1; Y:  0),
      (X:  0; Y: -1)
    );
  PDY: array[0..3] of TPoint =
    (
      (X:  0; Y:  1),
      (X: -1; Y:  0),
      (X:  0; Y: -1),
      (X:  1; Y:  0)
    );

implementation

uses options;

{$R *.dfm}

function IsDrawableMacro(C: char): Integer; forward;

procedure ShiftToOrigin;
var minx,miny,maxy,i,j,char: Integer;
begin
  // check for the lowest coordinate in x and y and reset it to 1/1
  if (Length(PhraseCoor)=0) or (Length(PhraseCoor[0])=0) then
    begin
      WriteCursor.X:=1;
      WriteCursor.Y:=1;
      Exit;
    end;
  char:=IsDrawableMacro(FormDesign.PhraseList.Items[0][1]);
  minx:=PhraseCoor[0][0].X;
  miny:=PhraseCoor[0][0].Y+LineMacros[char,3];
  maxy:=0;
  for i:=0 to High(PhraseCoor) do
    for j:=0 to High(PhraseCoor[i]) do
      begin
        char:=IsDrawableMacro(FormDesign.PhraseList.Items[i][j+1]);
        minx:=min(PhraseCoor[i,j].X+PDY[PhraseCoor[i,j].O].X * LineMacros[char,3],minx);
        miny:=min(PhraseCoor[i,j].Y+PDY[PhraseCoor[i,j].O].Y * LineMacros[char,3],miny);
        maxy:=min(PhraseCoor[i,j].Y+PDY[PhraseCoor[i,j].O].Y * LineMacros[char,3],maxy);
        minx:=min(PhraseCoor[i,j].X +
           PDX[PhraseCoor[i,j].O].X * (LineMacros[char,1]-1) +
           PDY[PhraseCoor[i,j].O].X * (LineMacros[char,2]+LineMacros[char,3]-1),minx);
        miny:=min(PhraseCoor[i,j].Y +
           PDX[PhraseCoor[i,j].O].Y * (LineMacros[char,1]-1) +
           PDY[PhraseCoor[i,j].O].Y * (LineMacros[char,2]+LineMacros[char,3]-1),miny);
        maxy:=max(PhraseCoor[i,j].Y +
           PDX[PhraseCoor[i,j].O].Y * (LineMacros[char,1]-1) +
           PDY[PhraseCoor[i,j].O].Y * (LineMacros[char,2]+LineMacros[char,3]-1),maxy);
      end;
  for i:=0 to High(PhraseCoor) do
    for j:=0 to High(PhraseCoor[i]) do
      begin
        PhraseCoor[i,j].X := PhraseCoor[i,j].X - minx + 1;
        PhraseCoor[i,j].Y := PhraseCoor[i,j].Y - miny + 1;
      end;
  WriteCursor.X := WriteCursor.X - minx + 1;
  WriteCursor.Y := maxy - miny + 2;
end;

procedure DrawPhrases;
var i,j,k,o,x,y,ix,iy,char,dx,dy,dmax: Integer;
    sc: Double;
    ts: string;

begin
  dx:=0; dy:=0;
  for i:=0 to High(PhraseCoor) do
    for j:=0 to High(PhraseCoor[i]) do
      begin
        char:=IsDrawableMacro(FormDesign.PhraseList.Items[i][j+1]);
        ix := LineMacros[char,1]-1;
        iy := LineMacros[char,2]+LineMacros[char,3]-1;
        k  := PhraseCoor[i,j].O;
        dx:=max(dx,PhraseCoor[i][j].X + PDY[k].X * (LineMacros[char,3]));
        dy:=max(dy,PhraseCoor[i][j].Y + PDY[k].Y * (LineMacros[char,3]));
        dx:=max(dx,PhraseCoor[i][j].X + PDX[k].X * ix + PDY[k].X * iy );
        dy:=max(dy,PhraseCoor[i][j].Y + PDX[k].Y * ix + PDY[k].Y * iy );
      end;
  if dy>0 then FormDesign.Caption:='Design Mosaic: ' + IntToStr(dx) + ':' + IntToStr(dy) + ' (' + FormatFloat('00.00',dx/dy) + ')';
  dmax:=max(dx,dy);
  // now dmax is the largest x or y coordinate of a used tile
  with FormDesign.DesignImage.Canvas do
    begin
      // white background
      Brush.Color:=FormDesign.ColorBG.Brush.Color;
      Pen.Color:=clWhite;
      if dmax=0 then
        begin
          FormDesign.DesignImage.Height:=417;
          FormDesign.DesignImage.Width :=417;
          FillRect(Rect(0,0,FormDesign.DesignImage.Width,FormDesign.DesignImage.Height));
          Exit;
        end;
      sc := 417/dmax;
      FormDesign.DesignImage.Height:=round(sc*dy);
      FormDesign.DesignImage.Width :=round(sc*dx);
      FillRect(Rect(0,0,FormDesign.DesignImage.Width,FormDesign.DesignImage.Height));
      Pen.Color:= FormDesign.ColorFG.Brush.Color;
      Pen.Width:=round(sc/3);
      for i:=0 to High(PhraseCoor) do
        for j:=0 to High(PhraseCoor[i]) do
          begin
            Pen.Color := PhraseCoor[i,j].Color;
            char:=IsDrawableMacro(FormDesign.PhraseList.Items[i][j+1]);
            if FormDesign.FillCell.Checked then
              begin
               Brush.Color:=PhraseCoor[i,j].Color;
               x:=PhraseCoor[i,j].X-1; y:=PhraseCoor[i,j].Y-1+LineMacros[char,3];
               FillRect(Rect(round(x*sc),round(y*sc),round((x+LineMacros[char,1])*sc),round((y+LineMacros[char,2])*sc)));
               Brush.Color:=FormDesign.ColorBG.Brush.Color;
              end
            else
            for iy:=1 to LineMacros[char,2] do
              for ix:=1 to LineMacros[char,1] do
                begin
                  o:=PhraseCoor[i,j].O;
                  x:=PhraseCoor[i,j].X + PDX[o].X * (ix - 1) + PDY[o].X * (LineMacros[char,3] + iy - 1);
                  y:=PhraseCoor[i,j].Y + PDX[o].Y * (ix - 1) + PDY[o].Y * (LineMacros[char,3] + iy - 1);;
                  // now get the typestring for the tile, rotate them and draw the lines
                  ts := typestring[LineMacros[char,3+ix+(iy-1)*LineMacros[char,1]]];
                  for k:=1 to Length(ts) do
                    if StrToInt(ts[k])+o>4 then
                      ts[k]:=chr(44 + StrToInt(ts[k])+o)
                    else
                      ts[k]:=chr(48 + StrToInt(ts[k])+o);

                  MoveTo( round( (x-0.5) * sc),round( (y-0.5) * sc) );
                  if Pos('1',ts)>0 then
                    LineTo( round( (x-0.5) * sc), round( (y-1)*sc));

                  MoveTo( round( (x-0.5) * sc),round( (y-0.5) * sc) );
                  if Pos('2',ts)>0 then
                    LineTo( round( x * sc), round( (y-0.5)*sc));

                  MoveTo( round( (x-0.5) * sc),round( (y-0.5) * sc) );
                  if Pos('3',ts)>0 then
                    LineTo( round( (x-0.5) * sc), round(y*sc));

                  MoveTo( round( (x-0.5) * sc),round( (y-0.5) * sc) );
                  if Pos('4',ts)>0 then
                    LineTo( round( (x-1) * sc), round( (y-0.5)*sc));
                end;
          end;
      Brush.Color := clRed;
      //FillRect( Rect( round( WriteCursor.X * sc )-3, round((WriteCursor.Y+5) * sc)-3,
      //   round( WriteCursor.X * sc )+3, round( (WriteCursor.Y+5) * sc)+3));
    end;
end;

procedure TFormDesign.ButtonCancelClick(Sender: TObject);
begin
  FormMain.Enabled:=true;
  FormDesign.Hide;
end;

procedure TFormDesign.ButtonTransferClick(Sender: TObject);
var char,i,j,k,o,ix,iy,x,y,dx,dy,bx,by: Integer;
    ts: string;

begin
  dx:=0; dy:=0;
  for i:=0 to High(PhraseCoor) do
    for j:=0 to High(PhraseCoor[i]) do
      begin
        char:=IsDrawableMacro(FormDesign.PhraseList.Items[i][j+1]);
        ix := LineMacros[char,1]-1;
        iy := LineMacros[char,2]+LineMacros[char,3]-1;
        o  := PhraseCoor[i,j].O;
        dx:=max(dx,PhraseCoor[i][j].X + PDY[o].X * (LineMacros[char,3]));
        dy:=max(dy,PhraseCoor[i][j].Y + PDY[o].Y * (LineMacros[char,3]));
        dx:=max(dx,PhraseCoor[i][j].X + PDX[o].X * ix + PDY[o].X * iy );
        dy:=max(dy,PhraseCoor[i][j].Y + PDX[o].Y * ix + PDY[o].Y * iy );
      end;
  // now we know the gridsize. make the thing.
  SetLength(used,Length(Images));
  for i:=0 to High(used) do used[i]:=false;
  if DesignAddBorder.Checked and DesignOutside.Checked then
    begin bx:=1; by:=1; end
  else
    begin bx:=0; by:=0; end;
  SetLength(grid,dx+2+2*bx);
  for i:=0 to High(grid) do
    SetLength(grid[i],dy+2+2*by);
  AssignColorTarget;
  for i:=0 to High(grid) do
    for j:=0 to High(grid[0]) do
      begin
       grid[i,j].index:=-1;
       grid[i,j].typ:=-1;
      end;
  for i:=0 to High(PhraseCoor) do
    for j:=0 to High(PhraseCoor[i]) do
      begin
        char:=IsDrawableMacro(FormDesign.PhraseList.Items[i][j+1]);
        for x:=1 to LineMacros[char,1] do
          for y:=1 to LineMacros[char,2] do
            begin
              ts:=typestring[LineMacros[ char,3+x+(y-1)*LineMacros[char,1] ]];
              o:=PhraseCoor[i,j].O;
              for k:=1 to Length(ts) do
                if StrToInt(ts[k])+o>4 then
                  ts[k]:=chr(44 + StrToInt(ts[k])+o)
                else
                  ts[k]:=chr(48 + StrToInt(ts[k])+o);
              ix:=x-1;
              iy:=y-1 + LineMacros[char,3];
              AddConnector(
                bx + PhraseCoor[i,j].X + PDX[o].X * ix + PDY[o].X * iy,
                by + PhraseCoor[i,j].Y + PDX[o].Y * ix + PDY[o].Y * iy,
                StrToInt('0'+ts)
                );
            end;
      end;
  if DesignAddBorder.Checked then
    begin
      for x:=2 to high(grid)-2 do
        begin
         if grid[x,1].index=-1 then AddConnector(x,1,24);
         if grid[x,high(grid[0])-1].index=-1 then AddConnector(x,high(grid[0])-1,24);
        end;
      for y:=2 to high(grid[0])-2 do
        begin
         if grid[1,y].index=-1 then AddConnector(1,y,13);
         if grid[high(grid)-1,y].index=-1 then AddConnector(high(grid)-1,y,13);
        end;
      if grid[1,1].index=-1 then AddConnector(1,1,23);
      if grid[high(grid)-1,1].index=-1 then AddConnector(high(grid)-1,1,34);
      if grid[1,high(grid[0])-1].index=-1 then AddConnector(1,high(grid[0])-1,12);
      if grid[high(grid)-1,high(grid[0])-1].index=-1 then AddConnector(high(grid)-1,high(grid[0])-1,14);
    end;
  if DesignFillBlanks.Checked then
    for i:=1+bx to High(grid)-1-bx do
      for j:=1+by to High(grid[i])-1-by do
        if grid[i,j].typ = -1 then
           AddConnector(i,j,0);
  //FormMain.Repopulate1Click(FormMain.Repopulate1);
  FormDesign.Hide;
  FormMain.MakeLargeClick(FormMain.MakeImage);
  FormMain.MakeLarge.Enabled:=true;
  FormMain.Enabled:=true;
end;

function IsDrawableMacro(C: char): Integer;
var i: Integer;
begin
  Result:=-1;
  for i:=0 to High(LineMacros) do
    if LineMacros[i,0]=ord(C) then Result:=i;
end;

procedure TFormDesign.ButtonAddPhraseClick(Sender: TObject);
var i,j: Integer;
    adding: string;
begin
  for i:=0 to AddPhrase.Lines.Count-1 do
   begin
     // check for each character whether it's drawable
     adding := '';
     for j:=1 to length(AddPhrase.Lines[i]) do
       if IsDrawableMacro(AddPhrase.Lines[i][j])>-1 then
         adding := concat(adding,AddPhrase.Lines[i][j]);
     // now adding has all the addable characters. add them at
     // their correct positions
     if length(adding)>0 then
       begin
         SetLength(PhraseCoor,Length(PhraseCoor)+1);
         SetLength(PhraseCoor[High(PhraseCoor)],Length(adding));
         for j:=1 to length(adding) do
           begin
             PhraseCoor[High(PhraseCoor),j-1].X := WriteCursor.X;
             PhraseCoor[High(PhraseCoor),j-1].Y := WriteCursor.Y;
             PhraseCoor[High(PhraseCoor),j-1].O := 0;
             PhraseCoor[High(PhraseCoor),j-1].Color := ColorFG.Brush.Color;
             WriteCursor.X := WriteCursor.X + LineMacros[ IsDrawableMacro(adding[j]),1];
           end;
         WriteCursor.X := 1;
         WriteCursor.Y := WriteCursor.Y + StrToInt(LineSpacing.Text);
         PhraseList.Items.Add(adding);
       end;
   end;
  AddPhrase.Lines.Clear;
  DrawPhrases;
end;

procedure TFormDesign.ButtonAddLettersClick(Sender: TObject);
var oldn,i: Integer;
begin
  // we do this by adding the phrases
  // selecting them
  // and then calling the split
  oldn:=PhraseList.Count;
  FormDesign.ButtonAddPhraseClick(Sender);
  for i:=oldn to PhraseList.Count-1 do
    PhraseList.Selected[i]:=true;
  FormDesign.ButtonSplitClick(Sender);
  DrawPhrases;
end;

procedure TFormDesign.FormCreate(Sender: TObject);
begin
  WriteCursor.X:=1;
  WriteCursor.Y:=1;
end;

procedure TFormDesign.ButtonFuseClick(Sender: TObject);
var i,j,target,base: Integer;
begin
  // collect all the selected phrases together and append to first selected phrase
  target:=-1;
  for i:=0 to PhraseList.Count-1 do
    if (PhraseList.Selected[i]) and (target=-1) then target:=i;
  if target=-1 then Exit;
  for i:=target+1 to PhraseList.Count-1 do
    // now we have the first selected item. append the others
    if PhraseList.Selected[i] then
      begin
        base:=Length(PhraseCoor[target])-1;
        SetLength(PhraseCoor[target],base+Length(PhraseCoor[i])+1);
        for j:=0 to Length(PhraseCoor[i])-1 do
          PhraseCoor[target,base+1+j]:=PhraseCoor[i,j];
        PhraseList.Items[target]:=concat(PhraseList.Items[target],PhraseList.Items[i]);
      end;
  // if the delete button called us, we remove the target, as well
  if Sender = ButtonDelete then
    begin
      i:=target;
      PhraseList.Selected[i]:=true;
    end
  else
    i:=target+1;
  while i<PhraseList.Count do
    if PhraseList.Selected[i] then
       begin
         PhraseList.Items.Delete(i);
         for j:=i to High(PhraseCoor)-1 do
           PhraseCoor[j]:=PhraseCoor[j+1];
         SetLength(PhraseCoor,Length(PhraseCoor)-1);
       end
    else
      i:=i+1;
  ShiftToOrigin;
  DrawPhrases;
end;

procedure TFormDesign.ButtonSplitClick(Sender: TObject);
var i,target: Integer;
begin
  target:=PhraseList.ItemIndex;
  if target=-1 then Exit;
  SetLength(PhraseCoor,Length(PhraseCoor)+Length(PhraseCoor[target])-1);
  // first, make room by shifting everything to the back
  for i:=High(PhraseCoor) downto target+Length(PhraseCoor[target]) do
      PhraseCoor[i]:=PhraseCoor[i-Length(PhraseCoor[target])+1];
  // now spread out the individual elements in the newly created cells
  for i:=1 to Length(PhraseCoor[target])-1 do
    begin
      SetLength(PhraseCoor[target+i],1);
      PhraseCoor[target+i,0]:=PhraseCoor[target,i];
      PhraseList.Items.Insert(target+i,PhraseList.Items[target][i+1]);
    end;
  // finally, truncate the target
  SetLength(PhraseCoor[target],1);
  PhraseList.Items[target]:=PhraseList.Items[target][1];
  DrawPhrases;
end;

procedure TFormDesign.PhraseListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var dx, dy, i, j: Integer;
begin
  dx:=0; dy:=0;
  if Key=VK_UP then begin dx:= 0; dy:=-1; end;
  if Key=VK_DOWN then begin dx:= 0; dy:= 1; end;
  if Key=VK_LEFT then begin dx:=-1; dy:= 0; end;
  if Key=VK_RIGHT then begin dx:= 1; dy:= 0; end;
  for i:=0 to High(PhraseCoor) do
    if FormDesign.PhraseList.Selected[i] then
      // move this item
      for j:=0 to High(PhraseCoor[i]) do
        begin
          PhraseCoor[i,j].X:=PhraseCoor[i,j].X+dx;
          PhraseCoor[i,j].Y:=PhraseCoor[i,j].Y+dy;
        end;
  Key:=0;
  ShiftToOrigin;
  DrawPhrases;
end;

procedure TFormDesign.FormShow(Sender: TObject);
begin
  DrawPhrases;  
end;

procedure TFormDesign.ColorFGMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var i,j: Integer;
begin
  if ColorDialog.Execute then
    (Sender As TShape).Brush.Color:=ColorDialog.Color;
  if Sender = FormDesign.ColorFG then
    for i:=0 to FormDesign.PhraseList.Count-1 do
      if PhraseList.Selected[i] then
        for j:=0 to High(PhraseCoor[i]) do
          PhraseCoor[i,j].Color := ColorDialog.Color;
  DrawPhrases;
end;

procedure TFormDesign.ButtonTransColClick(Sender: TObject);
begin
  DesignImage.Picture.Bitmap.Height:=DesignImage.Height;
  DesignImage.Picture.Bitmap.Width:=DesignImage.Width;
  FormMain.SaveDialog.DefaultExt:='bmp';
    FormMain.SaveDialog.Filter:='Color target file|*.bmp';
  FormMain.SaveDialog.InitialDir := ExtractFilePath(Application.ExeName)+'targets';
  if not FormMain.SaveDialog.Execute then Exit;
  DesignImage.Picture.Bitmap.SaveToFile(FormMain.SaveDialog.FileName);
  FormMain.OpenDialog.FileName:=FormMain.SaveDialog.FileName;
  FormOptions.LoadColorClick(FormDesign.ButtonTransCol);
  FormMain.Enabled:=true;
  FormDesign.Close;
end;

procedure TFormDesign.FillCellClick(Sender: TObject);
begin
  DrawPhrases;
end;

procedure TFormDesign.SBCCWClick(Sender: TObject);
var i,j,o,char,xmin,ymin,xmax,yref,dx: Integer;

begin
  // first find the overall dimensions of all selected phrases
  xmin:=100; ymin:=100; xmax:=-1;
  for i:=0 to High(PhraseCoor) do
    if PhraseList.Selected[i] then
      // first we need the top left and bottom left points for the new reference system
      for j:=0 to High(PhraseCoor[i]) do
        begin
          o:=PhraseCoor[i,j].O;
          char:=IsDrawableMacro(FormDesign.PhraseList.Items[i][j+1]);
          xmin:=min(xmin,PhraseCoor[i,j].X);
          xmin:=min(xmin,PhraseCoor[i,j].X + PDX[o].X * (LineMacros[char,1]-1) + PDY[o].X * (LineMacros[char,2]+LineMacros[char,3]-1));
          ymin:=min(ymin,PhraseCoor[i,j].Y);
          ymin:=min(ymin,PhraseCoor[i,j].Y + PDX[o].Y * (LineMacros[char,1]-1) + PDY[o].Y * (LineMacros[char,2]+LineMacros[char,3]-1));
          xmax:=max(xmax,PhraseCoor[i,j].X);
          xmax:=max(xmax,PhraseCoor[i,j].X + PDX[o].X * (LineMacros[char,1]-1) + PDY[o].X * (LineMacros[char,2]+LineMacros[char,3]-1));
        end;
  yref:=ymin+xmax-xmin;

  for i:=0 to High(PhraseCoor) do
    if PhraseList.Selected[i] then
      for j:=0 to High(PhraseCoor[i]) do
        begin
        // for clockwise rotations, the bottom left moves to the old top left
        // now we have the reference point. shift all the phrases such that their new
        // dx is the old -dy and the new dy is the old dx (clockwise rotation)
          dx:= PhraseCoor[i,j].Y - ymin;
          PhraseCoor[i,j].Y := yref - PhraseCoor[i,j].X + xmin;
          PhraseCoor[i,j].X := xmin + dx;
          if PhraseCoor[i,j].O=0 then
            PhraseCoor[i,j].O:=3
          else
            PhraseCoor[i,j].O:=PhraseCoor[i,j].O-1;
        end;
  ShiftToOrigin;
  DrawPhrases;
end;

procedure TFormDesign.SBCWClick(Sender: TObject);
var i,j,o,char,xmin,ymin,ymax,xref,dx: Integer;

begin
  // first find the overall dimensions of all selected phrases
  xmin:=100; ymin:=100; ymax:=-1;
  for i:=0 to High(PhraseCoor) do
    if PhraseList.Selected[i] then
      // first we need the top left and bottom left points for the new reference system
      for j:=0 to High(PhraseCoor[i]) do
        begin
          o:=PhraseCoor[i,j].O;
          char:=IsDrawableMacro(FormDesign.PhraseList.Items[i][j+1]);
          xmin:=min(xmin,PhraseCoor[i,j].X);
          xmin:=min(xmin,PhraseCoor[i,j].X + PDX[o].X * (LineMacros[char,1]-1) + PDY[o].X * (LineMacros[char,2]+LineMacros[char,3]-1));
          ymin:=min(ymin,PhraseCoor[i,j].Y);
          ymin:=min(ymin,PhraseCoor[i,j].Y + PDX[o].Y * (LineMacros[char,1]-1) + PDY[o].Y * (LineMacros[char,2]+LineMacros[char,3]-1));
          ymax:=max(ymax,PhraseCoor[i,j].Y);
          ymax:=max(ymax,PhraseCoor[i,j].Y + PDX[o].Y * (LineMacros[char,1]-1) + PDY[o].Y * (LineMacros[char,2]+LineMacros[char,3]-1));
        end;
  xref:=xmin+ymax-ymin;

  for i:=0 to High(PhraseCoor) do
    if PhraseList.Selected[i] then
      for j:=0 to High(PhraseCoor[i]) do
        begin
        // for clockwise rotations, the bottom left moves to the old top left
        // now we have the reference point. shift all the phrases such that their new
        // dx is the old -dy and the new dy is the old dx (clockwise rotation)
          dx:= ymin - PhraseCoor[i,j].Y;
          PhraseCoor[i,j].Y := ymin + PhraseCoor[i,j].X - xmin;
          PhraseCoor[i,j].X := xref + dx;
          if PhraseCoor[i,j].O=3 then
            PhraseCoor[i,j].O:=0
          else
            PhraseCoor[i,j].O:=PhraseCoor[i,j].O+1;
        end;
  ShiftToOrigin;
  DrawPhrases;
end;

procedure TFormDesign.ButtonFormatClick(Sender: TObject);
var ratio, bestratio: double;
    bestwidth, width, i, letter, total, maxwidth, linefeed, nlines: integer;
    currentline, actwidth, wordlength: integer;
    words: array of integer;
    toadd,addword: string;
    wasspace: boolean;
    tempstore: TStringlist;

begin
  if AddPhrase.Lines.Count<1 then Exit;
  SetLength(PhraseCoor,0);
  PhraseList.Clear;
  WriteCursor.Y:=1;
  tempstore:=TStringlist.Create;
  for i:=0 to AddPhrase.Lines.Count-1 do
    tempstore.Add(AddPhrase.Lines[i]);
  ratio := StrToFloat(SizeRatio.Text); // width / height
  linefeed:= StrToInt(LineSpacing.Text);
  SetLength(words,1);
  words[0]:=0;
  // tally the unbreakable phrases for width
  for i:=0 to AddPhrase.Lines.Count-1 do
    begin
      letter:=1;
      if words[High(words)]>0 then
        SetLength(words,length(words)+1);
      words[High(words)]:=0;
      while letter<Length(AddPhrase.Lines[i]) do
       begin
         if AddPhrase.Lines[i][letter]=' ' then
           begin
             if words[High(words)]>0 then
               SetLength(words,Length(words)+1);
             words[High(words)]:=0;
           end
         else
           begin
             if IsDrawableMacro(AddPhrase.Lines[i][letter])>-1 then
               words[High(words)]:=words[High(words)]+LineMacros[IsDrawableMacro(AddPhrase.Lines[i][letter]),1];
           end;
         letter:=letter+1;
       end;
      if words[High(words)]>0 then
        SetLength(words,Length(words)+1);
      words[High(words)]:=0;
    end;
  if words[High(words)]=0 then
    SetLength(words,Length(words)-1);
  // now we should have a list of the width of all the words in the text
  // test all linewidths from the longest words length to the total length of all of them
  total:=0; maxwidth:=0;
  for i:=0 to High(words) do
    begin
      total:=total+words[i];
      if words[i]>maxwidth then maxwidth:=words[i];
    end;
  // this is worse than at least one ratio (one line for all of the text)
  bestratio:=-1;
  bestwidth:=total;
  for width:=maxwidth to total do
    begin
      nlines:=1; currentline:=0; i:=0; actwidth:=0;
      while i<Length(words) do
       begin
        if currentline+words[i]>width then
          begin
            nlines:=nlines+1;
            if currentline>actwidth then actwidth:=currentline;
            currentline:=words[i];
          end
        else
          currentline:=currentline+words[i];
        i:=i+1;
       end;
      if currentline>actwidth then actwidth:=currentline;
      nlines:=nlines+1;
      if (abs((actwidth/(nlines*linefeed))-ratio)<abs(bestratio-ratio)) or (bestratio=-1) then
        begin
          bestwidth:=width;
          bestratio:=actwidth/(nlines*linefeed);
        end;
    end;
  // now we have the proper width, reformat the original text
  toadd:=AddPhrase.Lines[0];
  for i:=1 to AddPhrase.Lines.Count-1 do
    toadd:=toadd+' '+AddPhrase.Lines[i];
  AddPhrase.Clear;
  AddPhrase.Lines.Add('');
  currentline:=0;
  wasspace:=true;
  addword:='';
  wordlength:=1;
  for i:=1 to Length(toadd) do
    if ( (toadd[i]<>' ') or not wasspace) and (IsDrawableMacro(toadd[i])>-1) then
      // space? add the word and start a new word
      if toadd[i]=' ' then
        begin
          AddPhrase.Lines[AddPhrase.Lines.Count-1]:=AddPhrase.Lines[AddPhrase.Lines.Count-1]+addword;
          currentline:=currentline+wordlength;
          addword:=' ';
          wordlength:=1;
        end
      else
       begin
         // no space. is the line getting too long? start a new line
         if currentline+wordlength+LineMacros[IsDrawableMacro(toadd[i]),1]>bestwidth then
           begin
             AddPhrase.Lines.Add('');
             for letter:=1 to Length(addword)-1 do
               addword[letter]:=addword[letter+1];
             SetLength(addword,Length(addword)-1);
             wordlength:=wordlength-1;
             currentline:=0;
           end;
         addword:=addword+toadd[i];
         wordlength:=wordlength+LineMacros[IsDrawableMacro(toadd[i]),1];
         if toadd[i]=' ' then wasspace:=true else wasspace:=false;
       end;
  AddPhrase.Lines[AddPhrase.Lines.Count-1]:=AddPhrase.Lines[AddPhrase.Lines.Count-1]+addword;
  ButtonAddPhrase.Click;
  for i:=0 to tempstore.Count-1 do
    AddPhrase.Lines.Add(tempstore[i]);
  tempstore.Free;
end;

end.
