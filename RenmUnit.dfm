object RenameForm: TRenameForm
  Left = 274
  Top = 130
  BorderStyle = bsToolWindow
  Caption = 'Переименование'
  ClientHeight = 85
  ClientWidth = 290
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
    Left = 0
    Top = 0
    Width = 174
    Height = 13
    Caption = 'Маска имени файла (нового)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object RenBtn: TButton
    Left = 0
    Top = 41
    Width = 105
    Height = 25
    Caption = '&Переименовать'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = RenBtnClick
  end
  object CancelBtn: TButton
    Left = 214
    Top = 41
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Отменить'
    ModalResult = 2
    TabOrder = 1
  end
  object NameEdit: TEdit
    Left = 0
    Top = 16
    Width = 289
    Height = 21
    TabOrder = 2
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 66
    Width = 290
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
end
