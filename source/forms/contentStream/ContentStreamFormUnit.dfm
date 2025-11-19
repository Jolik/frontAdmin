object ContentStreamForm: TContentStreamForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1100
  Caption = #1055#1086#1090#1086#1082' '#1082#1086#1085#1090#1077#1085#1090#1072
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object cpMain: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 600
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 0
    object cpLeft: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 760
      Height = 600
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 1
      object gridContent: TUniDBGrid
        Left = 0
        Top = 0
        Width = 760
        Height = 480
        Hint = ''
        DataSource = dsContent
        ReadOnly = True
        WebOptions.Paged = False
        LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
        ForceFit = True
        Align = alClient
        TabOrder = 1
        OnDblClick = gridContentDblClick
        Columns = <
          item
            FieldName = 'n'
            Title.Caption = 'N'
            Width = 80
            ReadOnly = True
          end
          item
            FieldName = 'time'
            Title.Caption = #1042#1088#1077#1084#1103
            Width = 140
            ReadOnly = True
          end
          item
            FieldName = 'name'
            Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            Width = 200
            ReadOnly = True
          end
          item
            FieldName = 'type'
            Title.Caption = #1058#1080#1087
            Width = 120
            ReadOnly = True
          end
          item
            FieldName = 'who'
            Title.Caption = #1050#1090#1086
            Width = 140
            ReadOnly = True
          end
          item
            FieldName = 'key'
            Title.Caption = 'Key'
            Width = 120
            ReadOnly = True
          end
          item
            FieldName = 'size'
            Title.Caption = #1056#1072#1079#1084#1077#1088
            Width = 100
            ReadOnly = True
          end>
      end
      object cpStreamInfo: TUniContainerPanel
        Left = 0
        Top = 480
        Width = 760
        Height = 120
        Hint = ''
        ParentColor = False
        Align = alBottom
        TabOrder = 2
        object lTotalRecords: TUniLabel
          Left = 16
          Top = 16
          Width = 76
          Height = 13
          Hint = ''
          Caption = #1042#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081
          ParentFont = False
          Font.Style = [fsBold]
          TabOrder = 1
        end
        object lTotalRecordsValue: TUniLabel
          Left = 160
          Top = 16
          Width = 6
          Height = 13
          Hint = ''
          Caption = '0'
          TabOrder = 2
        end
        object lLastN: TUniLabel
          Left = 16
          Top = 44
          Width = 33
          Height = 13
          Hint = ''
          Caption = 'Last N'
          ParentFont = False
          Font.Style = [fsBold]
          TabOrder = 3
        end
        object lLastNValue: TUniLabel
          Left = 160
          Top = 44
          Width = 4
          Height = 13
          Hint = ''
          Caption = '-'
          TabOrder = 4
        end
        object lLastUpdate: TUniLabel
          Left = 16
          Top = 72
          Width = 100
          Height = 13
          Hint = ''
          Caption = #1055#1086#1089#1083'. '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077
          ParentFont = False
          Font.Style = [fsBold]
          TabOrder = 5
        end
        object lLastUpdateValue: TUniLabel
          Left = 160
          Top = 72
          Width = 4
          Height = 13
          Hint = ''
          Caption = '-'
          TabOrder = 6
        end
      end
    end
    object splMain: TUniSplitter
      Left = 760
      Top = 0
      Width = 6
      Height = 600
      Hint = ''
      Align = alRight
      ParentColor = False
      Color = clBtnFace
    end
    object cpInfo: TUniContainerPanel
      Left = 766
      Top = 0
      Width = 334
      Height = 600
      Hint = ''
      ParentColor = False
      Align = alRight
      TabOrder = 2
      object pcInfo: TUniPageControl
        Left = 0
        Top = 0
        Width = 334
        Height = 600
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
            Width = 326
            Height = 60
            Hint = ''
            ParentColor = False
            Align = alTop
            TabOrder = 0
            object lInfoName: TUniLabel
              Left = 16
              Top = 8
              Width = 51
              Height = 13
              Hint = ''
              Caption = #1053#1072#1079#1074#1072#1085#1080#1077
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
            Width = 326
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
            Width = 326
            Height = 60
            Hint = ''
            ParentColor = False
            Align = alTop
            TabOrder = 2
            object lInfoType: TUniLabel
              Left = 16
              Top = 8
              Width = 19
              Height = 13
              Hint = ''
              Caption = #1058#1080#1087
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
            Width = 326
            Height = 60
            Hint = ''
            ParentColor = False
            Align = alTop
            TabOrder = 3
            object lInfoWho: TUniLabel
              Left = 16
              Top = 8
              Width = 19
              Height = 13
              Hint = ''
              Caption = #1050#1090#1086
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
          object cpInfoBody: TUniContainerPanel
            Left = 0
            Top = 240
            Width = 326
            Height = 332
            Hint = ''
            ParentColor = False
            Align = alClient
            TabOrder = 4
            object memoBody: TUniMemo
              Left = 0
              Top = 0
              Width = 326
              Height = 332
              Hint = ''
              Align = alClient
              ReadOnly = True
              TabOrder = 1
            end
          end
        end
        object tsHistory: TUniTabSheet
          Hint = ''
          Caption = 'History'
          object cpHistoryToolbar: TUniContainerPanel
            Left = 0
            Top = 0
            Width = 326
            Height = 48
            Hint = ''
            ParentColor = False
            Align = alTop
            TabOrder = 0
            object btnRefreshHistory: TUniButton
              Left = 16
              Top = 8
              Width = 200
              Height = 32
              Hint = ''
              Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1080#1089#1090#1086#1088#1080#1102
              TabOrder = 1
              OnClick = btnRefreshHistoryClick
            end
          end
          object gridHistory: TUniDBGrid
            Left = 0
            Top = 48
            Width = 326
            Height = 524
            Hint = ''
            DataSource = dsHistory
            ReadOnly = True
            LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
            Align = alClient
            TabOrder = 1
            Columns = <
              item
                FieldName = 'time'
                Title.Caption = #1042#1088#1077#1084#1103
                Width = 120
                ReadOnly = True
              end
              item
                FieldName = 'event'
                Title.Caption = #1057#1086#1073#1099#1090#1080#1077
                Width = 140
                ReadOnly = True
              end
              item
                FieldName = 'who'
                Title.Caption = #1050#1090#1086
                Width = 80
                ReadOnly = True
              end
              item
                FieldName = 'reason'
                Title.Caption = #1055#1088#1080#1095#1080#1085#1072
                Width = 160
                ReadOnly = True
              end>
          end
        end
      end
    end
  end
  object dsContent: TDataSource
    DataSet = mtContent
    OnDataChange = dsContentDataChange
    Left = 64
    Top = 456
  end
  object mtContent: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 120
    Top = 456
    object mtContentn: TLargeintField
      FieldName = 'n'
    end
    object mtContenttime: TDateTimeField
      FieldName = 'time'
    end
    object mtContentname: TStringField
      FieldName = 'name'
      Size = 255
    end
    object mtContenttype: TStringField
      FieldName = 'type'
      Size = 100
    end
    object mtContentwho: TStringField
      FieldName = 'who'
      Size = 255
    end
    object mtContentkey: TStringField
      FieldName = 'key'
      Size = 255
    end
    object mtContentsize: TIntegerField
      FieldName = 'size'
    end
    object mtContentjrid: TStringField
      FieldName = 'jrid'
      Size = 64
    end
  end
  object StreamTimer: TUniTimer
    Enabled = False
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = StreamTimerTimer
    Left = 200
    Top = 456
  end
  object dsHistory: TDataSource
    DataSet = mtHistory
    Left = 272
    Top = 456
  end
  object mtHistory: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 328
    Top = 456
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
      Size = 255
    end
  end
end
