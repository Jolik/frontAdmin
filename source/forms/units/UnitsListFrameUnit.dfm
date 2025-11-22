inherited UnitsListFrame: TUnitsListFrame
  inherited tbEntity: TUniToolBar
    ExplicitWidth = 1348
  end
  inherited dbgEntity: TUniDBGrid
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
      end>
  end
  inherited pcEntityInfo: TUniPageControl
    ExplicitLeft = 968
    ExplicitHeight = 698
    inherited tsTaskInfo: TUniTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 372
      ExplicitHeight = 670
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
  end
end
