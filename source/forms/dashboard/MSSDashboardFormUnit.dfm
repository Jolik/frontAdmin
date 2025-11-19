object MSSDashboardForm: TMSSDashboardForm
  Left = 0
  Top = 0
  Caption = 'MSS Dashboard'
  ClientHeight = 720
  ClientWidth = 1200
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
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
        object gridChannels: TUniDBGrid
          Left = 0
          Top = 0
          Width = 780
          Height = 320
          Hint = ''
          DataSource = dsChannels
          ReadOnly = True
          WebOptions.Paged = False
          LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
          ForceFit = True
          Align = alClient
          TabOrder = 1
          Columns = <
            item
              FieldName = 'chid'
              Title.Caption = 'ID'
              Width = 80
              ReadOnly = True
            end
            item
              FieldName = 'name'
              Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
              Width = 160
              ReadOnly = True
            end
            item
              FieldName = 'caption'
              Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
              Width = 200
              ReadOnly = True
            end
            item
              FieldName = 'queue'
              Title.Caption = #1054#1095#1077#1088#1077#1076#1100
              Width = 140
              ReadOnly = True
            end
            item
              FieldName = 'link'
              Title.Caption = #1051#1080#1085#1082
              Width = 140
              ReadOnly = True
            end
            item
              FieldName = 'service'
              Title.Caption = 'Service'
              Width = 120
              ReadOnly = True
            end>
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
        object gridContent: TUniDBGrid
          Left = 0
          Top = 0
          Width = 780
          Height = 394
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
              Width = 220
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
              Title.Caption = #1048#1085#1080#1094#1080#1072#1090#1086#1088
              Width = 160
              ReadOnly = True
            end
            item
              FieldName = 'key'
              Title.Caption = 'Key'
              Width = 150
              ReadOnly = True
            end>
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
      object gridLogs: TUniDBGrid
        Left = 0
        Top = 0
        Width = 414
        Height = 720
        Hint = ''
        DataSource = dsLogs
        ReadOnly = True
        WebOptions.Paged = False
        LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
        ForceFit = True
        Align = alClient
        TabOrder = 1
        OnDblClick = gridLogsDblClick
        Columns = <
          item
            FieldName = 'display_time'
            Title.Caption = #1042#1088#1077#1084#1103
            Width = 150
            ReadOnly = True
          end
          item
            FieldName = 'payload'
            Title.Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
            Width = 260
            ReadOnly = True
          end
          item
            FieldName = 'container_name'
            Title.Caption = 'Container'
            Width = 160
            ReadOnly = True
          end
          item
            FieldName = 'source'
            Title.Caption = #1048#1089#1090#1086#1095#1085#1080#1082
            Width = 120
            ReadOnly = True
          end
          item
            FieldName = 'swarm_service'
            Title.Caption = 'Service'
            Width = 120
            ReadOnly = True
          end
          item
            FieldName = 'swarm_stack'
            Title.Caption = 'Stack'
            Width = 120
            ReadOnly = True
          end>
      end
    end
  end
  object ContentTimer: TUniTimer
    Interval = 3000
    Enabled = False
    RunOnce = False
    OnTimer = ContentTimerTimer
  end
  object LogTimer: TUniTimer
    Interval = 1000
    Enabled = False
    RunOnce = False
    OnTimer = LogTimerTimer
  end
  object dsChannels: TDataSource
    DataSet = mtChannels
    Left = 48
    Top = 88
  end
  object mtChannels: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    Left = 48
    Top = 136
    object mtChannelschid: TStringField
      FieldName = 'chid'
      Size = 64
    end
    object mtChannelsname: TStringField
      FieldName = 'name'
      Size = 128
    end
    object mtChannelscaption: TStringField
      FieldName = 'caption'
      Size = 255
    end
    object mtChannelsqueue: TStringField
      FieldName = 'queue'
      Size = 128
    end
    object mtChannelslink: TStringField
      FieldName = 'link'
      Size = 128
    end
    object mtChannelsservice: TStringField
      FieldName = 'service'
      Size = 128
    end
  end
  object dsContent: TDataSource
    DataSet = mtContent
    Left = 48
    Top = 232
  end
  object mtContent: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    Left = 48
    Top = 280
    object mtContentn: TLargeintField
      FieldName = 'n'
    end
    object mtContenttime: TDateTimeField
      FieldName = 'time'
      DisplayFormat = 'dd.mm.yyyy hh:nn:ss'
    end
    object mtContentname: TStringField
      FieldName = 'name'
      Size = 255
    end
    object mtContenttype: TStringField
      FieldName = 'type'
      Size = 128
    end
    object mtContentwho: TStringField
      FieldName = 'who'
      Size = 128
    end
    object mtContentkey: TStringField
      FieldName = 'key'
      Size = 255
    end
    object mtContentjrid: TStringField
      FieldName = 'jrid'
      Size = 128
    end
  end
  object dsLogs: TDataSource
    DataSet = mtLogs
    Left = 48
    Top = 376
  end
  object mtLogs: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    Left = 48
    Top = 424
    object mtLogsdisplay_time: TWideStringField
      FieldName = 'display_time'
      Size = 64
    end
    object mtLogspayload: TWideStringField
      FieldName = 'payload'
      Size = 2048
    end
    object mtLogscontainer_name: TWideStringField
      FieldName = 'container_name'
      Size = 255
    end
    object mtLogssource: TWideStringField
      FieldName = 'source'
      Size = 128
    end
    object mtLogsswarm_service: TWideStringField
      FieldName = 'swarm_service'
      Size = 128
    end
    object mtLogsswarm_stack: TWideStringField
      FieldName = 'swarm_stack'
      Size = 128
    end
    object mtLogshost: TWideStringField
      FieldName = 'host'
      Size = 128
    end
    object mtLogsfilename: TWideStringField
      FieldName = 'filename'
      Size = 255
    end
  end
end
