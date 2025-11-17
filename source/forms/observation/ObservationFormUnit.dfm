object ObservationForm: TObservationForm
  Left = 0
  Top = 0
  Caption = 'Наблюдения'
  ClientHeight = 540
  ClientWidth = 900
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 13
  object gridObservation: TUniDBGrid
    Left = 0
    Top = 0
    Width = 580
    Height = 540
    Hint = ''
    DataSource = dsObservation
    LoadMask.Message = 'Загрузка...'
    Align = alClient
    TabOrder = 0
    OnSelectionChange = gridObservationSelectionChange
  end
  object splObservation: TUniSplitter
    Left = 580
    Top = 0
    Width = 5
    Height = 540
    Cursor = crHSplit
    Align = alRight
  end
  object cpObservationInfo: TUniContainerPanel
    Left = 585
    Top = 0
    Width = 315
    Height = 540
    Hint = ''
    Align = alRight
    TabOrder = 2
    object cpObservationInfoHeader: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 315
      Height = 40
      Hint = ''
      Align = alTop
      ParentColor = False
      Color = 14540253
      TabOrder = 1
      object lObservationInfoTitle: TUniLabel
        Left = 16
        Top = 12
        Width = 200
        Height = 18
        Hint = ''
        Caption = 'Информация о наблюдении'
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 1
      end
    end
    object cpObservationInfoStatus: TUniContainerPanel
      Left = 0
      Top = 40
      Width = 315
      Height = 32
      Hint = ''
      Align = alTop
      TabOrder = 2
      object lObservationListStatus: TUniLabel
        Left = 16
        Top = 8
        Width = 283
        Height = 17
        Hint = ''
        Caption = 'Нет данных'
        TabOrder = 1
      end
    end
    object cpObservationInfoOid: TUniContainerPanel
      Left = 0
      Top = 72
      Width = 315
      Height = 48
      Hint = ''
      Align = alTop
      TabOrder = 3
      object lObservationOid: TUniLabel
        Left = 16
        Top = 6
        Width = 39
        Height = 13
        Hint = ''
        Caption = 'OID:'
        TabOrder = 1
      end
      object lObservationOidValue: TUniLabel
        Left = 16
        Top = 24
        Width = 279
        Height = 17
        Hint = ''
        Caption = ''
        AutoSize = False
        TabOrder = 2
      end
    end
    object cpObservationInfoName: TUniContainerPanel
      Left = 0
      Top = 120
      Width = 315
      Height = 48
      Hint = ''
      Align = alTop
      TabOrder = 4
      object lObservationName: TUniLabel
        Left = 16
        Top = 6
        Width = 48
        Height = 13
        Hint = ''
        Caption = 'Name:'
        TabOrder = 1
      end
      object lObservationNameValue: TUniLabel
        Left = 16
        Top = 24
        Width = 279
        Height = 17
        Hint = ''
        Caption = ''
        AutoSize = False
        TabOrder = 2
      end
    end
    object cpObservationInfoCaption: TUniContainerPanel
      Left = 0
      Top = 168
      Width = 315
      Height = 48
      Hint = ''
      Align = alTop
      TabOrder = 5
      object lObservationCaption: TUniLabel
        Left = 16
        Top = 6
        Width = 56
        Height = 13
        Hint = ''
        Caption = 'Caption:'
        TabOrder = 1
      end
      object lObservationCaptionValue: TUniLabel
        Left = 16
        Top = 24
        Width = 279
        Height = 17
        Hint = ''
        Caption = ''
        AutoSize = False
        TabOrder = 2
      end
    end
    object cpObservationInfoUid: TUniContainerPanel
      Left = 0
      Top = 216
      Width = 315
      Height = 48
      Hint = ''
      Align = alTop
      TabOrder = 6
      object lObservationUid: TUniLabel
        Left = 16
        Top = 6
        Width = 27
        Height = 13
        Hint = ''
        Caption = 'UID:'
        TabOrder = 1
      end
      object lObservationUidValue: TUniLabel
        Left = 16
        Top = 24
        Width = 279
        Height = 17
        Hint = ''
        Caption = ''
        AutoSize = False
        TabOrder = 2
      end
    end
    object cpObservationInfoDsTypes: TUniContainerPanel
      Left = 0
      Top = 264
      Width = 315
      Height = 276
      Hint = ''
      Align = alClient
      TabOrder = 7
      object lObservationDsTypes: TUniLabel
        AlignWithMargins = True
        Left = 16
        Top = 6
        Width = 283
        Height = 18
        Hint = ''
        Align = alTop
        Margins.Left = 16
        Margins.Right = 16
        Caption = 'Типы данных наблюдения:'
        TabOrder = 1
      end
      object memoObservationDsTypes: TUniMemo
        AlignWithMargins = True
        Left = 16
        Top = 24
        Width = 283
        Height = 240
        Hint = ''
        Align = alClient
        Margins.Left = 16
        Margins.Right = 16
        Margins.Bottom = 16
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
    end
  end
  object dsObservation: TDataSource
    DataSet = mtObservation
    Left = 80
    Top = 88
  end
  object mtObservation: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 144
    Top = 88
    object mtObservationoid: TStringField
      FieldName = 'oid'
      Size = 80
    end
    object mtObservationname: TStringField
      FieldName = 'name'
      Size = 255
    end
    object mtObservationcaption: TStringField
      FieldName = 'caption'
      Size = 255
    end
  end
end
