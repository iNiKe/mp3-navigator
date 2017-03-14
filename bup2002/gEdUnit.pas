unit gEdUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, UPTImageCombo, MPGTools, Gauges, MyStrs;

type
  TgEdForm = class(TForm)
    PageControl: TPageControl;
    ID3v1Sheet: TTabSheet;
    ID3v2Sheet: TTabSheet;
    DIDTGSheet: TTabSheet;

    RemoveID3v1Box: TCheckBox;
    RemoveID3v2Box: TCheckBox;
    RemoveDIDBox: TCheckBox;
    ArtistEnBox: TCheckBox;
    TitleEnBox: TCheckBox;
    AlbumEnBox: TCheckBox;
    YearEnBox: TCheckBox;
    GenreEnBox: TCheckBox;
    TrackEnBox: TCheckBox;
    GuessID3FromNameBox: TCheckBox;
    CommentEnBox: TCheckBox;
    CommentEdit: TEdit;
    TrackEdit: TEdit;
    AlbumEdit: TEdit;
    TitleEdit: TEdit;
    YearEdit: TEdit;
    GenreBox: TComboBox;
    ArtistEdit: TEdit;
    CopyFromID3v2tov1: TCheckBox;

    IArtistEnBox: TCheckBox;
    ITitleEnBox: TCheckBox;
    IAlbumEnBox: TCheckBox;
    IYearEnBox: TCheckBox;
    ITrackEnBox: TCheckBox;
    IGenreEnBox: TCheckBox;
    ICommentsEnBox: TCheckBox;
    IArtistEdit: TEdit;
    ITitleEdit: TEdit;
    IAlbumEdit: TEdit;
    IYearEdit: TEdit;
    ITrackEdit: TEdit;
    IGenreBox: TComboBox;
    ICommentsMemo: TMemo;

    DArtistEnBox: TCheckBox;
    DTitleEnBox: TCheckBox;
    DAlbumEnBox: TCheckBox;
    DYearEnBox: TCheckBox;
    DGenreEnBox: TCheckBox;
    DCommentsEnBox: TCheckBox;
    DArtistEdit: TEdit;
    DTitleEdit: TEdit;
    DAlbumEdit: TEdit;
    DYearEdit: TEdit;
    DGenreBox: TComboBox;
    DCommentsEdit: TEdit;
    StatusBar: TStatusBar;
    SaveBtn: TButton;
    CancelBtn: TButton;
    ExistID3v1Box: TCheckBox;
    ExistID3v2Box: TCheckBox;
    ExistDIDBox: TCheckBox;
    CopyFromID3v1tov2: TCheckBox;
    TabSheet1: TTabSheet;
    OptBegMPEGBox: TCheckBox;
    ProgressGauge: TGauge;
    T1BandCaseBox: TComboBox;
    T1TitleCaseBox: TComboBox;
    T1AlbumCaseBox: TComboBox;
    T1CommentCaseBox: TComboBox;
    T2BandCaseBox: TComboBox;
    T2TitleCaseBox: TComboBox;
    T2AlbumCaseBox: TComboBox;
    T2GenreCaseBox: TComboBox;
    DTBandCaseBox: TComboBox;
    DTTitleCaseBox: TComboBox;
    DTAlbumCaseBox: TComboBox;
    DTGenreCaseBox: TComboBox;
    DTCommentCaseBox: TComboBox;

    procedure SaveBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ArtistEnBoxClick(Sender: TObject);
    procedure TitleEnBoxClick(Sender: TObject);
    procedure AlbumEnBoxClick(Sender: TObject);
    procedure YearEnBoxClick(Sender: TObject);
    procedure TrackEnBoxClick(Sender: TObject);
    procedure GenreEnBoxClick(Sender: TObject);
    procedure CommentEnBoxClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure IArtistEnBoxClick(Sender: TObject);
    procedure ICommentsEnBoxClick(Sender: TObject);
    procedure IGenreEnBoxClick(Sender: TObject);
    procedure ITrackEnBoxClick(Sender: TObject);
    procedure IYearEnBoxClick(Sender: TObject);
    procedure IAlbumEnBoxClick(Sender: TObject);
    procedure ITitleEnBoxClick(Sender: TObject);
    procedure DArtistEnBoxClick(Sender: TObject);
    procedure DTitleEnBoxClick(Sender: TObject);
    procedure DAlbumEnBoxClick(Sender: TObject);
    procedure DYearEnBoxClick(Sender: TObject);
    procedure DGenreEnBoxClick(Sender: TObject);
    procedure DCommentsEnBoxClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetArtistEdState(s : boolean);
    procedure SetTitleEdState(s : boolean);
    procedure SetAlbumEdState(s : boolean);
    procedure SetTrackEdState(s : boolean);
    procedure SetYearEdState(s : boolean);
    procedure SetGenreEdState(s : boolean);
    procedure SetCommentEdState(s : boolean);

    procedure SetIArtistEdState(s : boolean);
    procedure SetITitleEdState(s : boolean);
    procedure SetIAlbumEdState(s : boolean);
    procedure SetITrackEdState(s : boolean);
    procedure SetIYearEdState(s : boolean);
    procedure SetIGenreEdState(s : boolean);
    procedure SetICommentsEdState(s : boolean);

    procedure SetDArtistEdState(s : boolean);
    procedure SetDTitleEdState(s : boolean);
    procedure SetDAlbumEdState(s : boolean);
    procedure SetDYearEdState(s : boolean);
    procedure SetDGenreEdState(s : boolean);
    procedure SetDCommentsEdState(s : boolean);

  public
    { Public declarations }
  end;

const CC : array[boolean] of tColor = (clBtnFace,clWindow);

function EditFilesTag : integer;

  implementation

uses Main;

var StopProc : boolean;
    LastPage : integer;
    GEDForm  : TgEdForm;

procedure TgEdForm.SetIArtistEdState(s : boolean);
begin
  with IArtistEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetITitleEdState(s : boolean);
begin
  with ITitleEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetIAlbumEdState(s : boolean);
begin
  with IAlbumEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetITrackEdState(s : boolean);
begin
  with ITrackEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetIYearEdState(s : boolean);
begin
  with IYearEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetIGenreEdState(s : boolean);
begin
  with IGenreBox  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetICommentsEdState(s : boolean);
begin
  with ICommentsMemo  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetDArtistEdState(s : boolean);
begin
  with DArtistEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetDTitleEdState(s : boolean);
begin
  with DTitleEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetDAlbumEdState(s : boolean);
begin
  with DAlbumEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetDYearEdState(s : boolean);
begin
  with DYearEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetDGenreEdState(s : boolean);
begin
  with DGenreBox  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TgEdForm.SetDCommentsEdState(s : boolean);
begin
  with DCommentsEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TGEdForm.SetArtistEdState(s : boolean);
begin
  with ArtistEdit  do begin Enabled := s; Color := cc[s]; end;
end;

procedure TGEdForm.SetTitleEdState(s : boolean);
begin
  with TitleEdit   do begin Enabled := s; Color := cc[s]; end;
end;

procedure TGEdForm.SetAlbumEdState(s : boolean);
begin
  with AlbumEdit   do begin Enabled := s; Color := cc[s]; end;
end;

procedure TGEdForm.SetTrackEdState(s : boolean);
begin
  with TrackEdit   do begin Enabled := s; Color := cc[s]; end;
end;

procedure TGEdForm.SetYearEdState(s : boolean);
begin
  with YearEdit    do begin Enabled := s; Color := cc[s]; end;
end;

procedure TGEdForm.SetGenreEdState(s : boolean);
begin
  with GenreBox    do begin Enabled := s; Color := cc[s]; end;
end;

procedure TGEdForm.SetCommentEdState(s : boolean);
begin
  with CommentEdit do begin Enabled := s; Color := cc[s]; end;
end;

function EditFilesTag : integer;
begin
  Result := -1;
  GEDForm := tGEDForm.Create(Application);
  with GEDForm do
  try
    if ShowModal <> mrCancel then Result := 0;
   finally
    Free;
  end;
end;

{$R *.DFM}

function GEDMPEGProgressFunc(const TagData : TMPEGAudio; Counter : Integer) : Boolean; far;
begin
  Result := true;
  if GEDForm = nil then exit;
  if Counter > 100 then Counter := 100 else if Counter < 0 then Counter := 0;
  if Counter <> GEDForm.ProgressGauge.Progress then
  begin
    GEDForm.ProgressGauge.Progress := Counter;
    Application.ProcessMessages;
  end;
end;

procedure TgEdForm.SaveBtnClick(Sender: TObject);
var DelimiterPos,i : integer;
    trk,trklen,sc,done,t,e : integer;
    s : string;
    oldo,bb,chg,found : boolean;

begin
  ProgressFunc := @GEDMPEGProgressFunc;
  ID3v1Sheet.Enabled := false;
  ID3v2Sheet.Enabled := false;
  DIDTGSheet.Enabled := false;
  with MainForm.PlayList.Items do
  begin
    LastPage := PageControl.ActivePageIndex;
    ProgressGauge.Visible := true;
    ProgressGauge.Progress := 0;
    StopProc := false;
    sc := MainForm.PlayList.SelCount;
    StatusBar.Panels[1].Text := '';
    Application.ProcessMessages;
    if sc > 0 then
    begin
      oldo := OptBegMPEG;
      OptBegMPEG := OptBegMPEGBox.Checked;
      done := 0;
      for i := 0 to Count - 1 do if Item[i] <> nil then if Item[i].Selected then
      begin
        if StopProc then break;
        inc(done);
        StatusBar.Panels[0].Text := inttostr(round((done / sc)*100))+'% ('+inttostr(sc)+' / '+inttostr(done)+')';
        Application.ProcessMessages;
        CheckItem(Item[i]);
        if Item[i].Data <> nil then if tMPEGAudio(Item[i].Data^).LoadData = 0 then with tMPEGAudio(Item[i].Data^).Data do
        begin
          StatusBar.Panels[1].Text := tMPEGAudio(Item[i].Data^).File_Name;
          Application.ProcessMessages;
          if (ExistDIDBox.Checked) then if DIDTag.isDIDTagged then bb := true else bb := false
            else bb := true;
          if bb then
          begin
            if RemoveDIDBox.Checked then DIDTag.IsDIDTagged := false else
            begin
              chg := false;
              with DIDTag do
              begin
                if not DIDTag.IsDIDTagged then
                begin
                  DIDTag.Artist := '';
                  DIDTag.Title  := '';
                  DIDTag.Album  := '';
                  DIDTag.Year   := '';
                  DIDTag.Genre  := '';
                  DIDTag.EncodedBy := '';
                  DIDTag.EncSoft   := '';
                  DIDTag.Comment   := '';
                end;

                if DCommentsEnBox.Checked then begin chg := true; Comment := DCommentsEdit.Text; end;
                if DArtistEnBox.Checked   then begin chg := true; Artist  := DArtistEdit.Text; end;
                if DTitleEnBox.Checked    then begin chg := true; Title   := DTitleEdit.Text; end;
                if DAlbumEnBox.Checked    then begin chg := true; Album   := DAlbumEdit.Text; end;
                if DYearEnBox.Checked     then begin chg := true; Year    := DYearEdit.Text; end;
                if DGenreEnBox.Checked    then begin chg := true; Genre   := DGenreBox.Text; end;
              end;

              if chg then
              begin
                DIDTag.IsDIDTagged := true;
              end;
            end;
          end;
          if (ExistID3v1Box.Checked) then if ID3v1Tag.isID3v1Tagged then bb := true else bb := false
            else bb := true;
          if bb then
          begin
            if RemoveID3v1Box.Checked then ID3v1Tag.isID3v1Tagged := false else
            begin
              if not ID3v1Tag.IsID3v1Tagged then
              begin
                ID3v1Tag.Artist := '';
                ID3v1Tag.Title  := '';
                ID3v1Tag.Album  := '';
                ID3v1Tag.Year   := '';
                ID3v1Tag.Genre  := 255;
                ID3v1Tag.Comment := '';
                ID3v1Tag.Track := 0;
              end;
              chg := false;
              if (CopyFromID3v2TOv1.Checked)and(ID3v2Tag.isID3v2Tagged) then
              begin
                chg := true;
                with ID3v2Tag do
                begin
                  ID3v1Tag.Comment  := Comments;
                  ID3v1Tag.Artist   := Artist;
                  ID3v1Tag.Title    := Title;
                  ID3v1Tag.Album    := Album;
                  ID3v1Tag.Year     := Year;
                  ID3v1Tag.Track    := GetTrackNum(Track);
                end;
              end;
              if GuessID3FromNameBox.Checked then
              begin
                chg := true;
                s := TrimLeft(ExtractFileName (tMPEGAudio(Item[i].Data^).File_Name));
                trklen := 0;
                if (length(s) > 3)and(s[1] in ['0'..'9'])and(s[2] in ['0'..'9']) then
                begin
                  if copy(s,3,2) = '. ' then trklen := 4 else
                   if copy(s,3,3) = ' - ' then trklen := 5;
                end;
                if trklen > 0 then
                begin
                  trk := (ord(s[1])-ord('0'))*10;
                  trk := trk+ord(s[2])-ord('0');
                  system.delete(s,1,trklen);
                  s := TrimLeft(s);
                  ID3v1Tag.Track := trk;

                  for DelimiterPos := Length (s) downto 1 do if s[DelimiterPos] = '.' then
                  begin
                    s := Copy (s, 1, DelimiterPos - 1);
                    break;
                  end;
                  ID3v1Tag.Title := s;
                end else
                begin
                  DelimiterPos := Pos (Delimiter, s);
                  If DelimiterPos > 0 then
                    s := Trim (Copy (s, 1, DelimiterPos - 1))
                  else s := '';
                  ID3v1Tag.Artist := s;
                  s := ExtractFileName (tMPEGAudio(Item[i].Data^).File_Name);
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
                  ID3v1Tag.Title := s;
                end;
              end;
              with ID3v1Tag do
              begin
                if CommentEnBox.Checked then begin chg := true; Comment := CommentEdit.Text; end;
                if ArtistEnBox.Checked  then begin chg := true; Artist  := ArtistEdit.Text; end;
                if TitleEnBox.Checked   then begin chg := true; Title   := TitleEdit.Text; end;
                if AlbumEnBox.Checked   then begin chg := true; Album   := AlbumEdit.Text; end;
                if YearEnBox.Checked    then begin chg := true; Year    := YearEdit.Text; end;
                if GenreEnBox.Checked then
                begin
                  chg := true;
                  found := false; s := trim(uppercase(GenreBox.Text));
                  for t := 0 to MaxGenres do
                  begin
                    if trim(uppercase(Genres[t])) = s then
                    begin
                      Found := true;
                      break;
                    end;
                  end;
                  if Found then Genre := t else Genre := 255;
                end;
                if TrackEnBox.Checked then
                begin
                  val(TrackEdit.Text,t,e);
                  if e = 0 then
                  begin
                    chg := true;
                    Track := t;
                  end;
                end;
                if T1BandCaseBox.ItemIndex > 0 then
                begin
                  chg := true;
                  case T1BandCaseBox.ItemIndex of
                   1: Artist := Strcapfirst(Artist);
                   2: Artist := StrCap(Artist);
                   3: Artist := stralldown(Artist);
                   4: Artist := StrAllUp(Artist);
                  end;
                end;
                if T1TitleCaseBox.ItemIndex > 0 then
                begin
                  chg := true;
                  case T1TitleCaseBox.ItemIndex of
                   1: Title := Strcapfirst(Title);
                   2: Title := StrCap(Title);
                   3: Title := stralldown(Title);
                   4: Title := StrAllUp(Title);
                  end;
                end;
                if T1AlbumCaseBox.ItemIndex > 0 then
                begin
                  chg := true;
                  case T1AlbumCaseBox.ItemIndex of
                   1: Album := Strcapfirst(Album);
                   2: Album := StrCap(Album);
                   3: Album := stralldown(Album);
                   4: Album := StrAllUp(Album);
                  end;
                end;
                if T1CommentCaseBox.ItemIndex > 0 then
                begin
                  chg := true;
                  case T1CommentCaseBox.ItemIndex of
                   1: Comment := Strcapfirst(Comment);
                   2: Comment := StrCap(Comment);
                   3: Comment := stralldown(Comment);
                   4: Comment := StrAllUp(Comment);
                  end;
                end;
              end;
              if chg then ID3v1Tag.isID3v1Tagged := true;

            end;
          end; {if exist...}

          if (ExistID3v2Box.Checked) then if ID3v2Tag.isID3v2Tagged then bb := true else bb := false
            else bb := true;
          if bb then
          begin
            if RemoveID3v2Box.Checked then ID3v2Tag.isID3v2Tagged := false else
            begin
              chg := false;

              if not ID3v2Tag.isID3v2Tagged then with ID3v2Tag do
              begin
                ID3v2Tag.Composer   := '';
                ID3v2Tag.OrigArtist := '';
                ID3v2Tag.stURL      := '';
                ID3v2Tag.CopyRight  := '';
                ID3v2Tag.EncodedBy  := '';
                ID3v2Tag.Comments   := '';
                ID3v2Tag.Artist     := '';
                ID3v2Tag.Title      := '';
                ID3v2Tag.Album      := '';
                ID3v2Tag.Year       := '';
                ID3v2Tag.Track      := '';
                ID3v2Tag.Genre      := '';
              end;

              if (CopyFromID3v1TOv2.Checked)and(ID3v1Tag.isID3v1Tagged) then
              begin
                chg := true;
                with ID3v1Tag do
                begin
                  ID3v2Tag.Comments := Comment;
                  ID3v2Tag.Artist   := Artist;
                  ID3v2Tag.Title    := Title;
                  ID3v2Tag.Album    := Album;
                  ID3v2Tag.Year     := Year;
                  ID3v2Tag.Track    := inttostr(Track);
                  if {(Genre >= 0)and}(Genre <= MaxGenres) then ID3v2Tag.Genre := Genres[Genre];
                end;
              end;
              with ID3v2Tag do
              begin
                if ICommentsEnBox.Checked then begin chg := true; Comments := ICommentsMemo.Text; end;
                if IArtistEnBox.Checked   then begin chg := true; Artist   := IArtistEdit.Text; end;
                if ITitleEnBox.Checked    then begin chg := true; Title    := ITitleEdit.Text; end;
                if IAlbumEnBox.Checked    then begin chg := true; Album    := IAlbumEdit.Text; end;
                if IYearEnBox.Checked     then begin chg := true; Year     := IYearEdit.Text; end;
                if IGenreEnBox.Checked    then begin chg := true; Genre    := IGenreBox.Text; end;
                if ITrackEnBox.Checked then
                begin
                  chg := true;
                  Track := ITrackEdit.Text;
                end;
              end;

              if chg then with ID3v2Tag do
              begin
                isID3v2Tagged := true;
              end;
            end;
          end;

          tMPEGAudio(Item[i].Data^).WriteTags;
          RefreshItem(Item[i]);
        end;
        if Done >= sc then break;
      end;
      StatusBar.Panels[0].Text := inttostr(round((done / sc)*100))+'% ('+inttostr(sc)+' / '+inttostr(done)+')';
      StatusBar.Panels[1].Text := 'Завершено.';
      Application.ProcessMessages;
      OptBegMPEG := oldo;
    end;
  end;
  ID3v1Sheet.Enabled := true;
  ID3v2Sheet.Enabled := true;
  DIDTGSheet.Enabled := true;
  ProgressGauge.Progress := 100;
  Application.ProcessMessages;
  ProgressFunc := nil;
end;

procedure TgEdForm.FormCreate(Sender: TObject);
var i : integer;
begin
  StopProc := false;
  ProgressGauge.Visible := false;
  PageControl.ActivePageIndex := LastPage;
  GenreBox.Items.Add('');
  IGenreBox.Items.Add('');
  DGenreBox.Items.Add('');
  for i := 0 to MaxGenres do
  begin
    GenreBox.Items.Add(Genres[i]);
    IGenreBox.Items.Add(Genres[i]);
    DGenreBox.Items.Add(Genres[i]);
  end;

  for i := 0 to MaxAddGenres do
  begin
    IGenreBox.Items.Add(AddGenres[i]);
    DGenreBox.Items.Add(AddGenres[i]);
  end;

  SetArtistEdState(ArtistEnBox.Checked);
  SetTitleEdState(TitleEnBox.Checked);
  SetAlbumEdState(AlbumEnBox.Checked);
  SetTrackEdState(TrackEnBox.Checked);
  SetYearEdState(YearEnBox.Checked);
  SetGenreEdState(GenreEnBox.Checked);
  SetCommentEdState(CommentEnBox.Checked);

  SetIArtistEdState(IArtistEnBox.Checked);
  SetITitleEdState(ITitleEnBox.Checked);
  SetIAlbumEdState(IAlbumEnBox.Checked);
  SetITrackEdState(ITrackEnBox.Checked);
  SetIYearEdState(IYearEnBox.Checked);
  SetIGenreEdState(IGenreEnBox.Checked);
  SetICommentsEdState(ICommentsEnBox.Checked);

  SetDArtistEdState(DArtistEnBox.Checked);
  SetDTitleEdState(DTitleEnBox.Checked);
  SetDAlbumEdState(DAlbumEnBox.Checked);
  SetDYearEdState(DYearEnBox.Checked);
  SetDGenreEdState(DGenreEnBox.Checked);
  SetDCommentsEdState(DCommentsEnBox.Checked);
end;

procedure TgEdForm.ArtistEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetArtistEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.TitleEnBoxClick(Sender: TObject);
begin
  if Sender = nil then exit;
  if tCheckBox(Sender).Checked then
  begin
    if ConfGroupNameEdit then
    begin
      if MessageDlg('Групповое изменение названий '#13#10+
                    'может переписать много полезной информации '#13#10+
                    'при неправильном использовании!'#13#10+
                    'Продолжить?',mtWarning,[mbOK,mbCancel],0) = mrCancel then
      begin
        tCheckBox(Sender).Checked := false;
      end;
    end;
  end;
  SetTitleEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.AlbumEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetAlbumEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.YearEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetYearEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.TrackEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetTrackEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.GenreEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetGenreEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.CommentEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetCommentEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.CancelBtnClick(Sender: TObject);
begin
  StopProc := true;
end;

procedure TgEdForm.IArtistEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetIArtistEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.ICommentsEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetICommentsEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.IGenreEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetIGenreEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.ITrackEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetITrackEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.IYearEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetIYearEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.IAlbumEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetIAlbumEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.ITitleEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetITitleEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.DArtistEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetDArtistEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.DTitleEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetDTitleEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.DAlbumEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetDAlbumEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.DYearEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetDYearEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.DGenreEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetDGenreEdState(tCheckBox(Sender).Checked);
end;

procedure TgEdForm.DCommentsEnBoxClick(Sender: TObject);
begin
  if Sender <> nil then SetDCommentsEdState(tCheckBox(Sender).Checked);
end;

end.



