inherited DsGroupEditForm: TDsGroupEditForm
  Caption = #1043#1088#1091#1087#1087#1099' '#1076#1072#1085#1085#1099#1093
  TextHeight = 15
  inherited pnCaption: TUniContainerPanel
    Height = 0
    Visible = False
    ExplicitHeight = 0
  end
  inherited pnName: TUniContainerPanel
    Top = 0
    Height = 0
    Visible = False
    ExplicitTop = 0
    ExplicitHeight = 0
  end
  inherited pnClient: TUniContainerPanel
    Top = 0
    Height = 468
    ExplicitTop = 0
    ExplicitWidth = 819
    ExplicitHeight = 468
    ScrollHeight = 510
    ScrollWidth = 819
    object lblGroupId: TUniLabel
      Left = 24
      Top = 16
      Width = 47
      Height = 13
      Hint = ''
      Caption = 'Group ID'
      TabOrder = 9
    end
    object edGroupId: TUniEdit
      Left = 120
      Top = 13
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object lblParentId: TUniLabel
      Left = 24
      Top = 50
      Width = 47
      Height = 13
      Hint = ''
      Caption = 'Parent ID'
      TabOrder = 10
    end
    object edParentId: TUniEdit
      Left = 120
      Top = 47
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object lblContextId: TUniLabel
      Left = 24
      Top = 84
      Width = 40
      Height = 13
      Hint = ''
      Caption = 'Context'
      TabOrder = 11
    end
    object edContextId: TUniEdit
      Left = 120
      Top = 81
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object lblGroupName: TUniLabel
      Left = 24
      Top = 118
      Width = 22
      Height = 13
      Hint = ''
      Caption = #1048#1084#1103
      TabOrder = 12
    end
    object edGroupName: TUniEdit
      Left = 120
      Top = 115
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
    object lblSid: TUniLabel
      Left = 24
      Top = 152
      Width = 17
      Height = 13
      Hint = ''
      Caption = 'SID'
      TabOrder = 13
    end
    object edSid: TUniEdit
      Left = 120
      Top = 149
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
    end
    object lblDstId: TUniLabel
      Left = 24
      Top = 186
      Width = 33
      Height = 13
      Hint = ''
      Caption = 'DST ID'
      TabOrder = 14
    end
    object edDstId: TUniEdit
      Left = 120
      Top = 183
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
    end
    object lblMetadata: TUniLabel
      Left = 24
      Top = 220
      Width = 49
      Height = 13
      Hint = ''
      Caption = 'Metadata'
      TabOrder = 16
    end
    object memoMetadata: TUniMemo
      Left = 24
      Top = 239
      Width = 767
      Height = 120
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
    end
    object lblDataseries: TUniLabel
      Left = 24
      Top = 371
      Width = 57
      Height = 13
      Hint = ''
      Caption = #1044#1072#1090#1072#1089#1077#1088#1080#1080
      TabOrder = 15
    end
    object memoDataseries: TUniMemo
      Left = 24
      Top = 390
      Width = 767
      Height = 120
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 8
    end
  end
end
