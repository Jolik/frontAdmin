inherited MainForm: TMainForm
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  ClientHeight = 722
  ClientWidth = 798
  Caption = 'MainForm'
  BorderStyle = bsNone
  WindowState = wsMaximized
  Movable = False
  Visible = True
  PageMode = True
  ExplicitWidth = 798
  ExplicitHeight = 722
  TextHeight = 15
  inherited pnlTop: TUniPanel
    Width = 798
    TabOrder = 1
    ExplicitWidth = 798
    inherited lblUtcTime: TUniLabel
      Left = 145
      Width = 146
      ExplicitLeft = 145
      ExplicitWidth = 146
    end
    inherited uncntnrpnLogo: TUniContainerPanel
      Width = 144
      ExplicitWidth = 144
      inherited unlblName: TUniLabel
        Width = 92
        Anchors = [akLeft, akTop, akRight]
        ExplicitWidth = 92
      end
      object unlblName1: TUniLabel
        Left = 40
        Top = 19
        Width = 101
        Height = 28
        Hint = ''
        Alignment = taCenter
        AutoSize = False
        Caption = #1082#1086#1084#1084#1091#1090#1072#1094#1080#1103
        Anchors = [akLeft, akTop, akRight]
        ParentFont = False
        Font.Color = 14273471
        Font.Height = -17
        ParentColor = False
        Color = 14273471
        TabOrder = 3
      end
    end
    inherited uncntnrpnAuth: TUniContainerPanel
      Left = 291
      ExplicitLeft = 291
    end
  end
  inherited pnlRight: TUniPanel
    Width = 145
    Height = 677
    TabOrder = 0
    Collapsible = True
    Color = 5652784
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
    object btnUsers: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 66
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      Align = alTop
      TabOrder = 1
      OnClick = btnUsersClick
      ExplicitTop = 128
    end
    object btnChannel: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 128
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1050#1072#1085#1072#1083#1099
      Align = alTop
      TabOrder = 2
      OnClick = btnChannelClick
      ExplicitTop = 283
    end
    object btnHandlers: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 97
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
      Align = alTop
      TabOrder = 3
      OnClick = btnHandlersClick
      ExplicitLeft = 3
    end
    object btnOperatorLinks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 159
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1054#1087#1077#1088'. '#1089#1074#1103#1079#1080
      Align = alTop
      TabOrder = 4
      OnClick = btnOperatorLinksClick
      ExplicitTop = 314
    end
    object btnRouterSources: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
      Align = alTop
      TabOrder = 5
      OnClick = btnRouterSourcesClick
      ExplicitTop = 97
    end
    object uncntnrpnInfo: TUniContainerPanel
      Left = 1
      Top = 548
      Width = 143
      Height = 128
      Hint = ''
      ParentColor = False
      Align = alBottom
      TabOrder = 6
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
      end
    end
    object btnOperatorLinksContent: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 190
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1050#1086#1085#1090#1077#1085#1090' '#1083#1080#1085#1082#1086#1074
      Align = alTop
      TabOrder = 7
      OnClick = btnOperatorLinksContentClick
      ExplicitTop = 345
    end
    object btnSearch: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 221
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1055#1086#1080#1089#1082
      Align = alTop
      TabOrder = 8
      OnClick = btnSearchClick
      ExplicitTop = 376
    end
    object btnLogs: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 252
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1051#1086#1075#1080
      Align = alTop
      TabOrder = 9
      OnClick = btnLogsClick
      ExplicitTop = 438
    end
    object btnSeetings: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 283
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      Align = alTop
      TabOrder = 10
      OnClick = btnSeetingsClick
      ExplicitTop = 469
    end
  end
  object uncntnrpnForms: TUniContainerPanel [2]
    Left = 145
    Top = 45
    Width = 653
    Height = 677
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 2
  end
end
