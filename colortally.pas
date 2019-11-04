unit colortally;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Math;

type
  TFormTally = class(TForm)
    TallyHue: TImage;
    GroupBox1: TGroupBox;
    ShowEmpty: TCheckBox;
    ShowEnds: TCheckBox;
    ShowCorners: TCheckBox;
    ShowStraight: TCheckBox;
    ShowCrosses: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    ButtonOK: TButton;
    ShowWhich: TRadioGroup;
    TallyHist: TImage;
    GroupBox2: TGroupBox;
    AvgTiles: TEdit;
    Label1: TLabel;
    HistHue: TRadioButton;
    HistSat: TRadioButton;
    ShowTriples: TCheckBox;
    PixSize: TEdit;
    Label2: TLabel;
    TotalLabel: TLabel;
    OnlyUsable: TCheckBox;
    procedure ButtonOKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure HistHueClick(Sender: TObject);
    procedure HistSatClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShowEmptyMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowWhichClick(Sender: TObject);
    procedure OnlyUsableClick(Sender: TObject);
    procedure AvgTilesExit(Sender: TObject);
    procedure PixSizeExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTally: TFormTally;

implementation

uses main;

{$R *.dfm}

procedure DrawTally;

var i,x,y,ntiles,nbins: Integer;
    c: TRGBColor;
    maxc,minc,hi,t,p,q: Integer;
    hue,sat,f,s,maxh: Double;
    hist: array of Double;

begin
  ntiles:=0;
  for i:=0 to High(Images) do
   if  ( ( (Images[i].typ=0) and FormTally.ShowEmpty.Checked ) or
    ( (Images[i].typ>0) and (Images[i].typ<5) and FormTally.ShowEnds.Checked ) or
    ( ( (Images[i].typ=5) or (Images[i].typ=7) or (Images[i].typ=8) or (Images[i].typ=10) ) and FormTally.ShowCorners.Checked ) or
    ( ( (Images[i].typ=6) or (Images[i].typ=9) ) and FormTally.ShowStraight.Checked ) or
    ( (Images[i].typ>10) and (Images[i].typ<15) and FormTally.ShowTriples.Checked ) or
    ( (Images[i].typ>14) and (Images[i].typ<18) and FormTally.ShowCrosses.Checked ) ) and
    ( (FormTally.OnlyUsable.Checked=false) or TileIsUsable(i) ) then
      ntiles:=ntiles+1;
  nbins:=Floor(ntiles/StrToInt(FormTally.AvgTiles.Text));
  SetLength(hist,nbins+2);
  for i:=0 to High(hist) do hist[i]:=0;

  if FormTally.ShowWhich.ItemIndex=1 then
    for x:=0 to 265 do
      for y:=0 to 265 do
        begin
          // determine the color for this pair of hue and saturation and plot it
          hi := floor(x/266*6);
          f := x/266*6 - hi;
          s := (y/265);
          t := floor((1-(1-f)*s)*255);
          p:=floor( (1-s)*255);
          q:=floor( (1-f*s)*255);
          case hi of
           0: begin c.Red:=255; c.Green:= t; c.Blue:= p; end;
           1: begin c.Red:=q; c.Green:=255; c.Blue:=p; end;
           2: begin c.Red:=p; c.Green:=255; c.Blue:=t; end;
           3: begin c.Red:=p; c.Green:=q; c.Blue:=255; end;
           4: begin c.Red:=t; c.Green:=p; c.Blue:=255; end;
           5: begin c.Red:=255; c.Green:=p; c.Blue:=q; end;
          end;
          if FormTally.HistHue.Checked then
            FormTally.TallyHue.Canvas.Pixels[x,y]:=c.Color
          else
            FormTally.TallyHue.Canvas.Pixels[y,x]:=c.Color
        end
  else
   begin
    FormTally.TallyHue.Canvas.Brush.Color:=clBlack;
    FormTally.TallyHue.Canvas.Pen.Color:=clBlack;
    FormTally.TallyHue.Canvas.FillRect(Rect(0,0,FormTally.TallyHue.Width,FormTally.TallyHue.Height));
   end;

  for i:=0 to High(Images) do
   if  ( ( (Images[i].typ=0) and FormTally.ShowEmpty.Checked ) or
    ( (Images[i].typ>0) and (Images[i].typ<5) and FormTally.ShowEnds.Checked ) or
    ( ( (Images[i].typ=5) or (Images[i].typ=7) or (Images[i].typ=8) or (Images[i].typ=10) ) and FormTally.ShowCorners.Checked ) or
    ( ( (Images[i].typ=6) or (Images[i].typ=9) ) and FormTally.ShowStraight.Checked ) or
    ( (Images[i].typ>10) and (Images[i].typ<15) and FormTally.ShowTriples.Checked ) or
    ( (Images[i].typ>14) and (Images[i].typ<18) and FormTally.ShowCrosses.Checked ) ) and
    ( (FormTally.OnlyUsable.Checked=false) or TileIsUsable(i) ) then
     begin
       // get the hue/saturation for the current tile
       c:=Images[i].color;
       maxc:=max(1,max(max(c.red,c.green),c.blue));
       minc:=min(min(c.red,c.green),c.blue);
       sat:=(maxc-minc)/maxc;
       if maxc=minc then
         hue:=0
       else if c.red=maxc then
         hue :=     (c.green - c.blue)/(maxc-minc)
       else if c.green=maxc then
         hue := 2 + (c.blue  -  c.red)/(maxc-minc)
       else
         hue := 4 + (c.red -  c.green)/(maxc-minc);
       if hue<0 then hue:=hue+6;
       if hue=6 then hue:=0;
       if FormTally.HistHue.Checked then
         hist[floor(hue/6*nbins)+1]:=hist[floor(hue/6*nbins)+1]+1
       else
         hist[floor(0.999*sat*nbins)+1]:=hist[floor(0.999*sat*nbins)+1]+1;

       if FormTally.ShowWhich.ItemIndex=0 then
         FormTally.TallyHue.Canvas.Brush.Color:=Images[i].color.Color
       else
         FormTally.TallyHue.Canvas.Brush.Color:=clBlack;

       FormTally.TallyHue.Canvas.Pen.Color:=FormTally.TallyHue.Canvas.Brush.Color;

       if FormTally.HistHue.Checked then
         FormTally.TallyHue.Canvas.FillRect( Rect(
           floor(hue/6*265 - StrToInt(FormTally.PixSize.Text)/2),
           floor(sat*265   - StrToInt(FormTally.PixSize.Text)/2),
           floor(hue/6*265 + StrToInt(FormTally.PixSize.Text)/2),
           floor(sat*265   + StrToInt(FormTally.PixSize.Text)/2) ) )
       else
         FormTally.TallyHue.Canvas.FillRect( Rect(
           floor(sat*265   - StrToInt(FormTally.PixSize.Text)/2),
           floor(hue/6*265 - StrToInt(FormTally.PixSize.Text)/2),
           floor(sat*265   + StrToInt(FormTally.PixSize.Text)/2),
           floor(hue/6*265 + StrToInt(FormTally.PixSize.Text)/2) ) );

{       for x:=-floor(StrToInt(FormTally.PixSize.Text)/2) to StrToInt(FormTally.PixSize.Text)-floor(StrToInt(FormTally.PixSize.Text)/2)-1 do
        for y:=-floor(StrToInt(FormTally.PixSize.Text)/2) to StrToInt(FormTally.PixSize.Text)-floor(StrToInt(FormTally.PixSize.Text)/2)-1 do
         if FormTally.ShowWhich.ItemIndex=0 then
          if FormTally.HistHue.Checked then
            FormTally.TallyHue.Canvas.Pixels[floor(hue/6*265)+x,floor(sat*265)+y]:=Images[i].color.Color
          else
            FormTally.TallyHue.Canvas.Pixels[floor(sat*265)+y,floor(hue/6*265)+x]:=Images[i].color.Color
         else
          if FormTally.HistHue.Checked then
            FormTally.TallyHue.Canvas.Pixels[floor(hue/6*265)+x,floor(sat*265)+y]:=clBlack
          else
            FormTally.TallyHue.Canvas.Pixels[floor(sat*265)+y,floor(hue/6*265)+x]:=clBlack;}
     end;

  FormTally.TotalLabel.Caption:='Total: '+IntToStr(ntiles)+' tiles.';
  maxh:=1;
  for i:=0 to High(hist) do
    maxh:=max(maxh,hist[i]);
  for i:=0 to high(hist) do
    hist[i]:=hist[i]/maxh;
  if nbins>0 then
   begin
    hist[0]:=hist[high(hist)-1];
    hist[high(hist)]:=hist[1];
   end;

  with FormTally.TallyHist.Canvas do
    begin
      Brush.Color:=clWhite;
      Pen.Color:=clWhite;
      FillRect(Rect(0,0,FormTally.TallyHist.Width,FormTally.TallyHist.Height));
      Pen.Color:=clBlack;
      Pen.Width:=2;
      for i:=1 to nbins do
        begin
          MoveTo( floor(10 + (i-1) * 245/nbins), floor( 10 + 60 * (1-hist[i-1]) ) );
          LineTo( floor(10 + i * 245/nbins), floor( 10 + 60 * (1-hist[i]) ) );
        end;
    end;
end;

procedure TFormTally.ButtonOKClick(Sender: TObject);
begin
  FormMain.Enabled:=true;
  FormTally.Hide;
end;

procedure TFormTally.Button1Click(Sender: TObject);
begin
  ShowEmpty.Checked:=true;
  ShowEnds.Checked:=true;
  ShowCorners.Checked:=true;
  ShowStraight.Checked:=true;
  ShowTriples.Checked:=true;
  ShowCrosses.Checked:=true;
  DrawTally;
end;

procedure TFormTally.Button2Click(Sender: TObject);
begin
  ShowEmpty.Checked:=false;
  ShowEnds.Checked:=false;
  ShowCorners.Checked:=false;
  ShowStraight.Checked:=false;
  ShowTriples.Checked:=false;
  ShowCrosses.Checked:=false;
  DrawTally;
end;

procedure TFormTally.HistHueClick(Sender: TObject);
begin
  HistSat.Checked := not HistHue.Checked;
  DrawTally;
end;

procedure TFormTally.HistSatClick(Sender: TObject);
begin
  HistHue.Checked := not HistSat.Checked;
  DrawTally;
end;

procedure TFormTally.FormShow(Sender: TObject);
begin
  DrawTally;
end;

procedure TFormTally.ShowEmptyMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DrawTally;
end;

procedure TFormTally.ShowWhichClick(Sender: TObject);
begin
  DrawTally;
end;

procedure TFormTally.OnlyUsableClick(Sender: TObject);
begin
  DrawTally;
end;

procedure TFormTally.AvgTilesExit(Sender: TObject);
begin
  DrawTally;
end;

procedure TFormTally.PixSizeExit(Sender: TObject);
begin
  DrawTally;
end;

end.
