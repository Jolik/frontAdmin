object LogsFrame: TLogsFrame
  Left = 0
  Top = 0
  Width = 414
  Height = 720
  Align = alClient
  ParentFont = False
  TabOrder = 0
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
        Width = 160
        ReadOnly = True
      end
      item
        FieldName = 'payload'
        Title.Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
        Width = 280
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
        Title.Caption = 'Source'
        Width = 140
        ReadOnly = True
      end
      item
        FieldName = 'swarm_service'
        Title.Caption = 'Service'
        Width = 140
        ReadOnly = True
      end
      item
        FieldName = 'swarm_stack'
        Title.Caption = 'Stack'
        Width = 140
        ReadOnly = True
      end
      item
        FieldName = 'host'
        Title.Caption = 'Host'
        Width = 120
        ReadOnly = True
      end
      item
        FieldName = 'filename'
        Title.Caption = 'File'
        Width = 160
        ReadOnly = True
      end>
  end
  object dsLogs: TDataSource
    DataSet = mtLogs
    Left = 64
    Top = 104
  end
  object mtLogs: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'display_time'
        DataType = ftWideString
        Size = 64
      end
      item
        Name = 'payload'
        DataType = ftWideMemo
      end
      item
        Name = 'container_name'
        DataType = ftWideString
        Size = 128
      end
      item
        Name = 'source'
        DataType = ftWideString
        Size = 128
      end
      item
        Name = 'swarm_service'
        DataType = ftWideString
        Size = 128
      end
      item
        Name = 'swarm_stack'
        DataType = ftWideString
        Size = 128
      end
      item
        Name = 'host'
        DataType = ftWideString
        Size = 128
      end
      item
        Name = 'filename'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 136
    Top = 104
    object mtLogsdisplay_time: TWideStringField
      FieldName = 'display_time'
      Size = 64
    end
    object mtLogspayload: TWideStringField
      FieldName = 'payload'
      Size = 4000
    end
    object mtLogscontainer_name: TWideStringField
      FieldName = 'container_name'
      Size = 128
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
  object LogTimer: TUniTimer
    Enabled = False
    Interval = 1000
    RunOnce = False
    OnTimer = LogTimerTimer
    Left = 208
    Top = 104
  end
end
