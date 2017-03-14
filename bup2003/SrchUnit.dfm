object QueryForm: TQueryForm
  Left = 218
  Top = 84
  BorderStyle = bsDialog
  Caption = 'Поиск'
  ClientHeight = 370
  ClientWidth = 394
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
    Left = 1
    Top = 102
    Width = 62
    Height = 13
    Caption = 'Результат'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object QueryEdit: TEdit
    Left = 0
    Top = 0
    Width = 393
    Height = 21
    TabOrder = 0
    OnChange = QueryEditChange
    OnKeyDown = QueryEditKeyDown
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 24
    Width = 393
    Height = 73
    Caption = ' Искать в '
    TabOrder = 1
    object ArtistBox: TCheckBox
      Left = 6
      Top = 14
      Width = 88
      Height = 17
      Caption = 'Исполнителе'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = ArtistBoxClick
    end
    object TitleBox: TCheckBox
      Left = 100
      Top = 14
      Width = 71
      Height = 17
      Caption = 'Названии'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = TitleBoxClick
    end
    object AlbumBox: TCheckBox
      Left = 188
      Top = 14
      Width = 69
      Height = 17
      Caption = 'Альбоме'
      TabOrder = 2
      OnClick = AlbumBoxClick
    end
    object CommentsBox: TCheckBox
      Left = 278
      Top = 14
      Width = 93
      Height = 17
      Caption = 'Комментарие'
      TabOrder = 3
      OnClick = CommentsBoxClick
    end
    object GenreBox: TCheckBox
      Left = 7
      Top = 32
      Width = 57
      Height = 17
      Caption = 'Жанре'
      TabOrder = 4
      OnClick = GenreBoxClick
    end
    object FNameBox: TCheckBox
      Left = 100
      Top = 35
      Width = 90
      Height = 17
      Caption = 'Имени файла'
      TabOrder = 5
      OnClick = FNameBoxClick
    end
    object TagMaskBox: TCheckBox
      Left = 278
      Top = 34
      Width = 78
      Height = 17
      Caption = 'TAG-маске'
      TabOrder = 6
      Visible = False
      OnClick = TagMaskBoxClick
    end
  end
  object OKBtn: TButton
    Left = 264
    Top = 344
    Width = 129
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object ResultLV: TPTListView
    Left = 0
    Top = 120
    Width = 393
    Height = 220
    ColumnClick = False
    Columns = <
      item
        Caption = 'Исполнитель'
      end
      item
        Caption = 'Название'
      end
      item
        Caption = 'Альбом'
      end
      item
        Caption = 'Год'
      end
      item
        Caption = 'Комментарий'
      end
      item
        Caption = 'Жанр'
      end
      item
        Caption = 'Время'
      end
      item
        Caption = 'Файл'
      end>
    OnDblClick = ResultLVDblClick
    ReadOnly = True
    HideSelection = False
    TabOrder = 3
    ViewStyle = vsReport
    RowSelect = True
  end
  object CancelBtn: TButton
    Left = 0
    Top = 344
    Width = 129
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 4
  end
  object Button1: TButton
    Left = 132
    Top = 344
    Width = 129
    Height = 25
    Caption = 'Выделить'
    ModalResult = 6
    TabOrder = 5
  end
end
