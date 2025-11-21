object LinksFrame: TLinksFrame
  Left = 0
  Top = 0
  Width = 600
  Height = 320
  Align = alClient
  ParentFont = False
  TabOrder = 0
  OnCreate = UniFrameCreate
  OnDestroy = UniFrameDestroy
  object gridLinks: TUniDBGrid
    Left = 0
    Top = 0
    Width = 600
    Height = 320
    Hint = ''
    DataSource = dsLinks
    ReadOnly = True
    WebOptions.Paged = False
    LoadMask.Message = #1047#1072#1075#1088#1091#1079#1082#1072'...'
    ForceFit = True
    Align = alClient
    TabOrder = 1
    Columns = <
      item
        FieldName = 'lid'
        Title.Caption = 'LID'
        Width = 100
        ReadOnly = True
      end
      item
        FieldName = 'type'
        Title.Caption = #1058#1080#1087
        Width = 140
        ReadOnly = True
      end
      item
        FieldName = 'dir'
        Title.Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
        Width = 120
        ReadOnly = True
      end
      item
        FieldName = 'status'
        Title.Caption = #1057#1090#1072#1090#1091#1089
        Width = 120
        ReadOnly = True
      end
      item
        FieldName = 'comsts'
        Title.Caption = 'Com status'
        Width = 120
        ReadOnly = True
      end
      item
        FieldName = 'last_activity_time'
        Title.Caption = #1055#1086#1089#1083#1077#1076'. '#1072#1082#1090#1080#1074#1085#1086#1089#1090#1100
        Width = 180
        ReadOnly = True
      end>
  end
  object dsLinks: TDataSource
    DataSet = mtLinks
    Left = 64
    Top = 88
  end
  object mtLinks: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'lid'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'type'
        DataType = ftString
        Size = 128
      end
      item
        Name = 'dir'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'status'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'comsts'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'last_activity_time'
        DataType = ftDateTime
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 136
    Top = 88
    object mtLinkslid: TStringField
      FieldName = 'lid'
      Size = 64
    end
    object mtLinkstype: TStringField
      FieldName = 'type'
      Size = 128
    end
    object mtLinksdir: TStringField
      FieldName = 'dir'
      Size = 64
    end
    object mtLinksstatus: TStringField
      FieldName = 'status'
      Size = 64
    end
    object mtLinkscomsts: TStringField
      FieldName = 'comsts'
      Size = 64
    end
    object mtLinkslast_activity_time: TDateTimeField
      FieldName = 'last_activity_time'
      DisplayFormat = 'dd.mm.yyyy hh:nn:ss'
    end
  end
end
