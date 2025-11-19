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
      Width = 320
      Height = 720
      Hint = ''
      ParentColor = False
      Align = alLeft
      TabOrder = 1
      object cpSources: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 320
        Height = 720
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
        object SourcesFrame: TSourcesFrame
          Left = 0
          Top = 0
          Width = 320
          Height = 720
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 320
          ExplicitHeight = 720
        end
      end
    end
    object splSources: TUniSplitter
      Left = 320
      Top = 0
      Width = 6
      Height = 720
      Hint = ''
      Align = alLeft
      ParentColor = False
      Color = clBtnFace
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
    object cpLinks: TUniContainerPanel
      Left = 326
      Top = 0
      Width = 454
      Height = 240
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 3
      object LinksFrame: TLinksFrame
        Left = 0
        Top = 0
        Width = 454
        Height = 240
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 454
        ExplicitHeight = 240
      end
    end
    object splLinks: TUniSplitter
      Left = 326
      Top = 240
      Width = 868
      Height = 6
      Hint = ''
      Align = alTop
      ParentColor = False
      Color = clBtnFace
    end
    object cpContent: TUniContainerPanel
      Left = 326
      Top = 246
      Width = 868
      Height = 474
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 4
      object ContentFrame: TContentFrame
        Left = 0
        Top = 0
        Width = 868
        Height = 474
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 868
        ExplicitHeight = 474
      end
    end
  end
end
