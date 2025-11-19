object LogViewForm: TLogViewForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1000
  Caption = 'Логи'
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 13
  object cpMain: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 600
    Align = alClient
    ParentColor = False
    Color = clBtnFace
    TabOrder = 0
    object pnlGrid: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 708
      Height = 600
      Align = alClient
      TabOrder = 0
      object gridLogs: TUniDBGrid
        Left = 0
        Top = 0
        Width = 708
        Height = 600
        Align = alClient
        TabOrder = 0
        DataSource = dsLogs
        OnDblClick = gridLogsDblClick
      end
    end
    object splFilters: TUniSplitter
      Left = 708
      Top = 0
      Width = 6
      Height = 600
      Align = alRight
    end
    object pnlFilters: TUniContainerPanel
      Left = 714
      Top = 0
      Width = 286
      Height = 600
      Align = alRight
      TabOrder = 1
      object lParamsTitle: TUniLabel
        Left = 16
        Top = 16
        Width = 177
        Height = 13
        Caption = 'Параметры запроса'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lQuery: TUniLabel
        Left = 16
        Top = 48
        Width = 70
        Height = 13
        Caption = 'Query'
      end
      object edQuery: TUniEdit
        Left = 16
        Top = 64
        Width = 250
        Height = 22
        TabOrder = 1
      end
      object lStart: TUniLabel
        Left = 16
        Top = 96
        Width = 88
        Height = 13
        Caption = 'Start (RFC3339)'
      end
      object edStart: TUniEdit
        Left = 16
        Top = 112
        Width = 250
        Height = 22
        TabOrder = 2
      end
      object lEnd: TUniLabel
        Left = 16
        Top = 144
        Width = 80
        Height = 13
        Caption = 'End (RFC3339)'
      end
      object edEnd: TUniEdit
        Left = 16
        Top = 160
        Width = 250
        Height = 22
        TabOrder = 3
      end
      object lStep: TUniLabel
        Left = 16
        Top = 192
        Width = 82
        Height = 13
        Caption = 'Step (seconds)'
      end
      object edStep: TUniEdit
        Left = 16
        Top = 208
        Width = 250
        Height = 22
        TabOrder = 4
      end
      object lLimit: TUniLabel
        Left = 16
        Top = 240
        Width = 61
        Height = 13
        Caption = 'Limit'
      end
      object edLimit: TUniEdit
        Left = 16
        Top = 256
        Width = 250
        Height = 22
        TabOrder = 5
      end
      object btnLoadLogs: TUniButton
        Left = 16
        Top = 296
        Width = 120
        Height = 25
        Caption = 'Загрузить'
        OnClick = btnLoadLogsClick
      end
      object btnClearFilters: TUniButton
        Left = 146
        Top = 296
        Width = 120
        Height = 25
        Caption = 'Очистить'
        OnClick = btnClearFiltersClick
      end
    end
  end
  object dsLogs: TDataSource
    DataSet = mtLogs
    Left = 96
    Top = 88
  end
  object mtLogs: TFDMemTable
    FieldDefs = <
      item
        Name = 'timestamp'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'payload'
        DataType = ftMemo
      end
      item
        Name = 'container_name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'filename'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'host'
        DataType = ftString
        Size = 128
      end
      item
        Name = 'source'
        DataType = ftString
        Size = 128
      end
      item
        Name = 'swarm_service'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'swarm_stack'
        DataType = ftString
        Size = 255
      end>
    IndexDefs = <>
    StoreDefs = True
    Left = 32
    Top = 88
    object mtLogstimestamp: TStringField
      FieldName = 'timestamp'
      Size = 64
    end
    object mtLogspayload: TMemoField
      FieldName = 'payload'
      BlobType = ftMemo
    end
    object mtLogscontainer_name: TStringField
      FieldName = 'container_name'
      Size = 255
    end
    object mtLogsfilename: TStringField
      FieldName = 'filename'
      Size = 255
    end
    object mtLogshost: TStringField
      FieldName = 'host'
      Size = 128
    end
    object mtLogssource: TStringField
      FieldName = 'source'
      Size = 128
    end
    object mtLogsswarm_service: TStringField
      FieldName = 'swarm_service'
      Size = 255
    end
    object mtLogsswarm_stack: TStringField
      FieldName = 'swarm_stack'
      Size = 255
    end
  end
end
