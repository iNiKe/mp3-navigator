object StatusForm: TStatusForm
  Left = 299
  Top = 180
  BorderStyle = bsToolWindow
  Caption = #1057#1090#1072#1090#1091#1089
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
  object Label2: TLabel
    Left = 0
    Top = 40
    Width = 80
    Height = 13
    Caption = #1058#1077#1082#1091#1097#1077#1077' '#1080#1084#1103
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
    Caption = #1092#1072#1081#1083#1086#1074' : '
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
    Caption = #1042#1089#1077#1075#1086' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1081' : '
  end
  object ProgGauge: TGauge
    Left = 0
    Top = 0
    Width = 299
    Height = 39
    Progress = 0
    Visible = False
  end
  object NameEdit: TEdit
    Left = 0
    Top = 56
    Width = 299
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
  object CancelBtn: TButton
    Left = 222
    Top = 83
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&'#1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 1
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
