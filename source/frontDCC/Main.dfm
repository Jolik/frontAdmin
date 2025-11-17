inherited MainForm: TMainForm
  ClientHeight = 722
  ClientWidth = 1291
  Caption = 'MainForm'
  BorderStyle = bsNone
  WindowState = wsMaximized
  Movable = False
  Visible = True
  PageMode = True
  ExplicitWidth = 1291
  ExplicitHeight = 722
  TextHeight = 15
  inherited pnlTop: TUniPanel
    Width = 1291
    TabOrder = 1
    ExplicitWidth = 1291
    inherited lblUtcTime: TUniLabel
      Width = 783
      ExplicitWidth = 783
    end
    inherited uncntnrpnAuth: TUniContainerPanel
      Left = 784
      ExplicitLeft = 784
    end
  end
  inherited pnlRight: TUniPanel
    Width = 113
    Height = 677
    TabOrder = 0
    Collapsible = True
    ExplicitWidth = 113
    ExplicitHeight = 677
    object btnStripTasks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 105
      Height = 25
      Hint = ''
      Caption = 'Strip '#1047#1072#1076#1072#1095#1080
      Align = alTop
      TabOrder = 0
      OnClick = btnStripTasksClick
    end
    object btnLinks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1051#1080#1085#1082#1080
      Align = alTop
      TabOrder = 1
      OnClick = btnLinksClick
    end
    object btnSummTask: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 66
      Width = 105
      Height = 25
      Hint = ''
      Caption = 'Summary '#1047#1072#1076#1072#1095#1080
      Align = alTop
      TabOrder = 2
      OnClick = btnSummTaskClick
    end
    object btnDSProcessorTasks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 128
      Width = 105
      Height = 25
      Hint = ''
      Caption = 'DSProc '#1047#1072#1076#1072#1095#1080
      Align = alTop
      TabOrder = 3
      OnClick = btnDSProcessorTasksClick
    end
    object unbtnMonitoring: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 97
      Width = 105
      Height = 25
      Hint = ''
      Caption = 'Monitoring '#1047#1072#1076#1072#1095#1080
      Align = alTop
      TabOrder = 4
      OnClick = unbtnMonitoringClick
    end
    object unbtnSources: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 159
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
      Align = alTop
      TabOrder = 6
      OnClick = unbtnSourcesClick
    end
    object uncntnrpnInfo: TUniContainerPanel
      Left = 1
      Top = 548
      Width = 111
      Height = 128
      Hint = ''
      ParentColor = False
      Align = alBottom
      TabOrder = 7
      object URLLabel: TUniLabel
        AlignWithMargins = True
        Left = 3
        Top = 88
        Width = 105
        Height = 70
        Hint = ''
        CreateOrder = 1
        AutoSize = False
        Caption = 'URL'
        Align = alTop
        TabOrder = 1
      end
      object OSLabel: TUniLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 105
        Height = 79
        Hint = ''
        CreateOrder = 1
        AutoSize = False
        Caption = 'OSLabel'
        Align = alTop
        TabOrder = 2
      end
    end
  end
end
