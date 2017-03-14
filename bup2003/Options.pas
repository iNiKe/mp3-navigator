unit Options;

  Interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, UPTImageCombo,
  MPGTools, FPTOpenDlg, FPTFolderBrowseDlg, Spin;

type
  TOptionsForm = class(TForm)
    PageControl: TPageControl;
    GeneralOptionsSheet: TTabSheet;
    MaskSheet: TTabSheet;

    Label1: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;

    PlayListsMaskEdit: TEdit;
    PlayListMaskEdit: TEdit;
    SaveWinPosBox: TCheckBox;
    SaveWinSizBox: TCheckBox;
    RecursiveDirsBox: TCheckBox;
    FocusDelBox: TCheckBox;
    ExtM3UBox: TCheckBox;
    AutoRunBox: TCheckBox;
    AutoPlayBox: TCheckBox;
    RWBox: TCheckBox;
    ConfDiskDelBox: TCheckBox;
    ConfClearListBox: TCheckBox;
    ConfExitBox: TCheckBox;
    ScanPlayBox: TCheckBox;
    PlayManualBox: TCheckBox;
    ConfROBox: TCheckBox;
    SaveROINIBox: TCheckBox;
    FadedStartBox: TCheckBox;
    FadingBox: TCheckBox;
    SaveBtn: TButton;
    CancelBtn: TButton;
    PlayModesBox: TPTCombobox;
    DefsBtn: TButton;
    plFontDlg: TFontDialog;
    plColorDlg: TColorDialog;
    plFontBtn: TButton;
    plColorBtn: TButton;
    ShowGridBox: TCheckBox;
    ShowColumnHdrBox: TCheckBox;
    NameMaskEdit: TEdit;
    Label4: TLabel;
    AskFileMaskBox: TCheckBox;
    Label5: TLabel;
    SelMaskBtn: TButton;
    FormSheet: TTabSheet;
    Label8: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    DefSizeBtn: TButton;
    CenterBtn: TButton;
    SkinsPathEdit: TEdit;
    Label15: TLabel;
    SelSkinsDirBtn: TButton;
    SkinsView: TListView;
    WidthEdit: TSpinEdit;
    HeightEdit: TSpinEdit;
    LeftEdit: TSpinEdit;
    TopEdit: TSpinEdit;
    SaveListAfterChangeBox: TCheckBox;
    ConfGroupNameEditBox: TCheckBox;
    ConfNonExistBox: TCheckBox;
    MinimizeRunBox: TCheckBox;
    TabSheet1: TTabSheet;
    MainPriorityBox: TComboBox;
    Label16: TLabel;
    Label17: TLabel;
    ThreadPriorityBox: TComboBox;
    DirDlg: TPTFolderBrowseDlg;
    PrecisionEdit: TSpinEdit;
    PadingEdit: TSpinEdit;
    FadedStartTimeEdit: TSpinEdit;
    FadingEdit: TSpinEdit;
    FocusAfterChangeSongBox: TCheckBox;
    ScanPlayTimeEdit: TSpinEdit;
    Label20: TLabel;
    TabSheet2: TTabSheet;
    PlugsControl: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    PlugsPathEdit: TEdit;
    InPlugsList: TListBox;
    ChoosePlugsDirBtn: TButton;
    OutPlugsList: TListBox;
    OutInfBtn: TButton;
    OutConfBtn: TButton;
    VisPlugsList: TListBox;
    VisConfBtn: TButton;
    RefreshPlugs: TButton;
    VisStartBtn: TButton;
    VisStopBtn: TButton;
    InConfBtn: TButton;
    InInfBtn: TButton;
    CurBtn: TButton;
    MaskRulesBtn: TButton;
    Label2: TLabel;
    ScrollMaskEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label18: TLabel;
    Label19: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure DefsBtnClick(Sender: TObject);
    procedure plFontBtnClick(Sender: TObject);
    procedure plColorBtnClick(Sender: TObject);
    procedure SelMaskBtnClick(Sender: TObject);
    procedure DefSizeBtnClick(Sender: TObject);
    procedure CenterBtnClick(Sender: TObject);
    procedure SelSkinsDirBtnClick(Sender: TObject);
    procedure MainPriorityBoxChange(Sender: TObject);
    procedure PreviewPriority;
    procedure ThreadPriorityBoxChange(Sender: TObject);
    procedure MPEGPlayerPriorityBoxChange(Sender: TObject);
    procedure ChoosePlugsDirBtnClick(Sender: TObject);
    procedure RefreshPlugsClick(Sender: TObject);
    procedure PopulatePlugs;
    procedure PopulateSkins;
    procedure CurBtnClick(Sender: TObject);

    procedure ConfInPlug(s : string);
    procedure AboutInPlug(s : string);

    procedure ConfOutPlug(s : string);
    procedure AboutOutPlug(s : string);

    procedure ConfVisPlug(s : string);
    procedure StartVisPlug(s : string);
    procedure StopVisPlug(s : string);
    procedure InConfBtnClick(Sender: TObject);
    procedure InInfBtnClick(Sender: TObject);
    procedure OutConfBtnClick(Sender: TObject);
    procedure OutInfBtnClick(Sender: TObject);
    procedure VisConfBtnClick(Sender: TObject);
    procedure VisStartBtnClick(Sender: TObject);
    procedure VisStopBtnClick(Sender: TObject);
    procedure InPlugsListDblClick(Sender: TObject);
    procedure OutPlugsListDblClick(Sender: TObject);
    procedure VisPlugsListDblClick(Sender: TObject);
    procedure MaskRulesBtnClick(Sender: TObject);
    procedure PlugsPathEditKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure LeftEditChange(Sender: TObject);
    procedure TopEditChange(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure WidthEditChange(Sender: TObject);
    procedure HeightEditChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var OptionsForm: TOptionsForm;
    plColor : tColor;
    plFont  : tFont;
    LastOptPage : integer;
    mow,moh,mol,mot,OutPlugIdx,InPlugIdx,VisPlugIdx : integer;

procedure Configure;
function  ConvertSt2CustomColors(s : string) : string;
function  ConvertCustomColors2St(s : string) : string;
procedure SetAutoRun(AutoRun : boolean);
function  GetAutoRun : boolean;
function  SaveOptions : integer;
function  LoadOptions : integer;
function  DoRelativePath(s1,s2 : string) : string;

  Implementation Uses Main,MaskAsk,IniFiles,Registry, Winamp, EQUnit, MaskHlpUnit;

{$R *.DFM}

var
{
    OutPlug : tGPFWinAmpOutputPurposePlugin;
    InPlug : tGPFWinAmpInputPurposePlugin;
    VisPlug : tGPFWinAmpInputPurposePlugin;
}
    hOutDLL,hInDLL,hVisDLL : HINST;
    getinfunc : winampGetInModule2func;
    getoufunc : winampGetOutModulefunc;
    getvifunc : winampVisGetHeaderfunc;
    p : pointer;
    pPath : string;

function  DoRelativePath(s1,s2 : string) : string;
begin
  if (AnsiUpperCase (Copy (s1, 1, Length(s2))) = AnsiUpperCase (s2))
    then Result := Copy (s1, Length(s2) + 1, Length (s1)) else Result := s1;
end;

procedure TOptionsForm.ConfInPlug(s : string);
begin
  hInDLL := LoadLibrary(PChar(s));
  if (hIndll <> 0) then
  begin
    @getinfunc := GetProcAddress(hInDLL,pchar('winampGetInModule2'));
    if @getinFunc <> nil then
    begin
      p := GetinFunc;
      if p <> nil then with PGPFWinAmpInputPurposePlugin(p)^ do
      begin
        Instance := hInDLL;
        Parent   := Handle;
        Config(Handle);
      end;
    end;
    FreeLibrary(hInDLL);
  end;
end;

procedure TOptionsForm.AboutInPlug(s : string);
begin
  hInDLL := LoadLibrary(PChar(s));
  if (hOutdll <> 0) then
  begin
    @getInfunc := GetProcAddress(hInDLL,pchar('winampGetInModule2'));
    if @getinFunc <> nil then
    begin
      p := GetinFunc;
      if p <> nil then with PGPFWinAmpInputPurposePlugin(p)^ do
      begin
        Instance := hInDLL;
        Parent   := Handle;
        About(Handle);
      end;
    end;
    FreeLibrary(hInDLL);
  end;
end;

procedure TOptionsForm.ConfOutPlug(s : string);
begin
  hOutDLL := LoadLibrary(PChar(s));
  if (hOutdll <> 0) then
  begin
    @getoufunc := GetProcAddress(hOutDLL,pchar('winampGetOutModule'));
    if @getouFunc <> nil then
    begin
      p := GetouFunc;
      if p <> nil then with PGPFWinAmpOutputPurposePlugin(p)^ do
      begin
        Instance := hOutDLL;
        Parent   := Handle;
        Config(Handle);
      end;
    end;
    FreeLibrary(hOutDLL);
  end;
end;

procedure TOptionsForm.AboutOutPlug(s : string);
begin
  hOutDLL := LoadLibrary(PChar(s));
  if (hOutdll <> 0) then
  begin
    @getoufunc := GetProcAddress(hOutDLL,pchar('winampGetOutModule'));
    if @getouFunc <> nil then
    begin
      p := GetouFunc;
      if p <> nil then with PGPFWinAmpOutputPurposePlugin(p)^ do
      begin
        Instance := hOutDLL;
        Parent   := Handle;
        About(Handle);
      end;
    end;
    FreeLibrary(hOutDLL);
  end;
end;

procedure TOptionsForm.ConfVisPlug(s : string);
var pp : pointer;
begin
  hVisDLL := LoadLibrary(PChar(s));
  if (hVisdll <> 0) then
  begin
    @getvifunc := GetProcAddress(hVisDLL,pchar('winampVisGetHeader'));
    if @getviFunc <> nil then
    begin
      p := Getvifunc;
      if p <> nil then
      begin
        pp := PGPFWinAmpVisualizationHeader(p)^.GetModule(0);
        if pp <> nil then
        begin
          PGPFWinAmpVisualizationPurposeModule(pp)^.Config(pp);
        end;
      end;
    end;
    FreeLibrary(hVisDLL);
  end;
end;

procedure TOptionsForm.StartVisPlug(s : string);
begin
(*
var pp : pointer;
  hOutDLL := LoadLibrary(PChar(s));
  if (hOutdll <> 0) then
  begin
    @getoufunc := GetProcAddress(hOutDLL,pchar('winampGetOutModule'));
    if @getouFunc <> nil then
    begin
      p := GetouFunc;
      if p <> nil then
      begin
        pp := PGPFWinAmpVisualizationHeader(p)^.GetModule;
        if pp <> nil then
        begin
          PGPFWinAmpVisualizationPurposeModule(pp)^.
        end;
      end;
    end;
    FreeLibrary(hOutDLL);
  end;
*)
end;

procedure TOptionsForm.StopVisPlug(s : string);
begin
(*
  hOutDLL := LoadLibrary(PChar(s));
  if (hOutdll <> 0) then
  begin
    @getoufunc := GetProcAddress(hOutDLL,pchar('winampGetOutModule'));
    if @getouFunc <> nil then
    begin
      p := GetouFunc;
      if p <> nil then
      begin
        PGPFWinAmpOutputPurposePlugin(p)^.Config(Handle);
      end;
    end;
    FreeLibrary(hOutDLL);
  end;
*)
end;

procedure TOptionsForm.PreviewPriority;
begin
  DefinePriority(MainPriorityBox.ItemIndex,ThreadPriorityBox.ItemIndex);
end;

function SaveOptions : integer;
{$IFNDEF _DEMO_}
var ini : tINIFile;
    i,j,OldAttr : integer;
    fName : string;
    DoSet : boolean;
begin
{$I-}
  Result := -1; DoSet := false;
//  SavePlayList;
  fName := AddSlash(BasePath)+INIFileName;
  OldAttr := FileGetAttr(fName);
  if (OldAttr and faReadOnly <> 0) then
  begin
    if (not SaveROINI) then exit;
    if FileExists(fName) then
    begin
      if FileSetAttr(fName,OldAttr and not faReadOnly) <> 0 then
      begin
        if not exiting then MessageDlg('Невозможно сохранить опции (в ReadOnly файл)!',mtError,[mbok],0);
        exit;
      end else DoSet := true;
    end;
  end;
  ini := TIniFile.Create(fName);
  try
    ini.WriteInteger(NavigatorSection,'PlayMode',PlayMode);
    ini.WriteInteger(NavigatorSection,'SoundBal',BalSlider.Position);
    ini.WriteInteger(NavigatorSection,'SoundVol',VolSlider.Position);
    ini.WriteBool(NavigatorSection,'ConfNonExist',ConfNonExist);
    ini.WriteBool(NavigatorSection,'ConfGroupNameEdit',ConfGroupNameEdit);
    ini.WriteBool(NavigatorSection,'ScanPlay',ScanPlay);
    ini.WriteBool(NavigatorSection,'PlayManual',PlayManual);
    ini.WriteBool(NavigatorSection,'SaveWinPos',SaveWinPos);
    ini.WriteBool(NavigatorSection,'SaveWinSiz',SaveWinSiz);
    ini.WriteBool(NavigatorSection,'FocusDel',FocusDel);
    ini.WriteBool(NavigatorSection,'MakeExtM3U',MakeExtM3U);
    ini.WriteBool(NavigatorSection,'AutoPlay',AutoPlay);
    ini.WriteBool(NavigatorSection,'SaveROINI',SaveROINI);
    ini.WriteBool(NavigatorSection,'SaveListAfterChange',SaveListAfterChange);
    ini.WriteBool(NavigatorSection,'RecursiveDirs',RecursiveDirs);
    ini.WriteBool(NavigatorSection,'ConfDiskDel',ConfDiskDel);
    ini.WriteBool(NavigatorSection,'ConfClearList',ConfClearList);
    ini.WriteBool(NavigatorSection,'ConfExit',ConfExit);
    ini.WriteBool(NavigatorSection,'ConfDelRO',ConfDelRO);
{    ini.WriteBool(NavigatorSection,'ConfEdtRO',ConfEdtRO);{}
    ini.ReadBool(NavigatorSection,'ConfGroupNameEdit',ConfGroupNameEdit);
    ini.WriteBool(NavigatorSection,'MinimizeRun',MinimizeRun);
    ini.WriteBool(NavigatorSection,'Fading',Fading);
    ini.WriteBool(NavigatorSection,'FadedStart',FadedStart);
    ini.WriteBool(NavigatorSection,'AskFileMask',AskFileMask);
    ini.WriteBool(NavigatorSection,'FocusAfterChangeSong',FocusAfterChangeSong);
    ini.WriteInteger(NavigatorSection,'FadingTime',FadingTime);
    ini.WriteInteger(NavigatorSection,'FadedStartTime',FadedStartTime);
    ini.WriteString(NavigatorSection,'ScrollMask',ScrollMask);
    ini.WriteString(NavigatorSection,'PlayListsMask',PlayListsMask);
    ini.WriteString(NavigatorSection,'PlayListMask',PlayListMask);
    ini.WriteString(NavigatorSection,'FileNameMask',FileNameMask);
    ini.WriteString(NavigatorSection,'CustomColors',stCustomColors);
    ini.WriteInteger(NavigatorSection,'DetectPrecision',DetectPrecision);
    ini.WriteInteger(NavigatorSection,'SecretThreadPriority',SecretThreadPriority);
    for i := 0 to 9 do ini.WriteInteger(NavigatorSection,'EQData'+inttostr(i),EQData[i]);
    ini.WriteInteger(NavigatorSection,'EQPreAmp',EQPreAmp);
    ini.WriteInteger(NavigatorSection,'EQForm.X',EQForm.Left);
    ini.WriteInteger(NavigatorSection,'EQForm.Y',EQForm.Top);
    ini.WriteBool(NavigatorSection,'EQVisible',EQForm.Visible);
    ini.WriteBool(NavigatorSection,'EQAuto',EQAuto);
    ini.WriteBool(NavigatorSection,'EQisON',EQisON);
    ini.WriteBool(NavigatorSection,'TimeDec',TimeDec);
    ini.WriteBool(NavigatorSection,'IsMaximized',IsMaximized);
    ini.WriteBool(NavigatorSection,'MouseEn',MouseEn);
    if IsMaximized then
    begin
      i := OldMaxX;
      j := OldMaxY;
    end else
    begin
      i := MainForm.Width;
      j := MainForm.Height;
    end;
    ini.WriteInteger(NavigatorSection,'Width',i);
    ini.WriteInteger(NavigatorSection,'Height',j);
    ini.WriteInteger(NavigatorSection,'OldMaxX',OldMaxX);
    ini.WriteInteger(NavigatorSection,'OldMaxY',OldMaxY);
    ini.WriteInteger(NavigatorSection,'Left',MainForm.Left);
    ini.WriteInteger(NavigatorSection,'Top',MainForm.Top);
    ini.WriteInteger(NavigatorSection,'DetectPrecision',DetectPrecision);
    ini.WriteInteger(NavigatorSection,'ID3v2Padding',ID3v2Padding);
    ini.WriteInteger(NavigatorSection,'MainPriority',MainPriority);
    ini.WriteInteger(NavigatorSection,'ThreadPriority',ThreadPriority);
    ini.WriteInteger(NavigatorSection,'LastPlayed',LastPlayed);
    ini.WriteInteger(NavigatorSection,'ScanPlayTime',ScanPlayTime);
    ini.WriteString(NavigatorSection,'LastOpenDir',LastOpenDir);
    ini.WriteString(NavigatorSection,'LastFileDir',LastFileDir);
    ini.WriteString(NavigatorSection,'SaveListLastDir',DoRelativePath(SaveListLastDir,BasePath));
    ini.WriteString(NavigatorSection,'LoadListLastDir',DoRelativePath(LoadListLastDir,BasePath));
    ini.WriteString(NavigatorSection,'SkinsPath',DoRelativePath(SkinsPath,BasePath));
    ini.WriteString(NavigatorSection,'PlugsPath',DoRelativePath(PlugsPath,BasePath));
    ini.WriteString(NavigatorSection,'OutPlugName',OutPlugName);
    ini.WriteString(NavigatorSection,'VisPlugName',VisPlugName);
    with MainForm.PlayList do
    begin
      ini.WriteInteger(PlayListSection,'Color',Color);
      ini.WriteBool(PlayListSection,'ShowGridLines',GridLines);
      ini.WriteBool(PlayListSection,'ShowColumnHeaders',ShowColumnHeaders);
      for i:=0 to Columns.Count-1 do ini.WriteInteger(PlayListSection,'Column'+inttostr(i)+'.Width',Columns[i].Width);
      with Font do
      begin
        ini.WriteInteger(PlayListSection,'Font.CharSet',Charset);
        ini.WriteInteger(PlayListSection,'Font.Color',Color);
        ini.WriteInteger(PlayListSection,'Font.Size',Size);
        ini.WriteString(PlayListSection,'Font.Name',Name);
        ini.WriteInteger(PlayListSection,'Font.Style',byte(Style));
      end;
    end;
    Result := 0;
  finally
    ini.Free;
  end;
  if DoSet then FileSetAttr(fName,OldAttr);
{$I+}
{$ELSE}
begin
  ShowDemoMsg;
  Result := 0;
{$ENDIF}
end;

function  LoadOptions : integer;
var ini : tINIFile;
    i : integer;
begin
  main.ovol := 32768;
  main.obal := 128;
  MPGTools.HandleErrors := false;
  mfh := 0; mfw := 0;
  ini := TIniFile.Create(AddSlash(BasePath)+INIFileName);
  try
    PlayMode := ini.ReadInteger(NavigatorSection,'PlayMode',PlayMode);
    if PlayMode > 3 then PlayMode := 3;
    ScanPlay        := ini.ReadBool(NavigatorSection,'ScanPlay',ScanPlay);
    PlayManual      := ini.ReadBool(NavigatorSection,'PlayManual',PlayManual);
    SaveWinPos      := ini.ReadBool(NavigatorSection,'SaveWinPos',SaveWinPos);
    if SaveWinPos then
    begin
      mfl := ini.ReadInteger(NavigatorSection,'Left',MainForm.Left);
      mft := ini.ReadInteger(NavigatorSection,'Top',MainForm.Top);
    end;
    SaveWinSiz      := ini.ReadBool(NavigatorSection,'SaveWinSiz',SaveWinSiz);
    if SaveWinSiz then
    begin
      mfw := ini.ReadInteger(NavigatorSection,'Width',MainForm.Width);
      mfh := ini.ReadInteger(NavigatorSection,'Height',MainForm.Height);
      IsMaximized := ini.ReadBool(NavigatorSection,'IsMaximized',IsMaximized);
    end;
    OldMaxX := ini.ReadInteger(NavigatorSection,'OldMaxX',OldMaxX);
    OldMaxY := ini.ReadInteger(NavigatorSection,'OldMaxY',OldMaxY);
    ConfGroupNameEdit := ini.ReadBool(NavigatorSection,'ConfGroupNameEdit',ConfGroupNameEdit);
    ConfNonExist      := ini.ReadBool(NavigatorSection,'ConfNonExist',ConfNonExist);
    MouseEn         := ini.ReadBool(NavigatorSection,'MouseEn',MouseEn);
    FocusDel        := ini.ReadBool(NavigatorSection,'FocusDel',FocusDel);
    MakeExtM3U      := ini.ReadBool(NavigatorSection,'MakeExtM3U',MakeExtM3U);
    AutoPlay        := ini.ReadBool(NavigatorSection,'AutoPlay',AutoPlay);
    SaveROINI       := ini.ReadBool(NavigatorSection,'SaveROINI',SaveROINI);
    SaveListAfterChange := ini.ReadBool(NavigatorSection,'SaveListAfterChange',SaveListAfterChange);
    RecursiveDirs   := ini.ReadBool(NavigatorSection,'RecursiveDirs',RecursiveDirs);
    ConfDiskDel     := ini.ReadBool(NavigatorSection,'ConfDiskDel',ConfDiskDel);
    ConfClearList   := ini.ReadBool(NavigatorSection,'ConfClearList',ConfClearList);
    ConfExit        := ini.ReadBool(NavigatorSection,'ConfExit',ConfExit);
    ConfDelRO       := ini.ReadBool(NavigatorSection,'ConfDelRO',ConfDelRO);
    ConfGroupNameEdit := ini.ReadBool(NavigatorSection,'ConfGroupNameEdit',ConfGroupNameEdit);
    MinimizeRun     := ini.ReadBool(NavigatorSection,'MinimizeRun',MinimizeRun);
    Fading          := ini.ReadBool(NavigatorSection,'Fading',Fading);
    FadedStart      := ini.ReadBool(NavigatorSection,'FadedStart',FadedStart);
    AskFileMask     := ini.ReadBool(NavigatorSection,'AskFileMask',AskFileMask);
    TimeDec         := ini.ReadBool(NavigatorSection,'TimeDec',TimeDec);
    FocusAfterChangeSong := ini.ReadBool(NavigatorSection,'FocusAfterChangeSong',FocusAfterChangeSong);
    FadingTime      := ini.ReadInteger(NavigatorSection,'FadingTime',FadingTime);
    FadedStartTime  := ini.ReadInteger(NavigatorSection,'FadedStartTime',FadedStartTime);
    DetectPrecision := ini.ReadInteger(NavigatorSection,'DetectPrecision',DetectPrecision);
    ID3v2Padding    := ini.ReadInteger(NavigatorSection,'ID3v2Padding',ID3v2Padding);
    PlayListsMask   := ini.ReadString(NavigatorSection,'PlayListsMask',PlayListsMask);
    PlayListMask    := ini.ReadString(NavigatorSection,'PlayListMask',PlayListMask);
    FileNameMask    := ini.ReadString(NavigatorSection,'FileNameMask',FileNameMask);
    ScrollMask      := ini.ReadString(NavigatorSection,'ScrollMask',ScrollMask);
    LastOpenDir     := ini.ReadString(NavigatorSection,'LastOpenDir',LastOpenDir);
    LastFileDir     := ini.ReadString(NavigatorSection,'LastFileDir',LastFileDir);
    SaveListLastDir := ini.ReadString(NavigatorSection,'SaveListLastDir',SaveListLastDir);
    LoadListLastDir := ini.ReadString(NavigatorSection,'LoadListLastDir',LoadListLastDir);
    SkinsPath       := ini.ReadString(NavigatorSection,'SkinsPath',SkinsPath);
    if not DirectoryExists(SkinsPath) then
    begin
      SkinsPath := BasePath+'Skins';
      if not DirectoryExists(SkinsPath) then SkinsPath := 'Skins';
    end;
    PlugsPath       := ini.ReadString(NavigatorSection,'PlugsPath',PlugsPath);
    if not DirectoryExists(SkinsPath) then
    begin
      PlugsPath := BasePath+'Plugins';
      if not DirectoryExists(PlugsPath) then PlugsPath := 'Plugins';
    end;
    OutPlugName     := ini.ReadString(NavigatorSection,'OutPlugName',OutPlugName);
    VisPlugName     := ini.ReadString(NavigatorSection,'VisPlugName',VisPlugName);
    stCustomColors  := ini.ReadString(NavigatorSection,'CustomColors',stCustomColors);
    MainPriority    := ini.ReadInteger(NavigatorSection,'MainPriority',MainPriority);
    ThreadPriority  := ini.ReadInteger(NavigatorSection,'ThreadPriority',ThreadPriority);
    LastPlayed      := ini.ReadInteger(NavigatorSection,'LastPlayed',LastPlayed);
    ScanPlayTime    := ini.ReadInteger(NavigatorSection,'ScanPlayTime',ScanPlayTime);
    SecretThreadPriority := ini.ReadInteger(NavigatorSection,'SecretThreadPriority',SecretThreadPriority);
    for i := 0 to 9 do EQData[i] := ini.ReadInteger(NavigatorSection,'EQData'+inttostr(i),EQData[i]);
    eqX := ini.ReadInteger(NavigatorSection,'EQForm.X',eqX);
    eqY := ini.ReadInteger(NavigatorSection,'EQForm.Y',eqY);
    EQAuto := ini.ReadBool(NavigatorSection,'EQAuto',EQAuto);
    EQVisible := ini.ReadBool(NavigatorSection,'EQVisible',EQVisible);
    EQisON := ini.ReadBool(NavigatorSection,'EQisON',EQisON);
    EQPreAmp := ini.ReadInteger(NavigatorSection,'EQPreAmp',EQPreAmp);
    obal := ini.ReadInteger(NavigatorSection,'SoundBal',obal);
    ovol := ini.ReadInteger(NavigatorSection,'SoundVol',ovol);

    with MainForm.PlayList do
    begin
      Color := ini.ReadInteger(PlayListSection,'Color',Color);
      with Font do
      begin
        Charset := ini.ReadInteger(PlayListSection,'Font.CharSet',Charset);
        Color   := ini.ReadInteger(PlayListSection,'Font.Color',Color);
        Size    := ini.ReadInteger(PlayListSection,'Font.Size',Size);
        Name    := ini.ReadString(PlayListSection,'Font.Name',Name);
        Style   := TFontStyles(byte(ini.ReadInteger(PlayListSection,'Font.Style',byte(Style))));
      end;
      GridLines := ini.ReadBool(PlayListSection,'ShowGridLines',GridLines);
      ShowColumnHeaders := ini.ReadBool(PlayListSection,'ShowColumnHeaders',ShowColumnHeaders);
      for i := 0 to Columns.Count-1 do Columns[i].Width := ini.ReadInteger(PlayListSection,'Column'+inttostr(i)+'.Width',Columns[i].Width);
    end;

    Result := 0;
  except
    Result := -1;
  end;
  ini.Free;
end;

function GetAutoRun : boolean;
var Reg : tRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(RegPathAutoRun, false)
      then if Reg.ValueExists(appName) then Result := true;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure SetAutoRun(AutoRun : boolean);
var Reg : tRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if AutoRun then
    begin
      if Reg.OpenKey(RegPathAutoRun, True)
        then Reg.WriteString(appName,'"' + Application.ExeName + '"');
    end else
    begin
      if Reg.OpenKey(RegPathAutoRun, false)
        then Reg.DeleteValue(appName);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

function  ConvertSt2CustomColors(s : string) : string;
var i : integer;
begin
  for i := 1 to length(s) do
   if s[i] = '(' then s[i] := #$0D else
   if s[i] = ')' then s[i] := #$0A;
  Result := s;
end;

function  ConvertCustomColors2St(s : string) : string;
var i : integer;
begin
  for i := 1 to length(s) do
   if s[i] = #$0D then s[i] := '(' else
   if s[i] = #$0A then s[i] := ')';
  Result := s;
end;

procedure Configure;
begin
  with TOptionsForm.Create(Application) do
  try
    if ShowModal = mrOK then
    begin
//      SaveOptions;
    end;
    LastOptPage := PageControl.ActivePageIndex;
   finally
    Free;
  end;
end;

procedure TOptionsForm.FormCreate(Sender: TObject);
begin
  PageControl.ActivePage := GeneralOptionsSheet;
  PlugsControl.ActivePageIndex := 0;
  if (LastOptPage >= 0)and(LastOptPage < PageControl.PageCount) then PageControl.ActivePageIndex := LastOptPage;
  SkinsPathEdit.Text := SkinsPath;
  PlugsPathEdit.Text := PlugsPath;
  AutoRunBox.Checked := GetAutoRun;
  SaveListAfterChangeBox.Checked := SaveListAfterChange;
  PlayModesBox.ItemIndex := PlayMode;
  PlayListsMaskEdit.Text := PlayListsMask;
  PlayListMaskEdit.Text  := PlayListMask;
  SaveWinPosBox.Checked  := SaveWinPos;
  SaveWinSizBox.Checked  := SaveWinSiz;
  RecursiveDirsBox.Checked := RecursiveDirs;
  FocusDelBox.Checked    := FocusDel;
  ExtM3UBox.Checked      := MakeExtM3U;
  AutoPlayBox.Checked    := AutoPlay;
  MinimizeRunBox.Checked := MinimizeRun;
  RWBox.Checked          := EnableWritePlay;
  ConfDiskDelBox.Checked := ConfDiskDel;
  ConfNonExistBox.Checked := ConfNonExist;
  ConfClearListBox.Checked := ConfClearList;
  ConfExitBox.Checked    := ConfExit;
  ScanPlayBox.Checked := ScanPlay;
  ScanPlayTimeEdit.Value := ScanPlayTime;
  FocusAfterChangeSongBox.Checked := FocusAfterChangeSong;
  PlayManualBox.Checked := PlayManual;
  ConfROBox.Checked := ConfDelRO;
  SaveROINIBox.Checked := SaveROINI;
  FadingEdit.Value := FadingTime;
  FadedStartTimeEdit.Value := FadedStartTime;
  PrecisionEdit.Value := DetectPrecision;
  FadedStartBox.Checked := FadedStart;
  FadingBox.Checked := Fading;
  AskFileMaskBox.Checked := AskFileMask;
  PlayListsMaskEdit.Text   := PlayListsMask;
  PlayListMaskEdit.Text    := PlayListMask;
  ScrollMaskEdit.Text := ScrollMask;
  NameMaskEdit.Text := FileNameMask;
  PadingEdit.Value := ID3v2Padding;
  plColor := MainForm.PlayList.Color;
  plFont := MainForm.PlayList.Font;
  plColorDlg.Color := plColor;
  if stCustomColors <> '' then
  begin
    plColorDlg.CustomColors.Text := ConvertSt2CustomColors(stCustomColors);
  end;
  plFontDlg.Font := plFont;
  ShowGridBox.Checked      := MainForm.PlayList.GridLines;
  ShowColumnHdrBox.Checked := MainForm.PlayList.ShowColumnHeaders;
  mow := MainForm.Width;
  WidthEdit.Value := mow;
  moh := MainForm.Height;
  HeightEdit.Value := moh;
  mol := MainForm.Left;
  LeftEdit.Value := mol;
  mot := MainForm.Top;
  TopEdit.Value := mot;
  ConfGroupNameEditBox.Checked := ConfGroupNameEdit;
  MainPriorityBox.ItemIndex := MainPriority;
  ThreadPriorityBox.ItemIndex := ThreadPriority;
  PopulatePlugs;
  PopulateSkins;
  if InPlugIdx >= 0 then InPlugsList.ItemIndex := InPlugIdx;
  if OutPlugIdx >= 0 then OutPlugsList.ItemIndex := OutPlugIdx;
  if VisPlugIdx >= 0 then VisPlugsList.ItemIndex := VisPlugIdx;
end;

procedure TOptionsForm.SaveBtnClick(Sender: TObject);
var ts : string;
    i : integer;
begin
  MainPriority := MainPriorityBox.ItemIndex;
  ThreadPriority := ThreadPriorityBox.ItemIndex;
  SetPriority;

  SetAutoRun(AutoRunBox.Checked);
  SaveListAfterChange := SaveListAfterChangeBox.Checked;
  ConfNonExist := ConfNonExistBox.Checked;
  case PlayModesBox.ItemIndex of
  0: PlayMode := pmNormal;
  1: PlayMode := pmRandom;
{  2: PlayMode := pmReverse;{}
  end;
  PlayListsMask   := PlayListsMaskEdit.Text;
  PlayListMask    := PlayListMaskEdit.Text;
  SaveWinPos      := SaveWinPosBox.Checked;
  SaveWinSiz      := SaveWinSizBox.Checked;
  RecursiveDirs   := RecursiveDirsBox.Checked;
  FocusDel        := FocusDelBox.Checked;
  MakeExtM3U      := ExtM3UBox.Checked;
  AutoPlay        := AutoPlayBox.Checked;
  MinimizeRun     := MinimizeRunBox.Checked;
  EnableWritePlay := RWBox.Checked;
  ConfDiskDel     := ConfDiskDelBox.Checked;
  ConfClearList   := ConfClearListBox.Checked;
  ConfExit        := ConfExitBox.Checked;
  ScanPlay        := ScanPlayBox.Checked;
  ScanPlayTime    := ScanPlayTimeEdit.Value;
  PlayManual      := PlayManualBox.Checked;
  ConfDelRO       := ConfROBox.Checked;
  SaveROINI       := SaveROINIBox.Checked;
  FadedStart      := FadedStartBox.Checked;
  Fading          := FadingBox.Checked;
  AskFileMask     := AskFileMaskBox.Checked;
  ID3v2Padding    := PadingEdit.Value;
  FadingTime      := FadingEdit.Value;
  DetectPrecision := PrecisionEdit.Value;
  PlayListsMask   := PlayListsMaskEdit.Text;
  PlayListMask    := PlayListMaskEdit.Text;
  FileNameMask    := NameMaskEdit.Text;
  ScrollMask      := ScrollMaskEdit.Text;
  FocusAfterChangeSong := FocusAfterChangeSongBox.Checked;
  MainForm.PlayList.Color := plColor;
  MainForm.PlayList.Font := plFont;
  MainForm.PlayList.GridLines := ShowGridBox.Checked;

  if WidthEdit.Value > 0 then MainForm.Width := WidthEdit.Value;
  if HeightEdit.Value > 0  then MainForm.Height := HeightEdit.Value;
  if LeftEdit.Value > 0 then MainForm.Left := LeftEdit.Value;
  if TopEdit.Value > 0 then MainForm.Top := TopEdit.Value;

  MainForm.PlayList.ShowColumnHeaders := ShowColumnHdrBox.Checked;
  stCustomColors := ConvertCustomColors2St(plColorDlg.CustomColors.Text);

  ConfGroupNameEdit := ConfGroupNameEditBox.Checked;
  SkinsPath := SkinsPathEdit.Text;
  PlugsPath := PlugsPathEdit.Text;

  SaveOptions;
  with OutPlugsList do
  begin
    if ItemIndex >= 0 then
    begin
      ts := Items[ItemIndex];
      i := pos('<',ts);
      ts := copy(ts,i+1,pos('>',ts)-i-1);
      if length(ts) > 3 then
      begin
        OutPlugName := ts;
      end;
    end;
  end;
  with VisPlugsList do
  begin
    if ItemIndex >= 0 then
    begin
      ts := Items[ItemIndex];
      i := pos('<',ts);
      ts := copy(ts,i+1,pos('>',ts)-i-1);
      if length(ts) > 3 then
      begin
        VisPlugName := ts;
      end;
    end;
  end;
  sct := 0;
  if IsPlaying then ScrollText := '*** ' + appName + ' [PLAY]: ' + CurMPA.Textilize(ScrollMask);
  UpdateScrollTxt;
end;

procedure TOptionsForm.DefsBtnClick(Sender: TObject);
begin
  ConfGroupNameEditBox.Checked := true;
  PlayModesBox.ItemIndex   := 0;
  ScanPlayBox.Checked      := false;
  PlayManualBox.Checked    := false;
  SaveWinPosBox.Checked    := false;
  SaveWinSizBox.Checked    := false;
  FocusDelBox.Checked      := false;
  ExtM3UBox.Checked        := true;
  AutoPlayBox.Checked      := false;
  RWBox.Checked            := true;
  SaveROINIBox.Checked     := false;
  RecursiveDirsBox.Checked := true;
  ConfDiskDelBox.Checked   := true;
  ConfNonExistBox.Checked  := false;
  ConfClearListBox.Checked := false;
  ConfExitBox.Checked      := false;
  ConfROBox.Checked        := false;
  AutoRunBox.Checked       := false;
  MinimizeRunBox.Checked   := false;
  FadingBox.Checked        := false;
  FadedStartBox.Checked    := false;
  AskFileMaskBox.Checked   := true;
  FadingEdit.Text          := '0';
  FadedStartTimeEdit.Text  := '0';
  PrecisionEdit.Value      := DefPrecision;
  PlayListsMaskEdit.Text   := DefPlayListsMask;
  PlayListMaskEdit.Text    := DefPlayListMask;
  NameMaskEdit.Text        := DefFileNameMask;
  PadingEdit.Value         := DefID3v2Padding;
  ShowGridBox.Checked      := true;
  ShowColumnHdrBox.Checked := true;
  WidthEdit.Value          := DefFormWidth;
  HeightEdit.Value         := DefFormHeight;
  LeftEdit.Value           := 0;
  TopEdit.Value            := 0;
  SkinsPathEdit.Text       := BasePath+'Skins\';
  PlugsPathEdit.Text       := BasePath+'PlugIns\';
  ScrollMaskEdit.Text      := ScrollMask;
  MainPriorityBox.ItemIndex := 2;
  ThreadPriorityBox.ItemIndex := 5;
  FocusAfterChangeSongBox.Checked := true;
  ScanPlayTimeEdit.Value := DefScanPlayTime;
end;

procedure TOptionsForm.plFontBtnClick(Sender: TObject);
begin
  if plFontDlg.Execute then
  begin
    plFont := plFontDlg.Font;
  end;
end;

procedure TOptionsForm.plColorBtnClick(Sender: TObject);
begin
  if plColorDlg.Execute then
  begin
    plColor := plColorDlg.Color;
  end;
end;

procedure TOptionsForm.SelMaskBtnClick(Sender: TObject);
var s : string;
begin
  s := AskMask;
  if s <> '' then NameMaskEdit.Text := s;
  AskFileMaskBox.Checked := AskFileMask;
end;

procedure TOptionsForm.DefSizeBtnClick(Sender: TObject);
begin
  WidthEdit.Value := DefFormWidth;
  HeightEdit.Value := DefFormHeight;
end;

procedure TOptionsForm.CenterBtnClick(Sender: TObject);
var w,h : integer;
begin
  w := WidthEdit.Value;
  h := HeightEdit.Value;
  if w < Screen.Width then LeftEdit.Value := (Screen.Width - w) div 2 else LeftEdit.Value := 0;
  if h < Screen.Height then TopEdit.Value := (Screen.Height - h) div 2 else TopEdit.Value := 0;
end;

procedure TOptionsForm.SelSkinsDirBtnClick(Sender: TObject);
begin
  with DirDlg do
  begin
    SelectedPathName := SkinsPathEdit.Text;
    if Execute then
    begin
      SkinsPathEdit.Text := SelectedPathName;
      PopulateSkins;
    end;
  end;
end;

procedure TOptionsForm.MainPriorityBoxChange(Sender: TObject);
begin
  PreviewPriority;
end;

procedure TOptionsForm.ThreadPriorityBoxChange(Sender: TObject);
begin
  PreviewPriority;
end;

procedure TOptionsForm.MPEGPlayerPriorityBoxChange(Sender: TObject);
begin
  PreviewPriority;
end;

procedure TOptionsForm.ChoosePlugsDirBtnClick(Sender: TObject);
begin
  with DirDlg do
  begin
    SelectedPathName := PlugsPathEdit.Text;
    if Execute then
    begin
      PlugsPathEdit.Text := SelectedPathName;
      PopulatePlugs;
    end;
  end;
end;

procedure TOptionsForm.PopulatePlugs;
var sr : TSearchRec;

function AddInFile(s : string) : boolean;
begin
  with InPlugsList do
  begin
    hInDLL := LoadLibrary(PChar(pPath + s));
    if (hIndll <> 0) then
    begin
      @getinfunc := GetProcAddress(hInDLL,pchar('winampGetInModule2'));
      if @getInFunc <> nil then
      begin
        p := GetInFunc;
        if p <> nil then
        begin
          Items.Add(PGPFWinAmpInputPurposePlugin(p)^.Description+' <'+s+'>');
        end;
      end;
      FreeLibrary(hInDLL);
    end;
  end;
  Result := true;
end;

function AddOutFile(s : string) : boolean;
begin
  with OutPlugsList do
  begin
    hOutDLL := LoadLibrary(PChar(pPath + s));
    if (hOutdll <> 0) then
    begin
      @getoufunc := GetProcAddress(hOutDLL,pchar('winampGetOutModule'));
      if @getouFunc <> nil then
      begin
        p := GetouFunc;
        if p <> nil then
        begin
          Items.Add(PGPFWinAmpOutputPurposePlugin(p)^.Description+' <'+s+'>');
        end;
      end;
      FreeLibrary(hOutDLL);
    end;
  end;
  Result := true;
end;

function AddVisFile(s : string) : boolean;
begin
  with VisPlugsList do
  begin
    hVisDLL := LoadLibrary(PChar(pPath + s));
    if (hVisdll <> 0) then
    begin
      @getvifunc := GetProcAddress(hVisDLL,pchar('winampVisGetHeader'));
      if @getviFunc <> nil then
      begin
        p := GetviFunc;
        if p <> nil then
        begin
          Items.Add(PGPFWinAmpVisualizationHeader(p)^.Description+' <'+s+'>');
        end;
      end;
      FreeLibrary(hVisDLL);
    end;
  end;
  Result := true;
end;

var ts : string;
begin
  InPlugIdx := -1; OutPlugIdx := -1; VisPlugIdx := -1;
  pPath := AddSlash(PlugsPathEdit.Text);
  with InPlugsList do
  begin
    Items.Clear;
    if (FindFirst(pPath + 'in_*.dll',faAnyFile,sr) = 0) then
    begin
      if AnsiUpperCase(sr.name) = 'IN_MP3.DLL' then InPlugIdx := Items.Count;
      AddInFile(sr.name);
      while (FindNext(sr) = 0) do
      begin
        if AnsiUpperCase(sr.name) = 'IN_MP3.DLL' then InPlugIdx := Items.Count;
        if not AddInFile(sr.Name) then {break};
      end;
    end;
    FindClose(sr);
  end;

  with OutPlugsList do
  begin
    Items.Clear;
    ts := AnsiUpperCase(OutPlugName);
    if (FindFirst(pPath + 'out_*.dll',faAnyFile,sr) = 0) then
    begin
      if AnsiUpperCase(sr.name) = ts then OutPlugIdx := Items.Count;
      AddOutFile(sr.name);
      while (FindNext(sr) = 0) do
      begin
        if AnsiUpperCase(sr.name) = ts then OutPlugIdx := Items.Count;
        if not AddOutFile(sr.Name) then {break};
      end;
    end;
    FindClose(sr);
  end;

  with VisPlugsList do
  begin
    Items.Clear;
    ts := AnsiUpperCase(VisPlugName);
    if (FindFirst(pPath + 'vis_*.dll',faAnyFile,sr) = 0) then
    begin
      if AnsiUpperCase(sr.name) = ts then VisPlugIdx := Items.Count;
      AddVisFile(sr.name);
      while (FindNext(sr) = 0) do
      begin
        if AnsiUpperCase(sr.name) = ts then VisPlugIdx := Items.Count;
        if not AddVisFile(sr.Name) then {break};
      end;
    end;
    FindClose(sr);
  end;
end;

procedure TOptionsForm.RefreshPlugsClick(Sender: TObject);
begin
  PopulatePlugs;
end;

procedure TOptionsForm.CurBtnClick(Sender: TObject);
begin
  PlugsPathEdit.Text := BasePath + 'PlugIns\';
  PopulatePlugs;
end;

procedure TOptionsForm.InConfBtnClick(Sender: TObject);
var i,j : integer;
    s : string;
begin
  with InPlugsList do
  begin
    i := ItemIndex;
    if i >= 0 then
    begin
      s := '';
      s := Items[i];

      i := pos('<',s);
      j := pos('>',s);
      if (i > 0)and(i < j) then
      begin
        s := copy(s,i+1,j - i - 1);
        ConfInPlug(pPath + s);
      end;
    end;
  end;
end;

procedure TOptionsForm.InInfBtnClick(Sender: TObject);
var i,j : integer;
    s : string;
begin
  with InPlugsList do
  begin
    i := ItemIndex;
    if i >= 0 then
    begin
      s := '';
      s := Items[i];

      i := pos('<',s);
      j := pos('>',s);
      if (i > 0)and(i < j) then
      begin
        s := copy(s,i+1,j - i - 1);
        AboutInPlug(pPath + s);
      end;
    end;
  end;
end;

procedure TOptionsForm.OutConfBtnClick(Sender: TObject);
var i,j : integer;
    s : string;
begin
  with OutPlugsList do
  begin
    i := ItemIndex;
    if i >= 0 then
    begin
      s := '';
      s := Items[i];

      i := pos('<',s);
      j := pos('>',s);
      if (i > 0)and(i < j) then
      begin
        s := copy(s,i+1,j - i - 1);
        ConfOutPlug(pPath + s);
      end;
    end;
  end;
end;

procedure TOptionsForm.OutInfBtnClick(Sender: TObject);
var i,j : integer;
    s : string;
begin
  with OutPlugsList do
  begin
    i := ItemIndex;
    if i >= 0 then
    begin
      s := '';
      s := Items[i];

      i := pos('<',s);
      j := pos('>',s);
      if (i > 0)and(i < j) then
      begin
        s := copy(s,i+1,j - i - 1);
        AboutOutPlug(pPath + s);
      end;
    end;
  end;
end;

procedure TOptionsForm.VisConfBtnClick(Sender: TObject);
var i,j : integer;
    s : string;
begin
  with VisPlugsList do
  begin
    i := ItemIndex;
    if i >= 0 then
    begin
      s := '';
      s := Items[i];

      i := pos('<',s);
      j := pos('>',s);
      if (i > 0)and(i < j) then
      begin
        s := copy(s,i+1,j - i - 1);
        ConfVisPlug(pPath + s);
      end;
    end;
  end;
end;

procedure TOptionsForm.VisStartBtnClick(Sender: TObject);
var i,j : integer;
    s : string;
begin
  with VisPlugsList do
  begin
    i := ItemIndex;
    if i >= 0 then
    begin
      s := '';
      s := Items[i];

      i := pos('<',s);
      j := pos('>',s);
      if (i > 0)and(i < j) then
      begin
        s := copy(s,i+1,j - i - 1);
        StartVisPlug(pPath + s);
      end;
    end;
  end;
end;

procedure TOptionsForm.VisStopBtnClick(Sender: TObject);
begin
{  StopVisPlug;}
end;

procedure TOptionsForm.InPlugsListDblClick(Sender: TObject);
begin
  InConfBtn.Click;
end;

procedure TOptionsForm.OutPlugsListDblClick(Sender: TObject);
begin
  OutConfBtn.Click;
end;

procedure TOptionsForm.VisPlugsListDblClick(Sender: TObject);
begin
  VisConfBtn.Click; 
end;

procedure TOptionsForm.MaskRulesBtnClick(Sender: TObject);
begin
  ShowMaskHlp;
end;

procedure TOptionsForm.PopulateSkins;
var sr : TSearchRec;
    ppath : string;

procedure AddSkin(s : string);
begin
  with SkinsView do
  begin
    with Items.Add do
    begin
      Caption := s;
    end;
  end;
end;

begin
//
  pPath := AddSlash(SkinsPathEdit.Text);
  with SkinsView do
  begin
    Items.Clear;
    with Items.Add do Caption := '<BASE Skin>';
    if (FindFirst(pPath + '*.*',faAnyFile,sr) = 0) then
    begin
//      if AnsiUpperCase(sr.name) = 'IN_MP3.DLL' then InPlugIdx := Items.Count;
      if (sr.Attr and faDirectory <> 0)and(sr.Name[1]<>'.') then AddSkin(sr.name);
      while (FindNext(sr) = 0) do
      begin
//        if AnsiUpperCase(sr.name) = 'IN_MP3.DLL' then InPlugIdx := Items.Count;
//        if not AddInFile(sr.Name) then {break};
        if (sr.Attr and faDirectory <> 0)and(sr.Name[1]<>'.') then AddSkin(sr.name);
      end;
    end;
    FindClose(sr);
  end;
end;

procedure TOptionsForm.PlugsPathEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    PopulatePlugs;
    key := #0;
  end;
end;

procedure TOptionsForm.Button1Click(Sender: TObject);
begin
  SkinsPathEdit.Text := BasePath + 'PlugIns\';
  PopulateSkins;
end;

procedure TOptionsForm.Button2Click(Sender: TObject);
begin
  PopulateSkins;
end;

procedure TOptionsForm.LeftEditChange(Sender: TObject);
begin
  if LeftEdit.Text <> '' then MainForm.Left := LeftEdit.Value;
end;

procedure TOptionsForm.TopEditChange(Sender: TObject);
begin
  if TopEdit.Text <> '' then MainForm.Top := TopEdit.Value;
end;

procedure TOptionsForm.CancelBtnClick(Sender: TObject);
begin
  MainForm.Width := mow;
  MainForm.Height := moh;
  MainForm.Left := mol;
  MainForm.Top := mot;
end;

procedure TOptionsForm.WidthEditChange(Sender: TObject);
begin
  if WidthEdit.Text <> '' then MainForm.Width := WidthEdit.Value;
end;

procedure TOptionsForm.HeightEditChange(Sender: TObject);
begin
  if HeightEdit.Text <> '' then MainForm.Height := HeightEdit.Value;
end;

end.
