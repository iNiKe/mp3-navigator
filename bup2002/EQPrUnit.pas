unit EQPrUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IO, Winamp;

type
  TEQPrForm = class(TForm)
    PresetsBox: TListBox;
    LoadPrBtn: TButton;
    CancelPrBtn: TButton;
    RefreshPrBtn: TButton;
    Label1: TLabel;
    procedure LoadPresets;
    procedure FormCreate(Sender: TObject);
    procedure RefreshPrBtnClick(Sender: TObject);
    procedure LoadPrBtnClick(Sender: TObject);
    procedure LoadPr;
    procedure PresetsBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PresetsBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelPrBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type pEQData = ^tEQData;
     tEQData = record
       eqp : TGPFWinAmpInputPluginEQData;
       eqa : integer;
       eqs : string;
     end;

const MaxEQPr = 1000;

var EQPrForm  : TEQPrForm;
    nEQPr     : integer = 0;
    EQPresets : array[1..MaxEQPr] of tEQData;
    OldPreAmp : integer;
    OldEQData : TGPFWinAmpInputPluginEQData;

  implementation uses main,EQUnit;

{$R *.DFM}

procedure TEQPrForm.LoadPresets;
var f : file;
    s : string;
    hdr : array[0..30] of char;
    eqd : array[0..267] of byte;
    i,ior : integer;
begin
  PresetsBox.Items.BeginUpdate;
  PresetsBox.Items.Clear;
  s := BasePath + 'mp3nav.q1';
  for i := 1 to nEQPr do with EQPresets[i] do
  begin
    fillchar(eqp,sizeof(eqp),0);
    eqa := 0;
    eqs := '';
  end;
  nEQPr := 0;
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
          inc(nEQPr);
          with EQPresets[nEQPr] do
          begin
            for i := 0 to 9 do eqp[i] := eqd[257 + i];
            eqa := eqd[267];
            eqs := s;
          end;
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

procedure TEQPrForm.FormCreate(Sender: TObject);
begin
  OldEQData := EQData;
  OldPreAmp := EQPreAmp;
  LoadPresets;
end;

procedure TEQPrForm.RefreshPrBtnClick(Sender: TObject);
begin
  LoadPresets;
end;

procedure TEQPrForm.LoadPrBtnClick(Sender: TObject);
begin
  LoadPr;
  Close;
end;

procedure TEQPrForm.LoadPr;
var i : integer;
    s : string;
begin
  with PresetsBox do
  begin
    i := ItemIndex;
    if i >= 0 then
    begin
      s := AnsiUpperCase(Items[i]);
      if s <> '' then
      for i := 1 to nEQPr do with EQPresets[i] do
      begin
        if s = AnsiUpperCase(eqs) then
        begin
          EQData   := eqp;
          EQPreAmp := eqa;
          Break;
        end;
      end;
      EQForm.InitEQs;
      SetEQ;
    end;
  end;
end;

procedure TEQPrForm.PresetsBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LoadPr;
  if (Key = VK_RETURN) then
  begin
    ModalResult := mrOK;
  end;
end;

procedure TEQPrForm.PresetsBoxClick(Sender: TObject);
begin
  LoadPr;
end;

procedure TEQPrForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ShowingEQPr := false;
  Action := caFree;
end;

procedure TEQPrForm.CancelPrBtnClick(Sender: TObject);
begin
  EQData := OldEQData;
  EQPreAmp := OldPreAmp;
  EQForm.InitEQs;
  SetEQ;
  Close;
end;

end.
