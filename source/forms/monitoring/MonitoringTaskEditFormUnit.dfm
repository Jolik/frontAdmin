inherited MonitoringTaskEditForm: TMonitoringTaskEditForm
  ClientWidth = 1418
  ExplicitWidth = 1434
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Width = 1418
    ExplicitWidth = 1416
    inherited btnOk: TUniButton
      Left = 1259
      ExplicitLeft = 1257
    end
    inherited btnCancel: TUniButton
      Left = 1340
      ExplicitLeft = 1338
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 1418
    ExplicitWidth = 1416
    inherited teCaption: TUniEdit
      Left = 98
      Width = 1317
      ExplicitLeft = 98
      ExplicitWidth = 1315
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 1418
    ExplicitWidth = 1416
    inherited teName: TUniEdit
      Left = 98
      Width = 1317
      ExplicitLeft = 98
      ExplicitWidth = 1315
    end
  end
  inherited pnClient: TUniContainerPanel
    Width = 491
    ExplicitWidth = 491
    ScrollHeight = 411
    ScrollWidth = 491
    inherited meDef: TUniMemo
      Top = 144
      ExplicitTop = 144
    end
    inherited cbEnabled: TUniCheckBox
      Top = 216
      ExplicitTop = 216
    end
    object ungrpbxSchedule: TUniGroupBox
      Left = 3
      Top = 239
      Width = 485
      Height = 105
      Hint = ''
      Caption = #1056#1072#1089#1087#1080#1089#1072#1085#1080#1077
      TabOrder = 12
      object unspndtPeriodSec: TUniSpinEdit
        Left = 183
        Top = 24
        Width = 121
        Hint = ''
        TabOrder = 1
      end
      object unlblCheckLate: TUniLabel
        Left = 21
        Top = 54
        Width = 156
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = #1044#1086#1087#1091#1089#1090#1080#1084#1086#1077' '#1086#1087#1086#1079#1076#1072#1085#1080#1077', '#1089#1077#1082':'
        TabOrder = 2
      end
      object unspndtLateSec: TUniSpinEdit
        Left = 183
        Top = 52
        Width = 121
        Hint = ''
        TabOrder = 3
      end
      object unlblPeriodSec: TUniLabel
        Left = 21
        Top = 28
        Width = 156
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1082#1072#1078#1076#1099#1077' N '#1089#1077#1082#1091#1085#1076':'
        TabOrder = 4
      end
    end
  end
  inherited pnCustomSettings: TUniContainerPanel
    Left = 1053
    ExplicitLeft = 1051
  end
  inherited pnSources: TUniContainerPanel
    Left = 491
    Width = 562
    ExplicitLeft = 491
    ExplicitWidth = 560
    inherited gridSources: TUniDBGrid
      Width = 562
    end
  end
end
