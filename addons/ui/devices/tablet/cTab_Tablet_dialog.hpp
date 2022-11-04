#include "script_component.hpp"

// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.


//--- cTab
#define CUSTOM_GRID_HAbs    (safezoneH * 1.2)
#define CUSTOM_GRID_WAbs    (CUSTOM_GRID_HAbs * 3/4)
// since the actual map position is not in the center, we correct for it by shifting it right
// (BACKGROUND_PIXEL_W - cTab_GUI_tablet_MAP_W) / 2 - cTab_GUI_tablet_MAP_X
// is 96.5, that is the pixel amount we have to shift by, devided by BACKGROUND_PIXEL_W
// to make it a ratio that we can apply to CUSTOM_GRID_WAbs in order to get a screen value to shift by
#define CUSTOM_GRID_X    (safezoneX + (safezoneW - CUSTOM_GRID_WAbs) / 2 + (CUSTOM_GRID_WAbs * 96.5 / 2048))
#define CUSTOM_GRID_Y    (safezoneY + (safezoneH - CUSTOM_GRID_HAbs) / 2)

#include "cTab_Tablet_controls.hpp"

#define MENU_sizeEx pxToScreen_H(cTab_GUI_tablet_OSD_TEXT_STD_SIZE)
#include "..\shared\cTab_defines.hpp"
#include "..\shared\cTab_markerMenu_macros.hpp"

class GVARMAIN(Tablet_dlg){
    idd = 1775154;
    movingEnable = true;
    onLoad = QUOTE(_this call FUNC(onIfOpen));
    onUnload = QUOTE([] call FUNC(onIfClose));
    onKeyDown = QUOTE(_this call FUNC(onIfKeyDown));
    objects[] = {};
    class controlsBackground {
        class windowsBG: cTab_RscPicture {
            idc = IDC_CTAB_WIN_BACK;
            text = "#(argb,8,8,3)color(0.2,0.431,0.647,1)";
            x = pxToScreen_X(cTab_GUI_tablet_MAP_X);
            y = pxToScreen_Y(cTab_GUI_tablet_MAP_Y);
            w = pxToScreen_W(cTab_GUI_tablet_MAP_W);
            h = pxToScreen_H(cTab_GUI_tablet_MAP_H);
        };
        class windowsBar: cTab_RscPicture {
            idc = IDC_CTAB_WIN_TASKBAR;
            text = QPATHTOEF(data,img\Desktop_bar.jpg);
            x = pxToScreen_X(cTab_GUI_tablet_TASKBAR_X);
            y = pxToScreen_Y(cTab_GUI_tablet_TASKBAR_Y);
            w = pxToScreen_W(cTab_GUI_tablet_TASKBAR_W);
            h = pxToScreen_H(cTab_GUI_tablet_TASKBAR_H);
        };
        class MiniMapBG: cTab_Tablet_window_back_BL {
            idc = IDC_CTAB_MINIMAPBG;
        };
        class cTabUavMap: cTab_Tablet_RscMapControl {
            idc = IDC_CTAB_CTABUAVMAP;
            x = pxToScreen_X(cTab_GUI_tablet_WINDOW_CONTENT_L_X);
            y = pxToScreen_Y(cTab_GUI_tablet_WINDOW_CONTENT_B_Y);
            w = pxToScreen_W(cTab_GUI_tablet_WINDOW_CONTENT_W);
            h = pxToScreen_H(cTab_GUI_tablet_WINDOW_CONTENT_H);
            onDraw = QUOTE(nop = _this call FUNC(drawUAV););
            onMouseButtonDblClick = "";
        };
        class cTabHcamMap: cTabUavMap {
            idc = IDC_CTAB_CTABHCAMMAP;
            onDraw = QUOTE(nop = _this call FUNC(drawHCam););
        };
        class screen: cTab_Tablet_RscMapControl {
            idc = IDC_CTAB_SCREEN;
            onDraw = QUOTE(_this call FUNC(drawMapControlTablet););
            onMouseButtonDblClick = QUOTE(_ok = [ARR_2(IDC_CTAB_MARKER_MENU_MAIN,_this)] call FUNC(loadMarkerMenu););
            onMouseMoving = QUOTE(GVAR(cursorOnMap) = _this select 3;GVAR(mapCursorPos) = _this select 0 ctrlMapScreenToWorld [ARR_2(_this select 1,_this select 2)];);
        };
        class screenTopo: screen {
            idc = IDC_CTAB_SCREEN_TOPO;
            maxSatelliteAlpha = 0;
        };
    };
     class controls {
        class header: cTab_tablet_header {};
        class battery: cTab_Tablet_OSD_battery {};
        class time: cTab_Tablet_OSD_time {};
        class signalStrength: cTab_Tablet_OSD_signalStrength {};
        class satellite: cTab_Tablet_OSD_satellite {};
        class dirDegree: cTab_Tablet_OSD_dirDegree {};
        class grid: cTab_Tablet_OSD_grid {};
        class dirOctant: cTab_Tablet_OSD_dirOctant {};
        class hookGrid: cTab_Tablet_OSD_hookGrid {};
        class hookElevation: cTab_Tablet_OSD_hookElevation {};
        class hookDst: cTab_Tablet_OSD_hookDst {};
        class hookDir: cTab_Tablet_OSD_hookDir {};
         // ---------- DESKTOP -----------
         class Desktop: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_DESKTOP;
            x = pxToScreen_X(cTab_GUI_tablet_SCREEN_CONTENT_X);
            y = pxToScreen_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y);
            w = pxToScreen_W(cTab_GUI_tablet_SCREEN_CONTENT_W);
            h = pxToScreen_H(cTab_GUI_tablet_SCREEN_CONTENT_H);
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class actBFTtxt: cTab_ActiveText {
                    style = ST_PICTURE;
                    idc = IDC_CTAB_ACTBFTTXT;
                    text = QPATHTOEF(data,img\cTab_BFT_ico.paa) ;//"Blue Force Tracker"; //--- ToDo: Localize;
                    x = pxToGroup_X(cTab_GUI_tablet_SCREEN_CONTENT_X + cTab_GUI_tablet_DESKTOP_ICON_OFFSET_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y + cTab_GUI_tablet_DESKTOP_ICON_OFFSET_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_DESKTOP_ICON_W);
                    h = pxToScreen_H(cTab_GUI_tablet_DESKTOP_ICON_H);
                    action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_BFT')]])] call FUNC(setSettings));
                    toolTip = "FBCB2 - Blue Force Tracker";
                };
                class actUAVtxt: actBFTtxt {
                    idc = IDC_CTAB_ACTUAVTXT;
                    text = QPATHTOEF(data,img\cTab_UAV_ico.paa) ;//"UAV Intelligence"; //--- ToDo: Localize;
                    y = pxToGroup_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y + cTab_GUI_tablet_DESKTOP_ICON_OFFSET_Y * 2 + cTab_GUI_tablet_DESKTOP_ICON_H);
                    action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_CAM_UAV')]])] call FUNC(setSettings));
                    toolTip = "UAV Video Feeds";
                };
                class actVIDtxt: actBFTtxt {
                    idc = IDC_CTAB_ACTVIDTXT;
                    text = QPATHTOEF(data,img\cTab_HMC_ico.paa) ;//"Live Video Feeds"; //--- ToDo: Localize;
                    y = pxToGroup_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y + cTab_GUI_tablet_DESKTOP_ICON_OFFSET_Y * 3 + cTab_GUI_tablet_DESKTOP_ICON_H * 2);
                    action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_CAM_HELMET')]])] call FUNC(setSettings));
                    toolTip = "Live Helmet Cam Video Feeds";
                };
                class actMSGtxt: actBFTtxt {
                    idc = IDC_CTAB_ACTMSGTXT;
                    text = QPATHTOEF(data,img\Mail_Main_Icon_ico.paa) ;
                    y = pxToGroup_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y + cTab_GUI_tablet_DESKTOP_ICON_OFFSET_Y * 4 + cTab_GUI_tablet_DESKTOP_ICON_H * 3);
                    action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_MESSAGES')]])] call FUNC(setSettings));
                    toolTip = "Text Messaging System";
                };
            };
         };
         // ---------- UAV -----------
         class UAV: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_UAV;
            x = pxToScreen_X(cTab_GUI_tablet_SCREEN_CONTENT_X);
            y = pxToScreen_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y);
            w = pxToScreen_W(cTab_GUI_tablet_SCREEN_CONTENT_W);
            h = pxToScreen_H(cTab_GUI_tablet_SCREEN_CONTENT_H);
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class UAVListBG: cTab_Tablet_window_back_TL {
                    idc = 9;
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_BACK_L_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_BACK_T_Y);
                };
                class UAVVidBG1: cTab_Tablet_window_back_TR {
                    idc = 10;
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_BACK_R_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_BACK_T_Y);
                };
                class UAVVidBG2: cTab_Tablet_window_back_BR {
                    idc = 11;
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_BACK_R_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_BACK_B_Y);
                };
                class GVARMAIN(UAVList): cTab_RscListbox_Tablet {
                    idc = IDC_CTAB_CTABUAVList;
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_CONTENT_L_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_CONTENT_T_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_WINDOW_CONTENT_W);
                    h = pxToScreen_H(cTab_GUI_tablet_WINDOW_CONTENT_H);
                    onLBSelChanged = QUOTE(if (!GVAR(openStart) && ((_this select 1) != -1)) then {ARR_2(['GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_CAM_UAV',(_this select 0) lbData (_this select 1))]])] call FUNC(setSettings);};);
                };
                class cTabUAVdisplay: cTab_RscPicture {
                    idc = IDC_CTAB_CTABUAVDISPLAY;
                    text = "#(argb,512,512,1)r2t(rendertarget8,1.1896551724)";
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_CONTENT_R_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_CONTENT_T_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_WINDOW_CONTENT_W);
                    h = pxToScreen_H(cTab_GUI_tablet_WINDOW_CONTENT_H);
                };
                class cTabUAV2nddisplay: cTab_RscPicture {
                    idc = IDC_CTAB_CTABUAV2NDDISPLAY;
                    text = "#(argb,512,512,1)r2t(rendertarget9,1.1896551724)";
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_CONTENT_R_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_CONTENT_B_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_WINDOW_CONTENT_W);
                    h = pxToScreen_H(cTab_GUI_tablet_WINDOW_CONTENT_H);
                };
            };
         };
         // ---------- HELMET CAM -----------
         class HCAM: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_HCAM;
            x = pxToScreen_X(cTab_GUI_tablet_SCREEN_CONTENT_X);
            y = pxToScreen_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y);
            w = pxToScreen_W(cTab_GUI_tablet_SCREEN_CONTENT_W);
            h = pxToScreen_H(cTab_GUI_tablet_SCREEN_CONTENT_H);
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class HcamListBG: cTab_Tablet_window_back_TL {
                    idc = 12;
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_BACK_L_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_BACK_T_Y);
                };
                class HcamVidBG: cTab_Tablet_window_back_TR {
                    idc = 14;
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_BACK_R_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_BACK_T_Y);
                };
                class GVARMAIN(hCamList): cTab_RscListbox_Tablet {
                    idc = IDC_CTAB_CTABHCAMLIST;
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_CONTENT_L_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_CONTENT_T_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_WINDOW_CONTENT_W);
                    h = pxToScreen_H(cTab_GUI_tablet_WINDOW_CONTENT_H);
                    onLBSelChanged = QUOTE(if (!GVAR(openStart) && ((_this select 1) != -1)) then {[ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_CAM_HELMET',(_this select 0) lbData (_this select 1))]])] call FUNC(setSettings);};);
                };
                class cTabHcamDisplay: cTab_RscPicture {
                    idc = IDC_CTAB_CTABHCAMDISPLAY;
                    text = "#(argb,512,512,1)r2t(rendertarget12,1.1896551724)";
                    x = pxToGroup_X(cTab_GUI_tablet_WINDOW_CONTENT_R_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_WINDOW_CONTENT_T_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_WINDOW_CONTENT_W);
                    h = pxToScreen_H(cTab_GUI_tablet_WINDOW_CONTENT_H);
                };
            };
         };
        // ---------- MESSAGING -----------
         class MESSAGE: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_MESSAGE;
            x = pxToScreen_X(cTab_GUI_tablet_SCREEN_CONTENT_X);
            y = pxToScreen_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y);
            w = pxToScreen_W(cTab_GUI_tablet_SCREEN_CONTENT_W);
            h = pxToScreen_H(cTab_GUI_tablet_SCREEN_CONTENT_H);
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class msgframe: cTab_RscFrame {
                    idc = 15;
                    text = "Read Message"; //--- ToDo: Localize;
                    x = pxToGroup_X(cTab_GUI_tablet_MESSAGE_MESSAGETEXT_FRAME_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_MESSAGE_MESSAGETEXT_FRAME_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_MESSAGE_MESSAGETEXT_FRAME_W);
                    h = pxToScreen_H(cTab_GUI_tablet_MESSAGE_MESSAGETEXT_FRAME_H);
                };
                class msgListbox: cTab_RscListbox_Tablet {
                    idc = IDC_CTAB_MSG_LIST;
                    style = LB_MULTI;
                    x = pxToGroup_X(cTab_GUI_tablet_MESSAGE_MESSAGELIST_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_MESSAGE_MESSAGELIST_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_MESSAGE_MESSAGELIST_W);
                    h = pxToScreen_H(cTab_GUI_tablet_MESSAGE_MESSAGELIST_H);
                    onLBSelChanged = QUOTE(_this call FUNC(messagingGetMessage););
                };
                class msgTxt: cTab_RscEdit_Tablet {
                    idc = IDC_CTAB_MSG_CONTENT;
                    htmlControl = true;
                    style = ST_MULTI;
                    lineSpacing = 0.2;
                    text = "No Message Selected"; //--- ToDo: Localize;
                    x = pxToGroup_X(cTab_GUI_tablet_MESSAGE_MESSAGETEXT_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_MESSAGE_MESSAGETEXT_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_MESSAGE_MESSAGETEXT_W);
                    h = pxToScreen_H(cTab_GUI_tablet_MESSAGE_MESSAGETEXT_H);
                    canModify = 0;
                };
                class composeFrame: cTab_RscFrame {
                    idc = 16;
                    text = "Compose Message"; //--- ToDo: Localize;
                    x = pxToGroup_X(cTab_GUI_tablet_MESSAGE_COMPOSE_FRAME_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_MESSAGE_COMPOSE_FRAME_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_MESSAGE_COMPOSE_FRAME_W);
                    h = pxToScreen_H(cTab_GUI_tablet_MESSAGE_COMPOSE_FRAME_H);
                };
                class playerlistbox: cTab_RscListbox_Tablet {
                    idc = IDC_CTAB_MSG_RECIPIENTS;
                    style = LB_MULTI;
                    x = pxToGroup_X(cTab_GUI_tablet_MESSAGE_PLAYERLIST_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_MESSAGE_PLAYERLIST_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_MESSAGE_PLAYERLIST_W);
                    h = pxToScreen_H(cTab_GUI_tablet_MESSAGE_PLAYERLIST_H);
                };
                class deletebtn: cTab_RscButton_Tablet {
                    idc = IDC_CTAB_MSG_BTNDELETE;
                    text = "Delete"; //--- ToDo: Localize;
                    tooltip = "Delete Selected Message(s)";
                    x = pxToGroup_X(cTab_GUI_tablet_MESSAGE_BUTTON_DELETE_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_MESSAGE_BUTTON_DELETE_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_MESSAGE_BUTTON_W);
                    h = pxToScreen_H(cTab_GUI_tablet_MESSAGE_BUTTON_H);
                    action = QUOTE(['GVARMAIN(Tablet_dlg)'] call FUNC(messagingDeleteSelectedMessage););
                };
                class sendbtn: cTab_RscButton_Tablet {
                    idc = IDC_CTAB_MSG_BTNSEND;
                    text = "Send"; //--- ToDo: Localize;
                    x = pxToGroup_X(cTab_GUI_tablet_MESSAGE_BUTTON_SEND_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_MESSAGE_BUTTON_SEND_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_MESSAGE_BUTTON_W);
                    h = pxToScreen_H(cTab_GUI_tablet_MESSAGE_BUTTON_H);
                    action = QUOTE(call FUNC(messagingSendMessage););
                };
                class edittxtbox: cTab_RscEdit_Tablet {
                    idc = IDC_CTAB_MSG_COMPOSE;
                    htmlControl = true;
                    style = ST_MULTI;
                    lineSpacing = 0.2;
                    text = ""; //--- ToDo: Localize;
                    x = pxToGroup_X(cTab_GUI_tablet_MESSAGE_COMPOSE_TEXT_X);
                    y = pxToGroup_Y(cTab_GUI_tablet_MESSAGE_COMPOSE_TEXT_Y);
                    w = pxToScreen_W(cTab_GUI_tablet_MESSAGE_COMPOSE_TEXT_W);
                    h = pxToScreen_H(cTab_GUI_tablet_MESSAGE_COMPOSE_TEXT_H);
                };
            };
        };
        // ---------- FULLSCREEN HCAM -----------
        class cTabHcamFull: cTab_RscPicture {
            idc = IDC_CTAB_HCAM_FULL;
            text = "#(argb,512,512,1)r2t(rendertarget13,1.3096153846)";
            x = pxToScreen_X(cTab_GUI_tablet_SCREEN_CONTENT_X);
            y = pxToScreen_Y(cTab_GUI_tablet_SCREEN_CONTENT_Y);
            w = pxToScreen_W(cTab_GUI_tablet_SCREEN_CONTENT_W);
            h = pxToScreen_H(cTab_GUI_tablet_SCREEN_CONTENT_H);
         };

        /*
            ### Overlays ###
        */
        // ---------- NOTIFICATION ------------
        class notification: cTab_Tablet_notification {};
        // ---------- LOADING ------------
        class loadingtxt: cTab_Tablet_loadingtxt {};
        // ---------- BRIGHTNESS ------------
        class brightness: cTab_Tablet_brightness {};
        // ---------- USER MARKERS ------------
        //CC: What the shit?
        #define cTab_IS_TABLET
            #include "..\shared\cTab_markerMenu_controls.hpp"
        #undef cTab_IS_TABLET
        // ---------- BACKGROUND ------------
        class background: cTab_Tablet_background {};
        // ---------- MOVING HANDLEs ------------
        class movingHandle_T: cTab_Tablet_movingHandle_T {};
        class movingHandle_B: cTab_Tablet_movingHandle_B {};
        class movingHandle_L: cTab_Tablet_movingHandle_L {};
        class movingHandle_R: cTab_Tablet_movingHandle_R {};

        /*
            ### PHYSICAL BUTTONS ###
        */
        class btnF1: cTab_Tablet_btnF1 {
            idc = IDC_CTAB_BTNF1;
            tooltip = "Blue Force Tracker - Quick Key";
            action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_BFT')]])] call FUNC(setSettings));
        };
        class btnF2: cTab_Tablet_btnF2 {
            idc = IDC_CTAB_BTNF2;
            tooltip = "UAV Intel Live Feed - Quick Key";
            action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_CAM_UAV')]])] call FUNC(setSettings));
        };
        class btnF3: cTab_Tablet_btnF3 {
            idc = IDC_CTAB_BTNF3;
            tooltip = "Helmet Cam Live Feed - Quick Key";
            action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_CAM_HELMET')]])] call FUNC(setSettings));
        };
        class btnF4: cTab_Tablet_btnF4 {
            idc = IDC_CTAB_BTNF4;
            tooltip = "Text Message Application - Quick Key";
            action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_MESSAGES')]])] call FUNC(setSettings));
        };
        class btnF5: cTab_Tablet_btnF5 {
            idc = IDC_CTAB_BTNF5;
            tooltip = "Toggle Map Tools (F5)";
            action = QUOTE(['GVARMAIN(Tablet_dlg)'] call FUNC(toggleMapTools));
        };
        class btnF6: cTab_Tablet_btnF6 {
            idc = IDC_CTAB_BTNF6;
            tooltip = "Toggle Map Textures (F6)";
            action = QUOTE(['GVARMAIN(Tablet_dlg)'] call FUNC(caseButtonsMapTypeToggle););
        };
        class btnF7: cTab_Tablet_btnTrackpad {
            idc = 17;
            action = QUOTE(['GVARMAIN(Tablet_dlg)'] call FUNC(caseButtonsCenterMapOnPlayerPosition));
            tooltip = "Center Map On Current Position (F7)";
        };
        class btnMain: cTab_Tablet_btnHome {
            idc = IDC_CTAB_BTNMAIN;
            tooltip = "Main Menu";
            action = QUOTE([ARR_2('GVARMAIN(Tablet_dlg)',[[ARR_2('SETTING_MODE','DESKTOP')]])] call FUNC(setSettings));
        };
        class btnFN: cTab_Tablet_btnFn {
            idc = IDC_CTAB_BTNFN;
            action = QUOTE(['GVARMAIN(Tablet_dlg)'] call FUNC(caseButtonsIconTextToggle););
            tooltip = "Toggle Text on/off";
        };
        class btnOFF: cTab_Tablet_btnPower {
            idc = IDC_CTAB_BTNOFF;
            action = QUOTE(closeDialog 0;);
            tooltip = "Close Interface";
        };
        class btnUP: cTab_Tablet_btnBrtUp {
            idc = IDC_CTAB_BTNUP;
            action = QUOTE(1 call FUNC(caseButtonsAdjustTextSize););
            tooltip = "Increase Font";
        };
        class btnDWN: cTab_Tablet_btnBrtDn {
            idc = IDC_CTAB_BTNDWN;
            action = QUOTE(-1 call FUNC(caseButtonsAdjustTextSize););
            tooltip = "Decrease Font";
        };
        class btnACT: cTab_Tablet_btnMouse {
            idc = IDC_CTAB_BTNACT;
            action = QUOTE(_null = [] call FUNC(caseButtonsOnACTButton););
            tooltip = "";
        };
     };
};
