#include "script_component.hpp"

#define GUI_GRID_W	(safezoneW)
#define GUI_GRID_H	(GUI_GRID_W * 4/3)
#define GUI_GRID_X	(safezoneX + (safezoneW - GUI_GRID_W) / 2)
#define GUI_GRID_Y	(safezoneY + (safezoneH - GUI_GRID_H) / 2)

#include "cTab_FBCB2_controls.hpp"
#include "..\shared\cTab_gui_macros.hpp"

#define MENU_sizeEx pxToScreen_H(cTab_GUI_FBCB2_OSD_TEXT_STD_SIZE)
#include "..\shared\cTab_markerMenu_macros.hpp"

class GVARMAIN(FBCB2_dlg){
	idd = 1775144;
	movingEnable = true;
	onLoad = QUOTE(_this call FUNC(onIfOpen));
	onUnload = QUOTE([] call FUNC(onIfclose));
	onKeyDown = QUOTE(_this call FUNC(onIfKeyDown));
	objects[] = {};
	class controlsBackground {
		class background: cTab_FBCB2_background {
			moving = 1;
		};
		class screen: cTab_RscMapControl {
			idc = IDC_CTAB_SCREEN;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = pxToScreen_X(cTab_GUI_FBCB2_SCREEN_CONTENT_X);
			y = pxToScreen_Y(cTab_GUI_FBCB2_SCREEN_CONTENT_Y);
			w = pxToScreen_W(cTab_GUI_FBCB2_SCREEN_CONTENT_W);
			h = pxToScreen_H(cTab_GUI_FBCB2_SCREEN_CONTENT_H);
			onDraw = QUOTE(nop = _this call FUNC(drawMapControlFBCB2););
			onMouseButtonDblClick = QUOTE(_ok = ARR_2(IDC_CTAB_MARKER_MENU_MAIN,_this) call FUNC(loadMarkerMenu););
			onMouseMoving = QUOTE(GVAR(cursorOnMap) = _this select 3;GVAR(mapCursorPos) = _this select 0 ctrlMapScreenToWorld ARR_2(_this select 1,_this select 2););
			maxSatelliteAlpha = 10000;
			alphaFadeStartScale = 10;
			alphaFadeEndScale = 10;

			// Rendering density coefficients
			ptsPerSquareSea = 8 / (0.86 / GUI_GRID_H);		// seas
			ptsPerSquareTxt = 8 / (0.86 / GUI_GRID_H);		// textures
			ptsPerSquareCLn = 8 / (0.86 / GUI_GRID_H);		// count-lines
			ptsPerSquareExp = 8 / (0.86 / GUI_GRID_H);		// exposure
			ptsPerSquareCost = 8 / (0.86 / GUI_GRID_H);		// cost

			// Rendering thresholds
			ptsPerSquareFor = 3 / (0.86 / GUI_GRID_H);		// forests
			ptsPerSquareForEdge = 100 / (0.86 / GUI_GRID_H);	// forest edges
			ptsPerSquareRoad = 1.5 / (0.86 / GUI_GRID_H);		// roads
			ptsPerSquareObj = 4 / (0.86 / GUI_GRID_H);		// other objects
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
		class btnfunction: cTab_FBCB2_btnFCN {
			idc = IDC_CTAB_BTNFN;
			action = QUOTE(['GVARMAIN(FBCB2_dlg)']  call FUNC(caseButtonsIconTextToggle););
			tooltip = "Toggle Text on/off";
		};
		class btnF5: cTab_FBCB2_btnF5 {
			idc = IDC_CTAB_BTNF5;
			tooltip = "Toggle Map Tools (F5)";
			action = QUOTE(['GVARMAIN(FBCB2_dlg)'] call FUNC(toggleMapTools));
		};
		class btnF6: cTab_FBCB2_btnF6 {
			idc = IDC_CTAB_BTNF6;
			tooltip = "Toggle Map Textures";
			action = QUOTE(['GVARMAIN(FBCB2_dlg)']  call FUNC(caseButtonsMapTypeToggle););
		};
		class btnF7: cTab_FBCB2_btnF7 {
			idc = 5;
			action = QUOTE(['GVARMAIN(FBCB2_dlg)'] call FUNC(caseButtonsCenterMapOnPlayerPosition));
			tooltip = "Center Map On Current Position (F7)";
		};
		class hookGrid: cTab_FBCB2_on_screen_hookGrid {};
		class hookElevation: cTab_FBCB2_on_screen_hookElevation {};
		class hookDst: cTab_FBCB2_on_screen_hookDst {};
		class hookDir: cTab_FBCB2_on_screen_hookDir {};
		//### Secondary Map Pop up	------------------------------------------------------------------------------------------------------
		#include "..\shared\cTab_markerMenu_controls.hpp"

		// ---------- NOTIFICATION ------------
		class notification: cTab_FBCB2_notification {};
		// ---------- LOADING ------------
		class loadingtxt: cTab_FBCB2_loadingtxt {};
	};
};
