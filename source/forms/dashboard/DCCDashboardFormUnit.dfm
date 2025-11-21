object DCCDashboardForm: TDCCDashboardForm
  Left = 0
  Top = 0
  ClientHeight = 720
  ClientWidth = 1200
  Caption = 'DCC Dashboard'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
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
        inline SourcesFrame: TSourcesFrame
          Left = 0
          Top = 0
          Width = 320
          Height = 720
          Align = alClient
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          ParentFont = False
          Background.Picture.Data = {00}
          ExplicitWidth = 320
          ExplicitHeight = 720
          inherited gridSources: TUniDBGrid
            Width = 320
            Height = 720
          end
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
      ExplicitLeft = 772
      ExplicitHeight = 695
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
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        ParentFont = False
        Background.Picture.Data = {00}
      end
    end
    object cpCenter: TUniContainerPanel
      Left = 326
      Top = 0
      Width = 454
      Height = 720
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 4
      object cpLinks: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 454
        Height = 240
        Hint = ''
        ParentColor = False
        Align = alTop
        TabOrder = 1
        ExplicitWidth = 446
      end
      object cpContent: TUniContainerPanel
        Left = 0
        Top = 246
        Width = 454
        Height = 474
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 2
        inline ContentFrame: TContentFrame
          Left = 0
          Top = 0
          Width = 454
          Height = 474
          Align = alClient
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          ParentFont = False
          Background.Picture.Data = {00}
          ExplicitWidth = 454
          ExplicitHeight = 474
          inherited gridContent: TUniDBGrid
            Width = 454
            Height = 474
          end
        end
      end
      object splLinks: TUniSplitter
        Left = 0
        Top = 240
        Width = 454
        Height = 6
        Cursor = crVSplit
        Hint = ''
        Align = alTop
        ParentColor = False
        Color = clBtnFace
        ExplicitWidth = 446
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
      ExplicitHeight = 695
    end
  end
end
