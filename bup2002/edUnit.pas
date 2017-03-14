unit edUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, UPTSplitter, UPTImageCombo,
  MPGTools, Gauges, Menus, MyStrs;

type
  TedForm = class(TForm)
    PageControl: TPageControl;
    ID3v1andDIDSheet: TTabSheet;
    ID3v2Sheet: TTabSheet;
    InfoSheet: TTabSheet;
    NameEdit: TEdit;
    ID3v1EnabledBox: TCheckBox;
    ArtistEdit: TEdit;
    TitleEdit: TEdit;
    AlbumEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    YearEdit: TEdit;
    TrackEdit: TEdit;
    CommentLabel: TLabel;
    CommentEdit: TEdit;

    ID3v2EnabledBox: TCheckBox;
    iArtistEdit: TEdit;
    iTitleEdit: TEdit;
    iAlbumEdit: TEdit;
    iLabel1: TLabel;
    iLabel2: TLabel;
    iLabel3: TLabel;
    iLabel4: TLabel;
    iLabel5: TLabel;
    iLabel6: TLabel;
    iYearEdit: TEdit;
    iTrackEdit: TEdit;
    iCommentLabel: TLabel;

    DIDEnabledBox: TCheckBox;
    dArtistEdit: TEdit;
    dTitleEdit: TEdit;
    dAlbumEdit: TEdit;
    dLabel1: TLabel;
    dLabel2: TLabel;
    dLabel3: TLabel;
    dLabel4: TLabel;
    dLabel5: TLabel;
    dYearEdit: TEdit;
    dCommentLabel: TLabel;
    dCommentEdit: TEdit;
    dEncodedByEdit: TEdit;
    dEncSoftEdit: TEdit;
    SaveBtn: TButton;
    CancelBtn: TButton;
    iCommentsMemo: TMemo;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    iURLEdit: TEdit;
    iComposerEdit: TEdit;
    iOrigArtistEdit: TEdit;
    iEncodedByEdit: TEdit;
    iCopyRightEdit: TEdit;
    AdvTagEditBtn: TButton;
    Label12: TLabel;
    Label13: TLabel;
    GenreBox: TComboBox;
    dGenreBox: TComboBox;
    iGenreBox: TComboBox;
    GroupBox1: TGroupBox;
    InfoMemo: TMemo;
    Button1: TButton;
    ID3v1toID3v2Btn: TButton;
    ID3v2toID3v1Btn: TButton;
    OptBegMPEGBox: TCheckBox;
    ProgressGauge: TGauge;
    edPopUp: TPopupMenu;
    UPCASE1: TMenuItem;
    downcase1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ID3v1EnabledBoxClick(Sender: TObject);
    procedure ID3v2EnabledBoxClick(Sender: TObject);
    procedure DIDEnabledBoxClick(Sender: TObject);
    procedure InfoMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure iCommentsMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ID3v2toID3v1BtnClick(Sender: TObject);
    procedure ID3v1toID3v2BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure edPopUpPopup(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure UPCASE1Click(Sender: TObject);
    procedure downcase1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetID3v1State(s : boolean);
    procedure SetID3v2State(s : boolean);
    procedure SetDIDTGState(s : boolean);
    procedure SaveState;
  public
    { Public declarations }
  end;


function EditFile(FileName : string) : integer;

var LastCtrl : integer;
    LastPage : integer;

  implementation uses Main;

var mpa : tMPEGAudio;
    FFName : string;
    EDForm : tEDForm;

{$R *.DFM}

function EDMPEGProgressFunc(const TagData : TMPEGAudio; Counter : Integer) : Boolean; far;
begin
  Result := true;
  if EDForm = nil then exit;
  if Counter > 100 then Counter := 100 else if Counter < 0 then Counter := 0;
  if Counter <> EDForm.ProgressGauge.Progress then
  begin
    EDForm.ProgressGauge.Progress := Counter;
    Application.ProcessMessages;
  end;
end;

procedure tEdForm.SaveState;
begin
  LastPage := PageControl.ActivePageIndex;
  LastCtrl := 0;
  if LastPage = 0 then
  begin
  {ID3v1 Sheet}
    if ID3v1EnabledBox.Focused then LastCtrl := 01 else
    if ArtistEdit.Focused      then LastCtrl := 02 else
    if TitleEdit.Focused       then LastCtrl := 03 else
    if AlbumEdit.Focused       then LastCtrl := 04 else
    if YearEdit.Focused        then LastCtrl := 05 else
    if GenreBox.Focused        then LastCtrl := 06 else
    if TrackEdit.Focused       then LastCtrl := 07 else
    if CommentEdit.Focused     then LastCtrl := 08 else
    begin
      if ActiveControl <> nil then
      case ActiveControl.Tag of
      1: LastCtrl := 6;
      end;
    end;
  end else if LastPage=1 then
  begin
  {ID3v2 Sheet}
    if ID3v2EnabledBox.Focused then LastCtrl := 09 else
    if iArtistEdit.Focused     then LastCtrl := 10 else
    if iTitleEdit.Focused      then LastCtrl := 11 else
    if iAlbumEdit.Focused      then LastCtrl := 12 else
    if iYearEdit.Focused       then LastCtrl := 13 else
    if iGenreBox.Focused       then LastCtrl := 14 else
    if iTrackEdit.Focused      then LastCtrl := 15 else
    if iURLEdit.Focused        then LastCtrl := 16 else
    if iComposerEdit.Focused   then LastCtrl := 17 else
    if iOrigArtistEdit.Focused then LastCtrl := 18 else
    if iEncodedByEdit.Focused  then LastCtrl := 19 else
    if iCopyRightEdit.Focused  then LastCtrl := 20 else
    begin
      if ActiveControl <> nil then
      case ActiveControl.Tag of
      2: LastCtrl := 14;
      end;
    end;
  end else if LastPage = 2 then
  begin
  {DID Sheet}
    if DIDEnabledBox.Focused   then LastCtrl := 21 else
    if dArtistEdit.Focused     then LastCtrl := 22 else
    if dTitleEdit.Focused      then LastCtrl := 23 else
    if dAlbumEdit.Focused      then LastCtrl := 24 else
    if dYearEdit.Focused       then LastCtrl := 25 else
    if dGenreBox.Focused       then LastCtrl := 26 else
    if dCommentEdit.Focused    then LastCtrl := 27 else
    if dEncodedByEdit.Focused  then LastCtrl := 28 else
    if dEncSoftEdit.Focused    then LastCtrl := 29;
    begin
      if ActiveControl <> nil then
      case ActiveControl.Tag of
      3: LastCtrl := 26;
      end;
    end;
  end;
end;

function EditFile(FileName : string) : integer;
begin
  Result := mrCancel;
  ffName := ExpandFileName(FileName);
  if (ffName = '')or(not FileExists(ffName)) then exit;
  mpa := tMPEGAudio.Create;
  mpa.AutoLoad  := true;
  mpa.File_Name := ffName;
  if mpa.LoadData = 0 then
  begin
    EDForm := tEDForm.Create(Application);
    with EDForm do
    try
      Result := ShowModal;
     finally
      Free;
    end;
  end else
  begin
    Result := mrCancel;
  end;
  mpa.Free;
end;

procedure TedForm.ID3v1toID3v2BtnClick(Sender: TObject);
begin
  SetID3v2State(true);
  iTitleEdit.Text   := TitleEdit.Text;
  iArtistEdit.Text  := ArtistEdit.Text;
  iAlbumEdit.Text   := AlbumEdit.Text;
  iCommentsMemo.Lines.Text := CommentEdit.Text;
  iYearEdit.Text    := YearEdit.Text;
  iTrackEdit.Text   := TrackEdit.Text;
  iGenreBox.Text := GenreBox.Text {Items[GenreBox.ItemIndex]};
end;

procedure TedForm.SetID3v1State(s : boolean);
begin
  ID3v1EnabledBox.Checked := s;
  ID3v1toID3v2Btn.Enabled := s;
  ArtistEdit.Enabled  := s;
  TitleEdit.Enabled   := s;
  AlbumEdit.Enabled   := s;
  YearEdit.Enabled    := s;
  GenreBox.Enabled    := s;
  TrackEdit.Enabled   := s;
  CommentEdit.Enabled := s;

  with ArtistEdit do  if Enabled then Color := clWindow else Color := clBtnFace;
  with TitleEdit do   if Enabled then Color := clWindow else Color := clBtnFace;
  with AlbumEdit do   if Enabled then Color := clWindow else Color := clBtnFace;
  with YearEdit do    if Enabled then Color := clWindow else Color := clBtnFace;
  with GenreBox do    if Enabled then Color := clWindow else Color := clBtnFace;
  with TrackEdit do   if Enabled then Color := clWindow else Color := clBtnFace;
  with CommentEdit do if Enabled then Color := clWindow else Color := clBtnFace;
end;

procedure TedForm.SetID3v2State(s : boolean);
begin
  ID3v2EnabledBox.Checked:=s;
  ID3v2toID3v1Btn.Enabled := s;
  iArtistEdit.Enabled := s;
  iTitleEdit.Enabled := s;
  iAlbumEdit.Enabled := s;
  iYearEdit.Enabled := s;
  iGenreBox.Enabled := s;
  iTrackEdit.Enabled := s;
  iCommentsMemo.Enabled := s;
  iURLEdit.Enabled := s;
  iComposerEdit.Enabled := s;
  iOrigArtistEdit.Enabled := s;
  iEncodedByEdit.Enabled := s;
  iCopyRightEdit.Enabled := s;

  with iArtistEdit do     if Enabled then Color := clWindow else Color := clBtnFace;
  with iTitleEdit do      if Enabled then Color := clWindow else Color := clBtnFace;
  with iAlbumEdit do      if Enabled then Color := clWindow else Color := clBtnFace;
  with iYearEdit do       if Enabled then Color := clWindow else Color := clBtnFace;
  with iGenreBox do       if Enabled then Color := clWindow else Color := clBtnFace;
  with iTrackEdit do      if Enabled then Color := clWindow else Color := clBtnFace;
  with iCommentsMemo do   if Enabled then Color := clWindow else Color := clBtnFace;
  with iURLEdit do        if Enabled then Color := clWindow else Color := clBtnFace;
  with iComposerEdit do   if Enabled then Color := clWindow else Color := clBtnFace;
  with iOrigArtistEdit do if Enabled then Color := clWindow else Color := clBtnFace;
  with iEncodedByEdit do  if Enabled then Color := clWindow else Color := clBtnFace;
  with iCopyRightEdit do  if Enabled then Color := clWindow else Color := clBtnFace;
end;

procedure TedForm.SetDIDTGState(s : boolean);
begin
  DIDEnabledBox.Checked:=s;
  dArtistEdit.Enabled := s;
  dTitleEdit.Enabled := s;
  dAlbumEdit.Enabled := s;
  dYearEdit.Enabled := s;
  dGenreBox.Enabled := s;
  dCommentEdit.Enabled := s;
  dEncodedByEdit.Enabled := s;
  dEncSoftEdit.Enabled := s;
  with dArtistEdit do    if Enabled then Color := clWindow else Color := clBtnFace;
  with dTitleEdit do     if Enabled then Color := clWindow else Color := clBtnFace;
  with dAlbumEdit do     if Enabled then Color := clWindow else Color := clBtnFace;
  with dYearEdit do      if Enabled then Color := clWindow else Color := clBtnFace;
  with dGenreBox do      if Enabled then Color := clWindow else Color := clBtnFace;
  with dCommentEdit do   if Enabled then Color := clWindow else Color := clBtnFace;
  with dEncodedByEdit do if Enabled then Color := clWindow else Color := clBtnFace;
  with dEncSoftEdit do   if Enabled then Color := clWindow else Color := clBtnFace;
end;

procedure TedForm.FormCreate(Sender: TObject);
const yesno : array[boolean] of string = ('no','yes');
var found : boolean;
    s : string;
    i : integer;
begin
//  it := tMenuItem.Create(ArtistEdit);
//  it.Caption := 'UPCASE';
//  it.
//  ArtistEdit.PopupMenu.Items.Add(EdPopUp.Items.Items[1]);
  if (LastPage >= 0)and(LastPage < PageControl.PageCount) then PageControl.ActivePageIndex := LastPage;
  if mpa<>nil then with mpa.Data do
  begin
    GenreBox.Items.Add('');
    iGenreBox.Items.Add('');
    dGenreBox.Items.Add('');
    for i := 0 to MaxGenres do
    begin
      GenreBox.Items.Add(Genres[i]);
      iGenreBox.Items.Add(Genres[i]);
      dGenreBox.Items.Add(Genres[i]);
    end;
    for i:=0 to MaxAddGenres do
    begin
      iGenreBox.Items.Add(AddGenres[i]);
      dGenreBox.Items.Add(AddGenres[i]);
    end;
    with InfoMemo.Lines do
    begin
      Add('Размер файла : '+inttostr(mpa.FileLength));
      Add('Смещение заголовока : '+inttostr(mpa.FirstValidFrameHeaderPosition));
      Add('Длительность : '+inttostr(mpa.Duration)+' ('+TimeSt(mpa.Duration,true)+') секунд(ы)');
      Add('MPEG '+mpa.VersionStr+' Layer '+mpa.LayerStr+' ');
      if mpa.Data.BitRate = -1 then s:='VBR' else s:=inttostr(mpa.Data.BitRate)+' kbit';
      Add(s+', '+inttostr(mpa.Data.SampleRate)+'Hz, '+mpa.ModeStr);
      Add('CopyRight : '+mpa.CopyrightStr('Yes','No'));
      Add('Original : '+mpa.OriginalStr('Yes','No'));
      Add('Padding : '+IIFStr(mpa.Data.Padding,'Yes','No'));
      Add('Защита : '+mpa.ErrorProtectionStr('Yes','No'));
      Add('CRC : '+inttostr(mpa.Data.CRC));
      Add('Emphasis: '+MPEG_EMPHASIS[mpa.Data.Emphasis]);
      if id3v2tag.isID3v2Tagged then
      begin
        Add('');
        Add('* ID3v2 Info');
        Add('Размер TAGа: '+inttostr(id3v2tag.Size + sizeof(tID3v2Header)));
        Add('Версия TAGа: '+inttostr(id3v2tag.maVer)+'.'+inttostr(id3v2tag.miVer));
        Add('UnSynced Data: '+yesno[id3v2tag.Unsync]);
        Add('Extended Header: '+yesno[id3v2tag.isExtHdr]);
        Add('Compressed: '+yesno[id3v2tag.Compressed]);
        Add('Experimetal: '+yesno[id3v2tag.isExperim]);
      end;
    end;

    NameEdit.Text := ffName;

    with id3v1tag do if isID3v1Tagged then
    begin
      TitleEdit.Text   := Title;
      ArtistEdit.Text  := Artist;
      AlbumEdit.Text   := Album;
      CommentEdit.Text := Comment;
      YearEdit.Text    := Year;
      if Track > 0 then TrackEdit.Text := inttostr(Track);
      found := false;
      if (Genre >= 0)and(Genre <= MaxGenres) then s := trim(uppercase(Genres[Genre]));
      for i := 0 to GenreBox.Items.Count-1 do
      begin
        if trim(uppercase(GenreBox.Items[i])) = s then
        begin
          Found := true;
          break;
        end;
      end;
      if Found then GenreBox.ItemIndex := i else GenreBox.ItemIndex := 0;
    end;

    with id3v2tag do if isID3v2Tagged then
    begin
      iTitleEdit.Text    := Title;
      iArtistEdit.Text   := Artist;
      iAlbumEdit.Text    := Album;
      iCommentsMemo.Text := Comments;
      iYearEdit.Text     := Year;
      iTrackEdit.Text := Track;
      found := false; s := trim(uppercase(Genre));
      for i := 0 to iGenreBox.Items.Count-1 do
      begin
        if trim(uppercase(iGenreBox.Items[i])) = s then
        begin
          Found := true;
          break;
        end;
      end;
      if Found then iGenreBox.ItemIndex := i else
        iGenreBox.ItemIndex := iGenreBox.Items.Add(Genre);
      iURLEdit.Text := stURL;
      iComposerEdit.Text := Composer;
      iOrigArtistEdit.Text := OrigArtist;
      iEncodedByEdit.Text := EncodedBy;
      iCopyRightEdit.Text := CopyRight;
      iCommentsMemo.Lines.Text := Comments;
    end;

    with DIDtag do if isDIDTagged then
    begin
      dTitleEdit.Text     := Title;
      dArtistEdit.Text    := Artist;
      dAlbumEdit.Text     := Album;
      dCommentEdit.Text   := Comment;
      dYearEdit.Text      := Year;
      dEncodedByEdit.Text := EncodedBy;
      dEncSoftEdit.Text   := EncSoft;
      found := false; s := trim(uppercase(Genre));
      for i:=0 to dGenreBox.Items.Count-1 do
      begin
        if trim(uppercase(dGenreBox.Items[i])) = s then
        begin
          Found := true;
          break;
        end;
      end;
      if Found then dGenreBox.ItemIndex := i else
      begin
        dGenreBox.ItemIndex := dGenreBox.Items.Add(Genre);
      end;
    end;
    SetID3v1State(id3v1tag.isID3v1Tagged);
    SetID3v2State(id3v2tag.isID3v2Tagged);
    SetDIDTGState(didtag.isDIDTagged);
  end;
end;

procedure TedForm.ID3v1EnabledBoxClick(Sender: TObject);
begin
  SetID3v1State(ID3v1EnabledBox.Checked);
end;

procedure TedForm.ID3v2EnabledBoxClick(Sender: TObject);
begin
  SetID3v2State(ID3v2EnabledBox.Checked);
end;

procedure TedForm.DIDEnabledBoxClick(Sender: TObject);
begin
  SetDIDTGState(DIDEnabledBox.Checked);
end;

procedure TedForm.InfoMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TedForm.FormActivate(Sender: TObject);
begin
  if LastCtrl > 0 then
  case LastCtrl of
{ID3v1 Sheet}
  01: with ID3v1EnabledBox do if (Visible)and(Enabled) then SetFocus;
  02: with ArtistEdit do      if (Visible)and(Enabled) then SetFocus;
  03: with TitleEdit do       if (Visible)and(Enabled) then SetFocus;
  04: with AlbumEdit do       if (Visible)and(Enabled) then SetFocus;
  05: with YearEdit do        if (Visible)and(Enabled) then SetFocus;
  06: with GenreBox do        if (Visible)and(Enabled) then SetFocus;
  07: with TrackEdit do       if (Visible)and(Enabled) then SetFocus;
  08: with CommentEdit do     if (Visible)and(Enabled) then SetFocus;
{ID3v2 Sheet}
  09: with ID3v2EnabledBox do if (Visible)and(Enabled) then SetFocus;
  10: with iArtistEdit do     if (Visible)and(Enabled) then SetFocus;
  11: with iTitleEdit do      if (Visible)and(Enabled) then SetFocus;
  12: with iAlbumEdit do      if (Visible)and(Enabled) then SetFocus;
  13: with iYearEdit do       if (Visible)and(Enabled) then SetFocus;
  14: with iGenreBox do       if (Visible)and(Enabled) then SetFocus;
  15: with iTrackEdit do      if (Visible)and(Enabled) then SetFocus;
  16: with iURLEdit do        if (Visible)and(Enabled) then SetFocus;
  17: with iComposerEdit do   if (Visible)and(Enabled) then SetFocus;
  18: with iOrigArtistEdit do if (Visible)and(Enabled) then SetFocus;
  19: with iEncodedByEdit do  if (Visible)and(Enabled) then SetFocus;
  20: with iCopyRightEdit do  if (Visible)and(Enabled) then SetFocus;
{DID Sheet}
  21: with DIDEnabledBox do  if (Visible)and(Enabled) then SetFocus;
  22: with dArtistEdit do    if (Visible)and(Enabled) then SetFocus;
  23: with dTitleEdit do     if (Visible)and(Enabled) then SetFocus;
  24: with dAlbumEdit do     if (Visible)and(Enabled) then SetFocus;
  25: with dYearEdit do      if (Visible)and(Enabled) then SetFocus;
  26: with dGenreBox do      if (Visible)and(Enabled) then SetFocus;
  27: with dCommentEdit do   if (Visible)and(Enabled) then SetFocus;
  28: with dEncodedByEdit do if (Visible)and(Enabled) then SetFocus;
  29: with dEncSoftEdit do   if (Visible)and(Enabled) then SetFocus;
  end;
end;

procedure TedForm.SaveBtnClick(Sender: TObject);
var oldattr,e,i : integer;
    found : boolean;
    s : string;
begin
  found := true;
  ProgressFunc := @EDMPEGProgressFunc;
  ProgressGauge.Visible := true;
  oldattr := FileGetAttr(ffName);
  if ((oldattr and faReadOnly) <> 0) then
  begin
    if ConfDelRO then if MessageDlg('Файл "'+ffName+'" доступен "только-для-чтения"'#13#10'Продолжить?',mtWarning,[mbOK,mbCancel],0) <> mrOK then found := false;
    if found then
    begin
      FileSetAttr(ffName,oldattr and (not faReadOnly));
    end;
  end;

  if Found then
  begin
    with mpa.Data.id3v1tag do
    begin
      isID3v1Tagged := ID3v1EnabledBox.Checked;
      Title := TitleEdit.Text;
      Artist := ArtistEdit.Text;
      Album := AlbumEdit.Text;
      Comment := CommentEdit.Text;
      Year := YearEdit.Text;
      found := false; s := uppercase(trim(GenreBox.Text));
      for i := 0 to MaxGenres do
      begin
        if trim(uppercase(Genres[i])) = s then
        begin
          Found := true;
          break;
        end;
      end;
      if Found then Genre := i else Genre := 255;
      val(TrackEdit.Text,Track,e);
      if e<>0 then Track:=0;
    end;

    with mpa.Data.id3v2tag do
    begin
      isID3v2Tagged := Id3v2EnabledBox.Checked;
      Title := iTitleEdit.Text;
      Artist := iArtistEdit.Text;
      Album := iAlbumEdit.Text;
      Comments := iCommentsMemo.Text;
      Year := iYearEdit.Text;
      Track := iTrackEdit.Text;
      Genre := iGenreBox.Text;
      stURL := iURLEdit.Text;
      Composer := iComposerEdit.Text;
      OrigArtist := iOrigArtistEdit.Text;
      EncodedBy := iEncodedByEdit.Text;
      CopyRight := iCopyRightEdit.Text;
    end;

    with mpa.Data.DIDtag do
    begin
      isDIDTagged := DIDEnabledBox.Checked;
      Title := dTitleEdit.Text;
      Artist := dArtistEdit.Text;
      Album := dAlbumEdit.Text;
      Comment := dCommentEdit.Text;
      Year := dYearEdit.Text;
      EncodedBy := dEncodedByEdit.Text;
      EncSoft := dEncSoftEdit.Text;
      Genre := dGenreBox.Text;
    end;
    found := OptBegMPEG;
    OptBegMPEG := OptBegMPEGBox.Checked;
    mpa.WriteTags;
    OptBegMPEG := found;

    FileSetAttr(ffName,oldattr);
  end;

  SaveState;
  ProgressFunc := nil;
end;

procedure TedForm.CancelBtnClick(Sender: TObject);
begin
  SaveState;
end;

procedure TedForm.iCommentsMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TedForm.ID3v2toID3v1BtnClick(Sender: TObject);
var i : integer;
    found : boolean;
    s : string;    
begin
  SetID3v1State(true);
  TitleEdit.Text   := iTitleEdit.Text;
  ArtistEdit.Text  := iArtistEdit.Text;
  AlbumEdit.Text   := iAlbumEdit.Text;
  CommentEdit.Text := '';
  for i := 0 to iCommentsMemo.Lines.Count-1 do
  begin
    CommentEdit.Text := CommentEdit.Text + iCommentsMemo.Lines[i];
  end;
  YearEdit.Text    := iYearEdit.Text;
  TrackEdit.Text   := iTrackEdit.Text;
  found := false; s := uppercase(trim(iGenreBox.Text));
  for i := 0 to GenreBox.Items.Count-1 do
  begin
    if trim(uppercase(GenreBox.Items[i])) = s then
    begin
      Found := true;
      break;
    end;
  end;
  if Found then GenreBox.ItemIndex := i else GenreBox.ItemIndex := 0;
end;

procedure TedForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveState;
end;

procedure TedForm.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
//  ArtistEdit.PopupMenu.Items.Add(EdPopUp.Items.Items[1]);
//  itt.Items.Add();
//  (Sender as TEdit).PopupMenu.Items.Add(it. );
//  (Sender as TEdit).se
//  EdPopUp.Popup(mousepos.x,mousepos.y);
//  handled := true;
end;

procedure TedForm.edPopUpPopup(Sender: TObject);
begin
  with (edPopup.PopupComponent as TEdit) do
  begin
    edpopup.Items[0].Enabled := CanUndo;
    edpopup.Items[2].Enabled := SelLength > 0;
    edpopup.Items[3].Enabled := SelLength > 0;
    edpopup.Items[5].Enabled := SelLength > 0;
    edpopup.Items[7].Enabled := SelLength < length(Text);
  end;
end;

procedure TedForm.N6Click(Sender: TObject);
begin
  (edPopup.PopupComponent as TEdit).CutToClipboard;
end;

procedure TedForm.N7Click(Sender: TObject);
begin
  (edPopup.PopupComponent as TEdit).CopyToClipboard;
end;

procedure TedForm.N5Click(Sender: TObject);
begin
  (edPopup.PopupComponent as TEdit).PasteFromClipboard;
end;

procedure TedForm.N8Click(Sender: TObject);
begin
  (edPopup.PopupComponent as TEdit).ClearSelection;
end;

procedure TedForm.N10Click(Sender: TObject);
begin
  (edPopup.PopupComponent as TEdit).SelectAll;
end;

procedure TedForm.UPCASE1Click(Sender: TObject);
begin
  with (edPopup.PopupComponent as TEdit) do
  begin
    Text := STRALLUP(Text);
  end;
end;

procedure TedForm.downcase1Click(Sender: TObject);
begin
  with (edPopup.PopupComponent as TEdit) do
  begin
    Text := stralldown(Text);
  end;
end;

procedure TedForm.N3Click(Sender: TObject);
begin
  (edPopup.PopupComponent as TEdit).Undo;
end;

procedure TedForm.N1Click(Sender: TObject);
begin
  with (edPopup.PopupComponent as TEdit) do
  begin
    Text := StrCap(Text);
  end;
end;

end.
