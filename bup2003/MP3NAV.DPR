program mp3nav;
(***********************************
 * MP3 NaviGatoR v2.9              *
 *                                 *
 * (c) 2000-2003 NiKe'Soft         *
 ***********************************)
uses
  Forms, Dialogs,
  Main in 'Main.pas' {MainForm},
  Options in 'Options.pas' {OptionsForm},
  About in 'About.PAS' {AboutBox},
  edUnit in 'edUnit.pas' {edForm},
  StatUnit in 'StatUnit.pas' {StatusForm},
  gEdUnit in 'gEdUnit.pas' {gEdForm},
  MaskAsk in 'MaskAsk.pas' {MAskForm},
  SrchUnit in 'SrchUnit.pas' {QueryForm},
  uProgres in 'uProgres.pas' {ProgressForm},
  EQUnit in 'EQUnit.pas' {EQForm},
  EQPrUnit in 'EQPrUnit.pas' {EQPrForm},
  MaskHlpUnit in 'MaskHlpUnit.pas' {MaskRulesForm},
  SaveEQPrUnit in 'SaveEQPrUnit.pas' {SaveEQPrForm},
  DelEQPrUnit in 'DelEQPrUnit.pas' {DelEQPrForm},
  ReqLyrUnit in 'ReqLyrUnit.pas' {ReqLyrForm};

{$R *.RES}

begin
  Application.Initialize;
{$IFDEF _DEMO_}
//  MessageDlg('� ��� ����-������ ���������, ���������� �������� �������� ������ � ������ ������, ������� �� ������ ���������� �� ������ '#13#13'http://cjnike.h1.ru',mtWarning,[mbok],0);

  InputBox('MP3 NaviGatoR - ����',
           '� ��� ����-������ ���������!'#13+
           '* � ����-������ �� ����������� ���������'#13+
           '* � ����-������ �������� ������ ������ 25 ������'#13+
           '��� ��� � ������ ������ �������� ������ � ������ ������, ������� �� ������ �������� �� ������: '#13#13+
           'http://www.CJNiKe.h1.ru'#13#13+
           '��������������� ��� ���������:',
           '7823648362468');
{$ENDIF}
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEQForm, EQForm);
  Application.Run;
end.
