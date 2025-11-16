object ContentViewForm: TContentViewForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1000
  Caption = 'Content details'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  OnShow = UniFormShow
  PixelsPerInch = 96
  TextHeight = 15
  object cpHeader: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 80
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 0
    object lHeaderName: TUniLabel
      Left = 16
      Top = 16
      Width = 100
      Height = 20
      Hint = ''
      Caption = 'Name'
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object lHeaderNameValue: TUniLabel
      Left = 16
      Top = 44
      Width = 960
      Height = 20
      Hint = ''
      Caption = ''
      Font.Style = [fsBold]
      TabOrder = 2
    end
  end
  object cpFooter: TUniContainerPanel
    Left = 0
    Top = 540
    Width = 1000
    Height = 60
    Hint = ''
    ParentColor = False
    Align = alBottom
    TabOrder = 1
    object btnClose: TUniButton
      Left = 884
      Top = 12
      Width = 100
      Height = 36
      Hint = ''
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object cpMain: TUniContainerPanel
    Left = 0
    Top = 80
    Width = 1000
    Height = 460
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 2
    object cpBody: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 560
      Height = 460
      Hint = ''
      ParentColor = False
      Align = alLeft
      TabOrder = 1
      object memoBody: TUniMemo
        Left = 0
        Top = 0
        Width = 560
        Height = 460
        Hint = ''
        Align = alClient
        ReadOnly = True
        TabOrder = 1
      end
    end
    object splMain: TUniSplitter
      Left = 560
      Top = 0
      Width = 6
      Height = 460
      Hint = ''
      Align = alLeft
      ResizeAnchor = akLeft
    end
    object cpInfo: TUniContainerPanel
      Left = 566
      Top = 0
      Width = 434
      Height = 460
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 2
      object pcInfo: TUniPageControl
        Left = 0
        Top = 0
        Width = 434
        Height = 460
        Hint = ''
        ActivePage = tsInfo
        Align = alClient
        TabOrder = 1
        object tsInfo: TUniTabSheet
          Hint = ''
          Caption = 'Info'
          object cpInfoName: TUniContainerPanel
            Left = 0
            Top = 0
            Width = 426
            Height = 60
            Hint = ''
            ParentColor = False
            Align = alTop
            TabOrder = 0
            object lInfoName: TUniLabel
              Left = 16
              Top = 8
              Width = 100
              Height = 20
              Hint = ''
              Caption = 'Name'
              ParentFont = False
              Font.Style = [fsBold]
              TabOrder = 1
            end
            object lInfoNameValue: TUniLabel
              Left = 16
              Top = 32
              Width = 394
              Height = 20
              Hint = ''
              Caption = ''
              TabOrder = 2
            end
          end
          object cpInfoKey: TUniContainerPanel
            Left = 0
            Top = 60
            Width = 426
            Height = 60
            Hint = ''
            ParentColor = False
            Align = alTop
            TabOrder = 1
            object lInfoKey: TUniLabel
              Left = 16
              Top = 8
              Width = 100
              Height = 20
              Hint = ''
              Caption = 'Key'
              ParentFont = False
              Font.Style = [fsBold]
              TabOrder = 1
            end
            object lInfoKeyValue: TUniLabel
              Left = 16
              Top = 32
              Width = 394
              Height = 20
              Hint = ''
              Caption = ''
              TabOrder = 2
            end
          end
          object cpInfoType: TUniContainerPanel
            Left = 0
            Top = 120
            Width = 426
            Height = 60
            Hint = ''
            ParentColor = False
            Align = alTop
            TabOrder = 2
            object lInfoType: TUniLabel
              Left = 16
              Top = 8
              Width = 100
              Height = 20
              Hint = ''
              Caption = 'Type'
              ParentFont = False
              Font.Style = [fsBold]
              TabOrder = 1
            end
            object lInfoTypeValue: TUniLabel
              Left = 16
              Top = 32
              Width = 394
              Height = 20
              Hint = ''
              Caption = ''
              TabOrder = 2
            end
          end
          object cpInfoWho: TUniContainerPanel
            Left = 0
            Top = 180
            Width = 426
            Height = 60
            Hint = ''
            ParentColor = False
            Align = alTop
            TabOrder = 3
            object lInfoWho: TUniLabel
              Left = 16
              Top = 8
              Width = 100
              Height = 20
              Hint = ''
              Caption = 'Who'
              ParentFont = False
              Font.Style = [fsBold]
              TabOrder = 1
            end
            object lInfoWhoValue: TUniLabel
              Left = 16
              Top = 32
              Width = 394
              Height = 20
              Hint = ''
              Caption = ''
              TabOrder = 2
            end
          end
        end
        object tsHistory: TUniTabSheet
          Hint = ''
          Caption = 'History'
          object memoHistory: TUniMemo
            Left = 0
            Top = 0
            Width = 426
            Height = 430
            Hint = ''
            Align = alClient
            ReadOnly = True
            TabOrder = 0
          end
        end
      end
    end
  end
end
