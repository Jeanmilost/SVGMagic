{**
 @abstract(@name provides an overridden image that acts as a button and supports SVG graphics.)
 @author(JMR)
 @created(2016-2018 by Ursa Minor)
}
unit UTWSVGImageButton;

interface

uses System.Classes,
     System.SysUtils,
     Vcl.Graphics,
     Vcl.Controls,
     Winapi.Messages,
     Winapi.Windows,
     Winapi.UxTheme,
     UTWSVGImage,
     UTWSVGFrameCalculator;

type
    {**
     Image that acts as a button and supports animated SVG graphics
    }
    TWSVGImageButton = class(TWSVGImage)
        private
            m_pCanvas:             TCanvas;
            m_pHoveredPicture:     TPicture;
            m_pClickedPicture:     TPicture;
            m_pDisabledPicture:    TPicture;
            m_pHoveredCalculator:  TWSVGFrameCalculator;
            m_pClickedCalculator:  TWSVGFrameCalculator;
            m_pDisabledCalculator: TWSVGFrameCalculator;
            m_pHoveredAnimation:   TWSVGImage.IAnimationProps;
            m_pClickedAnimation:   TWSVGImage.IAnimationProps;
            m_pDisabledAnimation:  TWSVGImage.IAnimationProps;
            m_Hovered:             Boolean;
            m_Clicked:             Boolean;

            {**
             Windows paint message override
             @param(message @bold([in, out]) Windows message, may contains result on function ends)
            }
            procedure WMPaint(var message: TWMPaint); message WM_PAINT;

        protected
            {**
             Enable or disable the animation
             @param(pSender Animation properties in which animate value changed)
             @param(value If @true the animation will be enabled, disabled otherwise)
            }
            procedure SetAnimate(pSender: TWSVGImage.IAnimationProps; value: Boolean); override;

            {**
             Set hovered picture
             @param(pPicture Picture to set)
            }
            procedure SetHoveredPicture(pPicture: TPicture); virtual;

            {**
             Set clicked picture
             @param(pPicture Picture to set)
            }
            procedure SetClickedPicture(pPicture: TPicture); virtual;

            {**
             Set disabled picture
             @param(pPicture Picture to set)
            }
            procedure SetDisabledPicture(pPicture: TPicture); virtual;

            {**
             Called when mouse is down
             @param(button Clicked mouse button)
             @param(shift Special shift keys state)
             @param(x Mouse x position on the client rect, in pixels)
             @param(y Mouse y position on the client rect, in pixels)
            }
            procedure MouseDown(button: TMouseButton; shift: TShiftState; x, y: Integer); override;

            {**
             Called when mouse is up
             @param(button Clicked mouse button)
             @param(shift Special shift keys state)
             @param(x Mouse x position on the client rect, in pixels)
             @param(y Mouse y position on the client rect, in pixels)
            }
            procedure MouseUp(button: TMouseButton; shift: TShiftState; x, y: Integer); override;

            {**
             Windows procedure
             @param(message @bold([in, out]) Windows message, may contains result on function ends)
            }
            procedure WndProc(var message: TMessage); override;

            {**
             Check if a picture is empty
             @param(pPicture Picture to check)
             @returns(@true if picture is empty, otherwise @false)
            }
            function IsEmpty(pPicture: TPicture): Boolean; virtual;

            {**
             Calculate the destination rect in which the picture should be drawn
             @param(pPicture Picture to draw)
             @returns(The destination rect)
            }
            function CalculateDestRect(pPicture: TPicture): TRect; virtual;

            {**
             Paint the image
             @param(pPicture Picture to paint)
             @param(pCanvas Canvas on which the picture will be painted)
            }
            procedure Paint(pPicture: TPicture; pCanvas: TCanvas); reintroduce; virtual;

            {**
             Called when the frame count should be get from properties
             @param(pSender Sender for which the frame count should be get)
             @returns(The frame count)
            }
            function DoGetFrameCount(pSender: TWSVGImage.IAnimationProps): Cardinal; override;

            {**
             Called when the frame count should be set to properties
             @param(pSender Sender for which the frame count should be set)
             @param(frameCount Frame count)
            }
            procedure DoSetFrameCount(pSender: TWSVGImage.IAnimationProps; frameCount: Cardinal); override;

            {**
             Called when next animation frame should be processed
            }
            procedure OnProcessAnimation; override;

            {**
             Called when the hovered picture changed
             @param(pSender Event sender)
            }
            procedure OnHoveredPictureChange(pSender: TObject); virtual;

            {**
             Called when the clicked picture changed
             @param(pSender Event sender)
            }
            procedure OnClickedPictureChange(pSender: TObject); virtual;

            {**
             Called when the disabled picture changed
             @param(pSender Event sender)
            }
            procedure OnDisabledPictureChange(pSender: TObject); virtual;

        public
            {**
             Constructor
             @param(pOwner Component owner)
            }
            constructor Create(pOwner: TComponent); override;

            {**
             Destructor
            }
            destructor Destroy; override;

            {**
             Get the hovered state frame count
             @returns(The frame count)
             @br @bold Be careful, this is not identical to the FPS. The frame count is used to
                       determine how many frames, in an ideal situation, should be rendered by
                       seconds, and thus allows to calculate the time interval between each frames.
                       Instead, the FPS represents the number of frames per seconds a system can
                       effectively process
            }
            function GetHoveredFrameCount: Double; virtual;

            {**
             Set the hovered state frame count
             @param(frameCount Frame count)
             @br @bold Be careful, this is not identical to the FPS. The frame count is used to
                       determine how many frames, in an ideal situation, should be rendered by
                       seconds, and thus allows to calculate the time interval between each frames.
                       Instead, the FPS represents the number of frames per seconds a system can
                       effectively process
            }
            procedure SetHoveredFrameCount(frameCount: Double); virtual;

            {**
             Get the clicked state frame count
             @returns(The frame count)
             @br @bold Be careful, this is not identical to the FPS. The frame count is used to
                       determine how many frames, in an ideal situation, should be rendered by
                       seconds, and thus allows to calculate the time interval between each frames.
                       Instead, the FPS represents the number of frames per seconds a system can
                       effectively process
            }
            function GetClickedFrameCount: Double; virtual;

            {**
             Set the clicked state frame count
             @param(frameCount Frame count)
             @br @bold Be careful, this is not identical to the FPS. The frame count is used to
                       determine how many frames, in an ideal situation, should be rendered by
                       seconds, and thus allows to calculate the time interval between each frames.
                       Instead, the FPS represents the number of frames per seconds a system can
                       effectively process
            }
            procedure SetClickedFrameCount(frameCount: Double); virtual;

            {**
             Get the disabled state frame count
             @returns(The frame count)
             @br @bold Be careful, this is not identical to the FPS. The frame count is used to
                       determine how many frames, in an ideal situation, should be rendered by
                       seconds, and thus allows to calculate the time interval between each frames.
                       Instead, the FPS represents the number of frames per seconds a system can
                       effectively process
            }
            function GetDisabledFrameCount: Double; virtual;

            {**
             Set the disabled state frame count
             @param(frameCount Frame count)
             @br @bold Be careful, this is not identical to the FPS. The frame count is used to
                       determine how many frames, in an ideal situation, should be rendered by
                       seconds, and thus allows to calculate the time interval between each frames.
                       Instead, the FPS represents the number of frames per seconds a system can
                       effectively process
            }
            procedure SetDisabledFrameCount(frameCount: Double); virtual;

        published
            {**
             Get or set the hovered state animation properties
            }
            property HoveredAnimation: TWSVGImage.IAnimationProps read m_pHoveredAnimation write m_pHoveredAnimation;

            {**
             Get or set the hovered picture
            }
            property HoveredPicture: TPicture read m_pHoveredPicture write SetHoveredPicture;

            {**
             Get or set the clicked state animation properties
            }
            property ClickedAnimation: TWSVGImage.IAnimationProps read m_pClickedAnimation write m_pClickedAnimation;

            {**
             Get or set the clicked picture
            }
            property ClickedPicture: TPicture read m_pClickedPicture write SetClickedPicture;

            {**
             Get or set the disabled state animation properties
            }
            property DisabledAnimation: TWSVGImage.IAnimationProps read m_pDisabledAnimation write m_pDisabledAnimation;

            {**
             Get or set the disabled picture
            }
            property DisabledPicture: TPicture read m_pDisabledPicture write SetDisabledPicture;
    end;

implementation
//---------------------------------------------------------------------------
constructor TWSVGImageButton.Create(pOwner: TComponent);
begin
    inherited Create(pOwner);

    m_pCanvas             := TCanvas.Create;
    m_pHoveredPicture     := TPicture.Create;
    m_pClickedPicture     := TPicture.Create;
    m_pDisabledPicture    := TPicture.Create;
    m_pHoveredCalculator  := TWSVGFrameCalculator.Create;
    m_pClickedCalculator  := TWSVGFrameCalculator.Create;
    m_pDisabledCalculator := TWSVGFrameCalculator.Create;
    m_pHoveredAnimation   := TWSVGImage.IAnimationProps.Create(Self);
    m_pClickedAnimation   := TWSVGImage.IAnimationProps.Create(Self);
    m_pDisabledAnimation  := TWSVGImage.IAnimationProps.Create(Self);
    m_Clicked             := False;

    // configure pictures
    m_pHoveredPicture.OnChange  := OnHoveredPictureChange;
    m_pClickedPicture.OnChange  := OnClickedPictureChange;
    m_pDisabledPicture.OnChange := OnDisabledPictureChange;
end;
//---------------------------------------------------------------------------
destructor TWSVGImageButton.Destroy;
begin
    FreeAndNil(m_pCanvas);
    FreeAndNil(m_pHoveredPicture);
    FreeAndNil(m_pClickedPicture);
    FreeAndNil(m_pDisabledPicture);
    FreeAndNil(m_pHoveredCalculator);
    FreeAndNil(m_pClickedCalculator);
    FreeAndNil(m_pDisabledCalculator);
    FreeAndNil(m_pHoveredAnimation);
    FreeAndNil(m_pClickedAnimation);
    FreeAndNil(m_pDisabledAnimation);

    inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.WMPaint(var message: TWMPaint);
begin
    if (message.DC <> 0) and not (csDestroying in ComponentState) then
    begin
        m_pCanvas.Lock;

        try
            m_pCanvas.Handle := message.DC;

            try
                // select the button state to paint
                if (csDesigning in ComponentState) then
                    Paint(Picture, m_pCanvas)
                else
                if (not Enabled and not IsEmpty(m_pDisabledPicture)) then
                    Paint(m_pDisabledPicture, m_pCanvas)
                else
                if (Enabled and m_Clicked and not IsEmpty(m_pClickedPicture)) then
                    Paint(m_pClickedPicture, m_pCanvas)
                else
                if (Enabled and m_Hovered and not IsEmpty(m_pHoveredPicture)) then
                    Paint(m_pHoveredPicture, m_pCanvas)
                else
                    Paint(Picture, m_pCanvas);
            finally
                m_pCanvas.Handle := 0;
            end;
        finally
            m_pCanvas.Unlock;
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.SetAnimate(pSender: TWSVGImage.IAnimationProps; value: Boolean);
begin
    if (pSender = m_pHoveredAnimation) then
    begin
        RunAnimation(Picture, m_pHoveredCalculator);
        Exit;
    end
    else
    if (pSender = m_pClickedAnimation) then
    begin
        RunAnimation(Picture, m_pClickedCalculator);
        Exit;
    end
    else
    if (pSender = m_pDisabledAnimation) then
    begin
        RunAnimation(Picture, m_pDisabledCalculator);
        Exit;
    end;

    inherited SetAnimate(pSender, value);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.SetHoveredPicture(pPicture: TPicture);
begin
    m_pHoveredPicture.Assign(pPicture);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.SetClickedPicture(pPicture: TPicture);
begin
    m_pClickedPicture.Assign(pPicture);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.SetDisabledPicture(pPicture: TPicture);
begin
    m_pDisabledPicture.Assign(pPicture);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.MouseDown(button: TMouseButton; shift: TShiftState; x, y: Integer);
begin
    inherited MouseDown(button, shift, x, y);

    m_Clicked := True;

    Invalidate;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.MouseUp(button: TMouseButton; shift: TShiftState; x, y: Integer);
begin
    inherited MouseUp(button, shift, x, y);

    m_Clicked := False;

    Invalidate;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.WndProc(var message: TMessage);
begin
    case (message.Msg) of
        CM_MOUSEENTER: begin; m_Hovered := True;  Invalidate; end;
        CM_MOUSELEAVE: begin; m_Hovered := False; Invalidate; end;
    end;

    inherited WndProc(message);
end;
//---------------------------------------------------------------------------
function TWSVGImageButton.IsEmpty(pPicture: TPicture): Boolean;
begin
    // is picture empty?
    if (not Assigned(pPicture.Graphic)) then
        Exit(True);

    // is a bitmap?
    if (pPicture.Graphic is Vcl.Graphics.TBitmap) then
    begin
        // is picture bitmap empty?
        if ((pPicture.Bitmap.Width = 0) or (pPicture.Bitmap.Height = 0)) then
            Exit(True);
    end
    else
        // is picture graphic empty?
        if ((pPicture.Graphic.Width = 0) or (pPicture.Graphic.Height = 0)) then
            Exit(True);

    Result := False;
end;
//---------------------------------------------------------------------------
function TWSVGImageButton.CalculateDestRect(pPicture: TPicture): TRect;
var
    w, h, cw, ch: Integer;
    xyaspect:     Double;
begin
    w  := pPicture.Width;
    h  := pPicture.Height;
    cw := ClientWidth;
    ch := ClientHeight;

    if (Stretch or (Proportional and ((w > cw) or (h > ch)))) then
    begin
        if (Proportional and (w > 0) and (h > 0)) then
        begin
            xyaspect := w / h;

            if (w > h) then
            begin
                w := cw;
                h := Trunc(cw / xyaspect);

                // is too big?
                if (h > ch) then
                begin
                    h := ch;
                    w := Trunc(ch * xyaspect);
                end;
            end
            else
            begin
                h := ch;
                w := Trunc(ch * xyaspect);

                // is too big?
                if (w > cw) then
                begin
                    w := cw;
                    h := Trunc(cw / xyaspect);
                end;
            end;
        end
        else
        begin
            w := cw;
            h := ch;
        end;
    end;

    with Result do
    begin
        Left   := 0;
        Top    := 0;
        Right  := w;
        Bottom := h;
    end;

    if Center then
        OffsetRect(Result, (cw - w) div 2, (ch - h) div 2);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.Paint(pPicture: TPicture; pCanvas: TCanvas);
var
    hPaintBuffer, hMemDC: THandle;
    rect:                 TRect;
begin
    // draw the design time rect around the image
    if (csDesigning in ComponentState) then
    begin
        pCanvas.Pen.Style   := psDash;
        pCanvas.Brush.Style := bsClear;
        pCanvas.Rectangle(0, 0, Width, Height);
    end;

    if (((csGlassPaint in ControlState) and (Assigned(pPicture.Graphic)))
            and not pPicture.Graphic.SupportsPartialTransparency)
    then
    begin
        rect         := CalculateDestRect(pPicture);
        hPaintBuffer := BeginBufferedPaint(pCanvas.Handle, rect, BPBF_TOPDOWNDIB, nil, HDC(hMemDC));

        try
            pCanvas.Handle := hMemDC;
            pCanvas.StretchDraw(rect, pPicture.Graphic);
            BufferedPaintMakeOpaque(hPaintBuffer, rect);
        finally
            EndBufferedPaint(hPaintBuffer, True);
        end;
    end
    else
        pCanvas.StretchDraw(CalculateDestRect(pPicture), pPicture.Graphic);
end;
//---------------------------------------------------------------------------
function TWSVGImageButton.DoGetFrameCount(pSender: TWSVGImage.IAnimationProps): Cardinal;
begin
    if (pSender = m_pHoveredAnimation) then
        Exit(Round(GetHoveredFrameCount))
    else
    if (pSender = m_pClickedAnimation) then
        Exit(Round(GetClickedFrameCount))
    else
    if (pSender = m_pDisabledAnimation) then
        Exit(Round(GetDisabledFrameCount));

    Result := inherited DoGetFrameCount(pSender);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.DoSetFrameCount(pSender: TWSVGImage.IAnimationProps; frameCount: Cardinal);
begin
    if (pSender = m_pHoveredAnimation) then
    begin
        SetHoveredFrameCount(frameCount);
        Exit;
    end
    else
    if (pSender = m_pClickedAnimation) then
    begin
        SetClickedFrameCount(frameCount);
        Exit;
    end
    else
    if (pSender = m_pDisabledAnimation) then
    begin
        SetDisabledFrameCount(frameCount);
        Exit;
    end;

    inherited SetFrameCount(frameCount);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.OnProcessAnimation;
begin
    inherited OnProcessAnimation;

    // animate pictures
    CalculateNextFrame(m_pHoveredPicture,  m_pHoveredCalculator,  m_pHoveredAnimation);
    CalculateNextFrame(m_pClickedPicture,  m_pClickedCalculator,  m_pClickedAnimation);
    CalculateNextFrame(m_pDisabledPicture, m_pDisabledCalculator, m_pDisabledAnimation);

    Invalidate;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.OnHoveredPictureChange(pSender: TObject);
begin
    if (m_pHoveredAnimation.Animate) then
        RunAnimation(m_pHoveredPicture, m_pHoveredCalculator);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.OnClickedPictureChange(pSender: TObject);
begin
    if (m_pClickedAnimation.Animate) then
        RunAnimation(m_pClickedPicture, m_pClickedCalculator);
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.OnDisabledPictureChange(pSender: TObject);
begin
    if (m_pDisabledAnimation.Animate) then
        RunAnimation(m_pDisabledPicture, m_pDisabledCalculator);
end;
//---------------------------------------------------------------------------
function TWSVGImageButton.GetHoveredFrameCount: Double;
begin
    if (not Assigned(m_pHoveredCalculator)) then
        Exit(0.0);

    // get the frame count
    Result := m_pHoveredCalculator.GetFrameCount;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.SetHoveredFrameCount(frameCount: Double);
begin
    if (not Assigned(m_pHoveredCalculator)) then
        exit;

    // apply the new frame count
    m_pHoveredCalculator.SetFrameCount(frameCount);
end;
//---------------------------------------------------------------------------
function TWSVGImageButton.GetClickedFrameCount: Double;
begin
    if (not Assigned(m_pClickedCalculator)) then
        Exit(0.0);

    // get the frame count
    Result := m_pClickedCalculator.GetFrameCount;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.SetClickedFrameCount(frameCount: Double);
begin
    if (not Assigned(m_pClickedCalculator)) then
        exit;

    // apply the new frame count
    m_pClickedCalculator.SetFrameCount(frameCount);
end;
//---------------------------------------------------------------------------
function TWSVGImageButton.GetDisabledFrameCount: Double;
begin
    if (not Assigned(m_pDisabledCalculator)) then
        Exit(0.0);

    // get the frame count
    Result := m_pDisabledCalculator.GetFrameCount;
end;
//---------------------------------------------------------------------------
procedure TWSVGImageButton.SetDisabledFrameCount(frameCount: Double);
begin
    if (not Assigned(m_pDisabledCalculator)) then
        exit;

    // apply the new frame count
    m_pDisabledCalculator.SetFrameCount(frameCount);
end;
//---------------------------------------------------------------------------

end.
