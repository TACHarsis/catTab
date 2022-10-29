class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    grid_Android_Display[] = {
                        {
							"safezoneX - 0.86 * 0.17",
							"safezoneY + safezoneH * 0.88 - (0.86 * 4/3) * 0.72",
							"0.86",
							"0.86 * 4/3"
                        },
                        "1",
                        "1"
                    };
                };
            };
        };

        class Variables {
            class grid_Android_Display {
                displayName = "Android";
                description = "Default position of android in display mode";
                //preview = "#(argb,8,8,3)color(1,0,0.91,0.75)";
				preview = QPATHTOEF(data,img\android_background_ca.paa);
                saveToProfile[] = {0,1};
            };
        };
    };
};
