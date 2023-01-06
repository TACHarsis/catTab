#include "..\shared\cTab_base_gui_classes.hpp"

// Background definition
#define FBCB2_BackgroundImage_px_W 2048 // width in pixels
#define FBCB2_BackgroundImage_px_H 2048 // hight in pixels

// Base macros to convert pixel space to screen space
#define FBCB2_pixel2Screen_X(PIXEL) (PIXEL) / FBCB2_BackgroundImage_px_W * CUSTOM_GRID_WAbs + CUSTOM_GRID_X
#define FBCB2_pixel2Screen_Y(PIXEL) (PIXEL) / FBCB2_BackgroundImage_px_H * CUSTOM_GRID_HAbs + CUSTOM_GRID_Y
#define FBCB2_pixel2Screen_W(PIXEL) (PIXEL) / FBCB2_BackgroundImage_px_W * CUSTOM_GRID_WAbs
#define FBCB2_pixel2Screen_H(PIXEL) (PIXEL) / FBCB2_BackgroundImage_px_H * CUSTOM_GRID_HAbs

// Map position within background, pixel based
#define FBCB2_mapRect_px_X (685)
#define FBCB2_mapRect_px_Y (608)
#define FBCB2_mapRect_px_W (810)
#define FBCB2_mapRect_px_H (810)

// Height of header and footer OSD elements
#define OSD_header_px_H (44)
#define OSD_footer_px_H (0)

// On-screen edge positions (left, right, top, bottom)
#define OSD_margin_px (15)
#define OSD_edge_px_L (OSD_margin_px + SCREEN_contentRect_px_X)
#define OSD_edge_px_R (-OSD_margin_px + SCREEN_contentRect_px_X + SCREEN_contentRect_px_W)
#define OSD_edge_px_T (OSD_margin_px + SCREEN_contentRect_px_Y)
#define OSD_edge_px_B (-OSD_footer_px_H + FBCB2_mapRect_px_Y + FBCB2_mapRect_px_H)

// On-screen element base width and height
#define OSD_elementBase_size_px_W ((SCREEN_contentRect_px_W - OSD_margin_px * 6) / 5)
#define OSD_elementBase_size_px_H (OSD_header_px_H - OSD_margin_px)

// On-screen element X-coord for left, center and right elements
#define OSD_element_left_px_X (OSD_edge_px_L)
#define OSD_element_center_px_X (OSD_edge_px_L + OSD_margin_px + OSD_elementBase_size_px_W)
#define OSD_element_right_px_X (OSD_edge_px_R - OSD_elementBase_size_px_W)

// On-screen element X-coord for left, center and right elements
#define OSD_element_px_X(ITEM) (OSD_edge_px_L + (OSD_margin_px + OSD_elementBase_size_px_W) * (ITEM - 1))

// On-screen text sizes, hight in pixels
// Standard text elements
#define OSD_elementBase_textSize_px (24)
#define OSD_elementBase_iconSize_px (28.5)

// On-screen map centre cursor
#define CURSOR_size_px (76)

// Screen content (the stuff that changes, so map area - header and footer)
#define SCREEN_contentRect_px_X (FBCB2_mapRect_px_X)
#define SCREEN_contentRect_px_Y (FBCB2_mapRect_px_Y + OSD_header_px_H)
#define SCREEN_contentRect_px_W (FBCB2_mapRect_px_W)
#define SCREEN_contentRect_px_H (FBCB2_mapRect_px_H - OSD_header_px_H - OSD_footer_px_H)

// Base macros to convert pixel space to screen space, but for groups (same size as map)
#define FBCB2_pixel2GroupRect_X(PIXEL) (((PIXEL) - SCREEN_contentRect_px_X) / FBCB2_BackgroundImage_px_W * CUSTOM_GRID_WAbs)
#define FBCB2_pixel2GroupRect_Y(PIXEL) (((PIXEL) - SCREEN_contentRect_px_Y) / FBCB2_BackgroundImage_px_H * CUSTOM_GRID_HAbs)


// Message element positions in pixels
#define SCREEN_messages_margin_outer_px (10)
#define SCREEN_messages_margin_inner_px (5)

#define SCREEN_messages_button_px_W (90)
#define SCREEN_messages_button_H (30)

#define SCREEN_messages_read_frame_px_X (SCREEN_contentRect_px_X + SCREEN_messages_margin_outer_px)
#define SCREEN_messages_read_frame_px_Y (SCREEN_contentRect_px_Y + SCREEN_messages_margin_inner_px)
#define SCREEN_messages_read_frame_px_W (SCREEN_contentRect_px_W - SCREEN_messages_margin_outer_px * 2)
#define SCREEN_messages_read_frame_px_H ((SCREEN_contentRect_px_H - SCREEN_messages_margin_inner_px * 3) / 2)

#define SCREEN_messages_read_list_px_X (SCREEN_messages_read_frame_px_X + SCREEN_messages_margin_inner_px)
#define SCREEN_messages_read_list_px_Y (SCREEN_messages_read_frame_px_Y + SCREEN_messages_margin_outer_px)
#define SCREEN_messages_read_list_px_W ((SCREEN_messages_read_frame_px_W - SCREEN_messages_margin_inner_px * 3) / 3)
#define SCREEN_messages_read_list_px_H (SCREEN_messages_read_frame_px_H - SCREEN_messages_margin_inner_px - SCREEN_messages_margin_outer_px)

#define SCREEN_messages_read_text_px_X (SCREEN_messages_read_list_px_X + SCREEN_messages_read_list_px_W + SCREEN_messages_margin_inner_px)
#define SCREEN_messages_read_text_px_Y (SCREEN_messages_read_list_px_Y)
#define SCREEN_messages_read_text_px_W (SCREEN_messages_read_list_px_W * 2)
#define SCREEN_messages_read_text_px_H (SCREEN_messages_read_list_px_H - SCREEN_messages_margin_inner_px - SCREEN_messages_button_H)

#define SCREEN_messages_compose_frame_px_X (SCREEN_messages_read_frame_px_X)
#define SCREEN_messages_compose_frame_px_Y (SCREEN_messages_read_frame_px_Y + SCREEN_messages_read_frame_px_H + SCREEN_messages_margin_inner_px)
#define SCREEN_messages_compose_frame_px_W (SCREEN_messages_read_frame_px_W)
#define SCREEN_messages_compose_frame_px_H (SCREEN_messages_read_frame_px_H)

#define SCREEN_messages_compose_list_px_X (SCREEN_messages_read_list_px_X)
#define SCREEN_messages_compose_list_px_Y (SCREEN_messages_compose_frame_px_Y + SCREEN_messages_margin_outer_px)
#define SCREEN_messages_compose_list_px_W (SCREEN_messages_read_list_px_W)
#define SCREEN_messages_compose_list_px_H (SCREEN_messages_read_list_px_H)

#define SCREEN_messages_compose_text_px_X (SCREEN_messages_read_text_px_X)
#define SCREEN_messages_compose_text_px_Y (SCREEN_messages_compose_list_px_Y)
#define SCREEN_messages_compose_text_px_W (SCREEN_messages_read_text_px_W)
#define SCREEN_messages_compose_text_px_H (SCREEN_messages_read_text_px_H)

#define SCREEN_messages_button_send_px_X (SCREEN_messages_compose_frame_px_X + SCREEN_messages_compose_frame_px_W - SCREEN_messages_margin_inner_px - SCREEN_messages_button_px_W)
#define SCREEN_messages_button_send_px_Y (SCREEN_messages_compose_text_px_Y + SCREEN_messages_compose_text_px_H + SCREEN_messages_margin_inner_px)

#define SCREEN_messages_button_delete_px_X (SCREEN_messages_button_send_px_X)
#define SCREEN_messages_button_delete_px_Y (SCREEN_messages_read_text_px_Y + SCREEN_messages_read_text_px_H + SCREEN_messages_margin_inner_px)

class cTab_RscText_FBCB2: cTab_RscText {
    style = ST_CENTER;
    w = QUOTE(FBCB2_pixel2Screen_W(OSD_elementBase_size_px_W));
    h = QUOTE(FBCB2_pixel2Screen_H(OSD_elementBase_size_px_H));
    font = QUOTE(GUI_FONT_MONO);
    colorText[] = COLOR_WHITE;
    sizeEx = QUOTE(FBCB2_pixel2Screen_H(OSD_elementBase_textSize_px));
    colorBackground[] = COLOR_TRANSPARENT;
    shadow = 0;
};
class cTab_RscListbox_FBCB2: cTab_RscListbox {
    sizeEx = QUOTE(FBCB2_pixel2Screen_H(OSD_elementBase_textSize_px * 1.2));
};
class cTab_RscEdit_FBCB2: cTab_RscEdit {
    sizeEx = QUOTE(FBCB2_pixel2Screen_H(OSD_elementBase_textSize_px * 1.2));
};
class cTab_RscButton_FBCB2: cTab_RscButton {
    font = QUOTE(GUI_FONT_MONO);
    sizeEx = QUOTE(FBCB2_pixel2Screen_H(OSD_elementBase_textSize_px));
};
class cTab_FBCB2_background: cTab_RscPicture {
    idc = IDC_CTAB_BACKGROUND;
    text = QPATHTOEF(data,img\ui\display_frames\FBCB2.paa);
    x = QUOTE(CUSTOM_GRID_X);
    y = QUOTE(CUSTOM_GRID_Y);
    w = QUOTE(CUSTOM_GRID_WAbs);
    h = QUOTE(CUSTOM_GRID_HAbs);
};
class cTab_FBCB2_header: cTab_RscPicture {
    idc = 1;
    text = "#(argb,8,8,3)color(0,0,0,1)";
    x = QUOTE(FBCB2_pixel2Screen_X(FBCB2_mapRect_px_X));
    y = QUOTE(FBCB2_pixel2Screen_Y(FBCB2_mapRect_px_Y));
    w = QUOTE(FBCB2_pixel2Screen_W(FBCB2_mapRect_px_W));
    h = QUOTE(FBCB2_pixel2Screen_H(OSD_header_px_H));
};
class cTab_FBCB2_on_screen_battery: cTab_RscPicture {
    idc = 2;
    text = QPATHTOEF(data,img\ui\icon_battery_ca.paa);
    x = QUOTE(FBCB2_pixel2Screen_X(OSD_element_px_X(1)));
    y = QUOTE(FBCB2_pixel2Screen_Y(FBCB2_mapRect_px_Y + (OSD_header_px_H - OSD_elementBase_iconSize_px) / 2));
    w = QUOTE(FBCB2_pixel2Screen_W(OSD_elementBase_iconSize_px));
    h = QUOTE(FBCB2_pixel2Screen_H(OSD_elementBase_iconSize_px));
    colorText[] = COLOR_WHITE;
};
class cTab_FBCB2_on_screen_time: cTab_RscText_FBCB2 {
    idc = IDC_CTAB_OSD_TIME;
    style = ST_CENTER;
    x = QUOTE(FBCB2_pixel2Screen_X(OSD_element_px_X(3)));
    y = QUOTE(FBCB2_pixel2Screen_Y(FBCB2_mapRect_px_Y + (OSD_header_px_H - OSD_elementBase_textSize_px) / 2));
};
class cTab_FBCB2_on_screen_signalStrength: cTab_FBCB2_on_screen_battery {
    idc = 3;
    text = QPATHTOEF(data,img\ui\icon_signalStrength_ca.paa);
    x = QUOTE(FBCB2_pixel2Screen_X(OSD_element_px_X(5) + OSD_elementBase_size_px_W - OSD_elementBase_iconSize_px * 2));
    colorText[] = COLOR_WHITE;
};
class cTab_FBCB2_on_screen_satellite: cTab_FBCB2_on_screen_battery {
    idc = 4;
    text = "\a3\ui_f\data\map\Diary\signal_ca.paa";
    x = QUOTE(FBCB2_pixel2Screen_X(OSD_element_px_X(5) + OSD_elementBase_size_px_W - OSD_elementBase_iconSize_px));
    colorText[] = COLOR_WHITE;
};
class cTab_FBCB2_on_screen_dirDegree: cTab_FBCB2_on_screen_time {
    idc = IDC_CTAB_OSD_DIR_DEGREE;
    style = ST_LEFT;
    x = QUOTE(FBCB2_pixel2Screen_X(OSD_element_px_X(2)));
};
class cTab_FBCB2_on_screen_grid: cTab_FBCB2_on_screen_dirDegree {
    idc = IDC_CTAB_OSD_GRID;
    style = ST_RIGHT;
    x = QUOTE(FBCB2_pixel2Screen_X(OSD_element_px_X(4)));
};
class cTab_FBCB2_on_screen_dirOctant: cTab_FBCB2_on_screen_dirDegree {
    idc = IDC_CTAB_OSD_DIR_OCTANT;
    style = ST_RIGHT;
    x = QUOTE(FBCB2_pixel2Screen_X(OSD_element_px_X(1)));
};
class cTab_FBCB2_btnF1: cTab_RscButtonInv {
    x = QUOTE(FBCB2_pixel2Screen_X(762));
    y = QUOTE(FBCB2_pixel2Screen_Y(1452));
    w = QUOTE(FBCB2_pixel2Screen_W(70));
    h = QUOTE(FBCB2_pixel2Screen_H(40));
};
class cTab_FBCB2_btnF2: cTab_FBCB2_btnF1 {
    x = QUOTE(FBCB2_pixel2Screen_X(846));
};
class cTab_FBCB2_btnF3: cTab_FBCB2_btnF1 {
    x = QUOTE(FBCB2_pixel2Screen_X(929));
};
class cTab_FBCB2_btnF4: cTab_FBCB2_btnF1 {
    x = QUOTE(FBCB2_pixel2Screen_X(1013));
};
class cTab_FBCB2_btnF5: cTab_FBCB2_btnF1 {
    x = QUOTE(FBCB2_pixel2Screen_X(1097));
};
class cTab_FBCB2_btnF6: cTab_FBCB2_btnF1 {
    x = QUOTE(FBCB2_pixel2Screen_X(1180));
};
class cTab_FBCB2_btnF7: cTab_FBCB2_btnF1 {
    x = QUOTE(FBCB2_pixel2Screen_X(1264));
};
class cTab_FBCB2_btnF8: cTab_FBCB2_btnF1 {
    x = QUOTE(FBCB2_pixel2Screen_X(1349));
};
class cTab_FBCB2_btnPWR: cTab_RscButtonInv {
    x = QUOTE(FBCB2_pixel2Screen_X(592));
    y = QUOTE(FBCB2_pixel2Screen_Y(603));
    w = QUOTE(FBCB2_pixel2Screen_W(40));
    h = QUOTE(FBCB2_pixel2Screen_H(70));
};
class cTab_FBCB2_btnBRTplus: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(680));
};
class cTab_FBCB2_btnBRTminus: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(759));
};
class cTab_FBCB2_btnBLKOUT: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(839));
};
class cTab_FBCB2_btnESC: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(918));
};
class cTab_FBCB2_btnRight: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(998));
};
class cTab_FBCB2_btnUp: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(1079));
};
class cTab_FBCB2_btnDown: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(1161));
};
class cTab_FBCB2_btnENT: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(1241));
};
class cTab_FBCB2_btnFCN: cTab_FBCB2_btnPWR {
    y = QUOTE(FBCB2_pixel2Screen_Y(1322));
};
class cTab_FBCB2_on_screen_hookGrid: cTab_RscText_FBCB2 {
    idc = IDC_CTAB_OSD_HOOK_GRID;
    style = ST_CENTER;
    x = QUOTE(FBCB2_pixel2Screen_X(OSD_element_right_px_X));
    y = QUOTE(FBCB2_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 4));
    colorText[] = {1,1,1,0.5};
    colorBackground[] = {0,0,0,0.25};
};
class cTab_FBCB2_on_screen_hookElevation: cTab_FBCB2_on_screen_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_ELEVATION;
    y = QUOTE(FBCB2_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 3));
};
class cTab_FBCB2_on_screen_hookDst: cTab_FBCB2_on_screen_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_DST;
    y = QUOTE(FBCB2_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 2));
};
class cTab_FBCB2_on_screen_hookDir: cTab_FBCB2_on_screen_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_DIR;
    y = QUOTE(FBCB2_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H));
};
class cTab_FBCB2_loadingtxt: cTab_RscText_FBCB2 {
    idc = IDC_CTAB_LOADINGTXT;
    style = ST_CENTER;
    text = "Loading"; //--- ToDo: Localize;
    x = QUOTE(FBCB2_pixel2Screen_X(SCREEN_contentRect_px_X));
    y = QUOTE(FBCB2_pixel2Screen_Y(SCREEN_contentRect_px_Y));
    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_contentRect_px_W));
    h = QUOTE(FBCB2_pixel2Screen_H(SCREEN_contentRect_px_H));
    colorBackground[] = COLOR_BLACK;
};
class cTab_FBCB2_notification: cTab_RscText_FBCB2 {
    idc = IDC_CTAB_NOTIFICATION;
    x = QUOTE(FBCB2_pixel2Screen_X(SCREEN_contentRect_px_X + (SCREEN_contentRect_px_W * 0.2) / 2));
    y = QUOTE(FBCB2_pixel2Screen_Y(SCREEN_contentRect_px_Y + SCREEN_contentRect_px_H - 2 * OSD_elementBase_textSize_px));
    w = QUOTE(FBCB2_pixel2Screen_W(SCREEN_contentRect_px_W * 0.8));
    colorBackground[] = COLOR_BLACK;
};
