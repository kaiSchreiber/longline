object FormProgress: TFormProgress
  Left = 492
  Top = 259
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 189
  ClientWidth = 196
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TProgressBar
    Left = 0
    Top = 2
    Width = 193
    Height = 20
    Step = 1
    TabOrder = 0
  end
  object ProgOK: TButton
    Left = 112
    Top = 160
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    TabOrder = 1
    OnClick = ProgOKClick
  end
  object ProgressMemo: TMemo
    Left = 0
    Top = 24
    Width = 193
    Height = 129
    Lines.Strings = (
      'ProgressMemo')
    TabOrder = 2
  end
end
