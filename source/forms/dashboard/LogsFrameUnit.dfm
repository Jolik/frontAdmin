object LogsFrame: TLogsFrame
  Left = 0
  Top = 0
  Width = 414
  Height = 720
  OnCreate = UniFrameCreate
  OnDestroy = UniFrameDestroy
  Align = alClient
  Anchors = [akLeft, akTop, akRight, akBottom]
  TabOrder = 0
  ParentFont = False
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
    TabOrder = 0
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
      end>
  end
  object dsLogs: TDataSource
    DataSet = mtLogs
    Left = 64
    Top = 104
  end
  object mtLogs: TFDMemTable
    Active = True
    IndexFieldNames = 'timestamp:D'
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
      Size = 8192
    end
    object mtLogstimestamp: TLargeintField
      FieldName = 'timestamp'
    end
  end
  object LogTimer: TUniTimer
    Enabled = False
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = LogTimerTimer
    Left = 208
    Top = 104
  end
end
