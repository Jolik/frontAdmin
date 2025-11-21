object DataseriesForm: TDataseriesForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1000
  Caption = 'Ряды данных'
  BorderStyle = bsSizeable
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 13
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  object cpLeft: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 600
    Align = alLeft
    TabOrder = 0
    object tvSources: TUniTreeView
      Left = 0
      Top = 0
      Width = 220
      Height = 600
      Align = alClient
      TabOrder = 0
      OnClick = tvSourcesClick
    end
  end
  object splLeft: TUniSplitter
    Left = 220
    Top = 0
    Width = 4
    Height = 600
    Align = alLeft
    ResizeAnchor = akLeft
  end
  object cpCenter: TUniContainerPanel
    Left = 224
    Top = 0
    Width = 456
    Height = 600
    Align = alClient
    TabOrder = 1
    object gridDataseries: TUniDBGrid
      Left = 0
      Top = 0
      Width = 456
      Height = 600
      Align = alClient
      DataSource = dsDataseries
      TabOrder = 0
      OnDblClick = gridDataseriesDblClick
      OnSelectionChange = gridDataseriesSelectionChange
    end
  end
  object splRight: TUniSplitter
    Left = 680
    Top = 0
    Width = 4
    Height = 600
    Align = alRight
    ResizeAnchor = akRight
  end
  object cpRight: TUniContainerPanel
    Left = 684
    Top = 0
    Width = 316
    Height = 600
    Align = alRight
    TabOrder = 2
    object cpInfoHeader: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 316
      Height = 40
      Align = alTop
      TabOrder = 0
      object lInfoTitle: TUniLabel
        Left = 8
        Top = 12
        Width = 180
        Height = 16
        Caption = 'Информация о ряде данных'
        ParentFont = False
        Font.Style = [fsBold]
      end
    end
    object cpInfoBody: TUniContainerPanel
      Left = 0
      Top = 40
      Width = 316
      Height = 560
      Align = alClient
      TabOrder = 1
      object lDsId: TUniLabel
        Left = 8
        Top = 8
        Width = 50
        Height = 13
        Caption = 'DsId:'
      end
      object lDsIdValue: TUniLabel
        Left = 120
        Top = 8
        Width = 180
        Height = 13
        AutoSize = False
      end
      object lName: TUniLabel
        Left = 8
        Top = 32
        Width = 50
        Height = 13
        Caption = 'Имя:'
      end
      object lNameValue: TUniLabel
        Left = 120
        Top = 32
        Width = 180
        Height = 13
        AutoSize = False
      end
      object lCaption: TUniLabel
        Left = 8
        Top = 56
        Width = 60
        Height = 13
        Caption = 'Название:'
      end
      object lCaptionValue: TUniLabel
        Left = 120
        Top = 56
        Width = 180
        Height = 13
        AutoSize = False
      end
      object lDstId: TUniLabel
        Left = 8
        Top = 80
        Width = 40
        Height = 13
        Caption = 'DstId:'
      end
      object lDstIdValue: TUniLabel
        Left = 120
        Top = 80
        Width = 180
        Height = 13
        AutoSize = False
      end
      object lBeginObs: TUniLabel
        Left = 8
        Top = 104
        Width = 90
        Height = 13
        Caption = 'Начало наблюд:'
      end
      object lBeginObsValue: TUniLabel
        Left = 120
        Top = 104
        Width = 180
        Height = 13
        AutoSize = False
      end
      object lEndObs: TUniLabel
        Left = 8
        Top = 128
        Width = 80
        Height = 13
        Caption = 'Конец наблюд:'
      end
      object lEndObsValue: TUniLabel
        Left = 120
        Top = 128
        Width = 180
        Height = 13
        AutoSize = False
      end
      object lState: TUniLabel
        Left = 8
        Top = 152
        Width = 50
        Height = 13
        Caption = 'Статус:'
      end
      object lStateValue: TUniLabel
        Left = 120
        Top = 152
        Width = 180
        Height = 13
        AutoSize = False
      end
      object lLastData: TUniLabel
        Left = 8
        Top = 176
        Width = 110
        Height = 13
        Caption = 'Последнее значение:'
      end
      object lLastDataValue: TUniLabel
        Left = 120
        Top = 176
        Width = 180
        Height = 13
        AutoSize = False
      end
    end
  end
  object dsDataseries: TDataSource
    Left = 328
    Top = 248
    DataSet = mtDataseries
  end
  object mtDataseries: TFDMemTable
    Left = 400
    Top = 248
    object mtDataseriesdsid: TStringField
      FieldName = 'dsid'
      Size = 120
    end
    object mtDataseriesname: TStringField
      FieldName = 'name'
      Size = 120
    end
    object mtDataseriescaption: TStringField
      FieldName = 'caption'
      Size = 255
    end
    object mtDataseriesdstid: TStringField
      FieldName = 'dstid'
      Size = 120
    end
  end
end
