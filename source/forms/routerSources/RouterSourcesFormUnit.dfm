inherited RouterSourcesForm: TRouterSourcesForm
  Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080' '#1084#1072#1088#1096#1088#1091#1090#1080#1079#1072#1090#1086#1088#1072
  ExplicitWidth = 1176
  ExplicitHeight = 606
  TextHeight = 15
  inherited dbgEntity: TUniDBGrid
    Columns = <
      item
        FieldName = 'caption'
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Width = 140
      end
      item
        FieldName = 'who'
        Title.Caption = #1048#1079
        Width = 218
      end
      item
        FieldName = 'service'
        Title.Caption = #1057#1077#1088#1074#1080#1089
        Width = 104
      end
      item
        FieldName = 'Created'
        Title.Caption = #1057#1086#1079#1076#1072#1085
        Width = 112
      end
      item
        FieldName = 'Updated'
        Title.Caption = #1048#1079#1084#1077#1085#1077#1085
        Width = 112
      end>
  end
  inherited pcEntityInfo: TUniPageControl
    inherited tsTaskInfo: TUniTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 372
      ExplicitHeight = 502
    end
  end
  inherited DatasourceEntity: TDataSource
    Left = 270
    Top = 84
  end
  inherited FDMemTableEntity: TFDMemTable
    Left = 428
    Top = 70
    object FDMemTableEntitycaption2: TStringField
      FieldName = 'caption'
      Size = 255
    end
    object FDMemTableEntitywho: TStringField
      FieldName = 'who'
      Size = 255
    end
    object FDMemTableEntitysercive: TStringField
      FieldName = 'service'
      Size = 255
    end
  end
end
