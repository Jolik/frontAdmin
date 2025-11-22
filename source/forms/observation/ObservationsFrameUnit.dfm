inherited ObservationsFrame: TObservationsFrame
  object gridObservation: TUniDBGrid
    Left = 0
    Top = 0
    Width = 365
    Height = 480
    Hint = ''
    DataSource = dsObservation
    LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
    Align = alClient
    TabOrder = 0
    OnSelectionChange = gridObservationSelectionChange
    Columns = <
      item
        FieldName = 'oid'
        Title.Caption = 'OID'
        Width = 80
      end
      item
        FieldName = 'name'
        Title.Caption = 'Name'
        Width = 90
      end
      item
        FieldName = 'caption'
        Title.Caption = 'Caption'
        Width = 95
      end>
  end
  object splObservation: TUniSplitter
    Left = 365
    Top = 0
    Width = 5
    Height = 480
    Hint = ''
    Align = alRight
    ParentColor = False
    Color = clBtnFace
  end
  object cpObservationInfo: TUniContainerPanel
    Left = 370
    Top = 0
    Width = 630
    Height = 480
    Hint = ''
    ParentColor = False
    Align = alRight
    TabOrder = 2
    object cpObservationInfoHeader: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 630
      Height = 40
      Hint = ''
      ParentColor = False
      Color = 14540253
      Align = alTop
      TabOrder = 1
      object lObservationInfoTitle: TUniLabel
        Left = 16
        Top = 12
        Width = 158
        Height = 13
        Hint = ''
        Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1085#1072#1073#1083#1102#1076#1077#1085#1080#1080
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 1
      end
    end
    object cpObservationInfoStatus: TUniContainerPanel
      Left = 0
      Top = 40
      Width = 630
      Height = 32
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 2
      object lObservationListStatus: TUniLabel
        Left = 16
        Top = 8
        Width = 61
        Height = 13
        Hint = ''
        Caption = #1053#1077#1090' '#1076#1072#1085#1085#1099#1093
        TabOrder = 1
      end
    end
    object cpObservationInfoOid: TUniContainerPanel
      Left = 0
      Top = 72
      Width = 630
      Height = 48
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 3
      object lObservationOid: TUniLabel
        Left = 16
        Top = 6
        Width = 23
        Height = 13
        Hint = ''
        Caption = 'OID:'
        TabOrder = 1
      end
      object lObservationOidValue: TUniLabel
        Left = 16
        Top = 24
        Width = 598
        Height = 17
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 2
      end
    end
    object cpObservationInfoName: TUniContainerPanel
      Left = 0
      Top = 120
      Width = 630
      Height = 48
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 4
      object lObservationName: TUniLabel
        Left = 16
        Top = 6
        Width = 32
        Height = 13
        Hint = ''
        Caption = 'Name:'
        TabOrder = 1
      end
      object lObservationNameValue: TUniLabel
        Left = 16
        Top = 24
        Width = 598
        Height = 17
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 2
      end
    end
    object cpObservationInfoCaption: TUniContainerPanel
      Left = 0
      Top = 168
      Width = 630
      Height = 48
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 5
      object lObservationCaption: TUniLabel
        Left = 16
        Top = 6
        Width = 44
        Height = 13
        Hint = ''
        Caption = 'Caption:'
        TabOrder = 1
      end
      object lObservationCaptionValue: TUniLabel
        Left = 16
        Top = 24
        Width = 598
        Height = 17
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 2
      end
    end
    object cpObservationInfoUid: TUniContainerPanel
      Left = 0
      Top = 216
      Width = 630
      Height = 48
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 6
      object lObservationUid: TUniLabel
        Left = 16
        Top = 6
        Width = 22
        Height = 13
        Hint = ''
        Caption = 'UID:'
        TabOrder = 1
      end
      object lObservationUidValue: TUniLabel
        Left = 16
        Top = 24
        Width = 598
        Height = 17
        Hint = ''
        AutoSize = False
        Caption = ''
        TabOrder = 2
      end
    end
    object cpObservationInfoDsTypes: TUniContainerPanel
      Left = 0
      Top = 264
      Width = 630
      Height = 216
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 7
      object lObservationDsTypes: TUniLabel
        AlignWithMargins = True
        Left = 16
        Top = 3
        Width = 142
        Height = 13
        Hint = ''
        Margins.Left = 16
        Margins.Right = 16
        Caption = #1058#1080#1087#1099' '#1076#1072#1085#1085#1099#1093' '#1085#1072#1073#1083#1102#1076#1077#1085#1080#1103':'
        Align = alTop
        TabOrder = 1
      end
      object gridDsTypes: TUniDBGrid
        AlignWithMargins = True
        Left = 16
        Top = 22
        Width = 598
        Height = 178
        Hint = ''
        Margins.Left = 16
        Margins.Right = 16
        Margins.Bottom = 16
        DataSource = dsDsTypes
        LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
        Align = alClient
        TabOrder = 2
        Columns = <
          item
            FieldName = 'name'
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Width = 400
          end>
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
  object dsDsTypes: TDataSource
    DataSet = mtDsTypes
    Left = 80
    Top = 168
  end
  object mtDsTypes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 144
    Top = 168
    object mtDsTypesdstid: TStringField
      FieldName = 'dstid'
      Size = 80
    end
    object mtDsTypesname: TStringField
      FieldName = 'name'
      Size = 255
    end
    object mtDsTypescaption: TStringField
      FieldName = 'caption'
      Size = 255
    end
    object mtDsTypesuid: TStringField
      FieldName = 'uid'
      Size = 80
    end
  end
end
