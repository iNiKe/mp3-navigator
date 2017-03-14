unit uProgres;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls;

type
  TProgressForm = class(TForm)
    ProgressGauge: TGauge;
    CancelBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProgressForm: TProgressForm;
  prStop : boolean = false;

implementation

{$R *.DFM}

procedure TProgressForm.CancelBtnClick(Sender: TObject);
begin
  prStop := true;
end;

procedure TProgressForm.FormCreate(Sender: TObject);
begin
  prStop := false;
  ProgressGauge.MaxValue := 100;
end;

procedure TProgressForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  prStop := true;
end;

end.
