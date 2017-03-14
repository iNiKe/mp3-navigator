object SaveEQPrForm: TSaveEQPrForm
  Left = 420
  Top = 189
  BorderStyle = bsDialog
  Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1069#1050'-'#1091#1089#1090#1072#1085#1086#1074#1082#1091
  ClientHeight = 249
  ClientWidth = 195
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SaveBtn: TButton
    Left = 1
    Top = 223
    Width = 97
    Height = 25
    Caption = '&'#1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = SaveBtnClick
  end
  object CancelBtn: TButton
    Left = 103
    Top = 223
    Width = 91
    Height = 25
    Cancel = True
    Caption = '&'#1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object PresetsBox: TComboBox
    Left = 0
    Top = 0
    Width = 194
    Height = 224
    Style = csSimple
    BiDiMode = bdLeftToRight
    ItemHeight = 13
    ParentBiDiMode = False
    Sorted = True
    TabOrder = 0
    OnKeyDown = PresetsBoxKeyDown
  end
end
