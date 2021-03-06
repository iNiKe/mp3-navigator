unit About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SysUtils, ComCtrls, Messages, ImgList;

type
  TAboutBox = class(TForm)
    OKButton: TButton;
    ProgramName: TLabel;
    PageControl: TPageControl;
    StatusBar: TStatusBar;
    GeneralSheet: TTabSheet;
    TabSheet2: TTabSheet;
    DrawImage: TImage;
    Timer: TTimer;
    HistoryMemo: TMemo;
    TabSheet1: TTabSheet;
    LinksBox: TComboBox;
    DescMemo: TMemo;
    Label1: TLabel;
    KeysSheet: TTabSheet;
    KeysMemo: TMemo;
    PaintImage: TImage;
    HomePageLinkLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure HomePageLinkLabelClick(Sender: TObject);
    procedure LinksBoxDblClick(Sender: TObject);
    procedure LinksBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LinksBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKButtonClick(Sender: TObject);
    procedure HomePageLinkLabelMouseEnter(Sender: TObject);
    procedure HomePageLinkLabelMouseLeave(Sender: TObject);
  private
    { Private declarations }
    procedure InitText;
    procedure InitGraphics;
    procedure DoneGraphics;
{    procedure DisplayPara(x,y : word);{}
    procedure DrawProc;
  public
    { Public declarations }
  end;

type tURLink = record
       URL  : string;
       Link : string;
       Desc : string;
     end;

const NiKesHomePageAddr = 'http://www.cjnike.h1.ru';
      HomePageLinkSt    = 'NiKe''s HomePage ('+NiKesHomePageAddr+')';
      nLinks = 26;
      Links : array [1..nLinks] of tURLink =
(
 (URL:'http://www.winamp.com';Link:'www.winamp.com';Desc:'����������� ���� �������� Winamp-�'),
 (URL:'http://napster.com';Link:'napster.com';Desc:'MP3 Music Network'#13#10'������ �������� Napster � ���������� ���'#13#10'� �� �������� ������ � ����������� MP3 !!!'),
 (URL:'http://www.musmania.ru';Link:'www.musmania.ru';Desc:'����������� ������ ��������'#13#10'����� ������� ������ ������������'#13#10'������ ��� ��������� Primorye OnLine :('),
 (URL:'http://www.farpost.com/mp3';Link:'www.farpost.com/mp3';Desc:'����� (aKa ������;) �� ����������� �����'),
 (URL:'http://www.farpost.com/5045/43.4/links.htm#mp3';Link:'www.farpost.com/5045/43.4';Desc:'����� �� MP3 ����� � NiGhthAWk 2:5045/43.4'),
 (URL:'http://www.allofmp3.com';Link:'www.allofmp3.com';Desc:'�������� ��������� � ��������'),
 (URL:'http://www.mp3mp4.com';Link:'www.mp3mp4.com';Desc:'���� �����, �� ����� "�����������"'),
 (URL:'http://mp3.ru';Link:'mp3.ru';Desc:'������������� ������ MP3'),
 (URL:'http://mp3.com';Link:'mp3.com';Desc:'���������� mp3 ���� ;)'),
 (URL:'http://omen.ru/music/MP3&RA.HTM';Link:'omen.ru/music/MP3&RA.HTM';Desc:'������� mp3 ���� (OMEN)'),
 (URL:'http://www.mp3shits.com/charts/mtv.shtml';Link:'www.mp3shits.com/charts/mtv.shtml';Desc:'MTV Top20 MP3 ����'),
 (URL:'http://www.altmp3.ru/';Link:'www.altmp3.ru';Desc:'mp3 ����. ����� �������. �����. ������'),
 (URL:'ftp://ftp.marine.su/pub/';Link:'ftp.marine.su/pub/';Desc:'ftp mp3 ���� �� ������������'),
 (URL:'ftp://ftp.stl.su/pub/music/';Link:'ftp.stl.su/pub/music/';Desc:'ftp mp3 ���� �� ������������ [�� ������ aka stl.ru]'),
 (URL:'http://top100.rambler.ru/top100/MP3/index.shtml.ru';Link:'top100.rambler.ru/top100/MP3/index.shtml.ru';Desc:'Rambler Top100 MP3'),
 (URL:'http://www.aria.ru';Link:'www.aria.ru';Desc:'����������� ���� ��. ����'),
 (URL:'http://www.dolphin.ipc.ru';Link:'www.dolphin.ipc.ru';Desc:'����������� ���� �������� aKa Dolphin'),
 (URL:'http://www.guanoapes.com';Link:'www.GuanoApes.com';Desc:'����������� ���� Guano Apes (Sandra Nasic & Co.)'),
 (URL:'http://www.guanoapes.org';Link:'www.GuanoApes.org';Desc:'���� ��� Guano Apes (Sandra Nasic & Co.)'),
 (URL:'http://www.guanoapes.al.ru';Link:'www.GuanoApes.al.ru';Desc:'���������� ���� ��� Guano Apes (Sandra Nasic & Co.)'),
 (URL:'http://guanoapes.jsa.ru';Link:'GuanoApes.jsa.ru';Desc:'���������� ����-������� Guano Apes (Sandra Nasic & Co.)'),
 (URL:'http://users.erols.com/dcrouch/aon.htm';Link:'users.erols.com/dcrouch/aon.htm';Desc:'ArtOfNoise'),
 (URL:'http://Durden.cjb.net';Link:'Durden.cjb.net';Desc:'Fight Club: Tyler Durden/Brad Pitt, Edvard Norton'),
 (URL:'http://www.foxmovies.com/fightclub';Link:'www.foxmovies.com/FightClub';Desc:'Fight Club: Tyler Durden/Brad Pitt, Edvard Norton'),
 (URL:'http://www.paparoach.com';Link:'www.PapaRoach.com';Desc:'����������� ���� ������ Papa Roach (�� Flash-e)'),
 (URL:'http://www.davidfincher.net';Link:'www.DavidFincher.net';Desc:'David Fincher (Fight Club, Se7en)')
);

    const FirstShowAbout : boolean = true;
          Initing        : boolean = false;
          ShowingAbout   : boolean = false;

procedure ShowAboutBox;

  Implementation uses Main,ShellApi;

{$R *.DFM}

procedure TAboutBox.InitText;
begin
  with HistoryMemo.Lines do
  begin
    Clear;
Add('*** MP3 NaviGatoR : ������� ������ ***');
Add('v2.9 (26/03/2003)');
Add('  * ���������� ��� D7');
Add('  * ������� ��������� � ���');
Add('  * ������������� ������� FileInfo() �� in_mp3.dll');
Add('');
Add('v2.8 (19/09/2002)');
Add('  * 1-� ������ ��� ����');
Add('  * ��������� ����');
Add('');
Add('v2.7 (30/03/2002)');
Add('  * ���������� � ����� ��������!');
Add('    ADO, M$ Jet.OLEDB.4.0');
Add('    ������� �����/������');
Add('  * TAGs union Fix');
Add('  * Skin �������');
Add('  * LoadSkin bugFIX');
Add('  * TagEditor.OnLoad bugFIX');
Add('  * Volume/Balance bugFIX');
Add('  * ��������� ������� ��� Edit-��:');
Add('    UPCASE, downcase, ������ �������');
Add('  * ������������� � XP');
(*
Add('  * ');
Add('    ');
*)
Add('  * "�������������" �����');
Add('');
Add('v2.6a (25/02/2002)');
Add('  * Special build 4 U.S.A.');
Add('');
Add('v2.5 (07/01/2002)');
Add('  * Fix � ��������� ���������');
Add('  * Fix � ID3v2 ������');
Add('  * ������� ���. �����:');
Add('    IDM');
Add('');
Add('v2.4 (04/08/2001)');
Add('  * ��������� �����');
Add('  * ������� ���. �����:');
Add('    Jump Up');
Add('');
Add('v2.3 beta 1 (07/08/2001)');
Add('  * ������ MP3 NaviGatoR ���������� DLL Winamp-a');
Add('    in_mp3.dll, out_*.dll, vis_*.dll!');
Add('    ��������� � �������� ��� ������� :)');
Add('');
Add('v2.2 beta 3 (21/07/2001)');
Add('  * ������ ����� ��������� ���������� ������ :)');
Add('');
Add('v2.2 beta 1 (28/06/2001)');
Add(' ������� ��� ���� ��� ���� :(');
Add(' �� �� ���� ��� ��������� � �����������!');
Add('  * ������� ��������� ID3v2');
Add('  * �������� ���� ���');
Add('  * ������� ���. �����:');
Add('    Speed Garage, Rapcore');
Add('');
Add('v2.1 beta 1 (18/03/2001)');
Add('  * ��������� �������������� � "0" ������!');
Add('  * ����������� MPEG-������');
Add('  * ��������� ID3v1.x, ID3v2.x � DID Tag-��');
Add('  * ��������� ���������� *.m3u, *.pls, *.nks');
Add('  * ������� ���. �����:');
Add('    Breakbeat, Garage, Progressive House');
Add('');
Add('');
Add('v2.00 beta 5 Src Crash! (09/04/Y2k)');
Add('  * ������� ��� ������������ ���� (HDD) :(((');
Add('    �� ����� �����������, MP3, Soft, Img, etc.');
Add('    �� ���� �������� NaviGatoR-� � ������ ���� ��������');
Add('    �� ����� ������������...');
Add('');
Add('v2.00 beta 5 (08/04/Y2k)');
Add('  * MP3 NaviGatoR ������� ������ ���������� �� ��������');
Add('    "���� ����������� 2000", ����, �����������, ������');
Add('    � ��������� "���������������� ��������"! �����! :)');
Add('');
Add('v2.00 beta 4 build 05/04/Y2k');
Add('  * ������ ����� ����������� DID - ������ !!!');
Add('  * ���������� ���� ������ ��� ������ � �������');
Add('  * ������ ��� ����� ������������� ����������� �� ������� ��������� INI-���� ��������� (mp3nav.ini)');
Add('');
Add('v2.00 beta 3 build 01/04/Y2k');
Add('  * ���������� ������������ ������ �������������� ID3');
Add('  * �������� ����� ��� ����-������ - *.nks, ������ ��������� ����������� ������� ������� (�������� ������ ������������� ����������� � ���� mp3nav.nks)');
Add('  * ��������� ��������� ������');
Add('  * ������ �������� ������� "������"');
Add('  * �������� ������ �� WaveOUT');
Add('  * ������� ��� ���� �������� - ������ ���������� ������ �������� � ����� ����� ������� � ������� ��������� �� "���������"');
Add('');
Add('v2.00 beta 2 build 26/03/Y2k');
Add('  * ������ ����� �� ������ ������������� PlayList-�, �� � ������ MPEGs !');
Add('  * �������� ��������� ��������� WaveOUT');
Add('  * ������ ������� PlayList ����������� ������������� (mp3nav.m3u).');
Add(' * ����� ������ ����� PlayList-�');
Add(' * ���������� ������');
Add('');
Add('v2.00 beta 1 build 10/03/Y2k');
Add('  * ������������������� ������, � ����� ������� ���������');
Add('    MP3 NaviGatoR ������ �����:');
Add('  * ������������� ID3 Tag (���������� � �����) ������ �����');
Add('  * ������������� ID3 Tag ������ ������');
Add('  * ��������� PlayList-� (*.m3u)');
Add('  * ��������� PlayList-� (*.m3u)');
Add('  * ���������� MPEG ����������');
Add('  * PlayList ����� ������������� �� ������ ��������� ID3 Tag: �������/��������/�����/�������/����/���������� , � ����� �� ����� ����� ��� ��� �������');
Add('  * ����� �������������� �������');
Add('  * ����� ������� �����');
Add('  * ��������� �������� � ReadOnly �������');
Add('');
Add('v1.00 beta 1 build 01/03/Y2k');
Add(' * ������ ��������� "����� � ����" MP3 NaviGatoR.');
Add(' * ������� ��������� �� ���� ��� ���������� :)');
Add('');
Add('*** �� 01/03/Y2k ***');
  end;

  with KeysMemo.Lines do
  begin
    Clear;

    Add('*** ������ ������, ������������ MP3 NaviGatoR-�� ***');
    Add('');
    Add('Alt+W'#9#9'������ ������ �����');
    Add('F12'#9#9'����� ������ ������ �����');
    Add('Alt+3'#9#9'������������� ������� ����');
    Add('Alt+E'#9#9'������������� �������. �����');
    Add('Alt+Z'#9#9'���������� �����');
    Add('Alt+X'#9#9'������������ (Play)');
    Add('Alt+C'#9#9'�����');
    Add('Alt+V'#9#9'����');
    Add('Alt+B'#9#9'�������� �����');
    Add('Alt+J'#9#9'����������� �� �����/�');
    Add('Alt+Up'#9#9'C������� ���������� ����� �� 1');
    Add('Alt+Down'#9#9'C������� ���������� ���� �� 1');
    Add('Alt+Home'#9#9'C������� ���������� � ������');
    Add('Alt+End'#9#9'C������� ���������� � �����');
    Add('Shift+Del'#9#9'������� ���� � �����');
    Add('Shift+Ins'#9#9'�������� ����(�)');
    Add('Ctrl+O'#9#9'�����');
    Add('Ctrl+F'#9#9'��������� �.�.');
    Add('Ctrl+R'#9#9'�������� ����������');
    Add('Ctrl+N'#9#9'������������� ���������� (!)');
    Add('Ctrl+L'#9#9'��������� ��������');
    Add('Ctrl+A'#9#9'�������� ���');
    Add('Ctrl+B'#9#9'�����/�������� ���������');
    Add('Ctrl+G'#9#9'������������� ����������');
    Add('Ctrl+C'#9#9'���������� �� ������');
    Add('Ctrl+D'#9#9'������ �� ���������');
    Add('Ctrl+H'#9#9'�������� ������� ����');
    Add('Ctrl+K'#9#9'����������� ���������� ����� ��������');
    Add('Ctrl+T'#9#9'�������� ��� �������');
    Add('Ctrl+Alt+E'#9#9'�������� ����������');
    Add('Ctrl+Del'#9#9'������� ����������� �� �.�.');
    Add('Ctrl+Alt+Shift+~'#9'"��������� ����" ("q" - �����)');
    Add('Ins'#9#9'�������� ���������(�/�)');
    Add('F1'#9#9'� ���������');
    Add('F3'#9#9'����������� �� �����/�');
    Add('F10'#9#9'�����');
  end;
end;

var Buf : TBitMap;
{    pHDC : HDC;{}

procedure TAboutBox.DoneGraphics;
begin
  if Buf <> nil then Buf.Free;
end;

// ����p������ � ������ ������� ������ � �p���� ����� size.
function CopyToMem(fpBlock1, fpBlock2: Pointer; Size: Cardinal): Boolean;
assembler;
asm
   push esi
   push edi
   pushfd
   cld
   mov  esi,fpBlock1
   mov  edi,fpBlock2
   mov  ecx,Size
   repe movsb
   popfd
   pop  edi
   pop  esi
end;

procedure TAboutBox.InitGraphics;
begin
{}
end;

procedure TAboutBox.DrawProc;
begin
(*
{  PaintImage.Canvas.Handle{}
  bitblt(pHDC,000,000,DrawImage.Width,DrawImage.Height,
         DrawImage.Canvas.Handle,000,000,SRCCOPY);

{  DisplayPara(i,15 + ptab[idx]);}
  DisplayPara(i,0);

  PaintImage.Canvas.Draw(0,0,Buf);
  bitblt(PaintImage.Canvas.Handle,000,000,Buf.Width,Buf.Height,
         pHDC,000,000,SRCCOPY);
  PaintImage.Repaint;
{  inc(idx,3);}
  inc(i,di); if (i < 5) or (i+xs > MaxX) then di := -di;
*)
end;

procedure ShowAboutBox;
begin
  if not ShowingAbout then
  begin
    ShowingAbout := true;
    with TAboutBox.Create(Application) do
    try
      Show;
     finally

    end;
  end;
end;

function GetCPUSpeed: Double;
const
  DelayTime = 500; // measure time in ms
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);

  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  Sleep(10);
  asm
//    dw 310Fh // rdtsc
    rdtsc
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
//    dw 310Fh // rdtsc
    rdtsc
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

  Result := TimerLo / (1000.0 * DelayTime);
end;

procedure TAboutBox.FormCreate(Sender: TObject);
var a,b,c,d : word;
    i : integer;
(*
    x,y,i : integer;
    trcol,bkcol,col : integer;
 *)
begin
{  DefinePriority(1,1,0);{}
  FirstShowAbout := true;
  PageControl.ActivePageIndex := 0;
  GetBuildInfo(a,b,c,d);
  Caption := Format('� ��������� %s', [(appName)]);
{  HomePageLinkLabel.Caption := HomePageLinkSt;}
{  ProgramIcon.Picture.Assign(Application.Icon);}
  ProgramName.Left := 0;
  ProgramName.Width := GeneralSheet.Width;
  ProgramName.Alignment := taCenter;
  ProgramName.Caption := appName + ' v' + inttostr(a)+'.'+inttostr(b)+'.'+inttostr(c)+' build '+inttostr(d);
{NiKeSoftImage}
{  if FirstShowAbout then{}
  with DrawImage.Picture do
  begin
(*
    Bitmap.TransparentMode  := tmFixed;
    Bitmap.PixelFormat      := pf4bit;
    Bitmap.TransparentColor := Bitmap.Canvas.Pixels[0,0];
    Bitmap.Transparent      := true;

    trcol := ColorToRGB(clBtnFace);
    bkcol := Bitmap.Canvas.Pixels[0,0];
    for x := 0 to Bitmap.Width-1 do
    for y := 0 to Bitmap.Height-1 do
    begin
      col := Bitmap.Canvas.Pixels[x,y];
      if (col <> bkcol) then
       Bitmap.Canvas.Pixels[x,y] := col
       else Bitmap.Canvas.Pixels[x,y] := trcol;
    end;
*)
  end;
  InitText;
  LinksBox.Items.Clear;
  for i := 1 to nLinks do LinksBox.Items.Add(Links[i].Link);
  LinksBox.ItemIndex := 0;
  LinksBox.OnChange(Self);
end;

procedure TAboutBox.TimerTimer(Sender: TObject);
begin
  if Initing then exit;
  Initing := true;
  if FirstShowAbout then
  begin
    FirstShowAbout := false;
    InitGraphics;
  end;
  DrawProc;
  Initing := false;
end;

procedure TAboutBox.HomePageLinkLabelClick(Sender: TObject);
begin
  ShellExecute(0,'open',NiKesHomePageAddr,nil,nil,SW_SHOWNORMAL);
end;

procedure TAboutBox.LinksBoxDblClick(Sender: TObject);
begin
  ShellExecute(0,'open',PChar(Links[LinksBox.ItemIndex+1].URL),nil,nil,SW_SHOWNORMAL);
end;

procedure TAboutBox.LinksBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (lo(Key) = 13) then ShellExecute(0,'open',PChar(Links[LinksBox.ItemIndex+1].URL),nil,nil,SW_SHOWNORMAL);
end;

procedure TAboutBox.LinksBoxChange(Sender: TObject);
begin
  if (LinksBox.ItemIndex >=0)and(LinksBox.ItemIndex < nLinks) then
  begin
{    LinksBox.Text := Links[LinksBox.ItemIndex+1].URL;}
    DescMemo.Lines.Clear;
    DescMemo.Lines.Add(Links[LinksBox.ItemIndex+1].Desc);
  end;
end;

procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer.Enabled := false;
  DoneGraphics;
  SetPriority;
  ShowingAbout := false;
  Action := caFree;
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.HomePageLinkLabelMouseEnter(Sender: TObject);
begin
  HomePageLinkLabel.Font.Color := clRed;
end;

procedure TAboutBox.HomePageLinkLabelMouseLeave(Sender: TObject);
begin
  HomePageLinkLabel.Font.Color := clBlue;
end;

end.

