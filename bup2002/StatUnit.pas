unit StatUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const acNone     = 0;
      acAddDirs  = 1;
      acAddFiles = 2;

type
  TStatusForm = class(TForm)
    Label1: TLabel;
    PathEdit: TEdit;
    NameEdit: TEdit;
    Label2: TLabel;
    CancelBtn: TButton;
    Label4: TLabel;
    DirCntLabel: TLabel;
    FileCntLabel: TLabel;
    Label5: TLabel;
    DoneTimer: TTimer;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DoneTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateLabels;
  end;

var StatusForm : tStatusForm;
    Act   : integer;
    td,tf : integer;

  implementation

uses Main;

procedure tStatusForm.UpdateLabels;
begin
  DirCntLabel.Caption  := inttostr(td);
  FileCntLabel.Caption := inttostr(tf);
end;

{$R *.DFM}

procedure TStatusForm.CancelBtnClick(Sender: TObject);
begin
  StopProc := true;
end;

procedure TStatusForm.FormActivate(Sender: TObject);
begin
  if Act = acAddDirs then
  begin
    Act := acNone;
    StopProc := False;
    td := 0;
    tf := 0;
    Main.AddDir(MainForm.OpenFolderDlg.SelectedPathName,-1);
  end;
  CancelBtn.Caption := '&OK';
  CancelBtn.SetFocus;
  CancelBtn.ModalResult := mrOK;
  DoneTimer.Enabled := true;
  Application.ProcessMessages;
end;

procedure TStatusForm.DoneTimerTimer(Sender: TObject);
begin
  DoneTimer.Enabled := false;
  StatusForm.CancelBtn.Click;
end;

end.
