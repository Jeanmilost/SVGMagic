{**
 @abstract(@name provides a standard color dictionary that allows to get a known color by naming it,
           e.g. Get('yellow') will return a TWColor set to yellow.)
 @author(JMR)
 @created(2016-2018 by Ursa Minor)
}
unit UTWStandardColor;

interface

uses System.SysUtils,
     System.Generics.Collections, Vcl.Forms,
     UTWColor;

type
    {**
     Standard color interface
    }
    IWStandardColor = interface['{07BB7AC3-52FC-4EDE-98FC-0C0785D023C7}']
        {**
         Check if color exists in dictionary
         @param(name Color name)
         @returns(@true if exists, otherwise @false)
        }
        function Exists(const name: UnicodeString): Boolean;

        {**
         Get color
         @param(name Color name)
         @param(color @bold([out]) Color if found, empty color (i.e. set to RGBA = 0) otherwise)
         @returns(@true if exists, otherwise @false)
        }
        function Get(const name: UnicodeString; out color: TWColor): Boolean;
    end;

    {**
     Standard predefined colors dictionary
    }
    TWStandardColor = class sealed (TInterfacedObject, IWStandardColor)
        private type
            IColorDictionary = TDictionary<UnicodeString, TWColor>;

        private
            class var m_pInstance:  TWStandardColor;
                      m_pColorDict: IColorDictionary;

        protected
            {**
             Create color dictionary
            }
            procedure CreateColorDictionary;

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
             Gets standard colors instance, creates one if still not created
             @returns(Standard colors instance)
            }
            class function GetInstance: IWStandardColor; static;

            {**
             Check if color exists in dictionary
             @param(name Color name)
             @returns(@true if exists, otherwise @false)
            }
            function Exists(const name: UnicodeString): Boolean; virtual;

            {**
             Get color
             @param(name Color name)
             @param(color @bold([out]) Color if found, empty color (e.g. set to RGBA = 0) otherwise)
             @returns(@true if exists, otherwise @false)
            }
            function Get(const name: UnicodeString; out color: TWColor): Boolean; virtual;
    end;

implementation
//---------------------------------------------------------------------------
constructor TWStandardColor.Create;
begin
    // singleton was already initialized?
    if (Assigned(m_pInstance)) then
        raise Exception.Create('Cannot create many instances of a singleton class');

    inherited Create;

    m_pColorDict := IColorDictionary.Create;

    CreateColorDictionary;
end;
//---------------------------------------------------------------------------
destructor TWStandardColor.Destroy;
begin
    m_pColorDict.Free;

    inherited Destroy;

    m_pInstance := nil;
end;
//---------------------------------------------------------------------------
procedure TWStandardColor.CreateColorDictionary;
begin
    // populate color dictionary with standard colors
    m_pColorDict.Add('none',    TWColor.Create(0,   0,   0, 0));
    m_pColorDict.Add('red',     TWColor.Create(255, 0,   0));
    m_pColorDict.Add('green',   TWColor.Create(0,   128, 0));
    m_pColorDict.Add('blue',    TWColor.Create(0,   0,   255));
    m_pColorDict.Add('black',   TWColor.Create(0,   0,   0));
    m_pColorDict.Add('white',   TWColor.Create(255, 255, 255));
    m_pColorDict.Add('gray',    TWColor.Create(128, 128, 128));
    m_pColorDict.Add('silver',  TWColor.Create(192, 192, 192));
    m_pColorDict.Add('maroon',  TWColor.Create(128, 0,   0));
    m_pColorDict.Add('lime',    TWColor.Create(0,   255, 0));
    m_pColorDict.Add('navy',    TWColor.Create(0,   0,   128));
    m_pColorDict.Add('yellow',  TWColor.Create(255, 255, 0));
    m_pColorDict.Add('olive',   TWColor.Create(128, 128, 0));
    m_pColorDict.Add('aqua',    TWColor.Create(0,   255, 255));
    m_pColorDict.Add('teal',    TWColor.Create(0,   128, 128));
    m_pColorDict.Add('fuchsia', TWColor.Create(255, 0,   255));
    m_pColorDict.Add('pink',    TWColor.Create(255, 0,   255));
    m_pColorDict.Add('purple',  TWColor.Create(128, 0,   128));
    m_pColorDict.Add('orange',  TWColor.Create(255, 165, 0));
end;
//--------------------------------------------------------------------------------------------------
class function TWStandardColor.GetInstance: IWStandardColor;
begin
    // is singleton instance already initialized?
    if (Assigned(m_pInstance)) then
        // get it
        Exit(m_pInstance);

    // create new singleton instance
    m_pInstance := TWStandardColor.Create;
    Result      := m_pInstance;
end;
//---------------------------------------------------------------------------
function TWStandardColor.Exists(const name: UnicodeString): Boolean;
begin
    // check if color exists in dictionary
    Result := m_pColorDict.ContainsKey(name);
end;
//---------------------------------------------------------------------------
function TWStandardColor.Get(const name: UnicodeString; out color: TWColor): Boolean;
begin
    // search for color
    if (not m_pColorDict.TryGetValue(name, color)) then
    begin
        color := TWColor.GetDefault;
        Exit(False);
    end;

    Result := True;
end;
//---------------------------------------------------------------------------

end.
