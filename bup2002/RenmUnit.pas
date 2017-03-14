unit RenmUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TRenameForm = class(TForm)
    RenBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    NameEdit: TEdit;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure RenBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RenameForm: TRenameForm;

procedure RenameFiles;

implementation uses Main;

{$R *.DFM}

procedure RenameFiles;
begin

end;

procedure TRenameForm.FormCreate(Sender: TObject);
begin
  NameEdit.Text := FileNameMask;
end;

procedure TRenameForm.RenBtnClick(Sender: TObject);
begin
  if length(NameEdit.Text) > 2 then
  begin
    FileNameMask := NameEdit.Text;
  end;
end;

end.
