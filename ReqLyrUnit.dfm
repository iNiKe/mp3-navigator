object ReqLyrForm: TReqLyrForm
  Left = 260
  Top = 109
  Width = 576
  Height = 516
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
  PixelsPerInch = 96
  TextHeight = 13
  object sb: TStatusBar
    Left = 0
    Top = 470
    Width = 568
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 568
    Height = 470
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1047#1072#1087#1088#1086#1089' '#1090#1077#1082#1089#1090#1072
      DesignSize = (
        560
        442)
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
        TabOrder = 1
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
        TabOrder = 7
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
        TabOrder = 0
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
        TabOrder = 2
        OnClick = AlbumBoxClick
      end
      object AlbumEdit: TEdit
        Left = 80
        Top = 32
        Width = 185
        Height = 21
        TabOrder = 3
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
        TabOrder = 6
        OnClick = LyrBoxClick
      end
      object LyrEdit: TRichEdit
        Left = 272
        Top = 72
        Width = 282
        Height = 366
        Anchors = [akLeft, akTop, akRight, akBottom]
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
        TabOrder = 14
        WordWrap = False
      end
      object SongsBox: TComboBox
        Left = 0
        Top = 216
        Width = 265
        Height = 227
        Style = csSimple
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 0
        TabOrder = 11
        Text = 'SongsBox'
        OnSelect = SongsBoxSelect
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
        TabOrder = 8
        OnClick = ReqBtnClick
        OnKeyDown = ReqBtnKeyDown
        OnKeyUp = ReqBtnKeyUp
      end
      object Button3: TButton
        Left = 0
        Top = 184
        Width = 75
        Height = 25
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1080#1090#1100
        ModalResult = 2
        TabOrder = 10
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
        TabOrder = 4
        OnClick = SongBoxClick
      end
      object SongTitleEdit: TEdit
        Left = 80
        Top = 56
        Width = 185
        Height = 21
        TabOrder = 5
        Text = 'SongTitleEdit'
      end
      object tBandEdit: TEdit
        Left = 328
        Top = 8
        Width = 201
        Height = 21
        ReadOnly = True
        TabOrder = 12
        Text = 'tBandEdit'
      end
      object tAlbumEdit: TEdit
        Left = 328
        Top = 32
        Width = 201
        Height = 21
        ReadOnly = True
        TabOrder = 13
        Text = 'tAlbumEdit'
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1053#1072#1074#1080#1075#1072#1094#1080#1103' '#1087#1086' '#1073#1072#1079#1077
      ImageIndex = 1
      DesignSize = (
        560
        442)
      object Label4: TLabel
        Left = 8
        Top = 3
        Width = 50
        Height = 13
        Caption = #1056#1091#1089#1089#1082#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 7
        Top = 114
        Width = 75
        Height = 13
        Caption = #1047#1072#1088#1091#1073#1077#1078#1085#1099#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 290
        Top = 4
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
      object Label7: TLabel
        Left = 9
        Top = 208
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
      object Label8: TLabel
        Left = 139
        Top = 3
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
      object Label9: TLabel
        Left = 139
        Top = 208
        Width = 38
        Height = 13
        Caption = #1055#1077#1089#1085#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object enchars: TStringGrid
        Left = 4
        Top = 130
        Width = 122
        Height = 71
        ColCount = 7
        DefaultColWidth = 16
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 4
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ScrollBars = ssNone
        TabOrder = 0
        OnSelectCell = encharsSelectCell
      end
      object ruchars: TStringGrid
        Left = 4
        Top = 19
        Width = 122
        Height = 88
        ColCount = 7
        DefaultColWidth = 16
        DefaultRowHeight = 16
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ScrollBars = ssNone
        TabOrder = 1
        OnSelectCell = rucharsSelectCell
      end
      object TextMemo: TMemo
        Left = 288
        Top = 19
        Width = 269
        Height = 419
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object SongsLBox: TComboBox
        Left = 136
        Top = 224
        Width = 145
        Height = 218
        Style = csSimple
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 3
        OnSelect = SongsLBoxSelect
      end
      object BandsLBox: TComboBox
        Left = 136
        Top = 18
        Width = 145
        Height = 185
        Style = csSimple
        ItemHeight = 13
        TabOrder = 4
        OnSelect = BandsLBoxSelect
      end
      object AlbumsLBox: TComboBox
        Left = 0
        Top = 224
        Width = 129
        Height = 216
        Style = csSimple
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 5
        OnSelect = AlbumsLBoxSelect
      end
    end
  end
  object MusCon: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\db\music.mdb;Per' +
      'sist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 488
  end
  object musds: TADODataSet
    Connection = MusCon
    Parameters = <>
    Left = 520
  end
end
