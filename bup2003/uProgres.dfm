object ProgressForm: TProgressForm
  Left = 301
  Top = 218
  BorderStyle = bsToolWindow
  Caption = 'Прогресс'
  ClientHeight = 78
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressGauge: TGauge
    Left = 0
    Top = 0
    Width = 250
    Height = 50
    ForeColor = clBlue
    Progress = 50
  end
  object CancelBtn: TButton
    Left = 174
    Top = 52
    Width = 75
    Height = 25
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 0
    OnClick = CancelBtnClick
  end
end
