object SearchForm: TSearchForm
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 1100
  Caption = #1055#1086#1080#1089#1082' '#1082#1086#1085#1090#1077#1085#1090#1072
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object pnlContent: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 600
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 0
    object gridContent: TUniDBGrid
      Left = 0
      Top = 0
      Width = 820
      Height = 460
      Hint = ''
      DataSource = dsContent
      ReadOnly = True
      LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
      ForceFit = True
      Align = alClient
      TabOrder = 1
      Columns = <
        item
          FieldName = 'jrid'
          Title.Caption = 'ID'
          Width = 120
          ReadOnly = True
        end
        item
          FieldName = 'name'
          Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          Width = 200
          ReadOnly = True
        end
        item
          FieldName = 'who'
          Title.Caption = #1050#1090#1086
          Width = 160
          ReadOnly = True
        end
        item
          FieldName = 'key'
          Title.Caption = 'Key'
          Width = 120
          ReadOnly = True
        end
        item
          FieldName = 'time'
          Title.Caption = #1042#1088#1077#1084#1103
          Width = 140
          ReadOnly = True
        end
        item
          FieldName = 'size'
          Title.Caption = #1056#1072#1079#1084#1077#1088
          Width = 80
          ReadOnly = True
        end>
    end
    object cpSearchInfo: TUniContainerPanel
      Left = 0
      Top = 460
      Width = 820
      Height = 140
      Hint = ''
      ParentColor = False
      Align = alBottom
      TabOrder = 2
      object lSearchId: TUniLabel
        Left = 16
        Top = 12
        Width = 120
        Height = 16
        Hint = ''
        Caption = 'ID '
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 1
      end
      object lSearchIdValue: TUniLabel
        Left = 160
        Top = 12
        Width = 600
        Height = 16
        Hint = ''
        Caption = ''
        TabOrder = 2
      end
      object lSearchStatus: TUniLabel
        Left = 16
        Top = 40
        Width = 120
        Height = 16
        Hint = ''
        Caption = #1057#1090#1072#1090#1091#1089
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 3
      end
      object lSearchStatusValue: TUniLabel
        Left = 160
        Top = 40
        Width = 600
        Height = 16
        Hint = ''
        Caption = ''
        TabOrder = 4
      end
      object lSearchProgress: TUniLabel
        Left = 16
        Top = 68
        Width = 120
        Height = 16
        Hint = ''
        Caption = #1053#1072#1081#1076#1077#1085#1086'/'#1074#1089#1077#1075#1086
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 5
      end
      object lSearchProgressValue: TUniLabel
        Left = 160
        Top = 68
        Width = 200
        Height = 16
        Hint = ''
        Caption = ''
        TabOrder = 6
      end
      object lSearchCache: TUniLabel
        Left = 380
        Top = 68
        Width = 120
        Height = 16
        Hint = ''
        Caption = #1042' '#1082#1101#1096#1077
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 7
      end
      object lSearchCacheValue: TUniLabel
        Left = 516
        Top = 68
        Width = 120
        Height = 16
        Hint = ''
        Caption = ''
        TabOrder = 8
      end
      object lSearchInterval: TUniLabel
        Left = 16
        Top = 96
        Width = 120
        Height = 16
        Hint = ''
        Caption = #1048#1085#1090#1077#1088#1074#1072#1083
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 9
      end
      object lSearchIntervalValue: TUniLabel
        Left = 160
        Top = 96
        Width = 600
        Height = 16
        Hint = ''
        Caption = ''
        TabOrder = 10
      end
    end
  end
  object cpSearchParams: TUniContainerPanel
    Left = 820
    Top = 0
    Width = 280
    Height = 600
    Hint = ''
    ParentColor = False
    Align = alRight
    TabOrder = 1
    object lParamsTitle: TUniLabel
      Left = 16
      Top = 16
      Width = 200
      Height = 20
      Hint = ''
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object lName: TUniLabel
      Left = 16
      Top = 56
      Width = 80
      Height = 16
      Hint = ''
      Caption = 'Name'
      TabOrder = 2
    end
    object teName: TUniEdit
      Left = 16
      Top = 72
      Width = 248
      Hint = ''
      Text = ''
      TabOrder = 3
    end
    object lKey: TUniLabel
      Left = 16
      Top = 112
      Width = 80
      Height = 16
      Hint = ''
      Caption = 'Key'
      TabOrder = 4
    end
    object teKey: TUniEdit
      Left = 16
      Top = 128
      Width = 248
      Hint = ''
      Text = ''
      TabOrder = 5
    end
    object cpSearchButtons: TUniContainerPanel
      Left = 0
      Top = 520
      Width = 280
      Height = 80
      Hint = ''
      ParentColor = False
      Align = alBottom
      TabOrder = 6
      object btnNew: TUniButton
        Left = 16
        Top = 8
        Width = 248
        Height = 25
        Hint = ''
        Caption = #1053#1072#1095#1072#1090#1100' '#1087#1086#1080#1089#1082
        TabOrder = 1
        OnClick = btnNewClick
      end
      object btnAbort: TUniButton
        Left = 16
        Top = 40
        Width = 248
        Height = 25
        Hint = ''
        Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
        TabOrder = 2
        OnClick = btnAbortClick
      end
    end
  end
  object dsContent: TDataSource
    DataSet = mtContent
    Left = 48
    Top = 488
  end
  object mtContent: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    Left = 120
    Top = 488
    object mtContentjrid: TStringField
      FieldName = 'jrid'
      Size = 64
    end
    object mtContentname: TStringField
      FieldName = 'name'
      Size = 255
    end
    object mtContentwho: TStringField
      FieldName = 'who'
      Size = 255
    end
    object mtContentkey: TStringField
      FieldName = 'key'
      Size = 255
    end
    object mtContenttime: TDateTimeField
      FieldName = 'time'
    end
    object mtContentsize: TIntegerField
      FieldName = 'size'
    end
  end
  object SearchTimer: TUniTimer
    Enabled = False
    Interval = 1000
    OnTimer = SearchTimerTimer
    Left = 192
    Top = 488
  end
end
