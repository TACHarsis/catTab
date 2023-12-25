// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

#undef CUSTOM_GRID_WAbs
#undef CUSTOM_GRID_HAbs
#undef CUSTOM_GRID_X
#undef CUSTOM_GRID_Y
#define CUSTOM_GRID_HAbs    (0.048)
#define CUSTOM_GRID_WAbs    (CUSTOM_GRID_HAbs * 3/4)
#define CUSTOM_GRID_X       (safezoneX + safezoneW * (1 - 0.00675) - CUSTOM_GRID_WAbs)
#define CUSTOM_GRID_Y       (safezoneY + safezoneH * 0.25)

class GVAR(mail_ico_disp) {
    idd = 13672;
    name="cTabMailico";
    onLoad = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(mail_ico_disp),_this select 0)]);
    fadein = 0;
    fadeout = 0;
    duration = 10e10;
    controlsBackground[] = {};
    objects[] = {};
    class controls {
        class trin_image {
            idc = IDC_CTAB_MAPSCALE;
            type = CT_STATIC;
            style = ST_PICTURE;
            colorBackground[] = { };
            colorText[] = { };
            font = "puristaLight";
            sizeEx = QUOTE(0.053);
            x = QUOTE(CUSTOM_GRID_X);
            y = QUOTE(CUSTOM_GRID_Y);
            w = QUOTE(CUSTOM_GRID_WAbs);
            h = QUOTE(CUSTOM_GRID_HAbs);
            text = QPATHTOEF(data,img\ui\messaging\icon_mail_ca.paa);
        };
    };
};
