object edForm: TedForm
  Left = 190
  Top = 114
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' TAG-'#1086#1074
  ClientHeight = 364
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnContextPopup = FormContextPopup
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressGauge: TGauge
    Left = 1
    Top = 323
    Width = 471
    Height = 13
    ForeColor = clBlue
    Progress = 0
    Visible = False
  end
  object TimeLabel: TLabel
    Left = 431
    Top = 5
    Width = 43
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '10:20'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PageControl: TPageControl
    Left = 0
    Top = 24
    Width = 473
    Height = 297
    ActivePage = ID3v1andDIDSheet
    TabOrder = 0
    object ID3v1andDIDSheet: TTabSheet
      Caption = 'ID3v1 && DID Tags'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      object Label1: TLabel
        Left = 0
        Top = 24
        Width = 79
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 0
        Top = 64
        Width = 59
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 0
        Top = 104
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
      object Label4: TLabel
        Left = 0
        Top = 144
        Width = 34
        Height = 13
        Caption = #1046#1072#1085#1088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 0
        Top = 224
        Width = 22
        Height = 13
        Caption = #1043#1086#1076
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 40
        Top = 224
        Width = 30
        Height = 13
        Caption = #1058#1088#1101#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CommentLabel: TLabel
        Left = 0
        Top = 184
        Width = 82
        Height = 13
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dLabel1: TLabel
        Left = 234
        Top = 24
        Width = 79
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dLabel2: TLabel
        Left = 234
        Top = 64
        Width = 59
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dLabel3: TLabel
        Left = 234
        Top = 104
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
      object dLabel4: TLabel
        Left = 234
        Top = 144
        Width = 34
        Height = 13
        Caption = #1046#1072#1085#1088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dLabel5: TLabel
        Left = 431
        Top = 104
        Width = 22
        Height = 13
        Caption = #1043#1086#1076
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dCommentLabel: TLabel
        Left = 234
        Top = 184
        Width = 82
        Height = 13
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 232
        Top = 224
        Width = 75
        Height = 13
        Caption = #1054#1094#1080#1092#1088#1086#1074#1072#1085#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 350
        Top = 224
        Width = 108
        Height = 13
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072'-'#1082#1086#1076#1077#1088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ID3v1EnabledBox: TCheckBox
        Tag = 15
        Left = 0
        Top = 4
        Width = 105
        Height = 17
        Caption = 'ID3v&1 Tag'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = ID3v1EnabledBoxClick
      end
      object ArtistEdit: TEdit
        Tag = 1
        Left = 0
        Top = 40
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 1
      end
      object TitleEdit: TEdit
        Tag = 2
        Left = 0
        Top = 80
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 2
      end
      object AlbumEdit: TEdit
        Tag = 3
        Left = 0
        Top = 120
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 3
      end
      object YearEdit: TEdit
        Tag = 6
        Left = 0
        Top = 240
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 4
        ParentFont = False
        TabOrder = 6
      end
      object TrackEdit: TEdit
        Tag = 7
        Left = 40
        Top = 240
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 3
        ParentFont = False
        TabOrder = 7
      end
      object CommentEdit: TEdit
        Tag = 5
        Left = 0
        Top = 200
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 5
      end
      object DIDEnabledBox: TCheckBox
        Tag = 16
        Left = 234
        Top = 2
        Width = 97
        Height = 17
        Caption = 'DID &Tag'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        OnClick = DIDEnabledBoxClick
      end
      object dArtistEdit: TEdit
        Tag = 8
        Left = 234
        Top = 40
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 9
      end
      object dTitleEdit: TEdit
        Tag = 9
        Left = 234
        Top = 80
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 10
      end
      object dAlbumEdit: TEdit
        Tag = 10
        Left = 234
        Top = 120
        Width = 194
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 11
      end
      object dYearEdit: TEdit
        Tag = 13
        Left = 431
        Top = 120
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 4
        ParentFont = False
        TabOrder = 12
      end
      object dCommentEdit: TEdit
        Tag = 12
        Left = 234
        Top = 200
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 14
      end
      object dEncodedByEdit: TEdit
        Left = 234
        Top = 240
        Width = 115
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 15
      end
      object dEncSoftEdit: TEdit
        Left = 350
        Top = 240
        Width = 115
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 16
      end
      object GenreBox: TComboBox
        Tag = 1
        Left = 0
        Top = 160
        Width = 230
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 4
      end
      object dGenreBox: TComboBox
        Tag = 2
        Left = 234
        Top = 160
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        MaxLength = 255
        ParentFont = False
        Sorted = True
        TabOrder = 13
      end
      object Button2: TButton
        Left = 174
        Top = 238
        Width = 55
        Height = 25
        Caption = #1059#1075#1072#1076#1072#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 17
        OnClick = Button2Click
      end
    end
    object ID3v2Sheet: TTabSheet
      Caption = 'ID3v2 Tag'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object iLabel1: TLabel
        Left = 0
        Top = 24
        Width = 79
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object iLabel2: TLabel
        Left = 0
        Top = 64
        Width = 59
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object iLabel3: TLabel
        Left = 0
        Top = 104
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
      object iLabel4: TLabel
        Left = 0
        Top = 144
        Width = 34
        Height = 13
        Caption = #1046#1072#1085#1088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object iLabel5: TLabel
        Left = 0
        Top = 224
        Width = 22
        Height = 13
        Caption = #1043#1086#1076
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object iLabel6: TLabel
        Left = 40
        Top = 224
        Width = 30
        Height = 13
        Caption = #1058#1088#1101#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object iCommentLabel: TLabel
        Left = 234
        Top = 144
        Width = 82
        Height = 13
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 0
        Top = 184
        Width = 135
        Height = 13
        Caption = 'URL ('#1040#1076#1088#1077#1089' '#1074' InterNet)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 234
        Top = 64
        Width = 73
        Height = 13
        Caption = #1050#1086#1084#1087#1086#1079#1080#1090#1086#1088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 234
        Top = 24
        Width = 182
        Height = 13
        Caption = #1055#1077#1088#1074#1086#1085#1072#1095#1072#1083#1100#1085#1099#1081' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 234
        Top = 104
        Width = 75
        Height = 13
        Caption = #1054#1094#1080#1092#1088#1086#1074#1072#1085#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 157
        Top = 5
        Width = 73
        Height = 13
        Caption = 'CopyRight '#169
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ID3v2EnabledBox: TCheckBox
        Tag = 29
        Left = 0
        Top = 4
        Width = 105
        Height = 17
        Caption = 'ID3v&2 Tag'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = ID3v2EnabledBoxClick
      end
      object iArtistEdit: TEdit
        Tag = 17
        Left = 0
        Top = 40
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 1
      end
      object iTitleEdit: TEdit
        Tag = 18
        Left = 0
        Top = 80
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 2
      end
      object iAlbumEdit: TEdit
        Tag = 19
        Left = 0
        Top = 120
        Width = 230
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        PopupMenu = edPopUp
        TabOrder = 3
      end
      object iYearEdit: TEdit
        Tag = 22
        Left = 0
        Top = 240
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 4
        ParentFont = False
        TabOrder = 6
      end
      object iTrackEdit: TEdit
        Tag = 23
        Left = 40
        Top = 240
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 32
        ParentFont = False
        TabOrder = 7
      end
      object iCommentsMemo: TMemo
        Tag = 28
        Left = 234
        Top = 160
        Width = 230
        Height = 107
        ScrollBars = ssVertical
        TabOrder = 12
        OnKeyDown = iCommentsMemoKeyDown
      end
      object iURLEdit: TEdit
        Tag = 21
        Left = 0
        Top = 200
        Width = 230
        Height = 21
        PopupMenu = edPopUp
        TabOrder = 5
      end
      object iComposerEdit: TEdit
        Tag = 26
        Left = 234
        Top = 80
        Width = 230
        Height = 21
        PopupMenu = edPopUp
        TabOrder = 10
      end
      object iOrigArtistEdit: TEdit
        Tag = 25
        Left = 234
        Top = 40
        Width = 230
        Height = 21
        PopupMenu = edPopUp
        TabOrder = 9
      end
      object iEncodedByEdit: TEdit
        Tag = 27
        Left = 234
        Top = 120
        Width = 230
        Height = 21
        PopupMenu = edPopUp
        TabOrder = 11
      end
      object iCopyRightEdit: TEdit
        Tag = 24
        Left = 234
        Top = 1
        Width = 230
        Height = 21
        PopupMenu = edPopUp
        TabOrder = 8
      end
      object AdvTagEditBtn: TButton
        Left = 77
        Top = 238
        Width = 93
        Height = 25
        Hint = #1044#1086#1089#1090#1091#1087#1085#1086' '#1074' Pro-'#1074#1077#1088#1089#1080#1080
        Caption = 'ID3v2 '#1056#1077#1076#1072#1082#1090#1086#1088
        Enabled = False
        TabOrder = 13
      end
      object iGenreBox: TComboBox
        Tag = 3
        Left = 0
        Top = 160
        Width = 230
        Height = 21
        ItemHeight = 0
        Sorted = True
        TabOrder = 4
      end
      object Button4: TButton
        Left = 174
        Top = 238
        Width = 55
        Height = 25
        Caption = #1059#1075#1072#1076#1072#1090#1100
        TabOrder = 14
        OnClick = Button4Click
      end
    end
    object InfoSheet: TTabSheet
      Caption = 'MPEG'
      ImageIndex = 3
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 241
        Height = 265
        Caption = ' MPEG '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '
        TabOrder = 0
        object InfoMemo: TMemo
          Left = 2
          Top = 15
          Width = 237
          Height = 248
          Align = alClient
          BorderStyle = bsNone
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
          OnKeyDown = InfoMemoKeyDown
        end
      end
      object Button1: TButton
        Left = 292
        Top = 240
        Width = 137
        Height = 25
        Hint = #1044#1086#1089#1090#1091#1087#1085#1086' '#1074' Pro-'#1074#1077#1088#1089#1080#1080
        Caption = 'MP&EG '#1056#1077#1076#1072#1082#1090#1086#1088
        Enabled = False
        TabOrder = 1
      end
      object OptBegMPEGBox: TCheckBox
        Left = 250
        Top = 6
        Width = 183
        Height = 17
        Caption = #1054#1087#1090#1080#1084#1080#1079#1080#1088#1086#1074#1072#1090#1100' '#1053#1072#1095#1072#1083#1086' MPEG'
        TabOrder = 2
      end
    end
  end
  object NameEdit: TEdit
    Left = 0
    Top = 1
    Width = 430
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
  object SaveBtn: TButton
    Left = 1
    Top = 338
    Width = 115
    Height = 25
    Caption = '&'#1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = SaveBtnClick
  end
  object CancelBtn: TButton
    Left = 357
    Top = 338
    Width = 115
    Height = 25
    Cancel = True
    Caption = '&'#1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object ID3v1toID3v2Btn: TButton
    Left = 147
    Top = 338
    Width = 85
    Height = 25
    Caption = '&ID3v1 '#1074' ID3v2'
    TabOrder = 4
    OnClick = ID3v1toID3v2BtnClick
  end
  object ID3v2toID3v1Btn: TButton
    Left = 235
    Top = 338
    Width = 85
    Height = 25
    Caption = 'I&D3v2 '#1074' ID3v1'
    TabOrder = 5
    OnClick = ID3v2toID3v1BtnClick
  end
  object edPopUp: TPopupMenu
    OnPopup = edPopUpPopup
    Left = 440
    Top = 24
    object N3: TMenuItem
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      OnClick = N6Click
    end
    object N7: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = N7Click
    end
    object N5: TMenuItem
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      OnClick = N5Click
    end
    object N8: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N8Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = N10Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object UPCASE1: TMenuItem
      Caption = #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045
      OnClick = UPCASE1Click
    end
    object downcase1: TMenuItem
      Caption = #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
      OnClick = downcase1Click
    end
    object N1: TMenuItem
      Caption = #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1072#1103
      OnClick = N1Click
    end
  end
end
