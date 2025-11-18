inherited DsGroupsForm: TDsGroupsForm
  Caption = #1043#1088#1091#1087#1087#1099' '#1076#1072#1090#1072#1089#1077#1088#1080#1081
  TextHeight = 15
  inherited tbEntity: TUniToolBar
    ExplicitWidth = 1158
  end
  inherited dbgEntity: TUniDBGrid
    Columns = <
      item
        FieldName = 'Name'
        Title.Caption = #1048#1084#1103
        Width = 100
      end
      item
        FieldName = 'type'
        Title.Caption = #1058#1080#1087
        Width = 124
      end
      item
        FieldName = 'sid'
        Title.Caption = #1048#1089#1090#1086#1095#1085#1080#1082
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
  inherited splSplitter: TUniSplitter
    ExplicitLeft = 772
    ExplicitHeight = 530
  end
  inherited pcEntityInfo: TUniPageControl
    ExplicitLeft = 778
    ExplicitHeight = 530
    inherited tsTaskInfo: TUniTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 372
      ExplicitHeight = 502
      inherited cpTaskInfo: TUniContainerPanel
        ExplicitHeight = 502
        inherited lTaskCaption: TUniLabel
          Caption = #1043#1088#1091#1087#1087#1072' '#1076#1072#1085#1085#1099#1093
        end
      end
    end
  end
  inherited DatasourceEntity: TDataSource
    Top = 84
  end
  inherited FDMemTableEntity: TFDMemTable
    Left = 416
    Top = 72
    object CredMemFDMemTableEntitysid: TStringField
      FieldName = 'sid'
      Size = 16
    end
    object CredMemFDMemTableEntitytype: TStringField
      FieldName = 'type'
    end
  end
end
