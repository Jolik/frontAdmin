object FormLayout: TFormLayout
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 800
  Caption = 'FormLayout'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object pnlTop: TUniPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 45
    Hint = ''
    Align = alTop
    TabOrder = 0
    Caption = ''
    ExplicitWidth = 798
    object lblUtcTime: TUniLabel
      Left = 1
      Top = 1
      Width = 798
      Height = 43
      Hint = ''
      Alignment = taCenter
      AutoSize = False
      Caption = #1042#1088#1077#1084#1103' UTC'
      Align = alClient
      ParentFont = False
      Font.Height = -25
      TabOrder = 1
      ExplicitWidth = 744
    end
  end
  object pnlRight: TUniPanel
    Left = 0
    Top = 45
    Width = 100
    Height = 555
    Hint = ''
    Align = alLeft
    TabOrder = 1
    Caption = ''
    ExplicitLeft = 698
    ExplicitHeight = 547
  end
  object tmUtc: TUniTimer
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = tmUtcTimer
    Left = 16
    Top = 60
  end
end
