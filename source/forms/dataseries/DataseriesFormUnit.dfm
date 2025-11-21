object DataseriesForm: TDataseriesForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1000
  Caption = #1056#160#1057#1039#1056#1169#1057#8249' '#1056#1169#1056#176#1056#1029#1056#1029#1057#8249#1057#8230
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object cpLeft: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 600
    Hint = ''
    ParentColor = False
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 575
    object tvSources: TUniTreeView
      Left = 0
      Top = 0
      Width = 220
      Height = 600
      Hint = ''
      Items.FontData = {0100000000}
      Align = alClient
      TabOrder = 0
      Color = clWindow
      OnClick = tvSourcesClick
      ExplicitHeight = 575
    end
  end
  object splLeft: TUniSplitter
    Left = 220
    Top = 0
    Width = 4
    Height = 600
    Hint = ''
    Align = alLeft
    ParentColor = False
    Color = clBtnFace
    ExplicitHeight = 575
  end
  object cpCenter: TUniContainerPanel
    Left = 224
    Top = 0
    Width = 456
    Height = 600
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 448
    ExplicitHeight = 575
    object gridDataseries: TUniDBGrid
      Left = 0
      Top = 0
      Width = 456
      Height = 600
      Hint = ''
      DataSource = dsDataseries
      LoadMask.Message = 'Loading data...'
      Align = alClient
      TabOrder = 0
      OnSelectionChange = gridDataseriesSelectionChange
      OnDblClick = gridDataseriesDblClick
    end
  end
  object splRight: TUniSplitter
    Left = 680
    Top = 0
    Width = 4
    Height = 600
    Hint = ''
    Align = alRight
    ParentColor = False
    Color = clBtnFace
    ExplicitLeft = 672
    ExplicitHeight = 575
  end
  object cpRight: TUniContainerPanel
    Left = 684
    Top = 0
    Width = 316
    Height = 600
    Hint = ''
    ParentColor = False
    Align = alRight
    TabOrder = 2
    ExplicitLeft = 676
    ExplicitHeight = 575
    object cpInfoHeader: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 316
      Height = 40
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 0
      object lInfoTitle: TUniLabel
        Left = 8
        Top = 12
        Width = 273
        Height = 13
        Hint = ''
        Caption = #1056#152#1056#1029#1057#8222#1056#1109#1057#1026#1056#1112#1056#176#1057#8224#1056#1105#1057#1039' '#1056#1109' '#1057#1026#1057#1039#1056#1169#1056#181' '#1056#1169#1056#176#1056#1029#1056#1029#1057#8249#1057#8230
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 1
      end
    end
    object cpInfoBody: TUniContainerPanel
      Left = 0
      Top = 40
      Width = 316
      Height = 560
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 1
      ExplicitHeight = 535
      object lDsId: TUniLabel
        Left = 8
        Top = 8
        Width = 26
        Height = 13
        Hint = ''
        Caption = 'DsId:'
        TabOrder = 1
      end
      object lDsIdValue: TUniLabel
        Left = 120
        Top = 8
        Width = 180
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 2
      end
      object lName: TUniLabel
        Left = 8
        Top = 32
        Width = 33
        Height = 13
        Hint = ''
        Caption = #1056#152#1056#1112#1057#1039':'
        TabOrder = 3
      end
      object lNameValue: TUniLabel
        Left = 120
        Top = 32
        Width = 180
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 4
      end
      object lCaption: TUniLabel
        Left = 8
        Top = 56
        Width = 90
        Height = 13
        Hint = ''
        Caption = #1056#1116#1056#176#1056#183#1056#1030#1056#176#1056#1029#1056#1105#1056#181':'
        TabOrder = 5
      end
      object lCaptionValue: TUniLabel
        Left = 120
        Top = 56
        Width = 180
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 6
      end
      object lDstId: TUniLabel
        Left = 8
        Top = 80
        Width = 30
        Height = 13
        Hint = ''
        Caption = 'DstId:'
        TabOrder = 7
      end
      object lDstIdValue: TUniLabel
        Left = 120
        Top = 80
        Width = 180
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 8
      end
      object lBeginObs: TUniLabel
        Left = 8
        Top = 104
        Width = 145
        Height = 13
        Hint = ''
        Caption = #1056#1116#1056#176#1057#8225#1056#176#1056#187#1056#1109' '#1056#1029#1056#176#1056#177#1056#187#1057#1035#1056#1169':'
        TabOrder = 9
      end
      object lBeginObsValue: TUniLabel
        Left = 120
        Top = 104
        Width = 180
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 10
      end
      object lEndObs: TUniLabel
        Left = 8
        Top = 128
        Width = 141
        Height = 13
        Hint = ''
        Caption = #1056#1113#1056#1109#1056#1029#1056#181#1057#8224' '#1056#1029#1056#176#1056#177#1056#187#1057#1035#1056#1169':'
        TabOrder = 11
      end
      object lEndObsValue: TUniLabel
        Left = 120
        Top = 128
        Width = 180
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 12
      end
      object lState: TUniLabel
        Left = 8
        Top = 152
        Width = 69
        Height = 13
        Hint = ''
        Caption = #1056#1038#1057#8218#1056#176#1057#8218#1057#1107#1057#1027':'
        TabOrder = 13
      end
      object lStateValue: TUniLabel
        Left = 120
        Top = 152
        Width = 180
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 14
      end
      object lLastData: TUniLabel
        Left = 8
        Top = 176
        Width = 207
        Height = 13
        Hint = ''
        Caption = #1056#1119#1056#1109#1057#1027#1056#187#1056#181#1056#1169#1056#1029#1056#181#1056#181' '#1056#183#1056#1029#1056#176#1057#8225#1056#181#1056#1029#1056#1105#1056#181':'
        TabOrder = 15
      end
      object lLastDataValue: TUniLabel
        Left = 120
        Top = 176
        Width = 180
        Height = 13
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 16
      end
    end
  end
  object dsDataseries: TDataSource
    DataSet = mtDataseries
    Left = 328
    Top = 248
  end
  object mtDataseries: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
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
