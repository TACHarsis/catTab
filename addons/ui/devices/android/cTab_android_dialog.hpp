#include "script_component.hpp"

// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

#define CUSTOM_GRID_WAbs    (safezoneW * 0.8)
#define CUSTOM_GRID_HAbs    (CUSTOM_GRID_WAbs * 4/3)
#define CUSTOM_GRID_X    (safezoneX + (safezoneW - CUSTOM_GRID_WAbs) / 2)
#define CUSTOM_GRID_Y    (safezoneY + (safezoneH - CUSTOM_GRID_HAbs) / 2)

#define cTab_android_DLGtoDSP_fctr (0.86 / CUSTOM_GRID_HAbs)

#include "cTab_android_controls.hpp"
#include "..\shared\cTab_defines.hpp"

#define MENU_sizeEx ANDROID_pixel2Screen_H(27)
#include "..\shared\cTab_markerMenu_macros.hpp"

class GVARMAIN(Android_dlg) {
    idd = 177382;
    movingEnable = true;
    onLoad = QUOTE(_this call FUNC(onIfOpen));
    onUnload = QUOTE([] call FUNC(onIfClose));
    onKeyDown = QUOTE(_this call FUNC(onIfKeyDown));
    objects[] = {};
    class controlsBackground {
        class windowsBG: cTab_android_windowsBG {
            onLoad = QUOTE([ARR_2(_this,[ARR_4(GVAR(androidDesktopBackgroundMode),GVAR(androidDesktopBackgroundPreset),GVAR(androidDesktopColor),GVAR(androidDesktopCustomImageName))])] call FUNC(setDeviceBackground););
        };
        class screen: cTab_android_RscMapControl {
            onDraw = QUOTE(nop = [ARR_2(QQGVARMAIN(Android_dlg),_this)] call FUNC(drawMapControl););
            onMouseButtonDblClick = QUOTE(_this call FUNC(loadMarkerMenu););
            onMouseMoving = QUOTE(GVAR(cursorOnMap) = _this select 3;GVAR(mapCursorPos) = _this select 0 ctrlMapScreenToWorld [ARR_2(_this select 1,_this select 2)];);
        };
        class screenTopo: screen {
            idc = IDC_CTAB_SCREEN_TOPO;
            maxSatelliteAlpha = 0;
        };
    };

    class controls {
        /*
            ### OSD GUI controls ###
        */
        class header: cTab_android_header {};
        class battery: cTab_android_on_screen_battery {};
        class time: cTab_android_on_screen_time {};
        class signalStrength: cTab_android_on_screen_signalStrength {};
        class satellite: cTab_android_on_screen_satellite {};
        class dirDegree: cTab_android_on_screen_dirDegree {};
        class grid: cTab_android_on_screen_grid {};
        class dirOctant: cTab_android_on_screen_dirOctant {};
        class hookGrid: cTab_android_on_screen_hookGrid {};
        class hookElevation: cTab_android_on_screen_hookElevation {};
        class hookDst: cTab_android_on_screen_hookDst {};
        class hookDir: cTab_android_on_screen_hookDir {};

        // ---------- MAIN MENU -----------
        class menuContainer: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_MENU;
            x = ANDROID_pixel2Screen_X(OSD_menu_px_X);
            y = ANDROID_pixel2Screen_Y(OSD_menu_px_Y);
            w = ANDROID_pixel2Screen_W(OSD_menu_px_W);
            h = ANDROID_pixel2Screen_H(OSD_menu_px_H);
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class menuBackground: cTab_IGUIBack {
                    idc = 9;
                    x = 0;
                    y = 0;
                    w = ANDROID_pixel2Screen_W(OSD_menu_px_W);
                    h = ANDROID_pixel2Screen_H(OSD_menu_px_H);
                };
                class btnTextonoff: cTab_RscButton {
                    idc = 9;
                    text = "Text On/Off"; //--- ToDo: Localize;
                    sizeEx = ANDROID_pixel2Screen_H(OSD_elementBase_textSize_px);
                    x = ANDROID_pixel2Menu_X(OSD_menuElement_px_X);
                    y = ANDROID_pixel2Menu_Y(OSD_menuElement_px_Y(1));
                    w = ANDROID_pixel2Screen_W(OSD_menuElement_px_W);
                    h = ANDROID_pixel2Screen_H(OSD_menuElement_px_H);
                    tooltip = "Toggle Text on/off"; //--- ToDo: Localize;
                    action = QUOTE(['GVARMAIN(Android_dlg)'] call FUNC(caseButtonsIconTextToggle););
                };
                class btnIcnSizeup: btnTextonoff {
                    idc = 10;
                    text = "Icon Size +"; //--- ToDo: Localize;
                    y = ANDROID_pixel2Menu_Y(OSD_menuElement_px_Y(2));
                    tooltip = "Increase Icon/Text Size"; //--- ToDo: Localize;
                    action = QUOTE(1 call FUNC(caseButtonsAdjustTextSize););
                };
                class btnIconSizedwn: btnTextonoff {
                    idc = 11;
                    text = "Icon Size -"; //--- ToDo: Localize;
                    y = ANDROID_pixel2Menu_Y(OSD_menuElement_px_Y(3));
                    tooltip = "Decrease Icon/Text Size"; //--- ToDo: Localize;
                    action = QUOTE(-1 call FUNC(caseButtonsAdjustTextSize););
                };
                class btnF5: btnTextonoff {
                    idc = 12;
                    y = ANDROID_pixel2Menu_Y(OSD_menuElement_px_Y(7));
                    text = "Map Tools";
                    tooltip = "Toggle Map Tools (F5)";
                    action = QUOTE(['GVARMAIN(Android_dlg)'] call FUNC(toggleMapTools));
                };
                class btnF6: btnTextonoff {
                    idc = 14;
                    y = ANDROID_pixel2Menu_Y(OSD_menuElement_px_Y(5));
                    text = "Map Textures";
                    tooltip = "Toggle Map Textures (F6)";
                    action = QUOTE(['GVARMAIN(Android_dlg)'] call FUNC(caseButtonsMapTypeToggle););
                };
                class btnF7: btnTextonoff {
                    idc = 15;
                    y = ANDROID_pixel2Menu_Y(OSD_menuElement_px_Y(6));
                    text = "Center Map";
                    action = QUOTE(['GVARMAIN(Android_dlg)'] call FUNC(caseButtonsCenterMapOnPlayerPosition));
                    tooltip = "Center Map On Current Position (F7)";
                };
            };
        };
        // ---------- MESSAGING READ -----------
        class MESSAGE: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_MESSAGE;
            x = ANDROID_pixel2Screen_X(SCREEN_contentRect_px_X);
            y = ANDROID_pixel2Screen_Y(SCREEN_contentRect_px_Y);
            w = ANDROID_pixel2Screen_W(SCREEN_contentRect_px_W);
            h = ANDROID_pixel2Screen_H(SCREEN_contentRect_px_H);
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class msgListbox: cTab_RscListbox {
                    idc = IDC_CTAB_MSG_LIST;
                    style = LB_MULTI;
                    sizeEx = ANDROID_pixel2Screen_H(OSD_elementBase_textSize_px * 0.8);
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_read_list_px_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_read_list_px_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_read_list_px_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_read_list_px_H);
                    onLBSelChanged = QUOTE(_this call FUNC(messagingGetMessage););
                };
                class msgframe: cTab_RscFrame {
                    idc = 16;
                    text = "Read Message"; //--- ToDo: Localize;
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_read_frame_px_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_read_frame_px_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_read_frame_px_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_read_frame_px_H);
                };
                class msgTxt: cTab_RscEdit {
                    idc = IDC_CTAB_MSG_CONTENT;
                    htmlControl = true;
                    style = ST_MULTI;
                    lineSpacing = 0.2;
                    text = "No Message Selected"; //--- ToDo: Localize;
                    sizeEx = ANDROID_pixel2Screen_H(OSD_elementBase_textSize_px);
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_read_text_px_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_read_text_px_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_read_text_px_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_read_text_px_H);
                    canModify = 0;
                };
                class deletebtn: cTab_RscButton {
                    idc = IDC_CTAB_MSG_BTNDELETE;
                    text = "Delete"; //--- ToDo: Localize;
                    tooltip = "Delete Selected Message(s)";
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_button_delete_px_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_button_delete_px_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_button_px_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_button_H);
                    action = QUOTE(['GVARMAIN(Android_dlg)'] call FUNC(messagingDeleteSelectedMessage););
                };
                class toCompose: cTab_RscButton {
                    idc = 17;
                    text = "Compose >>"; //--- ToDo: Localize;
                    tooltip = "Compose Messages";
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_mode_button_px_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_mode_button_px_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_button_px_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_button_H);
                    action = QUOTE(ARR_2(['GVARMAIN(Android_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_MESSAGES_COMPOSE')]]]) call FUNC(setSettings));
                };
            };
        };
        // ---------- MESSAGING COMPOSE -----------
        class COMPOSE: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_COMPOSE;
            x = ANDROID_pixel2Screen_X(SCREEN_contentRect_px_X);
            y = ANDROID_pixel2Screen_Y(SCREEN_contentRect_px_Y);
            w = ANDROID_pixel2Screen_W(SCREEN_contentRect_px_W);
            h = ANDROID_pixel2Screen_H(SCREEN_contentRect_px_H);
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class composeFrame: cTab_RscFrame {
                    idc = 18;
                    text = "Compose Message"; //--- ToDo: Localize;
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_compose_frame_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_compose_frame_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_compose_frame_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_compose_frame_H);
                };
                class playerlistbox: cTab_RscListbox {
                    idc = IDC_CTAB_MSG_RECIPIENTS;
                    style = LB_MULTI;
                    sizeEx = ANDROID_pixel2Screen_H(OSD_elementBase_textSize_px * 0.8);
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_compose_list_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_compose_list_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_compose_list_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_compose_list_H);
                };
                class sendbtn: cTab_RscButton {
                    idc = IDC_CTAB_MSG_BTNSEND;
                    text = "Send"; //--- ToDo: Localize;
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_button_send_px_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_button_send_px_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_button_px_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_button_H);
                    action = QUOTE(call FUNC(messagingSendMessage););
                };
                class edittxtbox: cTab_RscEdit {
                    idc = IDC_CTAB_MSG_COMPOSE;
                    htmlControl = true;
                    style = ST_MULTI;
                    lineSpacing = 0.2;
                    text = ""; //--- ToDo: Localize;
                    sizeEx = ANDROID_pixel2Screen_H(OSD_elementBase_textSize_px);
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_compose_text_px_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_compose_text_px_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_compose_text_px_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_compose_text_px_H);
                };
                class toRead: cTab_RscButton {
                    idc = 19;
                    text = "Read >>"; //--- ToDo: Localize;
                    tooltip = "Read Messages";
                    x = ANDROID_pixel2GroupRect_X(ANDROID_messages_mode_button_px_X);
                    y = ANDROID_pixel2GroupRect_Y(ANDROID_messages_mode_button_px_Y);
                    w = ANDROID_pixel2Screen_W(ANDROID_messages_button_px_W);
                    h = ANDROID_pixel2Screen_H(ANDROID_messages_button_H);
                    action = QUOTE(ARR_2(['GVARMAIN(Android_dlg)',[[ARR_2('SETTING_MODE','SETTING_MODE_MESSAGES')]]]) call FUNC(setSettings));
                };
            };
        };

        /*
            ### Overlays ###
        */
        // ---------- NOTIFICATION ------------
        class notification: cTab_android_notification {};
        // ---------- LOADING ------------
        class loadingtxt: cTab_android_loadingtxt {};
        // ---------- BRIGHTNESS ------------
        class brightness: cTab_android_brightness {};
        // ---------- USER MARKERS ------------
        #include "..\shared\cTab_markerMenu_controls.hpp"
        // ---------- BACKGROUND ------------
        class background: cTab_android_background {};
        // ---------- MOVING HANDLEs ------------
        class movingHandle_T: cTab_android_movingHandle_T{};
        class movingHandle_B: cTab_android_movingHandle_B{};
        class movingHandle_L: cTab_android_movingHandle_L{};
        class movingHandle_R: cTab_android_movingHandle_R{};

        /*
            ### PHYSICAL BUTTONS ###
        */
        class btnMenu: cTab_android_btnMenu {
            idc = IDC_CTAB_BTNFN;
            action = QUOTE(['GVARMAIN(Android_dlg)'] call FUNC(showMenuToggle););
            tooltip = "Map Options";
        };
        class btnPower: cTab_android_btnPower {
            idc = IDC_CTAB_BTNOFF;
            action = QUOTE(closeDialog 0;);
            tooltip = "Close Interface";
        };
        class btnHome: cTab_android_btnHome {
            idc = IDC_CTAB_BTNF1;
            action = QUOTE(['GVARMAIN(Android_dlg)'] call FUNC(caseButtonsToggleMode););
            tooltip = "Toggle Map (F1) / Messages (F4)";
        };
    };
};
