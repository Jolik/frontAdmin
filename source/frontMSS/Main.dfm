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
        ExplicitWidth = 98
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
    object btnAbonents: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 66
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1040#1073#1086#1085#1077#1085#1090#1099
      Align = alTop
      TabOrder = 1
      OnClick = btnAbonentsClick
    end
    object btnUsers: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 97
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      Align = alTop
      TabOrder = 2
      OnClick = btnUsersClick
    end
    object btnAliases: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 128
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1040#1083#1080#1072#1089#1099
      Align = alTop
      TabOrder = 3
      OnClick = btnAliasesClick
    end
    object btnChannel: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 221
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1050#1072#1085#1072#1083#1099
      Align = alTop
      TabOrder = 3
      OnClick = btnChannelClick
    end
    object btnHandlers: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 190
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
      Align = alTop
      TabOrder = 4
      OnClick = btnHandlersClick
    end
    object btnLinks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 159
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1051#1080#1085#1082#1080
      Align = alTop
      TabOrder = 6
      OnClick = btnLinksClick
    end
    object btnOperatorLinks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 252
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1054#1087#1077#1088'. '#1089#1074#1103#1079#1080
      Align = alTop
      TabOrder = 6
      OnClick = btnOperatorLinksClick
    end
    object btnQueues: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 97
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1054#1095#1077#1088#1077#1076#1080
      Align = alTop
      TabOrder = 8
      OnClick = btnQueuesClick
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
      TabOrder = 9
      OnClick = btnRouterSourcesClick
    end
    object btnRules: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1055#1088#1072#1074#1080#1083#1072
      Align = alTop
      TabOrder = 10
      OnClick = btnRulesClick
    end
    object uncntnrpnInfo: TUniContainerPanel
      Left = 1
      Top = 548
      Width = 143
      Height = 128
      Hint = ''
      ParentColor = False
      Align = alBottom
      TabOrder = 10
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
      Top = 283
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1050#1086#1085#1090#1077#1085#1090' '#1083#1080#1085#1082#1086#1074
      Align = alTop
      TabOrder = 12
      OnClick = btnOperatorLinksContentClick
    end
    object btnSearch: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 314
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1055#1086#1080#1089#1082
      Align = alTop
      TabOrder = 13
      OnClick = btnSearchClick
    end
    object btnContentStream: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 345
      Width = 137
      Height = 25
      Hint = ''
      Caption = #1055#1086#1090#1086#1082' '#1082#1086#1085#1090#1077#1085#1090#1072
      Align = alTop
      TabOrder = 14
      OnClick = btnContentStreamClick
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
    ExplicitLeft = 151
    ExplicitTop = 50
    ExplicitWidth = 618
    ExplicitHeight = 639
  end
end
