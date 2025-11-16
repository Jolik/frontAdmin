object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 722
  ClientWidth = 798
  Caption = 'MainForm'
  BorderStyle = bsNone
  WindowState = wsMaximized
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  Movable = False
  PageMode = True
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object btnAliases: TUniButton
    Left = 40
    Top = 296
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1040#1083#1080#1072#1089#1099
    TabOrder = 3
    OnClick = btnAliasesClick
  end
  object btnChannel: TUniButton
    Left = 40
    Top = 440
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1050#1072#1085#1072#1083#1099
    TabOrder = 0
    OnClick = btnChannelClick
  end
  object btnLinks: TUniButton
    Left = 40
    Top = 336
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1051#1080#1085#1082#1080
    TabOrder = 1
    OnClick = btnLinksClick
  end
  object btnQueues: TUniButton
    Left = 40
    Top = 409
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1054#1095#1077#1088#1077#1076#1080
    TabOrder = 11
    OnClick = btnQueuesClick
  end
  object btnRouterSources: TUniButton
    Left = 40
    Top = 480
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
    TabOrder = 2
    OnClick = btnRouterSourcesClick
  end
  object btnAbonents: TUniButton
    Left = 40
    Top = 256
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1040#1073#1086#1085#1077#1085#1090#1099
    TabOrder = 4
    OnClick = btnAbonentsClick
  end
  object btnOperatorLinksContent: TUniButton
    Left = 40
    Top = 184
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1050#1086#1085#1090#1077#1085#1090' '#1083#1080#1085#1082#1086#1074
    TabOrder = 15
    OnClick = btnOperatorLinksContentClick
  end
  object btnOperatorLinks: TUniButton
    Left = 40
    Top = 216
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1054#1087#1077#1088'. '#1089#1074#1103#1079#1080
    TabOrder = 14
    OnClick = btnOperatorLinksClick
  end
  object btnRules: TUniButton
    Left = 40
    Top = 536
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1055#1088#1072#1074#1080#1083#1072
    TabOrder = 5
    OnClick = btnRulesClick
  end
  object cbCurDept: TUniComboBox
    Left = 600
    Top = 76
    Width = 145
    Hint = ''
    Style = csDropDownList
    Text = ''
    TabOrder = 6
    IconItems = <>
  end
  object UniLabel1: TUniLabel
    Left = 523
    Top = 79
    Width = 71
    Height = 13
    Hint = ''
    Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090
    TabOrder = 7
  end
  object cbCurComp: TUniComboBox
    Left = 600
    Top = 51
    Width = 145
    Hint = ''
    Text = ''
    TabOrder = 8
    IconItems = <>
    OnChange = cbCurCompChange
  end
  object UniLabel2: TUniLabel
    Left = 523
    Top = 57
    Width = 54
    Height = 13
    Hint = ''
    Caption = #1050#1086#1084#1087#1072#1085#1080#1103
    TabOrder = 9
  end
  object btnHandlers: TUniButton
    Left = 40
    Top = 376
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
    TabOrder = 10
    OnClick = btnHandlersClick
  end
  object OSLabel: TUniLabel
    Left = 48
    Top = 60
    Width = 42
    Height = 13
    Hint = ''
    Caption = 'OSLabel'
    TabOrder = 12
  end
  object URLLabel: TUniLabel
    Left = 48
    Top = 79
    Width = 20
    Height = 13
    Hint = ''
    Caption = 'URL'
    TabOrder = 13
  end
  object btnSearch: TUniButton
    Left = 48
    Top = 584
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1055#1086#1080#1089#1082
    TabOrder = 16
    OnClick = btnSearchClick
  end
  object btnContentStream: TUniButton
    Left = 48
    Top = 616
    Width = 150
    Height = 25
    Hint = ''
    Caption = #1055#1086#1090#1086#1082' '#1082#1086#1085#1090#1077#1085#1090#1072
    TabOrder = 17
    OnClick = btnContentStreamClick
  end
end
