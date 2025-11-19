object SourcesFrame: TSourcesFrame
  Left = 0
  Top = 0
  Width = 600
  Height = 320
  Align = alClient
  ParentFont = False
  TabOrder = 0
  OnCreate = UniFrameCreate
  OnDestroy = UniFrameDestroy
  object gridSources: TUniDBGrid
    Left = 0
    Top = 0
    Width = 600
    Height = 320
    Hint = ''
    DataSource = dsSources
    ReadOnly = True
    WebOptions.Paged = False
    LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
    ForceFit = True
    Align = alClient
    TabOrder = 1
    Columns = <
      item
        FieldName = 'name'
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Width = 200
        ReadOnly = True
      end
      item
        FieldName = 'sid'
        Title.Caption = 'SID'
        Width = 120
        ReadOnly = True
      end
      item
        FieldName = 'last_insert'
        Title.Caption = #1055#1086#1089#1083#1077#1076'. '#1074#1089#1090#1072#1074#1082#1072
        Width = 160
        ReadOnly = True
      end>
  end
  object dsSources: TDataSource
    DataSet = mtSources
    Left = 64
    Top = 88
  end
  object mtSources: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'sid'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'last_insert'
        DataType = ftDateTime
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
    object mtSourcessid: TStringField
      FieldName = 'sid'
      Size = 64
    end
    object mtSourcesname: TStringField
      FieldName = 'name'
      Size = 255
    end
    object mtSourceslast_insert: TDateTimeField
      FieldName = 'last_insert'
      DisplayFormat = 'dd.mm.yyyy hh:nn:ss'
    end
  end
end
