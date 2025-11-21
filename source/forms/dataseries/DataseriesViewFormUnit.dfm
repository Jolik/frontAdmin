object DataseriesViewForm: TDataseriesViewForm
  Left = 0
  Top = 0
  ClientHeight = 320
  ClientWidth = 460
  Caption = 'Ряд данных'
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Position = poScreenCenter
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 13
  object cpHeader: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 460
    Height = 40
    Align = alTop
    TabOrder = 0
    object lTitle: TUniLabel
      Left = 8
      Top = 12
      Width = 120
      Height = 16
      Caption = 'Информация о ряде'
      ParentFont = False
      Font.Style = [fsBold]
    end
  end
  object cpBody: TUniContainerPanel
    Left = 0
    Top = 40
    Width = 460
    Height = 240
    Align = alClient
    TabOrder = 1
    DesignSize = (
      460
      240)
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
      Width = 330
      Height = 13
      AutoSize = False
      Caption = ''
      Anchors = [akLeft, akTop, akRight]
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
      Width = 330
      Height = 13
      AutoSize = False
      Anchors = [akLeft, akTop, akRight]
    end
    object lCaption: TUniLabel
      Left = 8
      Top = 56
      Width = 50
      Height = 13
      Caption = 'Название:'
    end
    object lCaptionValue: TUniLabel
      Left = 120
      Top = 56
      Width = 330
      Height = 13
      AutoSize = False
      Anchors = [akLeft, akTop, akRight]
    end
    object lDstId: TUniLabel
      Left = 8
      Top = 80
      Width = 50
      Height = 13
      Caption = 'DstId:'
    end
    object lDstIdValue: TUniLabel
      Left = 120
      Top = 80
      Width = 330
      Height = 13
      AutoSize = False
      Anchors = [akLeft, akTop, akRight]
    end
    object lSid: TUniLabel
      Left = 8
      Top = 104
      Width = 50
      Height = 13
      Caption = 'Sid:'
    end
    object lSidValue: TUniLabel
      Left = 120
      Top = 104
      Width = 330
      Height = 13
      AutoSize = False
      Anchors = [akLeft, akTop, akRight]
    end
    object lBeginObs: TUniLabel
      Left = 8
      Top = 128
      Width = 90
      Height = 13
      Caption = 'Начало наблюд:'
    end
    object lBeginObsValue: TUniLabel
      Left = 120
      Top = 128
      Width = 330
      Height = 13
      AutoSize = False
      Anchors = [akLeft, akTop, akRight]
    end
    object lEndObs: TUniLabel
      Left = 8
      Top = 152
      Width = 80
      Height = 13
      Caption = 'Конец наблюд:'
    end
    object lEndObsValue: TUniLabel
      Left = 120
      Top = 152
      Width = 330
      Height = 13
      AutoSize = False
      Anchors = [akLeft, akTop, akRight]
    end
    object lState: TUniLabel
      Left = 8
      Top = 176
      Width = 60
      Height = 13
      Caption = 'Статус:'
    end
    object lStateValue: TUniLabel
      Left = 120
      Top = 176
      Width = 330
      Height = 13
      AutoSize = False
      Anchors = [akLeft, akTop, akRight]
    end
    object lLastData: TUniLabel
      Left = 8
      Top = 200
      Width = 100
      Height = 13
      Caption = 'Последнее значение:'
    end
    object lLastDataValue: TUniLabel
      Left = 120
      Top = 200
      Width = 330
      Height = 13
      AutoSize = False
      Anchors = [akLeft, akTop, akRight]
    end
  end
  object cpFooter: TUniContainerPanel
    Left = 0
    Top = 280
    Width = 460
    Height = 40
    Align = alBottom
    TabOrder = 2
    object btnClose: TUniButton
      Left = 376
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Закрыть'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
end
