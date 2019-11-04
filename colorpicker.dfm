object FormColPick: TFormColPick
  Left = 284
  Top = 249
  Width = 546
  Height = 396
  Caption = 'FormColPick'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ColorMap: TImage
    Left = 8
    Top = 8
    Width = 377
    Height = 345
  end
  object LumMap: TImage
    Left = 392
    Top = 8
    Width = 25
    Height = 345
  end
  object Selected: TImage
    Left = 424
    Top = 8
    Width = 105
    Height = 105
  end
  object R: TLabel
    Left = 432
    Top = 136
    Width = 8
    Height = 13
    Caption = 'R'
  end
  object Label1: TLabel
    Left = 432
    Top = 160
    Width = 8
    Height = 13
    Caption = 'G'
  end
  object Label2: TLabel
    Left = 432
    Top = 184
    Width = 7
    Height = 13
    Caption = 'B'
  end
  object ColorR: TEdit
    Left = 456
    Top = 136
    Width = 65
    Height = 21
    TabOrder = 0
    Text = '255'
  end
  object ColorG: TEdit
    Left = 456
    Top = 160
    Width = 65
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object ColorB: TEdit
    Left = 456
    Top = 184
    Width = 65
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object ButtonCancel: TButton
    Left = 448
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
  end
  object ButtonUse: TButton
    Left = 448
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Use'
    TabOrder = 4
  end
end
