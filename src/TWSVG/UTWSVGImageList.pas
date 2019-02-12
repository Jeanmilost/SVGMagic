{**
 @abstract(@name provides an overridden image list that supports the SVG graphics.)
 @author(JMR)
 @created(2016-2018 by Ursa Minor)
}
unit UTWSVGImageList;

interface

uses System.SysUtils,
     System.Classes,
     System.Generics.Collections,
     Vcl.Graphics,
     Vcl.ImgList,
     Winapi.Windows,
     UTWMajorSettings,
     UTWColor,
     UTWHelpers,
     UTWSmartPointer,
     UTWSVGGraphic;

type
    {**
     Image list override that supports SVG graphics
    }
    TWSVGImageList = class(TCustomImageList)
        private type
            {**
             Picture item
            }
            IWPictureItem = class
                private
                    m_pPicture: TPicture;
                    m_ColorKey: TWColor;

                public
                    {**
                     Constructor
                    }
                    constructor Create; virtual;

                    {**
                     Destructor
                    }
                    destructor Destroy; override;

                    {**
                     Assign (i.e. copy) the content from another component
                     @param(pSource Source component to copy from
                    }
                    procedure Assign(pSource: IWPictureItem); virtual;
            end;

            {**
             Picture list
            }
            IWPictureList = TObjectList<IWPictureItem>;

        private
            m_pPictures: IWPictureList;
            m_Graphics:  array of TWSVGGraphic;

            {**
             Get the library version
             @returns(Library version, #ERROR on error)
            }
            function GetVersion: UnicodeString;

            {**
             Backup the SVG list content in a temporary array
            }
            procedure Backup;

            {**
             Restore the SVG list content from a temporary array
            }
            procedure Restore;

        protected
            {**
             Set image list width
             @param(value New width to set)
            }
            procedure SetWidth(value: Integer); virtual;

            {**
             Set image list height
             @param(value New height to set)
            }
            procedure SetHeight(value: Integer); virtual;

            {**
             Rasterize the SVG onto a bitmap image and add or insert it inside the base image list
             @param(index Index at which the SVG will be inserted, if -1 will be added on the end)
             @param(pSVG SVG image to add or insert)
             @param(colorKey Color key to use as transparent background for the SVG)
             @param(doReplace If true, the image will replace another image at index instead of insert it)
             @returns(The newly added or inserted position in the list)
            }
            function RasterizeAndAssign(index: Integer; pSVG: TWSVGGraphic; colorKey: TColor;
                    doReplace: Boolean): Integer; virtual;

            {**
             Declares properties that will deal with DFM files
             @param(pFiler DFM file manager)
            }
            procedure DefineProperties(pFiler: TFiler); override;

            {**
             Read the pictures data from DFM stream
             @param(pStream DFM stream containing the pictures to read)
            }
            procedure ReadPictures(pStream: TStream); virtual;

            {**
             Write the pictures data to DFM stream
             @param(pStream DFM stream containing the pictures to write)
            }
            procedure WritePictures(pStream: TStream); virtual;

            {**
             Save the picture list content to a stream
             @param(pList Picture list to save)
             @param(pStream Stream to save to)
            }
            procedure SavePictureListToStream(pList: IWPictureList; pStream: TStream); virtual;

            {**
             Load the picture list content from a stream
             @param(pList Picture list to populate)
             @param(pStream Stream to load from)
            }
            procedure LoadPictureListFromStream(pList: IWPictureList; pStream: TStream); virtual;

            {**
             Process the draw on the canvas
             @param(index Image index to draw on canvas)
             @param pCanvas Canvas to draw on)
             @param(x X position in pixels at which the image should be drawn)
             @param(y Y position in pixels at which the image should be drawn)
             @param(style Style to apply to image)
             @param enabled If @False, the disabled style will be applied on the image)
            }
            procedure DoDraw(index: Integer; pCanvas: TCanvas; x, y: Integer;
                    style: Cardinal; enabled: Boolean = True); override;

        protected
            property ColorDepth;
            property DrawingStyle;
            property GrayscaleFactor;
            property ImageType;
            property Masked;
            property ShareImages;

        public
            {**
             Constructor
             @param(pOwner Component owner)
            }
            constructor Create(pOwner: TComponent); override;

            {**
             Constructor
             @param(width Width of the images owned by the image list)
             @param(height Height of the images owned by the image list)
            }
            constructor CreateSize(width, height: Integer); virtual;

            {**
             Destructor
            }
            destructor Destroy; override;

            {**
             Clear the entire image list content
            }
            procedure Clear; virtual;

            {**
             Assign (i.e. copy) the content from another component
             @param(pSource Source component to copy from
            }
            procedure Assign(pSource: TPersistent); override;

            {**
             Set the image list size
             @param(newWidth New image list width)
             @param(newHeight New image list height)
            }
            procedure SetSize(newWidth, newHeight: Integer); virtual;

            {**
             Add a new SVG image inside the list
             @param(pSVG SVG image to add)
             @param(colorKey Color key to use with the image, if clNone the color will be those defined in BkColor)
             @returns(Index of the newly added image, -1 on error)
            }
            function AddSVG(pSVG: TWSVGGraphic; colorKey: TColor = clNone): Integer; virtual;

            {**
             Insert a new SVG image inside the list
             @param(index Index where the SVG will be inserted)
             @param(pSVG SVG image to add)
             @param(colorKey Color key to use with the image, if clNone the color will be those defined in BkColor)
            }
            procedure InsertSVG(index: Integer; pSVG: TWSVGGraphic; colorKey: TColor = clNone); virtual;

            {**
             Replace a SVG image by another
             @param(index Index of the SVG to replace)
             @param(pSVG SVG image to replace by)
             @param(colorKey Color key to use with the image, if clNone the color will be those defined in BkColor)
            }
            procedure ReplaceSVG(index: Integer; pSVG: TWSVGGraphic; colorKey: TColor = clNone); virtual;

            {**
             Delete a SVG image at index
             @param(index Index of the SVG to delete)
            }
            procedure DeleteSVG(index: Integer); virtual;

            {**
             Get the SVG image at index
             @param(index Index of the SVG to get)
             @returns(The SVG image, @nil on error or if not found)
            }
            function GetSVG(index: Integer): TWSVGGraphic; virtual;

            {**
             Get the SVG image color key at index
             @param(index Index of the color key to get)
             @returns(The color key, default color on error or if not found)
            }
            function GetSVGColorKey(index: Integer): TWColor; virtual;

            {**
             Set the SVG image color key at index
             @param(index Index of the color key to set)
             @param(colorKey The new color key to set)
            }
            procedure SetSVGColorKey(index: Integer; const colorKey: TWColor); virtual;

        published
            {**
             Get the library version number
            }
            property Version: UnicodeString read GetVersion;

            {**
             Get or set the blend color
            }
            property BlendColor;

            {**
             Get or set the background color
            }
            property BkColor default clBtnFace;

            {**
             Get or set the number of items the list view can store in memory
            }
            property AllocBy;

            {**
             Get or set the height
            }
            property Height write SetHeight;

            {**
             Get or set the width
            }
            property Width write SetWidth;

            {**
             Get or set the OnChange event
            }
            property OnChange;
    end;

implementation
//---------------------------------------------------------------------------
// TWSVGImageList.IWPictureItem
//---------------------------------------------------------------------------
constructor TWSVGImageList.IWPictureItem.Create;
begin
    inherited Create;

    m_pPicture := TPicture.Create;

    m_ColorKey.Clear;
end;
//---------------------------------------------------------------------------
destructor TWSVGImageList.IWPictureItem.Destroy;
begin
    FreeAndNil(m_pPicture);

    inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.IWPictureItem.Assign(pSource: IWPictureItem);
begin
    if (not Assigned(pSource)) then
        Exit;

    m_pPicture.Assign(pSource.m_pPicture);
    m_ColorKey.Assign(pSource.m_ColorKey);
end;
//---------------------------------------------------------------------------
// TWSVGImageList
//---------------------------------------------------------------------------
constructor TWSVGImageList.Create(pOwner: TComponent);
begin
    inherited Create(pOwner);

    // override several base values
    BkColor      := clBtnFace;
    ColorDepth   := cd32bit;
    DrawingStyle := dsTransparent;
    Masked       := False;

    m_pPictures := TObjectList<IWPictureItem>.Create;
end;
//---------------------------------------------------------------------------
constructor TWSVGImageList.CreateSize(width, height: Integer);
begin
    inherited CreateSize(width, height);

    // override several base values
    BkColor      := clBtnFace;
    ColorDepth   := cd32bit;
    DrawingStyle := dsTransparent;
    Masked       := False;

    m_pPictures := TObjectList<IWPictureItem>.Create;
end;
//---------------------------------------------------------------------------
destructor TWSVGImageList.Destroy;
var
    localCount, i: Integer;
begin
    localCount := Length(m_Graphics);

    // free the local array items
    for i := 0 to localCount - 1 do
        m_Graphics[i].Free;

    FreeAndNil(m_pPictures);

    inherited Destroy;
end;
//---------------------------------------------------------------------------
function TWSVGImageList.GetVersion: UnicodeString;
begin
    if (not Assigned(TWLibraryVersion)) then
        Exit('#ERROR');

    Result := TWLibraryVersion.ToStr;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.Backup;
var
    i: Integer;
begin
    // initialize the local array in which the list content will be saved
    SetLength(m_Graphics, Count);

    // save the list content
    for i := 0 to Count - 1 do
    begin
        m_Graphics[i] := TWSVGGraphic.Create;
        m_Graphics[i].Assign(GetSVG(i));
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.Restore;
var
    localCount, i: Integer;
begin
    localCount := Length(m_Graphics);

    // restore the list content from the local array and free the local array items
    for i := 0 to localCount - 1 do
    begin
        AddSVG(m_Graphics[i]);
        m_Graphics[i].Free;
    end;

    // clear the local list
    SetLength(m_Graphics, 0);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.SetWidth(value: Integer);
begin
    if (Width = value) then
        Exit;

    try
        Backup;
        Clear;
        inherited Width := value;
    finally
        Restore;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.SetHeight(value: Integer);
begin
    if (Height = value) then
        Exit;

    try
        Backup;
        Clear;
        inherited Height := value;
    finally
        Restore;
    end;
end;
//---------------------------------------------------------------------------
function TWSVGImageList.RasterizeAndAssign(index: Integer; pSVG: TWSVGGraphic; colorKey: TColor;
        doReplace: Boolean): Integer;
var
    pBitmap:      IWSmartPointer<Vcl.Graphics.TBitmap>;
    pPictureItem: IWPictureItem;
    color:        TWColor;
begin
    Result := index;

    if (not Assigned(pSVG)) then
        Exit;

    // create a bitmap image in which the SVG will be rasterized for the base image list
    pBitmap        := TWSmartPointer<Vcl.Graphics.TBitmap>.Create();
    pBitmap.Width  := Width;
    pBitmap.Height := Height;

    // select a color key. By default, use the user defined background color
    if (colorKey <> clNone) then
        color.SetColor(colorKey)
    else
    if (BkColor <> clNone) then
        color.SetColor(BkColor)
    else
        color.Clear;

    // fill bitmap with color key
    pBitmap.Canvas.Brush.Color := color.GetColor;
    pBitmap.Canvas.Brush.Style := bsSolid;
    pBitmap.Canvas.FillRect(TRect.Create(0, 0, pBitmap.Width, pBitmap.Height));

    pPictureItem := nil;

    try
        // create and populate new picture item
        pPictureItem := IWPictureItem.Create;
        pPictureItem.m_ColorKey.Assign(color);

        // copy the SVG in the picture item, and update his size to match with the rendering size
        pPictureItem.m_pPicture.Assign(pSVG);
        pPictureItem.m_pPicture.Graphic.Width  := Width  - 1;
        pPictureItem.m_pPicture.Graphic.Height := Height - 1;

        // rasterize the SVG onto the bitmap
        pBitmap.Canvas.Draw(0, 0, pPictureItem.m_pPicture.Graphic);

        // add, insert or replace the rasterized SVG in the base image list
        if (doReplace) then
        begin
            Replace(index, pBitmap, nil);

            // replace the SVG in the picture list
            if (index < m_pPictures.Count) then
                m_pPictures[index].Assign(pPictureItem);
        end
        else
        if (index < 0) then
        begin
            index  := Add(pBitmap, nil);
            Result := index;

            // add the SVG in the picture list
            Assert(m_pPictures.Add(pPictureItem) = index);
            pPictureItem := nil;
        end
        else
        begin
            Insert(index, pBitmap, nil);

            // insert the SVG in the picture list
            m_pPictures.Insert(index, pPictureItem);
            pPictureItem := nil;
        end;
    finally
        if (Assigned(pPictureItem)) then
            pPictureItem.Free;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.DefineProperties(pFiler: TFiler);
    function DoWritePictures: Boolean;
    begin
        if (Assigned(pFiler.Ancestor)) then
            Result := not (pFiler.Ancestor is TWSVGImageList)
        else
            Result := Count > 0;
    end;
begin
    inherited DefineProperties(pFiler);

    // register the properties that will load and save the pictures binary data in DFM files
    pFiler.DefineBinaryProperty('Pictures', ReadPictures, WritePictures, DoWritePictures);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.ReadPictures(pStream: TStream);
begin
    LoadPictureListFromStream(m_pPictures, pStream);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.WritePictures(pStream: TStream);
begin
    SavePictureListToStream(m_pPictures, pStream);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.SavePictureListToStream(pList: IWPictureList; pStream: TStream);
var
    count, i:     Integer;
    color:        Cardinal;
    imgClassName: string;
    imgNameBytes: TBytes;
    pMemStr:      TMemoryStream;
    size:         Int64;
begin
    // write the list count
    count := pList.Count;
    pStream.WriteBuffer(count, SizeOf(count));

    if (count = 0) then
        Exit;

    pMemStr := TMemoryStream.Create;

    try
        for i := 0 to count - 1 do
        begin
            // a picture should always be assigned in the list so this should never happen
            if (not Assigned(pList[i].m_pPicture.Graphic)) then
            begin
                TWLogHelper.LogToCompiler('Internal error - picture list is corrupted - ' + Name);

                // write empty size to prevent to corrupt the stream
                size := 0;
                pStream.WriteBuffer(size, SizeOf(size));
                pStream.WriteBuffer(size, SizeOf(size));
            end
            else
            begin
                // save the image type in the stream
                imgClassName := pList[i].m_pPicture.Graphic.ClassName;
                imgNameBytes := TEncoding.UTF8.GetBytes(imgClassName);
                size         := Length(imgNameBytes);
                pStream.WriteBuffer(size, SizeOf(size));
                pStream.Write(imgNameBytes, size);

                // save the image in the stream
                pList[i].m_pPicture.Graphic.SaveToStream(pMemStr);
                size := pMemStr.Size;
                pStream.WriteBuffer(size, SizeOf(size));
                pStream.CopyFrom(pMemStr, 0);
                pMemStr.Clear;
            end;

            // build the key color to save
            color := (pList[i].m_ColorKey.GetBlue          +
                     (pList[i].m_ColorKey.GetGreen shl 8)  +
                     (pList[i].m_ColorKey.GetRed   shl 16) +
                     (pList[i].m_ColorKey.GetAlpha shl 24));

            // save the key color in the stream
            size := SizeOf(color);
            pStream.WriteBuffer(size,  SizeOf(size));
            pStream.WriteBuffer(color, size);
        end;
    finally
        pMemStr.Free;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.LoadPictureListFromStream(pList: IWPictureList; pStream: TStream);
var
    count, i:      Integer;
    color:         Cardinal;
    imgClassName:  string;
    imgNameBytes:  TBytes;
    pMemStr:       TMemoryStream;
    size:          Int64;
    pItem:         IWPictureItem;
    pGraphicClass: TGraphicClass;
    pGraphic:      TGraphic;
begin
    // read the list count
    pStream.ReadBuffer(count, SizeOf(count));

    // is list empty?
    if (count <= 0) then
        Exit;

    pMemStr := TMemoryStream.Create;

    try
        for i := 0 to count - 1 do
        begin
            pItem := IWPictureItem.Create;

            try
                // read the next size
                pStream.ReadBuffer(size, SizeOf(size));

                // read the image type from stream
                if (size > 0) then
                begin
                    SetLength(imgNameBytes, size);
                    pStream.Read(imgNameBytes, size);
                    imgClassName := TEncoding.UTF8.GetString(imgNameBytes);
                end;

                // read the next size
                pStream.ReadBuffer(size, SizeOf(size));

                // read the image from stream
                if (size > 0) then
                begin
                    // read the image in a temporary memory stream
                    pMemStr.CopyFrom(pStream, size);
                    pMemStr.Position := 0;

                    // get the graphic class to create
                    if (imgClassName = 'TWSVGGraphic') then
                        pGraphicClass := TWSVGGraphic
                    else
                    begin
                        TWLogHelper.LogToCompiler('Internal error - unknown graphic class - '
                                + imgClassName + ' - name - ' + Name);
                        pGraphicClass := nil;
                    end;

                    // found it?
                    if (Assigned(pGraphicClass)) then
                    begin
                        pGraphic := nil;

                        try
                            // create a matching graphic to receive the image data
                            pGraphic := pGraphicClass.Create;
                            pGraphic.LoadFromStream(pMemStr);
                            pItem.m_pPicture.Assign(pGraphic);
                        finally
                            pGraphic.Free;
                        end;
                    end;

                    pMemStr.Clear;
                end;

                // read the next size
                pStream.ReadBuffer(size, SizeOf(size));

                // read the color key from stream
                if (size > 0) then
                begin
                    Assert(size = SizeOf(color));
                    pStream.ReadBuffer(color, size);

                    // get the color key
                    pItem.m_ColorKey := TWColor.Create((color shr 16) and $FF,
                                                       (color shr 8)  and $FF,
                                                        color         and $FF,
                                                       (color shr 24) and $FF);
                end;

                // add item to list
                pList.Add(pItem);
            except
                pItem.Free;
                raise;
            end;
        end;
    finally
        pMemStr.Free;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.DoDraw(index: Integer; pCanvas: TCanvas; x, y: Integer; style: Cardinal;
        enabled: Boolean = True);
var
    pPictureItem: IWPictureItem;
begin
    // is image to draw a registered picture? (NOTE all images added with the TImageList base
    // functions will not appear in this list, so let the base image list process the drawing in
    // this case)
    if ((index >= 0) and (index < m_pPictures.Count)) then
    begin
        // get picture item to draw
        pPictureItem := m_pPictures.Items[index];

        // found it?
        if (Assigned(pPictureItem)) then
            // do draw a SVG graphic?
            if (pPictureItem.m_pPicture.Graphic is TWSVGGraphic) then
            begin
                // fill the background with the color key
                if (pPictureItem.m_ColorKey.GetAlpha <> 0) then
                begin
                    pCanvas.Brush.Color := pPictureItem.m_ColorKey.GetColor;
                    pCanvas.Brush.Style := bsSolid;
                    pCanvas.FillRect(TRect.Create(x, y, x + Width, y + Height));
                end
                else
                if (pCanvas.Pixels[0, y] = clFuchsia) then
                begin
                    pCanvas.Brush.Color := clBtnFace;
                    pCanvas.Brush.Style := bsSolid;
                    pCanvas.FillRect(TRect.Create(x, y, x + Width, y + Height));
                end;

                // update the image size before painting it
                pPictureItem.m_pPicture.Graphic.Width  := Width  - 1;
                pPictureItem.m_pPicture.Graphic.Height := Height - 1;

                // draw the SVG image above
                pCanvas.Draw(x, y, pPictureItem.m_pPicture.Graphic);
                Exit;
            end;
    end;

    inherited DoDraw(index, pCanvas, x, y, style, enabled);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.Clear;
begin
    inherited Clear;

    // clear all pictures. NOTE the object dictionary will take care to also delete the picture items
    m_pPictures.Clear;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.Assign(pSource: TPersistent);
var
    pSrcImgList:  TWSVGImageList;
    pItem:        IWPictureItem;
    pPictureItem: IWPictureItem;
begin
    // clear the previous content
    Clear;

    inherited Assign(pSource);

    // no source or not a SVG image list?
    if (not Assigned(pSource) or not (pSource is TWSVGImageList)) then
        Exit;

    // get source as SVG image list
    pSrcImgList := pSource as TWSVGImageList;

    // iterate through source picture items
    for pItem in pSrcImgList.m_pPictures do
    begin
        pPictureItem := nil;

        try
            // create a local picture item and copy content from source
            pPictureItem := IWPictureItem.Create;
            pPictureItem.Assign(pItem);

            // add copied item to local list
            m_pPictures.Add(pPictureItem);
            pPictureItem := nil;
        finally
            pPictureItem.Free;
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.SetSize(newWidth, newHeight: Integer);
begin
    if ((Width = newWidth) and (Height = newHeight)) then
        Exit;

    try
        Backup;
        Clear;
        inherited SetSize(newWidth, newHeight);

    finally
        Restore;
    end;
end;
//---------------------------------------------------------------------------
function TWSVGImageList.AddSVG(pSVG: TWSVGGraphic; colorKey: TColor): Integer;
begin
    Result := RasterizeAndAssign(-1, pSVG, colorKey, False);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.InsertSVG(index: Integer; pSVG: TWSVGGraphic; colorKey: TColor);
begin
    RasterizeAndAssign(index, pSVG, colorKey, False);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.ReplaceSVG(index: Integer; pSVG: TWSVGGraphic; colorKey: TColor);
begin
    RasterizeAndAssign(index, pSVG, colorKey, True);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.DeleteSVG(index: Integer);
begin
    // delete the rasterized image in the base list
    Delete(index);

    // also delete it in the picture list
    if (index < m_pPictures.Count) then
        m_pPictures.Delete(index);
end;
//---------------------------------------------------------------------------
function TWSVGImageList.GetSVG(index: Integer): TWSVGGraphic;
var
    pPictureItem: IWPictureItem;
begin
    // image exists in list? (NOTE all images added with the TImageList base functions will not
    // appear in this list)
    if (index >= m_pPictures.Count) then
        Exit(nil);

    // get picture item to draw
    pPictureItem := m_pPictures.Items[index];

    // found it?
    if (not Assigned(pPictureItem)) then
        Exit(nil);

    // is picture something else than a SVG?
    if (not (pPictureItem.m_pPicture.Graphic is TWSVGGraphic)) then
        Exit(nil);

    Result := pPictureItem.m_pPicture.Graphic as TWSVGGraphic;
end;
//---------------------------------------------------------------------------
function TWSVGImageList.GetSVGColorKey(index: Integer): TWColor;
var
    pPictureItem: IWPictureItem;
begin
    // image exists in list? (NOTE all images added with the TImageList base functions will not
    // appear in this list)
    if (index >= m_pPictures.Count) then
        Exit(TWColor.GetDefault);

    // get picture item to draw
    pPictureItem := m_pPictures.Items[index];

    // found it?
    if (not Assigned(pPictureItem)) then
        Exit(TWColor.GetDefault);

    Result := pPictureItem.m_ColorKey;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageList.SetSVGColorKey(index: Integer; const colorKey: TWColor);
var
    pPictureItem: IWPictureItem;
begin
    // image exists in list? (NOTE all images added with the TImageList base functions will not
    // appear in this list)
    if (index >= m_pPictures.Count) then
        Exit;

    // get picture item to draw
    pPictureItem := m_pPictures.Items[index];

    // found it?
    if (not Assigned(pPictureItem)) then
        Exit;

    pPictureItem.m_ColorKey.Assign(colorKey);
end;
//---------------------------------------------------------------------------

end.
