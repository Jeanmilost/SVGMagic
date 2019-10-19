unit UTWSVG_Register;

interface

uses DesignIntf,
     System.Classes,
     System.TypInfo,
     UTWSVGGraphic,
     UTWSVGImage,
     UTWSVGImageButton,
     UTWSVGImageList,
     UTWSVGCheckBoxStyle,
     UTWSVGRadioButtonStyle,
     UTWSVG_Editors;

{**
 Main register procedure
}
procedure Register;

implementation
//---------------------------------------------------------------------------
// Main register procedure
//---------------------------------------------------------------------------
procedure Register;
begin
    // register all components to show in the designer toolbar
    RegisterComponents('TWSVGControls', [TWSVGImage, TWSVGImageButton, TWSVGImageList,
            TWSVGCheckBoxStyle, TWSVGRadioButtonStyle]);

    // register SVG image list component editor
    RegisterComponentEditor(TWSVGImageList, TWSVGImageListComponentEditor);

    // hide properties that should be omitted in TWSVGImageList
    UnlistPublishedProperty(TWSVGImageList, 'ColorDepth');
end;
//---------------------------------------------------------------------------

end.
