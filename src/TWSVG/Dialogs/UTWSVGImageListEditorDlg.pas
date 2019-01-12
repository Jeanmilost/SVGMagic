{**
 @abstract(@name provides an editor dialog box to deal with the SVG images contained inside a SVG
           image list.)
 @author(JMR)
 @created(2016-2018 by Ursa Minor)
}
unit UTWSVGImageListEditorDlg;

interface

uses DesignIntf,
     System.SysUtils,
     System.Variants,
     System.Classes,
     Vcl.Graphics,
     Vcl.Controls,
     Vcl.Forms,
     Vcl.Dialogs,
     Vcl.StdCtrls,
     Vcl.ExtCtrls,
     Vcl.ComCtrls,
     Winapi.Messages,
     Winapi.Windows,
     UTWColor,
     UTWSmartPointer,
     UTWSVGGraphic,
     UTWSVGImageList;

type
    TWSVGImageListEditorDlg = class(TForm)
        published
            paButtons: TPanel;
            btCancel: TButton;
            btOk: TButton;
            paEditor: TPanel;
            lbImageList: TListBox;
            paEditorButtons: TPanel;
            btAdd: TButton;
            btSaveToFile: TButton;
            btEdit: TButton;
            btDelete: TButton;
            btDeleteAll: TButton;
            btMoveUp: TButton;
            btMoveDown: TButton;
            odOpenDlg: TOpenDialog;
            sdSaveDlg: TSaveDialog;
            cbColorDlg: TColorBox;
            cdColorDlg: TColorDialog;
            paColorKey: TPanel;
            btColorKey: TButton;
            paColorKeySample: TPanel;
            tbOpacity: TTrackBar;
            laOpacityTitle: TLabel;

            procedure lbImageListClick(pSender: TObject);
            procedure lbImageListDrawItem(pControl: TWinControl; index: Integer; rect: TRect;
                    state: TOwnerDrawState);
            procedure btAddClick(pSender: TObject);
            procedure btEditClick(pSender: TObject);
            procedure btMoveUpClick(pSender: TObject);
            procedure btMoveDownClick(pSender: TObject);
            procedure btDeleteClick(pSender: TObject);
            procedure btSaveToFileClick(pSender: TObject);
            procedure btDeleteAllClick(pSender: TObject);
            procedure btColorKeyClick(pSender: TObject);
            procedure btOkClick(pSender: TObject);
            procedure tbOpacityChange(pSender: TObject);

        private
            m_pImageList: TWSVGImageList;
            m_pDesigner:  IDesigner;
            m_Modified:   Boolean;

        protected
            {**
             Set image list
             @param(pImageList Image list)
            }
            procedure SetImageList(pImageList: TWSVGImageList); virtual;

            {**
             Rebuild the view image list
            }
            procedure RebuildList; virtual;

            {**
             Called when image list has changed
             @param(setModified If true, modified flag is set, unset otherwise)
            }
            procedure OnChange(setModified: Boolean); virtual;

        public
            {**
             Constructor
             @param(pOwner Dialog box owner)
             @param(pDesigner Embarcadero designer)
            }
            constructor CreateDesigner(pOwner: TComponent; pDesigner: IDesigner); virtual;

            {**
             Destructor
            }
            destructor Destroy; override;

        public
            {**
             Get or set the image list to edit
            }
            property ImageList: TWSVGImageList read m_pImageList write SetImageList;
    end;

var
    WSVGImageListEditorDlg: TWSVGImageListEditorDlg;

implementation
//---------------------------------------------------------------------------
// Global resources
//---------------------------------------------------------------------------
{$R *.dfm}
//---------------------------------------------------------------------------
// TWSVGImageListEditorDlg
//---------------------------------------------------------------------------
constructor TWSVGImageListEditorDlg.CreateDesigner(pOwner: TComponent; pDesigner: IDesigner);
begin
    inherited Create(pOwner);

    m_pImageList := TWSVGImageList.Create(Self);
    m_pDesigner  := pDesigner;
    m_Modified   := False;
end;
//---------------------------------------------------------------------------
destructor TWSVGImageListEditorDlg.Destroy;
begin
    FreeAndNil(m_pImageList);

    inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.lbImageListClick(pSender: TObject);
begin
    OnChange(False);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.lbImageListDrawItem(pControl: TWinControl; index: Integer;
        rect: TRect; state: TOwnerDrawState);
var
    textRect, imageRect: TRect;
    pSVG:                TWSVGGraphic;
    prevAnimate:         Boolean;
    text:                UnicodeString;
begin
    // select background color to use
    if (odSelected in state) then
        lbImageList.Canvas.Brush.Color := clHighlight
    else
        lbImageList.Canvas.Brush.Color := clWhite;

    // draw item background
    lbImageList.Canvas.FillRect(rect);

    // calculate text rectangle
    textRect := TRect.Create(rect.Left + rect.Height + 5, rect.Top, rect.Right, rect.Top + rect.Height);

    // is index out of bounds?
    if (index >= m_pImageList.Count) then
    begin
        // draw item background
        lbImageList.Canvas.Brush.Color := clRed;
        lbImageList.Canvas.FillRect(rect);

        DrawText(lbImageList.Canvas.Handle, '#ERROR', 6, textRect, DT_SINGLELINE or DT_LEFT
                or DT_VCENTER or DT_END_ELLIPSIS);

        Exit;
    end;

    // get picture as SVG graphic
    pSVG := m_pImageList.GetSVG(index);

    // found it?
    if (not Assigned(pSVG)) then
    begin
        // draw item background
        lbImageList.Canvas.Brush.Color := clRed;
        lbImageList.Canvas.FillRect(rect);

        DrawText(lbImageList.Canvas.Handle, '#ERROR', 6, textRect, DT_SINGLELINE or DT_LEFT
                or DT_VCENTER or DT_END_ELLIPSIS);

        Exit;
    end;

    // calculate image rectangle
    imageRect := TRect.Create(rect.Left, rect.Top, rect.Left + rect.Height, rect.Top + rect.Height);

    // keep previous SVG value
    prevAnimate := pSVG.Animate;

    try
        // configure SVG
        pSVG.Animate := False;

        // draw image
        lbImageList.Canvas.StretchDraw(imageRect, pSVG);
    finally
        // revert SVG to previous value
        pSVG.Animate := prevAnimate;
    end;

    // get text to draw
    text := IntToStr(index);

    // draw text
    DrawTextW(lbImageList.Canvas.Handle, PWideChar(text), Length(text), textRect, DT_SINGLELINE
            or DT_LEFT or DT_VCENTER or DT_END_ELLIPSIS);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btAddClick(pSender: TObject);
var
    pSVG: IWSmartPointer<TWSVGGraphic>;
begin
    // open dialog box and check user result
    if (not odOpenDlg.Execute) then
        Exit;

    try
        // load SVG and add it to image list
        pSVG := TWSmartPointer<TWSVGGraphic>.Create();
        pSVG.LoadFromFile(odOpenDlg.FileName);
        m_pImageList.AddSVG(pSVG);

        RebuildList;

        // notify that image list has changed
        OnChange(True);
    except
        MessageDlg('Could not load file', mtError, [mbOK], 0);
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btEditClick(pSender: TObject);
var
    pSVG:  IWSmartPointer<TWSVGGraphic>;
    index: NativeInt;
begin
    try
        // get selected item index
        index := lbImageList.ItemIndex;

        // is index valid?
        if ((index < 0) or (index >= m_pImageList.Count)) then
        begin
            MessageDlg('Index is out of bounds', mtError, [mbOK], 0);
            Exit;
        end;

        // open dialog box and check user result
        if (not odOpenDlg.Execute) then
            Exit;

        // load SVG image
        pSVG := TWSmartPointer<TWSVGGraphic>.Create();
        pSVG.LoadFromFile(odOpenDlg.FileName);
        m_pImageList.ReplaceSVG(index, pSVG);

        RebuildList;

        // restore selection
        lbImageList.ItemIndex := index;

        // notify that image list has changed
        OnChange(True);
    except
        MessageDlg('Could not modify item', mtError, [mbOK], 0);
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btMoveUpClick(pSender: TObject);
var
    pSrcSVG, pDstSVG:       TWSVGGraphic;
    pSrcTmpSvg, pDstTmpSvg: IWSmartPointer<TWSVGGraphic>;
    imageCount, index:      NativeInt;
begin
    try
        // get image count
        imageCount := m_pImageList.Count;

        // not enough items to swap?
        if (imageCount <= 1) then
            Exit;

        // get selected item index
        index := lbImageList.ItemIndex;

        // is index valid?
        if ((index < 1) or (index >= imageCount)) then
            Exit;

        // swap images
        pSrcTmpSvg := TWSmartPointer<TWSVGGraphic>.Create();
        pDstTmpSvg := TWSmartPointer<TWSVGGraphic>.Create();
        pSrcSVG    := m_pImageList.GetSVG(index - 1);
        pDstSVG    := m_pImageList.GetSVG(index);
        pSrcTmpSvg.Assign(pSrcSVG);
        pDstTmpSvg.Assign(pDstSVG);
        m_pImageList.ReplaceSVG(index - 1, pDstTmpSvg);
        m_pImageList.ReplaceSVG(index,     pSrcTmpSvg);

        // update index to new position
        lbImageList.ItemIndex := index - 1;

        // notify that image list has changed
        OnChange(True);
    Except
        MessageDlg('Swap failed', mtError, [mbOK], 0);
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btMoveDownClick(pSender: TObject);
var
    pSrcSVG, pDstSVG:       TWSVGGraphic;
    pSrcTmpSvg, pDstTmpSvg: IWSmartPointer<TWSVGGraphic>;
    imageCount, index:      NativeInt;
begin
    try
        // get image count
        imageCount := m_pImageList.Count;

        // not enough items to swap?
        if (imageCount <= 1) then
            Exit;

        // get selected item index
        index := lbImageList.ItemIndex;

        // is index valid?
        if ((index < 0) or (index >= imageCount - 1)) then
            Exit;

        // swap images
        pSrcTmpSvg := TWSmartPointer<TWSVGGraphic>.Create();
        pDstTmpSvg := TWSmartPointer<TWSVGGraphic>.Create();
        pSrcSVG    := m_pImageList.GetSVG(index);
        pDstSVG    := m_pImageList.GetSVG(index + 1);
        pSrcTmpSvg.Assign(pSrcSVG);
        pDstTmpSvg.Assign(pDstSVG);
        m_pImageList.ReplaceSVG(index,     pDstTmpSvg);
        m_pImageList.ReplaceSVG(index + 1, pSrcTmpSvg);

        // update index to new position
        lbImageList.ItemIndex := index + 1;

        // notify that image list has changed
        OnChange(True);
    Except
        MessageDlg('Swap failed', mtError, [mbOK], 0);
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btDeleteClick(pSender: TObject);
var
    index: NativeInt;
begin
    try
        // get selected item index
        index := lbImageList.ItemIndex;

        // is index valid?
        if ((index < 0) or (index >= m_pImageList.Count)) then
        begin
            MessageDlg('Index is out of bounds', mtError, [mbOK], 0);
            Exit;
        end;

        // delete image at index
        m_pImageList.DeleteSVG(index);

        RebuildList;

        // any item remaining in list?
        if (m_pImageList.Count > 0) then
            // restore selection
            if (index >= m_pImageList.Count) then
                lbImageList.ItemIndex := m_pImageList.Count - 1
            else
                lbImageList.ItemIndex := index;

        // notify that image list has changed
        OnChange(True);
    except
        MessageDlg('Delete failed', mtError, [mbOK], 0);
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btSaveToFileClick(pSender: TObject);
var
    pSVG:  TWSVGGraphic;
    index: NativeInt;
begin
    // open dialog box and check user result
    if (not sdSaveDlg.Execute) then
        Exit;

    try
        // get selected item index
        index := lbImageList.ItemIndex;

        // is index valid?
        if ((index < 0) or (index >= m_pImageList.Count)) then
        begin
            MessageDlg('Index is out of bounds', mtError, [mbOK], 0);
            Exit;
        end;

        // get item
        pSVG := m_pImageList.GetSVG(index);

        // found it?
        if (not Assigned(pSVG)) then
        begin
            MessageDlg('Invalid item', mtError, [mbOK], 0);
            Exit;
        end;

        // save to file
        pSVG.SaveToFile(sdSaveDlg.FileName);
    except
        MessageDlg('Could not save file - ' + sdSaveDlg.FileName, mtError, [mbOK], 0);
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btDeleteAllClick(pSender: TObject);
begin
    try
        lbImageList.Items.BeginUpdate;

        // clear image list
        m_pImageList.Clear;

        // clear shown image list
        lbImageList.Items.Clear;

        // notify that image list has changed
        OnChange(True);
    finally
        lbImageList.Items.EndUpdate;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btColorKeyClick(pSender: TObject);
var
    index: NativeInt;
    color: TWColor;
begin
    // get selected item index
    index := lbImageList.ItemIndex;

    // is index valid?
    if ((index < 0) or (index >= m_pImageList.Count)) then
    begin
        MessageDlg('Index is out of bounds', mtError, [mbOK], 0);
        Exit;
    end;

    // set the current color key as default color
    color            := m_pImageList.GetSVGColorKey(index);
    cdColorDlg.Color := color.GetColor;

    // open dialog box and check user result
    if (not cdColorDlg.Execute) then
        Exit;

    // update color key
    color := TWColor.Create(cdColorDlg.Color, 255);
    m_pImageList.SetSVGColorKey(index, color);

    // notify that image list has changed
    OnChange(True);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.btOkClick(pSender: TObject);
begin
    // modification occurred?
    if (m_Modified) then
        // notify designer
        m_pDesigner.Modified;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.tbOpacityChange(pSender: TObject);
var
    index: NativeInt;
    color: TWColor;
begin
    // get selected item index
    index := lbImageList.ItemIndex;

    // is index valid?
    if ((index < 0) or (index >= m_pImageList.Count)) then
    begin
        MessageDlg('Index is out of bounds', mtError, [mbOK], 0);
        Exit;
    end;

    // get color key
    color            := m_pImageList.GetSVGColorKey(index);
    cdColorDlg.Color := color.GetColor;

    // update color key
    color.SetOpacity(tbOpacity.Position);
    m_pImageList.SetSVGColorKey(index, color);

    // notify that image list has changed
    OnChange(True);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.SetImageList(pImageList: TWSVGImageList);
begin
    m_pImageList.Clear;

    if (not Assigned(pImageList)) then
        Exit;

    m_pImageList.Assign(pImageList);

    RebuildList;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.RebuildList;
var
    itemCount, i: NativeInt;
begin
    try
        lbImageList.Items.BeginUpdate;

        // clear previous list
        lbImageList.Items.Clear;

        // get source item count
        itemCount := m_pImageList.Count;

        // iterate through source items
        for i := 0 to itemCount - 1 do
            // add new item in list view
            lbImageList.Items.Add('');
    finally
        lbImageList.Items.EndUpdate;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageListEditorDlg.OnChange(setModified: Boolean);
var
    imageCount, index: NativeInt;
    actionEnabled:     Boolean;
    color:             TWColor;
begin
    // get image count
    imageCount := m_pImageList.Count;

    // get selected item index
    index := lbImageList.ItemIndex;

    // are actions enabled?
    actionEnabled := ((index >= 0) and (index < imageCount));

    btSaveToFile.Enabled     := actionEnabled;
    btEdit.Enabled           := actionEnabled;
    btDelete.Enabled         := actionEnabled;
    btColorKey.Enabled       := actionEnabled;
    tbOpacity.Enabled        := actionEnabled;
    paColorKeySample.Enabled := actionEnabled;

    // are move enabled?
    btMoveUp.Enabled   := actionEnabled and (imageCount > 1) and (index >= 1) and (index < imageCount);
    btMoveDown.Enabled := actionEnabled and (imageCount > 1) and (index >= 0) and (index < imageCount - 1);

    // can delete all items?
    btDeleteAll.Enabled := (imageCount > 0);

    // update the color key
    if (actionEnabled) then
    begin
        color                  := m_pImageList.GetSVGColorKey(index);
        paColorKeySample.Color := color.GetColor;
        tbOpacity.Position     := color.GetOpacity;
    end;

    // do set modified?
    if (setModified) then
        m_Modified := True;
end;
//---------------------------------------------------------------------------

end.
