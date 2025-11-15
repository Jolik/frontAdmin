inherited MainForm: TMainForm
  ClientHeight = 722
  ClientWidth = 798
  Caption = 'MainForm'
  BorderStyle = bsNone
  WindowState = wsMaximized
  Movable = False
  Visible = True
  PageMode = True
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  ExplicitWidth = 798
  ExplicitHeight = 722
  TextHeight = 15
  inherited UserNameLabel: TUniLabel
    Left = 572
    TabOrder = 3
    ExplicitLeft = 572
  end
  object OSLabel: TUniLabel [1]
    Left = 40
    Top = 24
    Width = 42
    Height = 13
    Hint = ''
    Caption = 'OSLabel'
    TabOrder = 0
  end
  object URLLabel: TUniLabel [2]
    Left = 40
    Top = 43
    Width = 20
    Height = 13
    Hint = ''
    Caption = 'URL'
    TabOrder = 1
  end
  object UniContainerPanel1: TUniContainerPanel [3]
    Left = 54
    Top = 62
    Width = 656
    Height = 605
    Hint = ''
    ParentColor = False
    TabOrder = 2
    object btnAbonents: TUniButton
      Left = 32
      Top = 80
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1040#1073#1086#1085#1077#1085#1090#1099
      TabOrder = 1
      OnClick = btnAbonentsClick
    end
    object btnAliases: TUniButton
      Left = 32
      Top = 120
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1040#1083#1080#1072#1089#1099
      TabOrder = 2
      OnClick = btnAliasesClick
    end
    object btnChannel: TUniButton
      Left = 32
      Top = 264
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1050#1072#1085#1072#1083#1099
      TabOrder = 3
      OnClick = btnChannelClick
    end
    object btnHandlers: TUniButton
      Left = 32
      Top = 200
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
      TabOrder = 4
      OnClick = btnHandlersClick
    end
    object btnLinks: TUniButton
      Left = 32
      Top = 160
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1051#1080#1085#1082#1080
      TabOrder = 5
      OnClick = btnLinksClick
    end
    object btnOperatorLinks: TUniButton
      Left = 32
      Top = 40
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1054#1087#1077#1088'. '#1089#1074#1103#1079#1080
      TabOrder = 6
      OnClick = btnOperatorLinksClick
    end
    object btnQueues: TUniButton
      Left = 32
      Top = 233
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1054#1095#1077#1088#1077#1076#1080
      TabOrder = 7
      OnClick = btnQueuesClick
    end
    object btnRouterSources: TUniButton
      Left = 32
      Top = 304
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
      TabOrder = 8
      OnClick = btnRouterSourcesClick
    end
    object btnRules: TUniButton
      Left = 32
      Top = 360
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1055#1088#1072#1074#1080#1083#1072
      TabOrder = 9
      OnClick = btnRulesClick
    end
    object cbCurComp: TUniComboBox
      Left = 487
      Top = 11
      Width = 145
      Hint = ''
      Text = ''
      TabOrder = 10
      IconItems = <>
      OnChange = cbCurCompChange
    end
    object cbCurDept: TUniComboBox
      Left = 487
      Top = 36
      Width = 145
      Hint = ''
      Style = csDropDownList
      Text = ''
      TabOrder = 11
      IconItems = <>
    end
    object UniLabel1: TUniLabel
      Left = 410
      Top = 42
      Width = 71
      Height = 13
      Hint = ''
      Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090
      TabOrder = 12
    end
    object UniLabel2: TUniLabel
      Left = 427
      Top = 16
      Width = 54
      Height = 13
      Hint = ''
      Caption = #1050#1086#1084#1087#1072#1085#1080#1103
      TabOrder = 13
    end
  end
end
