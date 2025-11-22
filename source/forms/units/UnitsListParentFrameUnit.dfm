inherited UnitsListParentFrame: TUnitsListParentFrame
  inherited dbgEntity: TUniDBGrid
    OnSelectionChange = dbgEntitySelectionChange
    Columns = <
      item
        FieldName = 'Uid'
        Title.Caption = 'UID'
        Width = 80
      end
      item
        FieldName = 'Name'
        Title.Caption = #1048#1084#1103
        Width = 120
      end
      item
        FieldName = 'def'
        Title.Caption = #1055#1086#1076#1087#1080#1089#1100
        Width = 140
      end
      item
        FieldName = 'WUnit'
        Title.Caption = 'WUnit'
        Width = 80
      end>
  end
  inherited pcEntityInfo: TUniPageControl
    inherited tsTaskInfo: TUniTabSheet
      inherited cpTaskInfo: TUniContainerPanel
        ExplicitHeight = 670
      end
    end
  end
  inherited splSplitter: TUniSplitter
    ExplicitLeft = 962
    ExplicitHeight = 698
  end
  inherited FDMemTableEntity: TFDMemTable
    object FDMemTableEntityUid: TStringField
      FieldName = 'Uid'
      Size = 100
    end
    object FDMemTableEntityWUnit: TStringField
      FieldName = 'WUnit'
      Size = 100
    end
  end
end
