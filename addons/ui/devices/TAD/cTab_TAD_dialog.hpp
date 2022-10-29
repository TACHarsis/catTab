#include "script_component.hpp"

#define GUI_GRID_X	(safezoneX + (safezoneW - safezoneH * 0.8 * 3/4) / 2)
#define GUI_GRID_Y	(safezoneY + 0.1 * safezoneH)
#define GUI_GRID_W	(safezoneH * 0.8 * 3/4)
#define GUI_GRID_H	(safezoneH * 0.8)

#define cTab_TAD_DLGtoDSP_fctr (0.86 / GUI_GRID_H)

#include "cTab_TAD_controls.hpp"
#include "..\shared\cTab_gui_macros.hpp"

#define MENU_sizeEx pxToScreen_H(cTab_GUI_TAD_OSD_TEXT_STD_SIZE)
#include "..\shared\cTab_markerMenu_macros.hpp"

class GVARMAIN(TAD_dlg) {
	idd = 1755424;
	movingEnable = true;
	onLoad = QUOTE(_this call FUNC(onIfOpen));
	onUnload = QUOTE([] call FUNC(onIfClose));
	onKeyDown = QUOTE(_this call FUNC(onIfKeyDown));
	objects[] = {};
	class controlsBackground {
		class mapBackground: cTab_TAD_Map_Background {};
		class screen: cTab_TAD_RscMapControl {
			idc = IDC_CTAB_SCREEN;
			onDraw = QUOTE(_this call FUNC(drawMapControlTADDlg););
			onMouseButtonDblClick = QUOTE(_ok = [ARR_2(IDC_CTAB_MARKER_MENU_MAIN,_this)] call FUNC(loadMarkerMenu););
			onMouseMoving = QUOTE(GVAR(cursorOnMap) = _this select 3;GVAR(mapCursorPos) = _this select 0 ctrlMapScreenToWorld [ARR_2(_this select 1,_this select 2)];);
		};
		class screenTopo: screen {
			idc = IDC_CTAB_SCREEN_TOPO;
			maxSatelliteAlpha = 0;
		};
		class screenBlack: cTab_TAD_RscMapControl_BLACK {
			idc = IDC_CTAB_SCREEN_BLACK;
			onDraw = QUOTE(_this call FUNC(drawMapControlTADDlg););
			onMouseButtonDblClick = QUOTE(_ok = [ARR_2(IDC_CTAB_MARKER_MENU_MAIN,_this)] call FUNC(loadMarkerMenu););
			onMouseMoving = QUOTE(GVAR(cursorOnMap) = _this select 3;GVAR(mapCursorPos) = _this select 0 ctrlMapScreenToWorld [ARR_2(_this select 1,_this select 2)];);
		};
	};

	class controls {
		/*
			### OSD GUI controls ###
		*/
		class navMode: cTab_TAD_OSD_navModeOrScale {
			text = "EXT1";
		};
		class modeTAD: cTab_TAD_OSD_modeTAD {};
		class txtToggleIconBg: cTab_TAD_OSD_txtToggleIconBg {};
		class txtToggleIcon: cTab_TAD_OSD_txtToggleIcon {};
		class txtToggleText1: cTab_TAD_OSD_txtToggleText1 {};
		class txtToggleText2: cTab_TAD_OSD_txtToggleText2 {};
		class time: cTab_TAD_OSD_time {};
		class currentGrid: cTab_TAD_OSD_currentGrid {};
		class mapToggleIconBg: cTab_TAD_OSD_mapToggleIconBg {};
		class mapToggleIcon: cTab_TAD_OSD_mapToggleIcon {};
		class mapToggleText1: cTab_TAD_OSD_mapToggleText1 {};
		class mapToggleText2: cTab_TAD_OSD_mapToggleText2 {};
		class hookGrid: cTab_TAD_OSD_hookGrid {};
		class hookElevation: cTab_TAD_OSD_hookElevation {};
		class hookDir: cTab_TAD_OSD_hookDir {};
		class hookToggleIconBackground: cTab_TAD_OSD_hookToggleIconBackground {};
		class hookToggleIcon: cTab_TAD_OSD_hookToggleIcon {};
		class hookToggleText1: cTab_TAD_OSD_hookToggleText1 {};
		class hookToggleText2: cTab_TAD_OSD_hookToggleText2 {};
		class on_screen_currentDirection: cTab_TAD_OSD_currentDirection {};
		class on_screen_currentElevation: cTab_TAD_OSD_currentElevation {};
		class on_screen_centerMapText: cTab_TAD_OSD_centerMapText {};

		/*
			### Overlays ###
		*/
		// ---------- NOTIFICATION ------------
		class notification: cTab_TAD_notification {};
		// ---------- LOADING ------------
		class loadingtxt: cTab_TAD_loadingtxt {};
		// ---------- BRIGHTNESS ------------
		class brightness: cTab_TAD_brightness {};
		// ---------- USER MARKERS ------------
		#include "..\shared\cTab_markerMenu_controls.hpp"
		// ---------- BACKGROUND ------------
		class background: cTab_TAD_background {};
		// ---------- MOVING HANDLEs ------------
		class movingHandle_T: cTab_TAD_movingHandle_T {};
		class movingHandle_B: cTab_TAD_movingHandle_B {};
		class movingHandle_L: cTab_TAD_movingHandle_L {};
		class movingHandle_R: cTab_TAD_movingHandle_R {};

		/*
			### PHYSICAL BUTTONS ###
		*/
		class pwrbtn: cTab_RscButton_TAD_DNO {
			idc = IDC_CTAB_BTNMAIN;
			onMouseButtonUp = QUOTE(if (_this select 1 == 0) then {['GVARMAIN(TAD_dlg)'] call FUNC(caseButtonsToggleNightMode)} else {if (_this select 1 == 1) then {[] call FUNC(close)};});
			tooltip = "left-click: Toggle DAY / NIGHT mode; right-click: Close interface";
		};
		class btnSymInc: cTab_RscButton_TAD_SYM_INC {
			idc = IDC_CTAB_BTNUP;
			action = QUOTE(1 call FUNC(caseButtonsAdjustTextSize););
			tooltip = "Increase Font";
		};
		class btnSymDec: cTab_RscButton_TAD_SYM_DEC {
			idc = IDC_CTAB_BTNDWN;
			action = QUOTE(-1 call FUNC(caseButtonsAdjustTextSize););
			tooltip = "Decrease Font";
		};
		class btnBrtInc: cTab_RscButton_TAD_BRT_INC {
			idc = 18;
			action = QUOTE([ARR_2('GVARMAIN(TAD_dlg)', 0.1)]  call FUNC(caseButtonsAdjustBrightness););
			tooltip = "Increase Brightness";
		};
		class btnBrtDec: cTab_RscButton_TAD_BRT_DEC {
			idc = 19;
			action = QUOTE([ARR_2('GVARMAIN(TAD_dlg)', -0.1)] call FUNC(caseButtonsAdjustBrightness););
			tooltip = "Decrease Brightness";
		};
		class btnfunction: cTab_RscButton_TAD_OSB10 {
			idc = IDC_CTAB_BTNFN;
			action = QUOTE(['GVARMAIN(TAD_dlg)']  call FUNC(caseButtonsIconTextToggle););
			tooltip = "Toggle Text on/off";
		};
		class btnMapType: cTab_RscButton_TAD_OSB20 {
			idc = 20;
			action = QUOTE(['GVARMAIN(TAD_dlg)']  call FUNC(caseButtonsMapTypeToggle););
			tooltip = "Toggle Map Type (F6)";
		};
		class btnMapTools: cTab_RscButton_TAD_OSB18 {
			idc = 21;
			action = QUOTE(['GVARMAIN(TAD_dlg)'] call FUNC(toggleMapTools));
			tooltip = "Toggle Map Tools (F5)";
		};
		class btnF7: cTab_RscButton_TAD_OSB19 {
			idc = 22;
			action = QUOTE(['GVARMAIN(TAD_dlg)'] call FUNC(caseButtonsCenterMapOnPlayerPosition));
			tooltip = "Center Map On Current Position (F7)";
		};
	};
};
