inherited RuleEditForm: TRuleEditForm
  ClientHeight = 600
  ClientWidth = 720
  Caption = #1055#1088#1072#1074#1080#1083#1086' '#1084#1072#1088#1096#1088#1091#1090#1080#1079#1072#1094#1080#1080
  ExplicitWidth = 736
  ExplicitHeight = 639
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Top = 550
    Width = 720
    ExplicitTop = 550
    ExplicitWidth = 720
    inherited btnOk: TUniButton
      Left = 561
      OnClick = btnOkClick
      ExplicitLeft = 561
    end
    inherited btnCancel: TUniButton
      Left = 642
      ExplicitLeft = 642
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 720
    ExplicitWidth = 720
    inherited lCaption: TUniLabel
      Width = 48
      Caption = #1055#1088#1072#1074#1080#1083#1086
      Font.Style = [fsBold]
      ExplicitWidth = 48
    end
    inherited teCaption: TUniEdit
      Left = 62
      Width = 655
      ExplicitLeft = 62
      ExplicitWidth = 655
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 720
    Visible = False
    ExplicitWidth = 720
    inherited teName: TUniEdit
      Left = 40
      Width = 677
      ExplicitLeft = 40
      ExplicitWidth = 677
    end
  end
  inherited pnClient: TUniContainerPanel
    Width = 720
    Height = 496
    ExplicitWidth = 720
    ExplicitHeight = 496
    ScrollHeight = 496
    ScrollWidth = 720
    object RuleGroupBox: TUniGroupBox
      Left = 24
      Top = 16
      Width = 672
      Height = 480
      Hint = ''
      Caption = ' '#1055#1088#1072#1074#1080#1083#1086' '
      TabOrder = 0
      object RuleHeaderPanel: TUniPanel
        Left = 2
        Top = 15
        Width = 668
        Height = 70
        Hint = ''
        Align = alTop
        TabOrder = 0
        BorderStyle = ubsNone
        Caption = ''
        inline FrameRuleEnabled: TFrameBoolInput
          Left = 0
          Top = 0
          Width = 668
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitWidth = 668
          inherited PanelText: TUniPanel
            Caption = #1042#1082#1083#1102#1095#1077#1085#1086
          end
          inherited CheckBox: TUniCheckBox
            Width = 530
            ExplicitWidth = 530
          end
        end
        inline FrameRulePosition: TFrameTextInput
          Left = 0
          Top = 30
          Width = 668
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitTop = 30
          ExplicitWidth = 668
          inherited PanelText: TUniPanel
            Caption = #1055#1086#1079#1080#1094#1080#1103
          end
          inherited Edit: TUniEdit
            Width = 497
            InputType = 'number'
            ExplicitWidth = 497
          end
          inherited PanelUnits: TUniPanel
            Left = 642
            ExplicitLeft = 642
          end
        end
      end
      object RuleTreePanel: TUniPanel
        Left = 2
        Top = 85
        Width = 668
        Height = 393
        Hint = ''
        Align = alClient
        TabOrder = 1
        Caption = ''
        object RuleTreeSplitter: TUniSplitter
          Left = 261
          Top = 1
          Width = 6
          Height = 391
          Hint = ''
          Align = alLeft
          ParentColor = False
          Color = clBtnFace
        end
        object RuleTreeLeftPanel: TUniPanel
          Left = 1
          Top = 1
          Width = 260
          Height = 391
          Hint = ''
          Align = alLeft
          TabOrder = 0
          BorderStyle = ubsNone
          Caption = ''
          object RuleTreeToolbar: TUniPanel
            Left = 0
            Top = 0
            Width = 260
            Height = 28
            Hint = ''
            Align = alTop
            TabOrder = 0
            BorderStyle = ubsFrameLowered
            Caption = ''
            object RuleTreeAddPanel: TUniPanel
              AlignWithMargins = True
              Left = 5
              Top = 5
              Width = 25
              Height = 18
              Hint = ''
              Align = alLeft
              TabOrder = 1
              BorderStyle = ubsNone
              Caption = ''
              object btnRuleAdd: TUniBitBtn
                Left = 0
                Top = 0
                Width = 25
                Height = 18
                Hint = ''
                Caption = '+'
                Align = alClient
                TabOrder = 1
                OnClick = btnRuleAddClick
              end
            end
            object RuleTreeRemovePanel: TUniPanel
              AlignWithMargins = True
              Left = 36
              Top = 5
              Width = 25
              Height = 18
              Hint = ''
              Align = alLeft
              TabOrder = 2
              BorderStyle = ubsNone
              Caption = ''
              object btnRuleRemove: TUniBitBtn
                Left = 0
                Top = 0
                Width = 25
                Height = 18
                Hint = ''
                Caption = '-'
                Align = alClient
                TabOrder = 1
                OnClick = btnRuleRemoveClick
              end
            end
          end
          object RuleTreeView: TUniTreeView
            Left = 0
            Top = 28
            Width = 260
            Height = 363
            Hint = ''
            Items.FontData = {0100000000}
            Align = alClient
            TabOrder = 2
            Color = clWindow
            UseCheckBox = True
            OnChange = RuleTreeViewChange
          end
        end
        object RuleConditionsPanel: TUniPanel
          Left = 267
          Top = 1
          Width = 400
          Height = 391
          Hint = ''
          Align = alClient
          TabOrder = 3
          BorderStyle = ubsNone
          Caption = ''
        end
      end
    end
  end
end
