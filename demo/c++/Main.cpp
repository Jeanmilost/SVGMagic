#include <vcl.h>
#pragma hdrstop
#include "Main.h"

// std
#include <memory>

#include "Resources.rh"

#pragma package(smart_init)
#pragma link "UTWSVGGraphic"
#pragma link "UTWSVGImageList"
#pragma link "UTWSVGCheckBoxStyle"
#pragma link "UTWSVGImage"
#pragma link "UTWSVGComponentStyle"
#pragma link "UTWSVGRadioButtonStyle"
#pragma link "UTWSVGImageButton"
#pragma resource "*.dfm"

//---------------------------------------------------------------------------
TMainForm* MainForm;
//---------------------------------------------------------------------------
__fastcall TMainForm::TMainForm(TComponent* pOwner) :
    TForm(pOwner),
    m_CurrentSelection(-1),
    m_ResizeDirection(-10),
    m_ResizeableTrackbarWndProc_Backup(NULL),
    m_StepByStepTrackbarWndProc_Backup(NULL)
{
    #ifndef _DEBUG
        const int count = pcMain->PageCount;

        // hide page control tabs
        for (int i = 0; i < count; ++i)
            pcMain->Pages[i]->TabVisible = false;
    #endif

    // hook the resizeable trackbar windows procedure
    m_ResizeableTrackbarWndProc_Backup        = tbGalleryLine1ResizeableImage->WindowProc;
    tbGalleryLine1ResizeableImage->WindowProc = ResizeableTrackbarWndProc;

    // hook the step-by-step trackbar windows procedure
    m_StepByStepTrackbarWndProc_Backup        = tbGalleryLine1StepByStepImage->WindowProc;
    tbGalleryLine1StepByStepImage->WindowProc = StepByStepTrackbarWndProc;

    // be notified if the per-monitor DPI changes
    #if (CompilerVersion >= 30)
        OnAfterMonitorDpiChanged = OnAfterMonitorDpiChangedHandler;
    #endif

    ibGalleryFormClick(NULL);
}
//---------------------------------------------------------------------------
__fastcall TMainForm::~TMainForm()
{
    if (m_ResizeableTrackbarWndProc_Backup)
        tbGalleryLine1ResizeableImage->WindowProc = m_ResizeableTrackbarWndProc_Backup;

    if (m_StepByStepTrackbarWndProc_Backup)
        tbGalleryLine1StepByStepImage->WindowProc = m_StepByStepTrackbarWndProc_Backup;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::FormResize(TObject* pSender)
{
    Browser_OnResize();
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::pcMainChange(TObject* pSender)
{
    // search for active page
    if (pcMain->ActivePage == tsBrowser)
        OpenBrowserPage();
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ibGalleryFormClick(TObject* pSender)
{
    pcMain->ActivePage = tsComponentGallery;

    // the TPageControl will not call it so force the OnChange event manually
    pcMainChange(pcMain);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ibBrowserFormClick(TObject* pSender)
{
    pcMain->ActivePage = tsBrowser;

    // the TPageControl will not call it so force the OnChange event manually
    pcMainChange(pcMain);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ibBankingFormClick(TObject *Sender)
{
    pcMain->ActivePage = tsBanking;

    // the TPageControl will not call it so force the OnChange event manually
    pcMainChange(pcMain);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ibFreshBooksFormClick(TObject* pSender)
{
    pcMain->ActivePage = tsFreshBooks;

    // the TPageControl will not call it so force the OnChange event manually
    pcMainChange(pcMain);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::lbDirClick(TObject* pSender)
{
    // is file list empty?
    if (!lbDir->Count)
        return;

    // is file list selection valid?
    if (lbDir->ItemIndex < 0 || lbDir->ItemIndex >= lbDir->Count)
        return;

    // nothing changed since last selection?
    if (lbDir->ItemIndex == m_CurrentSelection)
        return;

    // open SVG from selection
    Browser_OpenSVG(m_CurrentDir + lbDir->Items->Strings[lbDir->ItemIndex]);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::btGalleryPopupMenuBtnClick(TObject* pSender)
{
    TPoint mousePos = Mouse->CursorPos;
    pmPopup->Popup(mousePos.X, mousePos.Y);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::btPrevClick(TObject* pSender)
{
    // is file list empty?
    if (!lbDir->Count)
        return;

    // calculate prev valid index to show
    if (lbDir->ItemIndex - 1 < 0)
        lbDir->ItemIndex = lbDir->Count - 1;
    else
        lbDir->ItemIndex = lbDir->ItemIndex - 1;

    // open SVG from selection
    Browser_OpenSVG(m_CurrentDir + lbDir->Items->Strings[lbDir->ItemIndex]);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::btNextClick(TObject* pSender)
{
    // is file list empty?
    if (!lbDir->Count)
        return;

    // calculate next valid index to show
    if (lbDir->ItemIndex + 1 >= lbDir->Count)
        lbDir->ItemIndex = 0;
    else
        lbDir->ItemIndex = lbDir->ItemIndex + 1;

    // open SVG from selection
    Browser_OpenSVG(m_CurrentDir + lbDir->Items->Strings[lbDir->ItemIndex]);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::btSlideshowClick(TObject* pSender)
{
    // slideshow enabled?
    tiSlideshow->Enabled      = !tiSlideshow->Enabled;
    tbSlideshowTimer->Visible =  tiSlideshow->Enabled;

    if (ilImages->Count)
        btSlideshow->ImageIndex = tiSlideshow->Enabled ? 0 : -1;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::btBrowseClick(TObject* pSender)
{
    // let the user select the file to show
    if (!odOpen->Execute())
        return;

    Browser_OpenSVG(odOpen->FileName);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::btChangeBgColorClick(TObject* pSender)
{
    cdBgColor->Color = paViewer->Color;

    if (!cdBgColor->Execute(Handle))
        return;

    paViewer->Color = cdBgColor->Color;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::edBrowserAnimSpeedChange(TObject* pSender)
{
    // don't try to convert empty text
    if (edBrowserAnimSpeed->Text.IsEmpty())
        return;

    // ignore too long texts
    if (edBrowserAnimSpeed->Text.Length() > 5)
        return;

    // get the new FPS value to apply
    const int frameCount = std::min(std::max(::StrToInt(::StringReplace(edBrowserAnimSpeed->Text,
            L"'", L"", TReplaceFlags() << rfReplaceAll << rfIgnoreCase)), udBrowserAnimSpeed->Min),
            udBrowserAnimSpeed->Max);

    // apply new frame count
    imViewer->Animation->FrameCount = frameCount;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::edBrowserZoomChange(TObject* pSender)
{
    if (acFitToView->Checked)
        return;

    // get the SVG graphic
    TWSVGGraphic* pSVGGraphic = dynamic_cast<TWSVGGraphic*>(imViewer->Picture->Graphic);

    if (!pSVGGraphic)
        return;

    // get the original SVG size
    const TSize svgSize = pSVGGraphic->Rasterizer->GetSize(pSVGGraphic->Native);

    // don't try to convert empty text
    if (edBrowserZoom->Text.IsEmpty())
    {
        // restore original size
        pSVGGraphic->Width  = svgSize.Width;
        pSVGGraphic->Height = svgSize.Height;
        return;
    }

    // ignore too long texts
    if (edBrowserZoom->Text.Length() > 5)
    {
        // restore original size
        pSVGGraphic->Width  = svgSize.Width;
        pSVGGraphic->Height = svgSize.Height;
        return;
    }

    // get the new zoom fator to apply
    const int zoomFactor = std::min(std::max(::StrToInt(::StringReplace(edBrowserZoom->Text, L"'",
            L"", TReplaceFlags() << rfReplaceAll << rfIgnoreCase)), udBrowserZoom->Min), udBrowserZoom->Max);

    // apply the size with the zoom factor
    pSVGGraphic->Width  = svgSize.Width  * (float(zoomFactor) / 100.0f);
    pSVGGraphic->Height = svgSize.Height * (float(zoomFactor) / 100.0f);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::tbGalleryLine1ResizeableImageChange(TObject* pSender)
{
    // update the image size
    imGalleryLine1ResizeableImage->Left   = 125 - (tbGalleryLine1ResizeableImage->Position / 2.3f);
    imGalleryLine1ResizeableImage->Top    = 125 - (tbGalleryLine1ResizeableImage->Position / 3);
    imGalleryLine1ResizeableImage->Width  = tbGalleryLine1ResizeableImage->Position;
    imGalleryLine1ResizeableImage->Height = tbGalleryLine1ResizeableImage->Position;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::tbGalleryLine1StepByStepImageChange(TObject* pSender)
{
    // update the image frame number
    imGalleryLine1StepByStepImage->Animation->Position = tbGalleryLine1StepByStepImage->Position;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::tbSlideshowTimerChange(TObject* pSender)
{
    tiSlideshow->Interval = tbSlideshowTimer->Position;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::tiSlideshowTimer(TObject* pSender)
{
    // the currently visible page isn't the browser page?
    if (pcMain->ActivePage != tsBrowser)
        return;

    btNextClick(btNext);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::tiResizeTimer(TObject* Sender)
{
    // the currently visible page isn't the demo page?
    if (pcMain->ActivePage != tsComponentGallery)
        return;

    // update the trackbar position
    tbGalleryLine1ResizeableImage->Position += m_ResizeDirection;

    // check if direction should be inverted
    if (imGalleryLine1ResizeableImage->Height <= tbGalleryLine1ResizeableImage->Min)
    {
        imGalleryLine1ResizeableImage->Width  =  tbGalleryLine1ResizeableImage->Min;
        imGalleryLine1ResizeableImage->Height =  tbGalleryLine1ResizeableImage->Min;
        m_ResizeDirection                     = -m_ResizeDirection;
    }
    else
    if (imGalleryLine1ResizeableImage->Height >= tbGalleryLine1ResizeableImage->Max)
    {
        imGalleryLine1ResizeableImage->Width  =  tbGalleryLine1ResizeableImage->Max;
        imGalleryLine1ResizeableImage->Height =  tbGalleryLine1ResizeableImage->Max;
        m_ResizeDirection                     = -m_ResizeDirection;
    }
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::spMainVertMoved(TObject* pSender)
{
    Browser_OnResize();
}
//---------------------------------------------------------------------------
bool __fastcall TMainForm::imGalleryLine1StepByStepImageAnimate(TObject* pSender,
        TWSVGAnimationDescriptor* pAnimDesc, Pointer pCustomData)
{
    tbGalleryLine1StepByStepImage->Position = imGalleryLine1StepByStepImage->Animation->Position;
    return true;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::imBankingBuyNowButtonClick(TObject* pSender)
{
    imBankingBuyNowButton->Enabled = false;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::imFreshBooksPayNowClick(TObject* pSender)
{
    imFreshBooksPayNow->Enabled = false;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::acDemoTBitBtnExecute(TObject* pSender)
{
    // dummy stupid code, otherwise RAD Studio will disable the action
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::acDemoTSpeedBtnExecute(TObject* pSender)
{
    // dummy stupid code, otherwise RAD Studio will disable the action
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::acAnimateExecute(TObject* pSender)
{
    imViewer->Animation->Animate = acAnimate->Checked;
    edBrowserAnimSpeed->Enabled  = acAnimate->Checked;
    udBrowserAnimSpeed->Enabled  = acAnimate->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::acFitToViewExecute(TObject* pSender)
{
    edBrowserZoom->Enabled = !acFitToView->Checked;
    udBrowserZoom->Enabled = !acFitToView->Checked;

    if (acFitToView->Checked)
    {
        // set SVG size to fit the view
        imViewer->Picture->Graphic->Width  = imViewer->Width;
        imViewer->Picture->Graphic->Height = imViewer->Height;
    }
    else
        // apply the zoom factor
        edBrowserZoomChange(NULL);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::aeEventsMessage(tagMSG& msg, bool& handled)
{
    // dispatch messages
    switch (msg.message)
    {
        case WM_MOUSEWHEEL:
        {
            // search for currently visible page
            if (pcMain->ActivePage == tsBrowser)
            {
                // do nothing if the browser zoom isn't accessible
                if (!edBrowserZoom->Enabled)
                    return;

                // get zoom direction (positive up, negative down)
                short delta = GET_WHEEL_DELTA_WPARAM(msg.wParam);

                if (!delta)
                    return;

                // compute zoom distance
                const int distance = delta / WHEEL_DELTA;

                // apply the new zoom value
                udBrowserZoom->Position += distance * 5;

                handled = true;
                return;
            }
            else
            {
                // get zoom direction (positive up, negative down)
                short      delta         = GET_WHEEL_DELTA_WPARAM(msg.wParam);
                const WORD lineDirection = delta > 0 ? SB_LINEUP : SB_LINEDOWN;
                const WORD pageDirection = delta > 0 ? SB_PAGEUP : SB_PAGEDOWN;

                if (!delta)
                    return;

                // find control under cursor
                TControl* pTarget = FindDragTarget(TPoint(msg.pt.x, msg.pt.y), true);

                if (!pTarget)
                    return;

                // check first scrolling window parent and scroll it
                TWinControl* pWinControl = dynamic_cast<TWinControl*>(pTarget);

                if (!pWinControl)
                    pWinControl = pTarget->Parent;

                WINDOWINFO info = {0};
                info.cbSize     = sizeof(info);

                // find first window control in child's parent hieararchy with scrollbars and scroll it
                for (; pWinControl; pWinControl = pWinControl->Parent)
                {
                    // poll window info for vertical scrollbar
                    if (!GetWindowInfo(pWinControl->Handle, &info))
                        continue;

                    if (!(info.dwStyle & WS_VSCROLL))
                        continue;

                    // has vertical scrollbars, scroll window
                    if (delta < 0)
                        delta *= -1;

                    // compute scroll distance
                    int distance = delta / WHEEL_DELTA;

                    // if distance < 5 send distance time SB_LINEUP/DOWN messages otherwise one SB_PAGEUP/DOWN
                    if (distance < 5)
                    {
                        // mutiply actual distance for better effect (more scrolling)
                        distance *= 5;

                        for (int i = 0; i < distance; ++i)
                            ::SendMessage(pWinControl->Handle, WM_VSCROLL, MAKEWPARAM(lineDirection, 0), NULL);
                    }
                    else
                        ::SendMessage(pWinControl->Handle, WM_VSCROLL, MAKEWPARAM(pageDirection, 0), NULL);

                    handled = true;
                    return;
                }
            }
        }
    }
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::OnAfterMonitorDpiChangedHandler(TObject* pSender, int oldDPI, int newDPI)
{
    // TBitBtn doesn't refresh his glyph automatically, so force it to refresh
    acDemoTBitBtn->ImageIndex = -1;
    acDemoTBitBtn->ImageIndex =  1;

    // TSpeedBtn doesn't refresh his glyph automatically, so force it to refresh
    acDemoTSpeedBtn->ImageIndex = -1;
    acDemoTSpeedBtn->ImageIndex =  1;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ResizeableTrackbarWndProc(TMessage& message)
{
    switch (message.Msg)
    {
        case CM_MOUSEENTER: tiResize->Enabled = false; break;
        case CM_MOUSELEAVE: tiResize->Enabled = true;  break;
    }

    if (m_ResizeableTrackbarWndProc_Backup)
        m_ResizeableTrackbarWndProc_Backup(message);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::StepByStepTrackbarWndProc(TMessage& message)
{
    switch (message.Msg)
    {
        case CM_MOUSEENTER: imGalleryLine1StepByStepImage->Animation->Animate = false; break;
        case CM_MOUSELEAVE: imGalleryLine1StepByStepImage->Animation->Animate = true;  break;
    }

    if (m_StepByStepTrackbarWndProc_Backup)
        m_StepByStepTrackbarWndProc_Backup(message);
}
//---------------------------------------------------------------------------
void TMainForm::OpenBrowserPage()
{
    Browser_ClearView();

    m_CurrentDir = Browser_GetDefaultImgDir();

    try
    {
        lbDir->Items->BeginUpdate();
        lbDir->Items->Clear();

        TSearchRec fileRec;

        // also list the other SVG in the dir to facilitate the browsing
        if (::FindFirst(m_CurrentDir + L"*.svg", faNormal, fileRec) == 0)
        {
            do
            {
                // add SVG file name to list
                lbDir->Items->Add(fileRec.Name);
            }
            while (::FindNext(fileRec) == 0);

            FindClose(fileRec);
        }
    }
    __finally
    {
        lbDir->Items->EndUpdate();
        lbDir->Invalidate();
    }

    // get the default image directory
    odOpen->InitialDir = m_CurrentDir;

    // configure the viewer events
    imViewer->OnAnimate = Browser_OnAnimate;

    // configure the slideshow timer position
    tbSlideshowTimer->Position = tiSlideshow->Interval;

    // open the first image if available
    if (lbDir->Count > 0)
    {
        lbDir->ItemIndex = 0;

        // open SVG from selection
        Browser_OpenSVG(m_CurrentDir + lbDir->Items->Strings[lbDir->ItemIndex]);
    }
}
//---------------------------------------------------------------------------
UnicodeString TMainForm::Browser_GetDefaultImgDir() const
{
    // get the image directory. Start from current application dir
    UnicodeString imgDir = ::IncludeTrailingPathDelimiter(::GetCurrentDir());

    // check if image dir is closer to application location
    if (::DirectoryExists(imgDir + L"Images"))
        imgDir += L"Images";
    else
    {
        // image dir isn't next to app location, probably app is running from compiler. So browse to
        // image directory. From the current app path, it's should be located at: ".\\..\\..\\..\\Images"
        imgDir  = ::ExtractFilePath(::ExcludeTrailingPathDelimiter(imgDir));
        imgDir  = ::ExtractFilePath(::ExcludeTrailingPathDelimiter(imgDir));
        imgDir  = ::ExtractFilePath(::ExcludeTrailingPathDelimiter(imgDir));
        imgDir += L"Images";
    }

    // check if dir exists. If not, use the current application dir
    if (::DirectoryExists(imgDir))
        return ::IncludeTrailingPathDelimiter(imgDir);

    return ::IncludeTrailingPathDelimiter(::GetCurrentDir());
}
//---------------------------------------------------------------------------
void TMainForm::Browser_ClearView()
{
    // clear previous view
    acAnimate->Enabled          = false;
    edBrowserAnimSpeed->Enabled = false;
    udBrowserAnimSpeed->Enabled = false;
    edBrowserAnimSpeed->Text    = L"0";
    imViewer->Picture->Assign(NULL);
}
//---------------------------------------------------------------------------
void TMainForm::Browser_OpenSVG(const UnicodeString& fileName)
{
    Browser_ClearView();

    // save the current directory
    m_CurrentDir = ::IncludeTrailingPathDelimiter(::ExtractFilePath(fileName));

    // get the SVG file name to open
    const UnicodeString svgName = ::ExtractFileName(fileName);

    try
    {
        lbDir->Items->BeginUpdate();
        lbDir->Clear();

        TSearchRec fileRec;

        // also list the other SVG in the dir to facilitate the browsing
        if (::FindFirst(m_CurrentDir + L"*.svg", faNormal, fileRec) == 0)
        {
            do
            {
                // add SVG file name to list
                lbDir->Items->Add(fileRec.Name);

                // found currently opened SVG?
                if (fileRec.Name == svgName)
                {
                    // select it
                    lbDir->ItemIndex   = lbDir->Count - 1;
                    m_CurrentSelection = lbDir->ItemIndex;
                }
            }
            while (::FindNext(fileRec) == 0);

            FindClose(fileRec);
        }
    }
    __finally
    {
        lbDir->Items->EndUpdate();
        lbDir->Invalidate();
    }

    // load and configure the SVG file
    std::unique_ptr<TWSVGGraphic> pSvg(new TWSVGGraphic());
    pSvg->LoadFromFile(fileName);
    pSvg->Proportional = true;

    if (acFitToView->Checked)
    {
        // set SVG size to fit the view
        pSvg->Width  = imViewer->Width;
        pSvg->Height = imViewer->Height;
    }
    else
    {
        // get original SVG size
        const TSize svgSize = pSvg->Rasterizer->GetSize(pSvg->Native);

        // reset the zoom control
        edBrowserZoom->Text     = L"100";
        udBrowserZoom->Position = 100;

        // set SVG size
        pSvg->Width  = svgSize.Width;
        pSvg->Height = svgSize.Height;
    }

    // show it in viewer
    imViewer->Picture->Assign(pSvg.get());
}
//---------------------------------------------------------------------------
void TMainForm::Browser_OnResize()
{
    // is browser visible and a picture is currently shown?
    if (!acFitToView->Checked || pcMain->ActivePage != tsBrowser || !imViewer->Picture->Graphic)
        return;

    // resize it
    imViewer->Picture->Graphic->Width  = imViewer->ClientWidth;
    imViewer->Picture->Graphic->Height = imViewer->ClientHeight;
}
//---------------------------------------------------------------------------
bool __fastcall TMainForm::Browser_OnAnimate(TObject* pSender, TWSVGAnimationDescriptor* pAnimDesc,
        void* pCustomData)
{
    // this event is called only if SVG supports animation, so enable the animation interface
    acAnimate->Enabled          = true;
    edBrowserAnimSpeed->Enabled = true;
    udBrowserAnimSpeed->Enabled = true;
    edBrowserAnimSpeed->Text    = ::IntToStr((int)imViewer->Animation->FrameCount);

    // notify that animation is allowed to run
    return true;
}
//---------------------------------------------------------------------------
void TMainForm::MakeRounded(TWinControl* pControl)
{
    TRect rect = pControl->ClientRect;
    HRGN  hRgn = CreateRoundRectRgn(rect.Left, rect.Top, rect.Right + 5, rect.Bottom + 5, 5, 5);
    pControl->Perform(EM_GETRECT, 0, LPARAM(&rect));
    ::InflateRect(&rect, -5, -5);
    pControl->Perform(EM_SETRECTNP, 0, LPARAM(&rect));
    ::SetWindowRgn(pControl->Handle, hRgn, true);
    pControl->Invalidate();
}
//---------------------------------------------------------------------------
