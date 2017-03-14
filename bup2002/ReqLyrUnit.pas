unit ReqLyrUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, ADODB, ExtCtrls;

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
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    procedure InitDB;
    procedure DoRequest;
  public
    { Public declarations }
    procedure ClearInput;
  end;

var
  cursong,basepath,dbpath : string;
  reqs : boolean;

procedure RequestLyrics(BandName,AlbumName,SongTitle : string);

implementation uses main;

procedure RequestLyrics(BandName,AlbumName,SongTitle : string);
var f : boolean;
begin
  f := false;
  with TReqLyrForm.Create(MainForm) do
  begin
    if BandName <> '' then
    begin
      BandEdit.Text := BandName;
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
begin
  ClearInput;
  InitDB;
end;

procedure TReqLyrForm.InitDB;
begin
  basepath := extractfilepath(application.ExeName);
  dbpath := basepath+'..\..\db\';
  MusCon.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+dbpath+'music.mdb;Persist Security Info=False';
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
    LyrEdit.Visible := false;
    SongsBox.Visible := false;
    LyrEdit.Text := '';
    SongsBox.Items.Clear;
    SongsBox.Text := '';
//    Add('Запрос (Band = "'+rbnd+'" Album = "'+ralb+'" Song = "'+rsng+'"');
    sb.Panels[0].Text := 'Connecting to Music DB...';
//    Add('Connecting to Music DB...');
    Application.ProcessMessages;
    if not MusCon.Connected then MusCon.Open;
    if MusCon.Connected then
    begin
//      Add('ok');
      sb.Panels[0].Text := 'ok';
      Application.ProcessMessages;
      if musds.Active then musds.Close;
      if rbnd <> '' then
      begin
        sb.Panels[0].Text := 'Looking up BandID...';
//        Add('Looking up BandID...');
        Application.ProcessMessages;
        cmd := 'SELECT * FROM Bands WHERE BandName LIKE '''+MakeSQLStr(rbnd)+'''';
        musds.CommandType := cmdText;
        musds.CommandText := cmd;
        musds.Connection := MusCon;
        musds.Open;
        Application.ProcessMessages;
        num := musds.RecordCount;
        if num > 0 then
        begin
          bandid := musds.FieldByName('ID').AsString;
//          Add('ok ('+bandid+')');
          sb.Panels[0].Text := 'ok ('+bandid+')';
          Application.ProcessMessages;
        end else
        begin
//        Add('failed');
          sb.Panels[0].Text := 'failed';
          exit;
        end;
        Application.ProcessMessages;
        musds.Close;
      end;

      if ralb <> '' then
      begin
        sb.Panels[0].Text := 'Looking up AlbumID...';
//        Add('Looking up AlbumID...');
        Application.ProcessMessages;
        cmd := 'SELECT * FROM Albums WHERE BandID LIKE '''+bandid+''' AND AlbumName LIKE '''+makesqlstr(ralb)+'''';
        musds.CommandText := cmd;
        musds.Open;
        num := musds.RecordCount;
        if num > 0 then
        begin
          albumid := musds.FieldByName('ID').AsString;
//          Add('ok ('+albumid+')');
          sb.Panels[0].Text := 'ok ('+albumid+')';
          Application.ProcessMessages;
        end else
        begin
//        Add('failed');
          sb.Panels[0].Text := 'failed';
          exit;
        end;

        Application.ProcessMessages;
        musds.Close;
      end;

      sb.Panels[0].Text := 'Looking up Lyrics...';
//      Add('Looking up Lyrics...');
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
      musds.CommandText := cmd;
      musds.Open;
      Application.ProcessMessages;
      num := musds.RecordCount;
      if num > 0 then
      begin
        found := true;
//        Add('ok, found '+inttostr(num)+' song(s)');
        sb.Panels[0].Text := 'ok, found '+inttostr(num)+' song(s)';
        Application.ProcessMessages;
      end else
//      Add('failed');
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
        Application.ProcessMessages;
      end;
      musds.Close;

      Application.ProcessMessages;
    end else
    begin
//      Add('Error!');
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
  BandEdit.Visible := false;
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

procedure TReqLyrForm.FormResize(Sender: TObject);
begin
  lyredit.Width := Width - lyredit.Left - 10;
  lyredit.Height := Height - lyredit.Top - 50;
end;

end.
