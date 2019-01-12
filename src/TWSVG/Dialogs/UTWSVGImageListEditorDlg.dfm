object WSVGImageListEditorDlg: TWSVGImageListEditorDlg
  Left = 0
  Top = 0
  Caption = 'Editing XXX'
  ClientHeight = 346
  ClientWidth = 293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object paButtons: TPanel
    Left = 0
    Top = 315
    Width = 293
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btCancel: TButton
      AlignWithMargins = True
      Left = 134
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btOk: TButton
      AlignWithMargins = True
      Left = 215
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 1
      OnClick = btOkClick
    end
    object cbColorDlg: TColorBox
      Left = 208
      Top = -248
      Width = 145
      Height = 22
      TabOrder = 2
    end
  end
  object paEditor: TPanel
    Left = 0
    Top = 0
    Width = 293
    Height = 315
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lbImageList: TListBox
      AlignWithMargins = True
      Left = 116
      Top = 3
      Width = 174
      Height = 309
      Style = lbOwnerDrawFixed
      Align = alClient
      ItemHeight = 50
      TabOrder = 0
      OnClick = lbImageListClick
      OnDrawItem = lbImageListDrawItem
    end
    object paEditorButtons: TPanel
      Left = 0
      Top = 0
      Width = 113
      Height = 315
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object laOpacityTitle: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 272
        Width = 107
        Height = 13
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Opacity'
        ExplicitLeft = -3
        ExplicitTop = 285
        ExplicitWidth = 113
      end
      object btAdd: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 107
        Height = 25
        Align = alTop
        Caption = 'Add...'
        TabOrder = 0
        OnClick = btAddClick
      end
      object btEdit: TButton
        AlignWithMargins = True
        Left = 3
        Top = 34
        Width = 107
        Height = 25
        Align = alTop
        Caption = 'Edit...'
        Enabled = False
        TabOrder = 1
        OnClick = btEditClick
      end
      object btDelete: TButton
        AlignWithMargins = True
        Left = 3
        Top = 127
        Width = 107
        Height = 25
        Align = alTop
        Caption = 'Delete'
        Enabled = False
        TabOrder = 2
        OnClick = btDeleteClick
      end
      object btDeleteAll: TButton
        AlignWithMargins = True
        Left = 3
        Top = 201
        Width = 107
        Height = 25
        Align = alTop
        Caption = 'Delete all'
        TabOrder = 3
        OnClick = btDeleteAllClick
      end
      object btMoveUp: TButton
        AlignWithMargins = True
        Left = 3
        Top = 65
        Width = 107
        Height = 25
        Align = alTop
        Caption = 'Move up'
        Enabled = False
        TabOrder = 4
        OnClick = btMoveUpClick
      end
      object btMoveDown: TButton
        AlignWithMargins = True
        Left = 3
        Top = 96
        Width = 107
        Height = 25
        Align = alTop
        Caption = 'Move down'
        Enabled = False
        TabOrder = 5
        OnClick = btMoveDownClick
      end
      object paColorKey: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 244
        Width = 107
        Height = 25
        Margins.Top = 15
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 6
        object btColorKey: TButton
          Left = 0
          Top = 0
          Width = 75
          Height = 25
          Align = alLeft
          Caption = 'Color key'
          Enabled = False
          TabOrder = 0
          OnClick = btColorKeyClick
        end
        object paColorKeySample: TPanel
          AlignWithMargins = True
          Left = 85
          Top = 3
          Width = 19
          Height = 19
          Cursor = crHandPoint
          Align = alRight
          Enabled = False
          ParentBackground = False
          TabOrder = 1
          OnClick = btColorKeyClick
        end
      end
      object btSaveToFile: TButton
        AlignWithMargins = True
        Left = 3
        Top = 170
        Width = 107
        Height = 25
        Margins.Top = 15
        Align = alTop
        Caption = 'Save to file...'
        Enabled = False
        TabOrder = 7
        OnClick = btSaveToFileClick
      end
      object tbOpacity: TTrackBar
        AlignWithMargins = True
        Left = 3
        Top = 285
        Width = 107
        Height = 23
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Max = 100
        PageSize = 1
        Position = 100
        ShowSelRange = False
        TabOrder = 8
        TickStyle = tsNone
        OnChange = tbOpacityChange
        ExplicitLeft = 0
        ExplicitTop = 272
        ExplicitWidth = 113
      end
    end
  end
  object odOpenDlg: TOpenDialog
    DefaultExt = 'svg'
    Filter = 'Scalable Vector Graphic|*.svg'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open SVG file'
    Left = 128
    Top = 8
  end
  object sdSaveDlg: TSaveDialog
    DefaultExt = 'svg'
    Filter = 'Scalable Vector Graphic|*.svg'
    Options = [ofEnableSizing]
    Title = 'Save SVG file'
    Left = 168
    Top = 8
  end
  object cdColorDlg: TColorDialog
    Options = [cdFullOpen, cdAnyColor]
    Left = 208
    Top = 8
  end
end
