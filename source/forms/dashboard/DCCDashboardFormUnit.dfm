object DCCDashboardForm: TDCCDashboardForm
  Left = 0
  Top = 0
  Caption = 'DCC Dashboard'
  ClientHeight = 720
  ClientWidth = 1200
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 15
  object cpMain: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 1200
    Height = 720
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 0
    object cpLeft: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 780
      Height = 720
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 1
      object cpSources: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 780
        Height = 200
        Hint = ''
        ParentColor = False
        Align = alTop
        TabOrder = 1
        object SourcesFrame: TSourcesFrame
          Left = 0
          Top = 0
          Width = 780
          Height = 200
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 780
          ExplicitHeight = 200
        end
      end
      object splSources: TUniSplitter
        Left = 0
        Top = 200
        Width = 780
        Height = 6
        Hint = ''
        Align = alTop
        ParentColor = False
        Color = clBtnFace
      end
      object cpLinks: TUniContainerPanel
        Left = 0
        Top = 206
        Width = 780
        Height = 214
        Hint = ''
        ParentColor = False
        Align = alTop
        TabOrder = 2
        object LinksFrame: TLinksFrame
          Left = 0
          Top = 0
          Width = 780
          Height = 214
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 780
          ExplicitHeight = 214
        end
      end
      object splLinks: TUniSplitter
        Left = 0
        Top = 420
        Width = 780
        Height = 6
        Hint = ''
        Align = alTop
        ParentColor = False
        Color = clBtnFace
      end
      object cpContent: TUniContainerPanel
        Left = 0
        Top = 426
        Width = 780
        Height = 294
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 3
        object ContentFrame: TContentFrame
          Left = 0
          Top = 0
          Width = 780
          Height = 294
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 780
          ExplicitHeight = 294
        end
      end
    end
    object splMain: TUniSplitter
      Left = 780
      Top = 0
      Width = 6
      Height = 720
      Hint = ''
      Align = alRight
      ParentColor = False
      Color = clBtnFace
    end
    object cpRight: TUniContainerPanel
      Left = 786
      Top = 0
      Width = 414
      Height = 720
      Hint = ''
      ParentColor = False
      Align = alRight
      TabOrder = 2
      object LogsFrame: TLogsFrame
        Left = 0
        Top = 0
        Width = 414
        Height = 720
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 414
        ExplicitHeight = 720
      end
    end
  end
end
