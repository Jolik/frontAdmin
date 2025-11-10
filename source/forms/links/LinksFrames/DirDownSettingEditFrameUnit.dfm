inherited DirDownSettingEditFrame: TDirDownSettingEditFrame
  Height = 515
  ExplicitHeight = 515
  inherited SettingsPanel: TUniPanel
    Height = 515
    ExplicitHeight = 515
    inherited SettingsGroupBox: TUniGroupBox
      Height = 513
      ExplicitHeight = 513
      inherited UniPanel3: TUniPanel
        Top = 441
        ExplicitTop = 441
      end
      inherited SettingsParentPanel: TUniPanel
        Height = 426
        ExplicitHeight = 426
        ScrollHeight = 341
        ScrollWidth = 427
        inline FrameSchedule1: TFrameSchedule
          AlignWithMargins = True
          Left = 10
          Top = 70
          Width = 386
          Height = 208
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitLeft = 61
          ExplicitTop = 96
          ExplicitWidth = 386
          inherited UniGroupBox1: TUniGroupBox
            Width = 386
            ExplicitWidth = 386
            ExplicitHeight = 208
            inherited UniPanel1: TUniPanel
              Width = 382
              ExplicitTop = 45
              ExplicitWidth = 382
              inherited FrameScheduleCron: TFrameTextInput
                Width = 382
                ExplicitLeft = 0
                ExplicitTop = 30
                ExplicitWidth = 382
                inherited Edit: TUniEdit
                  Width = 211
                  ExplicitWidth = 211
                end
                inherited PanelUnits: TUniPanel
                  Left = 356
                  ExplicitLeft = 356
                end
              end
              inherited FrameSchedulePeriod: TFrameTextInput
                Width = 382
                ExplicitLeft = 0
                ExplicitTop = 60
                ExplicitWidth = 382
                inherited Edit: TUniEdit
                  Width = 211
                  ExplicitLeft = 135
                  ExplicitWidth = 170
                end
                inherited PanelUnits: TUniPanel
                  Left = 356
                  ExplicitLeft = 356
                end
              end
              inherited FrameScheduleEnabled: TFrameBoolInput
                Width = 382
                ExplicitLeft = 0
                ExplicitWidth = 341
                inherited PanelText: TUniPanel
                  ExplicitLeft = 0
                  ExplicitTop = 0
                end
                inherited CheckBox: TUniCheckBox
                  Width = 244
                end
              end
              inherited FrameScheduleRetry: TFrameTextInput
                Width = 382
                ExplicitLeft = 0
                ExplicitTop = 90
                inherited PanelText: TUniPanel
                  ExplicitLeft = 0
                  ExplicitTop = 0
                end
                inherited Edit: TUniEdit
                  Width = 211
                end
                inherited PanelUnits: TUniPanel
                  Left = 356
                end
              end
              inherited FrameScheduleDelay: TFrameTextInput
                Width = 382
                ExplicitLeft = 0
                ExplicitTop = 120
                ExplicitWidth = 341
                inherited PanelText: TUniPanel
                  ExplicitLeft = 0
                  ExplicitTop = 0
                end
                inherited Edit: TUniEdit
                  Width = 211
                  ExplicitLeft = 135
                  ExplicitWidth = 211
                end
                inherited PanelUnits: TUniPanel
                  Left = 356
                  ExplicitLeft = 315
                end
              end
            end
            inherited UniPanel3: TUniPanel
              Width = 382
              ExplicitWidth = 382
              inherited btnRemoveJob: TUniBitBtn
                ExplicitLeft = 261
              end
              inherited btnAddJob: TUniBitBtn
                ExplicitLeft = 230
              end
              inherited JobsComboBox: TUniComboBox
                ExplicitLeft = 10
              end
            end
          end
        end
        inline FrameDepth: TFrameTextInput
          Left = 0
          Top = 30
          Width = 406
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitTop = 30
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1043#1083#1091#1073#1080#1085#1072
          end
          inherited Edit: TUniEdit
            Width = 235
            Text = 'number'
            InputType = 'number'
            ExplicitWidth = 235
          end
          inherited PanelUnits: TUniPanel
            Left = 380
            Caption = ''
            ExplicitLeft = 380
          end
        end
        inline FrameDir: TFrameTextInput
          Left = 0
          Top = 0
          Width = 406
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 3
          Background.Picture.Data = {00}
          ExplicitTop = 8
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1055#1072#1087#1082#1072
          end
          inherited Edit: TUniEdit
            Width = 235
            ExplicitWidth = 256
          end
          inherited PanelUnits: TUniPanel
            Left = 380
            Caption = ''
            ExplicitLeft = 401
          end
        end
        inline FrameSeekMetaFile: TFrameBoolInput
          Left = 0
          Top = 484
          Width = 406
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 4
          Background.Picture.Data = {00}
          ExplicitLeft = 72
          ExplicitTop = 328
          ExplicitWidth = 406
          inherited PanelText: TUniPanel
            Caption = #1052#1077#1090#1072' '#1092#1072#1081#1083#1099
          end
          inherited CheckBox: TUniCheckBox
            Width = 268
            ExplicitWidth = 268
          end
        end
        inline FrameS3: TFrameS3
          AlignWithMargins = True
          Left = 10
          Top = 298
          Width = 386
          Height = 176
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 5
          Background.Picture.Data = {00}
          ExplicitLeft = 64
          ExplicitTop = 194
          ExplicitWidth = 386
          inherited UniGroupBox1: TUniGroupBox
            Width = 386
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 298
            ExplicitHeight = 176
            inherited FrameS3Enabled: TFrameBoolInput
              Width = 382
              ExplicitLeft = 2
              ExplicitTop = 15
              inherited CheckBox: TUniCheckBox
                Width = 244
              end
            end
            inherited FrameS3AccessKey: TFrameTextInput
              Width = 382
              ExplicitLeft = 2
              ExplicitTop = 75
              inherited Edit: TUniEdit
                Width = 211
              end
              inherited PanelUnits: TUniPanel
                Left = 356
              end
            end
            inherited FrameS3Endpoint: TFrameTextInput
              Width = 382
              ExplicitLeft = 2
              ExplicitTop = 45
              ExplicitWidth = 382
              inherited Edit: TUniEdit
                Width = 211
                ExplicitWidth = 211
              end
              inherited PanelUnits: TUniPanel
                Left = 356
                ExplicitLeft = 356
              end
            end
            inherited FrameS3Secret: TFrameTextInput
              Width = 382
              ExplicitTop = 105
              ExplicitWidth = 382
              inherited Edit: TUniEdit
                Width = 211
                ExplicitWidth = 211
              end
              inherited PanelUnits: TUniPanel
                Left = 356
                ExplicitLeft = 356
              end
            end
            inherited FrameS3Bucket: TFrameTextInput
              Width = 382
              ExplicitTop = 135
              ExplicitWidth = 382
              inherited Edit: TUniEdit
                Width = 211
                ExplicitWidth = 211
              end
              inherited PanelUnits: TUniPanel
                Left = 356
                ExplicitLeft = 356
              end
            end
          end
        end
      end
    end
  end
  inherited ProfilesGroupBox: TUniGroupBox
    Height = 515
    ExplicitHeight = 515
    inherited ProfilesPanel: TUniPanel
      Height = 498
      ExplicitHeight = 498
      ScrollHeight = 413
      ScrollWidth = 410
    end
  end
  inherited UniSplitter1: TUniSplitter
    Height = 515
    ExplicitHeight = 515
  end
end
