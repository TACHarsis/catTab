#undef CUSTOM_GRID_WAbs
#undef CUSTOM_GRID_HAbs
#undef CUSTOM_GRID_X
#undef CUSTOM_GRID_Y
#define CUSTOM_GRID_WAbs    (safezoneW)
#define CUSTOM_GRID_HAbs    (CUSTOM_GRID_WAbs * 4/3)
#define CUSTOM_GRID_X       (safezoneX + (safezoneW - CUSTOM_GRID_WAbs) / 2)
#define CUSTOM_GRID_Y       (safezoneY + (safezoneH - CUSTOM_GRID_HAbs) / 2)

#include "cTab_FBCB2_controls.hpp"
#include "..\shared\cTab_defines.hpp"

#undef MENU_sizeEx
#define MENU_sizeEx FBCB2_pixel2Screen_H(OSD_elementBase_textSize_px)
#include "..\shared\cTab_markerMenu_macros.hpp"

class GVARMAIN(FBCB2_dlg){
    idd = IDD_CTAB_FBCB2_DLG;
    movingEnable = "true";
    onLoad = QUOTE(_this call FUNC(onIfOpen));
    onUnload = QUOTE([] call FUNC(onIfClose));
    onKeyDown = QUOTE(_this call FUNC(onIfKeyDown));
    objects[] = {};
    class controlsBackground {
        class background: cTab_FBCB2_background {
            moving = 1;
        };
        class windowsBG: cTab_RscPicture {
            idc = IDC_CTAB_WIN_BACK;
            //text=QPATHTOEF(data,img\ui\desktop\classic\FBCB2_desktop_background_1_co.paa);
            text = "#(argb,8,8,3)color(0.2,0.431,0.647,1)";
            //onLoad = QUOTE((_this # 0) ctrlSetText format[ARR_4('#(argb,8,8,3)color(%1,%2,%3,1)',GVAR(FBCB2DesktopColor) select 0,GVAR(FBCB2DesktopColor) select 1,GVAR(FBCB2DesktopColor) select 2)];);
            x = QUOTE(FBCB2_pixel2Screen_X(FBCB2_mapRect_px_X));
            y = QUOTE(FBCB2_pixel2Screen_Y(FBCB2_mapRect_px_Y));
            w = QUOTE(FBCB2_pixel2Screen_W(FBCB2_mapRect_px_W));
            h = QUOTE(FBCB2_pixel2Screen_H(FBCB2_mapRect_px_H));
        };
        class screen: cTab_RscMapControl {
            idc = IDC_CTAB_SCREEN;
            text = "#(argb,8,8,3)color(1,1,1,1)";
            x = QUOTE(FBCB2_pixel2Screen_X(SCREEN_contentRect_px_X));
            y = QUOTE(FBCB2_pixel2Screen_Y(SCREEN_contentRect_px_Y));
            w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_contentRect_px_W));
            h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_contentRect_px_H));
            onDraw = QUOTE(nop = [ARR_2(QQGVARMAIN(FBCB2_dlg),_this)] call FUNC(drawMapControl););
            onMouseButtonDblClick = QUOTE(_this call FUNC(loadMarkerMenu););
            onMouseButtonUp = QUOTE(_this call FUNC(onIfMapClicked););
            onMouseMoving = QUOTE(GVAR(cursorOnMap) = _this select 3;GVAR(mapCursorPos) = _this select 0 ctrlMapScreenToWorld [ARR_2(_this select 1,_this select 2)];);
            maxSatelliteAlpha = 10000;
            alphaFadeStartScale = 10;
            alphaFadeEndScale = 10;

            // Rendering density coefficients
            ptsPerSquareSea = QUOTE(8 / (0.86 / CUSTOM_GRID_HAbs));        // seas
            ptsPerSquareTxt = QUOTE(8 / (0.86 / CUSTOM_GRID_HAbs));        // textures
            ptsPerSquareCLn = QUOTE(8 / (0.86 / CUSTOM_GRID_HAbs));        // count-lines
            ptsPerSquareExp = QUOTE(8 / (0.86 / CUSTOM_GRID_HAbs));        // exposure
            ptsPerSquareCost = QUOTE(8 / (0.86 / CUSTOM_GRID_HAbs));        // cost

            // Rendering thresholds
            ptsPerSquareFor = QUOTE(3 / (0.86 / CUSTOM_GRID_HAbs));        // forests
            ptsPerSquareForEdge = QUOTE(100 / (0.86 / CUSTOM_GRID_HAbs));    // forest edges
            ptsPerSquareRoad = QUOTE(1.5 / (0.86 / CUSTOM_GRID_HAbs));        // roads
            ptsPerSquareObj = QUOTE(4 / (0.86 / CUSTOM_GRID_HAbs));        // other objects
        };
        class screenTopo: screen {
            idc = IDC_CTAB_SCREEN_TOPO;
            maxSatelliteAlpha = 0;
        };
    };
    class controls {
        class header: cTab_FBCB2_header {};
        class battery: cTab_FBCB2_on_screen_battery {};
        class time: cTab_FBCB2_on_screen_time {};
        class signalStrength: cTab_FBCB2_on_screen_signalStrength {};
        class satellite: cTab_FBCB2_on_screen_satellite {};
        class dirDegree: cTab_FBCB2_on_screen_dirDegree {};
        class grid: cTab_FBCB2_on_screen_grid {};
        class dirOctant: cTab_FBCB2_on_screen_dirOctant {};
        class hookGrid: cTab_FBCB2_on_screen_hookGrid {};
        class hookElevation: cTab_FBCB2_on_screen_hookElevation {};
        class hookDst: cTab_FBCB2_on_screen_hookDst {};
        class hookDir: cTab_FBCB2_on_screen_hookDir {};

        // ---------- MESSAGING -----------
         class MESSAGE: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_MESSAGE;
            x = QUOTE(FBCB2_pixel2Screen_X(SCREEN_contentRect_px_X));
            y = QUOTE(FBCB2_pixel2Screen_Y(SCREEN_contentRect_px_Y));
            w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_contentRect_px_W));
            h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_contentRect_px_H));
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class msgframe: cTab_RscFrame {
                    idc = 15;
                    text = "Read Message"; //--- ToDo: Localize;
                    x = QUOTE(FBCB2_pixel2GroupRect_X(SCREEN_messages_read_frame_px_X));
                    y = QUOTE(FBCB2_pixel2GroupRect_Y(SCREEN_messages_read_frame_px_Y));
                    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_messages_read_frame_px_W));
                    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_messages_read_frame_px_H));
                };
                class msgListbox: cTab_RscListBox_FBCB2 {
                    idc = IDC_CTAB_MSG_LIST;
                    style = LB_MULTI;
                    x = QUOTE(FBCB2_pixel2GroupRect_X(SCREEN_messages_read_list_px_X));
                    y = QUOTE(FBCB2_pixel2GroupRect_Y(SCREEN_messages_read_list_px_Y));
                    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_messages_read_list_px_W));
                    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_messages_read_list_px_H));
                    onLBSelChanged = QUOTE(_this call FUNC(messagingGetMessage););
                };
                class msgTxt: cTab_RscEdit_FBCB2 {
                    idc = IDC_CTAB_MSG_CONTENT;
                    htmlControl = "true";
                    style = ST_MULTI;
                    lineSpacing = 0.2;
                    text = "No Message Selected"; //--- ToDo: Localize;
                    x = QUOTE(FBCB2_pixel2GroupRect_X(SCREEN_messages_read_text_px_X));
                    y = QUOTE(FBCB2_pixel2GroupRect_Y(SCREEN_messages_read_text_px_Y));
                    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_messages_read_text_px_W));
                    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_messages_read_text_px_H));
                    canModify = 0;
                };
                class composeFrame: cTab_RscFrame {
                    idc = 16;
                    text = "Compose Message"; //--- ToDo: Localize;
                    x = QUOTE(FBCB2_pixel2GroupRect_X(SCREEN_messages_compose_frame_px_X));
                    y = QUOTE(FBCB2_pixel2GroupRect_Y(SCREEN_messages_compose_frame_px_Y));
                    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_messages_compose_frame_px_W));
                    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_messages_compose_frame_px_H));
                };
                class playerlistbox: cTab_RscListBox_FBCB2 {
                    idc = IDC_CTAB_MSG_RECIPIENTS;
                    style = LB_MULTI;
                    x = QUOTE(FBCB2_pixel2GroupRect_X(SCREEN_messages_compose_list_px_X));
                    y = QUOTE(FBCB2_pixel2GroupRect_Y(SCREEN_messages_compose_list_px_Y));
                    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_messages_compose_list_px_W));
                    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_messages_compose_list_px_H));
                };
                class deletebtn: cTab_RscButton_FBCB2 {
                    idc = IDC_CTAB_MSG_BTNDELETE;
                    text = "Delete"; //--- ToDo: Localize;
                    tooltip = "Delete Selected Message(s)";
                    x = QUOTE(FBCB2_pixel2GroupRect_X(SCREEN_messages_button_delete_px_X));
                    y = QUOTE(FBCB2_pixel2GroupRect_Y(SCREEN_messages_button_delete_px_Y));
                    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_messages_button_px_W));
                    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_messages_button_H));
                    action = QUOTE([QQGVARMAIN(FBCB2_dlg)] call FUNC(messagingDeleteSelectedMessage););
                };
                class sendbtn: cTab_RscButton_FBCB2 {
                    idc = IDC_CTAB_MSG_BTNSEND;
                    text = "Send"; //--- ToDo: Localize;
                    x = QUOTE(FBCB2_pixel2GroupRect_X(SCREEN_messages_button_send_px_X));
                    y = QUOTE(FBCB2_pixel2GroupRect_Y(SCREEN_messages_button_send_px_Y));
                    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_messages_button_px_W));
                    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_messages_button_H));
                    action = QUOTE(call FUNC(messagingSendMessage););
                };
                class edittxtbox: cTab_RscEdit_FBCB2 {
                    idc = IDC_CTAB_MSG_COMPOSE;
                    htmlControl = "true";
                    style = ST_MULTI;
                    lineSpacing = 0.2;
                    text = ""; //--- ToDo: Localize;
                    x = QUOTE(FBCB2_pixel2GroupRect_X(SCREEN_messages_compose_text_px_X));
                    y = QUOTE(FBCB2_pixel2GroupRect_Y(SCREEN_messages_compose_text_px_Y));
                    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_messages_compose_text_px_W));
                    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_messages_compose_text_px_H));
                };
            };
        };

        class pwrbtn: cTab_FBCB2_btnPWR {
            idc = IDC_CTAB_BTNOFF;
            action = QUOTE(closeDialog 0;);
            tooltip = "Close Interface";
        };
        class btnbrtpls: cTab_FBCB2_btnBRTplus {
            idc = IDC_CTAB_BTNUP;
            action = QUOTE(1 call FUNC(caseButtonsAdjustTextSize););
            tooltip = "Increase Font";
        };
        class btnbrtmns: cTab_FBCB2_btnBRTminus {
            idc = IDC_CTAB_BTNDWN;
            action = QUOTE(-1 call FUNC(caseButtonsAdjustTextSize););
            tooltip = "Decrease Font";
        };
        class btntggl: cTab_FBCB2_btnRight {
            idc = IDC_CTAB_BTNF1;
            action = QUOTE([QQGVARMAIN(FBCB2_dlg)] call FUNC(caseButtonsToggleMode););
            tooltip = "Toggle Map (F1) / Messages (F4)";
        };
        class btnfunction: cTab_FBCB2_btnFCN {
            idc = IDC_CTAB_BTNFN;
            action = QUOTE([QQGVARMAIN(FBCB2_dlg)]  call FUNC(caseButtonsIconTextToggle););
            tooltip = "Toggle Text on/off";
        };
        class btnF5: cTab_FBCB2_btnF5 {
            idc = IDC_CTAB_BTNF5;
            tooltip = "Toggle Map Tools (F5)";
            action = QUOTE([QQGVARMAIN(FBCB2_dlg)] call FUNC(toggleMapTools));
        };
        class btnF6: cTab_FBCB2_btnF6 {
            idc = IDC_CTAB_BTNF6;
            tooltip = "Toggle Map Textures";
            action = QUOTE([QQGVARMAIN(FBCB2_dlg)]  call FUNC(caseButtonsMapTypeToggle););
        };
        class btnF7: cTab_FBCB2_btnF7 {
            idc = IDC_CTAB_BTNF7;
            action = QUOTE([QQGVARMAIN(FBCB2_dlg)] call FUNC(caseButtonsCenterMapOnPlayerPosition));
            tooltip = "Center Map On Current Position (F7)";
        };

        //### Secondary Map Pop up    ------------------------------------------------------------------------------------------------------
        #include "..\shared\cTab_markerMenu_controls.hpp"

        // ---------- NOTIFICATION ------------
        class notification: cTab_FBCB2_notification {};
        // ---------- LOADING ------------
        class loadingtxt: cTab_FBCB2_loadingtxt {};
    };
};
