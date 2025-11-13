inherited OperatorLinkEditForm: TOperatorLinkEditForm
  Caption = #1054#1087#1077#1088#1072#1090#1086#1088#1089#1082#1072#1103' '#1089#1074#1103#1079#1100
  TextHeight = 15
  inherited pnClient: TUniContainerPanel
    ScrollHeight = 830
    ScrollWidth = 819
    object lLid: TUniLabel
      Left = 40
      Top = 27
      Width = 18
      Height = 13
      Hint = ''
      Caption = 'LID'
      TabOrder = 8
    end
    object teLid: TUniEdit
      Left = 84
      Top = 24
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 730
    end
    object lLinkType: TUniLabel
      Left = 40
      Top = 67
      Width = 55
      Height = 13
      Hint = ''
      Caption = 'Link type'
      TabOrder = 9
    end
    object teLinkType: TUniEdit
      Left = 84
      Top = 64
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      ExplicitWidth = 730
    end
    object lDir: TUniLabel
      Left = 40
      Top = 107
      Width = 16
      Height = 13
      Hint = ''
      Caption = 'Dir'
      TabOrder = 10
    end
    object teDir: TUniEdit
      Left = 84
      Top = 104
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      ExplicitWidth = 730
    end
    object lStatus: TUniLabel
      Left = 40
      Top = 147
      Width = 35
      Height = 13
      Hint = ''
      Caption = 'Status'
      TabOrder = 11
    end
    object teStatus: TUniEdit
      Left = 84
      Top = 144
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      ExplicitWidth = 730
    end
    object lComsts: TUniLabel
      Left = 40
      Top = 187
      Width = 42
      Height = 13
      Hint = ''
      Caption = 'Comsts'
      TabOrder = 12
    end
    object teComsts: TUniEdit
      Left = 84
      Top = 184
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      ExplicitWidth = 730
    end
    object lLastActivityTime: TUniLabel
      Left = 40
      Top = 227
      Width = 100
      Height = 13
      Hint = ''
      Caption = 'Last activity time'
      TabOrder = 13
    end
    object teLastActivityTime: TUniEdit
      Left = 152
      Top = 224
      Width = 664
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
      ExplicitWidth = 662
    end
    object lSent: TUniLabel
      Left = 40
      Top = 267
      Width = 22
      Height = 13
      Hint = ''
      Caption = 'Sent'
      TabOrder = 14
    end
    object teSent: TUniEdit
      Left = 84
      Top = 264
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
      ExplicitWidth = 730
    end
    object lRecv: TUniLabel
      Left = 40
      Top = 307
      Width = 27
      Height = 13
      Hint = ''
      Caption = 'Recv'
      TabOrder = 15
    end
    object teRecv: TUniEdit
      Left = 84
      Top = 304
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 16
      ExplicitWidth = 730
    end
    object cbAutostart: TUniCheckBox
      Left = 84
      Top = 344
      Width = 121
      Height = 17
      Hint = ''
      Caption = 'Autostart'
      TabOrder = 17
    end
    object lSettings: TUniLabel
      Left = 40
      Top = 372
      Width = 45
      Height = 13
      Hint = ''
      Caption = 'Settings'
      TabOrder = 18
    end
    object meSettings: TUniMemo
      Left = 84
      Top = 389
      Width = 732
      Height = 120
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 19
      ExplicitWidth = 730
    end
    object lSnapshot: TUniLabel
      Left = 40
      Top = 521
      Width = 47
      Height = 13
      Hint = ''
      Caption = 'Snapshot'
      TabOrder = 20
    end
    object meSnapshot: TUniMemo
      Left = 84
      Top = 538
      Width = 732
      Height = 120
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 21
      ExplicitWidth = 730
    end
    object lConnStats: TUniLabel
      Left = 40
      Top = 673
      Width = 51
      Height = 13
      Hint = ''
      Caption = 'Conn stats'
      TabOrder = 22
    end
    object meConnStats: TUniMemo
      Left = 84
      Top = 690
      Width = 732
      Height = 120
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 23
      ExplicitWidth = 730
      ExplicitHeight = 112
    end
  end
end
