unit SaveEQPrUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Winamp, IO;

type
  TSaveEQPrForm = class(TForm)
    SaveBtn: TButton;
    CancelBtn: TButton;
    PresetsBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PresetsBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPresets;
  end;

var SaveEQPrForm: TSaveEQPrForm;

procedure SavePreset;

implementation uses Main;

{$R *.DFM}

procedure SavePreset;
begin
  with TSaveEQPrForm.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TSaveEQPrForm.LoadPresets;
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

procedure TSaveEQPrForm.FormCreate(Sender: TObject);
begin
  LoadPresets;
end;

procedure TSaveEQPrForm.SaveBtnClick(Sender: TObject);
var f : file;
    s,t,st,stu : string;
    hdr : array[0..30] of char;
    eqd : array[0..267] of byte;
    i,ior : integer;
begin
{$I-}
  s := BasePath + 'mp3nav.q1';
  st := trim(PresetsBox.Text);
  stu := AnsiUpperCase(st);
  if length(st) > 267 - 12 then st := copy(st,1,267 - 12);
  if FileExists(s) then
  begin
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
          seek(f,filepos(f) - sizeof(eqd));
          break;
        end;
      end;
    end;
  end else
  begin
    AssignFile(f,s); rewrite(f,1);
    fillchar(hdr,sizeof(hdr),0);
    hdr := 'Winamp EQ library file v1.1'#$1A'!--';
  end;
  fillchar(eqd,sizeof(eqd),0);
  for i := 1 to length(st) do
  begin
    eqd[i-1] := byte(st[i]);
  end;
  for i := 0 to 9 do eqd[257 + i] := EQData[i];
  eqd[267] := EQPreAmp;
  eqd[length(st)] := 0;
  blockwrite(f,eqd,sizeof(eqd));
  closefile(f);
{$I+}
end;

procedure TSaveEQPrForm.PresetsBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then SaveBtn.Click else
  if (Key = VK_ESCAPE) then CancelBtn.Click;
end;

end.
