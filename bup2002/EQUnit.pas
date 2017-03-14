unit EQUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Winamp, Main,
  Menus;

type
  TEQForm = class(TForm)
    EQpMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    EQF1: TMenuItem;
    N7: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    { Public declarations }
    procedure EQSliderUpdate(var s);
    procedure InitEQSliders;
    procedure InitEQs;
    procedure LoadDefEQ;
    procedure Load0dbEQ;
    procedure Loadp20dbEQ;
    procedure Loadm20dbEQ;
  end;

type tBtn = record
        x,y : integer;
        w,h : integer;
        sX1,sY1 : integer;
        sX2,sY2 : integer;
        s       : integer;
        t       : integer;
     end;

const nEQBtns = 7;
      EQaBtns : array [1..nEQBtns] of tBtn =
      (
       (x:014;y:018;w:027;h:012;sX1:010;sY1:119;sX2:069;sY2:119;s:0;t:1),
       (x:040;y:018;w:031;h:012;sX1:036;sY1:119;sX2:095;sY2:119;s:0;t:1),
       (x:217;y:018;w:044;h:012;sX1:224;sY1:164;sX2:224;sY2:176;s:0;t:0),
       (x:264;y:003;w:009;h:009;sX1:000;sY1:116;sX2:000;sY2:125;s:0;t:0),
       (x:040;y:036;w:026;h:010;sX1:000;sY1:000;sX2:000;sY2:000;s:0;t:2),
       (x:040;y:064;w:026;h:010;sX1:000;sY1:000;sX2:000;sY2:000;s:0;t:2),
       (x:040;y:095;w:026;h:010;sX1:000;sY1:000;sX2:000;sY2:000;s:0;t:2)
      );

type tUpdateSliderEvent = procedure (var s) of object;

type pMyEQSlider = ^tMyEQSlider;
     tMyEQSlider = class(TObject)
       private
         fLeft,fTop : integer;
         fWidth,fHeight : integer;
         fMinPos,fMaxPos : integer;
         fPosition : integer;
         fSliderVisible : boolean;
         fUpdateEvent : tUpdateSliderEvent;
         Seeking : boolean;
         AutoSeek : boolean;
         sx1,sy1,sx2,sy2 : integer;
         sw,sh : integer;

         procedure SetTopPos(x : integer);
         procedure SetLeftPos(x : integer);
         procedure SetWidth(x : integer);
         procedure SetHeight(x : integer);
         procedure SetMinPos(x : integer);
         procedure SetMaxPos(x : integer);
         procedure SetPosition(x : integer);
         procedure SetVisible(b : boolean);

       public
         constructor Create;
         procedure Draw;
         procedure OnChangedPosition; virtual;
         function  IsHitSlider(x,y : integer) : boolean;
         procedure SetSliderPos(x : integer; upd : boolean);

       published
         property UpdateEvent : tUpdateSliderEvent read fUpdateEvent write fUpdateEvent;
         property MaxPos : Integer read fMaxPos write SetMaxPos default 1;
         property MinPos : Integer read fMinPos write SetMinPos default 0;
         property Left : Integer read fLeft write SetLeftPos default 0;
         property Top : Integer read fTop write SetTopPos default 0;
         property Height : Integer read fHeight write SetHeight default 0;
         property Width : Integer read fWidth write SetWidth default 0;
         property Position : Integer read fPosition write SetPosition default 0;
         property SliderVisible : boolean read fSliderVisible write SetVisible default true;
     end;

const MaxEQSliders = 09+1;

var EQForm: TEQForm;
    EQDontSeek : boolean = false;
    EQCreating : boolean = true;
    EQPainting : boolean = false;
    pHDC     : HDC;
    EQFShow  : boolean = true;
    EQFAct   : boolean = true;
    EQDragged : boolean = false;
    EQmX,EQmY : integer;
    EQSliders : array[0..MaxEQSliders] of tMyEQSlider;
    EQMouseDn : boolean = false;
    EQdnBt : integer = -1;
    EQdnBts : integer = 0;
    EQFirstShow : boolean = true;
    ShowingEQPr : boolean = false;


procedure EQPaintSkin;
function  nEQHitBtn(hx,hy : integer) : integer;
procedure EQPushBtn(b : integer; var s : integer; Button: TMouseButton; Shift: TShiftState; x,y : integer);
procedure SetEQ;
procedure LoadPreset;

  implementation uses EQPrUnit, SaveEQPrUnit, DelEQPrUnit;

procedure LoadPreset;
begin
  if not ShowingEQPr then
  with TEQPrForm.Create(EQForm) do
  try
    ShowingEQPr := true;
    Show;
  finally
{    Free;{}
  end;
end;

procedure SetEQ;
var i : integer;
begin
  for i := 0 to 9 do EQData[i] := EQSliders[i].MaxPos - EQSliders[i].Position;
  EQPreAmp := EQSliders[10].MaxPos - EQSliders[10].Position;
  if IsPlaying then if InPlug <> nil then
  begin
    InPlug^.EQSet(integer(EQisON),EQData,EQPreAmp);
  end;
end;

procedure tEQForm.Load0dbEQ;
var i : integer;
begin
  for i := 0 to 9 do EQData[i] := 31;
  InitEQs;
  SetEQ;
end;

procedure tEQForm.Loadp20dbEQ;
var i : integer;
begin
  for i := 0 to 9 do EQData[i] := 0;
  InitEQs;
  SetEQ;
end;

procedure tEQForm.Loadm20dbEQ;
var i : integer;
begin
  for i := 0 to 9 do EQData[i] := 63;
  InitEQs;
  SetEQ;
end;

procedure tEQForm.LoadDefEQ;
var i : integer;
begin
  for i := 0 to 9 do EQData[i] := 31;
  EQPreAmp := 31;
  InitEQs;
  SetEQ;
end;

procedure EQPushBtn(b : integer; var s : integer; Button: TMouseButton; Shift: TShiftState; x,y : integer);
begin
  case b of
  01: if Button = mbLeft then
      begin
        EQisOn := s <> 0;
        SetEQ;
      end;
  02: begin
        EQAuto := s <> 0;
      end;
  03: begin
        EQForm.EQpMenu.Popup(EQForm.Left + EQaBtns[b].x+1,EQForm.Top + EQaBtns[b].y+1);
      end;
  04: begin
        EQForm.Hide;
      end;
  05: EQForm.Loadp20dbEQ;
  06: EQForm.Load0dbEQ;
  07: EQForm.Loadm20dbEQ;
  end;
  with EQaBtns[EQdnBt] do
  begin
    if t = 0 then EQaBtns[b].s := 0;
  end;
end;

function  nEQHitBtn(hx,hy : integer) : integer;
var i : integer;
begin
  Result := -1;
  for i := 1 to nEQBtns do with EQaBtns[i] do
    if (hx >= x)and(hx <= x + w)and(hy >= y)and(hy <= y + h) then
    begin
      Result := i;
      break;
    end;
end;

procedure EQPaintSkin;
var i,cw,ch : integer;
begin
  if (Buf = nil)or(Skin = nil)or(MainForm = nil) then Exit;
  try
    EQPainting := true;

    pHDC := Buf.Canvas.Handle;{}
    cw := EQForm.ClientWidth;
    ch := EQForm.ClientHeight;
(*
    if IsActive then
     bitblt(pHDC,000,000,025,020,
            EQSkin.Canvas.Handle,000,000,SRCCOPY) else
     bitblt(pHDC,000,000,025,020,
            EQSkin.Canvas.Handle,000,021,SRCCOPY);
*)
    bitblt(pHDC,000,000,cw,ch,
           EQSkin.Canvas.Handle,000,000,SRCCOPY);

    for i := 0 to MaxEQSliders do with EQSliders[i] do Draw;

    for i := 1 to nEQBtns do with EQabtns[i] do if t <> 2 then 
    begin
      if S = 0 then
        bitblt(pHDC,x,y,w,h,EQSkin.Canvas.Handle,sx1,sy1,SRCCOPY)
      else
        bitblt(pHDC,x,y,w,h,EQSkin.Canvas.Handle,sx2,sy2,SRCCOPY)
    end;

    if pHDC <> EQForm.Canvas.Handle then
    bitblt(EQForm.Canvas.Handle,000,000,cw,ch,
           pHDC,000,000,SRCCOPY);
  finally
    EQPainting := false;
  end;
end;

procedure tEQForm.EQSliderUpdate(var s);
begin
  SetEQ;
(*
  with tMyEQSlider(s) do
  begin
  end;
*)
end;

procedure tEQForm.WMEraseBkgnd(var m : TWMEraseBkgnd);
begin
  m.Result := LRESULT(true);
end;

function  tMyEQSlider.IsHitSlider(x,y : integer) : boolean;
begin
  Result := false;
  if (x >= fLeft)and(x <= fLeft + fWidth)and
     (y >= fTop )and(y <= fTop + fHeight) then Result := true;
end;

procedure tMyEQSlider.SetSliderPos(x : integer; upd : boolean);
var mp,sp,ww,xx,i : integer;
begin
  if (x >= fTop)and(x <= fTop + fHeight) then
  begin
    x := x - sh div 2;{}
    xx := x - fTop;
    ww := fHeight - sh;
    if xx > ww then xx := ww;
    sp := fMaxPos - fMinPos;
    i := round( ((sp))*(1-(xx)/(ww)) );
    if (i < fMinPos) then i := 0 else if i > fMaxPos then i := fMaxPos;
{    mp := sp div 2;{}
    mp := 32;
    if (i > mp - 3)and(i < mp + 3) then i := mp;
    if i <> fPosition then fPosition := i;
    Draw;
    if (upd)or(AutoSeek) then UpdateEvent(Self);
  end;
end;

procedure tMyEQSlider.OnChangedPosition;
begin
  if not DontSeek then if Assigned(FUpdateEvent) then fUpdateEvent(Self);{}
end;

constructor tMyEQSlider.Create;
begin
  sw  := 0;
  sh  := 0;
  sx1 := 0;
  sy1 := 0;
  sx2 := 0;
  sy2 := 0;
  fLeft := 0;
  fTop  := 0;
  fMinPos := 0;
  fMaxPos := 0;
  fPosition := 0;
  fHeight := 0;
  fWidth  := 0;
  Seeking := false;
  AutoSeek := false;
end;

procedure tMyEQSlider.Draw;
var sp,spi,c,xx,yy,y,i,j : integer;
    p : real;
begin
  if (EQCreating) then exit;
  if not EQPainting then EQPaintSkin else
  begin
    if (fSliderVisible) then
    begin
      if (fWidth = 0)or(fHeight = 0)or(fPosition > fMaxPos) then exit;
      y := fPosition - fMinPos;
      i := fMaxPos - fMinPos;
      if i = 0 then p := 0 else p := (y / i);

      sp := round(28 * (p)) - 1;
      if sp <= 0 then sp := 0;
      if sp >= 14 then begin sp := sp - 14; spi := 1; end else spi := 0;
{      sp := sp - 1;{}
      xx := 13 + sp*15;
      yy := 164 + 65*spi;
      bitblt(Buf.Canvas.Handle,fLeft,fTop,14,63,
             EQSkin.Canvas.Handle,xx,yy,SRCCOPY);

      y := round((fHeight - sh)*(1-p));
      if y + sh > fHeight then y := fHeight - sh;

      if Seeking then
      begin
        xx := sx2; yy := sy2;
      end else
      begin
        xx := sx1; yy := sy1;
      end;

      for i := 0 to sw-1 do
      for j := 0 to sh-1 do
      begin
        c := EQSkin.Canvas.Pixels[xx+i,yy+j];
{        if c <> clWhite then Buf.Canvas.Pixels[fLeft+i+x,fTop+j] := c;}
        if c <> clWhite then Buf.Canvas.Pixels[fLeft+i+1,fTop+j+y] := c;
      end;
    end;
  end;
end;

procedure tMyEQSlider.SetTopPos(x : integer);
begin
  if x < 0 then fTop := 0 else fTop := x;
  Draw;
end;

procedure tMyEQSlider.SetLeftPos(x : integer);
begin
  if x < 0 then fLeft := 0 else fLeft := x;
  Draw;
end;

procedure tMyEQSlider.SetWidth(x : integer);
begin
  if x < 0 then fWidth := 0 else fWidth := x;
  Draw;
end;

procedure tMyEQSlider.SetPosition(x : integer);
var newpos : integer;
begin
  if not Seeking then
  begin
    if x > fMaxPos then newpos := fMaxPos else if x < fMinPos then newpos := fMinPos else newpos := x;
    if newpos <> fPosition then
    begin
      fPosition := newpos;
      OnChangedPosition;
      Draw;
    end;
  end;
end;

procedure tMyEQSlider.SetVisible(b : boolean);
begin
  fSliderVisible := b;
  Draw;
end;

procedure tMyEQSlider.SetHeight(x : integer);
begin
  if x < 0 then fHeight := 0 else fHeight := x;
  Draw;
end;

procedure tMyEQSlider.SetMinPos(x : integer);
begin
  if x > fMaxPos then fMinPos := fMaxPos-1 else fMinPos := x;
  Draw;
end;

procedure tMyEQSlider.SetMaxPos(x : integer);
begin
  if x < fMinPos then fMaxPos := fMinPos+1 else fMaxPos := x;
  Draw;
end;

{$R *.DFM}

procedure tEQForm.InitEQSliders;
var i : integer;
begin
  for i := 0 to MaxEQSliders do
  begin
    EQSliders[i] := tMyEQSlider.Create;
    with EQSliders[i] do
    begin
      fLeft := 78 + 18*i;
      fTop  := 38;
      fWidth := 15;
      fHeight := 62;
      fMinPos := 0;
      fMaxPos := 63;
      fPosition := 0;
      fSliderVisible := true;
      fUpdateEvent := EQSliderUpdate;
      Seeking := false;
      AutoSeek := true;
      sx1 := 0;
      sy1 := 164;
      sx2 := 0;
      sy2 := 175;
      sw  := 11;
      sh  := 11;
    end;
  end;
  with EQSliders[10] do
  begin
    fLeft := 21;
    fTop  := 38;
    fPosition := 0;
  end;
  InitEQs;
end;

procedure TEQForm.FormCreate(Sender: TObject);
begin
  EQCreating := true;
  EQFirstShow := true;
  EQDnBt := 0;
  EQFShow  := true;
  EQFAct   := true;
  InitEQSliders;
  SetEQ;
  EQCreating := false;
end;

procedure TEQForm.FormPaint(Sender: TObject);
begin
  EQPaintSkin;
end;

procedure TEQForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) then
  begin
    if (Key = ord('G')) then
    begin
      Visible := not Visible;
    end else
  end else
end;

procedure TEQForm.FormActivate(Sender: TObject);
begin
  if EQFAct then
  begin
    EQFAct := false;
    EQForm.ClientWidth  := 275;
    EQForm.ClientHeight := 116;
    EQForm.Left := eqX;
    EQForm.Top := eqY;
  end;
end;

procedure TEQForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i : integer;
begin
  EQdnBt := nEQHitBtn(x,y);
  if EQdnBt > 0 then with EQaBtns[EQdnBt] do
  begin
    EQdnBts := EQaBtns[EQdnBt].s;
    case t of
    1: if s = 0 then s := 1 else s := 0;
     else s := 1;
    end;
  end else
  if (Button = mbLeft) then
  begin
    EQMouseDn := false;
    for i := 0 to MaxEQSliders do
    if EQSliders[i].IsHitSlider(x,y) then
    begin
      EQSliders[i].SetSliderPos(y,true);
      EQMouseDn := true;
      break;
    end;
    if not EQMouseDn then
    begin
      EQDragged := true;
      EQmX := X;
      EQmY := Y;
    end;
  end;
  EQPaintSkin;
end;

procedure TEQForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i : integer;
{    pt : tPoint;}
begin
{  pt.x := x; pt.y := y; pt := MainForm.ClientToScreen(pt);{}
{  if then}
  begin
    i := nEQHitBtn(x,y);
    if i > 0 then
    begin
      if EQdnBt > 0 then
      begin
        if i > 0 then
        begin
          if (i = EQdnBt) then
          begin
            EQPushBtn(EQdnBt, EQaBtns[EQdnBt].s, Button, Shift, x,y);
            if EQdnBt = 14 then // Close
            begin
{              c := false;}
            end;
          end;
        end;
      end;
    end else if Button = mbRight then
    begin
      {mySysMenu.Popup(pt.x,pt.y);}
    end;
    EQdnBt := 0;
  end;
  EQDragged := false;
  EQMouseDn := false;
  EQPaintSkin;
end;

procedure TEQForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i,nL,nT,nLeft,nTop : integer;
begin
  if EQDragged then
  begin
    nLeft := Left + X - EQmX;
    nTop  := Top  + Y - EQmY;
    nL    := nLeft;
    nT    := nTop;
    SetBounds(nL,nT,Width,Height);
  end else if EQMouseDn then
  begin
    for i := 0 to MaxEQSliders do
    if EQSliders[i].IsHitSlider(x,y) then
    begin
      EQSliders[i].SetSliderPos(y,true);
    end;
  end else if EQdnBt > 0 then
  begin
    if (nEQHitBtn(x,y) = EQdnBt) then with EQaBtns[EQdnBt] do
    begin
      case t of
      0: begin
           EQaBtns[EQdnBt].s := 1;
         end;
       else
       begin
         if EQdnBts = 1 then EQaBtns[EQdnBt].s := 0 else EQaBtns[EQdnBt].s := 1;
       end;
      end;
    end else with EQaBtns[EQdnBt] do
    begin
      EQaBtns[EQdnBt].s := EQdnBts;
    end;
  end else
  ;
  EQPaintSkin;
end;

procedure TEQForm.FormClose(Sender: TObject; var Action: TCloseAction);
var i : integer;
begin
  EQPreAmp := EQSliders[10].MaxPos - EQSliders[10].Position;
  for i := 0 to MaxEQSliders do
  begin
    if i < 10 then EQData[i] := EQSliders[i].MaxPos - EQSliders[i].Position;
    EQSliders[i].Free;
  end;
  MainForm.smiEQ.Checked := false;
end;

procedure TEQForm.FormHide(Sender: TObject);
begin
  MainForm.smiEQ.Checked := EQForm.Visible;
end;

procedure TEQForm.FormShow(Sender: TObject);
begin
  if EQFirstShow then
  begin
    EQFirstShow := false;
  end;
  MainForm.smiEQ.Checked := EQForm.Visible;
end;

procedure TEQForm.N4Click(Sender: TObject);
begin
  LoadPreset;
end;

procedure TEQForm.InitEQs;
var i : integer;
begin
  for i := 0 to 9 do with EQSliders[i] do
  begin
    fPosition := MaxPos - EQData[i];
  end;
  with EQSliders[10] do
  begin
    fPosition := MaxPos - EQPreAmp;
  end;
  EQaBtns[1].s := integer(EQisON);
  EQaBtns[2].s := integer(EQAuto);
  EQaBtns[3].s := integer(0);
  EQPaintSkin;
end;

procedure TEQForm.N5Click(Sender: TObject);
begin
  LoadDefEQ;
end;

procedure TEQForm.N6Click(Sender: TObject);
begin
  SetEQ;
  SavePreset;
end;

procedure TEQForm.N7Click(Sender: TObject);
begin
  DelPreset;
end;

end.




