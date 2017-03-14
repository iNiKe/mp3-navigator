program mp3nav;
(***********************************
 * MP3 NaviGatoR v2.9x             *
 *                                 *
 * (c) 2000-2003 NiKe'Soft         *
 ***********************************)
uses
  Forms,
  Dialogs,
  Sysutils,
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
  ReqLyrUnit in 'ReqLyrUnit.pas' {ReqLyrForm},
  demo in 'demo.pas' {DMGForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEQForm, EQForm);
  Application.CreateForm(TDMGForm, DMGForm);
  {$IFDEF _DEMO_}
//  MessageDlg('У Вас Демо-версия программы, сохранение настроек доступно только в полной версии, которую вы можете приобрести по адресу '#13#13'http://www.NiKeSoft.ru',mtWarning,[mbok],0);

  DMGForm.ShowModal;
{$ENDIF}
  Application.Run;
end.
