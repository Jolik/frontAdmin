object AuthMainForm: TAuthMainForm
  Left = 0
  Top = 0
  ClientHeight = 400
  ClientWidth = 600
  Caption = 'AuthMainForm'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnAfterShow = UniFormAfterShow
  OnAjaxEvent = UniFormAjaxEvent
  DesignSize = (
    600
    400)
  TextHeight = 15
  object UserNameLabel: TUniLabel
    Left = 528
    Top = 8
    Width = 35
    Height = 25
    Cursor = crHandPoint
    Hint = ''
    Alignment = taRightJustify
    Caption = 'User'
    Anchors = [akTop, akRight]
    ParentFont = False
    Font.Height = -18
    TabOrder = 0
    OnClick = UserLabelClick
  end
  object UserMenu: TUniPopupMenu
    AutoPopup = False
    Left = 24
    Top = 48
    object LogoutMenuItem: TUniMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = LogoutMenuClick
    end
  end
end
