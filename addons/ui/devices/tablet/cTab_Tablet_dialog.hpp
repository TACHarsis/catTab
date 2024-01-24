// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

#undef CUSTOM_GRID_WAbs
#undef CUSTOM_GRID_HAbs
#undef CUSTOM_GRID_X
#undef CUSTOM_GRID_Y
#define CUSTOM_GRID_HAbs    (safezoneH * 1.2)
#define CUSTOM_GRID_WAbs    (CUSTOM_GRID_HAbs * 3/4)
// since the actual map position is not in the center, we correct for it by shifting it right
// (TABLET_BackgroundImage_px_W - TABLET_mapRect_px_W) / 2 - TABLET_mapRect_px_X
// is 96.5, that is the pixel amount we have to shift by, devided by TABLET_BackgroundImage_px_W
// to make it a ratio that we can apply to CUSTOM_GRID_WAbs in order to get a screen value to shift by
#define CUSTOM_GRID_X       (safezoneX + (safezoneW - CUSTOM_GRID_WAbs) / 2 + (CUSTOM_GRID_WAbs * 96.5 / 2048))
#define CUSTOM_GRID_Y       (safezoneY + (safezoneH - CUSTOM_GRID_HAbs) / 2)

#include "cTab_Tablet_controls.hpp"

#undef MENU_sizeEx
#define MENU_sizeEx TABLET_pixel2Screen_H(OSD_elementBase_textSize_px)
#include "..\shared\cTab_markerMenu_macros.hpp"

class GVARMAIN(Tablet_dlg){
    idd = IDD_CTAB_TABLET_DLG;
    movingEnable = "true";
    onLoad = QUOTE(_this call FUNC(onTabletOpen); _this call FUNC(onIfOpen););
    onUnload = QUOTE(_this call FUNC(onTabletClose); [] call FUNC(onIfClose););
    onKeyDown = QUOTE(_this call FUNC(onIfKeyDown));
    objects[] = {};
    class controlsBackground {
        class windowsBG: cTab_RscPicture {
            idc = IDC_CTAB_WIN_BACK;
            text = "";
            onLoad = QUOTE(
                [ARR_2(
                    _this,
                    [ARR_4(
                        GVAR(tabletDesktopBackgroundMode),
                        GVAR(tabletDesktopBackgroundPreset),
                        GVAR(tabletDesktopColor),
                        GVAR(tabletDesktopCustomImageName)
                    )]
                )] call FUNC(setDeviceBackground);
            );
            x = QUOTE(TABLET_pixel2Screen_X(TABLET_mapRect_px_X));
            y = QUOTE(TABLET_pixel2Screen_Y(TABLET_mapRect_px_Y));
            w = QUOTE(TABLET_pixel2Screen_W(TABLET_mapRect_px_W));
            h = QUOTE(TABLET_pixel2Screen_H(TABLET_mapRect_px_H));
        };
        class screen: cTab_Tablet_RscMapControl {
            idc = IDC_CTAB_SCREEN;
            onDraw = QUOTE(_this call FUNC(drawMapControlTablet););
            onMouseButtonDblClick = QUOTE(_this call FUNC(loadMarkerMenu););
            onMouseButtonClick = QUOTE(_this call FUNC(onTabletMapClicked););
            onMouseButtonUp = QUOTE(_this call FUNC(onIfMapClicked););
            onMouseMoving = QUOTE(
                GVAR(cursorOnMap) = _this select 3;
                GVAR(mapCursorPos) = (_this select 0) ctrlMapScreenToWorld [ARR_2( 
                                                                _this select 1,
                                                                _this select 2
                                                            )];
            );
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
            x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X));
            y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y));
            w = QUOTE(TABLET_pixel2Screen_W(SCREEN_contentRect_px_W));
            h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H));
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class actBFTtxt: cTab_ActiveText {
                    style = ST_PICTURE;
                    idc = IDC_CTAB_ACTBFTTXT;
                    text = QPATHTOEF(data,img\ui\desktop\classic\cTab_BFT_ico.paa);//"Blue Force Tracker"; //--- ToDo: Localize;
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_contentRect_px_X + SCREEN_icon_OFFSET_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_contentRect_px_Y + SCREEN_icon_OFFSET_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_icon_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_icon_px_H));
                    action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','SETTING_MODE_BFT')]])] call FUNC(setSettings));
                    toolTip = "FBCB2 - Blue Force Tracker";
                };
                class actUAVtxt: actBFTtxt {
                    idc = IDC_CTAB_ACTUAVTXT;
                    text = QPATHTOEF(data,img\ui\desktop\classic\cTab_UAV_ico.paa);//"UAV Intelligence"; //--- ToDo: Localize;
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_contentRect_px_Y + SCREEN_icon_OFFSET_px_Y * 2 + SCREEN_icon_px_H));
                    action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','SETTING_MODE_CAM_UAV')]])] call FUNC(setSettings));
                    toolTip = "UAV Video Feeds";
                };
                class actVIDtxt: actBFTtxt {
                    idc = IDC_CTAB_ACTVIDTXT;
                    text = QPATHTOEF(data,img\ui\desktop\classic\cTab_HMC_ico.paa);//"Live Video Feeds"; //--- ToDo: Localize;
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_contentRect_px_Y + SCREEN_icon_OFFSET_px_Y * 3 + SCREEN_icon_px_H * 2));
                    action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','SETTING_MODE_CAM_HCAM')]])] call FUNC(setSettings));
                    toolTip = "Live Helmet Cam Video Feeds";
                };
                class actMSGtxt: actBFTtxt {
                    idc = IDC_CTAB_ACTMSGTXT;
                    text = QPATHTOEF(data,img\ui\desktop\classic\Ctab_mail_ico.paa);
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_contentRect_px_Y + SCREEN_icon_OFFSET_px_Y * 4 + SCREEN_icon_px_H * 3));
                    action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','SETTING_MODE_MESSAGES')]])] call FUNC(setSettings));
                    toolTip = "Text Messaging System";
                };
            };
         };
        // ---------- Cameras -----------
        class UAVSourceSelectionList : cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_UAV_SOURCE_GRP;
            x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X));
            y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y));
            w = QUOTE(TABLET_pixel2Screen_W((SCREEN_contentRect_px_W)));
            h = QUOTE(TABLET_pixel2Screen_H(TASKBAR_area_px_H));

            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls { };
        };
        class HCAMSourceSelectionList : UAVSourceSelectionList {
            idc = IDC_CTAB_GROUP_HCAM_SOURCE_GRP;
        };
        class VideoFramePrototype : cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_VIDEO_FRAME;

            x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X));
            y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y + 2 * TASKBAR_area_px_H));
            w = QUOTE(TABLET_pixel2Screen_W(SCREEN_contentRect_px_W));
            h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H - 2 * TASKBAR_area_px_H));

            onLoad = QUOTE(
                (_this # 0) ctrlShow false;
                (_this # 0) ctrlEnable false;
            );

            class VScrollbar {scrollSpeed = 0;};
            class HScrollbar {scrollSpeed = 0;};
            class Scrollbar {scrollSpeed = 0;};
            class controls { };
         };
        // ---------- MESSAGING -----------
        class MESSAGE: cTab_RscControlsGroup {
            idc = IDC_CTAB_GROUP_MESSAGE;
            x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X));
            y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y));
            w = QUOTE(TABLET_pixel2Screen_W(SCREEN_contentRect_px_W));
            h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H));
            class VScrollbar {};
            class HScrollbar {};
            class Scrollbar {};
            class controls {
                class msgframe: cTab_RscFrame {
                    idc = 15;
                    text = "Read Message"; //--- ToDo: Localize;
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_messages_read_frame_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_messages_read_frame_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_messages_read_frame_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_messages_read_frame_px_H));
                };
                class msgListbox: cTab_RscListBox_Tablet {
                    idc = IDC_CTAB_MSG_LIST;
                    style = LB_MULTI;
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_messages_read_list_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_messages_read_list_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_messages_read_list_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_messages_read_list_px_H));
                    onLBSelChanged = QUOTE(_this call FUNC(messagingGetMessage););
                };
                class msgTxt: cTab_RscEdit_Tablet {
                    idc = IDC_CTAB_MSG_CONTENT;
                    htmlControl = "true";
                    style = ST_MULTI;
                    lineSpacing = 0.2;
                    text = "No Message Selected"; //--- ToDo: Localize;
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_messages_read_text_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_messages_read_text_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_messages_read_text_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_messages_read_text_px_H));
                    canModify = 0;
                };
                class composeFrame: cTab_RscFrame {
                    idc = 16;
                    text = "Compose Message"; //--- ToDo: Localize;
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_messages_compose_frame_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_messages_compose_frame_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_messages_compose_frame_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_messages_compose_frame_px_H));
                };
                class playerlistbox: cTab_RscListBox_Tablet {
                    idc = IDC_CTAB_MSG_RECIPIENTS;
                    style = LB_MULTI;
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_messages_compose_list_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_messages_compose_list_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_messages_compose_list_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_messages_compose_list_px_H));
                };
                class deletebtn: cTab_RscButton_Tablet {
                    idc = IDC_CTAB_MSG_BTNDELETE;
                    text = "Delete"; //--- ToDo: Localize;
                    tooltip = "Delete Selected Message(s)";
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_messages_button_delete_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_messages_button_delete_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_messages_button_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_messages_button_H));
                    action = QUOTE([QQGVARMAIN(Tablet_dlg)] call FUNC(messagingDeleteSelectedMessage););
                };
                class sendbtn: cTab_RscButton_Tablet {
                    idc = IDC_CTAB_MSG_BTNSEND;
                    text = "Send"; //--- ToDo: Localize;
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_messages_button_send_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_messages_button_send_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_messages_button_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_messages_button_H));
                    action = QUOTE(call FUNC(messagingSendMessage););
                };
                class edittxtbox: cTab_RscEdit_Tablet {
                    idc = IDC_CTAB_MSG_COMPOSE;
                    htmlControl = "true";
                    style = ST_MULTI;
                    lineSpacing = 0.2;
                    text = ""; //--- ToDo: Localize;
                    x = QUOTE(TABLET_pixel2GroupRect_X(SCREEN_messages_compose_text_px_X));
                    y = QUOTE(TABLET_pixel2GroupRect_Y(SCREEN_messages_compose_text_px_Y));
                    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_messages_compose_text_px_W));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_messages_compose_text_px_H));
                };
            };
        };
        // // ------ FULLSCREEN UAV Gunner ------
        class cTabUAVFull: cTab_RscControlsGroup {
            idc = IDC_CTAB_UAV_FULLSCREEN;
            x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X));
            y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y));
            w = QUOTE(TABLET_pixel2Screen_W(SCREEN_contentRect_px_W));
            h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H));

            class controls {
                class List: cTab_RscControlsGroup {
                    idc = IDC_CTAB_UAV_FULLSCREEN_LIST;
                    x = QUOTE(0);
                    y = QUOTE(0);
                    w = QUOTE(TABLET_pixel2Screen_W((SCREEN_contentRect_px_W)));
                    h = QUOTE(TABLET_pixel2Screen_H(TASKBAR_area_px_H));

                    class VScrollbar {scrollSpeed = 0;};
                    class HScrollbar {scrollSpeed = 0;};
                    class Scrollbar {scrollSpeed = 0;};
                };
                class Content: cTab_RscControlsGroup {
                    idc = IDC_CTAB_UAV_FULLSCREEN_CNTNT;
                    x = QUOTE(0);
                    y = QUOTE(TABLET_pixel2Screen_H(TASKBAR_area_px_H));
                    w = QUOTE(TABLET_pixel2Screen_W((SCREEN_contentRect_px_W)));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H - TASKBAR_area_px_H));

                    class VScrollbar {scrollSpeed = 0;};
                    class HScrollbar {scrollSpeed = 0;};
                    class Scrollbar {scrollSpeed = 0;};
                };
            };
        };
        // ---------- FULLSCREEN HCAM -----------
        class cTabHcamFull: cTab_RscControlsGroup {
            idc = IDC_CTAB_HCAM_FULLSCREEN;
            x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X));
            y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y));
            w = QUOTE(TABLET_pixel2Screen_W(SCREEN_contentRect_px_W));
            h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H));

            class controls {
                class List: cTab_RscControlsGroup {
                    idc = IDC_CTAB_HCAM_FULLSCREEN_LIST;
                    x = QUOTE(0);
                    y = QUOTE(0);
                    w = QUOTE(TABLET_pixel2Screen_W((SCREEN_contentRect_px_W)));
                    h = QUOTE(TABLET_pixel2Screen_H(TASKBAR_area_px_H));

                    class VScrollbar {scrollSpeed = 0;};
                    class HScrollbar {scrollSpeed = 0;};
                    class Scrollbar {scrollSpeed = 0;};
                };
                class Content: cTab_RscControlsGroup {
                    idc = IDC_CTAB_HCAM_FULLSCREEN_CNTNT;
                    x = QUOTE(0);
                    y = QUOTE(TABLET_pixel2Screen_H(TASKBAR_area_px_H));
                    w = QUOTE(TABLET_pixel2Screen_W((SCREEN_contentRect_px_W)));
                    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H - TASKBAR_area_px_H));

                    class VScrollbar {scrollSpeed = 0;};
                    class HScrollbar {scrollSpeed = 0;};
                    class Scrollbar {scrollSpeed = 0;};
                };
            };
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
            action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','SETTING_MODE_BFT')]])] call FUNC(setSettings));
        };
        class btnF2: cTab_Tablet_btnF2 {
            idc = IDC_CTAB_BTNF2;
            tooltip = "UAV Intel Live Feed - Quick Key";
            action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','SETTING_MODE_CAM_UAV')]])] call FUNC(setSettings));
        };
        class btnF3: cTab_Tablet_btnF3 {
            idc = IDC_CTAB_BTNF3;
            tooltip = "Helmet Cam Live Feed - Quick Key";
            action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','SETTING_MODE_CAM_HCAM')]])] call FUNC(setSettings));
        };
        class btnF4: cTab_Tablet_btnF4 {
            idc = IDC_CTAB_BTNF4;
            tooltip = "Text Message Application - Quick Key";
            action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','SETTING_MODE_MESSAGES')]])] call FUNC(setSettings));
        };
        class btnF5: cTab_Tablet_btnF5 {
            idc = IDC_CTAB_BTNF5;
            tooltip = "Toggle Map Tools (F5)";
            action = QUOTE([QQGVARMAIN(Tablet_dlg)] call FUNC(toggleMapTools));
        };
        class btnF6: cTab_Tablet_btnF6 {
            idc = IDC_CTAB_BTNF6;
            tooltip = "Toggle Map Textures (F6)";
            action = QUOTE([QQGVARMAIN(Tablet_dlg)] call FUNC(caseButtonsMapTypeToggle););
        };
        class btnF7: cTab_Tablet_btnTrackpad {
            idc = 17;
            action = QUOTE([QQGVARMAIN(Tablet_dlg)] call FUNC(caseButtonsCenterMapOnPlayerPosition));
            tooltip = "Center Map On Current Position (F7)";
        };
        class btnF8: cTab_Tablet_btnTiny {
            idc = 18;
            action = QUOTE([] call FUNC(caseButtonsToggleFollow));
            tooltip = "Toggle UAV Follow (F8)";
        };
        class btnMain: cTab_Tablet_btnHome {
            idc = IDC_CTAB_BTNMAIN;
            tooltip = "Main Menu";
            action = QUOTE([ARR_2(QQGVARMAIN(Tablet_dlg),[[ARR_2('SETTING_MODE','DESKTOP')]])] call FUNC(setSettings));
        };
        class btnFN: cTab_Tablet_btnFn {
            idc = IDC_CTAB_BTNFN;
            action = QUOTE([QQGVARMAIN(Tablet_dlg)] call FUNC(caseButtonsIconTextToggle););
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
