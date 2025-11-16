object EmbedLoginForm: TEmbedLoginForm
  Left = 0
  Top = 0
  ClientHeight = 220
  ClientWidth = 360
  Caption = 'Login'
  BorderStyle = bsDialog
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = UniFormClose
  BorderIcons = [biSystemMenu]
  MonitoredKeys.Keys = <>
  FreeOnClose = False
  TextHeight = 15
  object lblUser: TUniLabel
    Left = 24
    Top = 24
    Width = 98
    Height = 13
    Hint = ''
    Alignment = taRightJustify
    Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
    TabOrder = 4
  end
  object edtUser: TUniEdit
    Left = 144
    Top = 20
    Width = 192
    Height = 25
    Hint = ''
    Text = ''
    TabOrder = 0
  end
  object lblPassword: TUniLabel
    Left = 24
    Top = 64
    Width = 40
    Height = 13
    Hint = ''
    Alignment = taRightJustify
    Caption = #1055#1072#1088#1086#1083#1100
    TabOrder = 5
  end
  object edtPassword: TUniEdit
    Left = 144
    Top = 60
    Width = 192
    Height = 25
    Hint = ''
    PasswordChar = '*'
    Text = ''
    TabOrder = 1
  end
  object btnLogin: TUniButton
    Left = 246
    Top = 144
    Width = 90
    Height = 30
    Hint = ''
    Caption = #1042#1086#1081#1090#1080
    TabOrder = 2
    OnClick = btnLoginClick
  end
  object btnCancel: TUniButton
    Left = 144
    Top = 144
    Width = 90
    Height = 30
    Hint = ''
    Visible = False
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object lblError: TUniLabel
    Left = 24
    Top = 108
    Width = 30
    Height = 17
    Hint = ''
    Visible = False
    Caption = 'Error'
    ParentFont = False
    Font.Color = clRed
    Font.Height = -13
    Font.Style = [fsBold]
    TabOrder = 6
  end
end
