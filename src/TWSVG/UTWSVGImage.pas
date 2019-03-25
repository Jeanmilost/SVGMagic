{**
 @abstract(@name provides an overridden image that supports the SVG graphics in a such manner that
           the animations are taken into account internally.)
 @author(JMR)
 @created(2016-2019 by Ursa Minor)
}
unit UTWSVGImage;

interface

uses System.Classes,
     System.SysUtils,
     System.Math,
     Vcl.Graphics,
     Vcl.ExtCtrls,
     UTWMajorSettings,
     UTWDesignPatterns,
     UTWAnimationTimer,
     UTWSVGAnimationDescriptor,
     UTWSVGRasterizer,
     UTWSVGGraphic,
     UTWSVGFrameCalculator;

type
    {**
     Image that supports animated SVG graphics
    }
    TWSVGImage = class(TImage, IWObserver)
        public type
            {**
             Class to group and expose all SVG animation properties
            }
            IAnimationProps = class(TPersistent)
                private
                    m_pOwner:           TWSVGImage;
                    m_Position:         Cardinal;
                    m_Animate:          Boolean;
                    m_FramePosChanging: Boolean;

                protected
                    {**
                     Get the frame count
                     @returns(The frame count)
                     @br @bold Be careful, this is not identical to the FPS. The frame count is used
                               to determine how many frames, in an ideal situation, should be rendered
                               by seconds, and thus allows to calculate the time interval between each
                               frames. Instead, the FPS represents the number of frames per seconds
                               a system can effectively process
                    }
                    function GetFrameCount: Cardinal; virtual;

                    {**
                     Set the frame count
                     @param(count Frame count)
                     @br @bold Be careful, this is not identical to the FPS. The frame count is used
                               to determine how many frames, in an ideal situation, should be rendered
                               by seconds, and thus allows to calculate the time interval between each
                               frames. Instead, the FPS represents the number of frames per seconds
                               a system can effectively process
                    }
                    procedure SetFrameCount(count: Cardinal); virtual;

                    {**
                     Set animation position
                     @param(pos Animation position in percent (between 0 and 100))
                    }
                    procedure SetPosition(pos: Cardinal); virtual;

                    {**
                     Enable or disable the animation
                     @param(value If @true the animation will be enabled, disabled otherwise)
                    }
                    procedure SetAnimate(value: Boolean); virtual;

                public
                    {**
                     Constructor
                     @param(pOwner Properties owner)
                    }
                    constructor Create(pOwner: TWSVGImage); virtual;

                    {**
                     Destructor
                    }
                    destructor Destroy; override;

                published
                    {**
                     Get or set the number of frame to render per seconds
                     @br @bold Be careful, this is not identical to the FPS. The frame count is used
                               to determine how many frames, in an ideal situation, should be rendered
                               by seconds, and thus allows to calculate the time interval between each
                               frames. Instead, the FPS represents the number of frames per seconds
                               a system can effectively process
                    }
                    property FrameCount: Cardinal read GetFrameCount write SetFrameCount nodefault;

                    {**
                     Get or set the animation position, in percent (between 0 and 100)
                    }
                    property Position: Cardinal read m_Position write SetPosition nodefault;

                    {**
                     Enable or disable the animation
                    }
                    property Animate: Boolean read m_Animate write SetAnimate default C_TWSVGGraphic_Default_Animate;
            end;

            {**
             Called when a SVG is about to be animated
             @param(pSender Event sender)
             @param(pAnimDesc Animation description)
             @param(pCustomData Custom data)
             @returns(@true if animation can continue, otherwise @false)
            }
            ITfSVGAnimateEvent = function (pSender: TObject; pAnimDesc: TWSVGAnimationDescriptor;
                    pCustomData: Pointer): Boolean of object;

        private
            m_pAnimationProps:      IAnimationProps;
            m_pFrameCalculator:     TWSVGFrameCalculator;
            m_LastKnownAnimDur:     Double;
            m_fOnAnimate:           ITfSVGAnimateEvent;
            m_fPrevOnPictureChange: TNotifyEvent;

            {**
             Get the library version
             @returns(Library version, #ERROR on error)
            }
            function GetVersion: UnicodeString;

        protected
            {**
             Check if animation can be run, run it if yes
             @param(pPicture Picture for which next animation should be calculated)
             @param(pFrameCalculator Frame calculator linked with the picture)
            }
            procedure RunAnimation(pPicture: TPicture; pFrameCalculator: TWSVGFrameCalculator); virtual;

            {**
             Calculate the next animation frame
             @param(pPicture Picture for which next animation should be calculated)
             @param(pFrameCalculator Frame calculator linked with the picture)
             @param(pAnimProps Animation properties)
            }
            procedure CalculateNextFrame(pPicture: TPicture; pFrameCalculator: TWSVGFrameCalculator;
                    pAnimProps: IAnimationProps); virtual;

            {**
             Called when the frame count should be get from properties
             @param(pSender Sender for which the frame count should be get)
             @returns(The frame count)
            }
            function DoGetFrameCount(pSender: IAnimationProps): Cardinal; virtual;

            {**
             Called when the frame count should be set to properties
             @param(pSender Sender for which the frame count should be set)
             @param(frameCount Frame count)
            }
            procedure DoSetFrameCount(pSender: IAnimationProps; frameCount: Cardinal); virtual;

            {**
             Enable or disable the animation
             @param(pProps Animation properties in which animate value changed)
             @param(value If @true the animation will be enabled, disabled otherwise)
            }
            procedure SetAnimate(pProps: IAnimationProps; value: Boolean); virtual;

            {**
             Called while SVG animation is running
             @param(pSender Event sender)
             @param(pAnimDesc Animation description)
             @param(pCustomData Custom data)
             @returns(@true if animation can continue, otherwise @false)
            }
            function DoAnimate(pSender: TObject; pAnimDesc: TWSVGAnimationDescriptor;
                    pCustomData: Pointer): Boolean; virtual;

            {**
             Called when next animation frame should be processed
            }
            procedure OnProcessAnimation; virtual;

            {**
             Called when the internal picture changed
             @param(pSender Event sender)
            }
            procedure OnPictureChange(pSender: TObject); virtual;

            {**
             Called when subject send a notification to the observer
             @param(message Notification message)
            }
            procedure OnNotified(message: TWMessage); virtual;

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
             Get the frame count
             @returns(The frame count)
             @br @bold Be careful, this is not identical to the FPS. The frame count is used to
                       determine how many frames, in an ideal situation, should be rendered by
                       seconds, and thus allows to calculate the time interval between each frames.
                       Instead, the FPS represents the number of frames per seconds a system can
                       effectively process
            }
            function GetFrameCount: Double; virtual;

            {**
             Set the frame count
             @param(frameCount Frame count)
             @br @bold Be careful, this is not identical to the FPS. The frame count is used to
                       determine how many frames, in an ideal situation, should be rendered by
                       seconds, and thus allows to calculate the time interval between each frames.
                       Instead, the FPS represents the number of frames per seconds a system can
                       effectively process
            }
            procedure SetFrameCount(frameCount: Double); virtual;

        published
            {**
             Get the library version number
            }
            property Version: UnicodeString read GetVersion;

            {**
             Get or set the animation properties
            }
            property Animation: IAnimationProps read m_pAnimationProps write m_pAnimationProps;

            {**
             Get or set the OnAnimate event
            }
            property OnAnimate: ITfSVGAnimateEvent read m_fOnAnimate write m_fOnAnimate;
    end;

implementation
//---------------------------------------------------------------------------
// TWSVGImage.IAnimationProps
//---------------------------------------------------------------------------
constructor TWSVGImage.IAnimationProps.Create(pOwner: TWSVGImage);
begin
    inherited Create;

    m_pOwner           := pOwner;
    m_Position         := 0;
    m_Animate          := C_TWSVGGraphic_Default_Animate;
    m_FramePosChanging := False;
end;
//---------------------------------------------------------------------------
destructor TWSVGImage.IAnimationProps.Destroy;
begin
    inherited Destroy;
end;
//---------------------------------------------------------------------------
function TWSVGImage.IAnimationProps.GetFrameCount: Cardinal;
begin
    Result := m_pOwner.DoGetFrameCount(Self);
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.IAnimationProps.SetFrameCount(count: Cardinal);
begin
    m_pOwner.DoSetFrameCount(Self, count);
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.IAnimationProps.SetPosition(pos: Cardinal);
begin
    // sometimes frame position may be updated while OnProcessAnimation() function is called. This
    // prevent an infinite callback loop in this case
    if (m_FramePosChanging) then
        Exit;

    m_Position := Min(pos, 100);

    // process animation manually if animation is disabled
    if (not m_Animate) then
        try
            m_FramePosChanging := True;
            m_pOwner.OnProcessAnimation;
        finally
            m_FramePosChanging := False;
        end;
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.IAnimationProps.SetAnimate(value: Boolean);
begin
    if (value = m_Animate) then
        Exit;

    m_Animate := value;

    m_pOwner.SetAnimate(Self, value);
end;
//---------------------------------------------------------------------------
// TWSVGImage
//---------------------------------------------------------------------------
constructor TWSVGImage.Create(pOwner: TComponent);
begin
    inherited Create(pOwner);

    m_pAnimationProps  := IAnimationProps.Create(Self);
    m_pFrameCalculator := TWSVGFrameCalculator.Create;
    m_LastKnownAnimDur := 0.0;
    m_fOnAnimate       := nil;

    // override the picture OnChange event
    m_fPrevOnPictureChange := Picture.OnChange;
    Picture.OnChange       := OnPictureChange;

    // attach to animation timer to receive time notifications (runtime only)
    if (not(csDesigning in ComponentState)) then
        TWAnimationTimer.GetInstance.Attach(Self);
end;
//---------------------------------------------------------------------------
destructor TWSVGImage.Destroy;
begin
    // detach from animation timer and stop to receive time notifications (runtime only)
    if (not(csDesigning in ComponentState)) then
        TWAnimationTimer.GetInstance.Detach(Self);

    FreeAndNil(m_pFrameCalculator);
    FreeAndNil(m_pAnimationProps);

    inherited Destroy;
end;
//---------------------------------------------------------------------------
function TWSVGImage.GetVersion: UnicodeString;
begin
    if (not Assigned(TWLibraryVersion)) then
        Exit('#ERROR');

    Result := TWLibraryVersion.ToStr;
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.RunAnimation(pPicture: TPicture; pFrameCalculator: TWSVGFrameCalculator);
var
    pSVG:     TWSVGGraphic;
    duration: Double;
begin
    // on design time animation is never allowed to start
    if (csDesigning in ComponentState) then
        Exit;

    // is a SVG?
    if (Assigned(pPicture.Graphic) and (pPicture.Graphic is TWSVGGraphic)) then
    begin
        // get and configure the SVG
        pSVG           := pPicture.Graphic as TWSVGGraphic;
        pSVG.OnAnimate := DoAnimate;

        // get animation duration
        duration := pSVG.AnimationDuration;

        // animation duration changed?
        if (duration = m_LastKnownAnimDur) then
            Exit;

        // can animate this SVG?
        if (duration <> 0.0) then
        begin
            // configure animation duration
            pFrameCalculator.SetDuration(duration, 100);

            // start frame animation
            pFrameCalculator.StartTimer;
        end;

        m_LastKnownAnimDur := duration;
    end
    else
        m_LastKnownAnimDur := 0.0;
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.CalculateNextFrame(pPicture: TPicture; pFrameCalculator: TWSVGFrameCalculator;
        pAnimProps: IAnimationProps);
var
    pSVG: TWSVGGraphic;
    info: TWSVGFrameCalculator.IInfo;
begin
    if (not Assigned(pPicture.Graphic)) then
        Exit;

    // nothing to do if component isn't visible
    if (not Visible) then
        Exit;

    if (pPicture.Graphic is TWSVGGraphic) then
    begin
        pSVG := pPicture.Graphic as TWSVGGraphic;

        // calculate next position
        if (m_pAnimationProps.Animate) then
        begin
            pFrameCalculator.GetInfo(info);

            pAnimProps.Position := TWSVGFrameCalculator.ValidateIndex(pAnimProps.Position
                    + info.m_FrameCountSinceLastPaint, 0, 99);
        end;

        // change svg position and refresh the viewer
        pSVG.Position := pAnimProps.Position * 0.01;
    end;
end;
//---------------------------------------------------------------------------
function TWSVGImage.DoGetFrameCount(pSender: IAnimationProps): Cardinal;
begin
    Result := Round(GetFrameCount);
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.DoSetFrameCount(pSender: IAnimationProps; frameCount: Cardinal);
begin
    SetFrameCount(frameCount);
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.SetAnimate(pProps: IAnimationProps; value: Boolean);
begin
    if (value) then
        RunAnimation(Picture, m_pFrameCalculator)
end;
//---------------------------------------------------------------------------
function TWSVGImage.DoAnimate(pSender: TObject; pAnimDesc: TWSVGAnimationDescriptor;
        pCustomData: Pointer): Boolean;
begin
    // ask user about continuing animation
    if (Assigned(m_fOnAnimate)) then
        Exit(m_fOnAnimate(pSender, pAnimDesc, pCustomData));

    // notify that animation is allowed to continue
    Result := True;
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.OnProcessAnimation;
begin
    CalculateNextFrame(Picture, m_pFrameCalculator, m_pAnimationProps);
    Invalidate;
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.OnPictureChange(pSender: TObject);
begin
    if (Assigned(m_fPrevOnPictureChange)) then
        m_fPrevOnPictureChange(pSender);

    if (m_pAnimationProps.Animate) then
        RunAnimation(Picture, m_pFrameCalculator);
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.OnNotified(message: TWMessage);
begin
    case (TWAnimationTimer.EWAnimationTimerMessages(message.m_Type)) of
        TWAnimationTimer.EWAnimationTimerMessages.IE_AM_Animate:
        begin
            if (not m_pAnimationProps.Animate) then
                Exit;

            OnProcessAnimation;
        end;
    end;
end;
//---------------------------------------------------------------------------
function TWSVGImage.GetFrameCount: Double;
begin
    if (not Assigned(m_pFrameCalculator)) then
        Exit(0.0);

    // get the frame count
    Result := m_pFrameCalculator.GetFrameCount;
end;
//---------------------------------------------------------------------------
procedure TWSVGImage.SetFrameCount(frameCount: Double);
begin
    if (not Assigned(m_pFrameCalculator)) then
        exit;

    // apply the new frame count
    m_pFrameCalculator.SetFrameCount(frameCount);
end;
//---------------------------------------------------------------------------

end.
