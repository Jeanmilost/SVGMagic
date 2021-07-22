{**
 @abstract(@name provides the list of all known tags that can be parsed from a SVG data.)
 @author(JMR)
 @created(2016-2021, by Ursa Minor)
}
unit UTWSVGTags;

interface

const
    //---------------------------------------------------------------------------
    // Global defines
    //---------------------------------------------------------------------------
    C_SVG_Tag_Name:                                    UnicodeString = 'svg';
    C_SVG_Tag_Defs:                                    UnicodeString = 'defs';
    C_SVG_Tag_Switch:                                  UnicodeString = 'switch';
    C_SVG_Tag_Group:                                   UnicodeString = 'g';
    C_SVG_Tag_Action:                                  UnicodeString = 'a';
    C_SVG_Tag_Path:                                    UnicodeString = 'path';
    C_SVG_Tag_Rect:                                    UnicodeString = 'rect';
    C_SVG_Tag_Circle:                                  UnicodeString = 'circle';
    C_SVG_Tag_Ellipse:                                 UnicodeString = 'ellipse';
    C_SVG_Tag_Line:                                    UnicodeString = 'line';
    C_SVG_Tag_Polygon:                                 UnicodeString = 'polygon';
    C_SVG_Tag_Polyline:                                UnicodeString = 'polyline';
    C_SVG_Tag_Text:                                    UnicodeString = 'text';
    C_SVG_Tag_Image:                                   UnicodeString = 'image';
    C_SVG_Tag_SVG:                                     UnicodeString = 'svg';
    C_SVG_Tag_Use:                                     UnicodeString = 'use';
    C_SVG_Tag_Symbol:                                  UnicodeString = 'symbol';
    C_SVG_Tag_Set:                                     UnicodeString = 'set';
    C_SVG_Tag_Animate:                                 UnicodeString = 'animate';
    C_SVG_Tag_Animate_Color:                           UnicodeString = 'animateColor';
    C_SVG_Tag_Animate_Transform:                       UnicodeString = 'animateTransform';
    C_SVG_Tag_Animate_Motion:                          UnicodeString = 'animateMotion';
    C_SVG_Tag_Linear_Gradient:                         UnicodeString = 'linearGradient';
    C_SVG_Tag_Radial_Gradient:                         UnicodeString = 'radialGradient';
    C_SVG_Tag_Filter:                                  UnicodeString = 'filter';
    C_SVG_Tag_ClipPath:                                UnicodeString = 'clipPath';
    C_SVG_Prop_ID:                                     UnicodeString = 'id';
    C_SVG_Prop_Version:                                UnicodeString = 'version';
    C_SVG_Prop_ViewBox:                                UnicodeString = 'viewBox';
    C_SVG_Prop_Enable_Background:                      UnicodeString = 'enable-background';
    C_SVG_Prop_Page_Color:                             UnicodeString = 'pagecolor';
    C_SVG_Prop_Border_Color:                           UnicodeString = 'bordercolor';
    C_SVG_Prop_Border_Opacity:                         UnicodeString = 'borderopacity';
    C_SVG_Prop_Style:                                  UnicodeString = 'style';
    C_SVG_Prop_Fill:                                   UnicodeString = 'fill';
    C_SVG_Prop_Stroke:                                 UnicodeString = 'stroke';
    C_SVG_Prop_Stroke_Width:                           UnicodeString = 'stroke-width';
    C_SVG_Prop_Stroke_DashArray:                       UnicodeString = 'stroke-dasharray';
    C_SVG_Prop_Stroke_DashOffset:                      UnicodeString = 'stroke-dashoffset';
    C_SVG_Prop_Stroke_LineCap:                         UnicodeString = 'stroke-linecap';
    C_SVG_Prop_Stroke_LineJoin:                        UnicodeString = 'stroke-linejoin';
    C_SVG_Prop_Stroke_MiterLimit:                      UnicodeString = 'stroke-miterlimit';
    C_SVG_Prop_Opacity:                                UnicodeString = 'opacity';
    C_SVG_Prop_Fill_Rule:                              UnicodeString = 'fill-rule';
    C_SVG_Prop_Fill_Opacity:                           UnicodeString = 'fill-opacity';
    C_SVG_Prop_Stroke_Opacity:                         UnicodeString = 'stroke-opacity';
    C_SVG_Prop_Points:                                 UnicodeString = 'points';
    C_SVG_Prop_Path:                                   UnicodeString = 'd';
    C_SVG_Prop_X:                                      UnicodeString = 'x';
    C_SVG_Prop_Y:                                      UnicodeString = 'y';
    C_SVG_Prop_X1:                                     UnicodeString = 'x1';
    C_SVG_Prop_Y1:                                     UnicodeString = 'y1';
    C_SVG_Prop_X2:                                     UnicodeString = 'x2';
    C_SVG_Prop_Y2:                                     UnicodeString = 'y2';
    C_SVG_Prop_CX:                                     UnicodeString = 'cx';
    C_SVG_Prop_CY:                                     UnicodeString = 'cy';
    C_SVG_Prop_Width:                                  UnicodeString = 'width';
    C_SVG_Prop_Height:                                 UnicodeString = 'height';
    C_SVG_Prop_R:                                      UnicodeString = 'r';
    C_SVG_Prop_RX:                                     UnicodeString = 'rx';
    C_SVG_Prop_RY:                                     UnicodeString = 'ry';
    C_SVG_Prop_FX:                                     UnicodeString = 'fx';
    C_SVG_Prop_FY:                                     UnicodeString = 'fy';
    C_SVG_Prop_PreserveAspectRatio:                    UnicodeString = 'preserveAspectRatio';
    C_SVG_Prop_Font_Family:                            UnicodeString = 'font-family';
    C_SVG_Prop_Font_Size:                              UnicodeString = 'font-size';
    C_SVG_Prop_Font_Weight:                            UnicodeString = 'font-weight';
    C_SVG_Prop_Font_Style:                             UnicodeString = 'font-style';
    C_SVG_Prop_Text_Anchor:                            UnicodeString = 'text-anchor';
    C_SVG_Prop_Text_Decoration:                        UnicodeString = 'text-decoration';
    C_SVG_Prop_Transform:                              UnicodeString = 'transform';
    C_SVG_Prop_XLink_HRef:                             UnicodeString = 'xlink:href';
    C_SVG_Prop_HRef:                                   UnicodeString = 'href';
    C_SVG_Prop_Display:                                UnicodeString = 'display';
    C_SVG_Prop_Visibility:                             UnicodeString = 'visibility';
    C_SVG_Prop_Filter:                                 UnicodeString = 'filter';
    C_SVG_Prop_ClipPath:                               UnicodeString = 'clip-path';
    C_SVG_Value_New:                                   UnicodeString = 'new';
    C_SVG_Value_Accumulate:                            UnicodeString = 'accumulate';
    C_SVG_Value_CM:                                    UnicodeString = 'cm';
    C_SVG_Value_FT:                                    UnicodeString = 'ft';
    C_SVG_Value_IN:                                    UnicodeString = 'in';
    C_SVG_Value_M:                                     UnicodeString = 'm';
    C_SVG_Value_MM:                                    UnicodeString = 'mm';
    C_SVG_Value_PC:                                    UnicodeString = 'pc';
    C_SVG_Value_PT:                                    UnicodeString = 'pt';
    C_SVG_Value_PX:                                    UnicodeString = 'px';
    C_SVG_Value_Deg:                                   UnicodeString = 'deg';
    C_SVG_Value_Grad:                                  UnicodeString = 'grad';
    C_SVG_Value_Rad:                                   UnicodeString = 'rad';
    C_SVG_Value_Turn:                                  UnicodeString = 'turn';
    C_SVG_Value_Percent:                               UnicodeString = '%';
    C_SVG_Value_None:                                  UnicodeString = 'none';
    C_SVG_Value_Inherit:                               UnicodeString = 'inherit';
    C_SVG_Value_Butt:                                  UnicodeString = 'butt';
    C_SVG_Value_Round:                                 UnicodeString = 'round';
    C_SVG_Value_Square:                                UnicodeString = 'square';
    C_SVG_Value_Miter:                                 UnicodeString = 'miter';
    C_SVG_Value_Bevel:                                 UnicodeString = 'bevel';
    C_SVG_Value_NonZero:                               UnicodeString = 'nonzero';
    C_SVG_Value_EvenOdd:                               UnicodeString = 'evenodd';
    C_SVG_Value_Inline:                                UnicodeString = 'inline';
    C_SVG_Value_Block:                                 UnicodeString = 'block';
    C_SVG_Value_List_Item:                             UnicodeString = 'list-item';
    C_SVG_Value_Run_In:                                UnicodeString = 'run-in';
    C_SVG_Value_Compact:                               UnicodeString = 'compact';
    C_SVG_Value_Marker:                                UnicodeString = 'marker';
    C_SVG_Value_Table:                                 UnicodeString = 'table';
    C_SVG_Value_Inline_Table:                          UnicodeString = 'inline-table';
    C_SVG_Value_Table_Row_Group:                       UnicodeString = 'table-row-group';
    C_SVG_Value_Table_Header_Group:                    UnicodeString = 'table-header-group';
    C_SVG_Value_Table_Footer_Group:                    UnicodeString = 'table-footer-group';
    C_SVG_Value_Table_Row:                             UnicodeString = 'table-row';
    C_SVG_Value_Table_Column_Group:                    UnicodeString = 'table-column-group';
    C_SVG_Value_Table_Column:                          UnicodeString = 'table-column';
    C_SVG_Value_Table_Cell:                            UnicodeString = 'table-cell';
    C_SVG_Value_Table_Caption:                         UnicodeString = 'table-caption';
    C_SVG_Value_Start:                                 UnicodeString = 'start';
    C_SVG_Value_Middle:                                UnicodeString = 'middle';
    C_SVG_Value_End:                                   UnicodeString = 'end';
    C_SVG_Value_Visible:                               UnicodeString = 'visible';
    C_SVG_Value_Hidden:                                UnicodeString = 'hidden';
    C_SVG_Value_Collapse:                              UnicodeString = 'collapse';
    C_SVG_Value_XMinYMin:                              UnicodeString = 'xMinYMin';
    C_SVG_Value_XMidYMin:                              UnicodeString = 'xMidYMin';
    C_SVG_Value_XMaxYMin:                              UnicodeString = 'xMaxYMin';
    C_SVG_Value_XMinYMid:                              UnicodeString = 'xMinYMid';
    C_SVG_Value_XMidYMid:                              UnicodeString = 'xMidYMid';
    C_SVG_Value_XMaxYMid:                              UnicodeString = 'xMaxYMid';
    C_SVG_Value_XMinYMax:                              UnicodeString = 'xMinYMax';
    C_SVG_Value_XMidYMax:                              UnicodeString = 'xMidYMax';
    C_SVG_Value_XMaxYMax:                              UnicodeString = 'xMaxYMax';
    C_SVG_Value_Meet:                                  UnicodeString = 'meet';
    C_SVG_Value_Slice:                                 UnicodeString = 'slice';
    C_SVG_Value_Text_Weight_Normal:                    UnicodeString = 'normal';
    C_SVG_Value_Text_Weight_Bold:                      UnicodeString = 'bold';
    C_SVG_Value_Text_Weight_Bolder:                    UnicodeString = 'bolder';
    C_SVG_Value_Text_Weight_Lighter:                   UnicodeString = 'lighter';
    C_SVG_Value_Text_Font_Style_Normal:                UnicodeString = 'normal';
    C_SVG_Value_Text_Font_Style_Italic:                UnicodeString = 'italic';
    C_SVG_Value_Text_Font_Style_Oblique:               UnicodeString = 'oblique';
    C_SVG_Value_Text_Decoration_Normal:                UnicodeString = 'normal';
    C_SVG_Value_Text_Decoration_Underline:             UnicodeString = 'underline';
    C_SVG_Value_Text_Decoration_Line_Through:          UnicodeString = 'line-through';
    C_SVG_Link_URL:                                    UnicodeString = 'url';
    C_SVG_Path_MoveTo_Absolute                                       = 'M';
    C_SVG_Path_MoveTo_Relative                                       = 'm';
    C_SVG_Path_LineTo_Absolute                                       = 'L';
    C_SVG_Path_LineTo_Relative                                       = 'l';
    C_SVG_Path_HLineTo_Absolute                                      = 'H';
    C_SVG_Path_HLineTo_Relative                                      = 'h';
    C_SVG_Path_VLineTo_Absolute                                      = 'V';
    C_SVG_Path_VLineTo_Relative                                      = 'v';
    C_SVG_Path_CurveTo_Absolute                                      = 'C';
    C_SVG_Path_CurveTo_Relative                                      = 'c';
    C_SVG_Path_SmoothCurveTo_Absolute                                = 'S';
    C_SVG_Path_SmoothCurveTo_Relative                                = 's';
    C_SVG_Path_QuadraticBezier_CurveTo_Absolute                      = 'Q';
    C_SVG_Path_QuadraticBezier_CurveTo_Relative                      = 'q';
    C_SVG_Path_SmoothQuadraticBezier_CurveTo_Absolute                = 'T';
    C_SVG_Path_SmoothQuadraticBezier_CurveTo_Relative                = 't';
    C_SVG_Path_Elliptical_Arc_Absolute                               = 'A';
    C_SVG_Path_Elliptical_Arc_Relative                               = 'a';
    C_SVG_Path_Close_Upper                                           = 'Z';
    C_SVG_Path_Close                                                 = 'z';
    C_SVG_Matrix_Translate:                            UnicodeString = 'translate';
    C_SVG_Matrix_Scale:                                UnicodeString = 'scale';
    C_SVG_Matrix_Rotate:                               UnicodeString = 'rotate';
    C_SVG_Matrix_SkewX:                                UnicodeString = 'skewX';
    C_SVG_Matrix_SkewY:                                UnicodeString = 'skewY';
    C_SVG_Matrix_Matrix:                               UnicodeString = 'matrix';
    C_SVG_Animation_Attribute_Name:                    UnicodeString = 'attributeName';
    C_SVG_Animation_Attribute_Type:                    UnicodeString = 'attributeType';
    C_SVG_Animation_Attribute_Type_CSS:                UnicodeString = 'CSS';
    C_SVG_Animation_Attribute_Type_XML:                UnicodeString = 'XML';
    C_SVG_Animation_Attribute_Type_Auto:               UnicodeString = 'auto';
    C_SVG_Animation_Calc_Mode:                         UnicodeString = 'calcMode';
    C_SVG_Animation_Calc_Mode_Discrete:                UnicodeString = 'discrete';
    C_SVG_Animation_Calc_Mode_Linear:                  UnicodeString = 'linear';
    C_SVG_Animation_Calc_Mode_Paced:                   UnicodeString = 'paced';
    C_SVG_Animation_Calc_Mode_Spline:                  UnicodeString = 'spline';
    C_SVG_Animation_Fill_Mode:                         UnicodeString = 'fill';
    C_SVG_Animation_Fill_Mode_Freeze:                  UnicodeString = 'freeze';
    C_SVG_Animation_Fill_Mode_Remove:                  UnicodeString = 'remove';
    C_SVG_Animation_Values:                            UnicodeString = 'values';
    C_SVG_Animation_From:                              UnicodeString = 'from';
    C_SVG_Animation_To:                                UnicodeString = 'to';
    C_SVG_Animation_By:                                UnicodeString = 'by';
    C_SVG_Animation_Begin:                             UnicodeString = 'begin';
    C_SVG_Animation_End:                               UnicodeString = 'end';
    C_SVG_Animation_Duration:                          UnicodeString = 'dur';
    C_SVG_Animation_Min:                               UnicodeString = 'min';
    C_SVG_Animation_Max:                               UnicodeString = 'max';
    C_SVG_Animation_Repeat_Count:                      UnicodeString = 'repeatCount';
    C_SVG_Animation_Repeat_Duration:                   UnicodeString = 'repeatDur';
    C_SVG_Animation_Restart:                           UnicodeString = 'restart';
    C_SVG_Animation_Restart_Always:                    UnicodeString = 'always';
    C_SVG_Animation_Restart_When_Not_Active:           UnicodeString = 'whenNotActive';
    C_SVG_Animation_Restart_Never:                     UnicodeString = 'never';
    C_SVG_Animation_Transform:                         UnicodeString = 'transform';
    C_SVG_Animation_Transform_Type:                    UnicodeString = 'type';
    C_SVG_Animation_Transform_Type_Translate:          UnicodeString = 'translate';
    C_SVG_Animation_Transform_Type_Scale:              UnicodeString = 'scale';
    C_SVG_Animation_Transform_Type_Rotate:             UnicodeString = 'rotate';
    C_SVG_Animation_Transform_Type_SkewX:              UnicodeString = 'skewX';
    C_SVG_Animation_Transform_Type_SkewY:              UnicodeString = 'skewY';
    C_SVG_Animation_Key_Splines:                       UnicodeString = 'keySplines';
    C_SVG_Animation_Key_Times:                         UnicodeString = 'keyTimes';
    C_SVG_Animation_Indefinite:                        UnicodeString = 'indefinite';
    C_SVG_Animation_Additive:                          UnicodeString = 'additive';
    C_SVG_Animation_Additive_Replace:                  UnicodeString = 'replace';
    C_SVG_Animation_Additive_Sum:                      UnicodeString = 'sum';
    C_SVG_Gradient_Stop_Offset:                        UnicodeString = 'offset';
    C_SVG_Gradient_Stop_Color:                         UnicodeString = 'stop-color';
    C_SVG_Gradient_Stop_Opacity:                       UnicodeString = 'stop-opacity';
    C_SVG_Gradient_Units:                              UnicodeString = 'gradientUnits';
    C_SVG_Gradient_Transform:                          UnicodeString = 'gradientTransform';
    C_SVG_Gradient_Spread_Method:                      UnicodeString = 'spreadMethod';
    C_SVG_Gradient_Spread_Method_Pad:                  UnicodeString = 'pad';
    C_SVG_Gradient_Spread_Method_Reflect:              UnicodeString = 'reflect';
    C_SVG_Gradient_Spread_Method_Repeat:               UnicodeString = 'repeat';
    C_SVG_Filter_Res:                                  UnicodeString = 'filterRes';
    C_SVG_Filter_Units:                                UnicodeString = 'filterUnits';
    C_SVG_Primitive_Units:                             UnicodeString = 'primitiveUnits';
    C_SVG_Filter_Gaussian_Blur:                        UnicodeString = 'feGaussianBlur';
    C_SVG_Filter_STD_Deviation:                        UnicodeString = 'stdDeviation';
    C_SVG_Unit_Object_Bounding_Box:                    UnicodeString = 'objectBoundingBox';
    C_SVG_Unit_User_Space_On_Use:                      UnicodeString = 'userSpaceOnUse';
    C_SVG_Blank_Text_Attribute:                        UnicodeString = '#text';
    C_SVG_Global_Data:                                 UnicodeString = 'data';
    C_SVG_Global_Error:                                UnicodeString = '#ERROR';
    //---------------------------------------------------------------------------

implementation

end.
