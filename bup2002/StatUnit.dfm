object StatusForm: TStatusForm
  Left = 299
  Top = 180
  BorderStyle = bsToolWindow
  Caption = 'Статус'
  ClientHeight = 110
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 126
    Height = 13
    Caption = 'Текущая директория'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 0
    Top = 40
    Width = 87
    Height = 13
    Caption = 'Текущий файл'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 55
    Top = 95
    Width = 47
    Height = 13
    Caption = 'файлов : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object DirCntLabel: TLabel
    Left = 102
    Top = 81
    Width = 36
    Height = 13
    Caption = '00000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object FileCntLabel: TLabel
    Left = 102
    Top = 96
    Width = 36
    Height = 13
    Caption = '00000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 1
    Top = 80
    Width = 101
    Height = 13
    Caption = 'Всего директорий : '
  end
  object PathEdit: TEdit
    Left = 0
    Top = 16
    Width = 297
    Height = 21
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object NameEdit: TEdit
    Left = 0
    Top = 56
    Width = 297
    Height = 21
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 222
    Top = 83
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Отменить'
    ModalResult = 2
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object DoneTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = DoneTimerTimer
    Left = 192
    Top = 80
  end
end
