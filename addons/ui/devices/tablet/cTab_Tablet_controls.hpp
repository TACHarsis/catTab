//#include "..\shared\cTab_base_gui_classes.hpp"

// Background definition
#define TABLET_BackgroundImage_px_W 2048 // width in pixels
#define TABLET_BackgroundImage_px_H 2048 // hight in pixels

// Base macros to convert pixel space to screen space
#define TABLET_pixel2Screen_X(PIXEL) (PIXEL) / TABLET_BackgroundImage_px_W * CUSTOM_GRID_WAbs + CUSTOM_GRID_X
#define TABLET_pixel2Screen_Y(PIXEL) (PIXEL) / TABLET_BackgroundImage_px_H * CUSTOM_GRID_HAbs + CUSTOM_GRID_Y
#define TABLET_pixel2Screen_W(PIXEL) (PIXEL) / TABLET_BackgroundImage_px_W * CUSTOM_GRID_WAbs
#define TABLET_pixel2Screen_H(PIXEL) (PIXEL) / TABLET_BackgroundImage_px_H * CUSTOM_GRID_HAbs

// Map position within background, pixel based
#define TABLET_mapRect_px_X (257)
#define TABLET_mapRect_px_Y (491)
#define TABLET_mapRect_px_W (1341)
#define TABLET_mapRect_px_H (993)

// Height of header and footer OSD elements
#undef OSD_header_px_H
#undef OSD_footer_px_H
#define OSD_header_px_H (42)
#define OSD_footer_px_H (0)

// On-screen edge positions (left, right, top, bottom)
#undef OSD_margin_px
#undef OSD_edge_px_L
#undef OSD_edge_px_R
#undef OSD_edge_px_T
#undef OSD_edge_px_B
#define OSD_margin_px (10)
#define OSD_edge_px_L (OSD_margin_px + SCREEN_contentRect_px_X)
#define OSD_edge_px_R (-OSD_margin_px + SCREEN_contentRect_px_X + SCREEN_contentRect_px_W)
#define OSD_edge_px_T (OSD_margin_px + SCREEN_contentRect_px_Y)
#define OSD_edge_px_B (-OSD_footer_px_H + TABLET_mapRect_px_Y + TABLET_mapRect_px_H)

// On-screen element base width and height
#undef OSD_elementBase_size_px_W
#undef OSD_elementBase_size_px_H
#define OSD_elementBase_size_px_W ((SCREEN_contentRect_px_W - OSD_margin_px * 8) / 7)
#define OSD_elementBase_size_px_H (OSD_header_px_H - OSD_margin_px)

// On-screen element X-coord for left, center and right elements
#undef OSD_element_left_px_X
#undef OSD_element_center_px_X
#undef OSD_element_right_px_X
#define OSD_element_left_px_X (OSD_edge_px_L)
#define OSD_element_center_px_X (OSD_edge_px_L + OSD_margin_px + OSD_elementBase_size_px_W)
#define OSD_element_right_px_X (OSD_edge_px_R - OSD_elementBase_size_px_W)

// On-screen element X-coord for left, center and right elements
#undef OSD_element_px_X
#define OSD_element_px_X(ITEM) (OSD_edge_px_L + (OSD_margin_px + OSD_elementBase_size_px_W) * (ITEM - 1))

// On-screen text sizes, hight in pixels
// Standard text elements
#undef OSD_elementBase_textSize_px
#undef OSD_elementBase_iconSize_px
#define OSD_elementBase_textSize_px (27)
#define OSD_elementBase_iconSize_px (35)

// Screen content (the stuff that changes, so map area minus header and footer)
#undef SCREEN_contentRect_px_X
#undef SCREEN_contentRect_px_Y
#undef SCREEN_contentRect_px_W
#undef SCREEN_contentRect_px_H
#define SCREEN_contentRect_px_X (TABLET_mapRect_px_X)
#define SCREEN_contentRect_px_Y (TABLET_mapRect_px_Y + OSD_header_px_H)
#define SCREEN_contentRect_px_W (TABLET_mapRect_px_W)
#define SCREEN_contentRect_px_H (TABLET_mapRect_px_H - OSD_header_px_H)

// Base macros to convert pixel space to screen space, but for groups (same size as map)
#define TABLET_pixel2GroupRect_X(PIXEL) (((PIXEL) - SCREEN_contentRect_px_X) / TABLET_BackgroundImage_px_W * CUSTOM_GRID_WAbs)
#define TABLET_pixel2GroupRect_Y(PIXEL) (((PIXEL) - SCREEN_contentRect_px_Y) / TABLET_BackgroundImage_px_H * CUSTOM_GRID_HAbs)

// Task bar absolute size, pixel based (from source)
#define TASKBAR_image_px_W (1024)
#define TASKBAR_image_px_H (28)

// Translate task bar size to pixel based size in background
#define TASKBAR_area_px_W (TABLET_mapRect_px_W)
#define TASKBAR_area_px_H (TASKBAR_area_px_W / TASKBAR_image_px_W * TASKBAR_image_px_H)

// Set task bar position at the bottom of the screen area
#define TASKBAR_area_px_X (TABLET_mapRect_px_X)
#define TASKBAR_area_px_Y (TABLET_mapRect_px_Y + TABLET_mapRect_px_H - TASKBAR_area_px_H)

// Window background (application windows) absolute size, pixel based (from source)
#define WINDOW_SMALL_image_px_W (256)
#define WINDOW_SMALL_image_px_H (256)

// Window content (application windows) position within window background, pixel based
#define WINDOW_SMALL_image_contentRect_px_X (8)
#define WINDOW_SMALL_image_contentRect_px_Y (29)
#define WINDOW_SMALL_image_contentRect_px_W (242)
#define WINDOW_SMALL_image_contentRect_px_H (218)

// Translate window background size to pixel based position in background (heigth is 49 % of tablet screen height)
#define WINDOW_SMALL_px_H ((SCREEN_contentRect_px_H - TASKBAR_area_px_H) * 0.49)
#define WINDOW_SMALL_px_W (WINDOW_SMALL_image_px_W / WINDOW_SMALL_image_px_H * WINDOW_SMALL_px_H)

// Translate window content size to pixel based position in background
#define WINDOW_SMALL_contentRect_px_W (WINDOW_SMALL_image_contentRect_px_W / WINDOW_SMALL_image_px_W * WINDOW_SMALL_px_W)
#define WINDOW_SMALL_contentRect_px_H (WINDOW_SMALL_image_contentRect_px_H / WINDOW_SMALL_image_px_H * WINDOW_SMALL_px_H)

// Translate window content offsets (from edges of window background) to pixel based positions in background
#define WINDOW_SMALL_contentArea_OFFSET_px_X (WINDOW_SMALL_image_contentRect_px_X / WINDOW_SMALL_image_px_W * WINDOW_SMALL_px_W)
#define WINDOW_SMALL_contentArea_OFFSET_px_Y (WINDOW_SMALL_image_contentRect_px_Y / WINDOW_SMALL_image_px_H * WINDOW_SMALL_px_H)

// Distribute window backgrounds evenly on the available screen space for 2x2 windows
#define WINDOW_SMALL_OFFSET_L_px_X (SCREEN_contentRect_px_X + (SCREEN_contentRect_px_W - 2 * WINDOW_SMALL_px_W) / 3)
#define WINDOW_SMALL_OFFSET_R_px_X (SCREEN_contentRect_px_X + WINDOW_SMALL_px_W + (SCREEN_contentRect_px_W - 2 * WINDOW_SMALL_px_W) / 3 * 2)
#define WINDOW_SMALL_OFFSET_T_px_Y (SCREEN_contentRect_px_Y + (SCREEN_contentRect_px_H - TASKBAR_area_px_H - 2 * WINDOW_SMALL_px_H) / 3)
#define WINDOW_SMALL_OFFSET_B_px_Y (SCREEN_contentRect_px_Y + WINDOW_SMALL_px_H + (SCREEN_contentRect_px_H - TASKBAR_area_px_H - 2 * WINDOW_SMALL_px_H) / 3 * 2)

// Place window content within window background
#define WINDOW_SMALL_contentRect_px_L_X (WINDOW_SMALL_OFFSET_L_px_X + WINDOW_SMALL_contentArea_OFFSET_px_X)
#define WINDOW_SMALL_contentRect_px_R_X (WINDOW_SMALL_OFFSET_R_px_X + WINDOW_SMALL_contentArea_OFFSET_px_X)
#define WINDOW_SMALL_contentRect_px_T_Y (WINDOW_SMALL_OFFSET_T_px_Y + WINDOW_SMALL_contentArea_OFFSET_px_Y)
#define WINDOW_SMALL_contentRect_px_B_Y (WINDOW_SMALL_OFFSET_B_px_Y + WINDOW_SMALL_contentArea_OFFSET_px_Y)

// Desktop icon size and offset from tablet screen edge in pixels
#define SCREEN_icon_OFFSET_px_X (25)
#define SCREEN_icon_OFFSET_px_Y (25)
#define SCREEN_icon_px_W (100)
#define SCREEN_icon_px_H (100)

// Message element positions in pixels
#undef SCREEN_messages_margin_outer_px
#undef SCREEN_messages_margin_inner_px
#define SCREEN_messages_margin_outer_px (20)
#define SCREEN_messages_margin_inner_px (10)

#undef SCREEN_messages_button_px_W
#undef SCREEN_messages_button_H
#define SCREEN_messages_button_px_W (150)
#define SCREEN_messages_button_H (50)

#undef SCREEN_messages_read_frame_px_X
#undef SCREEN_messages_read_frame_px_Y
#undef SCREEN_messages_read_frame_px_W
#undef SCREEN_messages_read_frame_px_H
#define SCREEN_messages_read_frame_px_X (SCREEN_contentRect_px_X + SCREEN_messages_margin_outer_px)
#define SCREEN_messages_read_frame_px_Y (SCREEN_contentRect_px_Y + SCREEN_messages_margin_inner_px)
#define SCREEN_messages_read_frame_px_W (SCREEN_contentRect_px_W - SCREEN_messages_margin_outer_px * 2)
#define SCREEN_messages_read_frame_px_H ((SCREEN_contentRect_px_H - TASKBAR_area_px_H - SCREEN_messages_margin_inner_px * 3) / 2)

#undef SCREEN_messages_read_list_px_X
#undef SCREEN_messages_read_list_px_Y
#undef SCREEN_messages_read_list_px_W
#undef SCREEN_messages_read_list_px_H
#define SCREEN_messages_read_list_px_X (SCREEN_messages_read_frame_px_X + SCREEN_messages_margin_inner_px)
#define SCREEN_messages_read_list_px_Y (SCREEN_messages_read_frame_px_Y + SCREEN_messages_margin_outer_px)
#define SCREEN_messages_read_list_px_W ((SCREEN_messages_read_frame_px_W - SCREEN_messages_margin_inner_px * 3) / 3)
#define SCREEN_messages_read_list_px_H (SCREEN_messages_read_frame_px_H - SCREEN_messages_margin_inner_px - SCREEN_messages_margin_outer_px)

#undef SCREEN_messages_read_text_px_X
#undef SCREEN_messages_read_text_px_Y
#undef SCREEN_messages_read_text_px_W
#undef SCREEN_messages_read_text_px_H
#define SCREEN_messages_read_text_px_X (SCREEN_messages_read_list_px_X + SCREEN_messages_read_list_px_W + SCREEN_messages_margin_inner_px)
#define SCREEN_messages_read_text_px_Y (SCREEN_messages_read_list_px_Y)
#define SCREEN_messages_read_text_px_W (SCREEN_messages_read_list_px_W * 2)
#define SCREEN_messages_read_text_px_H (SCREEN_messages_read_list_px_H - SCREEN_messages_margin_inner_px - SCREEN_messages_button_H)

#undef SCREEN_messages_compose_frame_px_X
#undef SCREEN_messages_compose_frame_px_Y
#undef SCREEN_messages_compose_frame_px_W
#undef SCREEN_messages_compose_frame_px_H
#define SCREEN_messages_compose_frame_px_X (SCREEN_messages_read_frame_px_X)
#define SCREEN_messages_compose_frame_px_Y (SCREEN_messages_read_frame_px_Y + SCREEN_messages_read_frame_px_H + SCREEN_messages_margin_inner_px)
#define SCREEN_messages_compose_frame_px_W (SCREEN_messages_read_frame_px_W)
#define SCREEN_messages_compose_frame_px_H (SCREEN_messages_read_frame_px_H)

#undef SCREEN_messages_compose_list_px_X
#undef SCREEN_messages_compose_list_px_Y
#undef SCREEN_messages_compose_list_px_W
#undef SCREEN_messages_compose_list_px_H
#define SCREEN_messages_compose_list_px_X (SCREEN_messages_read_list_px_X)
#define SCREEN_messages_compose_list_px_Y (SCREEN_messages_compose_frame_px_Y + SCREEN_messages_margin_outer_px)
#define SCREEN_messages_compose_list_px_W (SCREEN_messages_read_list_px_W)
#define SCREEN_messages_compose_list_px_H (SCREEN_messages_read_list_px_H)

#undef SCREEN_messages_compose_text_px_X
#undef SCREEN_messages_compose_text_px_Y
#undef SCREEN_messages_compose_text_px_W
#undef SCREEN_messages_compose_text_px_H
#define SCREEN_messages_compose_text_px_X (SCREEN_messages_read_text_px_X)
#define SCREEN_messages_compose_text_px_Y (SCREEN_messages_compose_list_px_Y)
#define SCREEN_messages_compose_text_px_W (SCREEN_messages_read_text_px_W)
#define SCREEN_messages_compose_text_px_H (SCREEN_messages_read_text_px_H)

#undef SCREEN_messages_button_send_px_X
#undef SCREEN_messages_button_send_px_Y
#define SCREEN_messages_button_send_px_X (SCREEN_messages_compose_frame_px_X + SCREEN_messages_compose_frame_px_W - SCREEN_messages_margin_inner_px - SCREEN_messages_button_px_W)
#define SCREEN_messages_button_send_px_Y (SCREEN_messages_compose_text_px_Y + SCREEN_messages_compose_text_px_H + SCREEN_messages_margin_inner_px)

#undef SCREEN_messages_button_delete_px_X

#define SCREEN_messages_button_delete_px_X (SCREEN_messages_button_send_px_X)
#define SCREEN_messages_button_delete_px_Y (SCREEN_messages_read_text_px_Y + SCREEN_messages_read_text_px_H + SCREEN_messages_margin_inner_px)

class cTab_RscText_Tablet: cTab_RscText {
    style = ST_CENTER;
    w = QUOTE(TABLET_pixel2Screen_W(OSD_elementBase_size_px_W));
    h = QUOTE(TABLET_pixel2Screen_H(OSD_elementBase_size_px_H));
    font = QUOTE(GUI_FONT_MONO);
    colorText[] = COLOR_WHITE;
    sizeEx = QUOTE(TABLET_pixel2Screen_H(OSD_elementBase_textSize_px));
    colorBackground[] = COLOR_TRANSPARENT;
    shadow = 0;
};
class cTab_RscListBox_Tablet: cTab_RscListBox {
    sizeEx = QUOTE(TABLET_pixel2Screen_H(OSD_elementBase_textSize_px * 0.8));
};
class cTab_RscCombo_Tablet: cTab_RscCombo {
    sizeEx = QUOTE(TABLET_pixel2Screen_H(OSD_elementBase_textSize_px * 0.8));
};
class cTab_RscEdit_Tablet: cTab_RscEdit {
    sizeEx = QUOTE(TABLET_pixel2Screen_H(OSD_elementBase_textSize_px * 1.2));
};
class cTab_RscButton_Tablet: cTab_RscButton {
    font = QUOTE(GUI_FONT_MONO);
    sizeEx = QUOTE(TABLET_pixel2Screen_H(OSD_elementBase_textSize_px));
};

class Ctab_RscButton_Tablet_VideoToggle : cTab_RscButton{
    colorBackground[] = {0.118, 0.118, 0.118, 0.3};
    colorBackgroundActive[] = {0.118, 0.118, 0.118, 0.3};
    colorFocused[] = {0.118, 0.118, 0.118, 0.3};
    colorText[] = {1, 1, 1, 0.3};
    colorShadow[] = {0, 0, 0, 0.03};
};

class cTab_Tablet_background: cTab_RscPicture {
    idc = IDC_CTAB_BACKGROUND;
    text = "";
    x = QUOTE(CUSTOM_GRID_X);
    y = QUOTE(CUSTOM_GRID_Y);
    w = QUOTE(CUSTOM_GRID_WAbs);
    h = QUOTE(CUSTOM_GRID_HAbs);
};
class cTab_tablet_header: cTab_RscPicture {
    idc = 1;
    text = "#(argb,8,8,3)color(0,0,0,1)";
    x = QUOTE(TABLET_pixel2Screen_X(TABLET_mapRect_px_X));
    y = QUOTE(TABLET_pixel2Screen_Y(TABLET_mapRect_px_Y));
    w = QUOTE(TABLET_pixel2Screen_W(TABLET_mapRect_px_W));
    h = QUOTE(TABLET_pixel2Screen_H(OSD_header_px_H));
};
class cTab_Tablet_OSD_battery: cTab_RscPicture {
    idc = 2;
    text = QPATHTOEF(data,img\ui\icon_battery_ca.paa);
    x = QUOTE(TABLET_pixel2Screen_X(OSD_element_px_X(1)));
    y = QUOTE(TABLET_pixel2Screen_Y(TABLET_mapRect_px_Y + (OSD_header_px_H - OSD_elementBase_iconSize_px) / 2));
    w = QUOTE(TABLET_pixel2Screen_W(OSD_elementBase_iconSize_px));
    h = QUOTE(TABLET_pixel2Screen_H(OSD_elementBase_iconSize_px));
    colorText[] = COLOR_WHITE;
};
class cTab_Tablet_OSD_time: cTab_RscText_Tablet {
    idc = IDC_CTAB_OSD_TIME;
    style = ST_CENTER;
    x = QUOTE(TABLET_pixel2Screen_X(OSD_element_px_X(4)));
    y = QUOTE(TABLET_pixel2Screen_Y(TABLET_mapRect_px_Y + (OSD_header_px_H - OSD_elementBase_textSize_px) / 2));
};
class cTab_Tablet_OSD_signalStrength: cTab_Tablet_OSD_battery {
    idc = 3;
    text = QPATHTOEF(data,img\ui\icon_signalStrength_ca.paa);
    x = QUOTE(TABLET_pixel2Screen_X(OSD_element_px_X(7) + OSD_elementBase_size_px_W - OSD_elementBase_iconSize_px * 2));
    colorText[] = COLOR_WHITE;
};
class cTab_Tablet_OSD_satellite: cTab_Tablet_OSD_battery {
    idc = 4;
    text = "\a3\ui_f\data\map\Diary\signal_ca.paa";
    x = QUOTE(TABLET_pixel2Screen_X(OSD_element_px_X(7) + OSD_elementBase_size_px_W - OSD_elementBase_iconSize_px));
    colorText[] = COLOR_WHITE;
};
class cTab_Tablet_OSD_dirDegree: cTab_Tablet_OSD_time {
    idc = IDC_CTAB_OSD_DIR_DEGREE;
    style = ST_LEFT;
    x = QUOTE(TABLET_pixel2Screen_X(OSD_element_px_X(2)));
};
class cTab_Tablet_OSD_grid: cTab_Tablet_OSD_dirDegree {
    idc = IDC_CTAB_OSD_GRID;
    style = ST_RIGHT;
    x = QUOTE(TABLET_pixel2Screen_X(OSD_element_px_X(6)));
};
class cTab_Tablet_OSD_dirOctant: cTab_Tablet_OSD_dirDegree {
    idc = IDC_CTAB_OSD_DIR_OCTANT;
    style = ST_RIGHT;
    x = QUOTE(TABLET_pixel2Screen_X(OSD_element_px_X(1)));
};
class cTab_Tablet_window_back_TL: cTab_RscPicture {
    text = QPATHTOEF(data,img\ui\desktop\classic\window_small_ca.paa);
    x = QUOTE(TABLET_pixel2Screen_X(WINDOW_SMALL_OFFSET_L_px_X));
    y = QUOTE(TABLET_pixel2Screen_Y(WINDOW_SMALL_OFFSET_T_px_Y));
    w = QUOTE(TABLET_pixel2Screen_W(WINDOW_SMALL_px_W));
    h = QUOTE(TABLET_pixel2Screen_H(WINDOW_SMALL_px_H));
};
class cTab_Tablet_window_back_BL: cTab_Tablet_window_back_TL {
    y = QUOTE(TABLET_pixel2Screen_Y(WINDOW_SMALL_OFFSET_B_px_Y));
};
class cTab_Tablet_window_back_TR: cTab_Tablet_window_back_TL {
    x = QUOTE(TABLET_pixel2Screen_X(WINDOW_SMALL_OFFSET_R_px_X));
};
class cTab_Tablet_window_back_BR: cTab_Tablet_window_back_TR {
    y = QUOTE(TABLET_pixel2Screen_Y(WINDOW_SMALL_OFFSET_B_px_Y));
};
class cTab_Tablet_btnF1: cTab_RscButtonInv {
    x = QUOTE(TABLET_pixel2Screen_X(506));
    y = QUOTE(TABLET_pixel2Screen_Y(1545));
    w = QUOTE(TABLET_pixel2Screen_W(52));
    h = QUOTE(TABLET_pixel2Screen_H(52));
};
class cTab_Tablet_btnF2: cTab_Tablet_btnF1 {
    x = QUOTE(TABLET_pixel2Screen_X(569));
};
class cTab_Tablet_btnF3: cTab_Tablet_btnF1 {
    x = QUOTE(TABLET_pixel2Screen_X(639));
};
class cTab_Tablet_btnF4: cTab_Tablet_btnF1 {
    x = QUOTE(TABLET_pixel2Screen_X(703));
};
class cTab_Tablet_btnF5: cTab_Tablet_btnF1 {
    x = QUOTE(TABLET_pixel2Screen_X(768));
};
class cTab_Tablet_btnF6: cTab_Tablet_btnF1 {
    x = QUOTE(TABLET_pixel2Screen_X(833));
};
class cTab_Tablet_btnFn: cTab_Tablet_btnF1 {
    x = QUOTE(TABLET_pixel2Screen_X(970));
};
class cTab_Tablet_btnPower: cTab_Tablet_btnFn {
    x = QUOTE(TABLET_pixel2Screen_X(1034));
};
class cTab_Tablet_btnBrtDn: cTab_Tablet_btnFn {
    x = QUOTE(TABLET_pixel2Screen_X(1100));
};
class cTab_Tablet_btnBrtUp: cTab_Tablet_btnFn {
    x = QUOTE(TABLET_pixel2Screen_X(1163));
};
class cTab_Tablet_btnTrackpad: cTab_Tablet_btnFn {
    x = QUOTE(TABLET_pixel2Screen_X(1262));
    y = QUOTE(TABLET_pixel2Screen_Y(1550));
    w = QUOTE(TABLET_pixel2Screen_W(48));
    h = QUOTE(TABLET_pixel2Screen_H(43));
};
class cTab_Tablet_btnMouse: cTab_Tablet_btnFn {
    x = QUOTE(TABLET_pixel2Screen_X(1401));
    w = QUOTE(TABLET_pixel2Screen_W(91));
};
class cTab_Tablet_btnHome: cTab_Tablet_btnMouse {
    x = QUOTE(TABLET_pixel2Screen_X(897));
    y = QUOTE(TABLET_pixel2Screen_Y(1534));
    w = QUOTE(TABLET_pixel2Screen_W(61));
    h = QUOTE(TABLET_pixel2Screen_H(49));
};

class cTab_Tablet_btnTiny: cTab_Tablet_btnMouse {
    x = QUOTE(TABLET_pixel2Screen_X(1353));
    y = QUOTE(TABLET_pixel2Screen_Y(1557));
    w = QUOTE(TABLET_pixel2Screen_W(28));
    h = QUOTE(TABLET_pixel2Screen_H(28));
};

class cTab_Tablet_OSD_hookGrid: cTab_RscText_Tablet {
    idc = IDC_CTAB_OSD_HOOK_GRID;
    style = ST_CENTER;
    x = QUOTE(TABLET_pixel2Screen_X(OSD_element_right_px_X));
    y = QUOTE(TABLET_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 4));
    colorText[] = {1, 1, 1, 0.5};
    colorBackground[] = {0, 0, 0, 0.25};
};
class cTab_Tablet_OSD_hookElevation: cTab_Tablet_OSD_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_ELEVATION;
    y = QUOTE(TABLET_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 3));
};
class cTab_Tablet_OSD_hookDst: cTab_Tablet_OSD_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_DST;
    y = QUOTE(TABLET_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H * 2));
};
class cTab_Tablet_OSD_hookDir: cTab_Tablet_OSD_hookGrid {
    idc = IDC_CTAB_OSD_HOOK_DIR;
    y = QUOTE(TABLET_pixel2Screen_Y(OSD_edge_px_B - OSD_margin_px - OSD_elementBase_size_px_H));
};
class cTab_Tablet_loadingtxt: cTab_RscText_Tablet {
    idc = IDC_CTAB_LOADINGTXT;
    style = ST_CENTER;
    text = "Loading"; //--- ToDo: Localize;
    x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X));
    y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y));
    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_contentRect_px_W));
    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H));
    colorBackground[] = COLOR_LIGHT_BLUE;
};
// Define areas around the screen as interaction areas to allow screen movement
class cTab_Tablet_movingHandle_T: cTab_RscText_Tablet {
    idc = 5;
    moving = 1;
    colorBackground[] = COLOR_TRANSPARENT;
    x = QUOTE(TABLET_pixel2Screen_X(0));
    y = QUOTE(TABLET_pixel2Screen_Y(0));
    w = QUOTE(TABLET_pixel2Screen_W(TABLET_BackgroundImage_px_W));
    h = QUOTE(TABLET_pixel2Screen_H(TABLET_mapRect_px_Y));
};
class cTab_Tablet_movingHandle_B: cTab_Tablet_movingHandle_T {
    idc = 6;
    y = QUOTE(TABLET_pixel2Screen_Y(TABLET_mapRect_px_Y + TABLET_mapRect_px_H));
    h = QUOTE(TABLET_pixel2Screen_H(TABLET_BackgroundImage_px_H - (TABLET_mapRect_px_Y + TABLET_mapRect_px_H)));
};
class cTab_Tablet_movingHandle_L: cTab_Tablet_movingHandle_T {
    idc = 7;
    y = QUOTE(TABLET_pixel2Screen_Y(TABLET_mapRect_px_Y));
    w = QUOTE(TABLET_pixel2Screen_W(TABLET_mapRect_px_X));
    h = QUOTE(TABLET_pixel2Screen_H(TABLET_mapRect_px_H));
};
class cTab_Tablet_movingHandle_R: cTab_Tablet_movingHandle_L {
    idc = 8;
    x = QUOTE(TABLET_pixel2Screen_X(TABLET_mapRect_px_X + TABLET_mapRect_px_W));
    w = QUOTE(TABLET_pixel2Screen_W(TABLET_BackgroundImage_px_W - (TABLET_mapRect_px_X + TABLET_mapRect_px_W)));
};

// transparent control that gets placed on top of the GUI to adjust brightness
class cTab_Tablet_brightness: cTab_RscText_Tablet {
    idc = IDC_CTAB_BRIGHTNESS;
    x = QUOTE(TABLET_pixel2Screen_X(TABLET_mapRect_px_X));
    y = QUOTE(TABLET_pixel2Screen_Y(TABLET_mapRect_px_Y));
    w = QUOTE(TABLET_pixel2Screen_W(TABLET_mapRect_px_W));
    h = QUOTE(TABLET_pixel2Screen_H(TABLET_mapRect_px_H));
    colorBackground[] = COLOR_TRANSPARENT;
};
class cTab_Tablet_RscMapControl: cTab_RscMapControl {
    text = "#(argb,8,8,3)color(1,1,1,1)";
    x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X));
    y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y));
    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_contentRect_px_W));
    h = QUOTE(TABLET_pixel2Screen_H(SCREEN_contentRect_px_H));
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
class cTab_Tablet_notification: cTab_RscText_Tablet {
    idc = IDC_CTAB_NOTIFICATION;
    x = QUOTE(TABLET_pixel2Screen_X(SCREEN_contentRect_px_X + (SCREEN_contentRect_px_W * 0.5) / 2));
    y = QUOTE(TABLET_pixel2Screen_Y(SCREEN_contentRect_px_Y + (2 * OSD_elementBase_textSize_px)));
    w = QUOTE(TABLET_pixel2Screen_W(SCREEN_contentRect_px_W * 0.5));
    colorBackground[] = COLOR_BLACK;
};

class cTab_Tablet_FrameBox : cTab_RscControlsGroup {
    class VScrollbar {scrollSpeed = 0;};
    class HScrollbar {scrollSpeed = 0;};
    class Scrollbar {scrollSpeed = 0;};
};
