inherited DCCDashboardForm: TDCCDashboardForm
  Caption = 'DCC Dashboard'
  PixelsPerInch = 96
  TextHeight = 15
  inherited cpMain: TUniContainerPanel
    object cpSources: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 300
      Height = 720
      Hint = ''
      ParentColor = False
      Align = alLeft
      TabOrder = 3
      object SourcesFrame: TSourcesFrame
        Left = 0
        Top = 0
        Width = 300
        Height = 720
        Align = alClient
        TabOrder = 0
      end
    end
    object splSources: TUniSplitter
      Left = 300
      Top = 0
      Width = 6
      Height = 720
      Hint = ''
      Align = alLeft
      ParentColor = False
      Color = clBtnFace
    end
    inherited cpLeft: TUniContainerPanel
      Left = 306
      Width = 480
      ExplicitLeft = 306
      ExplicitWidth = 480
      inherited cpChannels: TUniContainerPanel
        Width = 480
        ExplicitWidth = 480
      end
      inherited splChannels: TUniSplitter
        Width = 480
        ExplicitWidth = 480
      end
      inherited cpContent: TUniContainerPanel
        Width = 480
        ExplicitWidth = 480
      end
    end
    inherited splMain: TUniSplitter
      Left = 786
      ExplicitLeft = 786
    end
    inherited cpRight: TUniContainerPanel
      Left = 792
      ExplicitLeft = 792
    end
  end
end
