object MAskForm: TMAskForm
  Left = 241
  Top = 284
  BorderStyle = bsToolWindow
  Caption = 'Выберите маску имени'
  ClientHeight = 177
  ClientWidth = 241
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
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 39
    Height = 13
    Caption = 'Маска'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object MaskEdit: TEdit
    Left = 64
    Top = 5
    Width = 174
    Height = 21
    TabOrder = 7
  end
  object RadioButton1: TRadioButton
    Left = 3
    Top = 39
    Width = 113
    Height = 17
    Caption = '&0  Текущая'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnEnter = RadioButton1Enter
  end
  object RadioButton2: TRadioButton
    Left = 3
    Top = 56
    Width = 86
    Height = 17
    Caption = '&1  Artist - Title'
    TabOrder = 1
    OnEnter = RadioButton2Enter
  end
  object RadioButton3: TRadioButton
    Left = 3
    Top = 72
    Width = 110
    Height = 17
    Caption = '&2  01. Title'
    TabOrder = 2
    OnEnter = RadioButton3Enter
  end
  object Button1: TButton
    Left = 1
    Top = 152
    Width = 160
    Height = 25
    Caption = '&Да'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object Button2: TButton
    Left = 166
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Отмена'
    ModalResult = 2
    TabOrder = 6
  end
  object RadioButton4: TRadioButton
    Left = 3
    Top = 88
    Width = 113
    Height = 17
    Caption = '&3  01 - Title'
    TabOrder = 3
    OnEnter = RadioButton4Enter
  end
  object RadioButton5: TRadioButton
    Left = 3
    Top = 104
    Width = 166
    Height = 17
    Caption = '&4  (Artist-Album(Year)-Title'
    TabOrder = 4
    OnEnter = RadioButton5Enter
  end
  object NoMoreAskBox: TCheckBox
    Left = 4
    Top = 128
    Width = 181
    Height = 17
    Caption = 'Больше не запрашивать'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
  end
end
