object MSSDashboardForm: TMSSDashboardForm
  Left = 0
  Top = 0
  Caption = 'MSS Dashboard'
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
      object cpChannels: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 780
        Height = 320
        Hint = ''
        ParentColor = False
        Align = alTop
        TabOrder = 1
        inline ChannelsFrame: TChannelsFrame
          Left = 0
          Top = 0
          Width = 780
          Height = 320
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 780
          ExplicitHeight = 320
        end
      end
      object splChannels: TUniSplitter
        Left = 0
        Top = 320
        Width = 780
        Height = 6
        Hint = ''
        Align = alTop
        ParentColor = False
        Color = clBtnFace
      end
      object cpContent: TUniContainerPanel
        Left = 0
        Top = 326
        Width = 780
        Height = 394
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 2
        inline ContentFrame: TContentFrame
          Left = 0
          Top = 0
          Width = 780
          Height = 394
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 780
          ExplicitHeight = 394
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
      inline LogsFrame: TLogsFrame
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
