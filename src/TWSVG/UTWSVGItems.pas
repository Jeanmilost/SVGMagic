{**
 @abstract(@name provides the basic items that a SVG may contain.)
 @author(JMR)
 @created(2016-2019 by Ursa Minor)
}
unit UTWSVGItems;

interface

uses System.Generics.Collections,
     {$ifdef USE_VERYSIMPLEXML}
         Xml.VerySimple,
     {$else}
         Xml.XMLIntf,
     {$endif}
     UTWSVGTags,
     UTWSVGCommon;

type
    // enable the line below if you want to log and print the reference content
    //{$define ENABLE_REFERENCE_LOGS}

    {**
     Scalable Vector Graphics (SVG) options
    }
    TWSVGOptions = record
        m_TrustSVGSyntax: Boolean;
    end;

    PWSVGOptions = ^TWSVGOptions;

    {**
     Scalable Vector Graphics (SVG) item
    }
    TWSVGItem = class
        private
            m_Name:    UnicodeString;
            m_ID:      UnicodeString;
            m_pParent: TWSVGItem;

        protected
            m_pOptions: PWSVGOptions;

        public
            {**
             Constructor
             @param(pParent Parent item, orphan or root if @nil)
             @param(pOptions SVG options)
            }
            constructor Create(pParent: TWSVGItem; pOptions: PWSVGOptions); virtual;

            {**
             Destructor
            }
            destructor Destroy; override;

            {**
             Assign (i.e. copy) content from another item
             @param(pOther Other item to copy from)
            }
            procedure Assign(const pOther: TWSVGItem); virtual;

            {**
             Clear
            }
            procedure Clear; virtual;

            {**
             Log content
             @param(margin Margin length in chars)
            }
            procedure Log(margin: Cardinal); virtual; abstract;

            {**
             Print content to string
             @param(margin Margin length in chars)
             @returns(Content)
            }
            function Print(margin: Cardinal): UnicodeString; virtual; abstract;

            {**
             Get xml formatted string
             @returns(String)
            }
            function ToXml: UnicodeString; virtual; abstract;

        public
            {**
             Get or set the item name
            }
            property ItemName: UnicodeString read m_Name write m_Name;

            {**
             Get or set the item identifier
            }
            property ItemID: UnicodeString read m_ID write m_ID;

            {**
             Get the parent item
            }
            property Parent: TWSVGItem read m_pParent;

            {**
             Get the options
             @br @bold(NOTE) BE CAREFUL, the options should never be changed from outside
            }
            property Options: PWSVGOptions read m_pOptions;
    end;

    {**
     A Scalable Vector Graphics (SVG) property is a data contained in an element, indicating the value
     of a particular variable. For example, a fill color, a stroke width, ...
     @br @bold(NOTE) In Inkscape files, properties containing the namespace sodipodi can be ignored,
                     they are reminiscent of the first Inkscape application version, when it was still
                     called SodiPodi
    }
    TWSVGProperty = class(TWSVGItem)
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
             Create new property instance
             @param(pParent Parent item, orphan or root if @nil)
             @returns(Property instance)
            }
            function CreateInstance(pParent: TWSVGItem): TWSVGProperty; virtual; abstract;

            {**
             Read property
             @param(name Xml tag name)
             @param(pNode Xml node containing property to read)
             @returns(@true on success, otherwise @false)
            }
            {$ifdef USE_VERYSIMPLEXML}
                function Read(const name: UnicodeString; const pNode: TXMLNode): Boolean; virtual;
            {$else}
                function Read(const name: UnicodeString; const pNode: IXMLNode): Boolean; virtual;
            {$endif}

            {**
             Parse data
             @param(data Data to parse)
             @returns(@true on success, otherwise @false)
            }
            function Parse(const data: UnicodeString): Boolean; virtual; abstract;
    end;

    {**
     A Scalable Vector Graphics (SVG) element is a data describing a part of the drawing or an action
     to be undertaken when drawing an SVG. It may contain a path to draw, a gradient to apply to a
     painting surface, an animation to apply to a shape, ...
    }
    TWSVGElement = class(TWSVGItem)
        public type
            IElements   = TObjectList<TWSVGElement>;
            IProperties = TObjectList<TWSVGProperty>;

        protected
            m_pProperties: IProperties;

            {**
             Delete and clear all data
            }
            procedure DelAndClear;

        protected
            {**
             Get property at index
             @param(index Property index)
             @returns(Property, @nil if not found or on error)
            }
            function GetProperty(index: Integer): TWSVGProperty; virtual;

            {**
             Get property count
             @returns(Property count)
            }
            function GetPropertyCount: Integer; virtual;

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
             Assign (i.e. copy) content from another item
             @param(pOther Other item to copy from)
            }
            procedure Assign(const pOther: TWSVGItem); override;

            {**
             Clear
            }
            procedure Clear; override;

            {**
             Create new element instance
             @param(pParent Parent item, orphan or root if @nil)
             @returns(Element instance)
            }
            function CreateInstance(pParent: TWSVGItem): TWSVGElement; virtual; abstract;

            {**
             Read SVG element from xml
             @param(pNode Xml node containing SVG element to read)
             @returns(@true on success, otherwise @false)
            }
            {$ifdef USE_VERYSIMPLEXML}
                function Read(const pNode: TXMLNode): Boolean; virtual; abstract;
            {$else}
                function Read(const pNode: IXMLNode): Boolean; virtual; abstract;
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

            {**
             Get xml formatted string
             @returns(String)
            }
            function ToXml: UnicodeString; override;

            {**
             Add a property
             @param(pProperty Property to add)
            }
            procedure AddProperty(const pProperty: TWSVGProperty); virtual;

        public
            {**
             Get the property at index. Example: property := Properties[0];
             @br @bold(NOTE) @nil will be returned if index is out of bounds
            }
            property Properties[index: Integer]: TWSVGProperty read GetProperty;

            {**
             Get the properties count
            }
            property Count: Integer read GetPropertyCount;
    end;

    {**
     A Scalable Vector Graphics (SVG) reference is a special element referring to another element
     @br @bold(NOTE) Although this class mentionates that it contains a reference, it is not really
                     the case, as this class contains a clone instead. The reference naming for this
                     class comes from the c++ mirror project, where it was possible to keep a reference
                     to an outside pointer. Here a such relationship isn't possible, because the
                     pointers change everytime an Assign() function is called, for that reason a
                     clone of the referenced object is kept, and (unfortunately) not a pointer
    }
    TWSVGReference = class(TWSVGElement)
        private
            m_pElement: TWSVGElement; // it's a clone and not a reference, unfortunately, see comments above

        protected
            procedure SetElement(pElement: TWSVGElement); virtual;

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
             Assign (i.e. copy) content from another item
             @param(pOther Other item to copy from)
            }
            procedure Assign(const pOther: TWSVGItem); override;

            {**
             Clear
            }
            procedure Clear; override;

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

            {**
             Get xml formatted string
             @returns(String)
            }
            function ToXml: UnicodeString; override;

        public
            {**
             Get or set the reference
            }
            property Reference: TWSVGElement read m_pElement write SetElement;
    end;

implementation
//---------------------------------------------------------------------------
// TWSVGItem
//---------------------------------------------------------------------------
constructor TWSVGItem.Create(pParent: TWSVGItem; pOptions: PWSVGOptions);
begin
    inherited Create;

    m_pParent  := pParent;
    m_pOptions := pOptions;
end;
//---------------------------------------------------------------------------
destructor TWSVGItem.Destroy;
begin
    inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure TWSVGItem.Assign(const pOther: TWSVGItem);
begin
    // clear existing data before copy new
    Clear;

    // copy data from source
    m_Name := pOther.m_Name;
    m_ID   := pOther.m_ID;
end;
//---------------------------------------------------------------------------
procedure TWSVGItem.Clear;
begin
    m_Name := '';
    m_ID   := '';
end;
//---------------------------------------------------------------------------
// TWSVGProperty
//---------------------------------------------------------------------------
constructor TWSVGProperty.Create(pParent: TWSVGItem; pOptions: PWSVGOptions);
begin
    inherited Create(pParent, pOptions);
end;
//---------------------------------------------------------------------------
destructor TWSVGProperty.Destroy;
begin
    inherited Destroy;
end;
//---------------------------------------------------------------------------
{$ifdef USE_VERYSIMPLEXML}
    function TWSVGProperty.Read(const name: UnicodeString; const pNode: TXMLNode): Boolean;
{$else}
    function TWSVGProperty.Read(const name: UnicodeString; const pNode: IXMLNode): Boolean;
{$endif}
var
    value: UnicodeString;
begin
    // no name?
    if (Length(name) = 0) then
        Exit(False);

    // no element?
    if (not Assigned(pNode)) then
        Exit(False);

    // read value
    value := TWSVGCommon.GetAttribute(pNode, name, C_SVG_Global_Error);

    // found it?
    if (value = C_SVG_Global_Error) then
        Exit(False);

    // set name
    m_Name := name;

    // if the value can be trusted, use it directly, otherwise clean it before
    if (m_pOptions.m_TrustSVGSyntax) then
        // parse value
        Result := Parse(value)
    else
        // clean and parse value
        Result := Parse(TWSVGCommon.PrepareStr(value));
end;
//---------------------------------------------------------------------------
// TWSVGElement
//---------------------------------------------------------------------------
constructor TWSVGElement.Create(pParent: TWSVGItem; pOptions: PWSVGOptions);
begin
    inherited Create(pParent, pOptions);

    m_pProperties := IProperties.Create;
end;
//---------------------------------------------------------------------------
destructor TWSVGElement.Destroy;
begin
    DelAndClear;

    m_pProperties.Free;

    inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure TWSVGElement.DelAndClear;
begin
    // clear all properties. NOTE as a TObjectList is used, the list will take care of freeing all
    // objects it contains, for that an explicit Free() on each item isn't required
    m_pProperties.Clear;
end;
//---------------------------------------------------------------------------
function TWSVGElement.GetProperty(index: Integer): TWSVGProperty;
begin
    if (index >= m_pProperties.Count) then
        Exit(nil);

    Result := m_pProperties[index];
end;
//---------------------------------------------------------------------------
function TWSVGElement.GetPropertyCount: Integer;
begin
    Result := m_pProperties.Count;
end;
//---------------------------------------------------------------------------
procedure TWSVGElement.Assign(const pOther: TWSVGItem);
var
    pSource:             TWSVGElement;
    pProperty, pNewProp: TWSVGProperty;
begin
    inherited Assign(pOther);

    // invalid item?
    if (not(pOther is TWSVGElement)) then
    begin
        Clear;
        Exit;
    end;

    // get source object
    pSource := pOther as TWSVGElement;

    // iterate through properties to copy
    for pProperty in pSource.m_pProperties do
    begin
        pNewProp := nil;

        try
            // copy property from source
            pNewProp := pProperty.CreateInstance(Self);
            pNewProp.Assign(pProperty);
            m_pProperties.Add(pNewProp);
            pNewProp := nil;
        finally
            pNewProp.Free;
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGElement.Clear;
begin
    inherited Clear;

    DelAndClear;
end;
//---------------------------------------------------------------------------
procedure TWSVGElement.Log(margin: Cardinal);
var
    pProperty: TWSVGProperty;
begin
    // iterate through properties to log
    for pProperty in m_pProperties do
        pProperty.Log(margin);
end;
//---------------------------------------------------------------------------
function TWSVGElement.Print(margin: Cardinal): UnicodeString;
var
    pProperty: TWSVGProperty;
begin
    Result := '';

    // iterate through properties to log
    for pProperty in m_pProperties do
        Result := Result + pProperty.Print(margin);
end;
//---------------------------------------------------------------------------
function TWSVGElement.ToXml: UnicodeString;
var
    pProperty: TWSVGProperty;
begin
    Result := '';

    // iterate through properties to log
    for pProperty in m_pProperties do
        Result := Result + pProperty.ToXml;
end;
//---------------------------------------------------------------------------
procedure TWSVGElement.AddProperty(const pProperty: TWSVGProperty);
var
    pClone: TWSVGProperty;
begin
    pClone := nil;

    try
        pClone := pProperty.CreateInstance(Self);
        pClone.Assign(pProperty);
        m_pProperties.Add(pClone);
        pClone := nil;
    finally
        pClone.Free;
    end;
end;
//---------------------------------------------------------------------------
// TWSVGReference
//---------------------------------------------------------------------------
constructor TWSVGReference.Create(pParent: TWSVGItem; pOptions: PWSVGOptions);
begin
    inherited Create(pParent, pOptions);

    m_Name     := 'reference';
    m_pElement := nil;
end;
//---------------------------------------------------------------------------
destructor TWSVGReference.Destroy;
begin
    if (Assigned(m_pElement)) then
        m_pElement.Free;

    inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure TWSVGReference.SetElement(pElement: TWSVGElement);
begin
    if (Assigned(m_pElement)) then
        m_pElement.Free;

    if (not Assigned(pElement)) then
    begin
        m_pElement := nil;
        Exit;
    end;

    m_pElement := pElement.CreateInstance(Self);
    m_pElement.Assign(pElement);
end;
//---------------------------------------------------------------------------
procedure TWSVGReference.Assign(const pOther: TWSVGItem);
var
    pSource: TWSVGReference;
begin
    inherited Assign(pOther);

    // invalid item?
    if (not(pOther is TWSVGReference)) then
    begin
        Clear;
        Exit;
    end;

    // get source object
    pSource := pOther as TWSVGReference;

    // copy the values
    SetElement(pSource.m_pElement);
end;
//---------------------------------------------------------------------------
procedure TWSVGReference.Clear;
begin
    inherited Clear;

    m_pElement := nil;
end;
//---------------------------------------------------------------------------
function TWSVGReference.CreateInstance(pParent: TWSVGItem): TWSVGElement;
begin
    Result := TWSVGReference.Create(pParent, m_pOptions);
end;
//---------------------------------------------------------------------------
{$ifdef USE_VERYSIMPLEXML}
    function TWSVGReference.Read(const pNode: TXMLNode): Boolean;
{$else}
    function TWSVGReference.Read(const pNode: IXMLNode): Boolean;
{$endif}
begin
    // this element cannot be read
    Result := False;
end;
//---------------------------------------------------------------------------
procedure TWSVGReference.Log(margin: Cardinal);
begin
    {$ifdef ENABLE_REFERENCE_LOGS}
        if (not Assigned(m_pElement)) then
            Exit;

        TWSVGElement(m_pElement).Log(margin);
    {$endif}
end;
//---------------------------------------------------------------------------
function TWSVGReference.Print(margin: Cardinal): UnicodeString;
begin
    {$ifdef ENABLE_REFERENCE_LOGS}
        if (not Assigned(m_pElement)) then
            Exit('');

        Result := TWSVGElement(m_pElement).Print(margin);
    {$else}
        Result := '';
    {$endif}
end;
//---------------------------------------------------------------------------
function TWSVGReference.ToXml: UnicodeString;
begin
    {$ifdef ENABLE_REFERENCE_LOGS}
        if (not Assigned(m_pElement)) then
            Exit('');

        Result := TWSVGElement(m_pElement).ToXml;
    {$else}
        Result := '';
    {$endif}
end;
//---------------------------------------------------------------------------

end.
