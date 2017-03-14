unit ReqLyrUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, ADODB, ExtCtrls, DBCtrls, Grids;

type
  TReqLyrForm = class(TForm)
    BandEdit: TEdit;
    ReqLyrMemo: TMemo;
    BandBox: TCheckBox;
    AlbumBox: TCheckBox;
    AlbumEdit: TEdit;
    LyrBox: TCheckBox;
    LyrEdit: TRichEdit;
    SongsBox: TComboBox;
    sb: TStatusBar;
    Button1: TButton;
    ReqBtn: TButton;
    Button3: TButton;
    MusCon: TADOConnection;
    musds: TADODataSet;
    SongBox: TCheckBox;
    SongTitleEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    tBandEdit: TEdit;
    tAlbumEdit: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ruchars: TStringGrid;
    enchars: TStringGrid;
    Label4: TLabel;
    Label5: TLabel;
    TextMemo: TMemo;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SongsLBox: TComboBox;
    BandsLBox: TComboBox;
    AlbumsLBox: TComboBox;
    procedure LyrBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReqBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SongBoxClick(Sender: TObject);
    procedure AlbumBoxClick(Sender: TObject);
    procedure BandBoxClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SongsBoxSelect(Sender: TObject);
    procedure ReqBtnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ReqBtnKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rucharsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure encharsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BandsLBoxSelect(Sender: TObject);
    procedure AlbumsLBoxSelect(Sender: TObject);
    procedure SongsLBoxSelect(Sender: TObject);
  private
    { Private declarations }
    procedure InitDB;
    procedure DoRequest;
  public
    { Public declarations }
    procedure ClearInput;
    procedure GetBands;
    procedure GetAlbums;
    procedure GetSongs;
  end;

const
{$IFDEF _DEMO_}
  basefile = 'demo.mdb';
{$ELSE}
  basefile = 'music.mdb';
{$ENDIF}

var
  basepath,dbpath : string;
  Curln,CurLang,CurChar,CurBandName,CurBand,CurAlbum,CurSong : string;
  reqs : boolean;
  shifted : boolean = false;

const RuCh = '*?Z#ÀÁÂÃÄÅÆÇÈÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÝÞß';
      EnCh = '*#ABCDEFGHIJKLMNOPQRSTUVWXYZ';

procedure RequestLyrics(BandName,AlbumName,SongTitle : string);

implementation uses main;

function LZs(s : string; n : integer; ch : char) : string;
begin
  Result := s;
  while length(Result) < n do Result := ch+Result;
end;

function LZ(i,n : integer; ch : char) : string;
begin
  Result := inttostr(i);
  while length(Result) < n do Result := ch+Result;
end;


procedure RequestLyrics(BandName,AlbumName,SongTitle : string);
var f : boolean;
begin
  f := false;
  with TReqLyrForm.Create(MainForm) do
  begin
    if BandName <> '' then
    begin
      BandEdit.Text := BandName;
//      BandCombo.Text := BandName;
      BandBox.Checked := true;
      f := true;
    end;
    if AlbumName <> '' then
    begin
      AlbumEdit.Text := AlbumName;
      AlbumBox.Checked := true;
      f := true;
    end;
    if SongTitle <> '' then
    begin
      SongTitleEdit.Text := SongTitle;
      SongBox.Checked := true;
      f := true;
    end;
    Show;
    if f then ReqBtn.Click;
  end;
end;

{$R *.dfm}

procedure TReqLyrForm.LyrBoxClick(Sender: TObject);
begin
  ReqLyrMemo.Visible := LyrBox.Checked;
end;

procedure TReqLyrForm.FormCreate(Sender: TObject);
var i : integer;
begin
  shifted := false;
  BandsLBox.Visible := false;
  AlbumsLBox.Visible := false;
  SongsLBox.Visible := false;
  TextMemo.Visible := false;
  
  PageControl1.ActivePageIndex := 0;
  ruchars.BorderStyle := bsNone;
  enchars.BorderStyle := bsNone;
  ClearInput;
  for i := 0 to length(ruch)-1 do
  begin
    ruchars.Cells[i mod 7,i div 7] := ruch[i+1];
  end;
  for i := 0 to length(ench)-1 do
  begin
    enchars.Cells[i mod 7,i div 7] := ench[i+1];
  end;
  InitDB;
end;

procedure TReqLyrForm.GetAlbums;
var s,cmd : string;
    num,i : integer;
begin
  cmd := 'SELECT * FROM Albums ';
//  cmd := cmd + CurLang;
  cmd := cmd + ' WHERE BandID LIKE '''+CurBand+'''';
  cmd := cmd + ' ORDER BY Year,AlbumName';

  if musds.Active then musds.Close;
  musds.CommandText := cmd;
  musds.Open;

  with AlbumsLBox.Items do
  begin
    Clear;
    Add('');
    num := musds.RecordCount;
    for i := 1 to num do
    begin
      s := musds.FieldByName('Year').AsString;
      if s <> '' then s := '('+s+') ';
      s := s + musds.FieldByName('AlbumName').AsString+' ('+musds.FieldByName('ID').AsString+')';
      Add(s);
      musds.Next;
    end;
    AlbumsLBox.ItemIndex := 0;
  end;
  musds.Close;
end;

procedure TReqLyrForm.GetBands;
var cmd : string;
    num,i : integer;
begin
  cmd := 'SELECT * FROM Bands ';
  if CurChar = '?' then
  begin
    cmd := cmd + 'WHERE BandName = ''?''';
    {if LyrBandsBox.Checked then }cmd := cmd + ' AND (NumLyr > 0) ';
  end else
  begin
    cmd := cmd + CurLang;
    {if LyrBandsBox.Checked then }cmd := cmd + ' AND (NumLyr > 0) ';
    if CurChar <> '*' then
    begin
      cmd := cmd + ' AND (';
      if CurChar = '#' then
      begin
        cmd := cmd + ' (BandName BETWEEN ''0%'' AND ''9%'') )';
      end else
      if (CurChar = 'A')and(curln = 'ru') then  // A .. Z
      begin
        cmd := cmd + ' ( (BandName BETWEEN ''A%'' AND ''Z%'') OR (BandName LIKE ''Z%'') ) )';
      end else
  (*
  '*AZ#þàá ö ä å ôãõ é êëìíîïÿðñòóæâü ù ÷ú';
  *)
      if CurChar = 'ö' then
      begin
        cmd := cmd + 'BandName LIKE ''ö_%'')';
      end else
      if CurChar = 'å' then
      begin
        cmd := cmd + 'BandName LIKE ''å_%'')';
      end else
      if CurChar = 'é' then
      begin
        cmd := cmd + 'BandName LIKE ''é_%'')';
      end else
      if CurChar = 'ù' then
      begin
        cmd := cmd + 'BandName LIKE ''ù_%'')';
      end else
      begin
        cmd := cmd + 'BandName LIKE '''+CurChar+'%'')';
      end;
    end else
    begin
  //      cmd := cmd + ' WHERE BandName = ''%''';
    end;
  //  cmd := 'SELECT * FROM Bands'#13+'WHERE BandName LIKE ''H%''';
  end;
  cmd := cmd + ' ORDER BY BandName';

  if musds.Active then musds.Close;
  musds.CommandText := cmd;
  musds.Open;

  with BandsLBox.Items do
  begin
    Clear;
//    musds.First;
    num := musds.RecordCount;
    for i := 1 to num do
    begin
      Add(musds.FieldByName('BandName').AsString + ' ('+musds.FieldByName('ID').AsString+')');
      musds.Next;
    end;
    BandsLBox.ItemIndex := 0;
  end;
  musds.Close;
end;

procedure TReqLyrForm.InitDB;
begin
  basepath := extractfilepath(application.ExeName);
  dbpath := basepath+'db\';
  if not fileexists(dbpath+basefile) then
  begin
    dbpath := '\db\';
    if not fileexists(dbpath+basefile) then dbpath := '';
  end;
  MusCon.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+dbpath+basefile+';Persist Security Info=False';
  musds.CommandType := cmdText;
    musds.Connection := MusCon;
end;

procedure TReqLyrForm.DoRequest;
var rbnd,ralb,rtit,rlyr,albumid,cmd,bandid,s : string;
    i,num : integer;
    fl,found : boolean;
begin
  if reqs then exit;
  reqs := true;
  with lyredit.Lines do
  begin
    Application.ProcessMessages;
    found := false;
    if BandBox.Checked then rbnd := trim(BandEdit.Text) else rbnd := '';
//    if BandBox.Checked then rbnd := trim(BandCombo.Text) else rbnd := '';
    if AlbumBox.Checked then ralb := trim(AlbumEdit.Text) else ralb := '';
    if SongBox.Checked then rtit := trim(SongTitleEdit.Text) else rtit := '';
    if LyrBox.Checked then rlyr := (ReqLyrMemo.Text) else rlyr := '';
    albumid := '';
    bandid := '';
    tBandEdit.Visible := false;
    tAlbumEdit.Visible := false;
    Label1.Visible := false;
    Label2.Visible := false;
    Label3.Visible := false;
    if shifted then LyrEdit.Visible := true else LyrEdit.Visible := false;
    SongsBox.Visible := false;
    LyrEdit.Text := '';
    SongsBox.Items.Clear;
    SongsBox.Text := '';
    if shifted then LyrEdit.Lines.Add('Çàïðîñ (Band = "'+rbnd+'" Album = "'+ralb+'" Song = "'+rtit+'" Lyr = "'+rlyr+'"');
    sb.Panels[0].Text := 'Connecting to Music DB...';
    if shifted then LyrEdit.Lines.Add('Connecting to Music DB...');
    Application.ProcessMessages;
    if not MusCon.Connected then MusCon.Open;
    if MusCon.Connected then
    begin
      if shifted then LyrEdit.Lines.Add('ok');
      sb.Panels[0].Text := 'ok';
      Application.ProcessMessages;
      if musds.Active then musds.Close;
      if rbnd <> '' then
      begin
        if shifted then LyrEdit.Lines.Add('Looking up BandID...');
        sb.Panels[0].Text := 'Looking up BandID...';
        Application.ProcessMessages;
        cmd := 'SELECT * FROM Bands WHERE BandName LIKE '''+MakeSQLStr(rbnd)+'''';
        if shifted then LyrEdit.Lines.Add('SQLcmd: "'+cmd+'"');
        musds.CommandType := cmdText;
        musds.CommandText := cmd;
        musds.Connection := MusCon;
        musds.Open;
        Application.ProcessMessages;
        num := musds.RecordCount;
        if num > 0 then
        begin
          bandid := musds.FieldByName('ID').AsString;
          sb.Panels[0].Text := 'ok ('+bandid+')';
          if shifted then LyrEdit.Lines.Add('ok BandID: "'+bandid+'"');
          Application.ProcessMessages;
        end else
        begin
          if shifted then LyrEdit.Lines.Add('failed');
          sb.Panels[0].Text := 'failed';
//          exit;
          bandid := '';
          bandbox.Checked := false;
          albumid := '';
          albumbox.Checked := false;
        end;
        Application.ProcessMessages;
        musds.Close;
      end;

      if (ralb <> '')and(bandid <> '') then
      begin
        sb.Panels[0].Text := 'Looking up AlbumID...';
        if shifted then LyrEdit.Lines.Add('Looking up AlbumID...');
        Application.ProcessMessages;
        cmd := 'SELECT * FROM Albums WHERE BandID LIKE '''+bandid+''' AND AlbumName LIKE '''+makesqlstr(ralb)+'''';
        if shifted then LyrEdit.Lines.Add('SQLcmd: "'+cmd+'"');
        musds.CommandText := cmd;
        musds.Open;
        num := musds.RecordCount;
        if num > 0 then
        begin
          albumid := musds.FieldByName('ID').AsString;
          if shifted then LyrEdit.Lines.Add('ok ('+albumid+')');
          sb.Panels[0].Text := 'ok ('+albumid+')';
          Application.ProcessMessages;
        end else
        begin
          if shifted then LyrEdit.Lines.Add('failed');
          sb.Panels[0].Text := 'failed';
//          exit;
          albumid := '';
          albumbox.Checked := false;
        end;

        Application.ProcessMessages;
        musds.Close;
      end;

      sb.Panels[0].Text := 'Looking up Lyrics...';
      if shifted then LyrEdit.Lines.Add('Looking up Lyrics...');
      Application.ProcessMessages;
      cmd := 'SELECT * FROM Lyrics';
//      cmd := 'SELECT DISTINCT * FROM Lyrics';
      if (bandid <> '')or(albumid <> '')or(rtit <> '')or(rlyr <> '') then
      begin
        fl := false;
        cmd := cmd + ' WHERE ';
//       BandID LIKE '''+bandid+''' AND AlbumID LIKE '''+albumid+''' AND SongName LIKE '''+makesqlstr(rtit)+'''';
        if bandid <> '' then
        begin
          cmd := cmd + ' BandID LIKE '''+BandID+''' ';
          fl := true;
        end;
        if albumid <> '' then
        begin
          if fl then cmd := cmd + ' AND ' else fl := true;
          cmd := cmd + ' AlbumID LIKE '''+AlbumID+''' ';
        end;
        if rtit <> '' then
        begin
          if fl then cmd := cmd + ' AND ' else fl := true;
          cmd := cmd + ' SongName LIKE '''+MakeSQLstr(rtit)+''' ';
        end;
        if rlyr <> '' then
        begin
          if fl then cmd := cmd + ' AND ' {else fl := true};
          cmd := cmd + ' Text LIKE ''%'+MakeSQLstr(rlyr)+'%'' ';
        end;
      end;
      if shifted then LyrEdit.Lines.Add('SQLcmd: "'+cmd+'"');
      musds.CommandText := cmd;
      musds.Open;
      Application.ProcessMessages;
      num := musds.RecordCount;
      if num > 0 then
      begin
        found := true;
        if shifted then LyrEdit.Lines.Add('ok, found '+inttostr(num)+' song(s)');
        sb.Panels[0].Text := 'ok, found '+inttostr(num)+' song(s)';
        Application.ProcessMessages;
      end else
      begin
        if shifted then LyrEdit.Lines.Add('failed');
      end;
      Application.ProcessMessages;
      if found then
      begin
//          num := musds.RecordCount;
        for i := 1 to num do
        begin
          s := musds.FieldByName('SongName').AsString;
          s := s + ' ('+musds.FieldByName('ID').AsString+')';
          SongsBox.Items.Add(s);
          musds.Next;
        end;
        LyrEdit.Visible := false;
        SongsBox.Visible := true;
        Application.ProcessMessages;
        SongsBox.ItemIndex := 0;
        SongsBox.OnSelect(Self);
      end else
      begin
        sb.Panels[0].Text := 'no songs found :*(';
        if shifted then LyrEdit.Lines.Add('no songs found :*(');
        Application.ProcessMessages;
      end;
      musds.Close;

      Application.ProcessMessages;
    end else
    begin
      if shifted then LyrEdit.Lines.Add('Error!');
      sb.Panels[0].Text := 'Error!';
    end;
  end;
end;

procedure TReqLyrForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MusCon.Connected then MusCon.Open;
  Action := caFree;
end;

procedure TReqLyrForm.ReqBtnClick(Sender: TObject);
begin
  DoRequest;
  reqs := false;
end;

procedure TReqLyrForm.Button1Click(Sender: TObject);
begin
  if reqs then exit;
  ClearInput;
end;

procedure TReqLyrForm.ClearInput;
begin
  cursong := '';
  LyrEdit.Text := '';
  LyrEdit.Visible := false;
  SongsBox.Items.Clear;
  SongsBox.Visible := false;

  ReqLyrMemo.Text := '';
  ReqLyrMemo.Visible := false;
  LyrBox.Checked := false;
  SongTitleEdit.Text := '';
  SongTitleEdit.Visible := false;
  SongBox.Checked := false;
  AlbumBox.Checked := false;
  AlbumEdit.Text := '';
  AlbumEdit.Visible := false;
  BandBox.Checked := false;
  BandEdit.Text := '';
//  BandCombo.Text := '';
  BandEdit.Visible := false;
//  BandCombo.Visible := false;
  tBandEdit.Text := '';
  tAlbumEdit.Text := '';
  tBandEdit.Visible := false;
  tAlbumEdit.Visible := false;
  Label1.Visible := false;
  Label2.Visible := false;
  Label3.Visible := false;
end;

procedure TReqLyrForm.SongBoxClick(Sender: TObject);
begin
  SongTitleEdit.Visible := SongBox.Checked;
end;

procedure TReqLyrForm.AlbumBoxClick(Sender: TObject);
begin
  AlbumEdit.Visible := AlbumBox.Checked;
end;

procedure TReqLyrForm.BandBoxClick(Sender: TObject);
begin
  BandEdit.Visible := BandBox.Checked;
//  BandCombo.Visible := BandBox.Checked;
end;

procedure TReqLyrForm.Button3Click(Sender: TObject);
begin
  if reqs then exit;
  Close;
end;

procedure TReqLyrForm.SongsBoxSelect(Sender: TObject);
var i : integer;
    ta,tb,cmd : string;
begin
  tBandEdit.Text := '';
  tAlbumEdit.Text := '';
  CurSong := SongsBox.Text;
  i := length(CurSong);
  while (i > 0)and(CurSong[i] <> '(') do dec(i);
  CurSong := Copy(CurSong,i+1,length(CurSong));
  CurSong := Copy(CurSong,1,pos(')',CurSong)-1);
  cmd := 'SELECT * FROM Lyrics ';
  cmd := cmd + ' WHERE (ID LIKE '''+CurSong+''')';
//  cmd := cmd + ' ORDER BY AlbumID,SongName';

  if musds.Active then musds.Close;
  musds.CommandType := cmdText;
  musds.CommandText := cmd;
  musds.Connection := MusCon;
  musds.Open;

  if musds.RecordCount > 0 then
  begin
    LyrEdit.Lines.Clear;
    LyrEdit.Text := musds.FieldByName('Text').AsString;
    tb := musds.FieldByName('BandID').AsString;
    ta := musds.FieldByName('AlbumID').AsString;
  end;
  musds.Close;

  cmd := 'SELECT * FROM Albums WHERE ID LIKE '''+ta+'''';
  musds.CommandText := cmd;
  musds.Open;
  if musds.RecordCount > 0 then
  begin
    ta := musds.FieldByName('AlbumName').AsString;
  end;
  musds.Close;

  tAlbumEdit.Text := ta;
  Label1.Visible := true;
  tAlbumEdit.Visible := true;
  Application.ProcessMessages;

  cmd := 'SELECT * FROM Bands WHERE ID LIKE '''+tb+'''';
  musds.CommandText := cmd;
  musds.Open;
  if musds.RecordCount > 0 then
  begin
    tb := musds.FieldByName('BandName').AsString;
  end;
  musds.Close;

  tBandEdit.Text := tb;
  tBandEdit.Visible := true;
  Label2.Visible := true;

  LyrEdit.Visible := true;
  Label3.Visible := true;
  Application.ProcessMessages;
end;

procedure TReqLyrForm.ReqBtnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_CONTROL then shifted := true;
end;

procedure TReqLyrForm.ReqBtnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  shifted := false;
end;

procedure TReqLyrForm.rucharsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  curln := 'ru';
  CurLang := ' WHERE ( Lang LIKE ''ru'' ) ';

  CurChar := trim(ruchars.Cells[acol,arow]);
  if (CurChar = '') then CurChar := '*' else
  begin
    CurChar := CurChar[1];
    if CurChar[1] = ' ' then CurChar := '*';
  end;

  GetBands;

  enchars.BorderStyle := bsNone;
  ruchars.BorderStyle := bsSingle;

  BandsLBox.Visible := true;
  AlbumsLBox.Visible := false;
  SongsLBox.Visible := false;
  TextMemo.Visible := false;
end;

procedure TReqLyrForm.encharsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  curln := 'fo';
  CurLang := ' WHERE ( (Lang NOT LIKE ''ru'') OR (Lang IS NULL) ) ';

  CurChar := trim(enchars.Cells[acol,arow]);
  if (CurChar = '') then CurChar := '*' else
  begin
    CurChar := CurChar[1];
    if CurChar[1] = ' ' then CurChar := '*';
  end;

  GetBands;

  ruchars.BorderStyle := bsNone;
  enchars.BorderStyle := bsSingle;

  BandsLBox.Visible := true;
  AlbumsLBox.Visible := false;
  SongsLBox.Visible := false;
  TextMemo.Visible := false;
end;

procedure TReqLyrForm.BandsLBoxSelect(Sender: TObject);
var i : integer;
begin
  CurBand := BandsLBox.Text;
  i := length(CurBand);
  while (i > 0)and(CurBand[i] <> '(') do dec(i);
  CurBandName := Trim(Copy(CurBand,1,i-1));
  CurBand := Copy(CurBand,i+1,length(CurBand));
  CurBand := Trim(Copy(CurBand,1,pos(')',CurBand)-1));

  GetAlbums;

//  BandsLBox.Visible := true;
  AlbumsLBox.Visible := true;
  SongsLBox.Visible := false;
  TextMemo.Visible := false;
  AlbumsLBox.ItemIndex := 0;
  Application.ProcessMessages;
  AlbumsLBox.OnSelect(Self);
{
  AlbumBox.Visible := true;
  NewAlbumBtn.Visible := true;
  SongBox.Visible := false;
  textredit.Visible := false;

  NewAlbumBtn.Visible := true;
  NewSongBtn.Visible := false;
  SaveBtn.Visible := false;
  CurTrackEdit.Visible := false;
  Application.ProcessMessages;
  AlbumBox.ItemIndex := 0;
  AlbumBox.OnSelect(Self);
}
end;

procedure TReqLyrForm.AlbumsLBoxSelect(Sender: TObject);
var i : integer;
begin
  CurAlbum := AlbumsLBox.Text;
  i := length(CurAlbum);
  while (i > 0)and(CurAlbum[i] <> '(') do dec(i);
  CurAlbum := Copy(CurAlbum,i+1,length(CurAlbum));
  CurAlbum := Copy(CurAlbum,1,pos(')',CurAlbum)-1);

  GetSongs;

  SongsLBox.Visible := true;
  textmemo.Visible := false;
end;


procedure TReqLyrForm.GetSongs;
var s,cmd : string;
    num,i : integer;
begin
  cmd := 'SELECT * FROM Lyrics ';
  if CurAlbum <> '' then
  begin
    cmd := cmd + ' WHERE (BandID LIKE '''+CurBand+''') AND (AlbumID LIKE '''+CurAlbum+''')';
  end else
  begin
    cmd := cmd + ' WHERE (BandID LIKE '''+CurBand+''') AND ((AlbumID LIKE '''') OR (AlbumID IS NULL))';
    cmd := cmd + ' ORDER BY AlbumID,SongName';
  end;

  if musds.Active then musds.Close;
  musds.CommandText := cmd;
  musds.Open;

  with SongsLBox.Items do
  begin
    Clear;
    num := musds.RecordCount;
    for i := 1 to num do
    begin
      s := musds.FieldByName('Track').AsString;
      if length(s) > 2 then s := 'xx. ' else
      begin
        if s <> '' then s := LZs(s,2,'0') + '. ';
      end;
      Add(s + musds.FieldByName('SongName').AsString+' ('+musds.FieldByName('ID').AsString+')');
      musds.Next;
    end;
    SongsLBox.ItemIndex := 0;
  end;
  musds.Close;
end;

procedure TReqLyrForm.SongsLBoxSelect(Sender: TObject);
var cmd : string;
    i : integer;
begin
  CurSong := SongsLBox.Text;
  i := length(CurSong);
  while (i > 0)and(CurSong[i] <> '(') do dec(i);
  CurSong := Copy(CurSong,i+1,length(CurSong));
  CurSong := Copy(CurSong,1,pos(')',CurSong)-1);
  cmd := 'SELECT * FROM Lyrics ';
  cmd := cmd + ' WHERE (ID LIKE '''+CurSong+''')';
//  cmd := cmd + ' ORDER BY AlbumID,SongName';

  if musds.Active then musds.Close;
  musds.CommandText := cmd;
  musds.Open;

  if musds.RecordCount > 0 then
  begin
    TextMemo.Lines.Clear;
    TextMemo.Text := musds.FieldByName('Text').AsString;
  end;
  musds.Close;

  textmemo.Visible := true;
end;

end.
