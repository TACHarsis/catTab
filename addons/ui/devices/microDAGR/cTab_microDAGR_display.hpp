#undef GUI_MARGIN_X
#undef GUI_MARGIN_Y
#undef GUI_TAD_W
#undef GUI_TAD_H
#define GUI_MARGIN_X        (-0.05)
#define GUI_MARGIN_Y        (0.2)
#define GUI_microDAGR_W     (0.86)
#define GUI_microDAGR_H     (0.86)

#undef cTab_microDAGR_DLGtoDSP_fctr
#define cTab_microDAGR_DLGtoDSP_fctr (1)

#undef CUSTOM_GRID_WAbs
#undef CUSTOM_GRID_HAbs
#undef CUSTOM_GRID_X
#undef CUSTOM_GRID_Y
#define CUSTOM_GRID_X       (safeZoneX + GUI_MARGIN_X * 3/4)
#define CUSTOM_GRID_Y       (safeZoneY + safeZoneH - GUI_microDAGR_H - GUI_MARGIN_Y)
#define CUSTOM_GRID_WAbs    (GUI_microDAGR_W * 3/4)
#define CUSTOM_GRID_HAbs    (GUI_microDAGR_H)

#include "cTab_microDAGR_controls.hpp"

class GVARMAIN(microDAGR_dsp) {
    idd = IDD_CTAB_MICRODAGR_DSP;
    movingEnable = "true";
    duration = 10e10;
    fadeIn = 0;
    fadeOut = 0;
    onLoad = QUOTE(_this call FUNC(onIfOpen));
    class controlsBackground {
        class screen: cTab_microDAGR_RscMapControl {
            onDraw = QUOTE(nop = [ARR_2(QQGVARMAIN(microDAGR_dsp),_this)] call FUNC(drawMapControl););
            // set initial map scale
            scaleDefault = QUOTE(missionNamespace getVariable QQGVAR(mapScale));
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
