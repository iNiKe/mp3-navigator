object LyricsForm: TLyricsForm
  Left = 273
  Top = 125
  Width = 342
  Height = 369
  Caption = 'LyricsForm'
  Color = clBtnFace
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
  object logmemo: TMemo
    Left = 0
    Top = 0
    Width = 334
    Height = 342
    Align = alClient
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    Lines.Strings = (
      'SQL Database request form...'
      '(c) C.J. NiKe.')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object MusCon: TADOConnection
  end
  object musds: TADODataSet
    Connection = MusCon
    Parameters = <>
    Left = 32
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 64
  end
end
