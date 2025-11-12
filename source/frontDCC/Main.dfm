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
  object btnStripTasks: TUniButton
    Left = 40
    Top = 344
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Strip '#1047#1072#1076#1072#1095#1080
    TabOrder = 0
    OnClick = btnStripTasksClick
  end
  object btnLinks: TUniButton
    Left = 40
    Top = 160
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1051#1080#1085#1082#1080
    TabOrder = 1
    OnClick = btnLinksClick
  end
  object btnSummTask: TUniButton
    Left = 40
    Top = 383
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Summary '#1047#1072#1076#1072#1095#1080
    TabOrder = 2
    OnClick = btnSummTaskClick
  end
  object btnDSProcessorTasks: TUniButton
    Left = 40
    Top = 464
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'DSProc '#1047#1072#1076#1072#1095#1080
    TabOrder = 3
    OnClick = btnDSProcessorTasksClick
  end
  object UniButton1: TUniButton
    Left = 40
    Top = 423
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Monitoring '#1047#1072#1076#1072#1095#1080
    TabOrder = 4
    OnClick = UniButton1Click
  end
  object cbCurDept: TUniComboBox
    Left = 608
    Top = 68
    Width = 145
    Hint = ''
    Style = csDropDownList
    Text = ''
    TabOrder = 5
    IconItems = <>
  end
  object UniLabel1: TUniLabel
    Left = 531
    Top = 71
    Width = 71
    Height = 13
    Hint = ''
    Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090
    TabOrder = 6
  end
  object cbCurComp: TUniComboBox
    Left = 608
    Top = 43
    Width = 145
    Hint = ''
    Text = ''
    TabOrder = 7
    IconItems = <>
    OnChange = cbCurCompChange
  end
  object UniLabel2: TUniLabel
    Left = 531
    Top = 49
    Width = 54
    Height = 13
    Hint = ''
    Caption = #1050#1086#1084#1087#1072#1085#1080#1103
    TabOrder = 8
  end
  object unbtnSources: TUniButton
    Left = 40
    Top = 544
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
    TabOrder = 9
    OnClick = unbtnSourcesClick
  end
  object OSLabel: TUniLabel
    Left = 40
    Top = 28
    Width = 42
    Height = 13
    Hint = ''
    Caption = 'OSLabel'
    TabOrder = 10
  end
end
