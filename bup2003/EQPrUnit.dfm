object EQPrForm: TEQPrForm
  Left = 120
  Top = 160
  BorderStyle = bsToolWindow
  Caption = 'Выберите ЭК-установку'
  ClientHeight = 249
  ClientWidth = 196
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
  object Label1: TLabel
    Left = 144
    Top = 232
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object PresetsBox: TListBox
    Left = 0
    Top = 0
    Width = 196
    Height = 220
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnClick = PresetsBoxClick
    OnKeyDown = PresetsBoxKeyDown
  end
  object LoadPrBtn: TButton
    Left = 0
    Top = 224
    Width = 81
    Height = 25
    Caption = '&Загрузить'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = LoadPrBtnClick
  end
  object CancelPrBtn: TButton
    Left = 112
    Top = 224
    Width = 84
    Height = 25
    Cancel = True
    Caption = '&Отменить'
    ModalResult = 2
    TabOrder = 2
    OnClick = CancelPrBtnClick
  end
  object RefreshPrBtn: TButton
    Left = 84
    Top = 224
    Width = 25
    Height = 25
    Caption = '&R'
    TabOrder = 3
    OnClick = RefreshPrBtnClick
  end
end
