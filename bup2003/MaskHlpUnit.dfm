object MaskRulesForm: TMaskRulesForm
  Left = 291
  Top = 141
  Width = 316
  Height = 331
  BorderStyle = bsSizeToolWin
  Caption = 'Правила построения маски'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 232
    Top = 279
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object MaskHelpMemo: TMemo
    Left = 0
    Top = 0
    Width = 306
    Height = 276
    Color = clBtnFace
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
