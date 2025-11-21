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
      Left = 145
      Width = 639
      ExplicitLeft = 145
      ExplicitWidth = 663
    end
    inherited uncntnrpnLogo: TUniContainerPanel
      Width = 144
      ExplicitWidth = 144
      inherited unlblName: TUniLabel
        Width = 101
        Anchors = [akLeft, akTop, akRight]
        ExplicitWidth = 102
      end
      object unlblName1: TUniLabel
        AlignWithMargins = True
        Left = 40
        Top = 17
        Width = 101
        Height = 25
        Hint = ''
        Margins.Top = 5
        Alignment = taCenter
        AutoSize = False
        Caption = #1076#1072#1085#1085#1099#1077
        Anchors = [akLeft, akTop, akRight]
        ParentFont = False
        Font.Color = 14273471
        Font.Height = -17
        ParentColor = False
        Color = 14273471
        TabOrder = 3
        ExplicitWidth = 102
      end
    end
    inherited uncntnrpnAuth: TUniContainerPanel
      Left = 784
      ExplicitLeft = 784
    end
  end
  inherited pnlRight: TUniPanel
    Width = 145
    Height = 677
    TabOrder = 0
    Collapsible = True
    Color = 47871
    ExplicitWidth = 145
    ExplicitHeight = 677
    object btnDashboard: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 137
      Height = 25
      Hint = ''
      Caption = 'Dashboard'
      Align = alTop
      TabOrder = 0
      OnClick = btnDashboardClick
    end
    object btnLinks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1051#1080#1085#1082#1080
      Align = alTop
      TabOrder = 1
      OnClick = btnLinksClick
      ExplicitWidth = 105
    end
    object btnStripTasks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 66
      Width = 137
      Height = 25
      Hint = ''
      Caption = 'Strip '#1047#1072#1076#1072#1095#1080
      Align = alTop
      TabOrder = 2
      OnClick = btnStripTasksClick
      ExplicitWidth = 105
    end
    object btnSummTask: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 97
      Width = 137
      Height = 25
      Hint = ''
      Caption = 'Summary '#1047#1072#1076#1072#1095#1080
      Align = alTop
      TabOrder = 3
      OnClick = btnSummTaskClick
      ExplicitWidth = 105
    end
    object btnDSProcessorTasks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 128
      Width = 137
      Height = 25
      Hint = ''
      Caption = 'DSProc '#1047#1072#1076#1072#1095#1080
      Align = alTop
      TabOrder = 4
      OnClick = btnDSProcessorTasksClick
      ExplicitWidth = 105
    end
    object unbtnMonitoring: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 159
      Width = 137
      Height = 25
      Hint = ''
      Caption = 'Monitoring '#1047#1072#1076#1072#1095#1080
      Align = alTop
      TabOrder = 5
      OnClick = unbtnMonitoringClick
      ExplicitWidth = 105
    end
    object btnDsGroups: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 190
      Width = 137
      Height = 25
      Hint = ''
      Caption = 'DS Groups'
      Align = alTop
      TabOrder = 6
      OnClick = btnDsGroupsClick
    end
    object unbtnSources: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 221
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
      Align = alTop
      TabOrder = 7
      OnClick = unbtnSourcesClick
      ExplicitWidth = 105
    end
    object btnObservations: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 252
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1053#1072#1073#1083#1102#1076#1077#1085#1080#1103
      Align = alTop
      TabOrder = 8
      OnClick = btnObservationsClick
      ExplicitWidth = 105
    end
    object btnDataseries: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 283
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1056#1103#1076#1099#32#1076#1072#1085#1085#1099#1093
      Align = alTop
      TabOrder = 9
      OnClick = btnDataseriesClick
    end
    object btnLogs: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 314
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1051#1086#1075#1080
      Align = alTop
      TabOrder = 10
      OnClick = btnLogsClick
    end
    object uncntnrpnInfo: TUniContainerPanel
      Left = 1
      Top = 548
      Width = 143
      Height = 128
      Hint = ''
      ParentColor = False
      Align = alBottom
      TabOrder = 11
      ExplicitWidth = 111
      object URLLabel: TUniLabel
        AlignWithMargins = True
        Left = 3
        Top = 88
        Width = 137
        Height = 70
        Hint = ''
        CreateOrder = 1
        AutoSize = False
        Caption = 'URL'
        Align = alTop
        TabOrder = 1
        ExplicitWidth = 105
      end
      object OSLabel: TUniLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 137
        Height = 79
        Hint = ''
        CreateOrder = 1
        AutoSize = False
        Caption = 'OSLabel'
        Align = alTop
        TabOrder = 2
        ExplicitWidth = 105
      end
    end
  end
end
