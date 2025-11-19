inherited LinkEditForm: TLinkEditForm
  ClientHeight = 801
  ClientWidth = 876
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1083#1080#1085#1082#1086#1074'..'
  ExplicitLeft = -114
  ExplicitTop = -254
  ExplicitWidth = 892
  ExplicitHeight = 840
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Top = 751
    Width = 876
    ExplicitTop = 743
    ExplicitWidth = 874
    inherited btnOk: TUniButton
      Left = 717
      ExplicitLeft = 715
    end
    inherited btnCancel: TUniButton
      Left = 798
      ExplicitLeft = 796
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 876
    Visible = False
    ExplicitWidth = 874
    inherited teCaption: TUniEdit
      Left = 110
      Width = 763
      ExplicitLeft = 110
      ExplicitWidth = 761
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 876
    ExplicitWidth = 874
    inherited teName: TUniEdit
      Left = 110
      Width = 763
      ExplicitLeft = 110
      ExplicitWidth = 761
    end
  end
  inherited pnClient: TUniContainerPanel
    Top = 135
    Width = 876
    Height = 616
    ExplicitTop = 135
    ExplicitWidth = 874
    ExplicitHeight = 608
    ScrollHeight = 616
    ScrollWidth = 876
    object UniScrollBox1: TUniScrollBox
      Left = 0
      Top = 0
      Width = 876
      Height = 616
      Hint = ''
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 878
      ExplicitHeight = 624
    end
  end
  object UniContainerPanel1: TUniContainerPanel [4]
    Left = 0
    Top = 54
    Width = 876
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 4
    ExplicitWidth = 874
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
      Left = 110
      Top = 3
      Width = 763
      Height = 21
      Hint = ''
      Style = csOwnerDrawFixed
      Text = ''
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      IconItems = <>
      OnChange = comboLinkTypeChange
      ExplicitWidth = 761
    end
  end
  object UniContainerPanel3: TUniContainerPanel [5]
    Left = 0
    Top = 108
    Width = 876
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 5
    ExplicitWidth = 874
    object UniLabel4: TUniLabel
      AlignWithMargins = True
      Left = 3
      Top = 32
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
    object UniComboBox2: TUniComboBox
      AlignWithMargins = True
      Left = 112
      Top = 30
      Width = 761
      Height = 0
      Hint = ''
      Style = csOwnerDrawFixed
      Text = ''
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      IconItems = <>
      OnChange = comboLinkTypeChange
      ExplicitWidth = 759
    end
    object directionPanel: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 876
      Height = 27
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 3
      ExplicitWidth = 874
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
        Left = 112
        Top = 3
        Width = 761
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
        ExplicitWidth = 759
      end
    end
  end
  object pnID: TUniContainerPanel [6]
    Left = 0
    Top = 81
    Width = 876
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 6
    ExplicitWidth = 874
    object UniLabel1: TUniLabel
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 11
      Height = 13
      Hint = ''
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Caption = 'ID'
      Align = alLeft
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object teID: TUniEdit
      AlignWithMargins = True
      Left = 110
      Top = 3
      Width = 763
      Height = 21
      Hint = ''
      Text = ''
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      ReadOnly = True
      ExplicitWidth = 761
    end
  end
end
