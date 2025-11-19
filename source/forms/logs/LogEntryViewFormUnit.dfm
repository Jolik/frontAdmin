object LogEntryViewForm: TLogEntryViewForm
  Left = 0
  Top = 0
  ClientHeight = 420
  ClientWidth = 640
  Caption = 'View log'
  BorderStyle = bsDialog
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 13
  object cpHeader: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 120
    Align = alTop
    TabOrder = 0
    object lTimestamp: TUniLabel
      Left = 16
      Top = 16
      Width = 83
      Height = 13
      Caption = 'Time (ns)'
    end
    object lTimestampValue: TUniLabel
      Left = 120
      Top = 16
      Width = 73
      Height = 13
      Caption = '---'
    end
    object lContainer: TUniLabel
      Left = 16
      Top = 40
      Width = 86
      Height = 13
      Caption = 'Container'
    end
    object lContainerValue: TUniLabel
      Left = 120
      Top = 40
      Width = 73
      Height = 13
      Caption = '---'
    end
    object lHost: TUniLabel
      Left = 16
      Top = 64
      Width = 64
      Height = 13
      Caption = 'Host'
    end
    object lHostValue: TUniLabel
      Left = 120
      Top = 64
      Width = 73
      Height = 13
      Caption = '---'
    end
    object lSource: TUniLabel
      Left = 16
      Top = 88
      Width = 71
      Height = 13
      Caption = 'Source'
    end
    object lSourceValue: TUniLabel
      Left = 120
      Top = 88
      Width = 73
      Height = 13
      Caption = '---'
    end
    object lSwarmService: TUniLabel
      Left = 320
      Top = 16
      Width = 100
      Height = 13
      Caption = 'Swarm service'
    end
    object lSwarmServiceValue: TUniLabel
      Left = 440
      Top = 16
      Width = 73
      Height = 13
      Caption = '---'
    end
    object lSwarmStack: TUniLabel
      Left = 320
      Top = 40
      Width = 94
      Height = 13
      Caption = 'Swarm stack'
    end
    object lSwarmStackValue: TUniLabel
      Left = 440
      Top = 40
      Width = 73
      Height = 13
      Caption = '---'
    end
    object lFilename: TUniLabel
      Left = 320
      Top = 64
      Width = 67
      Height = 13
      Caption = 'File'
    end
    object lFilenameValue: TUniLabel
      Left = 440
      Top = 64
      Width = 73
      Height = 13
      Caption = '---'
    end
  end
  object cpFooter: TUniContainerPanel
    Left = 0
    Top = 368
    Width = 640
    Height = 52
    Align = alBottom
    TabOrder = 2
    object btnClose: TUniButton
      Left = 520
      Top = 12
      Width = 105
      Height = 25
      Caption = 'Close'
      OnClick = btnCloseClick
    end
  end
  object memoPayload: TUniMemo
    Left = 0
    Top = 120
    Width = 640
    Height = 248
    Align = alClient
    ReadOnly = True
    TabOrder = 1
  end
end
