Unit Winamp;

  INTERFACE Uses Windows;

const WAVP_VER      =       $101;
  WACM_TRACK_PREV       =       40044;
  WACM_TRACK_NEXT       =       40048;
  WACM_PLAY_CUR         =       40045;
  WACM_PAUSE            =       40046;
  WACM_CONTINUE         =       40046;
  WACM_STOP             =       40047;
  WACM_STOP_FADEOUT     =       40147;
  WACM_STOP_AFTERENDED  =       40157;
  WACM_FF_5SECS         =       40148;
  WACM_FR_5SECS         =       40144;
  WACM_PLAYLIST_START   =       40154;
  WACM_PLAYLIST_END     =       40158;
  WACM_OPEN_FILE        =       40029;
  WACM_OPEN_URL         =       40155;
  WACM_FILE_INFO        =       40188;
  WACM_TIME_ELAPSED     =       40037;
  WACM_TIME_REMAINING   =       40038;
  WACM_PREFERENCES      =       40012;
  WACM_VIZ_OPTIONS      =       40190;
  WACM_VIZ_PLUGINOPTS   =       40191;
  WACM_VIZ_EXEC         =       40192;
  WACM_ABOUT            =       40041;
  WACM_TITLE_SCROLL     =       40189;
  WACM_ALWAYSONTOP      =       40019;
  WACM_WINSH            =       40064;
  WACM_WINSH_PL         =       40065;
  WACM_DOUBLESIZE       =       40165;
  WACM_EQ               =       40036;
  WACM_PL               =       40040;
  WACM_MAIN             =       40258;
  WACM_BROWSER          =       40298;
  WACM_EASYMOVE         =       40186;
  WACM_VOL_RAISE        =       40058;
  WACM_VOL_LOWER        =       40059;
  WACM_REPEAT           =       40022;
  WACM_SHUFFLE          =       40023;
  WACM_OPEN_JUMPTIME    =       40193;
  WACM_OPEN_JUMPFILE    =       40194;
  WACM_OPEN_SKINSEL     =       40219;
  WACM_VIZ_PLUGINCONF   =       40221;
  WACM_SKIN_RELOAD      =       40291;
  WACM_QUIT             =       40001;

  WAUM_VERSION          =       0;
  WAUM_START_PLAYBACK   =       100;
  WAUM_PLAYLIST_CLEAR   =       101;
  WAUM_PLAY_SEL_TRACK   =       102;
  WAUM_CHDIR            =       103;
  WAUM_PLAYBACK_STATUS  =       104;
  WAUM_PLAYBACK_POS     =       105;
  WAUM_TRACK_LENGTH     =       105;
  WAUM_PLAYBACK_SEEK    =       106;
  WAUM_PLAYLIST_WRITE   =       120;
  WAUM_PLAYLIST_SETPOS  =       121;
  WAUM_VOL_SET          =       122;
  WAUM_PAN_SET          =       123;
  WAUM_PLAYLIST_COUNT   =       124;
  WAUM_PLAYLIST_GETINDEX=       125;
  WAUM_TRACK_INFO       =       126;
  WAUM_EQ_DATA          =       127;
  WAUM_EQ_AUTOLOAD      =       128;
  WAUM_BOOKMARK_ADDFILE =       129;
  WAUM_RESTART          =       135;
  { plugin only }
  WAUM_SKIN_SET         =       200;
  WAUM_SKIN_GET         =       201;
  WAUM_VIZ_SET          =       202;
  WAUM_PLAYLIST_GETFN   =       211;
  WAUM_PLAYLIST_GETTIT  =       212;
  WAUM_MB_OPEN_URL      =       241;
  WAUM_INET_AVAIL       =       242;
  WAUM_TITLE_UPDATE     =       243;
  WAUM_PLAYLIST_SETITEM =       245;
  WAUM_MB_RETR_URL      =       246;
  WAUM_PLAYLIST_CACHEFL =       247;
  WAUM_MB_BLOCKUPD      =       248;
  WAUM_MB_BLOCKUPD2     =       249;
  WAUM_SHUFFLE_GET      =       250;
  WAUM_REPEAT_GET       =       251;
  WAUM_SHUFFLE_SET      =       252;
  WAUM_REPEAT_SET       =       253;

  type
  pVisDataArray = ^tVisDataArray;
  tVisDataArray = array [0..1,0..575] of byte;
  TGPFWinAmpOutputPurposePlugin=record
    Version : Integer;
    Description : PChar;
    ID : Integer;
    Parent : HWND;
    Instance : HINST;
    Config : procedure(ParentWindow : HWND); cdecl;
    About : procedure(ParentWindow : HWND); cdecl;
    Init : procedure; cdecl;
    Quit : procedure; cdecl;
    Open : function(SampleRate,NumChannels,BitsPerSamp,BufferLenMS,PreBufferMS:Integer):Integer; cdecl;
    Close : procedure; cdecl;
    Write : function(Buf:PChar;Len:Integer):Integer; cdecl;
    CanWrite : function : Integer; cdecl;
    IsPlaying : function : Integer; cdecl;
    Pause : function(Value : Integer) : Integer; cdecl;
    SetVolume : procedure(Volume:Integer); cdecl;
    SetPan : procedure(Pan:Integer); cdecl;
    Flush : procedure(SeekTime:Integer); cdecl;
    GetOutputTime : function : Integer; cdecl;
    GetWrittenTime : function : Integer; cdecl;
  end;
  PGPFWinAmpOutputPurposePlugin=^TGPFWinAmpOutputPurposePlugin;

type
  pGPFWinAmpInputPluginEQData = ^TGPFWinAmpInputPluginEQData;
  TGPFWinAmpInputPluginEQData = array[0..9] of byte;

  TGPFWinAmpInputPurposePlugin = record
    Version : Integer;
    Description : PChar;
    Parent : HWND;
    Instance : HINST;
    FileExtensions : PChar;
    IsSeekable : Integer;
    UsesOutputPlug : Integer;
    Config : procedure(ParentWindow : HWND); cdecl;
    About : procedure(ParentWindow : HWND); cdecl;
    Init : procedure; cdecl;
    Quit : procedure; cdecl;
    GetFileInfo : procedure(FileName,Title:PChar;LengthMS:PInteger); cdecl;
    InfoBox : function(FileName:PChar;ParentWindow:HWND):Integer; cdecl;
    IsOurFile : function(FileName:PChar):Integer; cdecl;
    Play : function(FileName:PChar):Integer; cdecl;
    Pause : procedure; cdecl;
    UnPause : procedure; cdecl;
    IsPaused : function : Integer; cdecl;
    Stop : procedure; cdecl;
    GetLength : function : Integer; cdecl;
    GetOutputTime : function : Integer; cdecl;
    SetOutputTime : procedure(TimeMS : Integer); cdecl;
    SetVolume : procedure(Volume:Integer); cdecl;
    SetPan : procedure(Pan:Integer); cdecl;
    SAVSAInit : procedure(MaxLatency,SRate:Integer); cdecl;
    SAVSADeInit : procedure; cdecl;
    SAAddPCMData : procedure(PCMData:Pointer;NCh,Bps,TimeStamp:Integer); cdecl;
    SAGetMode : function : Integer; cdecl;
    SAAdd : procedure(Data:Pointer;TimeStamp,Csa:Integer); cdecl;
    VSAAddPCMData : procedure(PCMData:Pointer;NCh,Bps,TimeStamp:Integer); cdecl;
    VSAGetMode : procedure(spacNch,waveNch:Pinteger); cdecl;
    VSAAdd : procedure(Data:Pointer;TimeStamp:Integer); cdecl;
    VSASetInfo : procedure(Nch,SRate:Integer); cdecl;
    DSPIsActive : function : Integer; cdecl;
    DSPDoSamples : function(Samples:Pointer;NumSaples,Bps,Nch,SRate:Integer):Integer; cdecl;
    EQSet : procedure(IsOn:Integer;Data:TGPFWinAmpInputPluginEQData;PreAmp:Integer); cdecl;
    SetInfo : procedure(BitRate,SRate,Stereo,Synched:Integer); cdecl;
    outMod : PGPFWinAmpOutputPurposePlugin;
  end;
  PGPFWinAmpInputPurposePlugin = ^TGPFWinAmpInputPurposePlugin;

  TGPFWinAmpVisualizationData = array[0..1,0..575] of byte;

  PGPFWinAmpVisualizationPurposeModule = ^TGPFWinAmpVisualizationPurposeModule;
  TGPFWinAmpVisualizationPurposeModule = record
    Description : PChar;
    Parent : HWND;
    Instance : HINST;
    SampleRate,
    NumChannels,
    LatencyMS,
    DelayMS,
    SpectrumNCh,
    WaveFormNCh : Integer;
    SpectrumData : TGPFWinAmpVisualizationData;
    WaveFormData : TGPFWinAmpVisualizationData;
    Config : procedure(Module:PGPFWinAmpVisualizationPurposeModule); cdecl;
    Init : function(Module:PGPFWinAmpVisualizationPurposeModule):Integer; cdecl;
    Render : function(Module:PGPFWinAmpVisualizationPurposeModule):Integer; cdecl;
    Quit : procedure(Module:PGPFWinAmpVisualizationPurposeModule); cdecl;
    UserData : Pointer;
  end;

  PGPFWinAmpVisualizationHeader = ^TGPFWinAmpVisualizationHeader;
  TGPFWinAmpVisualizationHeader = record
    Version : Integer;
    Description : PChar;
    GetModule : function(Index:Integer):PGPFWinAmpVisualizationPurposeModule; cdecl;
  end;

  TGPFWinAmpVisualizationModuleQueryEvent = function(Sender:TObject):Integer of object;

type winampGetInModule2func = function : PGPFWinAmpInputPurposePlugin; stdcall;
     winampGetOutModulefunc = function : PGPFWinAmpOutputPurposePlugin; stdcall;
     winampVisGetHeaderfunc = function : PGPFWinAmpVisualizationHeader; stdcall;

       IMPLEMENTATION

END.
