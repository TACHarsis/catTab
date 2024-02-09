
/*
    Preferred Image Size = 256x256
    Can Embed Images Into Description = 1024x512
        - Shadow = '0'
        - Size = '9'
*/
// Default arguments
//
// &lt;br/&gt; - linebreak
// %1 - small empty line
// %2 - bullet (for item in list)
// %3 - highlight start
// %4 - highlight end
// %5 - warning color formated for using in structured text tag
// %6 - BLUFOR color attribute
// %7 - OPFOR color attribute
// %8 - Independent color attribute
// %9 - Civilian color attribute
// %10 - Unknown side color attribute
// added:
// %11 - indent (4 spaces)
// %12 - linebreak
// %13 - reserved
// %14 - <
// %15 - >

// in arguments:
// {{"getOver"}}, // Double nested array means assigned key (will be specially formatted)
// {"name"}, // Nested array means element (specially formatted part of text)
// "name player" // Simple string will be simply compiled and called, String can also link to localization database in case it starts by str_

#define DEFAULT_ARGUMENTS "'    '", "'<br/>'", "selectRandom [1,2,3,4,5,6,7,8,9]", "'&lt;'", "'&gt;'"

class CfgHints {
    class GVAR(BaseEntry) {
        arguments[] = {DEFAULT_ARGUMENTS};
        image = QUOTE(\z\cTab\icon_128_ca.paa);
        //tip = "Just a tip: <a href='https://github.com/TACHarsis/catTab/'>GitHub</a>";
    };

    class GVAR(Changes) {
        displayName = CSTRING(Hints_Category_Changes);
        category = QGVAR(Manual);
        logicalOrder = 1;

        class GVAR(ACE): GVAR(BaseEntry) {
            logicalOrder = 1;
            arguments[] = {
                DEFAULT_ARGUMENTS,
                """<img size='10.5' image='\z\ctab\addons\manual\images\ace_interact_co.jpg' />""" // %16 ace interaction
            };
            displayName = CSTRING(Hints_Changes_ACE_Title);
            displayNameShort = CSTRING(Hints_Changes_ACE_Short);
            description = CSTRING(Hints_Changes_ACE_Description);
        };
        class GVAR(Items): GVAR(BaseEntry) {
            logicalOrder = 2;
            arguments[] = {
                DEFAULT_ARGUMENTS,
                """<img size='2.5' image='\z\ctab\addons\data\img\icons\icon_Android.paa' />""",    // %16 icon android
                """<img size='2.5' image='\z\ctab\addons\data\img\icons\icon_dk10' />""",           // %17 icon tablet
                """<img size='2.5' image='\z\ctab\addons\data\img\icons\icon_helmetCam.paa' />""",  // %18 icon hcam
                """<img size='2.5' image='\z\ctab\addons\data\img\icons\icon_MicroDAGR' />"""       // %19 icon microdagr
            };
            displayName = CSTRING(Hints_Changes_Items_Title);
            displayNameShort = CSTRING(Hints_Changes_Items_Short);
            description = CSTRING(Hints_Changes_Items_Description);
        };
        class GVAR(Backgrounds): GVAR(BaseEntry) {
            logicalOrder = 3;
            arguments[] = {
                DEFAULT_ARGUMENTS,
                """<img size='7' image='\z\ctab\addons\manual\images\tablet_settings_2_co.jpg' />""",        // %16 tablet settings (backgrounds)
                """<img size='7' image='\z\ctab\addons\manual\images\android_settings_co.jpg' />""",         // %17 android settings (backgrounds)
                """<img size='20' image='\z\ctab\addons\manual\images\tablet_custom_background_co.jpg' />""" // %18 tablet background
            };
            displayName = CSTRING(Hints_Changes_Backgrounds_Title);
            displayNameShort = CSTRING(Hints_Changes_Backgrounds_Short);
            description = CSTRING(Hints_Changes_Backgrounds_Description);
        };
        class GVAR(Layout): GVAR(BaseEntry) {
            logicalOrder = 4;
            arguments[] = {
                DEFAULT_ARGUMENTS,
                """<img size='20' image='\z\ctab\addons\manual\images\layout_options_co.jpg' />"""    // %16 layout options (backgrounds)
            };
            displayName = CSTRING(Hints_Changes_Layout_Title);
            displayNameShort = CSTRING(Hints_Changes_Layout_Short);
            description = CSTRING(Hints_Changes_Layout_Description);
        };
        class GVAR(Keybinds): GVAR(BaseEntry) {
            logicalOrder = 5;
            displayName = CSTRING(Hints_Changes_Keybinds_Title);
            displayNameShort = CSTRING(Hints_Changes_Keybinds_Short);
            description = CSTRING(Hints_Changes_Keybinds_Description);
        };
        class GVAR(Misc): GVAR(BaseEntry) {
            logicalOrder = 6;
            arguments[] = {DEFAULT_ARGUMENTS};
            displayName = CSTRING(Hints_Changes_Misc_Title);
            displayNameShort = CSTRING(Hints_Changes_Misc_Short);
            description = CSTRING(Hints_Changes_Misc_Description);
        };
    };
    class GVAR(Tablet) {
        displayName = CSTRING(Hints_Category_Tablet);
        category = QGVAR(Manual);
        logicalOrder = 2;

        class GVAR(Changes): GVAR(BaseEntry) {
            logicalOrder = 1;
            displayName = CSTRING(Hints_Tablet_Changes_Title);
            displayNameShort = CSTRING(Hints_Tablet_Changes_Short);
            description = CSTRING(Hints_Tablet_Changes_Description);
        };
        class GVAR(Settings): GVAR(BaseEntry) {
            logicalOrder = 2;
            arguments[] = {
                DEFAULT_ARGUMENTS,
                """<img size='20' image='\z\ctab\addons\manual\images\tablet_settings_1_co.jpg' />""",  // %16 tablet settings (feeds)
                """<img size='20' image='\z\ctab\addons\manual\images\tablet_settings_2_co.jpg' />"""   // %17 tablet settings (backgrounds)
            };
            displayName = CSTRING(Hints_Tablet_Settings_Title);
            displayNameShort = CSTRING(Hints_Tablet_Settings_Short);
            description = CSTRING(Hints_Tablet_Settings_Description);
        };
        class GVAR(VideoFeeds): GVAR(BaseEntry) {
            logicalOrder = 3;
            arguments[] = {
                DEFAULT_ARGUMENTS,
                """<img size='20' image='\z\ctab\addons\manual\images\tablet_interface_1_co.jpg' />""", // %16 screen UAV
                """<img size='20' image='\z\ctab\addons\manual\images\tablet_interface_2_co.jpg' />""", // %17 screen HCAM
                """<img size='20' image='\z\ctab\addons\manual\images\tablet_interface_3_co.jpg' />"""  // %18 Fulscreen HCAM
            };
            displayName = CSTRING(Hints_Tablet_VideoFeeds_View_Title);
            displayNameShort = CSTRING(Hints_Tablet_VideoFeeds_View_Short);
            description = CSTRING(Hints_Tablet_VideoFeeds_View_Description);
        };
        class GVAR(UAV): GVAR(BaseEntry) {
            logicalOrder = 4;
            arguments[] = {
                DEFAULT_ARGUMENTS,
                """<img size='15' image='\z\ctab\addons\manual\images\tablet_UAV_lock_1_co.jpg' />""", // %16 no lock
                """<img size='15' image='\z\ctab\addons\manual\images\tablet_UAV_lock_2_co.jpg' />""", // %17 lock menu
                """<img size='15' image='\z\ctab\addons\manual\images\tablet_UAV_lock_3_co.jpg' />""", // %18 lock over horizon
                """<img size='15' image='\z\ctab\addons\manual\images\tablet_UAV_lock_4_co.jpg' />"""  // %19 successful lock
            };
            displayName = CSTRING(Hints_Tablet_UAV_View_Title);
            displayNameShort = CSTRING(Hints_Tablet_UAV_View_Short);
            description = CSTRING(Hints_Tablet_UAV_View_Description);
        };
    };
};
