object FormDesign: TFormDesign
  Left = 303
  Top = 202
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Design Mosaic'
  ClientHeight = 486
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DesignImage: TImage
    Left = 160
    Top = 8
    Width = 417
    Height = 417
  end
  object ColorFG: TShape
    Left = 16
    Top = 392
    Width = 33
    Height = 33
    Brush.Color = clRed
    OnMouseDown = ColorFGMouseDown
  end
  object ColorBG: TShape
    Left = 112
    Top = 392
    Width = 33
    Height = 33
    OnMouseDown = ColorFGMouseDown
  end
  object Label1: TLabel
    Left = 24
    Top = 347
    Width = 62
    Height = 13
    Caption = 'Line Spacing'
  end
  object SBCCW: TSpeedButton
    Left = 82
    Top = 400
    Width = 23
    Height = 22
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
      D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000000000000000000000C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
      0000000000000000000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000000000000000
      00C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
      D0D4C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000
      00000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
      D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D40000000000
      00C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400000000
      0000C8D0D4C8D0D4000000000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4000000000000000000000000000000000000000000C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400000000000000
      0000000000000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
      0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
      D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4}
    OnClick = SBCCWClick
  end
  object SBCW: TSpeedButton
    Left = 56
    Top = 400
    Width = 23
    Height = 22
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
      D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4000000000000000000000000C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400000000000000000000
      0000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4000000000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8
      D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8D0D4C8
      D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4000000000000C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000000000000000C8D0D4C8
      D0D4000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4000000000000000000000000000000000000000000C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400000000000000
      0000000000000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
      D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
      D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4}
    OnClick = SBCWClick
  end
  object Label2: TLabel
    Left = 24
    Top = 368
    Width = 48
    Height = 13
    Caption = 'Size Ratio'
  end
  object FillCell: TCheckBox
    Left = 208
    Top = 440
    Width = 81
    Height = 17
    Caption = 'Fill entire cell'
    TabOrder = 10
    OnClick = FillCellClick
  end
  object PhraseList: TListBox
    Left = 8
    Top = 8
    Width = 145
    Height = 169
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
    OnKeyDown = PhraseListKeyDown
  end
  object ButtonSplit: TButton
    Left = 8
    Top = 184
    Width = 41
    Height = 25
    Caption = 'Split'
    TabOrder = 1
    OnClick = ButtonSplitClick
  end
  object ButtonFuse: TButton
    Left = 112
    Top = 184
    Width = 41
    Height = 25
    Caption = 'Fuse'
    TabOrder = 2
    OnClick = ButtonFuseClick
  end
  object ButtonAddPhrase: TButton
    Left = 8
    Top = 320
    Width = 41
    Height = 17
    Caption = 'Phrase'
    TabOrder = 3
    OnClick = ButtonAddPhraseClick
  end
  object ButtonAddLetters: TButton
    Left = 112
    Top = 320
    Width = 41
    Height = 17
    Caption = 'Letters'
    TabOrder = 4
    OnClick = ButtonAddLettersClick
  end
  object ButtonTransfer: TButton
    Left = 440
    Top = 440
    Width = 75
    Height = 25
    Caption = 'Transfer Grid'
    TabOrder = 5
    OnClick = ButtonTransferClick
  end
  object ButtonCancel: TButton
    Left = 520
    Top = 440
    Width = 57
    Height = 25
    Caption = 'Close'
    TabOrder = 6
    OnClick = ButtonCancelClick
  end
  object AddPhrase: TMemo
    Left = 8
    Top = 216
    Width = 145
    Height = 97
    TabOrder = 7
    WordWrap = False
  end
  object ButtonDelete: TButton
    Left = 56
    Top = 184
    Width = 49
    Height = 25
    Caption = 'Delete'
    TabOrder = 8
    OnClick = ButtonFuseClick
  end
  object DesignFillBlanks: TCheckBox
    Left = 16
    Top = 440
    Width = 81
    Height = 17
    Caption = 'Fill in blanks'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object ButtonTransCol: TButton
    Left = 352
    Top = 440
    Width = 81
    Height = 25
    Caption = 'Transfer Color'
    TabOrder = 11
    OnClick = ButtonTransColClick
  end
  object LineSpacing: TEdit
    Left = 104
    Top = 344
    Width = 33
    Height = 21
    TabOrder = 12
    Text = '5'
  end
  object DesignAddBorder: TCheckBox
    Left = 112
    Top = 440
    Width = 81
    Height = 17
    Caption = 'Add Border'
    TabOrder = 13
  end
  object DesignOutside: TCheckBox
    Left = 120
    Top = 456
    Width = 65
    Height = 17
    Caption = 'Outside'
    TabOrder = 14
  end
  object ButtonFormat: TButton
    Left = 56
    Top = 320
    Width = 49
    Height = 17
    Caption = 'Format'
    TabOrder = 15
    OnClick = ButtonFormatClick
  end
  object SizeRatio: TEdit
    Left = 104
    Top = 368
    Width = 33
    Height = 21
    TabOrder = 16
    Text = '1'
  end
  object ColorDialog: TColorDialog
    CustomColors.Strings = (
      'clRed')
    Left = 168
    Top = 16
  end
end
