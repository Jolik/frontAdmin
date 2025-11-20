object MSSSettingsForm: TMSSSettingsForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 800
  Caption = 'MSSSettingsForm'
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
      Caption = 'Blank'
    end
    object tshRules: TUniTabSheet
      Hint = ''
      Caption = 'Rules'
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
      Caption = 'Aliases'
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
      Caption = 'Abonents'
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
