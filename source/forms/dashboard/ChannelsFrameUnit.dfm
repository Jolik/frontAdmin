object ChannelsFrame: TChannelsFrame
  Left = 0
  Top = 0
  Width = 600
  Height = 320
  Align = alClient
  ParentFont = False
  TabOrder = 0
  object gridChannels: TUniDBGrid
    Left = 0
    Top = 0
    Width = 600
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
  object dsChannels: TDataSource
    DataSet = mtChannels
    Left = 64
    Top = 88
  end
  object mtChannels: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'chid'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'caption'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'queue'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'link'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'service'
        DataType = ftString
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
    Top = 88
    object mtChannelschid: TStringField
      FieldName = 'chid'
      Size = 64
    end
    object mtChannelsname: TStringField
      FieldName = 'name'
      Size = 255
    end
    object mtChannelscaption: TStringField
      FieldName = 'caption'
      Size = 255
    end
    object mtChannelsqueue: TStringField
      FieldName = 'queue'
      Size = 255
    end
    object mtChannelslink: TStringField
      FieldName = 'link'
      Size = 255
    end
    object mtChannelsservice: TStringField
      FieldName = 'service'
      Size = 255
    end
  end
end
