object DCCSettingsForm: TDCCSettingsForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1407
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' DCC'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  TextHeight = 15
  object tvNavigate: TUniTreeView
    Left = 0
    Top = 0
    Width = 200
    Height = 600
    Hint = ''
    Items.FontData = {0100000000}
    Align = alLeft
    TabOrder = 0
    Color = clWindow
    OnChange = tvNavigateChange
    ExplicitHeight = 575
  end
  object pcForms: TUniPageControl
    Left = 200
    Top = 0
    Width = 1207
    Height = 600
    Hint = ''
    ActivePage = tshObservations
    TabBarVisible = False
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 1266
    ExplicitHeight = 575
    object tshBlank: TUniTabSheet
      Hint = ''
      Caption = #1055#1091#1089#1090#1072#1103
      ExplicitWidth = 1258
      ExplicitHeight = 547
    end
    object tshUnits: TUniTabSheet
      Hint = ''
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      ExplicitWidth = 1258
      ExplicitHeight = 547
      object pnlUnitsHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 1199
        Height = 572
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 1258
        ExplicitHeight = 547
      end
    end
    object tshObservations: TUniTabSheet
      Hint = ''
      Caption = 'tshObservations'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 1207
      ExplicitHeight = 600
      object pnlObservationsHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 1199
        Height = 572
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 472
        ExplicitTop = 224
        ExplicitWidth = 256
        ExplicitHeight = 128
      end
    end
  end
end
