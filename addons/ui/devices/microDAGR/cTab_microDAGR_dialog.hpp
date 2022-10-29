#include "script_component.hpp"

#define GUI_GRID_X	(safezoneX + (safezoneW - safezoneH * 0.8 * 3/4) / 2)
#define GUI_GRID_Y	(safezoneY + 0.1 * safezoneH)
#define GUI_GRID_W	(safezoneH * 0.8 * 3/4)
#define GUI_GRID_H	(safezoneH * 0.8)

#define cTab_microDAGR_DLGtoDSP_fctr (0.86 / GUI_GRID_H)

#include "cTab_microDAGR_controls.hpp"

#define MENU_GRID_X	(0)
#define MENU_GRID_Y	(0)
#define MENU_GRID_W	(0.025)
#define MENU_GRID_H	(0.04)

class GVARMAIN(microDAGR_dlg) {
	idd = 1776134;
	movingEnable = true;
	onLoad = QUOTE(_this call FUNC(onIfOpen));
	onUnload = QUOTE([] call FUNC(onIfClose));
	onKeyDown = QUOTE(_this call FUNC(onIfKeyDown));
	objects[] = {};
	class controlsBackground {
		class screen: cTab_microDAGR_RscMapControl {
			onDraw = QUOTE(_this call FUNC(drawMapControlMicroDAGRDlg););
			onMouseMoving = QUOTE(GVAR(mapCursorPos) = _this select 0 ctrlMapScreenToWorld [ARR_2(_this select 1,_this select 2)];);
			// set initial map scale
			scaleDefault = QUOTE((missionNamespace getVariable 'GVAR(mapScale)') * 0.86 / (safezoneH * 0.8));
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
		class header: cTab_microDAGR_header {};
		class footer: cTab_microDAGR_footer {};
		class battery: cTab_microDAGR_on_screen_battery {};
		class time: cTab_microDAGR_on_screen_time {};
		class signalStrength: cTab_microDAGR_on_screen_signalStrength {};
		class satellite: cTab_microDAGR_on_screen_satellite {};
		class dirDegree: cTab_microDAGR_on_screen_dirDegree {};
		class grid: cTab_microDAGR_on_screen_grid {};
		class dirOctant: cTab_microDAGR_on_screen_dirOctant {};
		class btnbrtpls: cTab_microDAGR_btnbrtpls {};
		class btnbrtmns: cTab_microDAGR_btnbrtmns {};
		class hookGrid: cTab_microDAGR_on_screen_hookGrid {};
		class hookElevation: cTab_microDAGR_on_screen_hookElevation {};
		class hookDst: cTab_microDAGR_on_screen_hookDst {};
		class hookDir: cTab_microDAGR_on_screen_hookDir {};

		/*
			### Overlays ###
		*/
		// ---------- LOADING ------------
		class loadingtxt: cTab_microDAGR_loadingtxt {};
		// ---------- BRIGHTNESS ------------
		class brightness: cTab_microDAGR_brightness {};
		// ---------- BACKGROUND ------------
		class background: cTab_microDAGR_background {};
		// ---------- MOVING HANDLEs ------------
		class movingHandle_T: cTab_microDAGR_movingHandle_T{};
		class movingHandle_B: cTab_microDAGR_movingHandle_B{};
		class movingHandle_L: cTab_microDAGR_movingHandle_L{};
		class movingHandle_R: cTab_microDAGR_movingHandle_R{};

		/*
			### PHYSICAL BUTTONS ###
		*/
		class btnMapType: cTab_microDAGR_btnMapType {
			action = QUOTE(['GVARMAIN(microDAGR_dlg)']  call FUNC(caseButtonsMapTypeToggle););
		};
		class btnMapTools: cTab_microDAGR_btnMapTools {
			action = QUOTE(['GVARMAIN(microDAGR_dlg)'] call FUNC(toggleMapTools));
		};
		class btnF7: cTab_microDAGR_btnF7 {
			action = QUOTE(['GVARMAIN(microDAGR_dlg)'] call FUNC(caseButtonsCenterMapOnPlayerPosition));
		};
		class btnfunction: cTab_microDAGR_btnfunction {
			action = QUOTE(['GVARMAIN(microDAGR_dlg)']  call FUNC(caseButtonsIconTextToggle););
		};
	};
};
