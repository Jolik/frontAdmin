object MSSSettingsForm: TMSSSettingsForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 800
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' MSS'
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
    Width = 600
    Height = 600
    Hint = ''
    ActivePage = tshRouterSources
    TabBarVisible = False
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 592
    ExplicitHeight = 575
    object tshBlank: TUniTabSheet
      Hint = ''
      Caption = #1055#1091#1089#1090#1072#1103
      ExplicitWidth = 584
      ExplicitHeight = 547
    end
    object tshRules: TUniTabSheet
      Hint = ''
      Caption = #1055#1088#1072#1074#1080#1083#1072
      ExplicitWidth = 584
      ExplicitHeight = 547
      object pnlRulesHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 592
        Height = 572
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 584
        ExplicitHeight = 547
      end
    end
    object tshAliases: TUniTabSheet
      Hint = ''
      Caption = #1040#1083#1080#1072#1089#1099
      ExplicitWidth = 584
      ExplicitHeight = 547
      object pnlAliasesHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 592
        Height = 572
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 584
        ExplicitHeight = 547
      end
    end
    object tshAbonents: TUniTabSheet
      Hint = ''
      Caption = #1040#1073#1086#1085#1077#1085#1090#1099
      ExplicitWidth = 584
      ExplicitHeight = 547
      object pnlAbonentsHost: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 592
        Height = 572
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 584
        ExplicitHeight = 547
      end
    end
    object tshRouterSources: TUniTabSheet
      Hint = ''
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 600
      ExplicitHeight = 600
      object pnlRouterSources: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 592
        Height = 572
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 168
        ExplicitTop = 224
        ExplicitWidth = 256
        ExplicitHeight = 128
      end
    end
  end
end
