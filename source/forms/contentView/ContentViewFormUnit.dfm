object ContentViewForm: TContentViewForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1000
  Caption = 'Content details'
  OnShow = UniFormShow
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
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
      Width = 31
      Height = 13
      Hint = ''
      Caption = 'Name'
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object lHeaderNameValue: TUniLabel
      Left = 16
      Top = 44
      Width = 3
      Height = 13
      Hint = ''
      Caption = ''
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
    object btnRefreshHistory: TUniButton
      Left = 16
      Top = 12
      Width = 160
      Height = 36
      Hint = ''
      Caption = 'Refresh history'
      TabOrder = 1
      OnClick = btnRefreshHistoryClick
    end
    object btnClose: TUniButton
      Left = 884
      Top = 12
      Width = 100
      Height = 36
      Hint = ''
      Caption = 'Close'
      TabOrder = 2
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
      ParentColor = False
      Color = clBtnFace
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
        OnChange = pcInfoChange
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
              Width = 31
              Height = 13
              Hint = ''
              Caption = 'Name'
              ParentFont = False
              Font.Style = [fsBold]
              TabOrder = 1
            end
            object lInfoNameValue: TUniLabel
              Left = 16
              Top = 32
              Width = 3
              Height = 13
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
              Width = 19
              Height = 13
              Hint = ''
              Caption = 'Key'
              ParentFont = False
              Font.Style = [fsBold]
              TabOrder = 1
            end
            object lInfoKeyValue: TUniLabel
              Left = 16
              Top = 32
              Width = 3
              Height = 13
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
              Width = 25
              Height = 13
              Hint = ''
              Caption = 'Type'
              ParentFont = False
              Font.Style = [fsBold]
              TabOrder = 1
            end
            object lInfoTypeValue: TUniLabel
              Left = 16
              Top = 32
              Width = 3
              Height = 13
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
              Width = 25
              Height = 13
              Hint = ''
              Caption = 'Who'
              ParentFont = False
              Font.Style = [fsBold]
              TabOrder = 1
            end
            object lInfoWhoValue: TUniLabel
              Left = 16
              Top = 32
              Width = 3
              Height = 13
              Hint = ''
              Caption = ''
              TabOrder = 2
            end
          end
        end
        object tsHistory: TUniTabSheet
          Hint = ''
          Caption = 'History'
          object gridHistory: TUniDBGrid
            Left = 0
            Top = 0
            Width = 426
            Height = 432
            Hint = ''
            DataSource = dsHistory
            ReadOnly = True
            LoadMask.Message = 'Loading data...'
            Align = alClient
            TabOrder = 0
            Columns = <
              item
                FieldName = 'time'
                Title.Caption = 'Time'
                Width = 120
                ReadOnly = True
              end
              item
                FieldName = 'event'
                Title.Caption = 'Event'
                Width = 120
                ReadOnly = True
              end
              item
                FieldName = 'who'
                Title.Caption = 'Who'
                Width = 100
                ReadOnly = True
              end
              item
                FieldName = 'reason'
                Title.Caption = 'Reason'
                Width = 200
                ReadOnly = True
              end>
          end
        end
      end
    end
  end
  object dsHistory: TDataSource
    DataSet = mtHistory
    Left = 792
    Top = 520
  end
  object mtHistory: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 856
    Top = 520
    object mtHistoryhrid: TStringField
      FieldName = 'hrid'
      Size = 64
    end
    object mtHistorytime: TStringField
      FieldName = 'time'
      Size = 64
    end
    object mtHistoryevent: TStringField
      FieldName = 'event'
      Size = 255
    end
    object mtHistorywho: TStringField
      FieldName = 'who'
      Size = 128
    end
    object mtHistoryreason: TStringField
      FieldName = 'reason'
      Size = 512
    end
  end
end
