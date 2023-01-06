class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    GVARMAIN(Android_dsp)[] = {
                        { // Values from ctab_android_display.hpp
                    /*X*/   QUOTE((safezoneX - (0.86) * 0.17)),
                    /*Y*/   QUOTE((safezoneY + safezoneH * 0.88 - ((0.86) * 4/3) * 0.72)),
                    /*W*/   QUOTE((0.86)),
                    /*H*/   QUOTE(((0.86) * 4/3))
                        },
                /*?*/ "1",
                      "1"
                    };
                    GVARMAIN(Android_dsp_alt)[] = {
                        {
                            // default position         +  offset // 2 * safeZoneX + safeZoneW - elementWidth - 2 * defaultPosX
                    /*X*/   QUOTE((safezoneX - (0.86) * 0.17) +           (2 * safeZoneX + safeZoneW - (0.86)       - 2 * (safezoneX - (0.86 * 0.17)))),
                    /*Y*/   QUOTE((safezoneY + safezoneH * 0.88 - (0.86 * 4/3) * 0.72)),
                    /*W*/   QUOTE((0.86)),
                    /*H*/   QUOTE((0.86 * 4/3))
                        },
                        "1",
                        "1"
                    };
                    GVARMAIN(TAD_dsp)[] = {
                        { // Values from ctab_TAD_display.hpp
                    /*X*/   QUOTE((safeZoneX + 0.05 * 3/4)),
                    /*Y*/   QUOTE((safeZoneY + safeZoneH - 0.86 - 0.2)),
                    /*W*/   QUOTE((0.86 * 3/4)),
                    /*H*/   QUOTE((0.86))
                        },
                        "1",
                        "1"
                    };
                    GVARMAIN(TAD_dsp_alt)[] = {
                        {
                            // default position      +  offset //  2 * safeZoneX + safeZoneW - elementWidth - 2 * defaultPosX
                    /*X*/   QUOTE((safeZoneX + 0.05 * 3/4) +            (2 * safeZoneX + safeZoneW - (0.86 * 3/4) - 2 * (safeZoneX + (0.05) * 3/4))),
                    /*Y*/   QUOTE((safeZoneY + safeZoneH - 0.86 - 0.2)),
                    /*W*/   QUOTE((0.86 * 3/4)),
                    /*H*/   QUOTE((0.86))
                        },
                        "1",
                        "1"
                    };
                    GVARMAIN(microDAGR_dsp)[] = {
                        { // Values from ctab_microDAGR_display.hpp
                    /*X*/   QUOTE((safeZoneX + (-0.05 * 3/4))),
                    /*Y*/   QUOTE((safeZoneY + safeZoneH - 0.86 - 0.2)),
                    /*W*/   QUOTE((0.86 * 3/4)),
                    /*H*/   QUOTE((0.86))
                        },
                        "1",
                        "1"
                    };
                    GVARMAIN(microDAGR_dsp_alt)[] = {
                        {
                            // default position         +  offset //  2 * safeZoneX + safeZoneW - elementWidth - 2 * defaultPosX
                    /*X*/   QUOTE((safeZoneX + (-0.05 * 3/4)) +            (2 * safezoneX + safezoneW - (0.86 * 3/4) - 2 * (safeZoneX + (-0.05 * 3/4)))),
                    /*Y*/   QUOTE((safeZoneY + safeZoneH - 0.86 - 0.2)),
                    /*W*/   QUOTE((0.86 * 3/4)),
                    /*H*/   QUOTE((0.86))
                        },
                        "1",
                        "1"
                    };
                };
            };
        };

        class Variables {
            class GVARMAIN(Android_dsp) {
                displayName = "Android";
                description = "Default position of android in display mode";
                preview = "#(argb,8,8,3)color(1,0,0.91,0.75)";
                preview = QPATHTOEF(data,img\ui\display_frames\android_background_ca.paa);
                saveToProfile[] = {0,1,2,3};
            };
            class GVARMAIN(Android_dsp_alt) {
                displayName = "Android";
                description = "Alternative position of android in display mode";
                preview = "#(argb,8,8,3)color(1,0,0.91,0.75)";
                preview = QPATHTOEF(data,img\ui\display_frames\android_background_ca.paa);
                saveToProfile[] = {0,1,2,3};
            };
            class GVARMAIN(TAD_dsp) {
                displayName = "TAD";
                description = "Default position of TAD in display mode";
                preview = "#(argb,8,8,3)color(1,0,0.91,0.75)";
                preview = QPATHTOEF(data,img\ui\display_frames\TAD_background_ca.paa);
                saveToProfile[] = {0,1,2,3};
            };
            class GVARMAIN(TAD_dsp_alt) {
                displayName = "TAD";
                description = "Alternative position of TAD in display mode";
                preview = "#(argb,8,8,3)color(1,0,0.91,0.75)";
                preview = QPATHTOEF(data,img\ui\display_frames\TAD_background_ca.paa);
                saveToProfile[] = {0,1,2,3};
            };
            class GVARMAIN(microDAGR_dsp) {
                displayName = "MicroDAGR";
                description = "Default position of MicroDAGR in display mode";
                preview = "#(argb,8,8,3)color(1,0,0.91,0.75)";
                preview = QPATHTOEF(data,img\ui\display_frames\microDAGR_background_ca.paa);
                saveToProfile[] = {0,1,2,3};
            };
            class GVARMAIN(microDAGR_dsp_alt) {
                displayName = "MicroDAGR";
                description = "Alternative position of MicroDAGR in display mode";
                preview = "#(argb,8,8,3)color(1,0,0.91,0.75)";
                preview = QPATHTOEF(data,img\ui\display_frames\microDAGR_background_ca.paa);
                saveToProfile[] = {0,1,2,3};
            };
        };
    };
};
