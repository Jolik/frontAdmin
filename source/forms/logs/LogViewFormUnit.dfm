object LogViewForm: TLogViewForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1000
  Caption = #1056#8250#1056#1109#1056#1110#1056#1105
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object cpMain: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 600
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 0
    object pnlGrid: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 708
      Height = 600
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 0
      object gridLogs: TUniDBGrid
        Left = 0
        Top = 0
        Width = 708
        Height = 600
        Hint = ''
        DataSource = dsLogs
        LoadMask.Message = 'Loading data...'
        Align = alClient
        TabOrder = 0
        OnDblClick = gridLogsDblClick
      end
    end
    object splFilters: TUniSplitter
      Left = 708
      Top = 0
      Width = 6
      Height = 600
      Hint = ''
      Align = alRight
      ParentColor = False
      Color = clBtnFace
    end
    object pnlFilters: TUniContainerPanel
      Left = 714
      Top = 0
      Width = 286
      Height = 600
      Hint = ''
      ParentColor = False
      Align = alRight
      TabOrder = 1
      object lParamsTitle: TUniLabel
        Left = 16
        Top = 16
        Width = 196
        Height = 13
        Hint = ''
        Caption = #1056#1119#1056#176#1057#1026#1056#176#1056#1112#1056#181#1057#8218#1057#1026#1057#8249' '#1056#183#1056#176#1056#1111#1057#1026#1056#1109#1057#1027#1056#176
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 6
      end
      object lQuery: TUniLabel
        Left = 16
        Top = 48
        Width = 30
        Height = 13
        Hint = ''
        Caption = 'Query'
        TabOrder = 7
      end
      object edQuery: TUniEdit
        Left = 16
        Top = 64
        Width = 250
        Hint = ''
        Text = ''
        TabOrder = 1
      end
      object lStart: TUniLabel
        Left = 16
        Top = 96
        Width = 77
        Height = 13
        Hint = ''
        Caption = 'Start (RFC3339)'
        TabOrder = 8
      end
      object edStart: TUniEdit
        Left = 16
        Top = 112
        Width = 250
        Hint = ''
        Text = ''
        TabOrder = 2
      end
      object lEnd: TUniLabel
        Left = 16
        Top = 144
        Width = 73
        Height = 13
        Hint = ''
        Caption = 'End (RFC3339)'
        TabOrder = 9
      end
      object edEnd: TUniEdit
        Left = 16
        Top = 160
        Width = 250
        Hint = ''
        Text = ''
        TabOrder = 3
      end
      object lStep: TUniLabel
        Left = 16
        Top = 192
        Width = 74
        Height = 13
        Hint = ''
        Caption = 'Step (seconds)'
        TabOrder = 10
      end
      object edStep: TUniEdit
        Left = 16
        Top = 208
        Width = 250
        Hint = ''
        Text = ''
        TabOrder = 4
      end
      object lLimit: TUniLabel
        Left = 16
        Top = 240
        Width = 24
        Height = 13
        Hint = ''
        Caption = 'Limit'
        TabOrder = 11
      end
      object edLimit: TUniEdit
        Left = 16
        Top = 256
        Width = 250
        Hint = ''
        Text = ''
        TabOrder = 5
      end
      object btnLoadLogs: TUniButton
        Left = 16
        Top = 296
        Width = 120
        Height = 25
        Hint = ''
        Caption = #1056#8212#1056#176#1056#1110#1057#1026#1057#1107#1056#183#1056#1105#1057#8218#1057#1034
        TabOrder = 12
        OnClick = btnLoadLogsClick
      end
      object btnClearFilters: TUniButton
        Left = 146
        Top = 296
        Width = 120
        Height = 25
        Hint = ''
        Caption = #1056#1115#1057#8225#1056#1105#1057#1027#1057#8218#1056#1105#1057#8218#1057#1034
        TabOrder = 13
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
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
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
