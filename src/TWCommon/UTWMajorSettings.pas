unit UTWMajorSettings;

interface

uses System.SysUtils,
     UTWVersion;

var
    {**
     Global library version
    }
    TWLibraryVersion: TWVersion = nil;

implementation

//---------------------------------------------------------------------------
initialization
begin
    TWLibraryVersion := TWVersion.Create(1, 0, 0, 2);
end;
//---------------------------------------------------------------------------
finalization
begin
    FreeAndNil(TWLibraryVersion);
end;
//---------------------------------------------------------------------------

end.

