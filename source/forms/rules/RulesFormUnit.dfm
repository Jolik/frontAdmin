inherited RulesForm: TRulesForm
  Caption = #1055#1088#1072#1074#1080#1083#1072' '#1084#1072#1088#1096#1088#1091#1090#1080#1079#1072#1094#1080#1080
  TextHeight = 15
  inherited dbgEntity: TUniDBGrid
    Columns = <
      item
        FieldName = 'Name'
        Title.Caption = #1048#1084#1103
        Width = 100
      end
      item
        FieldName = 'Caption'
        Title.Caption = 'Caption'
        Width = 304
      end
      item
        FieldName = 'Caption'
        Title.Caption = #1055#1086#1076#1087#1080#1089#1100
        Width = 100
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
  inherited DatasourceEntity: TDataSource
    Left = 270
    Top = 84
  end
  inherited FDMemTableEntity: TFDMemTable
    Left = 428
    Top = 70
    object CredMemFDMemTableEntityCaption2: TStringField
      FieldName = 'Caption'
      Size = 50
    end
  end
end
