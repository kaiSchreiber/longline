object FormTally: TFormTally
  Left = 382
  Top = 253
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Tile Color Overview'
  ClientHeight = 389
  ClientWidth = 427
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
  object TallyHue: TImage
    Left = 152
    Top = 8
    Width = 265
    Height = 257
  end
  object TallyHist: TImage
    Left = 152
    Top = 272
    Width = 265
    Height = 81
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 137
    Height = 201
    Caption = 'Tiles to Show'
    TabOrder = 0
    object Label2: TLabel
      Left = 16
      Top = 168
      Width = 45
      Height = 13
      Caption = 'Pixel Size'
    end
    object TotalLabel: TLabel
      Left = 16
      Top = 144
      Width = 60
      Height = 13
      Caption = 'Total: 0 tiles.'
    end
    object ShowEmpty: TCheckBox
      Left = 8
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Empty'
      TabOrder = 0
      OnMouseUp = ShowEmptyMouseUp
    end
    object ShowEnds: TCheckBox
      Left = 72
      Top = 24
      Width = 49
      Height = 17
      Caption = 'Ends'
      TabOrder = 1
      OnMouseUp = ShowEmptyMouseUp
    end
    object ShowCorners: TCheckBox
      Left = 8
      Top = 48
      Width = 65
      Height = 17
      Caption = 'Corners'
      TabOrder = 2
      OnMouseUp = ShowEmptyMouseUp
    end
    object ShowStraight: TCheckBox
      Left = 72
      Top = 48
      Width = 57
      Height = 17
      Caption = 'Straight'
      TabOrder = 3
      OnMouseUp = ShowEmptyMouseUp
    end
    object ShowCrosses: TCheckBox
      Left = 72
      Top = 72
      Width = 97
      Height = 17
      Caption = 'Crosses'
      TabOrder = 4
      OnMouseUp = ShowEmptyMouseUp
    end
    object Button1: TButton
      Left = 16
      Top = 96
      Width = 41
      Height = 17
      Caption = 'All'
      TabOrder = 5
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 72
      Top = 96
      Width = 41
      Height = 17
      Caption = 'None'
      TabOrder = 6
      OnClick = Button2Click
    end
    object ShowTriples: TCheckBox
      Left = 8
      Top = 72
      Width = 57
      Height = 17
      Caption = 'Triples'
      TabOrder = 7
      OnMouseUp = ShowEmptyMouseUp
    end
    object PixSize: TEdit
      Left = 80
      Top = 168
      Width = 33
      Height = 21
      TabOrder = 8
      Text = '15'
      OnExit = PixSizeExit
    end
    object OnlyUsable: TCheckBox
      Left = 8
      Top = 120
      Width = 97
      Height = 17
      Caption = 'Only Usable'
      TabOrder = 9
      OnClick = OnlyUsableClick
    end
  end
  object ButtonOK: TButton
    Left = 344
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ShowWhich: TRadioGroup
    Left = 8
    Top = 216
    Width = 137
    Height = 49
    Caption = 'Show...'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Present'
      'Missing')
    TabOrder = 2
    OnClick = ShowWhichClick
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 272
    Width = 137
    Height = 81
    Caption = 'Histogram'
    TabOrder = 3
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 59
      Height = 13
      Caption = 'Avg tiles/bin'
    end
    object AvgTiles: TEdit
      Left = 88
      Top = 24
      Width = 33
      Height = 21
      TabOrder = 0
      Text = '10'
      OnExit = AvgTilesExit
    end
    object HistHue: TRadioButton
      Left = 8
      Top = 48
      Width = 57
      Height = 17
      Caption = 'Hue'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = HistHueClick
    end
    object HistSat: TRadioButton
      Left = 56
      Top = 48
      Width = 73
      Height = 17
      Caption = 'Saturation'
      TabOrder = 2
      OnClick = HistSatClick
    end
  end
end
