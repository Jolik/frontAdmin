object DCCSettingsForm: TDCCSettingsForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1474
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' DCC'
  OnCreate = UniFormCreate
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
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
  end
  object pcForms: TUniPageControl
    Left = 200
    Top = 0
    Width = 1274
    Height = 600
    Hint = ''
    ActivePage = tshBlank
    TabBarVisible = False
    Align = alClient
    TabOrder = 1
    object tshBlank: TUniTabSheet
      Hint = ''
      Caption = #1055#1091#1089#1090#1072#1103
    end
    object tshUnits: TUniTabSheet
      Hint = ''
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      object pnlUnitsHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 1274
        Height = 600
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
      end
    end
  end
end
