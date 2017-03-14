Unit Main;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, CommCtrl, MPGTOOLs, Menus, IniFiles,
  StdCtrls, UPTTreeList, FPTFolderBrowseDlg, FPTOpenDlg, Options, ExtCtrls,
  RenmUnit, MMSystem, SrchUnit, Winamp, IO, JPEG;

const
{$IFDEF _DEMO_}
      Demo_Count = 25;
      appName  = 'MP3 NaviGatoR DEMO';
      appVer   = 'v2.92d';
{$ELSE}
      appName  = 'MP3 NaviGatoR';
      appVer   = 'v2.92';
{$ENDIF}

      appBuildDate = '19/11/2003'; {DD/MM/YYYY}

      INIFileName = 'mp3nav.ini';
      PLAFileName = 'mp3nav.nks';
      NavigatorSection = 'MP3 NaviGatoR';
      PlayListSection  = 'PlayList';
      PLSSection       = 'playlist';

const RegPathAutoRun = '\Software\Microsoft\Windows\CurrentVersion\Run';
      RegPath        = '\Software\NiKe''Soft\'+appName;

      STimerInt = 100;
      NTimerInt = 300;

const pmNormal  = 0;
      pmRandom  = 1;
{      pmReverse = 2;}

      smNone     = 32;
      smRandom   = 33;
      smMask     = 34;

      SortMode : integer = smNone;
      LastSort : integer = smNone;
      RevSort  : boolean = false;

      DefPlayListsMask    = '%A% - %T% {%G%}';
      DefPlayListMask     = '%A% - %T% {%G%}';
      DefScrollMask       = '%A% - %T% {%G%}';
      DefPrecision        = 200000;
      DefFileNameMask     = '%A% - %T%';
      DefDelimiter        = ' - ';
      DefScanPlayTime     = 20000;

      WM_WA_MPEG_EOF      = WM_USER+2; {!!!!!!!!!!!!!!}

const ScrollText : string = appName;

var PlayMode         : byte = pmNormal;
    ScanPlay         : boolean = false;
    ScanPlayTime     : integer = DefScanPlayTime;
    PlayManual       : boolean = false;
    SaveWinPos       : boolean = false;
    SaveWinSiz       : boolean = false;
    FocusDel         : boolean = false;
    MakeExtM3U       : boolean = true;
    AutoPlay         : boolean = false;
    EnableWritePlay  : boolean = true;
    SaveROINI        : boolean = true;
    RecursiveDirs    : boolean = true;
    ConfDiskDel      : boolean = true;
    ConfClearList    : boolean = false;
    ConfExit         : boolean = false;
{      ConfEdtRO        : boolean = false;{}
    ConfDelRO        : boolean = false;
    MinimizeRun      : boolean = false;
    Fading           : boolean = false;
    FadedStart       : boolean = false;
    AskFileMask      : boolean = true;
    FocusAfterChangeSong : boolean = true;
    FadingTime       : integer = 0;
    FadedStartTime   : integer = 0;
    DetectPrecision  : integer = DefPrecision;
    PlayListsMask    : string = DefPlayListsMask;
    PlayListMask     : string = DefPlayListMask;
    FileNameMask     : string = DefFileNameMask;
    ScrollMask       : string = DefScrollMask;
    LastOpenDir      : string = '';
    LastFileDir      : string = '';
    SaveListLastDir  : string = '';
    LoadListLastDir  : string = '';
    SkinsPath        : string = '';
    PlugsPath        : string = '';
    FirstActivate    : boolean = true;
    FirstFormShow    : boolean = true;
    Delimiter        : string = DefDelimiter;
    DefFormWidth     : integer = 240+155 + 25*1;
    DefFormHeight    : integer = 32+70 + 29*10;
    stCustomColors   : string = '';
    SaveListAfterChange : boolean = true;
    ConfGroupNameEdit : boolean = true;
    ConfNonExist      : boolean = true;
    MainPriority   : integer = 2;
    ThreadPriority : integer = 5;
    SecretThreadPriority : integer = 0;
    ScrollTimerPriority : integer = 3;
    PlayingColor : integer = clLime;
    TotalTime : integer = 0;
    SnapWindow : boolean = false;
    Threshold  : Integer = 10;
    SecretActivated : boolean = false; // :)
    FirstScrollTimer : boolean = true;
    PlayTimeSt : string = '';
    TimeDec : boolean = true;
    Activ1 : boolean = false;
    EQVisible : boolean = false;
    EQData : TGPFWinAmpInputPluginEQData = (127,127,127,127,127,127,127,127,127,127);
    EQPreAmp : integer = 127;
    EQisOn : boolean = false;
    EQAuto : boolean = false;
    eqX : integer = 0;
    eqY : integer = 0;
    OutPlugName : string = 'out_wave.dll';
    VisPlugName : string = '';
    CurMPA : tMPEGAudio;
    simg : TJPEGImage;
    drawimg : tbitmap;
    stoppressed : boolean = false;
    drawingvis : boolean = false;
    obal,ovol : integer;

const stExit = 'Действительно Хотите Выйти?';
      stMinimize = 'Нормализовать';
      stMaximize = 'Максимизировать';

type tBtn = record
        x,y : integer;
        w,h : integer;
        sX1,sY1 : integer;
        sX2,sY2 : integer;
        s       : integer;
        t       : integer;
     end;

const nBtns = 15;
      aBtns : array [1..nBtns] of tBtn =
      ((x:012;y:147;w:025;h:021;sX1:111;sY1:113;sX2:111;sY2:134;s:0;t:0), // 01 Add
       (x:040;y:147;w:025;h:021;sX1:137;sY1:113;sX2:137;sY2:134;s:0;t:0), // 02 Del
       (x:068;y:147;w:025;h:021;sX1:163;sY1:113;sX2:163;sY2:134;s:0;t:0), // 03 Sel
       (x:096;y:147;w:025;h:021;sX1:189;sY1:113;sX2:189;sY2:134;s:0;t:0), // 04 Msc
       (x:125;y:148;w:021;h:018;sX1:000;sY1:113;sX2:000;sY2:131;s:0;t:0), // 05 Prev
       (x:148;y:148;w:021;h:018;sX1:022;sY1:113;sX2:022;sY2:131;s:0;t:0), // 06 Play
       (x:171;y:148;w:021;h:018;sX1:044;sY1:113;sX2:044;sY2:131;s:0;t:0), // 07 Pause
       (x:194;y:148;w:021;h:018;sX1:066;sY1:113;sX2:066;sY2:131;s:0;t:0), // 08 Stop
       (x:217;y:148;w:021;h:018;sX1:088;sY1:113;sX2:088;sY2:131;s:0;t:0), // 09 Next
       (x:410;y:146;w:021;h:021;sX1:215;sY1:113;sX2:215;sY2:134;s:0;t:0), // 10 Save

       (x:003;y:004;w:021;h:021;sX1:293;sY1:000;sX2:293;sY2:021;s:0;t:0), // 11 Menu

       (x:002;y:004;w:021;h:021;sX1:229;sY1:000;sX2:229;sY2:021;s:0;t:0), // 12 Minimize
       (x:002;y:004;w:021;h:021;sX1:250;sY1:000;sX2:250;sY2:021;s:0;t:0), // 13 Maximize
       (x:002;y:004;w:021;h:021;sX1:271;sY1:000;sX2:271;sY2:021;s:0;t:0), // 14 Close

       (x:000;y:000;w:047;h:015;sX1:182;sY1:186;sX2:182;sY2:201;s:0;t:1)  // 15 Normal-Shuffle
      );


type tUpdateSliderEvent = procedure (var s) of object;

type pMySlider = ^tMySlider;
     tMySlider = class(TObject)
       private
         fLeft,fTop : integer;
         fWidth,fHeight : integer;
         fMinPos,fMaxPos : integer;
         fPosition : integer;
         fSliderVisible : boolean;
         fUpdateEvent : tUpdateSliderEvent;
         fTransparent : boolean;
         fTransColor : integer;
         fVertical : boolean;
         Seeking : boolean;
         AutoSeek : boolean;

         procedure SetTopPos(x : integer);
         procedure SetLeftPos(x : integer);
         procedure SetWidth(x : integer);
         procedure SetHeight(x : integer);
         procedure SetMinPos(x : integer);
         procedure SetMaxPos(x : integer);
         procedure SetPosition(x : integer);
         procedure SetVisible(b : boolean);

       public
         sx1,sy1,sx2,sy2 : integer;
         sw,sh : integer;

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

type
  TMainForm = class(TForm)
    MySysMenu: TPopupMenu;
    N1: TMenuItem;
    smiTerminate: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    smiOptions: TMenuItem;
    smiSaveListAs: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    smiLoadList: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    TAG1: TMenuItem;
    TAG2: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    smiDeleteNonExisting: TMenuItem;
    smiClearList: TMenuItem;
    N25: TMenuItem;
    smiScanPlay: TMenuItem;
    smiNormalMode: TMenuItem;
    smiRandomMode: TMenuItem;
    smiManualPlay: TMenuItem;
    smiEditSelTags: TMenuItem;
    smiReReadSel: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    smiGroupSel: TMenuItem;
    smiMoveSelToBegin: TMenuItem;
    smiFindInList: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    smiSelSendToWinamp: TMenuItem;
    smiSelSendToDir: TMenuItem;
    ItemsPopUp: TPopupMenu;
    mpPlay: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    mpDelSelFromDisk: TMenuItem;
    mpEditTag: TMenuItem;
    mpClearList: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    mpMoveSelToBegin: TMenuItem;
    mpMoveSelToEnd: TMenuItem;
    mpMoveSelUp: TMenuItem;
    mpMoveSelDown: TMenuItem;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    N57: TMenuItem;
    N58: TMenuItem;
    N59: TMenuItem;
    N60: TMenuItem;
    N61: TMenuItem;
    N62: TMenuItem;
    N63: TMenuItem;
    mpSelEditTags: TMenuItem;
    mpGroupSel: TMenuItem;
    mpDelCurFile: TMenuItem;
    mpDelSel: TMenuItem;
    SaveListDlg: TPTSaveDlg;
    OpenFolderDlg: TPTFolderBrowseDlg;
    OpenDlg: TPTOpenDlg;
    smiSendList: TMenuItem;
    Winamp1: TMenuItem;
    N2: TMenuItem;
    LoadListDlg: TPTOpenDlg;
    N7: TMenuItem;
    N8: TMenuItem;
    N12: TMenuItem;
    N22: TMenuItem;
    TAG3: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    AddPopupMenu: TPopupMenu;
    N45: TMenuItem;
    N46: TMenuItem;
    DelPopupMenu: TPopupMenu;
    N47: TMenuItem;
    N50: TMenuItem;
    N51: TMenuItem;
    N52: TMenuItem;
    N53: TMenuItem;
    N64: TMenuItem;
    N65: TMenuItem;
    SelPopupMenu: TPopupMenu;
    N66: TMenuItem;
    N67: TMenuItem;
    N68: TMenuItem;
    MscPopupMenu: TPopupMenu;
    TAG4: TMenuItem;
    TAG5: TMenuItem;
    N69: TMenuItem;
    LoadPopupMenu: TPopupMenu;
    N70: TMenuItem;
    N71: TMenuItem;
    N72: TMenuItem;
    N73: TMenuItem;
    N74: TMenuItem;
    N75: TMenuItem;
    N76: TMenuItem;
    N77: TMenuItem;
    N78: TMenuItem;
    N79: TMenuItem;
    N80: TMenuItem;
    N81: TMenuItem;
    N82: TMenuItem;
    N83: TMenuItem;
    N84: TMenuItem;
    N85: TMenuItem;
    N86: TMenuItem;
    N87: TMenuItem;
    N88: TMenuItem;
    N89: TMenuItem;
    N90: TMenuItem;
    N91: TMenuItem;
    N92: TMenuItem;
    N93: TMenuItem;
    smiMaxMin: TMenuItem;
    N95: TMenuItem;
    SecretImg: TImage;
    ScrollTimer: TTimer;
    SecretEdit: TEdit;
    N94: TMenuItem;
    N96: TMenuItem;
    N97: TMenuItem;
    N98: TMenuItem;
    N99: TMenuItem;
    smiMouseEn: TMenuItem;
    smiEQ: TMenuItem;
    N100: TMenuItem;
    PlayList: TPTListView;
    miShowColHeaders: TMenuItem;
    N101: TMenuItem;
    inmp3dll1: TMenuItem;
    N102: TMenuItem;
    inmp3dll2: TMenuItem;
    FileInfo1: TMenuItem;
    N103: TMenuItem;
    N104: TMenuItem;
    N105: TMenuItem;
// Message Handlers
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMWAMPEGEOF(var Message: TMessage); message WM_WA_MPEG_EOF;
//    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHitTest;
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
(*
    procedure WMPaint(var m: TWMPaint); message WM_PAINT;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
*)

    procedure smiTerminateClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N60Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure N56Click(Sender: TObject);
    procedure N58Click(Sender: TObject);
    procedure N57Click(Sender: TObject);
    procedure mpPlayClick(Sender: TObject);
    procedure mpEditTagClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PlayListDeletion(Sender: TObject; Item: TListItem);
    procedure smiOptionsClick(Sender: TObject);
    procedure PlayListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PlayListItemContextMenu(aSender: TObject; aItem: TListItem;
      var aPos: TPoint; var aMenu: TPopupMenu);
    procedure smiEditSelTagsClick(Sender: TObject);
    procedure TAG3Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure PlayListColumnClick(Sender: TObject; Column: TListColumn);
    procedure N16Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure PlayListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mpSelEditTagsClick(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure mpDelCurFileClick(Sender: TObject);
    procedure mpDelSelClick(Sender: TObject);
    procedure mpDelSelFromDiskClick(Sender: TObject);
    procedure mpGroupSelClick(Sender: TObject);
    procedure mpMoveSelToBeginClick(Sender: TObject);
    procedure smiNormalModeClick(Sender: TObject);
    procedure smiRandomModeClick(Sender: TObject);
    procedure smiReReadSelClick(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure smiSaveListAsClick(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure smiDeleteNonExistingClick(Sender: TObject);
    procedure smiGroupSelClick(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure smiClearListClick(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure smiLoadListClick(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N39Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure N40Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure SetDefSize;
    procedure CenterPos;
    procedure N46Click(Sender: TObject);
    procedure N45Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure N47Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N50Click(Sender: TObject);
    procedure N66Click(Sender: TObject);
    procedure N67Click(Sender: TObject);
    procedure N68Click(Sender: TObject);
    procedure N69Click(Sender: TObject);
    procedure TAG5Click(Sender: TObject);
    procedure TAG4Click(Sender: TObject);
    procedure N72Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure N70Click(Sender: TObject);
    procedure N75Click(Sender: TObject);
    procedure N76Click(Sender: TObject);
    procedure N78Click(Sender: TObject);
    procedure N80Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N79Click(Sender: TObject);
    procedure N82Click(Sender: TObject);
    procedure PlayListDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure smiScanPlayClick(Sender: TObject);
    procedure smiManualPlayClick(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure TAG1Click(Sender: TObject);
    procedure TAG2Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N84Click(Sender: TObject);
    procedure N90Click(Sender: TObject);
    procedure N91Click(Sender: TObject);
    procedure N86Click(Sender: TObject);
    procedure N87Click(Sender: TObject);
    procedure N88Click(Sender: TObject);
    procedure ScrollTimerTimer(Sender: TObject);
    procedure smiFindInListClick(Sender: TObject);
    procedure N92Click(Sender: TObject);
    procedure smiMaxMinClick(Sender: TObject);
    procedure N93Click(Sender: TObject);
    procedure N95Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SecretEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N94Click(Sender: TObject);
    procedure N96Click(Sender: TObject);
    procedure N97Click(Sender: TObject);
    procedure mpMoveSelToEndClick(Sender: TObject);
    procedure mpMoveSelUpClick(Sender: TObject);
    procedure mpMoveSelDownClick(Sender: TObject);
    procedure PlayListInsert(Sender: TObject; Item: TListItem);
    procedure N7Click(Sender: TObject);
    procedure mpClearListClick(Sender: TObject);
    procedure smiMouseEnClick(Sender: TObject);
    procedure PlayListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure smiEQClick(Sender: TObject);
    procedure LoadSimgProgr(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
    procedure SecretEditKeyPress(Sender: TObject; var Key: Char);
    procedure miShowColHeadersClick(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure N102Click(Sender: TObject);
    procedure FileInfo1Click(Sender: TObject);
    procedure N104Click(Sender: TObject);
    procedure PlayListAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure SecretImgClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;

  public
    { Public declarations }
    procedure MainSliderUpdate(var s);
    procedure VolSliderUpdate(var s);
    procedure BalSliderUpdate(var s);
    procedure HorTrackSliderUpdate(var s);
    procedure VerTrackSliderUpdate(var s);
    procedure DoMinimize;
    procedure DoMaximize;
  end;

const MaxMyListItems = 70000;

type pMPLItem = ^tMPLItem;
     tMPLItem = record
       fName    : string;
       TagTitle : string;
       Title    : string;
       Artist   : string;
       Album    : string;
       Year     : string;
       Comment  : string;
       Genre    : string;
       MPA      : tMPEGAudio;
       nPlayed  : integer;
       Selected : boolean;
       Time,
       StartTime,
       EndTime  : integer;
       Flag     : boolean;
     end;

const MaxMyColumns = 100;

type  tMyColumn = record
         Caption : string;
         Width   : integer;
      end;

type pMyList = ^tMyList;
     tMyList = record
       Items : array[1..MaxMyListItems] of tMPLItem;
       Count : integer;

       TopItem,
       PlayItem,
       CurItem : integer;
// Colors
       NormBG,
       iCurBG,
       iSelBG,
       iNormFG,
       iCurFG,
       iPlayFG : integer;

       posX,posY,
       Width,Height : integer;
       ItemHeight   : integer;
       ScrollX : integer;
       Columns : array[1..MaxMyColumns] of tMyColumn;
       ColumnsHeight : integer;

       ViewType : integer;

       ListBMP : TBitmap;
     end;

const vtWinamp = 1;
      vtMP3Nav = 0;

      NumVisBuf = 1000;

type tIntVisData = array [0..50000] of byte;
     pVisArr = ^tVisArr;
     tVisArr = array[0..1,0..575] of byte;
     pVisData = ^tVisData;
     tVisData = record
       a : tVisArr;
       ts : integer; // TimeStamp
       n : pVisData;
     end;


var MainForm : TMainForm;
    VisPH,VisPT,VisBH,VisBT : pVisData;
    myPlayList : tMyList;
    BasePath : string;
    Skin,Buf : TBitMap;
    FontBmp  : TBitMap;
    EQSkin   : TBitMap;
    EQBuf    : TBitMap;
    StopProc : boolean;
    mX,mY    : integer;
    Dragged,Sizing : boolean;
    dnBt,dnBts : integer;
    mfw,mfh,mfl,mft : integer;
    DoNotFree : boolean = false;
    MainSlider,VolSlider,BalSlider,HorTrack,VerTrack : tMySlider;
    Creating : boolean = true;
    Painting : boolean = false;
    LastPlayed : integer = -1;
    Dontseek : boolean; {means that slider has to be updated}
    MovingItems : boolean = false;
    IsPlaying : boolean = false;
    Sct : integer = 0;
    OldMaxX,OldMaxY,OldMaxW,OldMaxH : integer;
    IsMaximized : boolean = false;
    IsActive : boolean = false;
    Captured : boolean = false;

    hOutDLL,hInDLL,hVisDLL : HINST;
    getinfunc : winampGetInModule2func;
    getoufunc : winampGetOutModulefunc;
    getvifunc : winampVisGetHeaderfunc;
    p : pointer;

    StopAfterCur : boolean = false;
    Stopping     : boolean = false;
    MouseEn      : boolean = true;
    ScrollingItems : boolean = false;
    osX,osY : integer;
    IntVisData : tIntVisData;
    IntVisBPS : integer = 8;
    IntVisNCH : integer = 2;
    VisStamp : integer = 0;
    SecretShowVis : boolean = false;
    FadingStopping : boolean = false;
    FadingCounter : integer = 0;
    FirstSecret1Activate : boolean = true;
    visPut : integer = 0;
    exited : boolean = false;
    exiting : boolean = false;

const StampTime = 5;

{$IFDEF _DEMO_}
procedure ShowDemoMsg;
{$ENDIF}

function  AddSlash(Path : string) : string;
function  AddDir(Path : string; ps : integer) : integer;
procedure AddDirs;
function  AddFile(FileName : string; ft,ps : integer) : integer;
procedure AddFiles;

function  SavePLSList (FileName : string; RelativePath,SelectedOnly : Boolean) : integer;
function  SaveM3UList (FileName : string; RelativePath,SelectedOnly : Boolean) : integer;
function  SaveNKSList (FileName : string; RelativePath,SelectedOnly : Boolean) : integer;
function  LoadPLSList (FileName : string) : integer;
function  LoadM3UList (FileName : string) : integer;
function  LoadNKSList (FileName : string) : integer;
procedure SavePlayList;
procedure SaveList(FileName : string; ft : integer; seOnly : boolean);
procedure SaveListAs(seOnly : boolean);
procedure LoadList(clr : boolean);

procedure SetEQVisible(v : boolean);
procedure ClearList;
procedure RenameSelected;
procedure DelNonExisting;
procedure DelSelFromList;
procedure DelSelFromDisk;
procedure DelCurFromList;
procedure DelCurFromDisk;
procedure GroupSelected;
procedure MoveSelToCur;
procedure EditCurTAG;
procedure EditSelTags;
function  RefreshItem(it : tListItem) : integer;
procedure RefreshItems(sel : boolean);
procedure MoveItem(j,n : integer);
procedure MoveSel(n : integer);
procedure MoveSelHome;
procedure MoveSelEnd;
procedure SelectZero;
procedure SelectAll;
procedure SelectInvert;
procedure RandomizeList;
procedure SortBy(sm : integer);
procedure PlayListAutoFit;
procedure DoPlayTimeSt;

procedure ToggleHeaders;
procedure SetHeaders(v : boolean);
procedure PaintSkin;
procedure AppExit;
procedure CheckItem(li : tListItem);
function  DecodeTimeSt(ts : string) : integer;
procedure SetSizes(w,h : integer);
procedure GetBuildInfo(var V1, V2, V3, V4: Word);
function  CorFormHeight(x : integer) : integer;
function  CorFormWidth(x : integer) : integer;
function  nHitBtn(hx,hy : integer) : integer;
procedure PushBtn(b : integer; var s : integer; Button: TMouseButton; Shift: TShiftState; x,y : integer);
procedure PlayListOnChange;
procedure SetPriority;
procedure DefinePriority(m,t : integer);

procedure SetPlayMode(pm : integer);
procedure PlayItem(i : integer);
procedure TogglePause;
procedure OnStopPlaying;
procedure PlayCurrent;
procedure PlayStop;
procedure PlayFadedStop;
procedure PlayPause;
procedure PlayUnPause;
procedure PlayNext;
procedure PlayPrev;
procedure PlayWind(t : integer);
procedure PlayFFWD5s;
procedure PlayReWind5s;
procedure PlayFile(s : string);
function  GetWaveVolume: DWord;
procedure SetWaveVolume(const AVolume: DWord);
procedure mySetBal;
procedure mySetVol;
procedure mySetVolume;

procedure SetCurSizes;
procedure SetTopItem(it : integer);
function  ValidLP(lp : integer) : boolean;
procedure WriteMySt(s : string; x,y,maxl : integer);
procedure DelDupes;
procedure UpdateScrollTxt;
procedure GetTagFromName(Name : string; var Band,Title,Album,Year : string; var Track : integer);
function  InitSoundSystem : boolean;
procedure SetMouseEn(s : boolean);
procedure SetManualPlay(s : boolean);
procedure SetScanPlay(s : boolean);
procedure SetTimeDec(s : boolean);
procedure VolumeUp;
procedure VolumeDown;
function  ReMax(v,OldMax,NewMax : integer) : integer;
procedure InitMatrixWorms;
procedure LoadJPEGFromRes(jname : string);
function  ItemFileExists(i : integer) : boolean;

procedure InitMyPlayList;
procedure SetMyListFont(fontname : string; size : integer);
procedure RecalcMyListH;
procedure SetMyListFnt(const Fnt : tFont);
procedure DrawMyItem(i,x,y : integer);
procedure DrawMyList;
function  AddMyListItem(si : integer) : integer;
function  TrySkinPath(s : string) : boolean;
procedure DoReqLyr;

var OutPlug : pGPFWinAmpOutputPurposePlugin;
    InPlug  : pGPFWinAmpInputPurposePlugin;
    VisPlug : pGPFWinAmpInputPurposePlugin;

function MakeSQLStr(s : string) : string;

  Implementation uses About,edUnit,GEdUnit,StatUnit,MaskAsk,ShellApi,uProgres,Quotes,
  EQUnit, ReqLyrUnit, demo;

{$R *.DFM}
{$R SIMG.RES}

var pHDC     : HDC;{}
    hTaskBar : HWND;
    hBar     : HWND;
    hStart   : HWND;
    hTray    : HWND;
    hClock   : HWND;
    secOldX,secOldY,secOldW,secOldH : integer;
    MatrixW,MatrixH : integer;
    TimeTicks : integer;
    Dropping : boolean = false;

const skinchars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ"@   '+
                  '0123456789_ :()-''!_+\/[]^&%.=$#'+
                  '   ?                           ';
      WAVE_MAPPER = $FFFF{UINT(-1)};

const MaxMatrixWormTail = 512;
type tMatrixWormTail = array [1..MaxMatrixWormTail] of integer;
     tMatrixWorm = record
        x,y : integer;
        Spd : integer;
        Tail : tMatrixWormTail;
        Dir  : integer;
        TailLen : integer;
        Alive : boolean;
      end;
      tMatrixDot = record
        x,y : integer;
        Spd : integer;
        dot : integer;
        st  : integer;
        Dir : integer;
      end;
      tMatrixMovingImg = record
        x,y : integer;
        spd : integer;
        dir : integer;
        sh,sw : integer;
        sx,sy : integer;
        mx,my : integer;
      end;

const MaxMatrixWorms = 200;
      MaxMatrixMovingImg = 5;

var mWorms  : array [1..MaxMatrixWorms] of tMatrixWorm;
    mDots   : array [1..MaxMatrixWorms] of tMatrixDot;
    mMoveImg : array[1..MaxMatrixMovingImg] of tMatrixMovingImg;
    nWorms,nMoveImg : integer;

{$IFDEF _DEMO_}
procedure ShowDemoMsg;
begin
  DMGForm.ShowModal;
//  MessageDlg('У Вас Демо-версия программы, сохранение настроек и другие полезные функции доступны только в полной зарегистрированной версии, которую вы можете приобрести по адресу '#13#13'http://www.NiKeSoft.ru',mtWarning,[mbok],0);
end;
{$ENDIF}

procedure GetTagFromName(Name : string; var Band,Title,Album,Year : string; var Track : integer);
var ts,s : string;
    DelimiterPos,k,i,j,trklen : integer;
begin
  s := ExtractFileName(Name);
  j := length(s);
  while (j > 0)and(s[j] <> '.') do dec(j);
  if j > 0 then s := Trim(copy(s,1,j-1));
  for i := 1 to length(s) do if s[i] = '_' then s[i] := ' ';
  Band   := '';
  Title  := s;
//  Title  := '';
  Album  := '';
  Year   := '';
  Track  := 0;
  if length(s) < 3 then
  begin
// 13.mp3
//    Title := s;
    val(s,i,j);
    if (j = 0)and(i > 0) then Track := i;
  end else
  if s[1] = '(' then
  begin
// ? (Bonus).mp3
    i := pos(')-',s);
    if i > 0 then
    begin
// (Era-Infinity(98)-05_Flovers_of_the_sea.mp3
//? (A-Ha-Garage_Days_Re-Visited(98)-05_Flovers_of_the_sea.mp3
      ts := copy(s,2,i-1);
      j := length(ts);
      while (j > 0)and(ts[j] in ['0'..'9']) do dec(j);
      Year := trim(copy(ts,j+1,4));
      ts := copy(ts,1,j);
      val(s,j,k);
      if (k = 0)and(j > 0) then
      begin
        if j < 30 then Year := '20'+lz(j,2,'0') else Year := '19'+lz(j,2,'0')
      end;
      ts := copy(s,i+2,length(s));
      k := pos('-',ts);
      if k > 0 then
      begin
        Band := trim(copy(ts,1,k-1));
        Album := trim(copy(ts,k+1,length(ts)));
      end;
      j := 1;
      while (j <= length(ts))and(ts[j] in ['0'..'9']) do inc(j);
      Title := trim(copy(ts,j,length(ts)));
      ts := copy(ts,1,j-1);
      val(ts,i,j);
      if j = 0 then
      begin
        Track := i;
      end;
    end else Title := s;
  end else
  begin
// 01. Track01Name.mp3
// 02 - Track02Name.mp3
// 01TrackName.mp3
// Track04.mp3
// Artist - Title.mp3
    trklen := 0;
    if (length(s) > 3)and(s[1] in ['0'..'9'])and(s[2] in ['0'..'9']) then
    begin
      if copy(s,3,2) = '. ' then trklen := 4 else
       if copy(s,3,3) = ' - ' then trklen := 5;
    end;
    if trklen > 0 then
    begin
      Track := (ord(s[1])-ord('0'))*10;
      Track := Track+ord(s[2])-ord('0');
      system.delete(s,1,trklen);
      s := TrimLeft(s);

      for DelimiterPos := Length (s) downto 1 do if s[DelimiterPos] = '.' then
      begin
        s := Copy (s, 1, DelimiterPos - 1);
        break;
      end;
      Title := s;
    end else
    begin
      DelimiterPos := Pos (Delimiter, s);
      If DelimiterPos > 0 then
        s := Trim (Copy (s, 1, DelimiterPos - 1))
      else s := '';
      Band := s;
      s := ExtractFileName(Name);
      DelimiterPos := Pos (Delimiter, s);
      if DelimiterPos > 0 then
        s := Trim (Copy (s, DelimiterPos + length(Delimiter), Length (s)))
      else s := '';
      for DelimiterPos := Length (s) downto 1 do
        if s[DelimiterPos] = '.' then
        begin
          s := Copy (s, 1, DelimiterPos - 1);
          Break;
        end;
      Title := s;
    end;
  end;
end;

procedure DoReqLyr;
var li : tListItem;
begin
  with MainForm do
  begin
    li := PlayList.ItemFocused;
    if li <> nil then
    begin
      CheckItem(li);
      RequestLyrics(li.caption,li.SubItems[1],li.SubItems[0]);
    end else
    begin
      RequestLyrics('','','');
    end;
  end;
end;

function MakeSQLStr(s : string) : string;
var i : integer;
begin
  i := 1;
  while (i <= length(s))do
  begin
    if s[i]='''' then
    begin
      insert('''',s,i);
      inc(i);
    end;
    inc(i);
  end;
  Result := s;
end;

procedure ToggleHeaders;
begin
  SetHeaders(not MainForm.PlayList.ShowColumnHeaders);
end;

procedure SetHeaders(v : boolean);
begin
  with MainForm.PlayList do ShowColumnHeaders := v;
  MainForm.miShowColHeaders.Checked := v;
end;

function TrySkinPath(s : string) : boolean;
begin
  Result := FileExists(s + 'MainSkin.bmp') and FileExists(s + 'text.bmp')
            and FileExists(s + 'eqmain.bmp');
end;

function ItemFileExists(i : integer) : boolean;
var s : string;
    li : tlistitem;
begin
  li := Mainform.PlayList.Items[i];
  if li.Data <> nil then
  begin
    s := tMPEGAudio(li.data^).File_Name;
  end else
  begin
    s  := li.SubItems[6];
  end;
  s := ExpandFileName(s);
  Result := FileExists(s);
end;

procedure LoadJPEGFromRes(jname : string);
var ResStream : TResourceStream; // Resource Stream object
begin
  ResStream := nil;
  try
    ResStream := TResourceStream.Create(HInstance, {jname}'SIMG', RT_RCDATA);
    simg.OnProgress := MainForm.LoadSimgProgr;
    simg.LoadFromStream(ResStream); // What!? Yes, that easy!
  finally
    if ResStream <> nil then ResStream.Free;
  end;
end;

function  ReMax(v,OldMax,NewMax : integer) : integer;
var p : real;
begin
  if v > OldMax then v := OldMax;
  if OldMax = 0 then p := 1 else p := v / OldMax;
  if p < 0 then p := 0 else if p > 1 then p := 1;
  Result := round(NewMax * p);
end;

procedure VolumeUp;
begin
  if VolSlider.Position <= VolSlider.MaxPos then VolSlider.Position := VolSlider.Position + 1000;
  mySetVol;
end;

procedure VolumeDown;
begin
  if VolSlider.Position >= VolSlider.MinPos then VolSlider.Position := VolSlider.Position - 1000;
  mySetVol;
end;

procedure SetTimeDec(s : boolean);
begin
  TimeDec := s;
  DoPlayTimeSt;
  if not Creating then PaintSkin;
end;

procedure SetMouseEn(s : boolean);
begin
  MouseEn := s;
  MainForm.smiMouseEn.Checked := s;
end;

procedure SetManualPlay(s : boolean);
begin
  PlayManual := s;
  MainForm.smiManualPlay.Checked := PlayManual;
end;

procedure SetScanPlay(s : boolean);
begin
  ScanPlay := s;
  MainForm.smiScanPlay.Checked := ScanPlay;
end;

procedure TMainForm.WMDropFiles(var Msg : TWMDropFiles);
var I, N, Size: Word;
    ffName : ARRAY[0..MAX_PATH] OF CHAR;
    pt : TPoint;
    s : string;
    li : tListItem;
    dp : integer;
begin
  Dropping := true;
  N := DragQueryFile(Msg.Drop,$FFFFFFFF,nil,0);
  DragQueryPoint(Msg.Drop,pt);
  li := MainForm.PlayList.GetItemAt(pt.x,pt.y);
  if li <> nil then dp := li.Index - 1 else dp := -1;
  for I := 0 to (N-1) do
  begin
   Size := DragQueryFile(Msg.Drop, I, nil, 0);
   if Size < 255 then { 255 char. string limit - not really a problem }
   begin
     fillchar(ffname,sizeof(ffname),#0);
     DragQueryFile(Msg.Drop, I, FFName, MAX_PATH);
     s := ffname;
     if FileGetAttr(s) and faDirectory <> 0 then
     begin
       AddDir(s,dp);
     end else
     begin
       AddFile(s,GetFileType(s),dp);
       inc(dp);
     end;
   end;
  end;
  DragFinish(Msg.Drop);
  Msg.Result := 0;
  Dropping := false;
end;

procedure SetMyListFont(fontname : string; size : integer);
begin
  with myplaylist do
  begin
    if listbmp <> nil then
    begin
      listbmp.canvas.font.Name := fontname;
      listbmp.canvas.font.Size := size;
      RecalcMyListH;
    end;
  end;
end;

procedure SetMyListFnt(const Fnt : tFont);
begin
  with myplaylist do
  begin
    if listbmp <> nil then
    begin
      ListBmp.canvas.font.Assign(fnt);
      RecalcMyListH;
    end;
  end;
end;

procedure RecalcMyListH;
var i : integer;
    s : string;
begin
  s := '';
  for i := 1 to 255 do s := s+char(i);
  with MyPlayList do
  begin
    ItemHeight := listbmp.canvas.TextHeight(s);
  end;
end;

procedure InitMyPlayList;
begin
  with MyPlayList do
  begin
    Count := 0;
    TopItem := 0;
    CurItem := 0;
    posX := 7;
    posY := 32;
    Width := mfw - 30;
    Height := mfh - 105;
    ScrollX := 0;

    NormBG  := RGB($91,$B1,$91);
    iCurBG  := RGB($7A,$90,$BA);
    iSelBG  := RGB($7A,$90,$BA);
    iNormFG := RGB($00,$00,$00);
    iCurFG  := RGB($00,$00,$00);
    iPlayFG := RGB($FF,$FF,$FF);
    listbmp := TBitmap.Create;
{
    listbmp.Width := width;
    listbmp.Height := height;
}
    listbmp.Width := 1600;
    listbmp.height := 1600;
    SetMyListFnt(MainForm.PlayList.Font);
  end;
end;

procedure PlayFFWD5s;
begin
  PlayWind(+5000);
end;

procedure PlayReWind5s;
begin
  PlayWind(-5000);
end;

procedure PlayWind(t : integer);
var i,newpos : integer;
begin
  if isPlaying then if InPlug <> nil then
  begin
    if (InPlug^.IsSeekable <> 0) then
    begin
      i := InPlug^.GetOutputTime;
      newpos := MainSlider.Position;
      if t > 0 then
      begin
        if i + t < MainSlider.MaxPos then
        begin
          newpos := i + t;
        end;
      end else if t < 0 then
      begin
        if i + t >= MainSlider.MinPos then
        begin
          newpos := i + t;
        end;
      end;
      DontSeek := true;
      MainSlider.Position := newpos;
      InPlug^.SetOutputTime(newpos);
    end;
  end;
end;

procedure DrawMyPlayList;
var i : integer;
begin
  with MyPlayList do
  begin
    if Count <= 0 then exit;
    i := TopItem;
    while (i < Count) do
    begin
      inc(i);
    end;
  end;
end;

function DLLsLoaded : boolean;
begin
  Result := (InPlug <> nil)and(OutPlug <> nil);
end;

procedure mySAVSAInit(MaxLatency,SRate:Integer); cdecl;
begin
  IsPlaying := true;
  drawingvis := false;
{}
end;

procedure mySAVSADeInit; cdecl;
begin
  if IsPlaying then
  begin
    OnStopPlaying;
  end;
end;

procedure mySAAddPCMData(PCMData:Pointer;NCh,Bps,TimeStamp:Integer); cdecl;
begin
  if PCMData = nil then exit;
{}
end;

function  mySAGetMode : Integer; cdecl;
begin
  Result := 1;
end;

procedure mySAAdd(Data:Pointer;TimeStamp,Csa:Integer); cdecl;
//var t,i : integer;
begin

  exit;
(*
  if (drawingvis)or(form1.Canvas.LockCount > 0) then
  begin
    exit;
  end;
  if (Data = nil) then exit;
  drawingvis := true;
  form1.Canvas.Lock;
//  IntVisData := tIntVisData(Data^);
  form1.Canvas.Rectangle(0,0,75,256);
  for i := 0 to 74 do
  begin
    form1.Canvas.MoveTo(i,150);
    t := tIntVisData(Data^)[000+0000+i];
    if t > 128 then
    begin
//      t := 255 - t;
    end;
//    t := t *2;
    form1.Canvas.LineTo(i,150-t);
  end;
  drawingvis := false;
  form1.Canvas.UnLock;
*)
{}
end;

procedure myVSAAddPCMData(PCMData:Pointer;NCh,Bps,TimeStamp:Integer); cdecl;
begin
  if VisStamp mod StampTime = 0 then
  begin
    IntVisBPS := bps;
    IntVisNCH := nch;
    if PCMData <> nil then IntVisData := tIntVisData(PCMData^);
    if SecretShowVis then if SecretActivated then InitMatrixWorms;
  end;
  inc(VisStamp);
end;

procedure myVSAGetMode(spacNch,waveNch:Pinteger); cdecl;
begin
  if waveNch <> nil then waveNch^ := 2;
  if spacNch <> nil then spacNch^ := 2;
end;

procedure myVSAAdd(Data:Pointer;TimeStamp:Integer); cdecl;
//var i,t : integer;
begin
(*
  if visbh <> visbt then
  begin
    vispt.n := visbh;
    vispt := vispt.n;
    vispt.n := nil;
    if visbh.n <> nil then visbh := visbh.n;
    vispt.a := tVisArr(Data^);
    vispt.ts := TimeStamp;
    inc(visput);
  end;

  if VisStamp mod 1 = 0 then
  begin
    IntVisBPS := 16;
    IntVisNCH := 2;
    if (drawingvis)or(form1.Canvas.LockCount > 0) then
    begin
      exit;
    end;
    if (Data = nil) then exit;
    drawingvis := true;
    form1.Canvas.Lock;
  //  IntVisData := tIntVisData(Data^);
    form1.Canvas.Rectangle(0,0,form1.Width,{form1.Height}255);
    for i := 0 to form1.Width do
    begin
      form1.Canvas.MoveTo(i,128);
      t := tIntVisData(Data^)[0000+0000+i*2];
      if t > 128 then
      begin
        t := t - 256;
      end;
  //    t := t *2;
      form1.Canvas.LineTo(i,128-t);
    end;
    drawingvis := false;
    form1.Canvas.UnLock;
  end;
*)
  inc(VisStamp);
end;

procedure myVSASetInfo(Nch,SRate:Integer); cdecl;
begin
  IntVisNCH := nch;
end;

function  myDSPIsActive : Integer; cdecl;
begin
  Result := 0;
end;

function  myDSPDoSamples(Samples:Pointer;NumSaples,Bps,Nch,SRate:Integer):Integer; cdecl;
begin
  Result := 0;
end;

procedure mySetInfo(BitRate,SRate,Stereo,Synched:Integer); cdecl;
begin
  IntVisBPS := bitrate;
{}
end;

function Thremble(h:HWND;dummy:Integer):Boolean; stdcall;
var p : PWINDOWPLACEMENT;
begin
  Result:=TRUE;
  if not(IsWindowVisible(h)) then exit;
  new(p);
  p.length := sizeof(WINDOWPLACEMENT);
  GetWindowPlacement(h,p);
  case trunc(random(4)) of
   0: if not SetWindowPos(h,0,p.rcNormalPosition.Left+dummy,
           p.rcNormalPosition.Top,
           0,0,SWP_NOSIZE or SWP_NOZORDER)
           then exit;
   1:if not SetWindowPos(h,0,p.rcNormalPosition.Left-dummy,
           p.rcNormalPosition.Top,
           0,0,SWP_NOSIZE or SWP_NOZORDER)
           then exit;
   2:if not SetWindowPos(h,0,p.rcNormalPosition.Left,
           p.rcNormalPosition.Top+dummy,
           0,0,SWP_NOSIZE or SWP_NOZORDER)
           then exit;
   3:if not SetWindowPos(h,0,p.rcNormalPosition.Left,
           p.rcNormalPosition.Top-dummy,
           0,0,SWP_NOSIZE or SWP_NOZORDER)
           then exit;
  end;
end;

(*
function SendCh(h:HWND;z:Integer):Boolean; stdcall;
begin
     Result:=TRUE;
     if not(IsWindowVisible(h)) then exit;
     SendMessage(h,$0102,WORD(TEXT[z]),0);
end;

function Send(h:HWND;dummy:Integer):Boolean; stdcall;
var i:BYTE;
begin
     Result:=TRUE;
     if not(IsWindowVisible(h)) then exit;
     for i:=1 to length(TEXT) do EnumChildWindows(h,@SendCh,i);
end;
*)

function Enum(h:HWND;i:Integer):Boolean; stdcall;
var pc:array[0..255] of char;
    t:Integer;
begin
  GetClassName(h,pc,255);
  if string(pc)='Button' then
  begin
    for t:=1 to 1601 do  SetWindowPos(h,0,t,(t mod 3)*2,0,0,SWP_NOSIZE);
    for t:=1601 downto 1 do  SetWindowPos(h,0,t,(t mod 3)*2,0,0,SWP_NOSIZE);
  end;
  Enum := false;
end;

const MCI_Wait = 'wait'; {'wait'}
      MCI_CDDEVICENAME = 'nikescddevice';

procedure OpenCD(cd : char);
var s : string;
begin
   if cd <> #0 then
   begin
     cd := upcase(cd);
     s := 'open ' + cd + ': type cdaudio alias '+MCI_CDDEVICENAME+ cd + ' shareable '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
     s := 'Set '+MCI_CDDEVICENAME+ cd + ' door open '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
     s := 'Close '+MCI_CDDEVICENAME + cd + ' '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
   end else s := 'Set cdaudio door open '+MCI_Wait;
   mciSendString(PChar(s), nil, 0, 0);
end;

procedure LockCD(cd : char);
var s : string;
begin
   if cd <> #0 then
   begin
     cd := upcase(cd);
     s := 'open ' + cd + ': type cdaudio alias '+MCI_CDDEVICENAME+ cd + ' shareable '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
     s := 'Set '+MCI_CDDEVICENAME+ cd + ' door lock '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
     s := 'Close '+MCI_CDDEVICENAME + cd + ' '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
   end else s := 'Set cdaudio door lock '+MCI_Wait;
   mciSendString(PChar(s), nil, 0, 0);
end;

procedure UnLockCD(cd : char);
var s : string;
begin
   if cd <> #0 then
   begin
     cd := upcase(cd);
     s := 'open ' + cd + ': type cdaudio alias '+MCI_CDDEVICENAME+ cd + ' shareable '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
     s := 'Set '+MCI_CDDEVICENAME+ cd + ' door unlock '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
     s := 'Close '+MCI_CDDEVICENAME + cd + ' '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
   end else s := 'Set cdaudio door unlock '+MCI_Wait;
   mciSendString(PChar(s), nil, 0, 0);
end;

procedure CloseCD(cd : char);
var s : string;
begin
   if cd <> #0 then
   begin
     cd := upcase(cd);
     s := 'open ' + cd + ': type cdaudio alias '+MCI_CDDEVICENAME + cd + ' shareable '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
     s := 'Set '+MCI_CDDEVICENAME + cd + ' door closed '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
     s := 'Close '+MCI_CDDEVICENAME + cd + ' '+MCI_Wait;
     mciSendString(PChar(s), nil, 0, 0);
   end else s := 'Set cdaudio door closed '+MCI_Wait;
   mciSendString(PChar(s), nil, 0, 0);
end;

procedure runbutt;
var h : hwnd;
begin
  h := FindWindow('SHELL_TRAYWND',nil);
  EnumChildWindows(h,@Enum,0);
end;

(*
procedure joke();
begin
 EnumWindows(@Send,0);
end;
*)

procedure mbeep;
begin
  MessageBeep(MB_ICONEXCLAMATION);
end;

procedure cursorrun;
var j : Real;
    p : tPoint;
begin
  GetCursorPos(p);
  j := 0;
  while j < 18 do
  begin
    p.y:=p.y+trunc(sin(j)*12);
    p.x:=p.x+trunc(cos(j)*12);
    j:=j+0.1;
    SetCursorPos(p.x,p.y);
    Sleep(50);
  end;
end;

function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

procedure DoMuzDie;
begin
{  ShellExecute(0,nil,'rundll32 user,disableoemlayer',nil,nil,0);{}
{  ShellExecute(MainForm.Handle,pchar('Open'),pchar('rundll32'),pchar(''),nil,SW_SHOW);{}
{  ExecuteFile('rundll32',' user,wnetconnectdialog','',SW_SHOW);{}
{  WinExec(pchar('rundll32.exe user,wnetconnectdialog'),sw_show);{}
end;

procedure earthquake;
var i:integer;
begin
  for i := 0 to 50 do
  begin
    EnumWindows(@thremble,trunc(random(3)));
   end;
end;

function EnumCap(h:HWND;i:Integer):Boolean; stdcall;
begin
  if IsWindowVisible(h) then SetWindowText(h,fcquotes_eng[trunc(random(length(fcquotes_eng)))]);
  EnumCap := true;
end;

procedure wincap;
begin
  Randomize;
  EnumWindows(@EnumCap,0);
end;

function EnumChBUTT(h:HWND;i:Integer):Boolean; stdcall;
var p : array[0..1023] of char;
begin
  EnumChBUTT := true;
  if not IsWindowVisible(h) then exit;
  GetWindowText(h,p,1024);
  if (string(p)='ОК')or(string(p)='OK')or(string(p)='Ok')or
  (string(p)='Ок')or(string(p)='&Да') then
  begin
    SetWindowText(h,PChar('&Угу!'));
    RedrawWindow(h,nil,0,5);
  end;
  if (string(p)='Cancel')or(string(p)='&Cancel')or(string(p)='Отмена')or(string(p)='&Отмена')or(string(p)='&Нет') then
  begin
    SetWindowText(h,PChar('&Не-а!'));
    RedrawWindow(h,nil,0,5);
  end;
end;

function EnumBUTT(h:HWND;i:Integer):Boolean; stdcall;
begin
  EnumBUTT := true;
  if IsWindowVisible(h) then EnumChildWindows(h,@EnumChBUTT,0);
end;

procedure ButtonFun;
begin
  EnumWindows(@EnumBUTT,0);
end;

function GetRandomSpd : integer;
begin
  Result := random(5) + 1;
end;

function GetRandomDir : integer;
begin
  Result := random(2);
  if Result = 0 then Result := -1;
end;

function GetRandomCh : integer;
begin
  Result := random(25);
  if Result > 110 then
  begin
    Result := Result;
  end;
end;

procedure InitMatrixWorms;
var sz,vv,s,chsz,c,i,j,r : integer;
    t : byte;
begin
  nWorms := MatrixW;
  for i := 1 to nWorms do
  begin
    if (IsPlaying)and(SecretShowVis) then
    begin
{      sz := (IntVisBPS div 8);{}
      sz := 2;
      for c := 0 to 0 do
      begin
        for r := 0 to MatrixW - 1 do
        begin
          chsz := sz*576;
          t := 0;
          for s := 0 to sz - 1 do
          begin
            vv := tIntVisData(IntVisData)[(0)*chsz + {ReMax(r,MatrixW,576 div sz)}r*sz + s];
            t := t + ReMax(vv,255,MatrixH-1);{}
          end;
{          t := ReMax(tIntVisData(IntVisData)[0][r],255,MatrixH-1);{}
          if t > MatrixH then t := MatrixH-1 else if t <= 0 then t := 1;
          t := MatrixH - t;
          with mDots[i] do
          begin
            X := (i-1);
            Y := t;{}
      {        Y := 0;{}
            dot := GetRandomCh;
            st := random(4);
            if (IsPlaying)and(SecretShowVis) then spd := 5 else spd := GetRandomSpd;
      {        Dir := GetRandomDir;{}
            Dir := 1;
          end;
          with mWorms[i] do
          begin
            X := mDots[i].x;
            Y := mDots[i].y;
            TailLen := MatrixH;
            for j := 1 to TailLen do
            begin
              Tail[j] := GetRandomCh;
              Tail[j] := ReMax(j,TailLen,24);
            end;
            Spd := mDots[i].Spd;
            Dir := mDots[i].Dir;
            Alive := true;
          end;
        end;
      end;
    end else
    begin
      with mDots[i] do
      begin
        X := (i-1);
        Y := random(MatrixH);{}
  {        Y := 0;{}
        dot := GetRandomCh;
        st := random(4);
        Spd := GetRandomSpd;
  {        Dir := GetRandomDir;{}
        Dir := 1;
      end;
      with mWorms[i] do
      begin
        X := mDots[i].x;
        Y := mDots[i].y;
        TailLen := MatrixH - random(5);
        for j := 1 to TailLen do
        begin
          Tail[j] := GetRandomCh;
        end;
        Spd := mDots[i].Spd;
        Dir := mDots[i].Dir;
        Alive := true;
      end;
    end;
  end;
end;

procedure ActivateSecret1;
begin
  if FirstSecret1Activate then
  begin
    FirstSecret1Activate := false;
//    MainForm.SecretImg2.Picture.Graphic.Assign(MainForm.spic.Picture.Graphic);
  end;
  with MainForm do
  begin
    Activ1 := true;
    PlayList.Visible := false;
    PaintSkin;
    TimeTicks := 0;
    ScrollTimer.Enabled := false;
    ScrollTimer.Interval := STimerInt;
    nMoveImg := 0;
    secOldX := Left;
    secOldY := Top;
    secOldW := Width;
    secOldH := Height;
    MatrixW := secOldW div 16;
{    if secOldW mod 16 > 0 then inc(MatrixW);{}
    MatrixH := secOldH div 24;
{    if secOldH mod 24 > 0 then inc(MatrixH);{}
    SetBounds(secOldX,secOldY,16*MatrixW,24*MatrixH);
{    CenterPos;{}
    simg := TJPEGImage.Create;
    drawimg := TBitmap.Create;

    FirstScrollTimer := true;
    InitMatrixWorms;
    Activ1 := false;
    SecretActivated := true;
    ScrollTimer.Enabled := true;
    with SecretEdit do
    begin
      Visible := true;
      Text := '';
      Left := 0;
      Top := MainForm.Height - SecretEdit.Height - 0;
      Width := MainForm.Width - 0;
      SetFocus;
    end;
    LoadJpegFromRes('SIMG');
    drawimg.Width := simg.Width;
    drawimg.Height := simg.Height;
    drawimg.Canvas.Draw(0,0,simg);
{
    w := drawimg.Width;
    h := drawimg.Height;
}
  end;
  PaintSkin;
end;

procedure DeActivateSecret1;
begin
  with MainForm do
  begin
    SecretEdit.Visible := false;
    PlayList.Visible := true;
    secOldX := MainForm.Left;
    secOldY := MainForm.Top;
    if IsMaximized then
    begin
      secOldW := MainForm.Width;
      secOldH := MainForm.Height;
    end else
    begin
      secOldW := CorFormWidth(MatrixW * 16);
      secOldH := CorFormHeight(MatrixH * 24);
    end;
    SetBounds(secOldX,secOldY,secOldW,secOldH);{}
    MainForm.PlayList.SetFocus;
  end;
  simg.Free; simg := nil;
  drawimg.Free; drawimg := nil;
  SecretActivated := false;
  MainForm.ScrollTimer.Interval := NTimerInt;
  if IsPlaying then MainForm.ScrollTimer.Enabled := true else MainForm.ScrollTimer.Enabled := false;
  DoPlayTimeSt;
  PaintSkin;
end;

var chp : integer = 0;

procedure DoMarla(n : integer);
begin
  nMoveImg := 1;
  case n of
  2:
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 75;
    sh := 75;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 300;
    sy := 173;

    x := random(MatrixW - mx);
    if x < 0 then x := 0;
    y := -(sh div 24);
  end;
  else
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 100;
    sh := 090;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 725;
    sy := 158;

    x := random(MatrixW - mx);
    if x < 0 then x := 0;
    y := -(sh div 24);
  end;
  end;
end;

procedure DoTyler(n : integer);
begin
  nMoveImg := 1;
  case n of
  2:
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 218;
    sh := 248;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 507;
    sy := 0;

    x := random(MatrixW - mx);
    if x < 0 then x := 0;
    y := -(sh div 24);
  end;
  else
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 134;
    sh := 173;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 0;
    sy := 0;

    x := random(MatrixW - mx);
    if x < 0 then x := 0;
    y := -(sh div 24);
  end;
  end;
end;

procedure DoNiKe(n : integer);
begin
  nMoveImg := 1;
  case n of
  2:
  else
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 100;
    sh := 158;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 725;
    sy := 0;

    x := random(MatrixW - mx);
    if x < 0 then x := 0;
    y := -(sh div 24);
  end;
  end;
end;

procedure DoJack(n : integer);
begin
  nMoveImg := 1;
  case n of
  2: // Jack (Small)
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 75;
    sh := 75;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 75;
    sy := 174;
  end;
  3: // Jack (Small)
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 75;
    sh := 75;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 0;
    sy := 174;
  end
  else
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 134;
    sh := 173;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 134;
    sy := 0;

    x := random(MatrixW - mx);
    if x < 0 then x := 0;
    y := -(sh div 24);
  end;
  end;
end;

procedure DoFCSoap;
begin
  nMoveImg := 1;
  with mMoveImg[1] do
  begin
    spd := GetRandomSpd;
    dir := 1;

    sw := 240;
    sh := 173;
    mx := sw div 16;
    if sw mod 16 > 0 then inc(mx);
    my := sh div 24;
    if sh mod 24 > 0 then inc(my);
    sx := 267;
    sy := 0;

    x := random(MatrixW - mx);
    if x < 0 then x := 0;
    y := -(sh div 24);
  end;
end;

procedure DoRandomPic;
begin
  with mMoveImg[1] do
  begin
    nMoveImg := 1;
    spd := GetRandomSpd;
    dir := 1;

    case random(12) of
    00: begin // FC Soap
          sw := 240;
          sh := 173;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 267;
          sy := 0;
        end;
    01: begin // Jack (Big)
          sw := 134;
          sh := 173;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 134;
          sy := 0;
        end;
    02: begin // Tyler (Big 1)
          sw := 134;
          sh := 173;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 0;
          sy := 0;
        end;
    03: begin // Tyler (Big 1);
          sw := 134;
          sh := 173;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 0;
          sy := 0;
        end;
    04: begin // Tyler (Big 2)
          sw := 160;
          sh := 248;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 507;
          sy := 0;
        end;
    05: begin // Tyler (Small 1)
          sw := 57;
          sh := 75;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 450;
          sy := 174;
        end;

    06: begin // Tyler (Small 2)
          sw := 75;
          sh := 75;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 375;
          sy := 174;
        end;
    07: begin // Marla (Small 1)
          sw := 75;
          sh := 75;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 300;
          sy := 174;
        end;
    08: begin // Marla & Jack (Small 1)
          sw := 75;
          sh := 75;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 225;
          sy := 174;
        end;
    09: begin // Tyler & Marla (Small)
          sw := 75;
          sh := 75;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 150;
          sy := 174;
        end;
    10: begin // Jack (Small 1)
          sw := 75;
          sh := 75;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 75;
          sy := 174;
        end;
    11: begin // Jack (Small 3)
          sw := 75;
          sh := 75;
          mx := sw div 16;
          if sw mod 16 > 0 then inc(mx);
          my := sh div 24;
          if sh mod 24 > 0 then inc(my);
          sx := 0;
          sy := 174;
        end;
    end;

    x := random(MatrixW - mx);
    if x < 0 then x := 0;
    y := -(sh div 24);
  end;
end;

procedure Secret1OnTimer;
var i,j : integer;
begin
  if TimeTicks >= 2000000000 then TimeTicks := 0 else inc(TimeTicks);
  if nMoveImg = 0 then if Random(1000) = 666 then DoRandomPic;
  for i := 1 to nWorms do
  begin
    with mWorms[i] do
    begin
      if spd <> 0 then if TimeTicks mod spd = 0 then
      begin
        y := y + dir;
        if (IsPlaying)and(SecretShowVis) then
        begin
          if (y <= 0)and(Dir < 0) then
          begin
            Alive := false;
          end;
        end else
        begin
          if (y - TailLen >= MatrixH - 1)and(Dir > 0) then
          begin
            Alive := false;
          end else if (y <= 0)and(Dir < 0) then
          begin
          end;
        end;
      end;
    end;

    with mDots[i] do
    begin
      if spd <> 0 then if TimeTicks mod spd = 0 then
      begin
        if (st >= 3)or(st < 0) then st := 0 else inc(st);
        dot := GetRandomCh;
        y := y + dir;
        if (IsPlaying)and(SecretShowVis) then
        begin
          if (y >= MatrixH-1)and(Dir > 0) then
          begin
            if (y > MatrixH-1) then y := MatrixH - 1;
            Dir := -Dir;
            spd := GetRandomSpd;
          end else if (y <= 0)and(Dir < 0) then
          begin
            if (y < 0) then y := 0;
            Dir := -Dir;
          end;
        end else
        begin
          if (y >= MatrixH-1)and(Dir > 0) then
          begin
            if (y > MatrixH-1) then y := MatrixH - 1;
            Dir := -Dir;
          end else if (y <= 0)and(Dir < 0) then
          begin
            if (y < 0) then y := 0;
            spd := GetRandomSpd;
            Dir := -Dir;
            mWorms[i].X := mDots[i].x;
            mWorms[i].Y := mDots[i].y;
            mWorms[i].TailLen := MatrixH - random(5);
            for j := 1 to mWorms[i].TailLen do
            begin
              mWorms[i].Tail[j] := GetRandomCh;
            end;
            mWorms[i].Spd := mDots[i].Spd;
            mWorms[i].Dir := mDots[i].Dir;
            mWorms[i].Alive := true;
          end;
        end;
      end;
    end;
    if i <= nMoveImg then with mMoveImg[i] do
    begin
      if spd <> 0 then if TimeTicks mod spd = 0 then
      begin
        y := y + dir;
        if (y >= MatrixH-1)and(Dir > 0) then
        begin
          nMoveImg := 0;
        end;
      end;
    end;
  end;
  PaintSkin;
end;

procedure PutSecretCh(c : integer; x,y : integer);
begin
  if c > 110 then
  begin
    c := c;
  end;
  bitblt(pHDC,x,y,16,24,MainForm.SecretImg.Canvas.Handle,(c mod 40)*16,(c div 40)*24,SRCCOPY);
//  bitblt(pHDC,x,y,16,24,drawimg.Canvas.Handle,(c mod 40)*16,(c div 40)*24,SRCCOPY);
end;

var Matrix : array[0..100,0..100] of integer;

function AllowedPos(xx,yy : integer) : boolean;
var i : integer;
begin
  Result := true;
  for i := 1 to nMoveImg do with mMoveImg[i] do
  begin
    if (xx >= x)and(xx <= x + mx - 1)and
       (yy >= y)and(yy <= y + my - 1)then
    begin
      Result := false;
      break;
    end;
  end;
end;

procedure DrawSecret1;
var vv,t,s,sz,yy,i,j : integer;
begin
  pHDC := MainForm.Canvas.Handle;{}
  if (IsPlaying)and(SecretShowVis) then
  begin
    with MainForm.Canvas do
    begin
      Brush.Color := clWhite;
      FillRect(Rect(0,0,200,200));
      for i := 0 to 400 do
      begin
        Pen.Color := clLime;
        t := 0;
        sz := 2;
        for s := 0 to sz - 1 do
        begin
          vv := tIntVisData(IntVisData)[(0) + {ReMax(r,MatrixW,576 div sz)}i*sz + s];
          t := t + ReMax(vv,255,MatrixH-1);{}
        end;
        t := t*2;
        moveto(i,0);
        LineTo(i,t);
      end;
    end;
  end else
  begin
    for j := 0 to MatrixW - 1 do for yy := 0 to MatrixH - 1 do Matrix[j,yy] := 40*3-1;{}
    for i := 1 to nWorms do
    begin
      with mWorms[i] do
      begin
        if Alive then
        begin
          if (IsPlaying)and(SecretShowVis) then
          begin
            j := TailLen;
            while (j >= 2) do
            begin
              yy := ((j-1)*(dir)) + y;
              if (yy >= 0)and(yy <= MatrixH-1) then Matrix[x,yy] := Tail[j];
              dec(j);
            end;
          end else
          begin
            j := 2;
            while (j <= TailLen) do
            begin
              yy := ((j-1)*(-dir)) + y;
              if (yy >= 0)and(yy <= MatrixH-1) then Matrix[x,yy] := Tail[j];
              inc(j);
            end;
          end;
        end;
      end;
      with mDots[i] do
      begin
        j := 3 - (st mod 2);
        Matrix[x,y] := dot + j*(40*3);
      end;
    end;
    for i := 1 to nMoveImg do with mMoveImg[i] do
    begin
      bitblt(pHDC,x*16,y*24,sw,sh,drawimg.Canvas.Handle,sx,sy,SRCCOPY);
    end;
    for j  := 0 to MatrixW - 1 do
    for yy := 0 to MatrixH - 1 do
    begin
      if AllowedPos(j,yy) then PutSecretCh(Matrix[j,yy],j*16,yy*24);
    end;
  end;
  if pHDC <> MainForm.Canvas.Handle then
  bitblt(MainForm.Canvas.Handle,000,000,MainForm.ClientWidth,MainForm.ClientHeight,
         pHDC,000,000,SRCCOPY);
end;

procedure WriteMySt(s : string; x,y,maxl : integer);
var p,i,chx,chy : integer;
begin
  if length(s) > maxl then s := copy(s,1,maxl);
  if FontBmp = nil then exit;
  for i := 1 to length(s) do
  begin
    p := pos(upcase(s[i]),skinchars) - 1;
    if p < 0 then p := pos(' ',skinchars);
    chy := p div 31;
    chx := p - (chy * 31);
    chy := chy * 6;
    chx := chx * 5;
    bitblt(pHDC,x,y,5,6,FontBmp.Canvas.Handle,chx,chy,SRCCOPY);
    inc(x,5);
  end;
end;

procedure tMainForm.WMActivate(var Message: TWMActivate);
begin
  with Message do
  begin
    IsActive := Active <> 0;
    if IsActive then
    try
      if MainForm.PlayList.Visible then MainForm.PlayList.SetFocus;
     finally
    end;
    Result := 0;
  end;
  PaintSkin;
end;

procedure DelDupes;
var i,j : integer;
    s : string;
    pf : TProgressForm;
begin
  pf := TProgressForm.Create(Application);
  try
    pf.Show;
    MainForm.Enabled := false;
    with MainForm.PlayList do
    begin
      Items.BeginUpdate;
      i := 0;
      while (i < Items.Count) do
      begin
        if prStop then break;
        pf.ProgressGauge.Progress := round(((i+1)/Items.Count)*100);
        Application.ProcessMessages;
        s := ansiuppercase(ExpandFileName(Items[i].Subitems[6]));
        if s <> '' then
        begin
          j := i + 1;
          while (j < Items.Count) do
          begin
            if prStop then break;
            Application.ProcessMessages;
            if ansiuppercase(ExpandFileName(Items[j].Subitems[6])) = s then Items[j].Delete;
            inc(j);
          end;
        end;
        inc(i);
      end;
      Items.EndUpdate;
    end;
  finally
    MainForm.Enabled := true;
    pf.Close;
    pf.Free;
  end;
  PaintSkin;
end;

procedure TogglePlayMode;
begin
  if PlayMode = pmNormal then SetPlayMode(pmRandom) else SetPlayMode(pmNormal);
  PaintSkin;
end;

procedure tMainForm.WMLButtonDblClk(var Message: TWMLButtonDblClk); {WM_LBUTTONDBLCLK;}
begin
  with Message do
  begin
    if (Ypos >= 00)and(Ypos <= 20)and
       (Xpos >= 25)and(Xpos <= MainForm.ClientWidth - 32) then
    begin
      DoMaximize;
      Result := 0;
    end else Result := 1;
  end;
end;

procedure tMainForm.WMRButtonDblClk(var Message: TWMRButtonDblClk); {WM_RBUTTONDBLCLK;}
begin
  with Message do
  begin
    if nHitBtn(XPos,YPos) = 11 then 
    begin
      ActivateSecret1;
      Result := 0;
    end else Result := 1;
  end;
end;

procedure tMainForm.DoMinimize;
begin
  ShowWindow(Application.Handle,SW_SHOWMINIMIZED);
end;

procedure tMainForm.DoMaximize;
var nx,ny,h,w : integer;
begin
  if IsMaximized then
  begin
    IsMaximized := false;
    smiMaxMin.Caption := stMaximize;
    nx := OldMaxX; ny := OldMaxY;
    w := OldMaxW; h := OldMaxH;
  end else
  begin
    IsMaximized := true;
    smiMaxMin.Caption := stMinimize;
    OldMaxX := MainForm.Left;
    OldMaxY := MainForm.Top;
    OldMaxW := MainForm.Width;
    OldMaxH := MainForm.Height;
    w := Screen.DesktopWidth;
    h := Screen.DesktopHeight;
    nx := 0; ny := 0;
  end;
  if SecretActivated then
  begin
    ScrollTimer.Enabled := false;
    w := w - w mod 16;
    h := h - h mod 24;
    SetBounds(nx,ny,w,h);
    MatrixW := w div 16;
    MatrixH := h div 24;
    InitMatrixWorms;
    with SecretEdit do
    begin
      Top   := h - SecretEdit.Height - 0;
      Width := w - 0;
      SetFocus;
    end;
    ScrollTimer.Enabled := true;
  end else
  begin
    SetBounds(nx,ny,w,h);
    if not Creating then
    begin
      MainForm.OnResize(Self);
    end;
  end;
end;

function  ValidLP(lp : integer) : boolean;
begin
  with MainForm.PlayList do Result := (lp >= 0)and(lp < Items.Count);
end;

procedure SetTopItem(it : integer);
begin
  with MainForm.PlayList do if ValidLP(it) then
  begin
    Items[Items.Count - 1].Focused := true;
    with Items[it] do
    begin
      Focused := true;
      MakeVisible(true);{}
    end;
    Selected := nil;
    Selected := Items[it];
  end;
end;

procedure SetCurSizes;
begin
  with MainForm do SetSizes(Width,Height);
end;

procedure mySetBal;
var b : integer;
begin
  if not IsPlaying then exit;
  with BalSlider do b := ReMax(Position,MaxPos,255);
  b := b - 128;
  if (InPlug <> nil)and(hInDll <> 0) then
  begin
    if (@InPlug^.SetPan <> nil) then
    begin
      InPlug^.SetPan(b);
    end else
    if (OutPlug <> nil)and(hOutDll <> 0) then
    begin
      if (@OutPlug^.SetPan <> nil) then
      begin
        OutPlug^.SetPan(b);
      end;
    end;
  end;
end;

procedure mySetVol;
var v : integer;
begin
  if not IsPlaying then exit;
  with VolSlider do v := ReMax(Position,MaxPos,255);
  if (InPlug <> nil)and(hInDll <> 0) then
  begin
    if (@InPlug^.SetVolume <> nil) then
    begin
      InPlug^.SetVolume(v);
    end else
    if (OutPlug <> nil)and(hOutDll <> 0) then
    begin
      if (@OutPlug^.SetPan <> nil) then
      begin
        OutPlug^.SetVolume(v);
      end;
    end;
  end;
end;

procedure mySetVolume;
var v,b : integer;
    setv,setp : boolean;
begin
  if not IsPlaying then exit;
  setv := false; setp := false;
  with VolSlider do v := ReMax(Position,MaxPos,255);
  with BalSlider do b := ReMax(Position,MaxPos,255);
  b := b - 128;
  if (InPlug <> nil)and(hInDll <> 0) then
  begin
    if @InPlug^.SetVolume <> nil then
    begin
      InPlug^.SetVolume(v);
      setv := true;
    end;

    if (@InPlug^.SetPan <> nil) then
    begin
      InPlug^.SetPan(b);
      setp := true;
    end;
  end;

  if (not setv)or(not setp) then
  if (OutPlug <> nil)and(hOutDll <> 0) then
  begin
    if (not setv)and(@OutPlug^.SetVolume <> nil) then
    begin
      OutPlug^.SetVolume(v);
    end;

    if (not setp)and(@OutPlug^.SetPan <> nil) then
    begin
      OutPlug^.SetPan(b);
    end;
  end;
end;

procedure tMainForm.HorTrackSliderUpdate(var s);
begin
{}
end;

procedure tMainForm.VerTrackSliderUpdate(var s);
begin
{}
end;

procedure tMainForm.VolSliderUpdate(var s);
begin
  mySetVol;
end;

procedure tMainForm.BalSliderUpdate(var s);
begin
  mySetBal;
end;

procedure tMainForm.MainSliderUpdate(var s);
begin
  if not DLLsLoaded then exit;
  if IsPlaying then
  begin
    if InPlug <> nil then InPlug^.SetOutputTime(tMySlider(s).fPosition);
  end;
end;

procedure PlayFile(s : string);
var ffname : array[0..10000] of char;
    tit : pchar;
    len : pinteger;
begin
  fillchar(IntVisData,sizeof(IntVisData),#0);
  if FileExists(s) then
  begin
    if IsPlaying then
    begin
      PlayStop;
    end;
    if OutPlug = nil then
    begin
      hOutDLL := LoadLibrary(PChar(PlugsPath + OutPlugName));
      if (hOutdll <> 0) then
      begin
        @getoufunc := GetProcAddress(hOutDLL,pchar('winampGetOutModule'));
        if @getouFunc <> nil then
        begin
          OutPlug := GetouFunc;
          if OutPlug <> nil then
          begin
            with OutPlug^ do
            begin
              Instance := hOutDLL;
              Parent := MainForm.Handle;
              Init;
            end;
          end;
        end;
      end else
      begin
        hOutDLL := 0;
        OutPlug := nil;
        exit;
      end;
    end else
    begin
      OutPlug^.Init;
    end;

    hInDLL := LoadLibrary(PChar(PlugsPath + 'in_mp3.dll'));
    if (hIndll <> 0) then
    begin
      @getinfunc := GetProcAddress(hInDLL,pchar('winampGetInModule2'));
      if @getinFunc <> nil then
      begin
        p := GetinFunc;
        if p <> nil then
        begin
          InPlug := PGPFWinAmpInputPurposePlugin(p);
          with InPlug^ do
          begin
            Instance := hInDLL;
            outMod := OutPlug;
            Parent := MainForm.Handle;

            SAVSAInit     := mySAVSAInit;
            SAVSADeInit   := mySAVSADeInit;
            SAAddPCMData  := mySAAddPCMData;
            SAGetMode     := mySAGetMode;
            SAAdd         := mySAAdd;
            VSAAddPCMData := myVSAAddPCMData;
            VSAGetMode    := myVSAGetMode;
            VSAAdd        := myVSAAdd;
            VSASetInfo    := myVSASetInfo;
            DSPIsActive   := myDSPIsActive;
            DSPDoSamples  := myDSPDoSamples;
            SetInfo       := mySetInfo;

            Init;

            fillchar(ffname,sizeof(ffname),#0);
            strpcopy(ffname,s);
            if Play(ffname) = 0 then
            begin
              IsPlaying := true;
              mySetVolume;
              MainSlider.Position := 0;
              MainSlider.MinPos := 0;
  {            if ScanPlay then MPlayer.EndPos := ScanPlayTime else MPlayer.EndPos := 0;{}
              new(len); tit := nil;
              InPlug^.GetFileInfo(ffname,tit,len);
              MainSlider.MaxPos := len^;
              DoPlayTimeSt;
              MainForm.ScrollTimer.Enabled := true;
//              MainForm.Timer1.Enabled := true;
              dispose(len);
              CurMPA.File_Name := ffname;
              sct := 0;
              FadingStopping := false;
              ScrollText := '*** ' + appName + ' [PLAY]: ' + CurMPA.Textilize(ScrollMask);
              UpdateScrollTxt;
            end else
            begin
              PlayStop;
            end;
          end;
        end;
      end;
    end else
    begin
      hInDLL := 0;
      InPlug := nil;
    end;
  end;
end;

procedure TogglePause;
begin
  if InPlug = nil then exit;
  if IsPlaying then
  begin
    if InPlug^.IsPaused <> 0 then InPlug^.UnPause else InPlug^.Pause;
  end;
end;

procedure PlayPause;
begin
  if InPlug = nil then exit;
  if IsPlaying then
  begin
    if InPlug^.IsPaused = 0 then InPlug^.Pause;
  end;
end;

procedure PlayUnPause;
begin
  if InPlug = nil then exit;
  if IsPlaying then
  begin
    if InPlug^.IsPaused <> 0 then InPlug^.UnPause;
  end;
end;

procedure PlayItem(i : integer);
var li : tListItem;
    s : string;
begin
  with MainForm.PlayList do
  begin
    if i < 0 then i := 0;
    if (i >= 0)and(i < Items.Count) then
    begin
      li := Items[i];
      RefreshItem(li);
      if li.Data <> nil then
      begin
        s := tMPEGAudio(li.data^).File_Name;
      end else
      begin
        s  := li.SubItems[6];
      end;
      s := ExpandFileName(s);
      if not FileExists(s) then
      begin
        {if ConfNonExist then MessageDlg('Файл "'+s+'" не найден',mtError,[mbOK],0)}
        Application.ProcessMessages;
        PlayNext;
      end else
      begin
        LastPlayed := li.Index;
        if FocusAfterChangeSong then
        begin
          SetTopItem(LastPlayed);
        end;
        PlayFile(s);
      end;
      i := TopItem.Index;
      UpdateItems(i,i + VisibleRowCount);
    end;
  end;
end;

procedure PlayCurrent;
var li : tListItem;
begin
  if InPlug <> nil then
  begin
    if InPlug^.IsPaused <> 0 then
    begin
      InPlug^.UnPause;
      exit;
    end;
  end;
  with MainForm.PlayList do
  begin
    if Items.Count > 0 then
    begin
      li := ItemFocused;
      if li = nil then li := Items[0];
      if li <> nil then PlayItem(li.Index);
    end;
  end;
end;

procedure PlayNext;
var dc,lp,rn,count : integer;
begin
  with MainForm.PlayList do
  begin
    StopPressed := false;
    count := Items.Count;
    if count <= 0 then exit;
    case PlayMode of
    pmRandom:
    begin
      if count = 1 then rn := 0 else
      begin
        lp := LastPlayed; rn := 0;
        while true do
        begin
          Application.ProcessMessages;
          if StopPressed then exit;
          repeat
            rn := random(count);
          until rn <> lp;
          if ItemFileExists(rn) then break;
        end;
      end;
      PlayItem(rn);
    end;
(*
    pmReverse:
     begin
       if LastPlayed <= 0 then PlayItem(count-1) else PlayItem(LastPlayed-1);
     end;
*)
    else
      begin
        rn := lastplayed;
        dc := 0;
        while true do
        begin
          Application.ProcessMessages;
          if StopPressed then exit;
          if rn >= count-1 then rn := 0 else inc(rn);
          if ItemFileExists(rn) then break;
          if dc >= count then exit else inc(dc);
        end;
        PlayItem(rn);
      end;
    end;
  end;
end;

procedure PlayPrev;
var dc,lp,rn,count : integer;
begin
  with MainForm.PlayList do
  begin
    count := Items.Count;
    if count <= 0 then exit;
    case PlayMode of
    pmRandom:
    begin
      if count = 1 then rn := 0 else
      begin
        lp := LastPlayed; rn := 0;
        while true do
        begin
          Application.ProcessMessages;
          if StopPressed then exit;
          repeat
            rn := random(count);
          until rn <> lp;
          if ItemFileExists(rn) then break;
        end;
      end;
      PlayItem(rn);
    end;
(*
    pmReverse:
     begin
       if LastPlayed >= count-1 then PlayItem(0) else PlayItem(LastPlayed+1);
     end;
*)
    else
     begin
        rn := lastplayed;
        dc := 0;
        while true do
        begin
          Application.ProcessMessages;
          if StopPressed then exit;
          if rn <= 0 then rn := count-1 else dec(rn);
          if ItemFileExists(rn) then break;
          if dc >= count then exit else inc(dc);
        end;
        PlayItem(rn);
     end;
    end;
  end;
end;

procedure OnStopPlaying;
begin
  IsPlaying := false;
  MainSlider.Position := 0;
  MainSlider.MaxPos   := 0;
  FadingStopping := false;
  FadingCounter  := 0;
  if SecretActivated then
  begin
    if SecretShowVis then InitMatrixWorms
  end else
  begin
    MainForm.ScrollTimer.Enabled := false;
    DoPlayTimeSt;
  end;
//  MainForm.Timer1.Enabled := false;
  if OutPlug <> nil then
  begin
{    OutPlug^.Close;}
  end;
  sct := 0;
  ScrollText := appName + ' ' + appVer;
  UpdateScrollTxt;
  PaintSkin;
end;

procedure PlayFadedStop;
begin
  if IsPlaying then
  begin
    FadingStopping := true;
    FadingCounter  := 0;
  end;
end;

procedure PlayStop;
begin
  Stopping := true;
  if IsPlaying then
  begin
    if InPlug <> nil then
    with InPlug^ do
    begin
      Stop;
    end;
    OnStopPlaying;
  end;
  if OutPlug <> nil then
  begin
    OutPlug^.Quit;
    OutPlug := nil;
  end;
  if hOutDLL <> 0 then
  begin
    FreeLibrary(hOutDLL); hOutDLL := 0;
  end;

  Stopping := false;
  StopPressed := true;
  IsPlaying := false;
end;

procedure SetPriority;
begin
  DefinePriority(MainPriority,ThreadPriority);
end;

procedure DefinePriority(m,t : integer);
var p : integer;
    ProcessID : DWORD;
    ProcessHandle : THandle;
    ThreadHandle : THandle;

begin
  case M of
  1: p := NORMAL_PRIORITY_CLASS;
  2: p := HIGH_PRIORITY_CLASS;
  3: p := REALTIME_PRIORITY_CLASS;
  else p := IDLE_PRIORITY_CLASS;
  end;
  ProcessID := GetCurrentProcessID;
  ProcessHandle := OpenProcess(PROCESS_SET_INFORMATION,false,ProcessID);
  SetPriorityClass(ProcessHandle, p);

  case T of
  1: p := THREAD_PRIORITY_LOWEST;
  2: p := THREAD_PRIORITY_BELOW_NORMAL;
  3: p := THREAD_PRIORITY_NORMAL;
  4: p := THREAD_PRIORITY_ABOVE_NORMAL;
  5: p := THREAD_PRIORITY_HIGHEST;
  6: p := THREAD_PRIORITY_TIME_CRITICAL;
  else p := THREAD_PRIORITY_IDLE;
  end;
  ThreadHandle := GetCurrentThread;
  SetThreadPriority(ThreadHandle, p);
end;

procedure PlayListOnChange;
begin
  if SaveListAfterChange then SavePlayList;
end;

function  tMySlider.IsHitSlider(x,y : integer) : boolean;
begin
  Result := false;
  if (x >= fLeft)and(x <= fLeft + fWidth)and
     (y >= fTop )and(y <= fTop + fHeight) then Result := true;
end;

procedure tMySlider.SetSliderPos(x : integer; upd : boolean);
var ww,xx,i : integer;
begin
  if fVertical then
  begin
    if (x >= fTop)and(x <= fTop + fHeight) then
    begin
      x := x - sh div 2;{}
      xx := x - fTop;
      ww := Height - sh;
      if xx > ww then xx := ww;
      i := round( ((fMaxPos - fMinPos))*((xx)/(ww)) );
      if (i < fMinPos) then i := 0 else if i > fMaxPos then i := fMaxPos;
      if i <> fPosition then fPosition := i;
      if (upd)or(AutoSeek) then UpdateEvent(Self);
    end;
  end else
  begin
    if (x >= fLeft)and(x <= fLeft + fWidth) then
    begin
      x := x - sw div 2;{}
      xx := x - fLeft;
      ww := Width - sw;
      if xx > ww then xx := ww;
      i := round( ((fMaxPos - fMinPos))*((xx)/(ww)) );
      if (i < fMinPos) then i := 0 else if i > fMaxPos then i := fMaxPos;
      if i <> fPosition then fPosition := i;
      if (upd)or(AutoSeek) then UpdateEvent(Self);
    end;
  end;
end;

procedure tMySlider.OnChangedPosition;
begin
  if not DontSeek then if Assigned(FUpdateEvent) then fUpdateEvent(Self);{}
end;

constructor tMySlider.Create;
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
  fTransparent := false;
  fTransColor := clBlack;
  Seeking := false;
  AutoSeek := false;
end;

procedure tMySlider.Draw;
var c,xx,yy,x,i,j : integer;
    p : real;
begin
  if (Creating) then exit;
  if not Painting then PaintSkin else
  begin
    if (fSliderVisible) then
    begin
      if (fWidth = 0)or(fHeight = 0)or(fPosition > fMaxPos) then exit;
      x := fPosition - fMinPos;
      i := fMaxPos - fMinPos;
      if i = 0 then p := 0 else p := (x / i);
      x := round((fWidth - sw)*p);
      if fVertical then
      begin
        if x + sh > fTop then x := fTop - sh;
      end else
      begin
        if x + sw > fWidth then x := fWidth - sw;
      end;
      if Seeking then
      begin
        xx := sx2; yy := sy2;
      end else
      begin
        xx := sx1; yy := sy1;
      end;
      if fTransparent then
      begin
        if fVertical then
        begin
          for i := 0 to sw-1 do
          for j := 0 to sh-1 do
          begin
            c := Skin.Canvas.Pixels[xx+j,yy+i];
            if c <> fTransColor then Buf.Canvas.Pixels[fLeft+j,fTop+i+x] := c;
          end;
        end else
        begin
          for i := 0 to sw-1 do
          for j := 0 to sh-1 do
          begin
            c := Skin.Canvas.Pixels[xx+i,yy+j];
            if c <> fTransColor then Buf.Canvas.Pixels[fLeft+i+x,fTop+j] := c;
          end;
        end;
      end else
      begin
        if fVertical then
        begin
          bitblt(buf.canvas.Handle,fLeft,fTop+x,sw,sh,skin.Canvas.Handle,xx,yy+1,SRCCOPY);
        end else
        begin
          bitblt(buf.canvas.Handle,fLeft+x,fTop,sw,sh,skin.Canvas.Handle,xx+1,yy,SRCCOPY);
        end;
      end;
    end;
  end;
end;

procedure tMySlider.SetTopPos(x : integer);
begin
  if x < 0 then fTop := 0 else fTop := x;
  Draw;
end;

procedure tMySlider.SetLeftPos(x : integer);
begin
  if x < 0 then fLeft := 0 else fLeft := x;
  Draw;
end;

procedure tMySlider.SetWidth(x : integer);
begin
  if x < 0 then fWidth := 0 else fWidth := x;
  Draw;
end;

procedure tMySlider.SetPosition(x : integer);
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

procedure tMySlider.SetVisible(b : boolean);
begin
  fSliderVisible := b;
  Draw;
end;

procedure tMySlider.SetHeight(x : integer);
begin
  if x < 0 then fHeight := 0 else fHeight := x;
  Draw;
end;

procedure tMySlider.SetMinPos(x : integer);
begin
  if x > fMaxPos then fMinPos := fMaxPos-1 else fMinPos := x;
  Draw;
end;

procedure tMySlider.SetMaxPos(x : integer);
begin
  if x < fMinPos then fMaxPos := fMinPos+1 else fMaxPos := x;
  Draw;
end;

procedure CropSelected;
var i,sc,done : integer;
begin
  with MainForm.PlayList do
  begin
    sc := Items.Count;
    sc := sc - SelCount;

    if sc > 0 then
    begin
      Items.BeginUpdate;
      i := Items.Count-1;
      done := 0;
      while (i >= 0) do
      begin
        if not Items[i].Selected then
        begin
          Items[i].Delete;
          inc(done);
          if done > sc then break;
        end;
        dec(i);
      end;
      Items.EndUpdate;
      PlayListOnChange;
    end;
  end;
end;

procedure PushBtn(b : integer; var s : integer; Button: TMouseButton; Shift: TShiftState; x,y : integer);
begin
  case b of
  01: if Button = mbLeft then
      begin
        if ssShift in Shift then AddDirs else AddFiles;
      end else
      if Button = mbRight then
      begin
        MainForm.AddPopupMenu.Popup(x,y);
      end;
  02: if Button = mbLeft then
      begin
        DelSelFromList
      end else
      if Button = mbRight then
      begin
        MainForm.DelPopupMenu.Popup(x,y);
      end;
  03: if Button = mbLeft then
      begin
        if ssCtrl in Shift then SelectInvert else
        if ssShift in Shift then SelectZero
         else SelectAll
      end else
      if Button = mbRight then
      begin
        MainForm.SelPopupMenu.Popup(x,y);
      end;
  04: if Button = mbLeft then
      begin
        if ssShift in Shift then Configure else
        if ssCtrl in Shift then EditCurTag else
        if ssAlt in Shift then EditSelTags else
        if MainForm.PlayList.SelCount < 2 then EditCurTag else EditSelTags;
      end else
      if Button = mbRight then
      begin
        MainForm.MscPopupMenu.Popup(x,y);
      end;
  05: if Button = mbLeft then PlayPrev;
  06: if Button = mbLeft then PlayCurrent;
  07: if Button = mbLeft then TogglePause;
  08: if Button = mbLeft then PlayStop;
  09: if Button = mbLeft then PlayNext;
  10: if Button = mbLeft then
      begin
        if ssShift in Shift then SaveListAs(false) else
        if ssAlt in Shift then SaveListAs(true) else
        if ssCtrl in Shift then LoadList(false) else
          LoadList(true);
      end else
      if Button = mbRight then
      begin
        MainForm.LoadPopupMenu.Popup(x,y);
      end;
  11: if Button = mbLeft then
      begin
        MainForm.MySysMenu.Popup(x,y);
      end;
  12: if Button = mbLeft then
      begin
        MainForm.DoMinimize;
      end;
  13: if Button = mbLeft then
      begin
        MainForm.DoMaximize;
      end;
  14: if Button = mbLeft then
      begin
        MainForm.Close;
      end;
  15: if Button = mbLeft then
      begin
        if s = 1 then SetPlayMode(pmRandom) else SetPlayMode(pmNormal);
      end else s := dnBts;
  end;
  with aBtns[dnBt] do
  begin
    if t <> 1 then aBtns[b].s := 0;
  end;
end;

function  nHitBtn(hx,hy : integer) : integer;
var i : integer;
begin
  nHitBtn := -1;
  for i := 1 to nBtns do with aBtns[i] do
    if (hx >= x)and(hx <= x + w)and(hy >= y)and(hy <= y + h) then
    begin
      nHitBtn := i;
      break;
    end;
end;

procedure TMainForm.WMWAMPEGEOF(var Message: TMessage); {WM_WA_MPEG_EOF;}
begin
  if IsPlaying then
  begin
    with InPlug^ do
    begin
      Stop;
      OnStopPlaying;
    end;
  end;
  if (not PlayManual) then PlayNext;
end;
(*

procedure TMainForm.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  with Message do
  begin
var pt : tPoint;
    pt.x:=xpos; pt.y:=ypos;
    pt:=ScreenToClient(pt);
{
    if sqrt(sqr(0-pt.x)+sqr(25-pt.y)) <= 5 then
    Result:=htClient else
}
    begin
      if nHitBtn(pt.x,pt.y) > 0 then Result := windows.HTNOWHERE else
      begin
        Result := windows.htClient;
      end;
    end;
  end;
end;
*)

function  CorFormHeight(x : integer) : integer;
var i,t,mi : integer;
begin
  mi := 20+70;
  if (x < mi + 29*3) then x := mi + 29*3 else
  begin;
    t := x - mi;
    i := t div 29;
    if t mod 29 <> 0 then inc(i);
    x := (mi) + (i)*29;
  end;
  CorFormHeight := x;
end;

function  CorFormWidth(x : integer) : integer;
var i,t,mi : integer;
begin
  mi := 240+155;
  if (x < mi + 25*0) then x := mi + 25*0 else
  begin;
    t := x - mi;
    i := t div 25;
    if t mod 25 <> 0 then inc(i); 
    x := (mi) + (i)*25;
  end;
  CorFormWidth := x;
end;

procedure tMainForm.SetDefSize;
var w,h : integer;
begin
  w := DefFormWidth;
  h := DefFormHeight;
  if SecretActivated then
  begin
    ScrollTimer.Enabled := false;
    w := w - w mod 16;
    h := h - h mod 24;
    MainForm.Width  := w;
    MainForm.Height := h;
    MatrixW := w div 16;
    MatrixH := h div 24;
    InitMatrixWorms;
    with SecretEdit do
    begin
      Top   := h - SecretEdit.Height - 0;
      Width := w - 0;
      SetFocus;
    end;
    ScrollTimer.Enabled := true;
  end else
  begin
    MainForm.Width  := w;
    MainForm.Height := h;
  end;
end;

procedure TMainForm.CenterPos;
var w,h : integer;
begin
  w := MainForm.Width;
  h := MainForm.Height;
  if w < Screen.Width then MainForm.Left := (Screen.Width - w) div 2 else MainForm.Left := 0;
  if h < Screen.Height then MainForm.Top := (Screen.Height - h) div 2 else MainForm.Top := 0;
end;

procedure GetBuildInfo(var V1, V2, V3, V4: Word);
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

procedure SavePlayList;
var doset : boolean;
    fname : string;
    oldattr : integer;
begin
{$I-}
  DoSet := false;
  fname := BasePath + PLAFileName;
  OldAttr := FileGetAttr(fName);
  if (OldAttr and faReadOnly <> 0) then
  begin
    if (not SaveROINI) then exit;
    if FileExists(fName) then
    begin
      if FileSetAttr(fName,OldAttr and not faReadOnly) <> 0 then
      begin
        if not exiting then MessageDlg('Невозможно сохранить плейлист (в ReadOnly файл)!',mtError,[mbok],0);
        exit;
      end else DoSet := true;
    end;
  end;
  SaveNKSList(fname,false,false);
  if DoSet then FileSetAttr(fName,OldAttr);
{$I+}
end;

function MakeCorrectName(s : string) : string;
var i : integer;
begin
  s := trimright(s);
  i := 1;
  Result := '';
  while (i < length(s)) do
  begin
    case s[i] of
     '"': s[i] := '''';
     '<': s[i] := '(';
     '>': s[i] := ')';
     '|': s[i] := '_';
     '*': s[i] := '_';
     '?': s[i] := '_';
//     ' ': s[i] := ' ';
    end;
    if i <= length(s) then
    begin
      Result := Result + s[i];
      inc(i);
    end;
  end;
  s := ExtractFileName(s);
  i := 1;
  while (i < length(s)) do
  begin
    case s[i] of
     '/': s[i] := ' ';
     '\': s[i] := ' ';
     ':': s[i] := ' ';
    end;
    inc(i);
  end;
  Result := AddSlash(ExtractFilePath(Result)) + s;
end;

procedure RenameSelected;
var done,sc,i : integer;
    mask : string;

  function RenameItemFileName(i : integer) : integer;
  var tt,s : string;
  begin
    Result := -1;
    with MainForm.PlayList do
    begin
      if FileExists(Items[i].SubItems[6]) then
      begin
        CheckItem(Items[i]);
        if Items[i].Data <> nil then
        begin
          tt := tMPEGAudio(Items[i].Data^).Textilize(FileNameMask);
          s := MakeCorrectName(ExtractFilePath(Items[i].SubItems[6]) + tt + '.mp3');
          if (s<>'')and(s <> Items[i].SubItems[6]) then
          begin
            Result := integer(RenameFile(Items[i].SubItems[6],s) = false);
            if Result = 0 then
            begin
              Items[i].SubItems[6] := s;
              RefreshItem(Items[i]);
            end;
          end;
        end;
      end;
    end;
  end;

begin
  with MainForm.PlayList do
  begin
    sc := SelCount;
    if sc > 0 then
    begin
      if AskFileMask then mask := AskMask;
      if trim(mask) = '' then exit;
      done := 0;
      for i := 0 to Items.Count - 1 do if Assigned(Items[i]) then if Items[i].Selected then
      begin
        inc(done);
        RenameItemFileName(i);
        if done >= sc then break;
      end;
      PlayListOnChange;
    end;
  end;
end;

procedure ClearList;
begin
  if ConfClearList then
  begin
    if MessageDlg('Вы действительно хотите очистить плейлист?',mtWarning,[mbOK,mbCancel],0) = mrCancel then exit;
  end;
  MainForm.PlayList.Items.Clear;
  TotalTime := 0;
  PlayListOnChange;
  PaintSkin;
end;

procedure RefreshItems;
var i : integer;
begin
  with MainForm.PlayList do
  begin
    if Sel then
    begin
      if SelCount > 0 then
        for i := Selected.Index to Items.Count - 1 do if Items[i].Selected then RefreshItem(Items[i]);
    end else
    begin
      for i := 0 to Items.Count - 1 do RefreshItem(Items[i]);
    end;
  end;
end;

function  DecodeTimeSt(ts : string) : integer;
var i,t,e : integer;
    s : string;
begin
  Result := 0;
  ts := trim(ts);
{  ts := '1:00:00';{}
  if length(ts) > 0 then
  begin
    i := length(ts);
    s := '';
    while (i > 2)and(ts[i] in ['0'..'9']) do begin s := ts[i] + s; dec(i); end;
    while (i > 1)and(not (ts[i] in [':'])) do dec(i);
    if (i > 1)and(ts[i]=':') then
    begin
      val(s,t,e);
      if (e = 0) then
      begin
        Result := t;
        dec(i);
        s := '';
        while (i > 0)and(ts[i] in ['0'..'9']) do begin s := ts[i] + s; dec(i); end;
        val(s,t,e);
        if (e = 0) then
        begin
          Result := Result + t*60;

          dec(i);
          s := '';
          while (i>0)and(ts[i] in ['0'..'9']) do begin s := ts[i] + s; dec(i); end;
          if (i >= 0) then
          begin
            val(s,t,e);
            if (e = 0) then
            begin
              Result := Result + t*(60*60);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure CheckItem(li : tListItem);
var mpa : ^tMPEGAudio;
begin
  if li<>nil then if li.Data=nil then
  begin
    new(mpa);
    mpa^ := tMPEGAudio.Create;
    mpa^.AutoLoad := true;
    mpa^.File_Name := ExpandFileName(li.SubItems[6]);
    if (FileExists(mpa^.File_Name))and(mpa^.LoadData = 0) then
    with li do
    begin
      Data := mpa;
      RefreshItem(li);
    end else mpa^.Free;
  end;
end;

procedure SetPlayMode(pm : integer);
begin
  case pm of
  pmNormal:
  begin
    PlayMode := pmNormal;
    MainForm.smiNormalMode.Checked  := true;
    MainForm.smiRandomMode.Checked  := false;
{    MainForm.smiReverseMode.Checked := false;{}
    aBtns[15].s := 0;
  end;
  pmRandom:
  begin
    PlayMode := pmRandom;
    MainForm.smiNormalMode.Checked  := false;
    MainForm.smiRandomMode.Checked  := true;
{    MainForm.smiReverseMode.Checked := false;{}
    aBtns[15].s := 1;
  end;
(*
  pmReverse:
  begin
    PlayMode := pmReverse;
    MainForm.smiReverseMode.Checked := true;
    MainForm.smiNormalMode.Checked  := false;
    MainForm.smiRandomMode.Checked  := false;
  end;
*)
  end;
  PaintSkin;
end;

procedure MoveItem(j,n : integer);
begin
  with MainForm.PlayList do
  begin
    if (Items.Count < 1)or(n = 0) then exit;

    MovingItems := true;
    Items.BeginUpdate;

    if n > 0 then
    begin
      if j - n < 0 then n := j;
      if j = LastPlayed then
      begin
        LastPlayed := j - n;
      end else
      begin
        if (j - n <= LastPlayed)and(j > LastPlayed) then
        begin
          inc(LastPlayed);
        end;
      end;
      with Items.Insert(j - n) do
      begin
        inc(j);
        Assign(Items[j]);
        Selected := Items[j].Selected;
        Focused := Items[j].Focused;
      end;
      DoNotFree := true;
      Items[j].Delete;
      DoNotFree := false;
    end else
    begin
      n := -n;
      if j + n >= Items.Count then n := Items.Count - j;
      if j = LastPlayed then
      begin
        LastPlayed := j + n;
      end else
      begin
        if (j + n >= LastPlayed)and(j < LastPlayed) then
        begin
          dec(LastPlayed);
        end;
      end;
      with Items.Insert(j + n + 1) do
      begin
        Assign(Items[j]);
        Selected := Items[j].Selected;
        Focused  := Items[j].Focused;
      end;
      DoNotFree := true;
      Items[j].Delete;
      DoNotFree := false;
    end;

    Items.EndUpdate;
    MovingItems := false;
  end;
end;

procedure MoveSel(n : integer);
var j,nm,sc : integer;
begin
  with MainForm.PlayList do
  begin
    sc := SelCount;
    if (sc <= 0)or(n = 0) then exit;
    MovingItems := true;
    Items.BeginUpdate;

    if n > 0 then
    begin
      j  := Selected.Index;
      if (j > 0) then
      begin
        if j - n < 0 then n := j;
        nm := 0;
        while (j < Items.Count) do
        begin
          if Items[j].Selected then
          begin
            MoveItem(j,n);
            inc(nm);
            if nm >= sc then break;
          end else inc(j);
        end;
      end;
    end else
    begin
      n := -n;
      j := Items.Count - 1;
      while j >= 0 do if Items[j].Selected then break else dec(j);
      if j >= 0 then
      begin
        if j + n >= Items.Count then n := (Items.Count-j-1);
        if (n > 0)and(j < Items.Count-1) then
        begin
          nm := 0;
          while (j >= 0) do
          begin
            if Items[j].Selected then
            begin
              MoveItem(j,-n);
              inc(nm);
              if nm >= sc then break;
            end;
            dec(j);
          end;
        end;
      end;
    end;

    Items.EndUpdate;
    MovingItems := false;
  end;
end;

procedure MoveSelHome;
begin
  MoveSel(MainForm.PlayList.Items.Count);
end;

procedure MoveSelEnd;
begin
  MoveSel( -MainForm.PlayList.Items.Count );
end;

procedure GroupSelected;
var lp,done,sc,i : integer;
begin
  with MainForm.PlayList do
  begin
    sc := SelCount; if sc <= 1 then exit;
    done := 0; i := Selected.Index; lp := i;
    MovingItems := true;
    while (i < Items.Count) do
    begin
      if Assigned(Items[i]) then if (Items[i].Selected) then
      begin
        if (i - lp >= 1) then MoveItem(i,i - lp);
        inc(lp);
        inc(done);
        if done >= sc then break;
      end;
      inc(i);
    end;
    MovingItems := false;
  end;
end;

procedure MoveSelToCur;
var lp,done,sc,i : integer;
begin
  with MainForm.PlayList do
  begin
    if LastPlayed < 0 then exit;
    sc := SelCount;
    done := 0;
{    if (sc <= 1)or(LastPlayed < 0)or(Selected = nil)or(lp < LastPlayed) then exit;{}
    MovingItems := true;
    Items.BeginUpdate;

    i := Items.Count - 1;
    while (i > LastPlayed + done) do
    begin
      if (Assigned(Items[i]))and(Items[i].Selected) then
      begin
        lp := i - (LastPlayed) - 1;
        MoveItem(i,lp);
        inc(done);
        if done >= sc then break;
      end else dec(i);
    end;

    i := LastPlayed - 1;
    while (i >= 0) do
    begin
      if (Assigned(Items[i]))and(Items[i].Selected) then
      begin
        lp := i - (LastPlayed);
        MoveItem(i,lp);
        inc(done);
        if done >= sc then break;
      end;
      dec(i);
    end;

    Items.EndUpdate;
    MovingItems := false;
  end;
end;

procedure AppExit;
begin
  MainForm.Close;
end;

procedure DrawSliders;
begin
  MainSlider.Draw;
  VolSlider.Draw;
  BalSlider.Draw;
end;

procedure PaintSkin;
var ss,mm,hh,cw,ch,w,i : integer;
    s : string;
begin
  if (Buf = nil)or(Skin = nil)or(MainForm = nil) then Exit;
  try
    Painting := true;
    cw := MainForm.ClientWidth;
    ch := MainForm.ClientHeight;
    if cw > Buf.Width then Buf.Width  := cw;
    if ch > Buf.Height then Buf.Height := ch;
  {  pHDC := MainForm.Canvas.Handle;{}
    if Activ1 then
    begin
      MainForm.Canvas.Brush.Color := clBlack;
      MainForm.Canvas.Brush.Style := bsSolid;
      MainForm.Canvas.FillRect(Rect(0,0,MainForm.Width,MainForm.Height));
      MainForm.Canvas.Font.Assign(MainForm.SecretEdit.Font);
      MainForm.Canvas.TextOut(5,5,'Loading Internal Matrix Terminal...');
    end else
    if SecretActivated then
    begin
      DrawSecret1;
    end else
    begin
      pHDC := Buf.Canvas.Handle;{}
      if IsActive then
       bitblt(pHDC,000,000,025,032,
              Skin.Canvas.Handle,000,000,SRCCOPY) else
       bitblt(pHDC,000,000,025,032,
              Skin.Canvas.Handle,000,033,SRCCOPY);
      i := 25;
      while (i + 25 <= cw - 75) do
      begin
        if IsActive then
         bitblt(pHDC,i,0,025,032,
                Skin.Canvas.Handle,127,000,SRCCOPY)
        else
         bitblt(pHDC,i,0,025,032,
                Skin.Canvas.Handle,127,033,SRCCOPY);
        inc(i,25);
      end;
      w := (cw - 75) - i;
      if w > 0 then
      begin
        if IsActive then
         bitblt(pHDC,i,0,w,032,
                Skin.Canvas.Handle,127,000,SRCCOPY)
        else
         bitblt(pHDC,i,0,w,032,
                Skin.Canvas.Handle,127,033,SRCCOPY);
      end;
      if IsActive then
       bitblt(pHDC,cw - 075,000,075,032,
              Skin.Canvas.Handle,153,000,SRCCOPY)
      else
       bitblt(pHDC,cw - 075,000,075,032,
              Skin.Canvas.Handle,153,033,SRCCOPY);

      if IsActive then // Center
       bitblt(pHDC,cw div 2 - 100 div 2,000,100,032,
              Skin.Canvas.Handle,026,000,SRCCOPY)
      else
       bitblt(pHDC,cw div 2 - 100 div 2,000,100,032,
              Skin.Canvas.Handle,026,033,SRCCOPY);

      i := 32;
      while (i + 29 <= ch - 70) do
      begin
        bitblt(pHDC,0,i,025,029,
               Skin.Canvas.Handle,182,156,SRCCOPY);
        bitblt(pHDC,cw - 25,i,025,029,
               Skin.Canvas.Handle,208,156,SRCCOPY);
        inc(i,29);
      end;
      w := (ch - 70) - i;
      if w > 0 then
      begin
        bitblt(pHDC,0,i,025,w,
               Skin.Canvas.Handle,182,156,SRCCOPY);
        bitblt(pHDC,cw - 25,i,025,029,
               Skin.Canvas.Handle,208,156,SRCCOPY);
      end;
      bitblt(pHDC,0,ch - 070,240,070,
             Skin.Canvas.Handle,000,227,SRCCOPY);
      i := 240;
      while (i + 25 <= cw - 155) do
      begin
        bitblt(pHDC,i,ch - 70,025,070,
               Skin.Canvas.Handle,156,156,SRCCOPY);
        inc(i,25);
      end;
      w := (cw - 155) - i;
      if w > 0 then bitblt(pHDC,i,ch - 70,w,070,
                            Skin.Canvas.Handle,156,156,SRCCOPY);

      bitblt(pHDC,cw - 155,ch - 070,155,070,
             Skin.Canvas.Handle,000,156,SRCCOPY);

      for i := 1 to nBtns do
      begin
        if aBtns[i].s = 0 then
          bitblt(pHDC,abtns[i].x,abtns[i].y,abtns[i].w,abtns[i].h,
                 Skin.Canvas.Handle,abtns[i].sx1,abtns[i].sy1,SRCCOPY)
        else
          bitblt(pHDC,abtns[i].x,abtns[i].y,abtns[i].w,abtns[i].h,
                 Skin.Canvas.Handle,abtns[i].sx2,abtns[i].sy2,SRCCOPY)
      end;
      DrawSliders;
      if TotalTime < 0 then TotalTime := 0;
      hh := TotalTime div (60*60);
      i := (TotalTime - hh*(60*60));
      mm := i div 60;
      ss := i mod 60;
      s := lz(hh,1,' ')+':'+lz(mm,2,'0')+':'+lz(ss,2,'0');
      writemyst(s,cw - 102,ch - 28,9);{}
      if IsPlaying then
      begin
        writemyst(PlayTimeSt,cw - 84,ch - 15,6);{}
      end;
    {  writemyst(s,cw - 83,ch - 15);{}
    {  writemyst(s,cw - length(s)*6 - 50,ch - 28);{}
      DrawMyList;
      if pHDC <> MainForm.Canvas.Handle then
      bitblt(MainForm.Canvas.Handle,000,000,cw,ch,
             pHDC,000,000,SRCCOPY);
    end;
  finally
    Painting := false;
  end;
end;

procedure PlayListAutoFit;
var i : integer;
begin
{  MainForm.PlayList.Items.BeginUpdate;{}
  with MainForm.PlayList.Columns do
  begin
    for i := 0 to count-1 do
    begin
      Items[i].Width := -1;{}
      Items[i].Width := ListView_GetColumnWidth(MainForm.PlayList.Columns.Owner.Handle, I);{}
    end;
  end;
{  MainForm.PlayList.Items.EndUpdate;{}
end;

procedure SortBy(sm : integer);
var oldp,newp : pointer;
    i : integer;
    vp : boolean;
begin
  if MainForm.PlayList.Items.Count <= 0 then exit;
  if LastSort = sm then
  begin
    RevSort  := not RevSort;
    SortMode := LastSort;
  end else SortMode := sm;
  with MainForm.PlayList do
  begin
    newp := nil; oldp := nil;
    vp := ValidLP(LastPlayed);
    if vp then
    begin
      oldp := Items[LastPlayed].Data;
      getmem(newp,1);
      Items[LastPlayed].Data := newp;
    end;
    AlphaSort;
    if vp then
    begin
      for i := 0 to Items.Count - 1 do if Items[i].Data = newp then break;
      if Items[i].Data = newp then
      begin
        LastPlayed := i;
        if FocusAfterChangeSong then SetTopItem(LastPlayed);{}
        Items[i].Data := oldp;
      end else LastPlayed := -1;
      freemem(newp,1);
    end;
  end;
  LastSort := SortMode;
  SortMode := smNone;
end;

procedure tMainForm.WMEraseBkgnd(var m : TWMEraseBkgnd);
begin
  m.Result := LRESULT(true);
end;

function AddDir(Path : string; ps : integer) : integer;
var i,StartPs,Num : integer;

  function AddPath(Path : string) : integer;
  var sr : TSearchRec;

    function AddItem : integer;
    var ft : integer;
        li : tListItem;
    begin
      if sr.Attr and faDirectory = 0 then
      begin
        ft := GetFileType(path+sr.name);
        if (ft = FT_MPEG_AUDIO) then
        begin
          inc(tf);
          if Assigned(StatusForm) then StatusForm.UpdateLabels;
//          if Assigned(StatusForm) then StatusForm.NameEdit.Text:= path+sr.name;
          Application.ProcessMessages;
          if ps >= 0 then
          begin
            li := MainForm.PlayList.Items.Insert(ps);
          end else
          begin
            li := MainForm.PlayList.Items.Add;
          end;
          if li <> nil then with li do
          begin
            while SubItems.Count < 7 do SubItems.Add('');
            SubItems[6] := Path + sr.name;
            inc(num);
            if ps >= 0 then inc(ps);
          end;
(*
          if AddFile(Path + sr.name,ft,ps) = mrCancel then
          begin
            Result := mrCancel; exit;
          end;
*)
        end;
      end else if (sr.Name<>'.')and(sr.Name<>'..')and(RecursiveDirs) then
      begin
        inc(td);
        if Assigned(StatusForm) then StatusForm.NameEdit.text := Path;
        if Assigned(StatusForm) then StatusForm.UpdateLabels;
        Application.ProcessMessages;
        if AddPath(Path+sr.Name) = mrCancel then
        begin
          Result := mrCancel;
          exit;
        end;
      end;
      Result := 0;
    end;

  begin
    Result := -1;
    if (Path='')or(StopProc) then exit else Path := AddSlash(Path);
    if (FindFirst(Path+'*.*',faAnyFile,sr) = 0)and(not StopProc) then
    begin
      if AddItem = 0 then
      while (FindNext(sr) = 0)and(not StopProc) do if AddItem <> 0 then break;
      Result := 0;
    end;
    FindClose(sr);
  end;

begin
  Result := -1;
  if (Path='')or(StopProc) then exit else Path := AddSlash(Path);
  td := 0; tf := 0; num := 0;
  if ps < 0 then StartPs := MainForm.PlayList.Items.Count-1 else StartPs := ps;
  if StartPs < 0 then StartPs := 0;
  if Assigned(StatusForm) then StatusForm.NameEdit.text := Path;
  inc(td);
  MainForm.PlayList.Items.BeginUpdate;
  AddPath(Path);
  MainForm.PlayList.Items.EndUpdate;
  inc(num);

  if num > 0 then
  begin
    if Assigned(StatusForm) then
    begin
  //  StatusForm.PathEdit.Visible := false;
      StatusForm.ProgGauge.Visible := true;
    end;
    StatusForm.ProgGauge.MinValue := 0;
    StatusForm.ProgGauge.MaxValue := 100;
    for i := StartPs to (StartPs+num) do
    begin
      if StopProc then break;
      StatusForm.ProgGauge.Progress := round(((i-StartPs)/(num))*100);
      if MainForm.PlayList.Items[i] <> nil then StatusForm.NameEdit.text := MainForm.PlayList.Items[i].SubItems[6]
        else StatusForm.NameEdit.text := '';
      RefreshItem(MainForm.PlayList.Items[i]);
      Application.ProcessMessages;
    end;
  end;
  if Assigned(StatusForm) then StatusForm.UpdateLabels;
  Result := 0;
end;

procedure AddDirs;
begin
  MainForm.OpenFolderDlg.SelectedPathName := LastOpenDir;
  if MainForm.OpenFolderDlg.Execute then
  begin
    LastOpenDir := MainForm.OpenFolderDlg.SelectedPathName;
    Act := acNone;
    StatusForm := tStatusForm.Create(Application);
    with StatusForm do
    try
      Act := acAddDirs;
      ShowModal;
     finally
      Free;
    end;
    LastOpenDir := MainForm.OpenFolderDlg.SelectedPathName;
    PlayListOnChange;
  end;
end;

function  SaveNKSList (FileName : string; RelativePath,SelectedOnly : Boolean) : integer;
var f : textfile;
    i : integer;
    OutStr : string;
begin
{$I-}
  AssignFile(f,FileName);
  ReWrite(f);
  Result := IOResult;
  if (not FatalIOError(Result)) then with MainForm.PlayList.Items do
  begin
    writeln(f,'[NKSPlayList]');
    for i := 0 to Count - 1 do with MainForm.PlayList.Items[i] do
    if not SelectedOnly or (SelectedOnly and (Selected)) then
    begin
{$IFDEF _DEMO_}
        if i > Demo_Count then break;
{$ENDIF}
{
      CheckItem(i);
      if Item[i].Data<>nil then
      with tMPEGAudio(Item[i].data^) do
}
      begin
        OutStr := SubItems[6];
        if RelativePath and
           (AnsiUpperCase (Copy (OutStr, 1, Length(ExtractFilePath (FileName)))) =
            AnsiUpperCase (ExtractFilePath (FileName)))
         then OutStr := Copy (OutStr, Length(ExtractFilePath (FileName)) + 1, Length (OutStr));
        writeln(f,'FILE:'+OutStr);
        writeln(f,'Artist:'+Caption);
        writeln(f,'SongTitle:'+SubItems[0]);
        writeln(f,'Genre:'+SubItems[4]);
        writeln(f,'Album:'+SubItems[1]);
        writeln(f,'Year:'+SubItems[2]);
        writeln(f,'Comments:'+SubItems[3]);
        writeln(f,'Time:'+SubItems[5]); {inttostr(DecodeTimeSt(SubItems[5]))}
        Result := IOResult; if (FatalIOError(Result)) then break;
      end;
    end;
    if Result = 0 then Result := IOResult;
  end;
{  Flush(f);{}
  CloseFile(f);
{$I+}
end;

function SavePLSList (FileName : string; RelativePath,SelectedOnly : Boolean) : integer;
var
  F : Integer;
  outfile : TINIFile;
  outstr : string;
  startcount : Integer;

begin
  FileName := ExpandFileName (FileName);
  outfile  := TINIFile.Create (FileName);

  try
    StartCount := 1;
    outfile.EraseSection (PLSSection);

    Result := 0;
    For f := 0 to MainForm.PlayList.Items.Count-1 do
    begin
{$IFDEF _DEMO_}
        if f > Demo_Count then break;
{$ENDIF}
      if not SelectedOnly or (SelectedOnly and (MainForm.PlayList.Items[F].Selected)) then
      begin
        CheckItem(MainForm.PlayList.Items.Item[f]);
        outstr := MainForm.PlayList.Items.Item[f].SubItems[6];
        if RelativePath and
           (AnsiUpperCase (Copy (OutStr, 1, Length(ExtractFilePath (FileName)))) =
            AnsiUpperCase (ExtractFilePath (FileName)))
         then OutStr := Copy (OutStr, Length(ExtractFilePath (FileName)) + 1, Length (OutStr));
        outfile.WriteString (PLSSection, 'File' + IntToStr(f + StartCount), OutStr);
        OutStr := tMPEGAudio(MainForm.PlayList.Items.Item[f].data^).Textilize(PlayListsMask);
        outfile.WriteString (PLSSection, 'Title' + IntToStr(f+StartCount), tMPEGAudio(MainForm.PlayList.Items.Item[f].data^).Textilize(PlayListsMask));
        outfile.WriteInteger (PLSSection, 'Length' + IntToStr(f+StartCount), tMPEGAudio(MainForm.PlayList.Items.Item[f].data^).Duration);
      end; { if selected }
    end; { for }
    OutFile.WriteInteger (PLSSection, 'NumberOfEntries', startcount + MainForm.PlayList.Items.Count - 1);
    OutFile.WriteInteger (PLSSection, 'Version', 2);
    OutFile.Free;
  except
    Result := -1;
  end;
end; { Function }

function  SaveM3UList (FileName : string; RelativePath,SelectedOnly : Boolean) : integer;
var f : textfile;
    i : integer;
    outstr : string;
begin
{$I-}
  AssignFile(f,FileName); rewrite(f);
  Result := IOResult;
  if not FatalIOError(Result) then with MainForm.PlayList.Items do
  begin
    if MakeExtM3U then writeln(f,'#EXTM3U');
    for i := 0 to Count - 1 do
    if not SelectedOnly or (SelectedOnly and (MainForm.PlayList.Items[i].Selected)) then
    begin
{$IFDEF _DEMO_}
        if i > Demo_Count then break;
{$ENDIF}
      CheckItem(Item[i]);
      if (Item[i].Data<>nil) then with tMPEGAudio(Item[i].data^) do
      begin
        if MakeExtM3U then
        begin
          writeln(f,'#EXTINF:'+inttostr(Duration)+',' + Textilize(PlayListsMask));
          Result := IOResult; if (FatalIOError(Result)) then break;
        end;
        OutStr := tMPEGAudio(Item[i].data^).File_Name;
        if RelativePath and
           (AnsiUpperCase (Copy (OutStr, 1, Length(ExtractFilePath (FileName)))) =
            AnsiUpperCase (ExtractFilePath (FileName)))
         then OutStr := Copy (OutStr, Length(ExtractFilePath (FileName)) + 1, Length (OutStr));
        writeln(f,OutStr);
      end;
    end;
    Flush(f);
    CloseFile(f);
    if Result = 0 then Result := IOResult;
  end;
{$I+}
end;

function  LoadPLSList (FileName : string) : integer;
var
  i, count : Integer;
  PLSList : TINIFile;
  tempstr : string;
  pf : TProgressForm;

begin
  { Load playlist }
  PLSList := TINIFile.Create (FileName);
  count := 0;
  Result := 0;

  try
    count := PLSList.ReadInteger (PLSSection, 'NumberOfEntries', 0);
  except
    Result := -1;
  end; {try}

  { if playlist file has been read ok then we should process it }
  if Result = 0 then
  begin
    pf := TProgressForm.Create(Application);
    MainForm.Enabled := false;
    pf.Show;
    for i := 1 to count do
    begin
{$IFDEF _DEMO_}
        if i > Demo_Count then break;
{$ENDIF}
      if prStop then break;
      pf.ProgressGauge.Progress := round((i/count)*100);
      Application.ProcessMessages;
      try
        tempstr := PLSList.ReadString (PLSSection, 'File'+IntToStr(i), '');
        if tempstr <> '' then
        begin
          if (length(tempstr)>=2) then
           if (tempstr[2] <> ':') then
            if tempstr[1] = '\' then
              tempstr := Copy (FileName,1,2) + tempstr
            else
                tempstr := ExtractFilePath (FileName) + tempstr;

          Result := AddFile (tempstr,GetFileType(tempstr),-1);
          if Result <> 0 then break;
        end;
      except
        Result := -1;
        Break;
      end;
{        if (i MOD 30) = 0 then winProcessMessages;}
    end; { for }
    pf.ProgressGauge.Progress := 100;
    Application.ProcessMessages;

    MainForm.Enabled := true;
    pf.Close;
    pf.Free;
  end; { if Result = 0 }
  PLSList.Free;
end;

function  LoadM3UList (FileName : string) : integer;
var s,t : string;
    i,nf : integer;
    pf : TProgressForm;
    stl : TStringList;
begin
{$I-}
  Result := -1;
{  FileName := ExpandFileName(FileName);{}
  if not FileExists(FileName) then exit;
  stl := TStringList.Create;
  pf := TProgressForm.Create(Application);
  MainForm.Enabled := false;
  try
    pf.Show;
{    FileName := ExpandFileName(FileName);{}
    stl.LoadFromFile(FileName);
    i := 0; nf := 0;
    if stl.Count > 0 then
    while (i < stl.count) do
    begin
      if prStop then break;
      pf.ProgressGauge.Progress := round((i/stl.count)*100);
      Application.ProcessMessages;
      s := stl.Strings[i];
      inc(i);
      t := uppercase(trim(s));
      if (t<>'')and(t<>'#EXTM3U')and(copy(t,1,8)<>'#EXTINF:') then
      begin
        if (length(s) >= 2) then
         if (s[2] <> ':') then
          { if item is full path then use it as is }
          if s[1] = '\' then
            { if item path starts with \ then add Playlist drive }
            s := Copy (FileName,1,2) + s
          else
            { in other cases assume that item contains relative path to PlayList path }
              s := ExtractFilePath (FileName) + s;

        Result := AddFile (s,GetFileType(s),-1);
        inc(nf);
{$IFDEF _DEMO_}
        if nf > Demo_Count then break;
{$ENDIF}
{        if Result <> 0 then break;}
      end;
    end;

    pf.ProgressGauge.Progress := 100;
    Application.ProcessMessages;

  finally
    MainForm.Enabled := true;
    pf.Close;
    pf.Free;
    stl.free;
    MainForm.Enabled := true;
  end;
{$I+}
end;

function  LoadNKSList (FileName : string) : integer;
var p : integer;
{$IFDEF _DEMO_}
    nf : integer;
{$ENDIF}
    s,tempstr : string;
    sName,sTitle,sArtist,sAlbum,sYear,sTime,sGenre,sComment : string;
    first : boolean;

procedure AddIt;
var ii : integer;
begin
  if sName = '' then exit;
  with MainForm.PlayList.Items.Add do
  begin
    Data := nil;
    Caption := sArtist;
    while SubItems.Count < 7 do SubItems.Add('');
    SubItems[0] := sTitle;
    SubItems[1] := sAlbum;
    SubItems[2] := sYear;
    SubItems[3] := sComment;
    SubItems[4] := sGenre;
    SubItems[5] := sTime;
    TotalTime   := TotalTime + DecodeTimeSt(sTime);
    s := sName;
    if (length(s) >= 2) then
     if (s[2] <> ':') then
      { if item is full path then use it as is }
      if s[1] = '\' then
        { if item path starts with \ then add Playlist drive }
        s := Copy (FileName,1,2) + s
      else
        { in other cases assume that item contains relative path to PlayList path }
          s := ExtractFilePath (FileName) + s;

    SubItems[6] := s;
  end{ else begin mpa^.Free; Dispose(mpa); end};
  ii := AddMyListItem(-1);
  if ii > 0 then
  begin
    with MyPlayList.Items[ii] do
    begin
      MyPlayList.Items[ii].fName := s;
      MyPlayList.Items[ii].Title := sTitle;
      MyPlayList.Items[ii].Artist := sArtist;
      MyPlayList.Items[ii].Year   := sYear;
      MyPlayList.Items[ii].Comment := sComment;
      MyPlayList.Items[ii].Time := DecodeTimeSt(sTime);
      MyPlayList.Items[ii].Genre := sGenre;
      MyPlayList.Items[ii].MPA := nil;
      MyPlayList.Items[ii].nPlayed := 0;
      MyPlayList.Items[ii].Selected := false;
      MyPlayList.Items[ii].Flag := false;
      MyPlayList.Items[ii].TagTitle := s;
    end;
  end;

end;

var tf : textfile;

begin
{$I-}
  Result := -1;
{  FileName := ExpandFileName(FileName);{}
  if not FileExists(FileName) then exit;
  sName := ''; sTitle := ''; sArtist := ''; sAlbum := '';
  sYear := ''; sTime := ''; sGenre := ''; sComment := '';
  First := false;
  MainForm.Enabled := false;
  try
  begin
    assignfile(tf,filename); reset(tf);
{$IFDEF _DEMO_}
    nf := 0;
{$ENDIF}
    while (not eof(tf)) do
    begin
      Application.ProcessMessages;
      readln(tf,s);
      s := uppercase(trim(s));
      if s = '[NKSPLAYLIST]' then
      begin
        first := true;
        break;
      end;
    end;
    if First then
    begin
      while (not eof(tf)) do
      try
{$IFDEF _DEMO_}
        if nf > Demo_Count then break;
{$ENDIF}
        readln(tf,tempstr);
        Application.ProcessMessages;
        p := pos(':',tempstr);
        if p > 0 then
        begin
          s := uppercase(copy(tempstr,1,p-1));
          delete(tempstr,1,p);
          if s = 'FILE' then
          begin
            if not First then
            begin
              AddIt;
{$IFDEF _DEMO_}
        inc(nf);
{$ENDIF}
            end else First := false;
            if tempstr <> '' then
            begin
              if tempstr[2] <> ':' then
                if tempstr[1] = '\' then
                  tempstr := Copy (FileName,1,2) + tempstr
                else
                    tempstr := ExtractFilePath (FileName) + tempstr;
              sName := tempstr;
            end;
          end else
          if s = 'ARTIST' then sArtist := tempstr else
          if s = 'SONGTITLE' then sTitle := tempstr else
          if s = 'ALBUM' then sAlbum := tempstr else
          if s = 'YEAR' then sYear := tempstr else
          if s = 'GENRE' then sGenre := tempstr else
          if s = 'COMMENTS' then sComment := tempstr else
          if s = 'TIME' then sTime := tempstr else
        end;
      except
(*
        Result := -1;
        Break;
*)
      end;
      if (not First) then
      begin
        AddIt;
      end;
    end;
    CloseFile(tf);
    Application.ProcessMessages;
    PaintSkin;
    Result := 0;

    MainForm.Enabled := true;
  end
  except
    MainForm.Enabled := true;
    Result := -1;
  end;
{$I+}
end;

function AddSlash(Path : string) : string;
begin
  if Path<>'' then if Path[length(Path)]<>'\' then Path := Path + '\';
  Result := Path;
end;

function AddFile;
var mpp : ^tMPEGAudio;
    li : tListItem;
begin
  case ft of
  FT_MPEG_AUDIO:
  begin
    new(mpp);
    mpp^ := tMPEGAudio.Create;
    mpp^.AutoLoad := true;
    mpp^.File_Name := FileName;
    Result := mpp^.LoadData;
    if ps >= 0 then
    begin
      li := MainForm.PlayList.Items.Insert(ps);
    end else
    begin
      li := MainForm.PlayList.Items.Add;
    end;
    if li <> nil then with li do
    begin
      Data := mpp;
      Caption := mpp^.data.Artist;
      while SubItems.Count < 7 do SubItems.Add('');
      SubItems[0] := mpp^.Data.Title;
      SubItems[1] := mpp^.Data.Album;
      SubItems[2] := mpp^.Data.Year;
      SubItems[3] := mpp^.Data.Comment;
      SubItems[4] := mpp^.Data.Genre;
      SubItems[5] := TimeSt(mpp^.Duration,true);
      TotalTime   := TotalTime + mpp^.Duration;
      SubItems[6] := FileName;
      Result := 0;
    end else begin mpp^.Free; Dispose(mpp); end;
  end;
  FT_WINAMP_PLAYLIST: Result := LoadM3UList(FileName);
  FT_PLS_PLAYLIST: Result := LoadPLSList(FileName);
  FT_NKS_PLAYLIST: Result := LoadNKSList(FileName);
  else Result := -1;
  end;
  PaintSkin;
end;

procedure DelSelFromList;
begin
  MainForm.PlayList.Items.BeginUpdate;
  while MainForm.PlayList.SelCount > 0 do
  begin
    MainForm.PlayList.Selected.Delete;
  end;
  if FocusDel then
  begin
    if MainForm.PlayList.SelCount <= 0 then
     if MainForm.PlayList.ItemFocused<>nil then MainForm.PlayList.Selected := MainForm.PlayList.ItemFocused;
  end;
  MainForm.PlayList.Items.EndUpdate;
  PaintSkin;
end;

procedure DelSelFromDisk;
var s : string;
    DelOK : boolean;
    oldattr,done,sc : integer;
begin
  done := 0; sc := MainForm.PlayList.SelCount;
  DelOK := true;
  if ConfDiskDel then
  case MessageDlg('Вы действительно хотите Удалить эти файл(ы) с Диска?',mtWarning,[mbCancel,mbOK],0) of
   mrCancel: exit; 
   mrOK: DelOK := true;
   mrIgnore: DelOK := false;
  end;
  if DelOK then
  begin
    MainForm.PlayList.Items.BeginUpdate;
    while MainForm.PlayList.SelCount > 0 do
    begin
      s := MainForm.PlayList.Selected.SubItems[6];
      if FileExists(s) then
      begin
        oldattr := FileGetAttr(s);
        if ((oldattr and faReadOnly) <> 0) then
        begin
          if ConfDelRO then if MessageDlg('Файл "'+s+'" доступен "только-для-чтения"'#13#10'Вы действительно хотите удалить его?',mtWarning,[mbOK,mbCancel],0) <> mrOK then DelOK := false;
          if DelOK then
          begin
            FileSetAttr(s,oldattr and (not faReadOnly));
          end;
        end;
        if DeleteFile(s) then
        begin
          MainForm.PlayList.Selected.Delete;

          if FocusDel then
          begin
            if MainForm.PlayList.SelCount <= 0 then
             if MainForm.PlayList.ItemFocused<>nil then MainForm.PlayList.Selected := MainForm.PlayList.ItemFocused;
          end;
        end else MessageDlg('Ошибка удаления файла "'+s+'"!',mtError,[mbok],0);
      end;
      inc(done); if done >= sc then break;
    end;
    MainForm.PlayList.Items.EndUpdate;
  end;
  if done > 0 then
  begin
    PlayListOnChange;
    PaintSkin;
  end;
end;

procedure DelCurFromList;
begin
  PlayListOnChange;
  PaintSkin;
end;

procedure DelCurFromDisk;
begin
  PlayListOnChange;
  PaintSkin;
end;

procedure AddFiles;
var i : integer;
begin
  with MainForm.OpenDlg do
  begin
    InitialDir := LastFileDir;
    if Execute then
    begin
      MainForm.PlayList.Items.BeginUpdate;
      for i:=0 to Files.Count-1 do
      begin
        if AddFile(Files[i],GetFileType(Files[i]),-1) = mrCancel then break;
      end;
      MainForm.PlayList.Items.EndUpdate;
      LastFileDir := ExtractFilePath(FileName);
      PlayListOnChange;
    end;
  end;
end;

procedure LoadList;
var i : integer;
    ffName : string;
begin
  with MainForm.LoadListDlg do
  begin
    InitialDir := LoadListLastDir;
    if Execute then
    begin
      if clr then ClearList;
      for i := 0 to Files.Count - 1 do
      begin
        ffName := Files[i];
        case GetFileType(ffName) of
         FT_WINAMP_PLAYLIST: LoadM3UList(ffName);
         FT_PLS_PLAYLIST: LoadPLSList(ffName);
         FT_NKS_PLAYLIST: LoadNKSList(ffName);
        end;
      end;
      LoadListLastDir := ExtractFilePath(ffName);
      PlayListOnChange;
    end;
  end;
end;

procedure SaveList(FileName : string; ft : integer; seOnly : boolean);
begin
  case ft of
  FT_NKS_PLAYLIST: SaveNKSList(FileName,True,seOnly);
  FT_PLS_PLAYLIST: SavePLSList(FileName,True,seOnly);
  else SaveM3UList(FileName,True,seOnly);
  end;
{$IFDEF _DEMO_}
    ShowDemoMsg;
{$ENDIF}
end;

procedure SaveListAs(seOnly : boolean);
var ffName,ext : string;
    ft : integer;
begin
  with MainForm.SaveListDlg do
  begin
    InitialDir := SaveListLastDir;
    if Execute then
    begin
      ffName := ExpandFileName(FileName);
      ext := ExtractFileExt(ffName);
      if ext = '' then
      begin
        case FilterIndex of
        1: ffName := ffName + '.m3u';
        2: ffName := ffName + '.pls';
        3: ffName := ffName + '.nks';
        end;
        ft := GetFileType(ffName);
      end else
      begin
        ft := GetFileType(ffName);
      end;
      SaveList(ffName,ft,seOnly);
    end;
    SaveListLastDir := ExtractFilePath(ffName);
  end;
end;

procedure DelNonExisting;
var i,p : integer;
    pf : TProgressForm;
begin
  pf := TProgressForm.Create(Application);
  try
    pf.Show;
    MainForm.Enabled := false;
    with MainForm.PlayList do
    begin
      Items.BeginUpdate;
      i := Items.Count - 1;
      while (i >= 0) do
      begin
        if prStop then break;
        if i <= 0 then p := 0 else p := round(100 - (i / Items.Count)*100);
        pf.ProgressGauge.Progress := p;
        Application.ProcessMessages;
        if not FileExists(Items[i].Subitems[6]) then Items[i].Delete;
        dec(i);
      end;
      Items.EndUpdate;
      PlayListOnChange;
    end;
  finally
    MainForm.Enabled := true;
    pf.Close;
    pf.Free;
  end;
  PaintSkin;
end;

procedure EditCurTAG;
var li : tListItem;
begin
  with MainForm do
  begin
    li := PlayList.ItemFocused;
    CheckItem(li);
    if li <> nil then
    begin
      if not FileExists(li.SubItems[6]) then
      begin
        if ConfNonExist then MessageDlg('Файл "'+li.SubItems[6]+'" не найден',mtError,[mbOK],0)
      end else if EditFile(li.SubItems[6]) = mrOK then RefreshItem(li);
    end;
  end;
end;

procedure EditSelTags;
begin
  if MainForm.PlayList.SelCount > 0 then EditFilesTag else
  begin
(*
    EditCurTAG;

    var li : tListItem;
    li := MainForm.PlayList.Selected;
    CheckItem(li);
    if li <> nil then if li.Data <> nil then
    begin
      if EditFile(tMPEGAudio(Li.Data^).File_Name) = mrOK then RefreshItem(li);
    end;
*)
  end;
end;

function RefreshItem(it : tListItem) : integer;
begin
  Result := -1;
  CheckItem(It);
  if (It<>nil) then if It.Data<>nil then with It do
  begin
    tMPEGAudio(Data^).File_Name := SubItems[6];
    Result := tMPEGAudio(Data^).LoadData;
    if Result = 0 then
    begin
      Caption := tMPEGAudio(Data^).Data.Artist;
      while SubItems.Count < 7 do SubItems.Add('');
      SubItems[0] := tMPEGAudio(Data^).Data.Title;
      SubItems[1] := tMPEGAudio(Data^).Data.Album;
      SubItems[2] := tMPEGAudio(Data^).Data.Year;
      SubItems[3] := tMPEGAudio(Data^).Data.Comment;
      SubItems[4] := tMPEGAudio(Data^).Data.Genre;
      SubItems[5] := TimeSt(tMPEGAudio(Data^).Duration,true);
      SubItems[6] := tMPEGAudio(Data^).Data.FileName;
    end;
  end;
end;

procedure SelectZero;
begin
  MainForm.PlayList.Selected := nil;
end;

procedure SelectAll;
var i : integer;
begin
  with MainForm.PlayList do
  begin
    for i:=0 to Items.Count - 1
     do Items[i].Selected := true;
  end;
end;

procedure SelectInvert;
var i : integer;
begin
  with MainForm.PlayList do
  begin
    for i:=0 to Items.Count - 1
     do Items[i].Selected := not Items[i].Selected;
  end;
end;

procedure RandomizeList;
begin
  Randomize;
  MainForm.PlayList.AlphaSort;
end;

procedure TMainForm.smiTerminateClick(Sender: TObject);
begin
  AppExit;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ConfExit then
  begin
    if MessageDlg(stExit,mtConfirmation,[mbYes,mbNo],0) in [mrYES,mrOK] then
    begin
      CanClose:=true;
    end else CanClose:=false
  end else CanClose := true;
end;

procedure InitMenu;
begin
(*
var hSysMenu : hMenu;
  hSysMenu := GetSystemMenu(Application.Handle,false);{}
  InsertMenu(hSysMenu,0,MF_STRING or MF_BYPOSITION or MF_SEPARATOR,0, '');
  InsertMenu(hSysMenu,0,{MF_BYPOSITION or }MF_BYPOSITION or MF_POPUP,MainForm.MySysMenu.Handle,'&MP3 NaviGatoR');
  DrawMenuBar(Application.Handle);
*)
(*
InsertMenu(hSysMenu,0,MF_BYPOSITION or MF_POPUP or MF_STRING,MySysMenu.Handle,PChar('new'));
AppendMenu(hSysMenu, MF_SEPARATOR, 1, '');

InsertMenu(hSysMenu,0,MF_BYPOSITION or MF_POPUP or MF_STRING,MySysMenu.Handle,PChar('new'));
AppendMenu(hSysMenu, MF_SEPARATOR, 1, '');
  with SysMenu do
    for I := 0 to Items.Count - 1 do
      AppendMenu (GetSystemMenu (Handle, FALSE),
        MF_POPUP, Items[I].Handle, PChar (Items[I].Caption));
        AppendMenu(hSysMenu,MF_POPUP,SysMenu.Handle,PChar('&MP3 NaviGatoR'));
*)
end;

procedure InitSliders;
begin
  MainSlider := tMySlider.Create;
  with MainSlider do
  begin
    fUpdateEvent := MainForm.MainSliderUpdate;
    fLeft := 8;
    sw  := 28;
    sh  := 12;
    fHeight := sh;
    fWidth := 0;
    sx1 := 237;
    sy1 := 156;
    sx2 := 237;
    sy2 := 156 + sh;
    fMinPos := 0;
    fMaxPos := 0;
    fPosition := 0;
    fSliderVisible := true;
    fTransparent := true;
    fTransColor := clWhite;
    fVertical := false;
  end;

  VolSlider  := tMySlider.Create;
  with VolSlider do
  begin
    fUpdateEvent := MainForm.VolSliderUpdate;
    sw  := 15;
    sh  := 11;
    fHeight := sh;
    fWidth  := 55;
    sx1 := 229;
    sy1 := 205;
    sx2 := 229 + sw;
    sy2 := 205;
    fMinPos := 0;
    fMaxPos := 65535;
//    fPosition := fMaxPos div 2;
    fPosition := ovol;
    AutoSeek := true;
    fSliderVisible  := true;
    fVertical := false;
  end;

  BalSlider  := tMySlider.Create;
  with BalSlider do
  begin
    fUpdateEvent := MainForm.BalSliderUpdate;
    sw  := 15;
    sh  := 11;
    fHeight := sh;
    fWidth  := 37;
    sx1 := 229;
    sy1 := 205;
    sx2 := 229 + sw;
    sy2 := 205;
    fMinPos := 0;
    fMaxPos := 255;
//    fPosition := 0;
    fPosition := obal;
    AutoSeek := true;
    fSliderVisible  := true;
    fVertical := false;
  end;
end;

procedure InitSkin;
var path : string;
begin
  try
    path := SkinsPath;
    if not TrySkinPath(path) then
    begin
      path := BasePath+'Skins\';
      if not TrySkinPath(path) then
      begin
        path := 'Skins\';
        if not TrySkinPath(path) then
        begin
          Application.Terminate;
        end;
      end;
    end;
    EQSkin := tBitmap.Create;
    EQSkin.LoadFromFile(path + 'eqmain.bmp');
    EQBuf  := tBitmap.Create;
    Skin := TBitMap.Create;
    Skin.LoadFromFile(path + 'MainSkin.bmp');
    FontBmp := TBitMap.Create;
    FontBmp.LoadFromFile(path + 'text.bmp');
    Buf  := TBitMap.Create;
    Buf.Width  := Screen.DesktopWidth + 256;
    Buf.Height := Screen.DesktopHeight + 256;
    Buf.Dormant
  except
//    Application.Terminate;
  end;
end;

function GetWaveVolume: DWord;
var Woc : TWAVEOUTCAPS;
    Volume : DWord;
begin
  result:=0;
  if WaveOutGetDevCaps(WAVE_MAPPER, @Woc, sizeof(Woc)) = MMSYSERR_NOERROR then
    if Woc.dwSupport and WAVECAPS_VOLUME = WAVECAPS_VOLUME then
    begin
      WaveOutGetVolume(WAVE_MAPPER, @Volume);
      Result := Volume;
    end;
end;

procedure SetWaveVolume(const AVolume: DWord);
var Woc : TWAVEOUTCAPS;
begin
  if WaveOutGetDevCaps(WAVE_MAPPER, @Woc, sizeof(Woc)) = MMSYSERR_NOERROR then
    if Woc.dwSupport and WAVECAPS_VOLUME = WAVECAPS_VOLUME then
      WaveOutSetVolume(WAVE_MAPPER, AVolume);
end;

function InitSoundSystem : boolean;
begin
  Result := true;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Creating := true;
  Application.Title := appName + ' ' + appVer; 
  exited := false;
  exiting := false;
  BasePath := AddSlash(ExtractFilePath(Application.ExeName));
  ChDir(BasePath);
  fillchar(IntVisData,sizeof(IntVisData),#0);
  CurMPA := tMPEGAudio.Create;
  CurMPA.AutoLoad := true;

  hTaskBar := FindWindow('Shell_TrayWnd', NIL);{}
  hStart   := FindWindowEx(hTaskBar, 0, 'Button', NIL);
  hBar     := FindWindowEx(hTaskBar, 0, 'ReBarWindow32', NIL);
  hTray    := FindWindowEx(hTaskBar, 0, 'TrayNotifyWnd', NIL);
  hClock   := FindWindowEx(hTray, 0, 'TrayClockWClass', NIL);

//   SetWindowText(hClock, 'MP3 NaviGatoR'#0153);
// Windows.SetParent(Panel1.Handle, hClock); //Поместить панель на часы
// MoveWindow(Panel1.Handle, 0, 0, 40, 18, True);

  dnBt  := 0;
  dnBts := 0;
  ID3v2Padding := DefID3v2Padding;
  mfl := MainForm.Left;
  mft := MainForm.Top;
  mfw := MainForm.Width;
  mfh := MainForm.Height;
  OldMaxX := MainForm.Left;
  OldMaxY := MainForm.Top;
  OldMaxW := MainForm.Width;
  OldMaxH := MainForm.Height;
  Randomize;
  LastSort := SortMode;
  edUnit.LastPage := 0;
  IsMaximized := false;

  LoadOptions;{}
  if (SaveWinPos)or(SaveWinSiz) then
  begin
    MainForm.Position := poDesigned;{}
    MainForm.Left := mfl;
    MainForm.Top  := mft;
    if SaveWinSiz then
    begin
      if IsMaximized then
      begin
        IsMaximized := false;
        OldMaxW := CorFormWidth(OldMaxW);
        OldMaxH := CorFormHeight(OldMaxH);
        SetBounds(OldMaxX,OldMaxY,OldMaxW,OldMaxH);
        DoMaximize;
      end else
      begin
        mfw := CorFormWidth(mfw);
        mfh := CorFormHeight(mfh);
        SetBounds(mfl,mft,mfw,mfh);
      end;
    end;
  end;
  SkinsPath := AddSlash(SkinsPath);
  InitSkin;
  InitSliders;
//  VolSlider.Position := ovol;
//  BalSlider.Position := obal;
  InitMyPlayList;
  LastPlayed := LastPlayed;
  LoadNKSList(BasePath + PLAFileName);
  LastPlayed := LastPlayed;
  if LastPlayed > PlayList.Items.Count then LastPlayed := -1;
{  PlayListAutoFit;}
  SetPriority;

  LastSort := SortMode;
  smiScanPlay.Checked := ScanPlay;
  smiManualPlay.Checked := PlayManual;
  miShowColHeaders.Checked := PlayList.ShowColumnHeaders;
  ScrollTimer.Interval := NTimerInt;

  SetPlayMode(PlayMode);
  SetTimeDec(TimeDec);
  SetMouseEn(MouseEn);
  SetManualPlay(PlayManual);
  SetScanPlay(ScanPlay);
//  SetEQVisible(EQForm.Visible);
  InitSoundSystem;

  InitMenu;
  SetCurSizes;
  Creating := false;
  DragAcceptFiles(Handle,true);
  Caption := appName + ' ' + appVer;
  Application.Title := Caption;
(*
  new(VisPH);
  visph.n := nil;
  vispt   := visph;
  new(VisBH);
  tp := visbh;
  for i := 1 to NumVisBuf do
  begin
    new(tp.n);
    tp := tp.n;
  end;
  tp.n := nil;
  visbt := tp;
*)
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  About.ShowAboutBox;
end;

procedure TMainForm.N60Click(Sender: TObject);
begin
  AddDirs;
end;

procedure TMainForm.N61Click(Sender: TObject);
begin
  AddFiles;
end;

procedure TMainForm.N56Click(Sender: TObject);
begin
  SelectAll;
end;

procedure TMainForm.N58Click(Sender: TObject);
begin
  SelectZero;
end;

procedure TMainForm.N57Click(Sender: TObject);
begin
  SelectInvert;
end;

procedure TMainForm.mpPlayClick(Sender: TObject);
begin
  PlayCurrent;
end;

procedure TMainForm.mpEditTagClick(Sender: TObject);
begin
  EditCurTag;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  RandomizeList;
end;

procedure TMainForm.PlayListDeletion(Sender: TObject; Item: TListItem);
begin
  if (Item <> nil)and(not Creating) then
  begin
    if not MovingItems then
    begin
      if Item.Index = LastPlayed then LastPlayed := -1 else
      if Item.Index < LastPlayed then dec(LastPlayed);
      if Item.Data <> nil then
      begin
        TotalTime := TotalTime - tMPEGAudio(Item.Data^).Duration;
      end else TotalTime := TotalTime - DecodeTimeSt(Item.Subitems[5]);
      if TotalTime < 0 then TotalTime := 0;
      if not DoNotFree then if Item.Data <> nil then tMPEGAudio(Item.Data^).Free;
    end;
  end;
end;

procedure TMainForm.smiOptionsClick(Sender: TObject);
begin
  Configure;
end;

procedure TMainForm.PlayListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) then
  begin
    if (Key = ord('I')) then PlayList.Visible := not PlayList.Visible else  
    if (Key = 192 {'`/~'}) then ActivateSecret1 else
    if (ssAlt in Shift) then
    begin
      if (ssShift in Shift) then
      begin
        if key > 20 then
        begin
          if (Key = 192 {'`/~'}) then if SecretActivated then DeActivateSecret1 else ActivateSecret1;
        end;
      end else
      if (Key = ord('E')) then RefreshItems(true) else
      if (Key = VK_UP) then VolumeUp else
      if (Key = VK_DOWN) then VolumeDown else
    end else
    if (Key = VK_INSERT) then AddFiles else
    if (Key = VK_DELETE) then CropSelected else
    if (Key = VK_RETURN) then
    begin
      if MouseEn then PlayCurrent;
    end else
    if (Key = ord('O')) then Configure else
    if (Key = ord('F')) then PlayListAutoFit else
    if (Key = ord('R')) then RefreshItems(false) else
    if (Key = ord('N')) then RenameSelected else
    if (Key = ord('L')) then LoadList(true) else
    if (Key = ord('A')) then SelectAll else
    if (Key = ord('B')) then ToggleHeaders else
    if (Key = ord('G')) then GroupSelected else
    if (Key = ord('C')) then CenterPos else
    if (Key = ord('D')) then SetDefSize else
    if (Key = ord('H')) then SetTopItem(LastPlayed) else
    if (Key = ord('Q')) then QueryItems else
    if (Key = ord('M')) then DoMaximize else
    if (Key = ord('K')) then MoveSelToCur else
    if (Key = ord('T')) then
    begin
      SetTimeDec(not TimeDec);
    end else
  end else
  if (ssShift in Shift) then
  begin
    if (Key = VK_DELETE) then DelSelFromDisk else
    if (Key = VK_F1) then ShowAboutBox else
    if (Key = ord('V')) then PlayFadedStop else
  end else
  if (ssAlt in Shift) then
  begin
    if (Key = ord('W')) then DoReqLyr else
    if (Key = ord('3')) then EditCurTag else
    if (Key = ord('E')) then EditSelTags else
    if (Key = VK_UP) then MoveSel(1) else
    if (Key = VK_DOWN) then MoveSel(-1) else
    if (Key = VK_END) then MoveSelEnd else
    if (Key = VK_HOME) then MoveSelHome else
    if (Key = VK_SPACE) then
    begin
      MySysMenu.Popup(Left + 4,Top + 4);
    end else
    if (Key = VK_LEFT)or(Key = VK_NUMPAD4) then PlayReWind5s else
    if (Key = VK_RIGHT)or(Key = VK_NUMPAD6) then PlayFFWD5s else
    if (Key = ord('Z')) then PlayPrev else
    if (Key = ord('X')) then PlayCurrent else
    if (Key = ord('C')) then TogglePause else
    if (Key = ord('V')) then PlayStop else
    if (Key = ord('B')) then PlayNext else
    if (Key = ord('J')) then QueryItems else
    if (Key = ord('S')) then TogglePlayMode else
    if (Key = ord('M')) then DoMinimize else
    if (Key = ord('G')) then
    begin
      SetEQVisible(not EQForm.Visible); 
    end else
  end else
  begin
    if (Key = VK_RETURN) then
    begin
      if not MouseEn then PlayCurrent;
    end else
    if (Key = VK_INSERT) then AddDirs else
    if (Key = VK_DELETE) then DelSelFromList else
    if (Key = VK_F4) then Configure else
    if (Key = VK_F1) then ShowAboutBox else
    if (Key = VK_F10) then Configure else
    if (Key = VK_F3) then QueryItems else
    if (Key = VK_F12) then RequestLyrics('','','') else
  end;
end;

procedure TMainForm.PlayListItemContextMenu(aSender: TObject;
  aItem: TListItem; var aPos: TPoint; var aMenu: TPopupMenu);
begin
  aPos := ScreenToClient(mouse.CursorPos);
  dec(aPos.X, PlayList.Left);
  if aPos.X < 0 then aPos.X := 0;
  dec(aPos.Y, PlayList.Top);
  if aPos.Y < 0 then aPos.Y := 0;
end;

procedure TMainForm.smiEditSelTagsClick(Sender: TObject);
begin
  EditSelTags;
end;

procedure TMainForm.TAG3Click(Sender: TObject);
begin
  EditSelTags;
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  DelSelFromList;
end;

procedure TMainForm.N8Click(Sender: TObject);
begin
  SaveListAs(true);
end;

procedure TMainForm.PlayListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if not MouseEn then SortBy(Column.Index);
end;

procedure TMainForm.N16Click(Sender: TObject);
begin
  SortBy(smMask);
end;

procedure TMainForm.N14Click(Sender: TObject);
begin
  SortBy(smRandom);
end;

procedure TMainForm.PlayListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var s1,s2 : string;
    a,b : integer;
begin
  case SortMode of
   smRandom: Compare := 1 - random(3);
   smMask:
    begin
      CheckItem(item1);
      CheckItem(item2);
      if (Item1 <> nil)and(Item1.Data <> nil)and(Item2 <> nil)and(Item2.Data <> nil) then
      begin
        s1 := tMPEGAudio(Item1.Data^).Textilize(PlayListsMask);
        s2 := tMPEGAudio(Item2.Data^).Textilize(PlayListsMask);
        Compare := CompareText(s1,s2);
      end else Compare := 0;
    end;
   0..7:
    if SortMode = 6 then
    begin
      a := DecodeTimeSt(Item1.SubItems[5]);
      b := DecodeTimeSt(Item2.SubItems[5]);
      if a > b then Compare := +1 else
      if a < b then Compare := -1 else
       Compare := 0;
    end else
    begin
      if SortMode = 0 then
      begin
        s1 := Item1.Caption;
        s2 := Item2.Caption;
      end else
      begin
        s1 := Item1.SubItems[SortMode-1];
        s2 := Item2.SubItems[SortMode-1];
      end;
      Compare := CompareText(s1,s2);
    end;

   else Compare := 0;
  end;
  if RevSort then Compare := -Compare;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  PaintSkin;
end;

procedure TMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i : integer;
    pt : tPoint;
    c : boolean;
begin
  if Captured then
  begin
    Captured := false;
    ReleaseCapture;
  end;
  pt.x := x; pt.y := y;
  pt := MainForm.ClientToScreen(pt);{}
  c := true;
  if not SecretActivated then
  begin
    if MainSlider.IsHitSlider(x,y) then
    begin
      if Button = mbLeft then
      begin
        if MainSlider.Seeking then
        begin
          MainSlider.SetSliderPos(x,true);
        end;
      end else MainSlider.Seeking := false;
    end else
    if VolSlider.IsHitSlider(x,y) then
    begin
      if Button = mbLeft then
      begin
        if VolSlider.Seeking then
        begin
          VolSlider.SetSliderPos(x,true);
        end;
      end else VolSlider.Seeking := false;
    end else
    if BalSlider.IsHitSlider(x,y) then
    begin
      if Button = mbLeft then
      begin
        if BalSlider.Seeking then
        begin
          BalSlider.SetSliderPos(x,true);
        end;
      end else BalSlider.Seeking := false;
    end else
    begin
      i := nHitBtn(x,y);
      if i > 0 then
      begin
        if dnBt > 0 then
        begin
          if i > 0 then
          begin
            if (i = dnBt) then
            begin
              PushBtn(dnBt, aBtns[dnBt].s, Button, Shift, pt.x,pt.y);
              if dnBt = 14 then // Close
                c := false;
            end;
          end;
        end;
      end else if Button = mbRight then
      begin
        mySysMenu.Popup(pt.x,pt.y);
      end;
      dnBt := 0;
    end;
    MainSlider.Seeking := false;
    VolSlider.Seeking  := false;
    BalSlider.Seeking  := false;
  end;
  Dragged := False; Sizing  := false;
  if c then PaintSkin;
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Captured := true;
  SetCapture(MainForm.Handle);
  MainSlider.Seeking := false; VolSlider.Seeking := false; BalSlider.Seeking := false;
  if not SecretActivated then
  begin
    dnBt := nHitBtn(x,y);
    if dnBt > 0 then with aBtns[dnBt] do
    begin
      dnBts := aBtns[dnBt].s;
      case t of
      1: if s = 0 then s := 1 else s := 0;
       else s := 1;
      end;
    end else
    if MainSlider.IsHitSlider(x,y) then
    begin
      if Button = mbLeft then
      begin
        MainSlider.Seeking := true;
        MainSlider.SetSliderPos(x,false);
      end;
    end else
    if VolSlider.IsHitSlider(x,y) then
    begin
      if Button = mbLeft then
      begin
        VolSlider.Seeking := true;
        VolSlider.SetSliderPos(x,false);
      end;
    end else
    if BalSlider.IsHitSlider(x,y) then
    begin
      if Button = mbLeft then
      begin
        BalSlider.Seeking := true;
        BalSlider.SetSliderPos(x,false);
      end;
    end else
    if Button = mbLeft then
    begin
      if (abs(MainForm.ClientWidth  - X) <= 20)and
         (abs(MainForm.ClientHeight - Y) <= 20) then
      begin
        Sizing := true;
      end else
      if (x > MainForm.ClientWidth  - 86)and(x < MainForm.ClientWidth  - 52)and
         (y > MainForm.ClientHeight  - 16)and(y < MainForm.ClientHeight  - 8) then
      begin
        SetTimeDec(not TimeDec);
      end else
      begin
        Dragged := true;
        mX := X;
        mY := Y;
      end;
    end;
  end else
  if Button = mbLeft then
  begin
    Dragged := true;
    mX := X;
    mY := Y;
  end;
  PaintSkin;
end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var nx,ny : integer;
    c : boolean;
    Pabd: AppBarData;
    ScreenWidth,
    ScreenHeight: Integer;
    ScreenRect,
    TaskBarRect : TRect;
    nL,nT,nLeft,nTop : integer;
begin
  c := false;
  if Dragged then
  begin
    nLeft := Left + X - mX;
    nTop  := Top  + Y - mY;
    nL    := nLeft;
    nT    := nTop;
    if SnapWindow then
    begin
      Pabd.cbSize := SizeOf(APPBARDATA);
      SHAppBarMessage(ABM_GETTASKBARPOS, Pabd);

      ScreenWidth := GetSystemMetrics(SM_CXSCREEN);
      ScreenHeight:= GetSystemMetrics(SM_CYSCREEN);
      SetRect(ScreenRect, 0, 0, ScreenWidth, ScreenHeight);
      TaskBarRect := Pabd.rc;

      if (TaskBarRect.Left = -2) and
         (TaskBarRect.Bottom = ScreenHeight + 2) and
         (TaskBarRect.Right = ScreenWidth + 2) then
        ScreenRect.Bottom := TaskBarRect.Top
          else
      if (TaskBarRect.Top = -2) and
         (TaskBarRect.Left  = -2) and
         (TaskBarRect.Right = ScreenWidth + 2) then
        ScreenRect.Top := TaskBarRect.Bottom
          else
      if (TaskBarRect.Left = -2) and
         (TaskBarRect.Top  = -2) and
         (TaskBarRect.Bottom = ScreenHeight + 2) then
        ScreenRect.Left := TaskBarRect.Right
          else
      if (TaskBarRect.Right = ScreenWidth + 2) and
         (TaskBarRect.Top = -2) and
         (TaskBarRect.Bottom = ScreenHeight + 2) then
        ScreenRect.Right := TaskBarRect.Left;

      // Позиционируем форму...
      if nLeft + Width > ScreenRect.Right - Threshold  then
      begin
        nL := ScreenRect.Right - Width;
      end;
      if nTop + Height > ScreenRect.Bottom - Threshold then
      begin
        nT := ScreenRect.Bottom - Height;
      end;
      if nLeft < ScreenRect.Left + Threshold then
      begin
        nL := ScreenRect.Left;
      end;
      if nTop < ScreenRect.Top + Threshold   then
      begin
        nT := ScreenRect.Top;
      end;
    end;
    mX := mX + (nLeft - nL);
    mY := mY + (nTop  - nT);
{    SetBounds(nL,nT,CorFormWidth(Width),CorFormHeight(Height));{}
    SetBounds(nL,nT,Width,Height);
{    MainForm.OnResize;{}
    c    := true;
  end else
  if Sizing then
  begin
    IsMaximized := false;
    nx := CorFormWidth(x);
    ny := CorFormHeight(y);
    SetBounds(Left,Top,nx,ny);
    SetCurSizes;
    c := true;
  end else if dnBt > 0 then
  begin
    if (nHitBtn(x,y) = dnBt) then with aBtns[dnBt] do
    begin
      case t of
      0: begin
           aBtns[dnBt].s := 1;
         end;
       else
       begin
         if dnBts = 1 then aBtns[dnBt].s := 0 else aBtns[dnBt].s := 1;
       end;
      end;
    end else with aBtns[dnBt] do
    begin
      aBtns[dnBt].s := dnBts;
    end;
    c := true;
  end else
  if MainSlider.Seeking then
  begin
    MainSlider.SetSliderPos(x,false);
    c := true;
  end else
  if VolSlider.Seeking then
  begin
    VolSlider.SetSliderPos(x,false);
    c := true;
  end else
  if BalSlider.Seeking then
  begin
    BalSlider.SetSliderPos(x,false);
    c := true;
  end;
  if c then PaintSkin;
end;

procedure SetSizes(w,h : integer);
var i : integer;
begin
  with MainForm.PlayList do
  begin
    Left   := 7;
    Top    := 32;
    Width  := w  - 15;
    Height := h - 101;
  end;
  with MyPlayList do
  begin
    Width := w - 30;
    Height := h - 117;
  end;
  with MainSlider do
  begin
    fTop   := h - 50;
    fWidth := w - 115;
  end;
  with VolSlider do
  begin
    fLeft  := w - 105;
    fTop   := h - 49;
  end;
  with BalSlider do
  begin
    fLeft   := w - 45;
    fTop    := h - 49;
  end;
  for i:=1 to 4 do
  begin
    aBtns[i].y := h - 31;
  end;
  for i := 5 to 9 do
  begin
    aBtns[i].y := h - 29;
  end;
  aBtns[10].y := h - 31;
  aBtns[10].x := w - 45;

  aBtns[12].x := w - 71;
  aBtns[13].x := w - 48;
  aBtns[14].x := w - 25;

  aBtns[15].x := w - 155;
  aBtns[15].y := h - 27;
end;

procedure TMainForm.mpSelEditTagsClick(Sender: TObject);
begin
  EditSelTags;
end;

procedure TMainForm.N12Click(Sender: TObject);
begin
  DelNonExisting;
end;

procedure TMainForm.mpDelCurFileClick(Sender: TObject);
begin
  DelCurFromList;
end;

procedure TMainForm.mpDelSelClick(Sender: TObject);
begin
  DelSelFromList;
end;

procedure TMainForm.mpDelSelFromDiskClick(Sender: TObject);
begin
  DelSelFromDisk;
end;

procedure TMainForm.mpGroupSelClick(Sender: TObject);
begin
  GroupSelected;
end;

procedure TMainForm.mpMoveSelToBeginClick(Sender: TObject);
begin
  MoveSelHome;
end;

procedure TMainForm.smiNormalModeClick(Sender: TObject);
begin
  SetPlayMode(pmNormal);
end;

procedure TMainForm.smiRandomModeClick(Sender: TObject);
begin
  SetPlayMode(pmRandom);
end;

procedure TMainForm.smiReReadSelClick(Sender: TObject);
begin
  RefreshItems(true);
end;

procedure TMainForm.N22Click(Sender: TObject);
begin
  RefreshItems(false);
end;

procedure TMainForm.smiSaveListAsClick(Sender: TObject);
begin
  SaveListAs(false);
end;

procedure TMainForm.N23Click(Sender: TObject);
begin
  PlayListAutoFit;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if FirstActivate then
  begin
    FirstActivate := false;
    if EQVisible then EQForm.Show;
{    MainForm.Show;{}
    with MainForm.PlayList do
    begin
{      if CanFocus then SetFocus;{}
      SetCurSizes;
      SetTopItem(LastPlayed);
      if AutoPlay then PlayItem(LastPlayed);
    end;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if FirstFormShow then
  begin
    FirstFormShow := false;
  end;
end;

procedure TMainForm.smiDeleteNonExistingClick(Sender: TObject);
begin
  DelNonExisting;
end;

procedure TMainForm.smiGroupSelClick(Sender: TObject);
begin
  GroupSelected;
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
  DelSelFromDisk;
end;

procedure TMainForm.N24Click(Sender: TObject);
begin
  MoveSelHome;
end;

procedure TMainForm.N26Click(Sender: TObject);
begin
  MoveSelEnd;
end;

procedure TMainForm.N27Click(Sender: TObject);
begin
  MoveSel(1);
end;

procedure TMainForm.N28Click(Sender: TObject);
begin
  MoveSel(-1);
end;

procedure TMainForm.smiClearListClick(Sender: TObject);
begin
  ClearList;
end;

procedure TMainForm.N29Click(Sender: TObject);
begin
  RenameSelected;
end;

procedure TMainForm.N32Click(Sender: TObject);
begin
  RenameSelected;
end;

procedure TMainForm.smiLoadListClick(Sender: TObject);
begin
  LoadList(true);
end;

procedure TMainForm.N33Click(Sender: TObject);
begin
  SavePlayList;
end;

procedure TMainForm.N39Click(Sender: TObject);
begin
  AddFiles;
end;

procedure TMainForm.N35Click(Sender: TObject);
begin
  AddDirs;
end;

procedure TMainForm.N40Click(Sender: TObject);
begin
  SetDefSize;
end;

procedure TMainForm.N43Click(Sender: TObject);
begin
  CenterPos;
end;

procedure TMainForm.N46Click(Sender: TObject);
begin
  AddDirs;
end;

procedure TMainForm.N45Click(Sender: TObject);
begin
  AddFiles;
end;

procedure TMainForm.N53Click(Sender: TObject);
begin
  ClearList;
end;

procedure TMainForm.N47Click(Sender: TObject);
begin
  DelSelFromList;
end;

procedure TMainForm.N51Click(Sender: TObject);
begin
  DelNonExisting;
end;

procedure TMainForm.N50Click(Sender: TObject);
begin
  DelSelFromDisk;
end;

procedure TMainForm.N66Click(Sender: TObject);
begin
  SelectAll;
end;

procedure TMainForm.N67Click(Sender: TObject);
begin
  SelectZero;
end;

procedure TMainForm.N68Click(Sender: TObject);
begin
  SelectInvert;
end;

procedure TMainForm.N69Click(Sender: TObject);
begin
  Configure;
end;

procedure TMainForm.TAG5Click(Sender: TObject);
begin
  EditCurTag;
end;

procedure TMainForm.TAG4Click(Sender: TObject);
begin
  EditSelTags;
end;

procedure TMainForm.N72Click(Sender: TObject);
begin
  ClearList;
end;

procedure TMainForm.N71Click(Sender: TObject);
begin
  LoadList(false);
end;

procedure TMainForm.N70Click(Sender: TObject);
begin
  LoadList(true);
end;

procedure TMainForm.N75Click(Sender: TObject);
begin
  CropSelected;
end;

procedure TMainForm.N76Click(Sender: TObject);
begin
  CropSelected;
end;

procedure TMainForm.N78Click(Sender: TObject);
begin
  CropSelected;
end;

procedure TMainForm.N80Click(Sender: TObject);
begin
  RefreshItems(true);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not exited then
  begin
    exiting := true;
    if SecretActivated then DeActivateSecret1;
    SaveOptions;
    SavePlayList;

    if IsPlaying then PlayStop;

    if InPlug <> nil then
    begin
      InPlug^.Quit;
      InPlug := nil;
    end;
    FreeLibrary(hInDLL);
    hInDLL := 0;

    Buf.Free; Buf := nil;
    Skin.Free; Skin := nil;
    EQSkin.Free; EQSkin := nil;
    EQBuf.Free; EQBuf := nil;
    FontBmp.Free; FontBmp := nil;
    CurMPA.Free;
    exited := true;
  end;
end;

procedure TMainForm.N79Click(Sender: TObject);
begin
  SaveListAs(false);
end;

procedure TMainForm.N82Click(Sender: TObject);
begin
  SavePlayList;
end;

procedure TMainForm.PlayListDblClick(Sender: TObject);
begin
  with MainForm.PlayList do
  begin
    if not MouseEn then
    if Selected <> nil then
    begin
      PlayCurrent;
    end;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  SetCurSizes;
  PaintSkin;
end;

procedure TMainForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
(*
  NewWidth  := CorFormWidth(NewWidth);
  NewHeight := CorFormHeight(NewHeight);
*)
  Resize    := true;
end;

procedure TMainForm.smiScanPlayClick(Sender: TObject);
begin
  SetScanPlay(not ScanPlay);
end;

procedure TMainForm.smiManualPlayClick(Sender: TObject);
begin
  SetManualPlay(not PlayManual);
end;

procedure TMainForm.N15Click(Sender: TObject);
begin
  SortBy(0);
end;

procedure TMainForm.N17Click(Sender: TObject);
begin
  SortBy(1);
end;

procedure TMainForm.N20Click(Sender: TObject);
begin
  SortBy(2);
end;

procedure TMainForm.N19Click(Sender: TObject);
begin
  SortBy(3);
end;

procedure TMainForm.TAG1Click(Sender: TObject);
begin
  SortBy(4);
end;

procedure TMainForm.TAG2Click(Sender: TObject);
begin
  SortBy(5);
end;

procedure TMainForm.N21Click(Sender: TObject);
begin
  SortBy(6);
end;

procedure TMainForm.N84Click(Sender: TObject);
begin
  SortBy(7);
end;

procedure TMainForm.N90Click(Sender: TObject);
begin
  TogglePause;
end;

procedure TMainForm.N91Click(Sender: TObject);
begin
  PlayStop;
end;

procedure TMainForm.N86Click(Sender: TObject);
begin
  PlayCurrent;
end;

procedure TMainForm.N87Click(Sender: TObject);
begin
  PlayNext;
end;

procedure TMainForm.N88Click(Sender: TObject);
begin
  PlayPrev;
end;

procedure DoPlayTimeSt;
var i : integer;
    p : real;
begin
  if IsPlaying then
  begin
    if InPlug = nil then exit;
    i := (InPlug^.GetLength div 1000);
    if TimeDec then
    begin
      if MainSlider.MaxPos = 0 then p := 0 else p := (MainSlider.MaxPos - MainSlider.Position) / MainSlider.MaxPos;
      i := round(i * p);
      if i < 0 then i := 0;
      PlayTimeSt := '-'+TimeSt(i,false);
    end else
    begin
      if MainSlider.MaxPos = 0 then p := 0 else p := MainSlider.Position / MainSlider.MaxPos;
      i := round(i * p);
      if i < 0 then i := 0;
      PlayTimeSt := ' ' + TimeSt(i,false);
    end;
  end else
  begin
    PlayTimeSt := '';
  end;
end;

procedure UpdateScrollTxt;
var l : integer;
begin
  l := length(ScrollText);
  if sct >= l then sct := 1 else inc(sct);
  if (l < 15)or(sct = 1) then Application.Title := ScrollText
   else Application.Title := copy(ScrollText,sct,length(ScrollText)) + '    ' + copy(ScrollText,1,sct-1);
end;

procedure TMainForm.ScrollTimerTimer(Sender: TObject);

  procedure SetScrollTimerPriority(p : integer);
  var pr : integer;
  begin
    case p of
    1: pr := THREAD_PRIORITY_LOWEST;
    2: pr := THREAD_PRIORITY_BELOW_NORMAL;
    3: pr := THREAD_PRIORITY_NORMAL;
    4: pr := THREAD_PRIORITY_ABOVE_NORMAL;
    5: pr := THREAD_PRIORITY_HIGHEST;
    6: pr := THREAD_PRIORITY_TIME_CRITICAL;
    else pr := THREAD_PRIORITY_IDLE;
    end;
    SetThreadPriority(GetCurrentThread, pr);
  end;

begin
  if isPlaying then if InPlug <> nil then
  begin
    if (InPlug^.IsSeekable <> 0) then
    begin
      DontSeek := true;
      MainSlider.MaxPos := InPlug^.GetLength;
      MainSlider.Position := InPlug^.GetOutputTime;
      DontSeek := false;
      DoPlayTimeSt;
    end;
    if FadingStopping then
    begin
      if VolSlider.Position <= VolSlider.MinPos then
      begin
        inc(FadingCounter);
        VolSlider.Position := VolSlider.Position - 1;
      end else
      begin
        FadingStopping := false;
        FadingCounter  := 0;
        PlayStop;
      end;
    end;
  end;
  if SecretActivated then
  begin
    if FirstScrollTimer then
    begin
      FirstScrollTimer := false;
      SetScrollTimerPriority(SecretThreadPriority);
    end;
    Secret1OnTimer;
  end else
  begin
    if FirstScrollTimer then
    begin
      FirstScrollTimer := false;
      SetScrollTimerPriority(ScrollTimerPriority);
    end;
  end;
  UpdateScrollTxt;
end;

procedure TMainForm.smiFindInListClick(Sender: TObject);
begin
  QueryItems;
end;

procedure TMainForm.N92Click(Sender: TObject);
begin
  QueryItems;
end;

procedure TMainForm.smiMaxMinClick(Sender: TObject);
begin
  DoMaximize;
end;

procedure TMainForm.N93Click(Sender: TObject);
begin
  DoMinimize;
end;

procedure TMainForm.N95Click(Sender: TObject);
begin
  DelDupes;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  PlayListKeyDown(Sender,Key,Shift);
end;

function GetNextStItem(var s : string) : string;
var i : integer;
begin
  Result := '';
  for i := 1 to length(s) do if s[i] <> ' ' then break;
  for i := i to length(s) do if s[i] = ' ' then break else Result := Result + s[i];
  s := copy(s,i,length(s));
end;

const MaxComm = 10;
var comm : array[1..MaxComm] of string;
    LastCommIdx : integer = 1;

procedure DoCommand(cmd : string);
const MaxOP = 10;
var s : string;
    p,e : integer;
    op : array[1..MaxOP] of record
            s : string;
            u : string;
         end;
    c : char;
begin
  with MainForm do
  try
    ScrollTimer.Enabled := false;
    s := trim(cmd);
    if s <> '' then
    begin
      p := MaxComm;
      while (p >= 1) do
      if (comm[p] = s) then
      begin
        break;
      end else dec(p);
      if p > 0 then
      begin
        for e := p + 1 to MaxComm do
        if comm[e] = '' then
        begin
          comm[e-1] := cmd;
          break;
        end else comm[e-1] := comm[e];
      end else
      begin
        for p := MaxComm downto 1 do if comm[p] <> '' then break;
        inc(p);
        if p >= MaxComm then
        begin
          for e := 2 to MaxComm do comm[e-1] := comm[e];
          p := MaxComm;
        end else if (p <= 0) then p := 1;
        comm[p] := s;
      end;
      LastCommIdx := 0;
      p := 1;
      while (s <> '')and(p <= MaxOP) do
      begin
        op[p].s := GetNextStItem(s);
        op[p].u := AnsiUpperCase(trim(op[p].s));
        inc(p);
      end;
      while (p <= MaxOP) do
      begin
        op[p].s := '';
        op[p].u := '';
        inc(p);
      end;
      if (op[1].u = '/Q')or(op[1].u = 'QUIT')or(op[1].u = 'EXIT') then AppExit else
      if (op[1].u = 'Q') then DeActivateSecret1 else
      if (op[1].u = 'CLEAR') then
      begin
        for p := MaxComm downto 1 do comm[p] := '';
      end else
      if (op[1].u = 'PRIORITY') then
      begin
        val(op[2].u,p,e);
        if (e = 0) then
        begin
          if (p >= 0)and(p <= 6) then
          begin
            SecretThreadPriority := p;
            FirstScrollTimer := true;
          end;
        end else
        if (op[2].u = '')or(op[2].u = 'GET') then
        begin
          SecretEdit.Text := inttostr(SecretThreadPriority);
        end else
        if (op[2].u = 'REALTIME') then
        begin
          SecretThreadPriority := 6;
          FirstScrollTimer := true;
        end else
        if (op[2].u = 'HIGHEST') then
        begin
          SecretThreadPriority := 5;
          FirstScrollTimer := true;
        end else
        if (op[2].u = 'ABOVENORMAL') then
        begin
          SecretThreadPriority := 4;
          FirstScrollTimer := true;
        end else
        if (op[2].u = 'NORMAL') then
        begin
          SecretThreadPriority := 3;
          FirstScrollTimer := true;
        end else
        if (op[2].u = 'BELOWNORMAL') then
        begin
          SecretThreadPriority := 2;
          FirstScrollTimer := true;
        end else
        if (op[2].u = 'LOWEST') then
        begin
          SecretThreadPriority := 1;
          FirstScrollTimer := true;
        end else
        if (op[2].u = 'IDLE') then
        begin
          SecretThreadPriority := 0;
          FirstScrollTimer := true;
        end else
      end else
      if (op[1].u = 'CD') then
      begin
        if (op[3].u = 'OPEN') then
        begin
          if op[2].u = '' then c := #0 else c := op[2].u[1];
          OpenCD(c);
        end else
        if (op[3].u = 'CLOSE') then
        begin
          if op[2].u = '' then c := #0 else c := op[2].u[1];
          CloseCD(c);
        end else
        if (op[3].u = 'LOCK') then
        begin
          if op[2].u = '' then c := #0 else c := op[2].u[1];
          LockCD(c);
        end else
        if (op[3].u = 'UNLOCK') then
        begin
          if op[2].u = '' then c := #0 else c := op[2].u[1];
          UnLockCD(c);
        end else
      end else
      if op[1].u = 'RUNBUTT' then RunButt else
      if op[1].u = 'BUTTONFUN' then ButtonFun else
      if op[1].u = 'MBEEP' then mbeep else
      if op[1].u = 'CURSORRUN' then CursorRun else
      if op[1].u = 'QUAKE' then EarthQuake else
      if op[1].u = 'MUZDIE' then DoMuzDie else
      if op[1].u = 'WINCAP' then WinCap else
      if op[1].u = 'STOP' then
      begin
        PlayStop;
      end else
      if op[1].u = 'NEXT' then
      begin
        PlayNext;
      end else
      if op[1].u = 'PREV' then
      begin
        PlayPrev;
      end else
      if op[1].u = 'PAUSE' then
      begin
        TogglePause;
      end else
      if op[1].u = 'PLAY' then
      begin
        if (op[2].u = '') then PlayCurrent else
        begin
          val(op[2].s,p,e);
          if (e = 0) then
          begin
            if (p >= 0)and(p < MainForm.PlayList.Items.Count) then PlayItem(p);
          end else
          if op[2].u = 'STOP' then PlayStop else
          if op[2].u = 'PAUSE' then PlayPause else
          if op[2].u = 'NEXT' then PlayNext else
          if op[2].u = 'PREV' then PlayPrev else
          if (op[2].u = 'RND')or(op[2].u = 'RANDOM')or(op[2].u = 'SHUFFLE') then SetPlayMode(pmRandom) else
          if (op[2].u = 'NORMAL') then SetPlayMode(pmNormal) else
        end;
      end else
      if (op[1].u = 'VOL')or(op[1].u = 'VOLUME') then
      begin
        val(op[2].u,p,e);
        if (e = 0) then
        begin
          if (p >= 0)and(p <= 65535) then
          begin
            VolSlider.Position := p;
            mySetVol;
          end;
        end else
        if (op[2].u = 'MAX') then
        begin
          VolSlider.Position := VolSlider.MaxPos;
          mySetVol;
        end else
        if (op[2].u = '')or(op[2].u = 'GET') then
        begin
          SecretEdit.Text := inttostr(VolSlider.Position)
        end
      end else
      if (op[1].u = 'BAL')or(op[1].u = 'BALANCE') then
      begin
        val(op[2].u,p,e);
        if (e = 0)and(p >= 0)and(p <= 255) then
        begin
          BalSlider.Position := p;
        end else
        if (op[2].u = '')or(op[2].u = 'GET') then
        begin
          if BalSlider.Position = 128 then SecretEdit.Text := 'center' else
          if BalSlider.Position <= 0 then SecretEdit.Text := 'left' else
          if BalSlider.Position >= 255 then SecretEdit.Text := 'right' else SecretEdit.Text := inttostr(BalSlider.Position)
        end else if (op[2].u = 'C')or(op[2].u = 'CENTER') then
        begin
          BalSlider.Position := 128;
        end else if (op[2].u = 'L')or(op[2].u = 'LEFT') then
        begin
          BalSlider.Position := 0;
        end else if (op[2].u = 'R')or(op[2].u = 'RIGHT') then
        begin
          BalSlider.Position := 255;
        end else
        mySetVolume;
      end else
      if (op[1].u = 'MAX') then
      begin
        DoMaximize;
      end else
      if op[1].u = 'NIKE' then
      begin
        val(op[2].u,p,e);
        if (e = 0) and (p > 0) then DoNiKe(p) else DoNiKe(1);
      end else
      if op[1].u = 'MIN' then DoMinimize else
      if op[1].u = 'POS' then
      begin
        if (op[2].u = 'C')or(op[2].u = 'CENTER') then CenterPos;
      end else
      if op[1].u = 'SIZE' then
      begin
        if (op[2].u = 'DEF')or(op[2].u = 'DEFAULT') then SetDefSize else
        if (op[2].u = 'MAX') then DoMaximize else;
      end else
      if op[1].u = 'TASKBAR' then
      begin
        if op[2].u = 'FIND' then
        begin
          hTaskBar := FindWindow('Shell_TrayWnd', NIL);
        end else
        if op[2].u = 'HIDE' then
        begin
          ShowWindow(hTaskBar,sw_hide)
        end else
        if op[2].u = 'SHOW' then
        begin
          ShowWindow(hTaskBar,sw_show)
        end else
        if op[2].u = 'START' then
        begin
          if op[3].u = 'TEXT' then
          begin
            SetWindowText(hStart,PChar(op[3].u));
          end else
          if op[3].u = 'SHOW' then
          begin
            ShowWindow(hStart,sw_normal);
          end else
          if op[3].u = 'HIDE' then
          begin
            ShowWindow(hStart,sw_hide);
          end else
          if op[3].u = 'FIND' then
          begin
            hStart := FindWindowEx(hTaskBar, 0, 'Button', NIL);
          end else
        end else
        if op[2].u = 'CLOCK' then
        begin
          if op[3].u = 'TEXT' then
          begin
            SetWindowText(hClock,PChar(op[3].u));
          end else
          if op[3].u = 'SHOW' then
          begin
            ShowWindow(hClock,sw_normal);
          end else
          if op[3].u = 'HIDE' then
          begin
            ShowWindow(hClock,sw_hide);
          end else
          if op[3].u = 'FIND' then
          begin
            hClock := FindWindowEx(hTray, 0, 'TrayClockWClass', NIL);
          end else
        end else
        if copy(op[2].u,1,4) = 'BAR' then
        begin
          if op[3].u = 'SHOW' then
          begin
            ShowWindow(hBar,sw_show);
          end else
          if op[3].u = 'HIDE' then
          begin
            ShowWindow(hBar,sw_hide);
          end else
          if op[3].u = 'FIND' then
          begin
            hBar := FindWindowEx(hTaskBar, 0, 'ReBarWindow32', NIL);
          end else
        end else
        if copy(op[2].u,1,4) = 'BAR' then
        begin
          if op[3].u = 'SHOW' then
          begin
            ShowWindow(hTray,sw_show);
          end else
          if op[3].u = 'HIDE' then
          begin
            ShowWindow(hTray,sw_hide);
          end else
          if op[3].u = 'FIND' then
          begin
            hTray  := FindWindowEx(hTaskBar, 0, 'TrayNotifyWnd', NIL);
          end else
        end else
      end else
      if (op[1].u = 'MCISEND') then mciSendString(PChar(op[2].u), nil, 0, 0) else
      if (op[1].u = 'X')or(op[1].u = 'LEFT') then
      begin
        if (op[2].u = '')or(op[2].u = 'GET') then
        begin
          SecretEdit.Text := inttostr(MainForm.Left);
        end else
        begin
          val(op[2].u,p,e);
          if (e = 0) and (p >= 0) then MainForm.Left := p;
        end;
      end else
      if (op[1].u = 'Y')or(op[1].u = 'TOP') then
      begin
        if (op[2].u = '')or(op[2].u = 'GET') then
        begin
          SecretEdit.Text := inttostr(MainForm.Top);
        end else
        begin
          val(op[2].u,p,e);
          if (e = 0) and (p >= 0) then MainForm.Top := p;
        end;
      end else
      if (op[1].u = 'H')or(op[1].u = 'HEIGHT') then
      begin
        val(op[2].u,p,e);
        if (e = 0) then
        begin
          if (p > 0)and(p <> MatrixH) then
          begin
            MatrixH := p;
            MainForm.Height := MatrixH*24;
            InitMatrixWorms;
            with SecretEdit do
            begin
              Top := MainForm.Height - SecretEdit.Height - 0;
              Width := MainForm.Width - 0;
              SetFocus;
            end;
          end;
        end else
        if (op[2].u = '')or(op[2].u = 'GET') then
        begin
          SecretEdit.Text := inttostr(MatrixH);
        end;
      end else
      if (op[1].u = 'W')or(op[1].u = 'WIDTH') then
      begin
        val(op[2].u,p,e);
        if (e = 0) and (p > 0) then
        begin
          if (p <> MatrixW)and(p <= MaxMatrixWorms) then
          begin
            MatrixW := p;
            MainForm.Width := MatrixW*16;
            InitMatrixWorms;
            with SecretEdit do
            begin
              Top := MainForm.Height - SecretEdit.Height - 0;
              Width := MainForm.Width - 0;
              SetFocus;
            end;
          end;
        end else
        if (op[2].u = '')or(op[2].u = 'GET') then
        begin
          SecretEdit.Text := inttostr(MatrixW);
        end;
      end else
      if op[1].u = 'FC' then
      begin
        if (op[2].u = 'RANDOM')or(op[2].u = 'RND') then
        begin
          DoRandomPic;
        end else
        if op[2].u = 'TYLER' then
        begin
          val(op[3].u,p,e);
          if (e = 0) and (p > 0) then DoTyler(p) else DoTyler(1);
        end else
        if op[2].u = 'JACK' then
        begin
          val(op[3].u,p,e);
          if (e = 0) and (p > 0) then DoJack(p) else DoJack(1);
        end else
        if op[2].u = 'MARLA' then
        begin
          val(op[3].u,p,e);
          if (e = 0) and (p > 0) then DoMarla(p) else DoMarla(1);
        end else
        if op[2].u = 'SOAP' then
        begin
          DoFCSoap;
        end else
      end else
    end;

    finally
      ScrollTimer.Enabled := true;
  end;
  MainForm.ScrollTimer.Enabled := true;
end;

procedure TMainForm.SecretEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i : integer;
begin
  if (key = VK_ESCAPE) then
  begin
    SecretEdit.Text := '';
    LastCommIdx := 0;
  end else
  if (key = VK_F10) then
  begin
    for i := MaxComm downto 1 do
    begin
      if comm[i] <> '' then break;
    end;
    if i > 0 then
    begin
      SecretEdit.Text := comm[i];
      SecretEdit.SelectAll;
      DoCommand(comm[i]);
    end;
    Key := 0;
  end else
  if (key = VK_UP) then
  begin
    if LastCommIdx > 1 then dec(LastCommIdx);
    if (LastCommIdx <= 0)or(LastCommIdx > MaxComm) then LastCommIdx := MaxComm;
    for i := LastCommIdx downto 1 do if comm[i] <> '' then break;
    if i > 0 then
    begin
      SecretEdit.Text := comm[i];
      SecretEdit.SelectAll;
      LastCommIdx := i;
    end;
    Key := 0;
  end else
  if (key = VK_DOWN) then
  begin
    if LastCommIdx < MaxComm then inc(LastCommIdx);
    if (LastCommIdx <= 0)or(LastCommIdx > MaxComm) then LastCommIdx := 1;
    for i := LastCommIdx to MaxComm do if comm[i] <> '' then break;
    if (i <= MaxComm)and(i > 0) then
    begin
      SecretEdit.Text := comm[i];
      SecretEdit.SelectAll;
      LastCommIdx := i;
    end;
    Key := 0;
  end else
  ;
//  Key := 0;
end;

procedure TMainForm.N94Click(Sender: TObject);
begin
  DelDupes;
end;

procedure TMainForm.N96Click(Sender: TObject);
begin
  MoveSelToCur;
end;

procedure TMainForm.N97Click(Sender: TObject);
begin
  MoveSelToCur;
end;

procedure TMainForm.mpMoveSelToEndClick(Sender: TObject);
begin
  MoveSelEnd;
end;

procedure TMainForm.mpMoveSelUpClick(Sender: TObject);
begin
  MoveSel(1);
end;

procedure TMainForm.mpMoveSelDownClick(Sender: TObject);
begin
  MoveSel(-1);
end;

procedure TMainForm.PlayListInsert(Sender: TObject; Item: TListItem);
begin
  if Dropping then if Item <> nil then if Item.Index <= LastPlayed then inc(LastPlayed);
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  SaveListAs(true);
end;

procedure TMainForm.mpClearListClick(Sender: TObject);
begin
  ClearList;
end;

procedure TMainForm.smiMouseEnClick(Sender: TObject);
begin
  SetMouseEn(not MouseEn);
end;

procedure TMainForm.PlayListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if MainForm.PlayList.GetItemAt(x,y) <> nil then
    begin
      if MainForm.PlayList.SelCount > 0 then
      begin
        osX := X;
        osY := Y;
        ScrollingItems := true;
      end;
    end else ScrollingItems := false;
  end;
end;

procedure TMainForm.PlayListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollingItems := false;
  osX := 0;
  osY := 0;
end;

procedure TMainForm.PlayListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ScrollingItems then
  begin
    if (osY - Y) > 15 then
    begin
      osX := X;
      osY := Y;
{      MoveSel(1);{}
    end else
    if (osY - Y) < 15 then
    begin
      osX := X;
      osY := Y;
{      MoveSel(-1);{}
    end;
  end;
end;

procedure TMainForm.smiEQClick(Sender: TObject);
begin
  SetEQVisible(not EQForm.Visible);
  smiEQ.Checked := EQForm.Visible;
end;

procedure SetEQVisible(v : boolean);
begin
  with MainForm do
  begin
    EQForm.Visible := v;
    smiEQ.Checked := EQForm.Visible;
  end;
end;

procedure TMainForm.LoadSimgProgr(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
  const Msg: string);
begin
{}
end;

procedure DrawMyItem(i,x,y : integer);
begin
  with myPlayList do
  begin
    if (i <= 0)or(i > count) then exit;
    with listbmp.Canvas do
    begin
(*
    NormBG  := RGB($91,$B1,$91);
    iCurBG  := RGB($7A,$90,$BA);
    iSelBG  := RGB($7A,$90,$BA);
    iNormFG := RGB($00,$00,$00);
    iCurFG  := RGB($00,$00,$00);
    iPlayFG := RGB($FF,$FF,$FF);
*)
      if items[i].Selected then
      begin
        brush.Color := iSelBG;
      end else
      if i = CurItem then
      begin
        brush.Color := iCurBG;
      end else
      begin
        brush.Color := NormBG;
      end;
      FillRect(rect(x,y,width,y+itemheight));

      if i = PlayItem then
      begin
        pen.Color := iPlayFG;
      end else
      if i = CurItem then
      begin
        pen.Color := iCurFG;
      end else
      begin
        pen.Color := iNormFG;
      end;

      textout(x,y,items[i].tagtitle);
    end

  end;
end;

procedure DrawMyList;
var si,i,x,y : integer;
begin
  with myPlayList do
  begin
{
    listbmp.Width := width;
    listbmp.height := height;
}
    listbmp.Canvas.Brush.Color := NormBG;
    listbmp.Canvas.FillRect(rect(0,0,width,height));
    x := 0;
    si := TopItem;
    if (si <= 0)or(si > count) then si := 1;
    for i := si to count do
    begin
      y := (i-si)*ItemHeight;
      if y > height then break;
      DrawMyItem(i,x,y);
    end;
    bitblt(pHDC,posx,posy,width,height,listbmp.Canvas.Handle,0,0,SRCCOPY);
  end;
end;

function  AddMyListItem(si : integer) : integer;
var i : integer;
begin
  Result := -1;
  with myPlayList do
  begin
    if count >= MaxMyListItems then exit;
    if (si > count)or(si < 1) then
    begin
      si := count;
    end else
    begin
      for i := count-1 downto si do
      begin
        items[i-1] := items[i];
      end;
    end;
    inc(count);
  end;
  Result := si;
end;

procedure TMainForm.SecretEditKeyPress(Sender: TObject; var Key: Char);
var s : string;
begin
  if (key = #13) then
  begin
    s := SecretEdit.Text;
    SecretEdit.Text := '';
    DoCommand(s);
    key := #0;
  end else
  ;
end;

procedure TMainForm.miShowColHeadersClick(Sender: TObject);
begin
  ToggleHeaders;
end;

procedure TMainForm.N101Click(Sender: TObject);
begin
  DoReqLyr;
end;

procedure InfoBoxCall;
var li : tlistitem;
begin
  if InPlug <> nil then
  with InPlug^ do
  begin
    with MainForm do
    begin
      li := PlayList.ItemFocused;
      CheckItem(li);
      if li <> nil then
      begin
        InfoBox(pansichar(li.SubItems[6]),mainform.handle);
      end;
    end;
  end;
end;

procedure TMainForm.N102Click(Sender: TObject);
begin
  InfoBoxCall;
end;

procedure TMainForm.FileInfo1Click(Sender: TObject);
begin
  InfoBoxCall;
end;

procedure TMainForm.N104Click(Sender: TObject);
begin
  RequestLyrics('','','');
end;

procedure TMainForm.PlayListAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
  if Stage = cdPrePaint then
  begin
    if Item <> nil then if (Item.Index = LastPlayed) then
    begin
      Sender.Canvas.Font.Color := clLime;
    end;
  end;
end;

procedure TMainForm.SecretImgClick(Sender: TObject);
begin

end;

END.
