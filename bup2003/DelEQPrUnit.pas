unit DelEQPrUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TDelEQPrForm = class(TForm)
    PresetsBox: TListBox;
    DelBtn: TButton;
    CancelBtn: TButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PresetsBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPresets;
    procedure DelCurPreset;
  end;

var DelEQPrForm: TDelEQPrForm;

procedure DelPreset;

  implementation uses Main, IO;

{$R *.DFM}

procedure DelPreset;
begin
  with TDelEQPrForm.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TDelEQPrForm.DelCurPreset;
var f : file;
    s,t,st,stu : string;
    hdr : array[0..30] of char;
    eqd : array[0..267] of byte;
    nr,i,ior : integer;
begin
{$I-}
  s := BasePath + 'mp3nav.q1';
  i := PresetsBox.ItemIndex;
  if i < 0 then exit;
  st := trim(PresetsBox.Items[i]);
  PresetsBox.Items.Delete(i);
  stu := AnsiUpperCase(st);
  if length(st) > 267 - 12 then st := copy(st,1,267 - 12);
  if FileExists(s) then
  begin
    FileMode := fmOpenReadWrite;
    AssignFile(f,s); reset(f,1);
    blockread(f,hdr,sizeof(hdr));
    ior := IOResult;
    if not FatalIOError(ior) then
    begin
      while not eof(f) do
      begin
        blockread(f,eqd,sizeof(eqd));
        i := 0; t := '';
        while (i < 267 - 11) do
        begin
          if eqd[i] = 0 then break else t := t + char(eqd[i]);
          inc(i);
        end;
        t := ansiuppercase(trim(t));
        if t = stu then
        begin
          i := filepos(f);
          if eof(f) then
          begin
            i := i - sizeof(eqd);
          end else
          begin
            while not eof(f) do
            begin
              seek(f,i);
              blockread(f,eqd,sizeof(eqd),nr);
              if nr > 0 then
              begin
                seek(f,i - sizeof(eqd));
                blockwrite(f,eqd,nr);
                inc(i,nr);
                if i > filesize(f) then break;
              end;
              if nr <> sizeof(eqd) then break;
            end;
            i := i - sizeof(eqd);
          end;
          seek(f,i);
//          ior := IOResult;
          Truncate(f);
//          ior := IOResult;
          break;
        end;
      end;
    end;
  end;
  CloseFile(f);
  LoadPresets;
{$I+}
end;

procedure TDelEQPrForm.LoadPresets;
var f : file;
    s : string;
    hdr : array[0..30] of char;
    eqd : array[0..267] of byte;
    i,ior : integer;
begin
  PresetsBox.Items.BeginUpdate;
  PresetsBox.Items.Clear;
  s := BasePath + 'mp3nav.q1';
{$I-}
  if FileExists(s) then
  begin
    assignfile(f,s); reset(f,1);
    blockread(f,hdr,sizeof(hdr));
    ior := IOResult;
    if not FatalIOError(ior) then
    begin
      while not eof(f) do
      begin
        blockread(f,eqd,sizeof(eqd));
        i := 0; s := '';
        while (i < 267 - 11) do
        begin
          if eqd[i] = 0 then break else s := s + char(eqd[i]);
          inc(i);
        end;
        s := trim(s);
        if s <> '' then
        begin
          PresetsBox.Items.Add(s);
        end;
        ior := IOResult;
        if FatalIOError(IOR) then
        begin
{          syserrormessage(ior);{}
          break;
        end;
      end;
    end else
    begin
{      syserrormessage(ior);{}
    end;
    closefile(f);
  end;
{$I+}
  PresetsBox.Items.EndUpdate;
end;

procedure TDelEQPrForm.Button1Click(Sender: TObject);
begin
  LoadPresets;
end;

procedure TDelEQPrForm.DelBtnClick(Sender: TObject);
begin
  DelCurPreset;
end;

procedure TDelEQPrForm.FormCreate(Sender: TObject);
begin
  LoadPresets;
end;

procedure TDelEQPrForm.PresetsBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
  begin
    DelCurPreset;
  end;
end;

end.
