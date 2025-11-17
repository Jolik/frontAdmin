inherited MainForm: TMainForm
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
      Width = 290
      ExplicitWidth = 290
    end
    inherited uncntnrpnAuth: TUniContainerPanel
      Left = 291
      ExplicitLeft = 291
    end
  end
  inherited pnlRight: TUniPanel
    Width = 113
    Height = 677
    TabOrder = 0
    Collapsible = True
    ExplicitLeft = 0
    ExplicitWidth = 113
    ExplicitHeight = 677
    object btnAbonents: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 66
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1040#1073#1086#1085#1077#1085#1090#1099
      Align = alTop
      TabOrder = 1
      OnClick = btnAbonentsClick
      ExplicitTop = 97
    end
    object btnAliases: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 128
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1040#1083#1080#1072#1089#1099
      Align = alTop
      TabOrder = 2
      OnClick = btnAliasesClick
      ExplicitTop = 159
    end
    object btnChannel: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 221
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1050#1072#1085#1072#1083#1099
      Align = alTop
      TabOrder = 3
      OnClick = btnChannelClick
      ExplicitTop = 252
    end
    object btnHandlers: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 190
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
      Align = alTop
      TabOrder = 4
      OnClick = btnHandlersClick
      ExplicitTop = 221
    end
    object btnLinks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 159
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1051#1080#1085#1082#1080
      Align = alTop
      TabOrder = 5
      OnClick = btnLinksClick
      ExplicitTop = 190
    end
    object btnOperatorLinks: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 252
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1054#1087#1077#1088'. '#1089#1074#1103#1079#1080
      Align = alTop
      TabOrder = 6
      OnClick = btnOperatorLinksClick
      ExplicitLeft = 5
      ExplicitTop = 268
    end
    object btnQueues: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 97
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1054#1095#1077#1088#1077#1076#1080
      Align = alTop
      TabOrder = 7
      OnClick = btnQueuesClick
      ExplicitTop = 128
    end
    object btnRouterSources: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
      Align = alTop
      TabOrder = 8
      OnClick = btnRouterSourcesClick
      ExplicitTop = 66
    end
    object btnRules: TUniButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 105
      Height = 25
      Hint = ''
      Caption = #1055#1088#1072#1074#1080#1083#1072
      Align = alTop
      TabOrder = 9
      OnClick = btnRulesClick
      ExplicitTop = 35
    end
    object uncntnrpnInfo: TUniContainerPanel
      Left = 1
      Top = 548
      Width = 111
      Height = 128
      Hint = ''
      ParentColor = False
      Align = alBottom
      TabOrder = 10
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
    object btnOperatorLinksContent: TUniButton
      Left = 22
      Top = 296
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1050#1086#1085#1090#1077#1085#1090' '#1083#1080#1085#1082#1086#1074
      TabOrder = 11
      OnClick = btnOperatorLinksContentClick
    end
    object btnSearch: TUniButton
      Left = 22
      Top = 336
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1055#1086#1080#1089#1082
      TabOrder = 12
      OnClick = btnSearchClick
    end
    object btnContentStream: TUniButton
      Left = 22
      Top = 376
      Width = 78
      Height = 25
      Hint = ''
      Caption = #1055#1086#1090#1086#1082' '#1082#1086#1085#1090#1077#1085#1090#1072
      TabOrder = 13
      OnClick = btnContentStreamClick
    end
  end
end
