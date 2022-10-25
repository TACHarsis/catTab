#define GUI_MARGIN_X	(-0.05)
#define GUI_MARGIN_Y	(0.2)
#define GUI_microDAGR_W	(0.86)
#define GUI_microDAGR_H	(0.86)

#define cTab_microDAGR_DLGtoDSP_fctr (1)

#define GUI_GRID_X	(safeZoneX + GUI_MARGIN_X * 3/4)
#define GUI_GRID_Y	(safeZoneY + safeZoneH - GUI_microDAGR_H - GUI_MARGIN_Y)
#define GUI_GRID_W	(GUI_microDAGR_W * 3/4)
#define GUI_GRID_H	(GUI_microDAGR_H)

#include "cTab_microDAGR_controls.hpp"

class GVARMAIN(microDAGR_dsp) {
	idd = 1776135;
	movingEnable = true;
	duration = 10e10;
	fadeIn = 0;
	fadeOut = 0;
	onLoad = QUOTE(_this call FUNC(onIfOpen));
	class controlsBackground {
		class screen: cTab_microDAGR_RscMapControl {
			onDraw = QUOTE(nop = _this call FUNC(drawMapControlMicroDAGRDsp););
			// set initial map scale
			scaleDefault = QUOTE(missionNamespace getVariable 'GVAR(mapScale)');
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

		/*
			### Overlays ###
		*/
		// ---------- LOADING ------------
		class loadingtxt: cTab_microDAGR_loadingtxt {};
		// ---------- BRIGHTNESS ------------
		class brightness: cTab_microDAGR_brightness {};
		// ---------- BACKGROUND ------------
		class background: cTab_microDAGR_background {};
	};
};
