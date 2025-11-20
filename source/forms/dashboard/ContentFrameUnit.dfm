object ContentFrame: TContentFrame
  Left = 0
  Top = 0
  Width = 600
  Height = 394
  Align = alClient
  ParentFont = False
  TabOrder = 0
  OnCreate = UniFrameCreate
  OnDestroy = UniFrameDestroy
  object gridContent: TUniDBGrid
    Left = 0
    Top = 0
    Width = 600
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
  object dsContent: TDataSource
    DataSet = mtContent
    Left = 72
    Top = 96
  end
  object mtContent: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'n'
        DataType = ftLargeint
      end
      item
        Name = 'time'
        DataType = ftDateTime
      end
      item
        Name = 'name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'type'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'who'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'key'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'jrid'
        DataType = ftString
        Size = 255
      end>
    IndexDefs = <>
    IndexFieldNames = 'n:D'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 144
    Top = 96
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
      Size = 255
    end
    object mtContentwho: TStringField
      FieldName = 'who'
      Size = 255
    end
    object mtContentkey: TStringField
      FieldName = 'key'
      Size = 255
    end
    object mtContentjrid: TStringField
      FieldName = 'jrid'
      Size = 255
    end
  end
  object ContentTimer: TUniTimer
    Enabled = False
    Interval = 3000
    RunOnce = False
    OnTimer = ContentTimerTimer
    Left = 208
    Top = 96
  end
end
