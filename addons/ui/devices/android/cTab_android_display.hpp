// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

#undef CUSTOM_GRID_WAbs
#undef CUSTOM_GRID_HAbs
#undef CUSTOM_GRID_X
#undef CUSTOM_GRID_Y
#define CUSTOM_GRID_WAbs    (0.86)
#define CUSTOM_GRID_HAbs    (CUSTOM_GRID_WAbs * 4/3)
#define CUSTOM_GRID_X       (safezoneX - CUSTOM_GRID_WAbs * 0.17)
#define CUSTOM_GRID_Y       (safezoneY + safezoneH * 0.88 - CUSTOM_GRID_HAbs * 0.72)

#undef cTab_android_DLGtoDSP_fctr
#define cTab_android_DLGtoDSP_fctr (1)

#include "cTab_android_controls.hpp"

#undef MENU_sizeEx
#define MENU_sizeEx ANDROID_pixel2Screen_H(OSD_elementBase_textSize_px)
#include "..\shared\cTab_markerMenu_macros.hpp"

class GVARMAIN(Android_dsp) {
    idd = IDD_CTAB_ANDROID_DSP;
    duration = 10e10;
    fadeIn = 0;
    fadeOut = 0;
    onLoad = QUOTE(_this call FUNC(onIfOpen));
    objects[] = {};
    class controlsBackground {
        class windowsBG: cTab_android_windowsBG {};
        class screen: cTab_android_RscMapControl {
            onDraw = QUOTE(nop = [ARR_2(QQGVARMAIN(Android_dsp),_this)] call FUNC(drawMapControl););
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
        class header: cTab_android_header {};
        class battery: cTab_android_on_screen_battery {};
        class time: cTab_android_on_screen_time {};
        class signalStrength: cTab_android_on_screen_signalStrength {};
        class satellite: cTab_android_on_screen_satellite {};
        class dirDegree: cTab_android_on_screen_dirDegree {};
        class grid: cTab_android_on_screen_grid {};
        class dirOctant: cTab_android_on_screen_dirOctant {};

        /*
            ### Overlays ###
        */
        // ---------- NOTIFICATION ------------
        class notification: cTab_android_notification {};
        // ---------- LOADING ------------
        class loadingtxt: cTab_android_loadingtxt {};
        // ---------- BRIGHTNESS ------------
        class brightness: cTab_android_brightness {};
        // ---------- BACKGROUND ------------
        class background: cTab_android_background {};
    };
};
