inherited UserEditForm: TUserEditForm
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
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
    ScrollHeight = 701
    ScrollWidth = 819
    object cbConfirmed: TUniCheckBox
      Left = 24
      Top = 16
      Width = 153
      Height = 17
      Hint = ''
      Caption = #1059#1078#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1105#1085
      TabOrder = 0
    end
    object lblUserId: TUniLabel
      Left = 24
      Top = 48
      Width = 37
      Height = 13
      Hint = ''
      Caption = 'User ID'
      TabOrder = 12
    end
    object edUserId: TUniEdit
      Left = 120
      Top = 45
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object lblCompanyId: TUniLabel
      Left = 24
      Top = 82
      Width = 48
      Height = 13
      Hint = ''
      Caption = 'Company'
      TabOrder = 13
    end
    object edCompanyId: TUniEdit
      Left = 120
      Top = 79
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object lblGroupId: TUniLabel
      Left = 24
      Top = 116
      Width = 47
      Height = 13
      Hint = ''
      Caption = 'Group ID'
      TabOrder = 14
    end
    object edGroupId: TUniEdit
      Left = 120
      Top = 113
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object lblUserName: TUniLabel
      Left = 24
      Top = 150
      Width = 22
      Height = 13
      Hint = ''
      Caption = #1048#1084#1103
      TabOrder = 15
    end
    object edUserName: TUniEdit
      Left = 120
      Top = 147
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
    object lblFullName: TUniLabel
      Left = 24
      Top = 184
      Width = 65
      Height = 13
      Hint = ''
      Caption = #1055#1086#1083#1085#1086#1077' '#1080#1084#1103
      TabOrder = 16
    end
    object edFullName: TUniEdit
      Left = 120
      Top = 181
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
    end
    object lblEmail: TUniLabel
      Left = 24
      Top = 218
      Width = 27
      Height = 13
      Hint = ''
      Caption = 'Email'
      TabOrder = 17
    end
    object edEmail: TUniEdit
      Left = 120
      Top = 215
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
    end
    object lblPassword: TUniLabel
      Left = 24
      Top = 252
      Width = 40
      Height = 13
      Hint = ''
      Caption = #1055#1072#1088#1086#1083#1100
      TabOrder = 18
    end
    object edPassword: TUniEdit
      Left = 120
      Top = 249
      Width = 671
      Height = 21
      Hint = ''
      PasswordChar = '*'
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
    end
    object lblCountry: TUniLabel
      Left = 24
      Top = 286
      Width = 38
      Height = 13
      Hint = ''
      Caption = #1057#1090#1088#1072#1085#1072
      TabOrder = 19
    end
    object edCountry: TUniEdit
      Left = 120
      Top = 283
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 8
    end
    object lblOrg: TUniLabel
      Left = 24
      Top = 320
      Width = 72
      Height = 13
      Hint = ''
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
      TabOrder = 20
    end
    object edOrg: TUniEdit
      Left = 120
      Top = 317
      Width = 671
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 9
    end
    object lblData: TUniLabel
      Left = 24
      Top = 354
      Width = 24
      Height = 13
      Hint = ''
      Caption = 'Data'
      TabOrder = 21
    end
    object memoData: TUniMemo
      Left = 24
      Top = 373
      Width = 767
      Height = 90
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 10
    end
    object lblBody: TUniLabel
      Left = 24
      Top = 473
      Width = 26
      Height = 13
      Hint = ''
      Caption = 'Body'
      TabOrder = 22
    end
    object memoBody: TUniMemo
      Left = 24
      Top = 492
      Width = 767
      Height = 90
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 11
    end
    object lblLocation: TUniLabel
      Left = 24
      Top = 592
      Width = 46
      Height = 13
      Hint = ''
      Caption = #1051#1086#1082#1072#1094#1080#1103
      TabOrder = 23
    end
    object memoLocation: TUniMemo
      Left = 24
      Top = 611
      Width = 767
      Height = 90
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 24
    end
  end
end
