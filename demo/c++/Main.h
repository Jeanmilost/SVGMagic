#ifndef MainH
#define MainH

// vcl
#include <System.Classes.hpp>
#include "System.Actions.hpp"
#include "System.ImageList.hpp"
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ActnList.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.ValEdit.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.AppEvnts.hpp>

// magic SVG
#include "UTWSVGGraphic.hpp"
#include "UTWSVGImageList.hpp"
#include "UTWSVGCheckBoxStyle.hpp"
#include "UTWSVGImage.hpp"
#include "UTWSVGComponentStyle.hpp"
#include "UTWSVGRadioButtonStyle.hpp"
#include "UTWSVGImageButton.hpp"

// std
#include <string>
#include <vector>

/**
* Demo main form
*@author JMR
*/
class TMainForm : public TForm
{
    __published:
        TPageControl *pcMain;
        TPanel *paNavigation;
        TTabSheet *tsBanking;
        TPanel *paBankingHeader;
        TWSVGImage *imBankingHeaderClipart;
        TShape *shBankingHeaderBackground;
        TLabel *laBankingHeaderTitle;
        TLabel *laBankingHeaderDesc;
        TScrollBox *sbBanking;
        TPanel *paBankingSummary;
        TBevel *blBankingHeaderSeparator;
        TLabel *laBankingSummaryTitle;
        TLabel *laBankingSummaryReview;
        TValueListEditor *veBankingSummary;
        TBevel *blBankingSummarySeparator;
        TPanel *paBankingBillingInfo;
        TWSVGRadioButtonStyle *rsBankingStyle;
        TLabel *laBankingPaymentMethod;
        TLabel *laBankingBillingInfoTitle;
        TLabel *laBankingBillingInfoDesc;
        TPanel *paBankingBillingPaymentMethods;
        TRadioButton *rbBankingPaymentMethodCreditCard;
        TRadioButton *rbBankingPaymentMethodPayPal;
        TWSVGImage *imBankingPaymentMastercard;
        TWSVGImage *imBankingPaymentVisa;
        TWSVGImage *imBankingPaymentPayPal;
        TWSVGImage *imBankingPaymentAmEx;
        TWSVGImage *imBankingPaymentDiners;
        TWSVGImage *imBankingPaymentAsterisk;
        TBevel *blBankingPaymentSeparator;
        TPanel *paBankingPersonalInfo;
        TLabel *laBankingPersonalInfoTitle;
        TLabel *laBankingPersonalInfoDesc;
        TLabel *laBankingPersonalInfoFirstName;
        TPanel *paBankingPersonalInfoClientName;
        TPanel *paBankingPersonalInfoFirstName;
        TEdit *edBankingPersonalInfoFirstName;
        TPanel *paBankingPersonalInfoFirstNameTitle;
        TWSVGImage *imBankingPersonalInfoFirstName;
        TPanel *paBankingPersonalInfoLastName;
        TEdit *edBankingPersonalInfoLastName;
        TPanel *paBankingPersonalInfoLastNameTitla;
        TLabel *laBankingPersonalInfoLastName;
        TWSVGImage *imBankingPersonalInfoLastName;
        TPanel *paBankingPersonalInfoCreditCard;
        TPanel *paBankingPersonalInfoCreditCardInfo;
        TEdit *edBankingPersonalInfoCreditCard;
        TPanel *paBankingPersonalInfoCreditCardTitle;
        TLabel *laBankingPersonalInfoCreditCardTitle;
        TWSVGImage *imBankingPersonalInfoCreditCardTitleImage;
        TPanel *paBankingPersonalInfoCreditCardData;
        TPanel *paBankingPersonalInfoCreditCardSecurity;
        TEdit *edBankingPersonalInfoCreditCardSecurity;
        TPanel *paBankingPersonalInfoCreditCardSecurityTitle;
        TLabel *laBankingPersonalInfoCreditCardSecurity;
        TWSVGImage *imBankingPersonalInfoCreditCardSecurityTitle;
        TPanel *paBankingPersonalInfoCreditCardExpires;
        TPanel *paBankingPersonalInfoCreditCardExpiresTitle;
        TLabel *laBankingPersonalInfoCreditCardExpires;
        TWSVGImage *imBankingPersonalInfoCreditCardExpires;
        TPanel *paBankingPersonalInfoCreditCardSecurityInfo;
        TWSVGImage *imBankingPersonalInfoCreditCardSecurity;
        TPanel *paBankingPersonalInfoCreditCardExpiresInfo;
        TDateTimePicker *dpBankingPersonalInfoCreditCardExpiresInfoDay;
        TDateTimePicker *dpBankingPersonalInfoCreditCardExpiresInfoMonth;
        TDateTimePicker *dpBankingPersonalInfoCreditCardExpiresInfoYear;
        TPanel *paBankingPersonalInfoGender;
        TLabel *laBankingPersonalInfoGenderTitle;
        TRadioButton *rbBankingPersonalInfoGenderMale;
        TRadioButton *rbBankingPersonalInfoGenderFemale;
        TBevel *blBankingAboutSeparator;
        TWSVGImageButton *imBankingBuyNowButton;
        TPanel *paBankingAboutProduct;
        TLabel *laBankingAboutProductTitle;
        TLabel *laBankingAboutProductDesc;
        TPanel *paBankingAboutProductRight;
        TBevel *blBankingPersonalInfoSeparator;
        TPanel *paBankingBuy;
        TPanel *paBankingAboutProductLeft;
        TCheckBox *ckBankingAboutProductProfessional;
        TCheckBox *ckBankingAboutProductAsAGift;
        TCheckBox *ckBankingAboutProductByFriends;
        TCheckBox *ckBankingAboutProductOnTheInternet;
        TCheckBox *ckBankingAboutProductInAShop;
        TCheckBox *ckBankingAboutProductFromAdv;
        TCheckBox *ckBankingAboutProductOther;
        TCheckBox *ckBankingAboutProductPrivate;
        TWSVGCheckBoxStyle *csBankingStyle;
        TWSVGImageButton *ibBankingForm;
        TTabSheet *tsBrowser;
        TPanel *paExplorer;
        TListBox *lbDir;
        TPanel *paExplorerBrowserTop;
        TButton *btBrowse;
        TButton *btNext;
        TButton *btPrev;
        TButton *btSlideshow;
        TTrackBar *tbSlideshowTimer;
        TPanel *paViewer;
        TPanel *paViewerControls;
        TOpenDialog *odOpen;
        TColorDialog *cdBgColor;
        TTimer *tiSlideshow;
        TWSVGImageList *ilImages;
        TWSVGImage *imViewer;
        TWSVGImageButton *ibBrowserForm;
        TTabSheet *tsFreshBooks;
        TPanel *paFreshBooksHeader;
        TImage *imFreshBooksHeaderShadow;
        TShape *shFreshBooksHeaderBackground;
        TScrollBox *sbFreshBooks;
        TLabel *laFreshBooksHeaderYourCreditCard;
        TPanel *paFreshBooksHeaderYourCreditCard;
        TImage *imFreshBooksHeaderYourCreditCard;
        TPanel *paFreshBooksHeaderLine1;
        TEdit *edFreshBooksHeaderCreditCard;
        TEdit *edFreshBooksHeaderCreditCardSecurityCode;
        TImage *imFreshBooksHeaderCreditCardSecurityCode;
        TPanel *paFreshBooksHeaderLine1Captions;
        TLabel *laFreshBooksHeaderCreditCardCaption;
        TLabel *laFreshBooksHeaderSecurityCodeCaption;
        TPanel *paFreshBooksHeaderLine2;
        TEdit *edFreshBooksHeaderName;
        TDateTimePicker *dpFreshBooksHeaderExpDateYear;
        TDateTimePicker *dpFreshBooksHeaderExpDateMonth;
        TLabel *laFreshBooksHeaderSlash;
        TPanel *paFreshBooksHeaderLine2Captions;
        TLabel *laFreshBooksHeaderFullName;
        TLabel *laFreshBooksHeaderExpDate;
        TPanel *paFreshBooksHeaderLine3;
        TImage *imFreshBooksHeaderVisa;
        TImage *imFreshBooksHeaderMasterCard;
        TPanel *paFreshBookAddress;
        TPanel *paFreshBookAddressLine2;
        TEdit *edFreshBookAddress;
        TLabel *laFreshBookAddressCaption;
        TWSVGImage *imFreshBookAddressTitle;
        TPanel *paFreshBookAddressLine1;
        TPanel *paFreshBookAddressLine2Captions;
        TLabel *laFreshBooksStreetAddressCaption;
        TPanel *paFreshBookAddressLine3;
        TEdit *edFreshBookCity;
        TPanel *paFreshBookAddressLine3Captions;
        TLabel *laFreshBookCityCaption;
        TEdit *edFreshBooksCountry;
        TLabel *laFreshBooksCountryCaption;
        TPanel *paFreshBooksPaymentOptions;
        TPanel *paFreshBooksPaymentOptionsRight;
        TPanel *paFreshBooksPaymentOptionsHeader;
        TWSVGImage *imFreshBooksPaymentOptionsHeader;
        TLabel *laFreshBooksPaymentOptionsHeader;
        TPanel *paFreshBooksPaymentOptionsLeft;
        TCheckBox *ckFreshBooksPaymentOptionsForAFriend;
        TCheckBox *ckFreshBooksPaymentOptionsForMe;
        TCheckBox *ckFreshBooksPaymentOptionsOther;
        TCheckBox *ckFreshBooksPaymentOptionsGift;
        TPanel *paFreshBooksPayNow;
        TWSVGImageButton *imFreshBooksPayNow;
        TPanel *paFreshBooksPayNowLine1;
        TPanel *paFreshBooksPayNowLine1Captions;
        TLabel *laFreshBooksPayNowCaption;
        TImage *imFreshBooksPayNowCaption;
        TLabel *laFreshBooksPayNowLink;
        TTabSheet *tsComponentGallery;
        TPanel *paGalleryLine1;
        TPanel *paGalleryLine1Captions;
        TLabel *laGalleryTImage;
        TPanel *paGalleryLine1Components;
        TImage *imGalleryTImage;
        TWSVGImage *imGalleryTWSVGImage;
        TPanel *paGalleryTImage;
        TPanel *paGalleryTWSVGImage;
        TLabel *laGalleryTWSVGImage;
        TPanel *paGalleryTWSVGImageButton;
        TLabel *laGalleryTWSVGImageButton;
        TPanel *paGalleryLine1Header;
        TLabel *laGalleryLine1Title;
        TPanel *paGalleryLine1Desc;
        TPanel *paGalleryTImageDesc;
        TLabel *laGalleryTImageDesc;
        TPanel *paGalleryTWSVGImageDesc;
        TLabel *laGalleryTWSVGImageDesc;
        TPanel *paGalleryTWSVGImageButtonDesc;
        TLabel *laGalleryTWSVGImageButtonDesc;
        TPanel *paGalleryLine3;
        TPanel *paGalleryLine3Captions;
        TPanel *paGalleryStyledCheckBox;
        TLabel *laGalleryStyledCheckBox;
        TPanel *paGalleryLine3Components;
        TPanel *paGalleryLine3Header;
        TLabel *laGalleryLine3Title;
        TPanel *paGalleryLine3ComponentsStyledCB;
        TCheckBox *ckGalleryStyledCBDisabledGrayed;
        TCheckBox *ckGalleryStyledCBDisabledChecked;
        TCheckBox *ckGalleryStyledCBDisabled;
        TCheckBox *ckGalleryStyledCBGrayed;
        TCheckBox *ckGalleryStyledCBChecked;
        TCheckBox *ckGalleryStyledCBDefault;
        TPanel *paGalleryLine2ComponentsUnstyledCB;
        TCheckBox *ckGalleryUnstyledCBDisabledGrayed;
        TCheckBox *ckGalleryUnstyledCBDisabledChecked;
        TCheckBox *ckGalleryUnstyledCBDisabled;
        TCheckBox *ckGalleryUnstyledCBGrayed;
        TCheckBox *ckGalleryUnstyledCBChecked;
        TCheckBox *ckGalleryUnstyledCBDefault;
        TPanel *paGalleryNormalCheckBox;
        TLabel *laGalleryNormalCheckBox;
        TPanel *paGalleryLine3Desc;
        TPanel *paGalleryCheckBoxDesc;
        TLabel *laGalleryCheckBoxDesc;
        TPanel *paGalleryStyledRB;
        TRadioButton *rbGalleryStyledRBDefault;
        TRadioButton *rbGalleryStyledRBDisabledChecked;
        TRadioButton *rbGalleryStyledRBDisabled;
        TRadioButton *rbGalleryStyledRBChecked;
        TPanel *paGalleryStyledRBDisabled;
        TBevel *blGalleryLine3ComponentsSeparator;
        TPanel *paGalleryUnstyledRB;
        TRadioButton *rbGalleryUnstyledRBDefault;
        TRadioButton *rbGalleryUnstyledRBChecked;
        TPanel *paGalleryUnstyledRBDisabled;
        TRadioButton *rbGalleryUnstyledRBDisabled;
        TRadioButton *rbGalleryUnstyledRBDisabledChecked;
        TPanel *paGalleryStyledRadioButton;
        TLabel *laGalleryStyledRadioButton;
        TPanel *paGalleryNormalRadioButton;
        TLabel *laGalleryNormalRadioButton;
        TWSVGImageButton *imGalleryTWSVGImageButton;
        TPanel *paGalleryLine1Resizeable;
        TPanel *paGalleryLine1ResizeableCaptions;
        TPanel *paGalleryLine1ResizeableComponentsCaptions;
        TLabel *laGalleryResizeableDesc;
        TWSVGImageButton *ibFreshBooksForm;
        TWSVGImageButton *ibGalleryForm;
        TPanel *paGalleryLine2;
        TPanel *paGalleryLine2ComponentsTitle;
        TPanel *paGalleryTButton;
        TLabel *laGalleryTButton;
        TPanel *paGalleryTBitBtn;
        TLabel *laGalleryTBitBtn;
        TPanel *paGalleryTSpeedBtn;
        TLabel *laGalleryTSpeedBtn;
        TPanel *paGalleryLine2Components;
        TPanel *paGalleryLine2Header;
        TLabel *laGalleryLine2Title;
        TPanel *paGalleryLine2ComponentsDesc;
        TPanel *paGalleryTButtonDesc;
        TLabel *laGalleryTButtonDesc;
        TButton *btGalleryTButton;
        TBitBtn *btGalleryTBitBtn;
        TActionList *alActions;
        TAction *acDemoTBitBtn;
        TSpeedButton *btGalleryTSpeedBtn;
        TAction *acDemoTSpeedBtn;
        TPanel *paGalleryTBitBtnDesc;
        TLabel *laGalleryTBitBtnDesc;
        TPanel *paGalleryTSpeedBtnDesc;
        TLabel *laGalleryTSpeedBtnDesc;
        TPanel *paGalleryTPopupMenu;
        TLabel *laGalleryTPopupMenu;
        TButton *btGalleryPopupMenuBtn;
        TPopupMenu *pmPopup;
        TMenuItem *miGreyHouse;
        TMenuItem *miDarkGreenHouse;
        TMenuItem *miLightGreenHouse;
        TPanel *paGalleryTPopupMenuDesc;
        TLabel *laGalleryTPopupMenuDesc;
        TTimer *tiResize;
        TImage *imGalleryLine1ResizeableImage;
        TScrollBox *sbGallery;
        TPanel *paGalleryLine1ResizeableLeft;
        TPanel *paGalleryLine1ResizeableRight;
        TTrackBar *tbGalleryLine1ResizeableImage;
        TPanel *paGalleryLine1ResizeableImageControls;
        TPanel *paGalleryLine1ResizeableImageView;
        TWSVGImage *imGalleryLine1StepByStepImage;
        TTrackBar *tbGalleryLine1StepByStepImage;
        TLabel *laGalleryStepByStepDesc;
        TSplitter *spMainVert;
        TPopupMenu *pmBrowserSettings;
        TAction *acAnimate;
        TAction *acFitToView;
        TMenuItem *miAnimate;
        TMenuItem *miFitToView;
        TMenuItem *miChangeBgColor;
        TMenuItem *miBrowserSettingsSep1;
        TMenuItem *miBrowserSettingsSep2;
        TPanel *paBrowserZoom;
        TLabel *laBrowserZoom;
        TEdit *edBrowserZoom;
        TUpDown *udBrowserZoom;
        TPanel *paViewerControlsTop;
        TCheckBox *ckAnimate;
        TPanel *paViewerControlsBottom;
        TCheckBox *ckFitToView;
        TPanel *paBrowserAnimSpeed;
        TLabel *laBrowserAnimSpeed;
        TEdit *edBrowserAnimSpeed;
        TUpDown *udBrowserAnimSpeed;
        TButton *btChangeBgColor;
        TPanel *paExplorerBrowser;
        TPanel *paExplorerBrowserBottom;
        TApplicationEvents *aeEvents;

        void __fastcall FormResize(TObject* pSender);
        void __fastcall pcMainChange(TObject* pSender);
        void __fastcall ibGalleryFormClick(TObject* pSender);
        void __fastcall ibBrowserFormClick(TObject* pSender);
        void __fastcall ibBankingFormClick(TObject* pSender);
        void __fastcall ibFreshBooksFormClick(TObject* pSender);
        void __fastcall lbDirClick(TObject* pSender);
        void __fastcall btGalleryPopupMenuBtnClick(TObject* pSender);
        void __fastcall btPrevClick(TObject* pSender);
        void __fastcall btNextClick(TObject* pSender);
        void __fastcall tbGalleryLine1ResizeableImageChange(TObject* pSender);
        void __fastcall tbGalleryLine1StepByStepImageChange(TObject* pSender);
        void __fastcall btSlideshowClick(TObject* pSender);
        void __fastcall btBrowseClick(TObject* pSender);
        void __fastcall btChangeBgColorClick(TObject* pSender);
        void __fastcall tbSlideshowTimerChange(TObject* pSender);
        void __fastcall tiSlideshowTimer(TObject* pSender);
        void __fastcall tiResizeTimer(TObject* pSender);
        void __fastcall edBrowserAnimSpeedChange(TObject* pSender);
        void __fastcall edBrowserZoomChange(TObject* pSender);
        void __fastcall spMainVertMoved(TObject* pSender);
        bool __fastcall imGalleryLine1StepByStepImageAnimate(TObject* pSender,
                TWSVGAnimationDescriptor* pAnimDesc, Pointer pCustomData);
        void __fastcall imBankingBuyNowButtonClick(TObject* pSender);
        void __fastcall imFreshBooksPayNowClick(TObject* pSender);
        void __fastcall acDemoTBitBtnExecute(TObject* pSender);
        void __fastcall acDemoTSpeedBtnExecute(TObject* pSender);
        void __fastcall acAnimateExecute(TObject* pSender);
        void __fastcall acFitToViewExecute(TObject* pSender);
        void __fastcall aeEventsMessage(tagMSG& msg, bool& handled);

    public:
        /**
        * Constructor
        *@param pOwner - form owner
        */
        __fastcall TMainForm(TComponent* pOwner);

        virtual __fastcall ~TMainForm();

    protected:
        /**
        * Called after DPI changed because app was moved on another monitor
        *@param pSender - Event sender
        *@param oldDPI - Previous DPI value
        *@param newDPI - New DPI value
        */
        virtual void __fastcall OnAfterMonitorDpiChangedHandler(TObject* pSender, int oldDPI, int newDPI);

        /**
        * Resizeable image trackbar hooked Windows procedure
        *@param message - Windows message
        */
        void __fastcall ResizeableTrackbarWndProc(TMessage& message);

        /**
        * Step-by-step animated image trackbar hooked Windows procedure
        *@param message - Windows message
        */
        void __fastcall StepByStepTrackbarWndProc(TMessage& message);

    private:
        UnicodeString m_CurrentDir;
        int           m_CurrentSelection;
        int           m_ResizeDirection;
        TWndMethod    m_ResizeableTrackbarWndProc_Backup;
        TWndMethod    m_StepByStepTrackbarWndProc_Backup;

        /**
        * Open the browser demo page
        */
        void OpenBrowserPage();

        /**
        * Get the default image directory
        *@returns default image directory
        */
        UnicodeString Browser_GetDefaultImgDir() const;

        /**
        * Clear the browser view
        */
        void Browser_ClearView();

        /**
        * Open a SVG file and show it on the view
        *@param fileName - SVG file name to open
        */
        void Browser_OpenSVG(const UnicodeString& fileName);

        /**
        * Called when browser content should be resized
        */
        void Browser_OnResize();

        /**
        * Called when animation is running
        *@param pSender - event sender
        *@param pAnimDesc - animation description
        *@param pCustomData - custom data
        *@returns true if animation can continue, otherwise false
        */
        bool __fastcall Browser_OnAnimate(TObject* pSender, TWSVGAnimationDescriptor* pAnimDesc,
                void* pCustomData);

        /**
        * Make a control with a rounded background
        *@param pControl - control to make rounded
        */
        void MakeRounded(TWinControl* pControl);
};
extern PACKAGE TMainForm* MainForm;
#endif
