object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 338
  ClientWidth = 651
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  DesignSize = (
    651
    338)
  PixelsPerInch = 96
  TextHeight = 13
  object userShape: TShape
    Left = 24
    Top = 280
    Width = 161
    Height = 33
    Anchors = [akLeft, akBottom]
  end
  object Label1: TLabel
    Left = 576
    Top = 24
    Width = 31
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 24
    Width = 59
    Height = 24
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 24
    Top = 54
    Width = 59
    Height = 24
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Timer1: TTimer
    Interval = 33
    OnTimer = Timer1Timer
    Left = 200
    Top = 24
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer2Timer
    Left = 264
    Top = 24
  end
end
