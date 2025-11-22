inherited UnitEditForm: TUnitEditForm
  Caption = 'Unit'
  TextHeight = 15
  inherited pnClient: TUniContainerPanel
    ScrollHeight = 414
    ScrollWidth = 819
    object lUid: TUniLabel
      Left = 40
      Top = 24
      Width = 44
      Height = 13
      Hint = ''
      Caption = 'UID'
      TabOrder = 4
    end
    object teUid: TUniEdit
      Left = 86
      Top = 20
      Width = 730
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 728
    end
    object lWUnit: TUniLabel
      Left = 40
      Top = 64
      Width = 35
      Height = 13
      Hint = ''
      Caption = 'WUnit'
      TabOrder = 5
    end
    object teWUnit: TUniEdit
      Left = 86
      Top = 60
      Width = 730
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 728
    end
  end
end
