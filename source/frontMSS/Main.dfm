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
    Left = 32
    Top = 176
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1040#1083#1080#1072#1089#1099
    TabOrder = 3
    OnClick = btnAliasesClick
  end
  object btnChannel: TUniButton
    Left = 32
    Top = 320
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1050#1072#1085#1072#1083#1099
    TabOrder = 0
    OnClick = btnChannelClick
  end
  object btnLinks: TUniButton
    Left = 32
    Top = 216
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1051#1080#1085#1082#1080
    TabOrder = 1
    OnClick = btnLinksClick
  end
  object btnQueues: TUniButton
    Left = 32
    Top = 289
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1054#1095#1077#1088#1077#1076#1080
    TabOrder = 11
    OnClick = btnQueuesClick
  end
  object btnRouterSources: TUniButton
    Left = 32
    Top = 360
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
    TabOrder = 2
    OnClick = btnRouterSourcesClick
  end
  object btnAbonents: TUniButton
    Left = 32
    Top = 136
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1040#1073#1086#1085#1077#1085#1090#1099
    TabOrder = 4
    OnClick = btnAliasesClick
  end
  object btnRules: TUniButton
    Left = 32
    Top = 416
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
    Left = 32
    Top = 256
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
    TabOrder = 10
    OnClick = btnHandlersClick
  end
  object OSLabel: TUniLabel
    Left = 40
    Top = 24
    Width = 42
    Height = 13
    Hint = ''
    Caption = 'OSLabel'
    TabOrder = 12
  end
end
