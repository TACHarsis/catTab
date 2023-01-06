#define HEMTT_FIRST_LINE_COMMENT_FIX
#include "..\shared\cTab_base_gui_classes.hpp"
// Background definition
#define TAD_BackgroundImage_px_W 2048 // width in pixels
#define TAD_BackgroundImage_px_H 2048 // hight in pixels

// Base Macros to convert pixel space to screen space
#define TAD_pixel2Screen_X(PIXEL) ((PIXEL) / TAD_BackgroundImage_px_W * CUSTOM_GRID_WAbs + CUSTOM_GRID_X)
#define TAD_pixel2Screen_Y(PIXEL) ((PIXEL) / TAD_BackgroundImage_px_H * CUSTOM_GRID_HAbs + CUSTOM_GRID_Y)
#define TAD_pixel2Screen_W(PIXEL) ((PIXEL) / TAD_BackgroundImage_px_W * CUSTOM_GRID_WAbs)
#define TAD_pixel2Screen_H(PIXEL) ((PIXEL) / TAD_BackgroundImage_px_H * CUSTOM_GRID_HAbs)

// Map position within background, pixel based
#define TAD_mapContent_px_X (359)
#define TAD_mapContent_px_Y (371)
#define TAD_mapContent_px_W (1330)
#define TAD_mapContent_px_H (1345)

// On-screen edge positions (left, right, top, bottom)
#define OSD_margin_px (24)
#define OSD_edge_px_L (OSD_margin_px + TAD_mapContent_px_X)
#define OSD_edge_px_R (-OSD_margin_px + TAD_mapContent_px_X + TAD_mapContent_px_W)
#define OSD_edge_px_T (OSD_margin_px + TAD_mapContent_px_Y)
#define OSD_edge_px_B (-OSD_margin_px + TAD_mapContent_px_Y + TAD_mapContent_px_H)

// On-screen element base width and height
#define OSD_elementBase_size_px_W (26)
#define OSD_elementBase_size_px_H (53)
#define OSD_elementMode_size_px_W (38)
#define OSD_elementMode_size_px_H (82)
#define OSD_elementRoll_size_px_W (146)
#define OSD_elementRoll_size_px_H (146)

// On-screen OSB element offsets horizontally from the edge
#define OSD_text_offset_px (36)

// On-screen text sizes, hight in pixels
// Standard text elements
#define OSD_text_size_base_px (42)
// Mode / scale element (top right corner)
#define OSD_text_size_mode_px (66)
// Icon height
#define OSD_icon_size_px_H (32)

// On-screen map centre cursor
#define CURSOR_size_px (48)

// On-screen OSB positions (where the line meets the screen), all values absolute pixels values
// OSB01 to OSB05 along the top, values along the x-axis
#define OSD_button_01_px_X (661)
#define OSD_button_02_px_X (844)
#define OSD_button_03_px_X (1023)
#define OSD_button_04_px_X (1202)
#define OSD_button_05_px_X (1384)
// OSB06 to OSB10 along the right side, values along the y-axis
#define OSD_button_06_px_Y (647)
#define OSD_button_07_px_Y (836)
#define OSD_button_08_px_Y (1023)
#define OSD_button_09_px_Y (1209)
#define OSD_button_10_px_Y (1398)
// OSB11 to OSB15 along the bottom, values along the x-axis
#define OSD_button_11_px_X (OSD_button_05_px_X)
#define OSD_button_12_px_X (OSD_button_04_px_X)
#define OSD_button_13_px_X (OSD_button_03_px_X)
#define OSD_button_14_px_X (OSD_button_02_px_X)
#define OSD_button_15_px_X (OSD_button_01_px_X)
// OSB16 to OSB20 along the left, values along the y-axis
#define OSD_button_16_px_Y (OSD_button_10_px_Y)
#define OSD_button_17_px_Y (OSD_button_09_px_Y)
#define OSD_button_18_px_Y (OSD_button_08_px_Y)
#define OSD_button_19_px_Y (OSD_button_07_px_Y)
#define OSD_button_20_px_Y (OSD_button_06_px_Y)

class cTab_RscButton_TAD_OSB: cTab_RscButtonInv {
    w = QUOTE(TAD_pixel2Screen_W(134));
    h = QUOTE(TAD_pixel2Screen_H(134));
};
class cTab_RscButton_TAD_OSB01: cTab_RscButton_TAD_OSB {
    x = QUOTE(TAD_pixel2Screen_X(577));
    y = QUOTE(TAD_pixel2Screen_Y(146));
};
class cTab_RscButton_TAD_OSB02: cTab_RscButton_TAD_OSB01 {
    x = QUOTE(TAD_pixel2Screen_X(767));
};
class cTab_RscButton_TAD_OSB03: cTab_RscButton_TAD_OSB01 {
    x = QUOTE(TAD_pixel2Screen_X(957));
};
class cTab_RscButton_TAD_OSB04: cTab_RscButton_TAD_OSB01 {
    x = QUOTE(TAD_pixel2Screen_X(1147));
};
class cTab_RscButton_TAD_OSB05: cTab_RscButton_TAD_OSB01 {
    x = QUOTE(TAD_pixel2Screen_X(1337));
};
class cTab_RscButton_TAD_OSB06: cTab_RscButton_TAD_OSB {
    x = QUOTE(TAD_pixel2Screen_X(1782));
    y = QUOTE(TAD_pixel2Screen_Y(563));
};
class cTab_RscButton_TAD_OSB07: cTab_RscButton_TAD_OSB06 {
    y = QUOTE(TAD_pixel2Screen_Y(760));
};
class cTab_RscButton_TAD_OSB08: cTab_RscButton_TAD_OSB06 {
    y = QUOTE(TAD_pixel2Screen_Y(957));
};
class cTab_RscButton_TAD_OSB09: cTab_RscButton_TAD_OSB06 {
    y = QUOTE(TAD_pixel2Screen_Y(1155));
};
class cTab_RscButton_TAD_OSB10: cTab_RscButton_TAD_OSB06 {
    y = QUOTE(TAD_pixel2Screen_Y(1352));
};
class cTab_RscButton_TAD_OSB11: cTab_RscButton_TAD_OSB {
    x = QUOTE(TAD_pixel2Screen_X(1337));
    y = QUOTE(TAD_pixel2Screen_Y(1811));
};
class cTab_RscButton_TAD_OSB12: cTab_RscButton_TAD_OSB11 {
    x = QUOTE(TAD_pixel2Screen_X(1147));
};
class cTab_RscButton_TAD_OSB13: cTab_RscButton_TAD_OSB11 {
    x = QUOTE(TAD_pixel2Screen_X(957));
};
class cTab_RscButton_TAD_OSB14: cTab_RscButton_TAD_OSB11 {
    x = QUOTE(TAD_pixel2Screen_X(767));
};
class cTab_RscButton_TAD_OSB15: cTab_RscButton_TAD_OSB11 {
    x = QUOTE(TAD_pixel2Screen_X(577));
};
class cTab_RscButton_TAD_OSB16: cTab_RscButton_TAD_OSB {
    x = QUOTE(TAD_pixel2Screen_X(132));
    y = QUOTE(TAD_pixel2Screen_Y(1352));
};
class cTab_RscButton_TAD_OSB17: cTab_RscButton_TAD_OSB16 {
    y = QUOTE(TAD_pixel2Screen_Y(1155));
};
class cTab_RscButton_TAD_OSB18: cTab_RscButton_TAD_OSB16 {
    y = QUOTE(TAD_pixel2Screen_Y(957));
};
class cTab_RscButton_TAD_OSB19: cTab_RscButton_TAD_OSB16 {
    y = QUOTE(TAD_pixel2Screen_Y(760));
};
class cTab_RscButton_TAD_OSB20: cTab_RscButton_TAD_OSB16 {
    y = QUOTE(TAD_pixel2Screen_Y(563));
};
class cTab_RscButton_TAD_ADJ_INC: cTab_RscButtonInv {
    x = QUOTE(TAD_pixel2Screen_X(124));
    y = QUOTE(TAD_pixel2Screen_Y(257));
    w = QUOTE(TAD_pixel2Screen_W(142));
    h = QUOTE(TAD_pixel2Screen_H(119));
};
class cTab_RscButton_TAD_ADJ_DEC: cTab_RscButton_TAD_ADJ_INC {
    y = QUOTE(TAD_pixel2Screen_Y(376));
};
class cTab_RscButton_TAD_DSP_INC: cTab_RscButton_TAD_ADJ_INC {
    x = QUOTE(TAD_pixel2Screen_X(1782));
};
class cTab_RscButton_TAD_DSP_DEC: cTab_RscButton_TAD_DSP_INC {
    y = QUOTE(TAD_pixel2Screen_Y(376));
};
class cTab_RscButton_TAD_CON_INC: cTab_RscButton_TAD_ADJ_INC {
    y = QUOTE(TAD_pixel2Screen_Y(1539));
};
class cTab_RscButton_TAD_CON_DEC: cTab_RscButton_TAD_CON_INC {
    y = QUOTE(TAD_pixel2Screen_Y(1658));
};
class cTab_RscButton_TAD_BRT_INC: cTab_RscButton_TAD_CON_INC {
    x = QUOTE(TAD_pixel2Screen_X(1782));
};
class cTab_RscButton_TAD_BRT_DEC: cTab_RscButton_TAD_BRT_INC {
    y = QUOTE(TAD_pixel2Screen_Y(1658));
};
class cTab_RscButton_TAD_SYM_INC: cTab_RscButtonInv {
    x = QUOTE(TAD_pixel2Screen_X(1663));
    y = QUOTE(TAD_pixel2Screen_Y(1811));
    w = QUOTE(TAD_pixel2Screen_W(119));
    h = QUOTE(TAD_pixel2Screen_H(142));
};
class cTab_RscButton_TAD_SYM_DEC: cTab_RscButton_TAD_SYM_INC {
    x = QUOTE(TAD_pixel2Screen_X(1544));
};
class cTab_RscButton_TAD_DNO: cTab_RscButtonInv {
    x = QUOTE(TAD_pixel2Screen_X(234));
    y = QUOTE(TAD_pixel2Screen_Y(1894));
    w = QUOTE(TAD_pixel2Screen_W(142));
    h = QUOTE(TAD_pixel2Screen_H(142));
};

class cTab_RscText_TAD: cTab_RscText {
    style = ST_CENTER;
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W));
    h = QUOTE(TAD_pixel2Screen_H(OSD_elementBase_size_px_H));
    font = QUOTE(GUI_FONT_MONO);
    colorText[] = COLOR_NEON_GREEN;
    sizeEx = QUOTE(TAD_pixel2Screen_H(OSD_text_size_base_px));
    colorBackground[] = COLOR_BLACK;
    shadow = 0;
};
class cTab_TAD_upDownArrow: cTab_RscPicture {
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W));
    h = QUOTE(TAD_pixel2Screen_H(OSD_icon_size_px_H));
    colorText[] = COLOR_NEON_GREEN;
    colorBackground[] = COLOR_BLACK;
    text = "\a3\ui_f\data\IGUI\Cfg\Actions\autohover_ca.paa";
};
class cTab_TAD_RscMapControl: cTab_RscMapControl {
    text = "#(argb,8,8,3)color(1,1,1,1)";
    x = QUOTE(TAD_pixel2Screen_X(TAD_mapContent_px_X));
    y = QUOTE(TAD_pixel2Screen_Y(TAD_mapContent_px_Y));
    w = QUOTE(TAD_pixel2Screen_W(TAD_mapContent_px_W));
    h = QUOTE(TAD_pixel2Screen_H(TAD_mapContent_px_H));
    //type = CT_MAP;
    // allow to zoom out further (defines the maximum map scale, usually 1)
    scaleMax = 1000;
    // set initial map scale
    scaleDefault = "(missionNamespace getVariable 'GVAR(mapScale)') * 0.86 / (safezoneH * 0.8)";
    // turn on satellite map information (defines the map scale of when to switch to topographical)
    maxSatelliteAlpha = 10000;
    alphaFadeStartScale = 10;
    alphaFadeEndScale = 10;

    // Rendering density coefficients
    ptsPerSquareSea = QUOTE(8 / cTab_TAD_DLGtoDSP_fctr);        // seas
    ptsPerSquareTxt = QUOTE(8 / cTab_TAD_DLGtoDSP_fctr);        // textures
    ptsPerSquareCLn = QUOTE(8 / cTab_TAD_DLGtoDSP_fctr);        // count-lines
    ptsPerSquareExp = QUOTE(8 / cTab_TAD_DLGtoDSP_fctr);        // exposure
    ptsPerSquareCost = QUOTE(8 / cTab_TAD_DLGtoDSP_fctr);        // cost

    // Rendering thresholds
    ptsPerSquareFor = QUOTE( 3 / cTab_TAD_DLGtoDSP_fctr);        // forests
    ptsPerSquareForEdge = QUOTE(100 / cTab_TAD_DLGtoDSP_fctr);    // forest edges
    ptsPerSquareRoad = QUOTE(1.5 / cTab_TAD_DLGtoDSP_fctr);        // roads
    ptsPerSquareObj = QUOTE(4 / cTab_TAD_DLGtoDSP_fctr);        // other objects

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
class cTab_TAD_RscMapControl_BLACK: cTab_TAD_RscMapControl {
    font = "TahomaB";
    sizeEx = QUOTE(0.0);
    maxSatelliteAlpha = 0.0;
    colorBackground[] = {0,0,0,0};
    colorLevels[] = {0,0,0,0};
    colorSea[] = {0,0,0,0};
    colorForest[] = {0,0,0,0};
    colorRocks[] = {0,0,0,0};
    colorCountlines[] = {0,0,0,0};
    colorMainCountlines[] = {0,0,0,0};
    colorCountlinesWater[] = {0,0,0,0};
    colorMainCountlinesWater[] = {0,0,0,0};
    colorPowerLines[] = {0,0,0,0};
    colorRailWay[] = {0,0,0,0};
    colorForestBorder[] = {0,0,0,0};
    colorRocksBorder[] = {0,0,0,0};
    colorNames[] = {0,0,0,0};
    colorInactive[] = {0,0,0,0};
    colorOutside[] = {0,0,0,0};
    colorText[] = {0,0,0,0};
    colorGrid[] = {0,0,0,0};
    colorGridMap[] = {0,0,0,0};
    colorTracks[] = {0,0,0,0};
    colorTracksFill[] = {0,0,0,0};
    colorRoads[] = {0,0,0,0};
    colorRoadsFill[] = {0,0,0,0};
    colorMainRoads[] = {0,0,0,0};
    colorMainRoadsFill[] = {0,0,0,0};
    ShowCountourInterval = 0;
    shadow = 0;
    text = "";
    alphaFadeStartScale = 0.0;
    alphaFadeEndScale = 0.0;
    fontLabel = "TahomaB";
    sizeExLabel = 0.0;
    fontGrid = "TahomaB";
    sizeExGrid = 0.0;
    fontUnits = "TahomaB";
    sizeExUnits = 0.0;
    fontNames = "TahomaB";
    sizeExNames = 0.0;
    fontInfo = "TahomaB";
    sizeExInfo = 0.0;
    fontLevel = "TahomaB";
    sizeExLevel = 0.0;
    stickX[] = {0.0,{ "Gamma",0,0.0 }};
    stickY[] = {0.0,{ "Gamma",0,0.0 }};
    ptsPerSquareSea = QUOTE( 10000);
    ptsPerSquareTxt = QUOTE( 10000);
    ptsPerSquareCLn = QUOTE( 10000);
    ptsPerSquareExp = QUOTE( 10000);
    ptsPerSquareCost = QUOTE( 10000);
    ptsPerSquareFor = QUOTE( 10000);
    ptsPerSquareForEdge = QUOTE( 10000);
    ptsPerSquareRoad = QUOTE( 10000);
    ptsPerSquareObj = QUOTE( 10000);
    class Task {
        icon = "";
        color[] = {0,0,0,0};
        iconCreated = "";
        colorCreated[] = {0,0,0,0};
        iconCanceled = "";
        colorCanceled[] = {0,0,0,0};
        iconDone = "";
        colorDone[] = {0,0,0,0};
        iconFailed = "";
        colorFailed[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class CustomMark {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Bunker {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Bush {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class BusStop {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Command {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Cross {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Fortress {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Fuelstation {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Fountain {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Hospital {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Chapel {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Church {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Lighthouse {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Quay {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Rock {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Ruin {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class SmallTree {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Stack {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Tree {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Tourism {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Transmitter {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class ViewTower {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Watertower {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Waypoint {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class WaypointCompleted {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class ActiveMarker {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class PowerSolar {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class PowerWave {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class PowerWind {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
    class Shipwreck {
        icon = "";
        color[] = {0,0,0,0};
        size = 0;
        importance = 0;
        coefMin = 0;
        coefMax = 0;
    };
};

class cTab_TAD_Map_Background: cTab_RscText {
    idc = 1;
    x = QUOTE(TAD_pixel2Screen_X(TAD_mapContent_px_X));
    y = QUOTE(TAD_pixel2Screen_Y(TAD_mapContent_px_Y));
    w = QUOTE(TAD_pixel2Screen_W(TAD_mapContent_px_W));
    h = QUOTE(TAD_pixel2Screen_H(TAD_mapContent_px_H));
    colorBackground[] = COLOR_BLACK;
};

class cTab_TAD_background: cTab_RscPicture {
    idc = IDC_CTAB_BACKGROUND;
    text = ""; // will be set during onLoad event
    x = QUOTE(CUSTOM_GRID_X);
    y = QUOTE(CUSTOM_GRID_Y);
    w = QUOTE(CUSTOM_GRID_WAbs);
    h = QUOTE(CUSTOM_GRID_HAbs);
};
class cTab_TAD_OSD_hookGrid: cTab_RscText_TAD {
    idc = IDC_CTAB_OSD_HOOK_GRID;
    style = ST_CENTER;
    x = QUOTE(TAD_pixel2Screen_X(OSD_button_11_px_X - OSD_elementBase_size_px_W * 4));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_10_px_Y - OSD_elementBase_size_px_H * 0.5 + OSD_elementBase_size_px_H * 1));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 6));
};
class cTab_TAD_OSD_hookElevation: cTab_TAD_OSD_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_ELEVATION;
    x = QUOTE(TAD_pixel2Screen_X(OSD_button_11_px_X - OSD_elementBase_size_px_W * 2));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_10_px_Y - OSD_elementBase_size_px_H * 0.5 + OSD_elementBase_size_px_H * 2));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 4));
};
class cTab_TAD_OSD_hookDir: cTab_TAD_OSD_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_DIR;
    x = QUOTE(TAD_pixel2Screen_X(OSD_button_11_px_X - OSD_elementBase_size_px_W * 6));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_10_px_Y - OSD_elementBase_size_px_H * 0.5 + OSD_elementBase_size_px_H * 0));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 8));
};
class cTab_TAD_OSD_hookToggleIconBackground: cTab_RscText_TAD {
    idc = 2;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L + OSD_text_offset_px - OSD_elementBase_size_px_W));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_18_px_Y - OSD_elementBase_size_px_H     / 2));
};
class cTab_TAD_OSD_hookToggleIcon: cTab_TAD_upDownArrow {
    idc = 3;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L + OSD_text_offset_px - OSD_elementBase_size_px_W));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_18_px_Y - OSD_icon_size_px_H / 2));
};
class cTab_TAD_OSD_hookToggleText1: cTab_RscText_TAD {
    idc = IDC_CTAB_OSD_HOOK_TGGL1;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L + OSD_text_offset_px));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_18_px_Y - OSD_elementBase_size_px_H));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 4));
};
class cTab_TAD_OSD_hookToggleText2: cTab_TAD_OSD_hookToggleText1 {
    idc = IDC_CTAB_OSD_HOOK_TGGL2;
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_18_px_Y));
};
class cTab_TAD_OSD_currentDirection: cTab_RscText_TAD {
    idc = IDC_CTAB_OSD_DIR_DEGREE;
    x = QUOTE(TAD_pixel2Screen_X(OSD_button_14_px_X - OSD_elementBase_size_px_W * 4 / 2));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_edge_px_B - OSD_elementBase_size_px_H * 2));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 4));
};
class cTab_TAD_OSD_currentElevation: cTab_TAD_OSD_currentDirection {
    idc = IDC_CTAB_OSD_ELEVATION;
    x = QUOTE(TAD_pixel2Screen_X(OSD_button_12_px_X - OSD_elementBase_size_px_W * 5 / 2));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 5));
};
class cTab_TAD_OSD_centerMapText: cTab_RscText_TAD {
    idc = 4;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L + OSD_text_offset_px));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_19_px_Y - OSD_elementBase_size_px_H / 2));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 3));
    text = "CTR";
};
class cTab_TAD_loadingtxt: cTab_RscText_TAD {
    idc = IDC_CTAB_LOADINGTXT;
    style = ST_CENTER;
    text = "Loading"; //--- ToDo: Localize;
    x = QUOTE(TAD_pixel2Screen_X(TAD_mapContent_px_X));
    y = QUOTE(TAD_pixel2Screen_Y(TAD_mapContent_px_Y));
    w = QUOTE(TAD_pixel2Screen_W(TAD_mapContent_px_W));
    h = QUOTE(TAD_pixel2Screen_H(TAD_mapContent_px_H));
};
class cTab_TAD_OSD_cursor: cTab_RscPicture {
    idc = 5;
    text = "\a3\ui_f\data\IGUI\Cfg\WeaponCursors\cursoraimon_gs.paa";
        // "\a3\ui_f\data\map\Markers\Military\destroy_ca.paa";
        // "\a3\ui_f\data\IGUI\Cfg\WeaponCursors\cursoraimon_gs.paa"
        // "\a3\ui_f\data\map\MarkerBrushes\cross_ca.paa"
    x = QUOTE(TAD_pixel2Screen_X(TAD_mapContent_px_X + TAD_mapContent_px_W / 2 - 128 / 33 * CURSOR_size_px / 2));
    y = QUOTE(TAD_pixel2Screen_Y(TAD_mapContent_px_Y + TAD_mapContent_px_H / 2 - 128 / 33 * CURSOR_size_px / 2));
    w = QUOTE(TAD_pixel2Screen_W(128 / 33 * CURSOR_size_px));
    h = QUOTE(TAD_pixel2Screen_H(128 / 33 * CURSOR_size_px));
    colorText[] = COLOR_NEON_GREEN;
};
class cTab_TAD_OSD_navModeOrScale: cTab_RscText_TAD {
    idc = IDC_CTAB_OSD_MAP_SCALE;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_R - OSD_elementMode_size_px_W * 4));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_edge_px_T));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementMode_size_px_W * 4));
    h = QUOTE(TAD_pixel2Screen_H(OSD_elementMode_size_px_H));
    sizeEx = QUOTE(TAD_pixel2Screen_H(OSD_text_size_mode_px));
};
class cTab_TAD_OSD_modeTAD: cTab_RscText_TAD {
    idc = 6;
    x = QUOTE(TAD_pixel2Screen_X(OSD_button_15_px_X - OSD_elementBase_size_px_W * 3 / 2));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_edge_px_B - OSD_elementBase_size_px_H));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 3));
    colorText[] = COLOR_BLACK;
    colorBackground[] = COLOR_NEON_GREEN;
    text = "TAD";
};
class cTab_TAD_OSD_txtToggleIconBg: cTab_RscText_TAD {
    idc = 7;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_R - OSD_text_offset_px));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_10_px_Y - OSD_elementBase_size_px_H / 2));
};
class cTab_TAD_OSD_txtToggleIcon: cTab_TAD_upDownArrow {
    idc = 8;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_R - OSD_text_offset_px));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_10_px_Y - OSD_icon_size_px_H / 2));
};
class cTab_TAD_OSD_txtToggleText1: cTab_RscText_TAD {
    idc = 9;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_R - OSD_text_offset_px - OSD_elementBase_size_px_W * 3));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_10_px_Y - OSD_elementBase_size_px_H));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 3));
    text = "TXT";
};
class cTab_TAD_OSD_txtToggleText2: cTab_RscText_TAD {
    idc = IDC_CTAB_OSD_TXT_TGGL;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_R - OSD_text_offset_px - OSD_elementBase_size_px_W * 3));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_10_px_Y));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 3));
};
class cTab_TAD_OSD_time: cTab_RscText_TAD {
    idc = IDC_CTAB_OSD_TIME;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_edge_px_B - OSD_elementBase_size_px_H));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 5));
};
class cTab_TAD_OSD_currentGrid: cTab_RscText_TAD {
    idc = IDC_CTAB_OSD_GRID;
    x = QUOTE(TAD_pixel2Screen_X(OSD_button_13_px_X - OSD_elementBase_size_px_W * 6 / 2));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_edge_px_B - OSD_elementBase_size_px_H * 2));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 6));
};
class cTab_TAD_OSD_mapToggleIconBg: cTab_RscText_TAD {
    idc = 10;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L + OSD_text_offset_px - OSD_elementBase_size_px_W));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_20_px_Y - OSD_elementBase_size_px_H / 2));
};
class cTab_TAD_OSD_mapToggleIcon: cTab_TAD_upDownArrow {
    idc = 11;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L + OSD_text_offset_px - OSD_elementBase_size_px_W));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_20_px_Y - OSD_icon_size_px_H / 2));
};
class cTab_TAD_OSD_mapToggleText1: cTab_RscText_TAD {
    idc = 12;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L + OSD_text_offset_px));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_20_px_Y - OSD_elementBase_size_px_H));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 3));
    text = "MAP";
};
class cTab_TAD_OSD_mapToggleText2: cTab_RscText_TAD {
    idc = IDC_CTAB_OSD_MAP_TGGL;
    x = QUOTE(TAD_pixel2Screen_X(OSD_edge_px_L + OSD_text_offset_px));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_button_20_px_Y));
    w = QUOTE(TAD_pixel2Screen_W(OSD_elementBase_size_px_W * 4));
};

// Define areas around the screen as interaction areas to allow screen movement
class cTab_TAD_movingHandle_T: cTab_RscText_TAD {
    idc = 14;
    moving = 1;
    colorBackground[] = COLOR_TRANSPARENT;
    x = QUOTE(TAD_pixel2Screen_X(0));
    y = QUOTE(TAD_pixel2Screen_Y(0));
    w = QUOTE(TAD_pixel2Screen_W(TAD_BackgroundImage_px_W));
    h = QUOTE(TAD_pixel2Screen_H(TAD_mapContent_px_Y));
};
class cTab_TAD_movingHandle_B: cTab_TAD_movingHandle_T {
    idc = 15;
    y = QUOTE(TAD_pixel2Screen_Y(TAD_mapContent_px_Y + TAD_mapContent_px_H));
    h = QUOTE(TAD_pixel2Screen_H(TAD_BackgroundImage_px_H - (TAD_mapContent_px_Y + TAD_mapContent_px_H)));
};
class cTab_TAD_movingHandle_L: cTab_TAD_movingHandle_T {
    idc = 16;
    y = QUOTE(TAD_pixel2Screen_Y(TAD_mapContent_px_Y));
    w = QUOTE(TAD_pixel2Screen_W(TAD_mapContent_px_X));
    h = QUOTE(TAD_pixel2Screen_H(TAD_mapContent_px_H));
};
class cTab_TAD_movingHandle_R: cTab_TAD_movingHandle_L {
    idc = 17;
    x = QUOTE(TAD_pixel2Screen_X(TAD_mapContent_px_X + TAD_mapContent_px_W));
    w = QUOTE(TAD_pixel2Screen_W(TAD_BackgroundImage_px_W - (TAD_mapContent_px_X + TAD_mapContent_px_W)));
};

// transparent control that gets placed on top of the GUI to adjust brightness
class cTab_TAD_brightness: cTab_RscText_TAD {
    idc = IDC_CTAB_BRIGHTNESS;
    x = QUOTE(TAD_pixel2Screen_X(TAD_mapContent_px_X));
    y = QUOTE(TAD_pixel2Screen_Y(TAD_mapContent_px_Y));
    w = QUOTE(TAD_pixel2Screen_W(TAD_mapContent_px_W));
    h = QUOTE(TAD_pixel2Screen_H(TAD_mapContent_px_H));
    colorBackground[] = COLOR_TRANSPARENT;
};
class cTab_TAD_notification: cTab_RscText_TAD {
    idc = IDC_CTAB_NOTIFICATION;
    x = QUOTE(TAD_pixel2Screen_X(TAD_mapContent_px_X + (TAD_mapContent_px_W * 0.2) / 2));
    y = QUOTE(TAD_pixel2Screen_Y(OSD_edge_px_B - OSD_elementBase_size_px_H * 3));
    w = QUOTE(TAD_pixel2Screen_W(TAD_mapContent_px_W * 0.8));
    colorText[] = COLOR_NAVYBLUE;
    colorBackground[] = COLOR_WHITE;
};
