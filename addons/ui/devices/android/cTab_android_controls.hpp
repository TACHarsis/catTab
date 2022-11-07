#define HEMTT_FIRST_LINE_COMMENT_FIX
// Background definition
#define ANDROID_BackgroundImage_px_W 2048 // width in pixels
#define ANDROID_BackgroundImage_px_H 2048 // hight in pixels

// Base macros to convert pixel space to screen space
#define ANDROID_pixel2Screen_X(PIXEL) (PIXEL) / ANDROID_BackgroundImage_px_W * CUSTOM_GRID_WAbs + CUSTOM_GRID_X
#define ANDROID_pixel2Screen_Y(PIXEL) (PIXEL) / ANDROID_BackgroundImage_px_H * CUSTOM_GRID_HAbs + CUSTOM_GRID_Y
#define ANDROID_pixel2Screen_W(PIXEL) (PIXEL) / ANDROID_BackgroundImage_px_W * CUSTOM_GRID_WAbs
#define ANDROID_pixel2Screen_H(PIXEL) (PIXEL) / ANDROID_BackgroundImage_px_H * CUSTOM_GRID_HAbs

// Map position within background, pixel based
#define ANDROID_mapRect_px_X (452)
#define ANDROID_mapRect_px_Y (713)
#define ANDROID_mapRect_px_W (1067)
#define ANDROID_mapRect_px_H (622)

// Height of header and footer OSD elements
#define OSD_header_px_H (60)
#define OSD_footer_px_H (0)

// On-screen edge positions (left, right, top, bottom)
#define OSD_margin_px (20)
#define OSD_edge_px_L (OSD_margin_px + ANDROID_mapRect_px_X)
#define OSD_edge_px_R (-OSD_margin_px + ANDROID_mapRect_px_X + ANDROID_mapRect_px_W)
#define OSD_edge_px_T (OSD_margin_px + ANDROID_mapRect_px_Y)
#define OSD_edge_px_B (-OSD_footer_px_H + ANDROID_mapRect_px_Y + ANDROID_mapRect_px_H)

// On-screen element base width and height
#define OSD_elementBase_size_px_W ((ANDROID_mapRect_px_W - OSD_margin_px * 6) / 5)
#define OSD_elementBase_size_px_H (OSD_header_px_H - OSD_margin_px)

// On-screen element X-coord for left, center and right elements
#define OSD_element_px_X(ITEM) (OSD_edge_px_L + (OSD_margin_px + OSD_elementBase_size_px_W) * (ITEM - 1))

// On-screen text sizes, hight in pixels
// Standard text elements
#define OSD_elementBase_textSize_px (38)
#define OSD_elementBase_iconSize_px (42)

// On-screen map centre cursor
#define CURSOR_size_px (48)

// On-screen menu frame
#define OSD_menu_px_W (SCREEN_contentRect_px_W / 4)
#define OSD_menu_px_H (SCREEN_contentRect_px_H)
#define OSD_menu_px_X (SCREEN_contentRect_px_X + SCREEN_contentRect_px_W - OSD_menu_px_W)
#define OSD_menu_px_Y (SCREEN_contentRect_px_Y)

// On-screen menu elelements
#define OSD_menu_margin_px_W (OSD_menu_px_W * 0.05)
#define OSD_menu_margin_px_H (OSD_menu_px_H * 0.05)
#define OSD_menuElement_px_X (OSD_menu_px_X + OSD_menu_margin_px_W)
#define OSD_menuElement_px_W (OSD_menu_px_W - (OSD_menu_margin_px_W * 2))
#define OSD_menuElement_px_H ((OSD_menu_px_H - OSD_menu_margin_px_H * 8) / 7)
#define OSD_menuElement_px_Y(ITEM) (OSD_menu_px_Y + OSD_menu_margin_px_H + (OSD_menuElement_px_H + OSD_menu_margin_px_H) * (ITEM - 1))

// like to pxToGrou, just for the menu
#define ANDROID_pixel2Menu_X(PIXEL) (((PIXEL) - OSD_menu_px_X) / ANDROID_BackgroundImage_px_W * CUSTOM_GRID_WAbs)
#define ANDROID_pixel2Menu_Y(PIXEL) (((PIXEL) - OSD_menu_px_Y) / ANDROID_BackgroundImage_px_H * CUSTOM_GRID_HAbs)

// Screen content (the stuff that changes, so map area - header and footer)
#define SCREEN_contentRect_px_X (ANDROID_mapRect_px_X)
#define SCREEN_contentRect_px_Y (ANDROID_mapRect_px_Y + OSD_header_px_H)
#define SCREEN_contentRect_px_W (ANDROID_mapRect_px_W)
#define SCREEN_contentRect_px_H (ANDROID_mapRect_px_H - OSD_header_px_H - OSD_footer_px_H)

// Base macros to convert pixel space to screen space, but for groups (same size as map)
#define ANDROID_pixel2GroupRect_X(PIXEL) (((PIXEL) - SCREEN_contentRect_px_X) / ANDROID_BackgroundImage_px_W * CUSTOM_GRID_WAbs)
#define ANDROID_pixel2GroupRect_Y(PIXEL) (((PIXEL) - SCREEN_contentRect_px_Y) / ANDROID_BackgroundImage_px_H * CUSTOM_GRID_HAbs)

// Message element positions in pixels
#define ANDROID_messages_margin_outer (20)
#define ANDROID_messages_margin_inner (10)

#define ANDROID_messages_button_H (60)

#define ANDROID_messages_read_frame_px_X (ANDROID_mapRect_px_X + ANDROID_messages_margin_outer)
#define ANDROID_messages_read_frame_px_Y (ANDROID_mapRect_px_Y + OSD_header_px_H + ANDROID_messages_margin_inner)
#define ANDROID_messages_read_frame_px_W (ANDROID_mapRect_px_W - ANDROID_messages_margin_outer * 2)
#define ANDROID_messages_read_frame_px_H (ANDROID_mapRect_px_H - OSD_header_px_H - ANDROID_messages_margin_inner * 2)

#define ANDROID_messages_read_list_px_X (ANDROID_messages_read_frame_px_X + ANDROID_messages_margin_inner)
#define ANDROID_messages_read_list_px_Y (ANDROID_messages_read_frame_px_Y + ANDROID_messages_margin_outer)
#define ANDROID_messages_read_list_px_W ((ANDROID_messages_read_frame_px_W - ANDROID_messages_margin_inner * 3) / 3)
#define ANDROID_messages_read_list_px_H (ANDROID_messages_read_frame_px_H - ANDROID_messages_margin_inner * 3 - ANDROID_messages_margin_outer - ANDROID_messages_button_H * 2)

#define ANDROID_messages_read_text_px_X (ANDROID_messages_read_list_px_X + ANDROID_messages_read_list_px_W + ANDROID_messages_margin_inner)
#define ANDROID_messages_read_text_px_Y (ANDROID_messages_read_list_px_Y)
#define ANDROID_messages_read_text_px_W (ANDROID_messages_read_list_px_W * 2)
#define ANDROID_messages_read_text_px_H (ANDROID_messages_read_frame_px_H - ANDROID_messages_margin_outer -ANDROID_messages_margin_inner)

#define ANDROID_messages_compose_frame_X (ANDROID_messages_read_frame_px_X)
#define ANDROID_messages_compose_frame_Y (ANDROID_messages_read_frame_px_Y)
#define ANDROID_messages_compose_frame_W (ANDROID_messages_read_frame_px_W)
#define ANDROID_messages_compose_frame_H (ANDROID_messages_read_frame_px_H)

#define ANDROID_messages_compose_list_X (ANDROID_messages_read_list_px_X)
#define ANDROID_messages_compose_list_Y (ANDROID_messages_compose_frame_Y + ANDROID_messages_margin_outer)
#define ANDROID_messages_compose_list_W (ANDROID_messages_read_list_px_W)
#define ANDROID_messages_compose_list_H (ANDROID_messages_read_list_px_H)

#define ANDROID_messages_compose_text_px_X (ANDROID_messages_read_text_px_X)
#define ANDROID_messages_compose_text_px_Y (ANDROID_messages_compose_list_Y)
#define ANDROID_messages_compose_text_px_W (ANDROID_messages_read_text_px_W)
#define ANDROID_messages_compose_text_px_H (ANDROID_messages_read_text_px_H)

#define ANDROID_messages_button_px_W (ANDROID_messages_read_list_px_W)
#define ANDROID_messages_mode_button_px_X (ANDROID_messages_button_send_px_X)
#define ANDROID_messages_mode_button_px_Y (ANDROID_messages_button_send_px_Y + ANDROID_messages_margin_inner + ANDROID_messages_button_H)

#define ANDROID_messages_button_send_px_X (ANDROID_messages_compose_frame_X + ANDROID_messages_margin_inner)
#define ANDROID_messages_button_send_px_Y (ANDROID_messages_compose_list_Y + ANDROID_messages_compose_list_H + ANDROID_messages_margin_inner)

#define ANDROID_messages_button_delete_px_X (ANDROID_messages_button_send_px_X)
#define ANDROID_messages_button_delete_px_Y (ANDROID_messages_button_send_px_Y)

class cTab_RscText_Android: cTab_RscText {
    style = ST_CENTER;
    w = ANDROID_pixel2Screen_W(OSD_elementBase_size_px_W);
    h = ANDROID_pixel2Screen_H(OSD_elementBase_size_px_H);
    font = GUI_FONT_MONO;
    colorText[] = COLOR_WHITE;
    sizeEx = ANDROID_pixel2Screen_H(OSD_elementBase_textSize_px);
    colorBackground[] = COLOR_TRANSPARENT;
    shadow = 0;
};
class cTab_android_RscMapControl: cTab_RscMapControl {
    idc = IDC_CTAB_SCREEN;
    text = "#(argb,8,8,3)color(1,1,1,1)";
    x = ANDROID_pixel2Screen_X(SCREEN_contentRect_px_X);
    y = ANDROID_pixel2Screen_Y(SCREEN_contentRect_px_Y);
    w = ANDROID_pixel2Screen_W(SCREEN_contentRect_px_W);
    h = ANDROID_pixel2Screen_H(SCREEN_contentRect_px_H);
    //type = CT_MAP;
    // allow to zoom out further (defines the maximum map scale, usually 1)
    scaleMax = 1000;
    // set initial map scale
    scaleDefault = QUOTE((missionNamespace getVariable 'GVAR(mapScale)') * 0.86 / safezoneH);
    // turn on satellite map information (defines the map scale of when to switch to topographical)
    maxSatelliteAlpha = 10000;
    alphaFadeStartScale = 10;
    alphaFadeEndScale = 10;

    // Rendering density coefficients
    ptsPerSquareSea = 8 / cTab_android_DLGtoDSP_fctr;        // seas
    ptsPerSquareTxt = 8 / cTab_android_DLGtoDSP_fctr;        // textures
    ptsPerSquareCLn = 8 / cTab_android_DLGtoDSP_fctr;        // count-lines
    ptsPerSquareExp = 8 / cTab_android_DLGtoDSP_fctr;        // exposure
    ptsPerSquareCost = 8 / cTab_android_DLGtoDSP_fctr;        // cost

    // Rendering thresholds
    ptsPerSquareFor = 3 / cTab_android_DLGtoDSP_fctr;        // forests
    ptsPerSquareForEdge = 100 / cTab_android_DLGtoDSP_fctr;    // forest edges
    ptsPerSquareRoad = 1.5 / cTab_android_DLGtoDSP_fctr;        // roads
    ptsPerSquareObj = 4 / cTab_android_DLGtoDSP_fctr;        // other objects

    /*
    // replace CustomMark with wedding cake icon
    class CustomMark {
        icon = QPATHTOEF(data,img\icon_wedding_cake_ca.paa);
        size = 18;
        importance = 1;
        coefMin = 1;
        coefMax = 1;
        color[] = {1,1,1,1};
        shadow = 1;
    };
    */
};
class cTab_android_background: cTab_RscPicture {
    idc = IDC_CTAB_BACKGROUND;
    text = ""; // will be set during onLoad event
    x = CUSTOM_GRID_X;
    y = CUSTOM_GRID_Y;
    w = CUSTOM_GRID_WAbs;
    h = CUSTOM_GRID_HAbs;
};
class cTab_android_btnBack: cTab_RscButtonInv {
    x = ANDROID_pixel2Screen_X(1609);
    y = ANDROID_pixel2Screen_Y(806);
    w = ANDROID_pixel2Screen_W(102);
    h = ANDROID_pixel2Screen_H(102);
};
class cTab_android_btnMenu: cTab_android_btnBack {
    y = ANDROID_pixel2Screen_Y(1140);
};
class cTab_android_btnHome: cTab_android_btnBack {
    x = ANDROID_pixel2Screen_X(1613);
    y = ANDROID_pixel2Screen_Y(972);
};
class cTab_android_btnPower: cTab_RscButtonInv {
    x = ANDROID_pixel2Screen_X(1583);
    y = ANDROID_pixel2Screen_Y(1407);
    w = ANDROID_pixel2Screen_W(107);
    h = ANDROID_pixel2Screen_H(48);
};
class cTab_android_notificationLight {
    x = ANDROID_pixel2Screen_X(1793);
    y = ANDROID_pixel2Screen_Y(768);
    w = ANDROID_pixel2Screen_W(61);
    h = ANDROID_pixel2Screen_H(61);
};
class cTab_android_header: cTab_RscPicture {
    idc = 1;
    text = "#(argb,8,8,3)color(0,0,0,1)";
    x = ANDROID_pixel2Screen_X(ANDROID_mapRect_px_X);
    y = ANDROID_pixel2Screen_Y(ANDROID_mapRect_px_Y);
    w = ANDROID_pixel2Screen_W(ANDROID_mapRect_px_W);
    h = ANDROID_pixel2Screen_H(OSD_header_px_H);
};
class cTab_android_on_screen_battery: cTab_RscPicture {
    idc = 2;
    text = QPATHTOEF(data,img\ui\icon_battery_ca.paa);
    x = ANDROID_pixel2Screen_X(OSD_element_px_X(1));
    y = ANDROID_pixel2Screen_Y(ANDROID_mapRect_px_Y + (OSD_header_px_H - OSD_elementBase_iconSize_px) / 2);
    w = ANDROID_pixel2Screen_W(OSD_elementBase_iconSize_px);
    h = ANDROID_pixel2Screen_H(OSD_elementBase_iconSize_px);
    colorText[] = COLOR_WHITE;
};
class cTab_android_on_screen_time: cTab_RscText_android {
    idc = IDC_CTAB_OSD_TIME;
    style = ST_CENTER;
    x = ANDROID_pixel2Screen_X(OSD_element_px_X(3));
    y = ANDROID_pixel2Screen_Y(ANDROID_mapRect_px_Y + (OSD_header_px_H - OSD_elementBase_textSize_px) / 2);
};
class cTab_android_on_screen_signalStrength: cTab_android_on_screen_battery {
    idc = 3;
    text = QPATHTOEF(data,img\ui\icon_signalStrength_ca.paa);
    x = ANDROID_pixel2Screen_X(OSD_element_px_X(5) + OSD_elementBase_size_px_W - OSD_elementBase_iconSize_px * 2);
    colorText[] = COLOR_WHITE;
};
class cTab_android_on_screen_satellite: cTab_android_on_screen_battery {
    idc = 4;
    text = "\a3\ui_f\data\map\Diary\signal_ca.paa";
    x = ANDROID_pixel2Screen_X(OSD_element_px_X(5) + OSD_elementBase_size_px_W - OSD_elementBase_iconSize_px);
    colorText[] = COLOR_WHITE;
};
class cTab_android_on_screen_dirDegree: cTab_android_on_screen_time {
    idc = IDC_CTAB_OSD_DIR_DEGREE;
    style = ST_LEFT;
    x = ANDROID_pixel2Screen_X(OSD_element_px_X(2));
};
class cTab_android_on_screen_grid: cTab_android_on_screen_dirDegree {
    idc = IDC_CTAB_OSD_GRID;
    style = ST_RIGHT;
    x = ANDROID_pixel2Screen_X(OSD_element_px_X(4));
};
class cTab_android_on_screen_dirOctant: cTab_android_on_screen_dirDegree {
    idc = IDC_CTAB_OSD_DIR_OCTANT;
    style = ST_RIGHT;
    x = ANDROID_pixel2Screen_X(OSD_element_px_X(1));
};
class cTab_android_on_screen_hookGrid: cTab_RscText_Android {
    idc = IDC_CTAB_OSD_HOOK_GRID;
    style = ST_CENTER;
    x = ANDROID_pixel2Screen_X(OSD_element_px_X(1));
    y = ANDROID_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 4);
    colorText[] = {1,1,1,0.5};
    colorBackground[] = {0,0,0,0.25};
};
class cTab_android_on_screen_hookElevation: cTab_android_on_screen_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_ELEVATION;
    y = ANDROID_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 3);
};
class cTab_android_on_screen_hookDst: cTab_android_on_screen_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_DST;
    y = ANDROID_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 2);
};
class cTab_android_on_screen_hookDir: cTab_android_on_screen_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_DIR;
    y = ANDROID_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H);
};
class cTab_android_loadingtxt: cTab_RscText_android {
    idc = IDC_CTAB_LOADINGTXT;
    style = ST_CENTER;
    text = "Loading"; //--- ToDo: Localize;
    x = ANDROID_pixel2Screen_X(SCREEN_contentRect_px_X);
    y = ANDROID_pixel2Screen_Y(SCREEN_contentRect_px_Y);
    w = ANDROID_pixel2Screen_W(SCREEN_contentRect_px_W);
    h = ANDROID_pixel2Screen_H(SCREEN_contentRect_px_H);
    colorBackground[] = COLOR_LIGHT_BLUE;
};
class cTab_android_windowsBG: cTab_RscPicture {
    idc = IDC_CTAB_WIN_BACK;
    //text = "#(argb,8,8,3)color(0.2,0.431,0.647,1)";
    text=QPATHTOEF(data,img\ui\desktop\classic\android_desktop_background_0_co.paa);
    //onLoad = QUOTE((_this # 0) ctrlSetText format[ARR_4('#(argb,8,8,3)color(%1,%2,%3,1)',GVAR(androidDesktopColor) select 0,GVAR(androidDesktopColor) select 1,GVAR(androidDesktopColor) select 2)];);
    x = ANDROID_pixel2Screen_X(ANDROID_mapRect_px_X);
    y = ANDROID_pixel2Screen_Y(ANDROID_mapRect_px_Y);
    w = ANDROID_pixel2Screen_W(ANDROID_mapRect_px_W);
    h = ANDROID_pixel2Screen_H(ANDROID_mapRect_px_H);
};

// Define areas around the screen as interaction areas to allow screen movement
class cTab_android_movingHandle_T: cTab_RscText_android {
    idc = 5;
    moving = 1;
    colorBackground[] = COLOR_TRANSPARENT;
    x = ANDROID_pixel2Screen_X(0);
    y = ANDROID_pixel2Screen_Y(0);
    w = ANDROID_pixel2Screen_W(ANDROID_BackgroundImage_px_W);
    h = ANDROID_pixel2Screen_H(ANDROID_mapRect_px_Y);
};
class cTab_android_movingHandle_B: cTab_android_movingHandle_T {
    idc = 6;
    y = ANDROID_pixel2Screen_Y(ANDROID_mapRect_px_Y + ANDROID_mapRect_px_H);
    h = ANDROID_pixel2Screen_H(ANDROID_BackgroundImage_px_H - (ANDROID_mapRect_px_Y + ANDROID_mapRect_px_H));
};
class cTab_android_movingHandle_L: cTab_android_movingHandle_T {
    idc = 7;
    y = ANDROID_pixel2Screen_Y(ANDROID_mapRect_px_Y);
    w = ANDROID_pixel2Screen_W(ANDROID_mapRect_px_X);
    h = ANDROID_pixel2Screen_H(ANDROID_mapRect_px_H);
};
class cTab_android_movingHandle_R: cTab_android_movingHandle_L {
    idc = 8;
    x = ANDROID_pixel2Screen_X(ANDROID_mapRect_px_X + ANDROID_mapRect_px_W);
    w = ANDROID_pixel2Screen_W(ANDROID_BackgroundImage_px_W - (ANDROID_mapRect_px_X + ANDROID_mapRect_px_W));
};

// transparent control that gets placed on top of the GUI to adjust brightness
class cTab_android_brightness: cTab_RscText_Android {
    idc = IDC_CTAB_BRIGHTNESS;
    x = ANDROID_pixel2Screen_X(ANDROID_mapRect_px_X);
    y = ANDROID_pixel2Screen_Y(ANDROID_mapRect_px_Y);
    w = ANDROID_pixel2Screen_W(ANDROID_mapRect_px_W);
    h = ANDROID_pixel2Screen_H(ANDROID_mapRect_px_H);
    colorBackground[] = COLOR_TRANSPARENT;
};
class cTab_android_notification: cTab_RscText_Android {
    idc = IDC_CTAB_NOTIFICATION;
    x = ANDROID_pixel2Screen_X(SCREEN_contentRect_px_X + (SCREEN_contentRect_px_W * 0.2) / 2);
    y = ANDROID_pixel2Screen_Y(SCREEN_contentRect_px_Y + SCREEN_contentRect_px_H - 2 * OSD_elementBase_textSize_px);
    w = ANDROID_pixel2Screen_W(SCREEN_contentRect_px_W * 0.8);
    colorBackground[] = COLOR_BLACK;
};
