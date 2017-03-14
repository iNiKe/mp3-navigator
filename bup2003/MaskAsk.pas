unit MaskAsk;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMAskForm = class(TForm)
    MaskEdit: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    NoMoreAskBox: TCheckBox;
    procedure RadioButton1Enter(Sender: TObject);
    procedure RadioButton2Enter(Sender: TObject);
    procedure RadioButton3Enter(Sender: TObject);
    procedure RadioButton4Enter(Sender: TObject);
    procedure RadioButton5Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MAskForm: TMAskForm;

function AskMask : string;

implementation uses main;

function AskMask : string;
begin
  AskMask := '';
  with TMAskForm.Create(Application) do
  try
    if ShowModal = mrOK then
    begin
      AskMask := MaskEdit.Text;
      AskFileMask := not NoMoreAskBox.Checked;
      FileNameMask := MaskEdit.Text;
    end else AskMask := '';
   finally
    Free;
  end;
end;

{$R *.DFM}

procedure TMAskForm.RadioButton1Enter(Sender: TObject);
begin
  MaskEdit.Text := FileNameMask;
end;

procedure TMAskForm.RadioButton2Enter(Sender: TObject);
begin
  MaskEdit.Text := '%A% - %T%';
end;

procedure TMAskForm.RadioButton3Enter(Sender: TObject);
begin
  MaskEdit.Text := '%TR,R,2,0%. %T%';
end;

procedure TMAskForm.RadioButton4Enter(Sender: TObject);
begin
  MaskEdit.Text := '%TR,R,2,0% - %T%';
end;

procedure TMAskForm.RadioButton5Enter(Sender: TObject);
begin
  MaskEdit.Text := '(%A%-%ALB%(%Y%)-%T%';
end;

procedure TMAskForm.FormCreate(Sender: TObject);
begin
  NoMoreAskBox.Checked := not AskFileMask;
end;

end.
