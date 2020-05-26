{**
 @abstract(@name is the main parser for the Scalable Vector Graphics (SVG) files.)
 @author(JMR)
 @created(2016-2019 by Ursa Minor)
}
unit UTWSVGParser;

interface

uses System.SysUtils,
     System.Generics.Collections,
     Vcl.Graphics,
     {$ifdef USE_VERYSIMPLEXML}
         Xml.VerySimple,
     {$else}
         Xml.XMLIntf,
     {$endif}
     UTWSmartPointer,
     UTWColor,
     UTWHelpers,
     UTWSVGTags,
     UTWSVGMeasure,
     UTWSVGItems,
     UTWSVGProperties,
     UTWSVGElements,
     UTWSVGStyle;

type
    {**
     Scalable Vector Graphics (SVG) files parser
     @br @bold(NOTE) See http://www.w3.org/TR/SVGCompositing/
    }
    TWSVGParser = class(TWSVGContainer)
        public type
            {**
             SVG header
            }
            IHeader = class(TWSVGElement)
                public
                    {**
                     Constructor
                     @param(pParent Parent item, orphan or root if @nil)
                     @param(pOptions SVG options)
                    }
                    constructor Create(pParent: TWSVGItem; pOptions: PWSVGOptions); override;

                    {**
                     Destructor
                    }
                    destructor Destroy; override;

                    {**
                     Create new element instance
                     @param(pParent Parent item, orphan or root if @nil)
                     @returns(Element instance)
                    }
                    function CreateInstance(pParent: TWSVGItem): TWSVGElement; override;

                    {**
                     Read SVG element from xml
                     @param(pNode Xml node containing SVG element to read)
                     @returns(@true on success, otherwise @false)
                    }
                    {$ifdef USE_VERYSIMPLEXML}
                        function Read(const pNode: TXMLNode): Boolean; override;
                    {$else}
                        function Read(const pNode: IXMLNode): Boolean; override;
                    {$endif}

                    {**
                     Log content
                     @param(margin Margin length in chars)
                    }
                    procedure Log(margin: Cardinal); override;

                    {**
                     Print content to string
                     @param(margin Margin length in chars)
                     @returns(Content)
                    }
                    function Print(margin: Cardinal): UnicodeString; override;
            end;

        private
            {**
             Read the SVG define section
             @param(pNode Defs root xml node)
            }
            {$ifdef USE_VERYSIMPLEXML}
                function ReadDefs(const pNode: TXMLNode): Boolean;
            {$else}
                function ReadDefs(const pNode: IXMLNode): Boolean;
            {$endif}

            {**
             Log the SVG define section
             @param(margin Log margin in chars)
            }
            procedure LogDefs(margin: Cardinal);

            {**
             Print the SVG define section
             @param(margin Print margin in chars)
             @param(svgContent @bold([in, out]) SVG content string to print to)
            }
            procedure PrintDefs(margin: Cardinal; var svgContent: UnicodeString);

        public
            {**
             Constructor
             @param(pOptions SVG options)
            }
            constructor Create(pOptions: PWSVGOptions); reintroduce; virtual;

            {**
             Destructor
            }
            destructor Destroy; override;

            {**
             Create new element instance
             @param(pParent Parent item, orphan or root if @nil)
             @returns(Element instance)
            }
            function CreateInstance(pParent: TWSVGItem): TWSVGElement; override;

            {**
             Load SVG from xml document
             @param(pDocument Xml document)
             @returns(@true on success, otherwise @false)
            }
            {$ifdef USE_VERYSIMPLEXML}
                function Load(const pDocument: TXmlVerySimple): Boolean; virtual;
            {$else}
                function Load(const pDocument: IXMLDocument): Boolean; virtual;
            {$endif}

            {**
             Read element from xml
             @param(pNode Xml node to read)
             @returns(@true on success, otherwise @false)
            }
            {$ifdef USE_VERYSIMPLEXML}
                function Read(const pNode: TXMLNode): Boolean; override;
            {$else}
                function Read(const pNode: IXMLNode): Boolean; override;
            {$endif}

            {**
             Check if parser is empty
             @returns(@true if parser is empty, otherwise @false)
            }
            function IsEmpty: Boolean; virtual;

            {**
             Log content
             @param(margin Margin length in chars)
            }
            procedure Log(margin: Cardinal); override;

            {**
             Print content to string
             @param(margin Margin length in chars)
             @returns(Content)
            }
            function Print(margin: Cardinal): UnicodeString; override;

            {**
             Get xml formatted string
             @returns(String)
            }
            function ToXml: UnicodeString; override;
    end;

implementation
//---------------------------------------------------------------------------
// TWSVGParser.IHeader
//---------------------------------------------------------------------------
constructor TWSVGParser.IHeader.Create(pParent: TWSVGItem; pOptions: PWSVGOptions);
begin
    inherited Create(pParent, pOptions);

    // although it's not the real root object (this object is instead the TWSVGParser itself), the
    // header will contain all the root object properties. For that reason it takes the name of the
    // root SVG tag
    ItemName := C_SVG_Tag_Name;
end;
//---------------------------------------------------------------------------
destructor TWSVGParser.IHeader.Destroy;
begin
    inherited Destroy;
end;
//---------------------------------------------------------------------------
function TWSVGParser.IHeader.CreateInstance(pParent: TWSVGItem): TWSVGElement;
begin
    Result := IHeader.Create(pParent, m_pOptions);
end;
//---------------------------------------------------------------------------
{$ifdef USE_VERYSIMPLEXML}
    function TWSVGParser.IHeader.Read(const pNode: TXMLNode): Boolean;
{$else}
    function TWSVGParser.IHeader.Read(const pNode: IXMLNode): Boolean;
{$endif}
var
    color:                                   TWColor;
    pID:                                     TWSVGPropText;
    pVersion:                                TWSVGPropVersion;
    pX, pY, pWidth, pHeight, pBorderOpacity: TWSVGMeasure<Single>;
    pViewBox:                                TWSVGPropRect;
    pBg:                                     TWSVGPropBackground;
    pPageColor, pBorderColor:                TWSVGPropColor;
    pStyle:                                  TWSVGStyle;
begin
    // no xml node?
    if (not Assigned(pNode)) then
        Exit(False);

    pID := nil;

    try
        pID := TWSVGPropText.Create(Self, m_pOptions);

        // read identifier (optional)
        if (pID.Read(C_SVG_Prop_ID, pNode)) then
        begin
            m_pProperties.Add(pID);
            pID := nil;
        end;
    finally
        pID.Free;
    end;

    pVersion := nil;

    try
        pVersion := TWSVGPropVersion.Create(Self, m_pOptions);

        // read version (optional)
        if (pVersion.Read(C_SVG_Prop_Version, pNode)) then
        begin
            m_pProperties.Add(pVersion);
            pVersion := nil;
        end;
    finally
        pVersion.Free;
    end;

    pX := nil;

    try
        pX := TWSVGMeasure<Single>.Create(Self, m_pOptions, False);

        // read x position
        if (not pX.Read(C_SVG_Prop_X, pNode)) then
        begin
            pX.ItemName    := C_SVG_Prop_X;
            pX.MeasureUnit := TWSVGMeasure<Single>.IEUnit.IE_UN_PX;
            pX.Value       := 0.0;
        end;

        m_pProperties.Add(pX);
        pX := nil;
    finally
        pX.Free;
    end;

    pY := nil;

    try
        pY := TWSVGMeasure<Single>.Create(Self, m_pOptions, False);

        // read y position
        if (not pY.Read(C_SVG_Prop_Y, pNode)) then
        begin
            pY.ItemName    := C_SVG_Prop_Y;
            pY.MeasureUnit := TWSVGMeasure<Single>.IEUnit.IE_UN_PX;
            pY.Value       := 0.0;
        end;

        m_pProperties.Add(pY);
        pY := nil;
    finally
        pY.Free;
    end;

    Result := True;

    pWidth := nil;

    try
        // read width
        pWidth := TWSVGMeasure<Single>.Create(Self, m_pOptions, False);
        Result := pWidth.Read(C_SVG_Prop_Width, pNode) and Result;
        m_pProperties.Add(pWidth);
        pWidth := nil;
    finally
        pWidth.Free;
    end;

    pHeight := nil;

    try
        // read height
        pHeight := TWSVGMeasure<Single>.Create(Self, m_pOptions, False);
        Result  := pHeight.Read(C_SVG_Prop_Height, pNode) and Result;
        m_pProperties.Add(pHeight);
        pHeight := nil;
    finally
        pHeight.Free;
    end;

    pViewBox := nil;

    try
        pViewBox := TWSVGPropRect.Create(Self, m_pOptions);

        // read viewbox (optional)
        if (not pViewBox.Read(C_SVG_Prop_ViewBox, pNode)) then
        begin
            // set default viewbox (this property is optional in SVG, but can be used by rasterizer)
            pViewBox.ItemName := C_SVG_Prop_ViewBox;
            pViewBox.X        := 0.0;
            pViewBox.Y        := 0.0;
            pViewBox.Width    := 0.0;
            pViewBox.Height   := 0.0;
        end;

        m_pProperties.Add(pViewBox);
        pViewBox := nil;
    finally
        pViewBox.Free;
    end;

    pBg := nil;

    try
        pBg := TWSVGPropBackground.Create(Self, m_pOptions);

        // read enable-background property (optional)
        if (pBg.Read(C_SVG_Prop_Enable_Background, pNode)) then
        begin
            m_pProperties.Add(pBg);
            pBg := nil;
        end;
    finally
        pBg.Free;
    end;

    pPageColor := nil;

    try
        pPageColor := TWSVGPropColor.Create(Self, m_pOptions);

        // read page color (optional)
        if (not pPageColor.Read(C_SVG_Prop_Page_Color, pNode)) then
        begin
            color := TWColor.Create(clWhite);

            // set default page color (this property is optional in SVG, but can be used by rasterizer)
            pPageColor.ItemName := C_SVG_Prop_Page_Color;
            pPageColor.Add(@color);
        end;

        m_pProperties.Add(pPageColor);
        pPageColor := nil;
    finally
        pPageColor.Free;
    end;

    pBorderColor := nil;

    try
        pBorderColor := TWSVGPropColor.Create(Self, m_pOptions);

        // read border color (optional)
        if (pBorderColor.Read(C_SVG_Prop_Border_Color, pNode)) then
        begin
            m_pProperties.Add(pBorderColor);
            pBorderColor := nil;
        end;
    finally
        pBorderColor.Free;
    end;

    pBorderOpacity := nil;

    try
        pBorderOpacity := TWSVGMeasure<Single>.Create(Self, m_pOptions, False);

        // read border opacity (optional)
        if (pBorderOpacity.Read(C_SVG_Prop_Border_Opacity, pNode)) then
        begin
            m_pProperties.Add(pBorderOpacity);
            pBorderOpacity := nil;
        end;
    finally
        pBorderOpacity.Free;
    end;

    pStyle := nil;

    try
        pStyle := TWSVGStyle.Create(Self, m_pOptions);

        // read global style (optional)
        if (pStyle.Read(C_SVG_Prop_Style, pNode)) then
        begin
            pStyle.ItemName := C_SVG_Prop_Style;
            m_pProperties.Add(pStyle);
            pStyle          := nil;
        end;
    finally
        pStyle.Free;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGParser.IHeader.Log(margin: Cardinal);
begin
    TWLogHelper.LogBlockToCompiler(' Header ');

    inherited Log(margin);
end;
//---------------------------------------------------------------------------
function TWSVGParser.IHeader.Print(margin: Cardinal): UnicodeString;
begin
    Result := '<Header>' + #13 + #10 + inherited Print(margin);
end;
//---------------------------------------------------------------------------
// TWSVGParser
//---------------------------------------------------------------------------
constructor TWSVGParser.Create(pOptions: PWSVGOptions);
begin
    inherited Create(nil, pOptions);
end;
//---------------------------------------------------------------------------
destructor TWSVGParser.Destroy;
begin
    inherited Destroy;
end;
//---------------------------------------------------------------------------
{$ifdef USE_VERYSIMPLEXML}
    function TWSVGParser.ReadDefs(const pNode: TXMLNode): Boolean;
{$else}
    function TWSVGParser.ReadDefs(const pNode: IXMLNode): Boolean;
{$endif}
var
    {$ifdef USE_VERYSIMPLEXML}
        pChildNode: TXMLNode;
    {$else}
        pChildNode: IXMLNode;
    {$endif}
    count, i:       NativeInt;
    name:           UnicodeString;
    pGroup:         TWSVGGroup;
    pSwitch:        TWSVGSwitch;
    pAction:        TWSVGAction;
    pSymbol:        TWSVGSymbol;
    pClipPath:      TWSVGClipPath;
    pRect:          TWSVGRect;
    pCircle:        TWSVGCircle;
    pEllipse:       TWSVGEllipse;
    pLine:          TWSVGLine;
    pPolygon:       TWSVGPolygon;
    pPolyline:      TWSVGPolyline;
    pPath:          TWSVGPath;
    pText:          TWSVGText;
    pUse:           TWSVGUse;
begin
    count  := pNode.ChildNodes.Count;
    Result := True;

    // iterate through all child nodes
    for i := 0 to count - 1 do
    begin
        // get child node
        pChildNode := pNode.ChildNodes.Get(i);

        // found it?
        if (not Assigned(pChildNode)) then
            continue;

        // get child element name
        name := pChildNode.NodeName;

        {$ifdef USE_VERYSIMPLEXML}
            // trim all CRLF chars because very simple xml parser will not do that
            name := StringReplace(StringReplace(name, #10, '', [rfReplaceAll]), #13, '', [rfReplaceAll]);
        {$endif}

        // do skip blank text? (NOTE required because the XML parser consider each blank space
        // between the attributes as a generic #text attribute. For that unwished #text nodes may
        // appear while children are processed, and need to be ignored)
        if (name = C_SVG_Blank_Text_Attribute) then
            continue;

        // search for matching SVG element
        if (name = C_SVG_Tag_Group) then
        begin
            pGroup := nil;

            try
                // read group
                pGroup := TWSVGGroup.Create(Self, m_pOptions);
                Result := pGroup.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pGroup.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pGroup, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pGroup.ItemName);
                    Exit(False);
                end;

                pGroup := nil;
            finally
                pGroup.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Switch) then
        begin
            pSwitch := nil;

            try
                // read switch
                pSwitch := TWSVGSwitch.Create(Self, m_pOptions);
                Result  := pSwitch.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pSwitch.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pSwitch, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pSwitch.ItemName);
                    Exit(False);
                end;

                pSwitch := nil;
            finally
                pSwitch.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Action) then
        begin
            pAction := nil;

            try
                // read action
                pAction := TWSVGAction.Create(Self, m_pOptions);
                Result  := pAction.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pAction.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pAction, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pAction.ItemName);
                    Exit(False);
                end;

                pAction := nil;
            finally
                pAction.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Symbol) then
        begin
            pSymbol := nil;

            try
                // read symbol
                pSymbol := TWSVGSymbol.Create(Self, m_pOptions);
                Result  := pSymbol.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pSymbol.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pSymbol, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pSymbol.ItemName);
                    Exit(False);
                end;

                pSymbol := nil;
            finally
                pSymbol.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_ClipPath) then
        begin
            pClipPath := nil;

            try
                // read clip path
                pClipPath := TWSVGClipPath.Create(Self, m_pOptions);
                Result    := pClipPath.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pClipPath.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pClipPath, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pClipPath.ItemName);
                    Exit(False);
                end;

                pClipPath := nil;
            finally
                pClipPath.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Rect) then
        begin
            pRect := nil;

            try
                // read rectangle
                pRect  := TWSVGRect.Create(Self, m_pOptions);
                Result := pRect.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pRect.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pRect, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pRect.ItemName);
                    Exit(False);
                end;

                pRect := nil;
            finally
                pRect.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Circle) then
        begin
            pCircle := nil;

            try
                // read circle
                pCircle := TWSVGCircle.Create(Self, m_pOptions);
                Result  := pCircle.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pCircle.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pCircle, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pCircle.ItemName);
                    Exit(False);
                end;

                pCircle := nil;
            finally
                pCircle.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Ellipse) then
        begin
            pEllipse := nil;

            try
                // read ellipse
                pEllipse := TWSVGEllipse.Create(Self, m_pOptions);
                Result   := pEllipse.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pEllipse.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pEllipse, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pEllipse.ItemName);
                    Exit(False);
                end;

                pEllipse := nil;
            finally
                pEllipse.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Line) then
        begin
            pLine := nil;

            try
                // read line
                pLine  := TWSVGLine.Create(Self, m_pOptions);
                Result := pLine.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pLine.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pLine, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pLine.ItemName);
                    Exit(False);
                end;

                pLine := nil;
            finally
                pLine.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Polygon) then
        begin
            pPolygon := nil;

            try
                // read polygon
                pPolygon := TWSVGPolygon.Create(Self, m_pOptions);
                Result   := pPolygon.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pPolygon.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pPolygon, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pPolygon.ItemName);
                    Exit(False);
                end;

                pPolygon := nil;
            finally
                pPolygon.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Polyline) then
        begin
            pPolyline := nil;

            try
                // read polyline
                pPolyline := TWSVGPolyline.Create(Self, m_pOptions);
                Result    := pPolyline.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pPolyline.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pPolyline, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pPolyline.ItemName);
                    Exit(False);
                end;

                pPolyline := nil;
            finally
                pPolyline.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Path) then
        begin
            pPath := nil;

            try
                // read path
                pPath  := TWSVGPath.Create(Self, m_pOptions);
                Result := pPath.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pPath.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pPath, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pPath.ItemName);
                    Exit(False);
                end;

                pPath := nil;
            finally
                pPath.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Text) then
        begin
            pText := nil;

            try
                // read text
                pText  := TWSVGText.Create(Self, m_pOptions);
                Result := pText.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pText.ItemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pText, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pText.ItemName);
                    Exit(False);
                end;

                pText := nil;
            finally
                pText.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Use) then
        begin
            pUse := nil;

            try
                // read use instruction, which allows to reuse a geometry
                pUse   := TWSVGUse.Create(Self, m_pOptions);
                Result := pUse.Read(pChildNode) and Result;

                // is item identifier empty?
                if (not TWStringHelper.IsEmpty(pUse.ITemID)) then
                begin
                    // register the item
                    if (not RegisterLink(pUse, m_pDefs, False)) then
                        Exit(False);
                end
                else
                begin
                    TWLogHelper.LogToCompiler('Read defs - FAILED - item ID is empty - ' + pUse.ItemName);
                    Exit(False);
                end;

                pUse := nil;
            finally
                pUse.Free;
            end;
        end
        else
        if (name = C_SVG_Tag_Linear_Gradient) then
            Result := inherited ReadLinearGradient(pChildNode, m_pDefs) and Result
        else
        if (name = C_SVG_Tag_Radial_Gradient) then
            Result := inherited ReadRadialGradient(pChildNode, m_pDefs) and Result
        else
        if (name = C_SVG_Tag_Filter) then
            Result := inherited ReadFilter(pChildNode, m_pDefs) and Result;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGParser.LogDefs(margin: Cardinal);
var
    item: TPair<UnicodeString, TWSVGElement>;
begin
    if (m_pDefs.Count = 0) then
        Exit;

    //TWLogHelper.LogBlockToCompiler(' Defs ');

    // iterate through defines to log
    for item in m_pDefs do
        item.Value.Log(margin);
end;
//---------------------------------------------------------------------------
procedure TWSVGParser.PrintDefs(margin: Cardinal; var svgContent: UnicodeString);
var
    item: TPair<UnicodeString, TWSVGElement>;
begin
    if (m_pDefs.Count = 0) then
        Exit;

    svgContent := '<Defs>' + #13 + #10;

    // iterate through defines to print
    for item in m_pDefs do
        svgContent := svgContent + item.Value.Print(margin);

    svgContent := svgContent + '</Defs>' + #13 + #10;
end;
//---------------------------------------------------------------------------
function TWSVGParser.CreateInstance(pParent: TWSVGItem): TWSVGElement;
begin
    Result := TWSVGParser.Create(m_pOptions);
end;
//---------------------------------------------------------------------------
{$ifdef USE_VERYSIMPLEXML}
    function TWSVGParser.Load(const pDocument: TXmlVerySimple): Boolean;
{$else}
    function TWSVGParser.Load(const pDocument: IXMLDocument): Boolean;
{$endif}
var
    {$ifdef USE_VERYSIMPLEXML}
        pNode: TXMLNode;
    {$else}
        pNode: IXMLNode;
    {$endif}
begin
    // get first xml element
    pNode := pDocument.DocumentElement;

    if (not Assigned(pNode)) then
        Exit(False);

    Result := Read(pNode);
end;
//---------------------------------------------------------------------------
{$ifdef USE_VERYSIMPLEXML}
    function TWSVGParser.Read(const pNode: TXMLNode): Boolean;
{$else}
    function TWSVGParser.Read(const pNode: IXMLNode): Boolean;
{$endif}
var
    count, i:       NativeInt;
    {$ifdef USE_VERYSIMPLEXML}
        pChildNode: TXMLNode;
    {$else}
        pChildNode: IXMLNode;
    {$endif}
    name:           UnicodeString;
    pHeader:        IHeader;
begin
    pHeader := nil;

    try
        // read SVG document header
        pHeader          := IHeader.Create(Self, m_pOptions);
        pHeader.ItemName := C_SVG_Tag_Name;
        pHeader.Read(pNode);
        m_pElements.Add(pHeader);
        pHeader := nil;
    finally
        pHeader.Free;
    end;

    count  := pNode.ChildNodes.Count;
    Result := True;

    // iterate through all child elements
    for i := 0 to count - 1 do
    begin
        // get child node
        pChildNode := pNode.ChildNodes.Get(i);

        // found it?
        if (not Assigned(pChildNode)) then
            continue;

        // get child element name
        name := pChildNode.NodeName;

        {$ifdef USE_VERYSIMPLEXML}
            // trim all CRLF chars because very simple xml parser will not do that
            name := StringReplace(StringReplace(name, #10, '', [rfReplaceAll]), #13, '', [rfReplaceAll]);
        {$endif}

        // do skip blank text? (NOTE required because the XML parser consider each blank space
        // between the attributes as a generic #text attribute. For that unwished #text nodes may
        // appear while children are processed, and need to be ignored)
        if (name = C_SVG_Blank_Text_Attribute) then
            continue;

        // search for matching SVG element
        if (name = C_SVG_Tag_Defs) then
            Result := ReadDefs(pChildNode) and Result
        else
            // read next item
            Result := inherited ReadItem(name, pChildNode, m_pDefs, m_pElements) and Result;
    end;
end;
//---------------------------------------------------------------------------
function TWSVGParser.IsEmpty: Boolean;
begin
    Result := (m_pElements.Count = 0);
end;
//---------------------------------------------------------------------------
procedure TWSVGParser.Log(margin: Cardinal);
var
    index:     NativeUInt;
    pProperty: TWSVGProperty;
    pElement:  TWSVGElement;
begin
    // iterate through properties to log
    for pProperty in m_pProperties do
        pProperty.Log(margin);

    index := 0;

    // iterate through properties to log
    for pElement in m_pElements do
    begin
        // log defs at this position, because the first element should always be the header
        if (index = 1) then
            LogDefs(margin);

        pElement.Log(margin);

        Inc(index);
    end;

    // log defs at this position, if still not logged
    if (index = 1) then
        LogDefs(margin);
end;
//---------------------------------------------------------------------------
function TWSVGParser.Print(margin: Cardinal): UnicodeString;
var
    index:     NativeUInt;
    pProperty: TWSVGProperty;
    pElement:  TWSVGElement;
begin
    Result := '';

    // iterate through properties to log
    for pProperty in m_pProperties do
        Result := Result + pProperty.Print(margin);

    index  := 0;

    // iterate through properties to print
    for pElement in m_pElements do
    begin
        // print defs at this position, because the first element should always be the header
        if (index = 1) then
            PrintDefs(margin, Result);

        Result := Result + pElement.Print(margin);

        Inc(index);
    end;

    // print defs at this position, if still not printed
    if (index = 1) then
        PrintDefs(margin, Result);
end;
//---------------------------------------------------------------------------
function TWSVGParser.ToXml: UnicodeString;
begin
    raise Exception.Create('NOT IMPLEMENTED');
end;
//---------------------------------------------------------------------------

end.
