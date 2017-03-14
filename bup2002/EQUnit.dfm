object EQForm: TEQForm
  Left = 336
  Top = 291
  BorderStyle = bsNone
  Caption = #1069#1082#1074#1072#1083#1072#1081#1079#1077#1088
  ClientHeight = 89
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object EQpMenu: TPopupMenu
    object N1: TMenuItem
      Caption = '&'#1047#1072#1075#1088#1091#1079#1080#1090#1100
      object N4: TMenuItem
        Caption = #1069#1050'-'#1074#1086#1083#1085#1091
        OnClick = N4Click
      end
      object N5: TMenuItem
        Caption = #1069#1050' '#1087#1086' '#1059#1084#1086#1083#1095#1072#1085#1080#1102
        OnClick = N5Click
      end
    end
    object N2: TMenuItem
      Caption = '&'#1057#1086#1093#1088#1072#1085#1080#1090#1100
      object N6: TMenuItem
        Caption = #1069#1050'-'#1074#1086#1083#1085#1091
        OnClick = N6Click
      end
      object EQF1: TMenuItem
        Caption = #1069#1050'-'#1074#1086#1083#1085#1091' '#1074' *.EQF ...'
      end
    end
    object N3: TMenuItem
      Caption = '&'#1059#1076#1072#1083#1080#1090#1100
      object N7: TMenuItem
        Caption = #1069#1050'-'#1074#1086#1083#1085#1091
        OnClick = N7Click
      end
    end
  end
end
