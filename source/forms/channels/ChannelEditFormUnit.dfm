inherited ChannelEditForm: TChannelEditForm
  ClientHeight = 813
  ClientWidth = 882
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1072#1085#1072#1083#1072'...'
  ExplicitWidth = 900
  ExplicitHeight = 860
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Top = 763
    Width = 882
    ExplicitTop = 488
    ExplicitWidth = 880
    inherited btnOk: TUniButton
      Left = 723
      ExplicitLeft = 721
    end
    inherited btnCancel: TUniButton
      Left = 804
      ExplicitLeft = 802
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 882
    Visible = False
    ExplicitWidth = 880
    inherited teCaption: TUniEdit
      Left = 96
      Width = 783
      ExplicitLeft = 96
      ExplicitWidth = 781
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 882
    ExplicitWidth = 880
    inherited teName: TUniEdit
      Left = 96
      Width = 783
      ExplicitLeft = 96
      ExplicitWidth = 781
    end
  end
  inherited pnClient: TUniContainerPanel
    Top = 108
    Width = 882
    Height = 655
    ExplicitTop = 108
    ExplicitWidth = 880
    ExplicitHeight = 380
    ScrollHeight = 414
    ScrollWidth = 819
    object panelLink: TUniPanel
      Left = 0
      Top = 0
      Width = 882
      Height = 193
      Hint = ''
      Align = alTop
      TabOrder = 1
      ShowCaption = False
      Caption = 'panelLink'
      object scrollBoxLinks: TUniScrollBox
        Left = 1
        Top = 1
        Width = 880
        Height = 191
        Hint = ''
        Align = alClient
        TabOrder = 1
      end
    end
    object UniSplitter1: TUniSplitter
      Left = 0
      Top = 193
      Width = 882
      Height = 6
      Cursor = crVSplit
      Hint = ''
      Align = alTop
      ParentColor = False
      Color = clBtnFace
    end
    object UniPanel2: TUniPanel
      Left = 0
      Top = 199
      Width = 882
      Height = 456
      Hint = ''
      Align = alClient
      TabOrder = 3
      Caption = 'panelQueue'
      ExplicitHeight = 189
      object scrollBoxQueue: TUniScrollBox
        Left = 1
        Top = 1
        Width = 880
        Height = 454
        Hint = ''
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 187
      end
    end
  end
  object UniContainerPanel1: TUniContainerPanel [4]
    Left = 0
    Top = 54
    Width = 882
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 5
    ExplicitWidth = 880
    object UniLabel2: TUniLabel
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 19
      Height = 13
      Hint = ''
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Caption = #1058#1080#1087
      Align = alLeft
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object comboLinkType: TUniComboBox
      AlignWithMargins = True
      Left = 96
      Top = 3
      Width = 783
      Height = 21
      Hint = ''
      Style = csOwnerDrawFixed
      Text = ''
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      IconItems = <>
      OnChange = comboLinkTypeChange
      ExplicitWidth = 781
    end
  end
  object directionPanel: TUniContainerPanel [5]
    Left = 0
    Top = 81
    Width = 882
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 4
    ExplicitWidth = 880
    object UniLabel5: TUniLabel
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 73
      Height = 13
      Hint = ''
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      Align = alLeft
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object ComboBoxDirection: TUniComboBox
      AlignWithMargins = True
      Left = 96
      Top = 3
      Width = 783
      Height = 21
      Hint = ''
      Style = csOwnerDrawFixed
      Text = 'download'
      Items.Strings = (
        'download'
        'upload'
        'duplex')
      ItemIndex = 0
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      IconItems = <>
      ExplicitWidth = 781
    end
  end
end
