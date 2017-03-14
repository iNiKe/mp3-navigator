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
    procedure PaintImageClick(Sender: TObject);
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

const NiKesHomePageAddr = 'http://www.NiKeSoft.ru';
      HomePageLinkSt    = 'NiKe''s HomePage ('+NiKesHomePageAddr+')';
      nLinks = 26;
      Links : array [1..nLinks] of tURLink =
(
 (URL:'http://www.winamp.com';Link:'www.winamp.com';Desc:'Официальный сайт рульного Winamp-а'),
 (URL:'http://napster.com';Link:'napster.com';Desc:'MP3 Music Network'#13#10'Просто скачайте Napster и установите его'#13#10'и ВЫ получите доступ к ТЕРРАбайтам MP3 !!!'),
 (URL:'http://www.musmania.ru';Link:'www.musmania.ru';Desc:'Музыкальный портал Приморья'#13#10'Целые альбомы разных исполнителей'#13#10'только для абонентов Primorye OnLine :('),
 (URL:'http://www.farpost.com/mp3';Link:'www.farpost.com/mp3';Desc:'Линки (aKa ссылки;) на проверенные сайты'),
 (URL:'http://www.farpost.com/5045/43.4/links.htm#mp3';Link:'www.farpost.com/5045/43.4';Desc:'Линки на MP3 сайты © NiGhthAWk 2:5045/43.4'),
 (URL:'http://www.allofmp3.com';Link:'www.allofmp3.com';Desc:'Неплохой интерфейс и подборка'),
 (URL:'http://www.mp3mp4.com';Link:'www.mp3mp4.com';Desc:'Куча всего, но можно "заблудиться"'),
 (URL:'http://mp3.ru';Link:'mp3.ru';Desc:'Русскоязычный портал MP3'),
 (URL:'http://mp3.com';Link:'mp3.com';Desc:'Буржуйский mp3 сайт ;)'),
 (URL:'http://omen.ru/music/MP3&RA.HTM';Link:'omen.ru/music/MP3&RA.HTM';Desc:'Русский mp3 сайт (OMEN)'),
 (URL:'http://www.mp3shits.com/charts/mtv.shtml';Link:'www.mp3shits.com/charts/mtv.shtml';Desc:'MTV Top20 MP3 сайт'),
 (URL:'http://www.altmp3.ru/';Link:'www.altmp3.ru';Desc:'mp3 сайт. Обмен файлами. Архив. Заказы'),
 (URL:'ftp://ftp.marine.su/pub/';Link:'ftp.marine.su/pub/';Desc:'ftp mp3 сайт во Владивостоке'),
 (URL:'ftp://ftp.stl.su/pub/music/';Link:'ftp.stl.su/pub/music/';Desc:'ftp mp3 сайт во Владивостоке [на СиТеле aka stl.ru]'),
 (URL:'http://top100.rambler.ru/top100/MP3/index.shtml.ru';Link:'top100.rambler.ru/top100/MP3/index.shtml.ru';Desc:'Rambler Top100 MP3'),
 (URL:'http://www.aria.ru';Link:'www.aria.ru';Desc:'Официальный сайт гр. АриЯ'),
 (URL:'http://www.dolphin.ipc.ru';Link:'www.dolphin.ipc.ru';Desc:'Официальный сайт Дельфина aKa Dolphin'),
 (URL:'http://www.guanoapes.com';Link:'www.GuanoApes.com';Desc:'Официальный сайт Guano Apes (Sandra Nasic & Co.)'),
 (URL:'http://www.guanoapes.org';Link:'www.GuanoApes.org';Desc:'Сайт про Guano Apes (Sandra Nasic & Co.)'),
 (URL:'http://www.guanoapes.al.ru';Link:'www.GuanoApes.al.ru';Desc:'Российский сайт про Guano Apes (Sandra Nasic & Co.)'),
 (URL:'http://guanoapes.jsa.ru';Link:'GuanoApes.jsa.ru';Desc:'Российский сайт-спонсор Guano Apes (Sandra Nasic & Co.)'),
 (URL:'http://users.erols.com/dcrouch/aon.htm';Link:'users.erols.com/dcrouch/aon.htm';Desc:'ArtOfNoise'),
 (URL:'http://Durden.cjb.net';Link:'Durden.cjb.net';Desc:'Fight Club: Tyler Durden/Brad Pitt, Edvard Norton'),
 (URL:'http://www.foxmovies.com/fightclub';Link:'www.foxmovies.com/FightClub';Desc:'Fight Club: Tyler Durden/Brad Pitt, Edvard Norton'),
 (URL:'http://www.paparoach.com';Link:'www.PapaRoach.com';Desc:'Официальный сайт группы Papa Roach (на Flash-e)'),
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
Add('*** MP3 NaviGatoR : Хроника Версий ***');
Add('v2.92 (19/11/2003)');
Add('  ! Исправил баг в Делфи7 (StdCtrls::ComboBoxStrings.Get)');
Add('    Теперь корректно отображается Таг-едитор');
Add('  * Качайте из сети (www.NiKeSoft.ru/?page=download)');
Add('  * Теперь MP3 NaviGatoR до выхода версии 3.x будет бесплатный!');
Add('');
Add('v2.9 (03/05/2003)');
Add('  * Перенесено под D7');
Add('  * Внесены изменения в код');
Add('  * База данных пополнена');
Add('  * Добален диалог "навигация по базе"');
Add('  * Использование функции FileInfo() из in_mp3.dll');
Add('  * Запущен www.NiKeSoft.ru, добро пожаловать!');
Add('');
Add('v2.8 (19/09/2002)');
Add('  * 1-я версия для сети');
Add('  * Пофикшены баги');
Add('');
Add('v2.7 (30/03/2002)');
Add('  * Интеграция с Базой Лириксов!');
Add('    ADO, M$ Jet.OLEDB.4.0');
Add('    удобный поиск/запрос');
Add('  * TAGs union Fix');
Add('  * Skin улучшен');
Add('  * LoadSkin bugFIX');
Add('  * TagEditor.OnLoad bugFIX');
Add('  * Volume/Balance bugFIX');
Add('  * Добавлены менюшки для Edit-ов:');
Add('    UPCASE, downcase, Первая Большая');
Add('  * Совместимость с XP');
(*
Add('  * ');
Add('    ');
*)
Add('  * "Косметические" фиксы');
Add('');
Add('v2.6a (25/02/2002)');
Add('  * Special build 4 U.S.A.');
Add('');
Add('v2.5 (07/01/2002)');
Add('  * Fix в групповой обработке');
Add('  * Fix в ID3v2 движке');
Add('  * Добавил доп. стили:');
Add('    IDM');
Add('');
Add('v2.4 (04/08/2001)');
Add('  * Небольшие фиксы');
Add('  * Добавил доп. стили:');
Add('    Jump Up');
Add('');
Add('v2.3 beta 1 (07/08/2001)');
Add('  * Теперь MP3 NaviGatoR использует DLL Winamp-a');
Add('    in_mp3.dll, out_*.dll, vis_*.dll!');
Add('    Радуйтесь и забудьте про тормоза :)');
Add('');
Add('v2.2 beta 3 (21/07/2001)');
Add('  * Теперь можно прочитать назначение клавиш :)');
Add('');
Add('v2.2 beta 1 (28/06/2001)');
Add(' Полетел еще один мой винт :(');
Add(' но на этот раз исходники я восстановил!');
Add('  * Изменил обработку ID3v2');
Add('  * Пофиксил кучу баг');
Add('  * Добавил доп. стили:');
Add('    Speed Garage, Rapcore');
Add('');
Add('v2.1 beta 1 (18/03/2001)');
Add('  * Полностью переработанная с "0" версия!');
Add('  * Продвинутый MPEG-парсер');
Add('  * Поддержка ID3v1.x, ID3v2.x и DID Tag-ов');
Add('  * Поддержка плейлистов *.m3u, *.pls, *.nks');
Add('  * Добавил доп. стили:');
Add('    Breakbeat, Garage, Progressive House');
Add('');
Add('');
Add('v2.00 beta 5 Src Crash! (09/04/Y2k)');
Add('  * Полетел мой единственный винт (HDD) :(((');
Add('    со всеми исходниками, MP3, Soft, Img, etc.');
Add('    На этом развитие NaviGatoR-а и других моих проектов');
Add('    на долго прекратилось...');
Add('');
Add('v2.00 beta 5 (08/04/Y2k)');
Add('  * MP3 NaviGatoR признан лучшей программой на конкурсе');
Add('    "Юный программист 2000", ДВГУ, Владивосток, Россия');
Add('    в номинации "инструментальные средства"! Рулез! :)');
Add('');
Add('v2.00 beta 4 build 05/04/Y2k');
Add('  * Теперь можно оперировать DID - Тагами !!!');
Add('  * Исправлена пара ошибок при работе с файлами');
Add('  * Теперь все опции автоматически сохраняются во внешний текстовый INI-файл программы (mp3nav.ini)');
Add('');
Add('v2.00 beta 3 build 01/04/Y2k');
Add('  * Исправлена серьезнейшая ошибка редактирования ID3');
Add('  * Добавлен новый тип плей-листов - *.nks, теперь программа запускается намного быстрее (Плейлист теперь автоматически сохраняется в файл mp3nav.nks)');
Add('  * Добавлена поддержка скинов');
Add('  * Убрана ненужная колонка "размер"');
Add('  * Добавлен баланс на WaveOUT');
Add('  * Изменен тип всех бегунков - теперь достаточно просто кликнуть в любом месте бегунка и позиция изменится на "кликнутую"');
Add('');
Add('v2.00 beta 2 build 26/03/Y2k');
Add('  * Теперь можно не только редактировать PlayList-ы, но и играть MPEGs !');
Add('  * Добавлен регулятор громкости WaveOUT');
Add('  * Теперь текущий PlayList сохраняется автоматически (mp3nav.m3u).');
Add(' * Можно менять шрифт PlayList-а');
Add(' * Исправлены ошибки');
Add('');
Add('v2.00 beta 1 build 10/03/Y2k');
Add('  * Усовершенствованная версия, в корне изменен интерфейс');
Add('    MP3 NaviGatoR теперь может:');
Add('  * Редактировать ID3 Tag (информацию о песне) одного файла');
Add('  * Редактировать ID3 Tag группы файлов');
Add('  * Загружать PlayList-ы (*.m3u)');
Add('  * Сохранять PlayList-ы (*.m3u)');
Add('  * Показывать MPEG информацию');
Add('  * PlayList можно отсортировать по любому параметру ID3 Tag: Артисту/Названию/Жанру/Альбому/Году/Коментарию , а также по имени файла или его размеру');
Add('  * Легко манипулировать файлами');
Add('  * Может удалять файлы');
Add('  * Корректно работает с ReadOnly файлами');
Add('');
Add('v1.00 beta 1 build 01/03/Y2k');
Add(' * Первый публичный "Выход в свет" MP3 NaviGatoR.');
Add(' * Простой интерфейс не даст вам потеряться :)');
Add('');
Add('*** От 01/03/Y2k ***');
  end;

  with KeysMemo.Lines do
  begin
    Clear;

    Add('*** Список Клавиш, используемых MP3 NaviGatoR-ом ***');
    Add('');
    Add('Alt+W'#9#9'Запрос текста песни');
    Add('F12'#9#9'Новый запрос текста песни');
    Add('Alt+3'#9#9'Редактировать текущий файл');
    Add('Alt+E'#9#9'Редактировать выделен. файлы');
    Add('Alt+Z'#9#9'Предыдущая песня');
    Add('Alt+X'#9#9'Проигрывание (Play)');
    Add('Alt+C'#9#9'Пауза');
    Add('Alt+V'#9#9'Стоп');
    Add('Alt+B'#9#9'Следущая песня');
    Add('Alt+J'#9#9'Перескочить на песню/и');
    Add('Alt+Up'#9#9'Cдвинуть выделенное вверх на 1');
    Add('Alt+Down'#9#9'Cдвинуть выделенное вниз на 1');
    Add('Alt+Home'#9#9'Cдвинуть выделенное в начало');
    Add('Alt+End'#9#9'Cдвинуть выделенное в конец');
    Add('Shift+Del'#9#9'Удалить Файл с Диска');
    Add('Shift+Ins'#9#9'Добавить файл(ы)');
    Add('Ctrl+O'#9#9'Опции');
    Add('Ctrl+F'#9#9'Выровнять П.Л.');
    Add('Ctrl+R'#9#9'Обновить выделенное');
    Add('Ctrl+N'#9#9'Переименовать выделенное (!)');
    Add('Ctrl+L'#9#9'Загрузить плейлист');
    Add('Ctrl+A'#9#9'Выделить все');
    Add('Ctrl+B'#9#9'Показ/спрятать заголовки');
    Add('Ctrl+G'#9#9'Сгруппировать выделенное');
    Add('Ctrl+C'#9#9'Разместить по центру');
    Add('Ctrl+D'#9#9'Размер по умолчанию');
    Add('Ctrl+H'#9#9'Показать текущий файл');
    Add('Ctrl+K'#9#9'Переместить выделенное после играющей');
    Add('Ctrl+T'#9#9'Изменить вид времени');
    Add('Ctrl+Alt+E'#9#9'Обновить выделенное');
    Add('Ctrl+Del'#9#9'Удалить невыделеное из П.Л.');
    Add('Ctrl+Alt+Shift+~'#9'"Секретное меню" ("q" - выход)');
    Add('Ins'#9#9'Добавить директори(ю/и)');
    Add('F1'#9#9'О Порграмме');
    Add('F3'#9#9'Перескочить на песню/и');
    Add('F10'#9#9'Опции');
  end;
end;

var Buf : TBitMap;
{    pHDC : HDC;{}

procedure TAboutBox.DoneGraphics;
begin
  if Buf <> nil then Buf.Free;
end;

// Копиpование с одного участка памяти в дpугой длины size.
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
  Caption := Format('О программе %s', [(appName)]);
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

procedure TAboutBox.PaintImageClick(Sender: TObject);
begin
  ShellExecute(0,'open',NiKesHomePageAddr,nil,nil,SW_SHOWNORMAL);
end;

end.

