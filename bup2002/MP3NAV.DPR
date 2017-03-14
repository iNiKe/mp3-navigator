program mp3nav;
(***********************************
 * MP3 NaviGatoR v2.5              *
 *                                 *
 * (c) 2000-2002 NiKe'Soft         *
 ***********************************)
uses
  Forms,
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
  Application.Title := 'MP3 NaviGatoR v2.7';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEQForm, EQForm);
  Application.Run;
end.
