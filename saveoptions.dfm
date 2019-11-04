object FormSaveOptions: TFormSaveOptions
  Left = 408
  Top = 250
  BorderStyle = bsDialog
  Caption = 'Image Save Options'
  ClientHeight = 294
  ClientWidth = 247
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 40
    Height = 13
    Caption = 'Tile Size'
  end
  object Label3: TLabel
    Left = 160
    Top = 56
    Width = 5
    Height = 13
    Caption = 'x'
  end
  object LabelSO: TLabel
    Left = 152
    Top = 112
    Width = 65
    Height = 13
    Caption = '/1000 of size.'
  end
  object Label4: TLabel
    Left = 168
    Top = 144
    Width = 8
    Height = 13
    Caption = '%'
  end
  object Label5: TLabel
    Left = 160
    Top = 232
    Width = 5
    Height = 13
    Caption = 'x'
  end
  object Label6: TLabel
    Left = 136
    Top = 16
    Width = 29
    Height = 13
    Caption = 'pixels.'
  end
  object Label7: TLabel
    Left = 48
    Top = 168
    Width = 48
    Height = 13
    Caption = 'Line width'
  end
  object Label8: TLabel
    Left = 144
    Top = 168
    Width = 65
    Height = 13
    Caption = '/1000 of size.'
  end
  object Label2: TLabel
    Left = 128
    Top = 80
    Width = 67
    Height = 13
    Caption = '% of total size.'
  end
  object Label23: TLabel
    Left = 208
    Top = 202
    Width = 8
    Height = 13
    Caption = '%'
  end
  object SOCancel: TButton
    Left = 88
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = SOCancelClick
  end
  object SOGo: TButton
    Left = 168
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 1
    OnClick = SOGoClick
  end
  object SOTileSize: TEdit
    Left = 72
    Top = 16
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '75'
  end
  object SOPadding: TCheckBox
    Left = 16
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Pad to format'
    TabOrder = 3
  end
  object SOBorder: TEdit
    Left = 96
    Top = 80
    Width = 25
    Height = 21
    TabOrder = 4
    Text = '5'
  end
  object SORatioX: TEdit
    Left = 128
    Top = 56
    Width = 25
    Height = 21
    TabOrder = 5
    Text = '5'
  end
  object SORatioY: TEdit
    Left = 176
    Top = 56
    Width = 25
    Height = 21
    TabOrder = 6
    Text = '7'
  end
  object SOSeparators: TCheckBox
    Left = 16
    Top = 112
    Width = 97
    Height = 17
    Caption = 'Add tile border'
    TabOrder = 7
  end
  object SOLineWidth: TEdit
    Left = 120
    Top = 112
    Width = 25
    Height = 21
    TabOrder = 8
    Text = '2'
  end
  object SOLowerContrast: TCheckBox
    Left = 16
    Top = 144
    Width = 113
    Height = 17
    Caption = 'Lower contrast to'
    TabOrder = 9
  end
  object SOBackContrast: TEdit
    Left = 128
    Top = 144
    Width = 33
    Height = 21
    TabOrder = 10
    Text = '75'
  end
  object SOSplitImage: TCheckBox
    Left = 16
    Top = 232
    Width = 97
    Height = 17
    Caption = 'Split output file'
    TabOrder = 11
  end
  object SOSplitX: TEdit
    Left = 128
    Top = 232
    Width = 25
    Height = 21
    TabOrder = 12
    Text = '5'
  end
  object SOSplitY: TEdit
    Left = 176
    Top = 232
    Width = 25
    Height = 21
    TabOrder = 13
    Text = '7'
  end
  object SOLowLineWidth: TEdit
    Left = 104
    Top = 168
    Width = 33
    Height = 21
    TabOrder = 14
    Text = '10'
  end
  object SOAddBorder: TCheckBox
    Left = 16
    Top = 80
    Width = 81
    Height = 17
    Caption = 'Add border'
    TabOrder = 15
  end
  object PushColor: TCheckBox
    Left = 16
    Top = 200
    Width = 145
    Height = 17
    Caption = 'Reduce color distance to '
    TabOrder = 16
  end
  object ColorDistanceReduction: TEdit
    Left = 168
    Top = 200
    Width = 33
    Height = 21
    TabOrder = 17
    Text = '80'
  end
end
