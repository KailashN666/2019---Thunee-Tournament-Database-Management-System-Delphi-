object frmHelp: TfrmHelp
  Left = 0
  Top = 0
  Caption = 'Help'
  ClientHeight = 675
  ClientWidth = 798
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object redHelp: TRichEdit
    Left = 0
    Top = 0
    Width = 801
    Height = 617
    ParentColor = True
    PlainText = True
    ReadOnly = True
    TabOrder = 0
    Zoom = 100
  end
  object btnClose: TBitBtn
    Left = 352
    Top = 640
    Width = 75
    Height = 25
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 1
  end
end
