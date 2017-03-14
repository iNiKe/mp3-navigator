unit demo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TDMGForm = class(TForm)
    Readit: TEdit;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMGForm: TDMGForm;

implementation uses main,options,shellapi;      

{$R *.dfm}

procedure TDMGForm.FormCreate(Sender: TObject);
begin
  Readit.Text := SerialNum;
end;

procedure TDMGForm.Button1Click(Sender: TObject);
begin
{$IFDEF _DEMO_}
  MessageDlg('Код Активации НЕ Верен! Попробуйте еще раз...',mtError,[mbOK],0);
{$ELSE}

{$ENDIF}

end;

procedure TDMGForm.Button3Click(Sender: TObject);
begin
  ShellExecute(0,'open',pchar(basepath+'docs\register.html'),nil,nil,SW_SHOWNORMAL);
end;

procedure TDMGForm.Button4Click(Sender: TObject);
begin
  ShellExecute(0,'open',pchar('http://www.NiKeSoft.ru'),nil,nil,SW_SHOWNORMAL);
end;

end.
