object FormReject: TFormReject
  Left = 245
  Top = 232
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Remove Image'
  ClientHeight = 192
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 169
    Height = 169
  end
  object ExtraLines: TCheckBox
    Left = 192
    Top = 8
    Width = 185
    Height = 17
    Caption = 'Extra lines.'
    TabOrder = 0
  end
  object NoLines: TCheckBox
    Left = 192
    Top = 32
    Width = 185
    Height = 17
    Caption = 'Lines not visible.'
    TabOrder = 1
  end
  object NoConnect: TCheckBox
    Left = 192
    Top = 56
    Width = 185
    Height = 17
    Caption = 'Lines don'#39't connect.'
    TabOrder = 2
  end
  object NoLicense: TCheckBox
    Left = 192
    Top = 80
    Width = 185
    Height = 17
    Caption = 'Incorrect or no license.'
    TabOrder = 3
  end
  object Comment: TEdit
    Left = 192
    Top = 104
    Width = 185
    Height = 21
    TabOrder = 4
  end
  object ButtonReject: TButton
    Left = 328
    Top = 160
    Width = 57
    Height = 25
    Caption = 'Reject'
    TabOrder = 5
    OnClick = ButtonRejectClick
  end
  object ButtonCancel: TButton
    Left = 200
    Top = 160
    Width = 57
    Height = 25
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = ButtonCancelClick
  end
  object ButtonRemove: TButton
    Left = 264
    Top = 159
    Width = 57
    Height = 25
    Caption = 'Remove'
    TabOrder = 7
    OnClick = ButtonRejectClick
  end
  object KeepImage: TCheckBox
    Left = 304
    Top = 136
    Width = 81
    Height = 17
    Caption = 'Keep Image'
    TabOrder = 8
  end
  object DoBlacklist: TCheckBox
    Left = 224
    Top = 136
    Width = 65
    Height = 17
    Caption = 'Blacklist'
    TabOrder = 9
  end
end
