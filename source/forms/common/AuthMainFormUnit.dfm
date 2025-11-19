inherited AuthMainForm: TAuthMainForm
  ClientHeight = 791
  ClientWidth = 1227
  Caption = 'AuthMainForm'
  OnAfterShow = UniFormAfterShow
  OnAjaxEvent = UniFormAjaxEvent
  ExplicitWidth = 1243
  ExplicitHeight = 830
  TextHeight = 15
  inherited pnlTop: TUniPanel
    Width = 1227
    ExplicitWidth = 1225
    inherited lblUtcTime: TUniLabel
      Width = 599
      ExplicitWidth = 597
    end
    inherited uncntnrpnLogo: TUniContainerPanel
      TabOrder = 3
      inherited unmgLogo: TUniImage
        ExplicitLeft = 5
        ExplicitTop = 3
        ExplicitHeight = 37
      end
    end
    object uncntnrpnAuth: TUniContainerPanel
      Left = 720
      Top = 1
      Width = 506
      Height = 43
      Hint = ''
      ParentColor = False
      Align = alRight
      TabOrder = 2
      ExplicitLeft = 718
      DesignSize = (
        506
        43)
      object UserNameLabel: TUniLabel
        AlignWithMargins = True
        Left = 386
        Top = 3
        Width = 120
        Height = 40
        Cursor = crHandPoint
        Hint = ''
        Margins.Top = 20
        Alignment = taCenter
        AutoSize = False
        Caption = 'User'
        Anchors = [akTop, akRight]
        ParentFont = False
        Font.Height = -18
        TabOrder = 1
        OnClick = UserLabelClick
      end
      object cbCurComp: TUniComboBox
        Left = 65
        Top = 9
        Width = 107
        Hint = ''
        Text = ''
        TabOrder = 2
        IconItems = <>
        OnChange = cbCurCompChange
      end
      object cbCurDept: TUniComboBox
        Left = 255
        Top = 9
        Width = 122
        Hint = ''
        Style = csDropDownList
        Text = ''
        TabOrder = 3
        IconItems = <>
        OnChange = cbCurDeptChange
      end
      object lblComp: TUniLabel
        Left = 6
        Top = 12
        Width = 54
        Height = 13
        Hint = ''
        Caption = #1050#1086#1084#1087#1072#1085#1080#1103
        TabOrder = 4
      end
      object lblDept: TUniLabel
        Left = 178
        Top = 12
        Width = 71
        Height = 13
        Hint = ''
        Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090
        TabOrder = 5
      end
    end
  end
  inherited pnlRight: TUniPanel
    Height = 746
    ExplicitHeight = 738
  end
  inherited tmUtc: TUniTimer
    Left = 280
    Top = 136
  end
  object UserMenu: TUniPopupMenu
    AutoPopup = False
    Left = 1136
    Top = 64
    object LogoutMenuItem: TUniMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = LogoutMenuClick
    end
  end
end
