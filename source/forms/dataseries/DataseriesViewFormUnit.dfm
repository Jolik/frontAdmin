object DataseriesViewForm: TDataseriesViewForm
  Left = 0
  Top = 0
  ClientHeight = 320
  ClientWidth = 460
  Caption = #1056#160#1057#1039#1056#1169' '#1056#1169#1056#176#1056#1029#1056#1029#1057#8249#1057#8230
  BorderStyle = bsDialog
  OldCreateOrder = False
  BorderIcons = [biSystemMenu]
  MonitoredKeys.Keys = <>
  TextHeight = 15
  object cpHeader: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 460
    Height = 40
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 0
    object lTitle: TUniLabel
      Left = 8
      Top = 12
      Width = 193
      Height = 13
      Hint = ''
      Caption = #1056#152#1056#1029#1057#8222#1056#1109#1057#1026#1056#1112#1056#176#1057#8224#1056#1105#1057#1039' '#1056#1109' '#1057#1026#1057#1039#1056#1169#1056#181
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
  end
  object cpBody: TUniContainerPanel
    Left = 0
    Top = 40
    Width = 460
    Height = 240
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 1
    DesignSize = (
      460
      240)
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
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
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
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
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
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
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
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 8
    end
    object lSid: TUniLabel
      Left = 8
      Top = 104
      Width = 19
      Height = 13
      Hint = ''
      Caption = 'Sid:'
      TabOrder = 9
    end
    object lSidValue: TUniLabel
      Left = 120
      Top = 104
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 10
    end
    object lBeginObs: TUniLabel
      Left = 8
      Top = 128
      Width = 145
      Height = 13
      Hint = ''
      Caption = #1056#1116#1056#176#1057#8225#1056#176#1056#187#1056#1109' '#1056#1029#1056#176#1056#177#1056#187#1057#1035#1056#1169':'
      TabOrder = 11
    end
    object lBeginObsValue: TUniLabel
      Left = 120
      Top = 128
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 12
    end
    object lEndObs: TUniLabel
      Left = 8
      Top = 152
      Width = 141
      Height = 13
      Hint = ''
      Caption = #1056#1113#1056#1109#1056#1029#1056#181#1057#8224' '#1056#1029#1056#176#1056#177#1056#187#1057#1035#1056#1169':'
      TabOrder = 13
    end
    object lEndObsValue: TUniLabel
      Left = 120
      Top = 152
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 14
    end
    object lState: TUniLabel
      Left = 8
      Top = 176
      Width = 69
      Height = 13
      Hint = ''
      Caption = #1056#1038#1057#8218#1056#176#1057#8218#1057#1107#1057#1027':'
      TabOrder = 15
    end
    object lStateValue: TUniLabel
      Left = 120
      Top = 176
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 16
    end
    object lLastData: TUniLabel
      Left = 8
      Top = 200
      Width = 207
      Height = 13
      Hint = ''
      Caption = #1056#1119#1056#1109#1057#1027#1056#187#1056#181#1056#1169#1056#1029#1056#181#1056#181' '#1056#183#1056#1029#1056#176#1057#8225#1056#181#1056#1029#1056#1105#1056#181':'
      TabOrder = 17
    end
    object lLastDataValue: TUniLabel
      Left = 120
      Top = 200
      Width = 330
      Height = 13
      Hint = ''
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 18
    end
  end
  object cpFooter: TUniContainerPanel
    Left = 0
    Top = 280
    Width = 460
    Height = 40
    Hint = ''
    ParentColor = False
    Align = alBottom
    TabOrder = 2
    object btnClose: TUniButton
      Left = 376
      Top = 8
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1056#8212#1056#176#1056#1108#1057#1026#1057#8249#1057#8218#1057#1034
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
end
