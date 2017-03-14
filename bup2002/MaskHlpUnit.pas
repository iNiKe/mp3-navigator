unit MaskHlpUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMaskRulesForm = class(TForm)
    OKBtn: TButton;
    MaskHelpMemo: TMemo;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MaskRulesForm: TMaskRulesForm;

procedure ShowMaskHlp;

  implementation uses MPGTools;

{$R *.DFM}

procedure ShowMaskHlp;
begin
  with TMaskRulesForm.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMaskRulesForm.FormResize(Sender: TObject);
begin
  MaskHelpMemo.Width := ClientWidth - 0;
  MaskHelpMemo.Height := ClientHeight - 2 - OKBtn.Height;
  OKBtn.Left := ClientWidth - OKBtn.Width - 0;
  OKBtn.Top := ClientHeight - OKBtn.Height - 0;
end;

procedure TMaskRulesForm.FormCreate(Sender: TObject);
var i : integer;
begin
  with MaskHelpMemo.Lines do
  begin
    Clear;
    Add('%<IDполя>[,<ВыравниваниеL/R>][,<Длина>][,<ЗаполняющийСимвол>]%');
    Add(' Например: %FNS,L,12, % - получится короткое (DOS) имя,');
    Add(' дополненное пробелами справа до длины в 12 символов');
    Add('-------------------------------------------------------------------');
    Add('*** ID полей :');
    Add('');
    for i := 0 to Macros.Count-1 do
     if (Macros.Items[i].ShortName<>'' )
     and(Macros.Items[i].ShortName[1]<>' ')
     and(Macros.Items[i].ValueProc<>nil) then
     MaskHelpMemo.lines.Add(PadLeft(macros.items[i].ShortName,5,' ')+#9#9+macros.Items[i].Description);
  end;
end;

end.
