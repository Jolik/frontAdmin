object MSSSettingsForm: TMSSSettingsForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 800
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080#32#77#83#83
  OnCreate = UniFormCreate
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 15
  object tvNavigate: TUniTreeView
    Left = 0
    Top = 0
    Width = 200
    Height = 600
    Hint = ''
    Align = alLeft
    Items.NodeData = {0100000000000000}
    TabOrder = 0
    OnChange = tvNavigateChange
  end
  object pcForms: TUniPageControl
    Left = 200
    Top = 0
    Width = 600
    Height = 600
    Hint = ''
    ActivePage = tshBlank
    Align = alClient
    TabOrder = 1
    object tshBlank: TUniTabSheet
      Hint = ''
      Caption = #1055#1091#1089#1090#1072#1103
    end
    object tshRules: TUniTabSheet
      Hint = ''
      Caption = #1055#1088#1072#1074#1080#1083#1072
      object pnlRulesHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 592
        Height = 570
        Hint = ''
        Align = alClient
        TabOrder = 0
      end
    end
    object tshAliases: TUniTabSheet
      Hint = ''
      Caption = #1040#1083#1080#1072#1089#1099
      object pnlAliasesHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 592
        Height = 570
        Hint = ''
        Align = alClient
        TabOrder = 0
      end
    end
    object tshAbonents: TUniTabSheet
      Hint = ''
      Caption = #1040#1073#1086#1085#1077#1085#1090#1099
      object pnlAbonentsHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 592
        Height = 570
        Hint = ''
        Align = alClient
        TabOrder = 0
      end
    end
  end
end
