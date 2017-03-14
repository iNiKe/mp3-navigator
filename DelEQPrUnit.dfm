object DelEQPrForm: TDelEQPrForm
  Left = 419
  Top = 179
  BorderStyle = bsDialog
  Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1069#1050'-'#1091#1089#1090#1072#1085#1074#1086#1082
  ClientHeight = 245
  ClientWidth = 193
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
  object PresetsBox: TListBox
    Left = 0
    Top = 0
    Width = 193
    Height = 217
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnKeyDown = PresetsBoxKeyDown
  end
  object DelBtn: TButton
    Left = 0
    Top = 220
    Width = 81
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 1
    OnClick = DelBtnClick
  end
  object CancelBtn: TButton
    Left = 112
    Top = 220
    Width = 81
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 2
  end
  object Button1: TButton
    Left = 84
    Top = 221
    Width = 25
    Height = 23
    Caption = '&R'
    TabOrder = 3
    OnClick = Button1Click
  end
end
