object SourcesFrame: TSourcesFrame
  Left = 0
  Top = 0
  Width = 600
  Height = 320
  OnCreate = UniFrameCreate
  OnDestroy = UniFrameDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object gridSources: TUniDBGrid
    Left = 0
    Top = 0
    Width = 600
    Height = 320
    Hint = ''
    DataSource = dsSources
    LoadMask.Message = 'Loading...'
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    WebOptions.PageSize = 50
    Align = alClient
    TabOrder = 0
    Columns = <
      item
        FieldName = 'name'
        Title.Caption = #1048#1084#1103
        Width = 220
      end
      item
        FieldName = 'sid'
        Title.Caption = 'SID'
        Width = 120
      end
      item
        FieldName = 'last_insert'
        Title.Caption = #1055#1086#1089#1083#1077#1076'. '#1074#1099#1075#1088#1091#1079#1082#1072
        Width = 200
      end>
  end
  object dsSources: TDataSource
    DataSet = mtSources
    Left = 72
    Top = 96
  end
  object mtSources: TFDMemTable
    FieldDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 152
    Top = 96
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
