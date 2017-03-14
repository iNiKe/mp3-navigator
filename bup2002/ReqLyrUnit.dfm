object ReqLyrForm: TReqLyrForm
  Left = 168
  Top = 133
  Width = 555
  Height = 395
  Caption = #1047#1072#1087#1088#1086#1089' '#1090#1077#1082#1089#1090#1072
  Color = clBtnFace
  Constraints.MinHeight = 395
  Constraints.MinWidth = 555
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 272
    Top = 8
    Width = 42
    Height = 13
    Caption = #1043#1088#1091#1087#1087#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 272
    Top = 32
    Width = 46
    Height = 13
    Caption = #1040#1083#1100#1073#1086#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 272
    Top = 56
    Width = 36
    Height = 13
    Caption = #1058#1077#1082#1089#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object BandEdit: TEdit
    Left = 80
    Top = 8
    Width = 185
    Height = 21
    TabOrder = 0
    Text = 'BandEdit'
  end
  object ReqLyrMemo: TMemo
    Left = 80
    Top = 80
    Width = 185
    Height = 129
    Lines.Strings = (
      'ReqLyrMemo')
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object BandBox: TCheckBox
    Left = 0
    Top = 8
    Width = 65
    Height = 17
    Caption = #1043#1088#1091#1087#1087#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = BandBoxClick
  end
  object AlbumBox: TCheckBox
    Left = 0
    Top = 32
    Width = 73
    Height = 17
    Caption = #1040#1083#1100#1073#1086#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = AlbumBoxClick
  end
  object AlbumEdit: TEdit
    Left = 80
    Top = 32
    Width = 185
    Height = 21
    TabOrder = 4
    Text = 'AlbumEdit'
  end
  object LyrBox: TCheckBox
    Left = 0
    Top = 80
    Width = 57
    Height = 17
    Caption = #1058#1077#1082#1089#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = LyrBoxClick
  end
  object LyrEdit: TRichEdit
    Left = 272
    Top = 72
    Width = 273
    Height = 275
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'LyrEdit')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 6
    WordWrap = False
  end
  object SongsBox: TComboBox
    Left = 0
    Top = 216
    Width = 265
    Height = 131
    Style = csSimple
    ItemHeight = 13
    TabOrder = 7
    Text = 'SongsBox'
    OnSelect = SongsBoxSelect
  end
  object sb: TStatusBar
    Left = 0
    Top = 349
    Width = 547
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object Button1: TButton
    Left = 0
    Top = 152
    Width = 75
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 9
    OnClick = Button1Click
  end
  object ReqBtn: TButton
    Left = 0
    Top = 120
    Width = 75
    Height = 25
    Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100
    Default = True
    TabOrder = 10
    OnClick = ReqBtnClick
  end
  object Button3: TButton
    Left = 0
    Top = 184
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 11
    OnClick = Button3Click
  end
  object SongBox: TCheckBox
    Left = 0
    Top = 56
    Width = 65
    Height = 17
    Caption = #1055#1077#1089#1085#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    OnClick = SongBoxClick
  end
  object SongTitleEdit: TEdit
    Left = 80
    Top = 56
    Width = 185
    Height = 21
    TabOrder = 13
    Text = 'SongTitleEdit'
  end
  object tBandEdit: TEdit
    Left = 328
    Top = 8
    Width = 185
    Height = 21
    ReadOnly = True
    TabOrder = 14
    Text = 'tBandEdit'
  end
  object tAlbumEdit: TEdit
    Left = 328
    Top = 32
    Width = 185
    Height = 21
    ReadOnly = True
    TabOrder = 15
    Text = 'tAlbumEdit'
  end
  object MusCon: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\db\music.mdb;Per' +
      'sist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Top = 272
  end
  object musds: TADODataSet
    Connection = MusCon
    Parameters = <>
    Left = 32
    Top = 272
  end
end
