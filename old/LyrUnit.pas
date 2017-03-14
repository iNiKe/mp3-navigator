unit LyrUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, ExtCtrls;

type
  TLyricsForm = class(TForm)
    logmemo: TMemo;
    MusCon: TADOConnection;
    musds: TADODataSet;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DoRequest;
  end;

var
  basepath,dbpath : string;
  rBandName,rAlbumName,rSongTitle,rYear : string;

procedure RequestLyrics(BandName,AlbumName,SongTitle,Year : string);

  implementation uses Main;

procedure RequestLyrics(BandName,AlbumName,SongTitle,Year : string);
begin
  rBandName := BandName;
  rAlbumName := AlbumName;
  rSongTitle := SongTitle;
  rYear := Year;

  with TLyricsForm.Create(MainForm) do
  begin
    Show;
  end;
end;

{$R *.dfm}

procedure TLyricsForm.DoRequest;
var albumid,cmd,bandid,s : string;
    num : integer;
    found : boolean;
begin
  with logmemo.Lines do
  begin
    Application.ProcessMessages;
    found := false;
    Add('Запрос (Band = "'+rBandName+'" Album = "'+rAlbumName+'" Song = "'+rSongTitle+'"');
    Add('Connecting to Music DB...');
    MusCon.Open;
    if MusCon.Connected then
    begin
      Application.ProcessMessages;
      Add('O.K.');
      if musds.Active then musds.Close;
      logmemo.Lines.Add('Looking up BandID...');
      cmd := 'SELECT * FROM Bands WHERE BandName LIKE '''+MakeSQLStr(rBandName)+'''';
      musds.CommandType := cmdText;
      musds.CommandText := cmd;
      musds.Connection := MusCon;
      musds.Open;
      Application.ProcessMessages;
      num := musds.RecordCount;
      if num > 0 then
      begin
        bandid := musds.Fields[0].AsString;
        logmemo.Lines.Add('ok ('+bandid+')');
        musds.Close;
        Application.ProcessMessages;
        logmemo.Lines.Add('Looking up AlbumID...');
        cmd := 'SELECT * FROM Albums WHERE BandID LIKE '''+bandid+''' AND AlbumName LIKE '''+makesqlstr(rAlbumName)+'''';
        musds.CommandText := cmd;
        musds.Open;
        Application.ProcessMessages;
        num := musds.RecordCount;
        if num > 0 then
        begin
          albumid := musds.Fields[0].AsString;
          logmemo.Lines.Add('ok ('+albumid+')');
          musds.Close;
          Application.ProcessMessages;
          logmemo.Lines.Add('Looking up Lyrics from album...');
          cmd := 'SELECT * FROM Lyrics WHERE BandID LIKE '''+bandid+''' AND AlbumID LIKE '''+albumid+''' AND SongName LIKE '''+makesqlstr(rSongTitle)+'''';
          musds.CommandText := cmd;
          musds.Open;
          Application.ProcessMessages;
          num := musds.RecordCount;
          if num > 0 then
          begin
            found := true;
            logmemo.Lines.Add('ok, found:');
            logmemo.Lines.Add('');
            s := musds.Fields[5].AsString;
            logmemo.Lines.Add(s);
            Application.ProcessMessages;
          end else
          logmemo.Lines.Add('failed');

          musds.Close;
          Application.ProcessMessages;
        end else
        logmemo.Lines.Add('failed');

        if not found then
        begin
          if musds.Active then musds.Close;
          logmemo.Lines.Add('Trying 2 find just lyrics...');
          cmd := 'SELECT * FROM Lyrics WHERE BandID LIKE '''+bandid+''' AND SongName LIKE '''+makesqlstr(rSongTitle)+'''';
          musds.CommandText := cmd;
          musds.Open;
          Application.ProcessMessages;
          num := musds.RecordCount;
          if num > 0 then
          begin
            logmemo.Lines.Add('ok, found:');
            logmemo.Lines.Add('');
            s := musds.Fields[5].AsString;
            logmemo.Lines.Add(s);
            Application.ProcessMessages;
          end else
          begin
            logmemo.Lines.Add('failed - no lyrics found :(');
          end;
          musds.Close;
        end;
        musds.Close;
      end else
      logmemo.Lines.Add('failed');
      Application.ProcessMessages;
    end else
    begin
      Add('Error!');
    end;
  end;
end;

procedure TLyricsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MusCon.Close;
  Action := caFree;
end;

procedure TLyricsForm.FormCreate(Sender: TObject);
begin
  basepath := extractfilepath(application.ExeName);
//  dbpath := basepath;
  dbpath := basepath+'..\..\db\';

  MusCon.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+dbpath+'music.mdb;Persist Security Info=False';
end;

procedure TLyricsForm.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled := false;
  DoRequest;
end;

end.
