object DMGForm: TDMGForm
  Left = 237
  Top = 189
  BorderStyle = bsDialog
  Caption = #1042#1085#1080#1084#1072#1085#1080#1077'! '#1042#1099' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1077' '#1044#1077#1084#1086'-'#1074#1077#1088#1089#1080#1102' '#1087#1088#1086#1075#1088#1072#1084#1084#1099'!'
  ClientHeight = 247
  ClientWidth = 396
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
    Left = 4
    Top = 163
    Width = 240
    Height = 13
    Caption = #1048#1050#1055' ('#1048#1089#1090#1072#1083#1083#1103#1094#1080#1086#1085#1085#1099#1081' '#1050#1086#1076' '#1055#1088#1086#1075#1088#1072#1084#1084#1099')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 3
    Top = 205
    Width = 89
    Height = 13
    Caption = #1050#1086#1076' '#1072#1082#1090#1080#1074#1072#1094#1080#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Readit: TEdit
    Left = 3
    Top = 179
    Width = 249
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 3
    Top = 221
    Width = 249
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 280
    Top = 216
    Width = 115
    Height = 28
    Caption = #1040#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 279
    Top = 184
    Width = 116
    Height = 25
    Caption = #1044#1045#1052#1054'-'#1074#1077#1088#1089#1080#1103
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 0
    Top = 8
    Width = 393
    Height = 105
    Alignment = taCenter
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'MP3 NaviGatoR - '#1044#1077#1084#1086
      #1059' '#1042#1072#1089' '#1044#1077#1084#1086'-'#1074#1077#1088#1089#1080#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099'!'
      '* '#1042' '#1076#1077#1084#1086'-'#1074#1077#1088#1089#1080#1080' '#1085#1077' '#1089#1086#1093#1088#1072#1085#1103#1102#1090#1089#1103' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      '* '#1074' '#1087#1083#1077#1081'-'#1083#1080#1089#1090#1072#1093' '#1076#1086#1089#1090#1091#1087#1085#1099' '#1090#1086#1083#1100#1082#1086' '#1087#1077#1088#1074#1099#1077' 25 '#1092#1072#1081#1083#1086#1074
      '* '#1073#1072#1079#1072' '#1076#1072#1085#1085#1099#1093' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1072
      ''
      
        #1042#1089#1077' '#1101#1090#1086' '#1080' '#1084#1085#1086#1075#1086#1077' '#1076#1088#1091#1075#1086#1077' '#1076#1086#1089#1090#1091#1087#1085#1086' '#1090#1086#1083#1100#1082#1086' '#1074' '#1055#1054#1051#1053#1054#1049' '#1074#1077#1088#1089#1080#1080', '#1082#1086#1090#1086#1088#1091#1102 +
        ' '#1042#1099' '
      #1084#1086#1078#1077#1090#1077' '#1079#1072#1082#1072#1079#1072#1090#1100' '#1087#1086' '#1072#1076#1088#1077#1089#1091':')
    TabOrder = 4
  end
  object Button3: TButton
    Left = 279
    Top = 144
    Width = 115
    Height = 33
    Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100' !'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 147
    Top = 116
    Width = 121
    Height = 25
    Caption = 'www.NiKeSoft.ru'
    TabOrder = 6
    OnClick = Button4Click
  end
end
