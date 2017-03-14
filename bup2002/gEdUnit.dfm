object gEdForm: TgEdForm
  Left = 276
  Top = 137
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1099' TAG-'#1086#1074
  ClientHeight = 306
  ClientWidth = 400
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
  object ProgressGauge: TGauge
    Left = 119
    Top = 260
    Width = 162
    Height = 25
    Color = clBtnFace
    ForeColor = clBlue
    ParentColor = False
    Progress = 0
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 400
    Height = 257
    ActivePage = ID3v1Sheet
    TabIndex = 0
    TabOrder = 0
    object ID3v1Sheet: TTabSheet
      Caption = 'ID3v1 Tag'
      object RemoveID3v1Box: TCheckBox
        Left = 0
        Top = 0
        Width = 65
        Height = 17
        Caption = '&'#1059#1076#1072#1083#1080#1090#1100
        TabOrder = 0
      end
      object ArtistEnBox: TCheckBox
        Left = 0
        Top = 23
        Width = 97
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        TabOrder = 1
        OnClick = ArtistEnBoxClick
      end
      object TitleEnBox: TCheckBox
        Left = 0
        Top = 47
        Width = 97
        Height = 17
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        TabOrder = 3
        OnClick = TitleEnBoxClick
      end
      object AlbumEnBox: TCheckBox
        Left = 0
        Top = 70
        Width = 97
        Height = 17
        Caption = #1040#1083#1100#1073#1086#1084
        TabOrder = 5
        OnClick = AlbumEnBoxClick
      end
      object YearEnBox: TCheckBox
        Left = 0
        Top = 94
        Width = 97
        Height = 17
        Caption = #1043#1086#1076
        TabOrder = 7
        OnClick = YearEnBoxClick
      end
      object GenreEnBox: TCheckBox
        Left = 0
        Top = 143
        Width = 97
        Height = 17
        Caption = #1046#1072#1085#1088
        TabOrder = 11
        OnClick = GenreEnBoxClick
      end
      object TrackEnBox: TCheckBox
        Left = 0
        Top = 118
        Width = 97
        Height = 17
        Caption = #1058#1088#1101#1082
        TabOrder = 9
        OnClick = TrackEnBoxClick
      end
      object GuessID3FromNameBox: TCheckBox
        Left = 80
        Top = 0
        Width = 153
        Height = 17
        Caption = #1059'&'#1075#1072#1076#1072#1090#1100' '#1080#1079' '#1080#1084#1077#1085#1080' '#1092#1072#1081#1083#1072
        TabOrder = 15
      end
      object CommentEnBox: TCheckBox
        Left = 0
        Top = 167
        Width = 97
        Height = 17
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        TabOrder = 13
        OnClick = CommentEnBoxClick
      end
      object CommentEdit: TEdit
        Left = 104
        Top = 165
        Width = 190
        Height = 21
        MaxLength = 30
        TabOrder = 14
      end
      object TrackEdit: TEdit
        Left = 104
        Top = 117
        Width = 40
        Height = 21
        MaxLength = 3
        TabOrder = 10
      end
      object AlbumEdit: TEdit
        Left = 104
        Top = 69
        Width = 190
        Height = 21
        MaxLength = 30
        TabOrder = 6
      end
      object TitleEdit: TEdit
        Left = 104
        Top = 45
        Width = 190
        Height = 21
        MaxLength = 30
        TabOrder = 4
      end
      object YearEdit: TEdit
        Left = 104
        Top = 93
        Width = 40
        Height = 21
        MaxLength = 4
        TabOrder = 8
      end
      object ArtistEdit: TEdit
        Left = 104
        Top = 21
        Width = 190
        Height = 21
        MaxLength = 30
        TabOrder = 2
      end
      object CopyFromID3v2tov1: TCheckBox
        Left = 248
        Top = 0
        Width = 129
        Height = 17
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1080#1079' ID3v2'
        TabOrder = 16
      end
      object GenreBox: TComboBox
        Left = 104
        Top = 141
        Width = 190
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        Sorted = True
        TabOrder = 12
      end
      object ExistID3v1Box: TCheckBox
        Left = 0
        Top = 212
        Width = 241
        Height = 17
        Caption = #1054#1073#1088#1072#1073#1072#1090#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1077#1089#1083#1080' '#1077#1089#1090#1100' ID3v1 '#1090#1072#1075
        TabOrder = 17
      end
      object T1BandCaseBox: TComboBox
        Left = 296
        Top = 21
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 18
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object T1TitleCaseBox: TComboBox
        Left = 296
        Top = 45
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 19
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object T1AlbumCaseBox: TComboBox
        Left = 296
        Top = 69
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 20
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object T1CommentCaseBox: TComboBox
        Left = 296
        Top = 165
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 21
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
    end
    object ID3v2Sheet: TTabSheet
      Caption = 'ID3v2 Tag'
      ImageIndex = 1
      object RemoveID3v2Box: TCheckBox
        Left = 0
        Top = 0
        Width = 97
        Height = 17
        Caption = '&'#1059#1076#1072#1083#1080#1090#1100
        TabOrder = 0
      end
      object IArtistEnBox: TCheckBox
        Left = 0
        Top = 23
        Width = 97
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        TabOrder = 1
        OnClick = IArtistEnBoxClick
      end
      object ITitleEnBox: TCheckBox
        Left = 0
        Top = 47
        Width = 97
        Height = 17
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        TabOrder = 3
        OnClick = ITitleEnBoxClick
      end
      object IAlbumEnBox: TCheckBox
        Left = 0
        Top = 70
        Width = 97
        Height = 17
        Caption = #1040#1083#1100#1073#1086#1084
        TabOrder = 5
        OnClick = IAlbumEnBoxClick
      end
      object IYearEnBox: TCheckBox
        Left = 0
        Top = 94
        Width = 97
        Height = 17
        Caption = #1043#1086#1076
        TabOrder = 7
        OnClick = IYearEnBoxClick
      end
      object ITrackEnBox: TCheckBox
        Left = 0
        Top = 118
        Width = 97
        Height = 17
        Caption = #1058#1088#1101#1082
        TabOrder = 9
        OnClick = ITrackEnBoxClick
      end
      object IGenreEnBox: TCheckBox
        Left = 0
        Top = 143
        Width = 97
        Height = 17
        Caption = #1046#1072#1085#1088
        TabOrder = 11
        OnClick = IGenreEnBoxClick
      end
      object ICommentsEnBox: TCheckBox
        Left = 0
        Top = 167
        Width = 97
        Height = 17
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080
        TabOrder = 13
        OnClick = ICommentsEnBoxClick
      end
      object IArtistEdit: TEdit
        Left = 104
        Top = 21
        Width = 190
        Height = 21
        TabOrder = 2
      end
      object ITitleEdit: TEdit
        Left = 104
        Top = 45
        Width = 190
        Height = 21
        TabOrder = 4
      end
      object IAlbumEdit: TEdit
        Left = 104
        Top = 69
        Width = 190
        Height = 21
        TabOrder = 6
      end
      object IYearEdit: TEdit
        Left = 104
        Top = 93
        Width = 40
        Height = 21
        TabOrder = 8
      end
      object ITrackEdit: TEdit
        Left = 104
        Top = 117
        Width = 40
        Height = 21
        TabOrder = 10
      end
      object IGenreBox: TComboBox
        Left = 104
        Top = 141
        Width = 190
        Height = 21
        ItemHeight = 13
        Sorted = True
        TabOrder = 12
      end
      object ICommentsMemo: TMemo
        Left = 104
        Top = 165
        Width = 289
        Height = 63
        TabOrder = 14
        WordWrap = False
      end
      object ExistID3v2Box: TCheckBox
        Left = 0
        Top = 212
        Width = 81
        Height = 17
        Caption = #1089#1083#1080' '#1077#1089#1090#1100' '#1090#1072#1075
        TabOrder = 15
      end
      object CopyFromID3v1tov2: TCheckBox
        Left = 248
        Top = 0
        Width = 129
        Height = 17
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1080#1079' ID3v1'
        TabOrder = 16
      end
      object T2BandCaseBox: TComboBox
        Left = 296
        Top = 21
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 17
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object T2TitleCaseBox: TComboBox
        Left = 296
        Top = 45
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 18
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object T2AlbumCaseBox: TComboBox
        Left = 296
        Top = 69
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 19
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object T2GenreCaseBox: TComboBox
        Left = 296
        Top = 141
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 20
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
    end
    object DIDTGSheet: TTabSheet
      Caption = 'DID Tag'
      ImageIndex = 2
      object RemoveDIDBox: TCheckBox
        Left = 0
        Top = 0
        Width = 97
        Height = 17
        Caption = '&'#1059#1076#1072#1083#1080#1090#1100
        TabOrder = 0
      end
      object DArtistEnBox: TCheckBox
        Left = 0
        Top = 23
        Width = 97
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        TabOrder = 1
        OnClick = DArtistEnBoxClick
      end
      object DTitleEnBox: TCheckBox
        Left = 0
        Top = 47
        Width = 97
        Height = 17
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        TabOrder = 3
        OnClick = DTitleEnBoxClick
      end
      object DAlbumEnBox: TCheckBox
        Left = 0
        Top = 70
        Width = 97
        Height = 17
        Caption = #1040#1083#1100#1073#1086#1084
        TabOrder = 5
        OnClick = DAlbumEnBoxClick
      end
      object DYearEnBox: TCheckBox
        Left = 0
        Top = 94
        Width = 97
        Height = 17
        Caption = #1043#1086#1076
        TabOrder = 7
        OnClick = DYearEnBoxClick
      end
      object DGenreEnBox: TCheckBox
        Left = 0
        Top = 118
        Width = 97
        Height = 17
        Caption = #1046#1072#1085#1088
        TabOrder = 9
        OnClick = DGenreEnBoxClick
      end
      object DCommentsEnBox: TCheckBox
        Left = 0
        Top = 143
        Width = 97
        Height = 17
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080
        TabOrder = 11
        OnClick = DCommentsEnBoxClick
      end
      object DArtistEdit: TEdit
        Left = 104
        Top = 21
        Width = 190
        Height = 21
        TabOrder = 2
      end
      object DTitleEdit: TEdit
        Left = 104
        Top = 45
        Width = 190
        Height = 21
        TabOrder = 4
      end
      object DAlbumEdit: TEdit
        Left = 104
        Top = 69
        Width = 190
        Height = 21
        TabOrder = 6
      end
      object DYearEdit: TEdit
        Left = 104
        Top = 93
        Width = 40
        Height = 21
        TabOrder = 8
      end
      object DGenreBox: TComboBox
        Left = 104
        Top = 117
        Width = 190
        Height = 21
        ItemHeight = 13
        Sorted = True
        TabOrder = 10
      end
      object DCommentsEdit: TEdit
        Left = 104
        Top = 141
        Width = 190
        Height = 21
        TabOrder = 12
      end
      object ExistDIDBox: TCheckBox
        Left = 0
        Top = 212
        Width = 233
        Height = 17
        Caption = #1054#1073#1088#1072#1073#1072#1090#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1077#1089#1083#1080' '#1077#1089#1090#1100' DID '#1090#1072#1075
        TabOrder = 13
      end
      object DTBandCaseBox: TComboBox
        Left = 296
        Top = 21
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 14
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object DTTitleCaseBox: TComboBox
        Left = 296
        Top = 45
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 15
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object DTAlbumCaseBox: TComboBox
        Left = 296
        Top = 69
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 16
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object DTGenreCaseBox: TComboBox
        Left = 296
        Top = 117
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 17
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
      object DTCommentCaseBox: TComboBox
        Left = 296
        Top = 141
        Width = 96
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 18
        Text = #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
        Items.Strings = (
          #1041#1077#1047' '#1048#1079#1084#1077#1085#1077#1085#1080#1081
          #1055#1077#1088#1074#1072#1103' '#1073#1086#1083#1100#1096#1072#1103
          #1055#1077#1088#1074#1099#1077' '#1041#1086#1083#1100#1096#1080#1077
          #1074#1089#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077
          #1042#1057#1045' '#1041#1054#1051#1068#1064#1048#1045)
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'MPEG'
      ImageIndex = 3
      object OptBegMPEGBox: TCheckBox
        Left = 0
        Top = 0
        Width = 193
        Height = 17
        Caption = #1054#1087#1090#1080#1084#1080#1079#1080#1088#1086#1074#1072#1090#1100' '#1053#1072#1095#1072#1083#1086' MPEG'
        TabOrder = 0
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 287
    Width = 400
    Height = 19
    Panels = <
      item
        Width = 115
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object SaveBtn: TButton
    Left = 0
    Top = 260
    Width = 115
    Height = 25
    Caption = #1054'&'#1073#1088#1072#1073#1086#1090#1072#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = SaveBtnClick
  end
  object CancelBtn: TButton
    Left = 285
    Top = 260
    Width = 115
    Height = 25
    Cancel = True
    Caption = '&'#1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
end
