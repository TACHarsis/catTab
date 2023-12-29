/* CBA Settings

Parameters:
    * setting     - Unique setting name. Matches resulting variable name <STRING>
    * settingType - Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
    * title       - Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
    * category    - Category for the settings menu + optional sub-category <STRING, ARRAY>
    * valueInfo   - Extra properties of the setting depending of _settingType. See examples below <ANY>
    * isGlobal    - 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <NUMBER>
    * script      - Script to execute when setting is changed. (optional) <CODE>
    * needRestart - Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>

Types:

    * CHECKBOX: A checkbox. The resulting settings value is a boolean.
        * Default value <BOOLEAN>
    * EDITBOX: A string type setting that players can type.
        * Default value <STRING>
    * SLIDER: Resulting settings value is a number between a min and a max value. (e.g. view distance slider)
        * 0: Minimum (lowest possible value) <NUMBER>
        * 1: Maximum (highest possible value) <NUMBER>
        * 2: Default value <NUMBER>
        * 3: Number of displayed trailing decimals (should be 0, 1 or 2) <NUMBER>
        * 4: Percentage display <BOOL>
            Example: [1, 25, 5, 2] (value), [0, 1, 0.5, 2, true] (percentage)
    * LIST: A dropdown list. Resulting value can be anything, but only one item can be selected at any time.
        * 0: Values this setting can take. <ARRAY>
        * 1: Corresponding pretty names for the ingame settings menu. Can be stringtable entries. <ARRAY>
        * 2: Index of the default value. Not the default value itself. <NUMBER>
            Example: [[false, true], ["STR_A3_OPTIONS_DISABLED", "STR_A3_OPTIONS_ENABLED"], 0]
    * COLOR: Will create a "color picker" setting. The value will be an array representing a color.
            The array size can be 3 or 4, depending on the passed default value. The fourth element will represent the opacity ("alpha value").
        * Default color. Array size can be 3 or 4, depending on whether the setting uses the alpha value. <ARRAY>
            Example: [1, 0, 0] (red), [1, 1, 0, 0.5] (semi transparent yellow)

*/

private _modCategory = "CatTab";//LLSTRING(Setting_Cagetory_Mod);
private _androidCategory = "Android";//LLSTRING(Setting_Cagetory_Android);
private _tabletCategory = "Tablet";//LLSTRING(Setting_Cagetory_Tablet);

[
    QGVAR(enableAddon),
    "CHECKBOX",
    [LLSTRING(Setting_Enable_Addon), LLSTRING(Setting_Enable_Addon_Hint)],
    [_modCategory],
    true
] call CBA_fnc_addSetting;

//--------------- Android ---------------

[
    QGVAR(androidDesktopBackgroundMode),
    "LIST",
    [LLSTRING(Setting_Android_Desktop_Background_Mode), LLSTRING(Setting_Android_Desktop_Background_Mode_Hint)],
    [_modCategory,_androidCategory],
    [[0,1,2],["Preset", "Custom", "Color"], 0],
    2
] call CBA_fnc_addSetting;

[
    QGVAR(androidDesktopBackgroundPreset),
    "LIST",
    [LLSTRING(Setting_Android_Desktop_Background_Preset), LLSTRING(Setting_Android_Desktop_Background_Preset_Hint)],
    [_modCategory,_androidCategory],
    [
        [
            QPATHTOEF(data,img\ui\desktop\classic\example_custom_android_desktop_background_0_co.paa)
        ],
        [
            "Bisxual Lighting"
        ],
        0
    ],
    2
] call CBA_fnc_addSetting;

[
    QGVAR(androidDesktopColor),
    "COLOR",
    [LLSTRING(Setting_Android_Desktop_Color), LLSTRING(Setting_Android_Desktop_Color_Hint)],
    [_modCategory,_androidCategory],
    [0.239,0.863,0.517],
    2
] call CBA_fnc_addSetting;

[   //These images get cached the first time they are used from their path
    QGVAR(androidDesktopCustomImageName),
    "EDITBOX",
    [LLSTRING(Setting_Android_Desktop_Custom_Image), LLSTRING(Setting_Android_Desktop_Custom_Image_Hint)],
    [_modCategory,_androidCategory],
    "example_custom_android_desktop_background_co.jpg",
    2
] call CBA_fnc_addSetting;

//--------------- Tablet ---------------

[ //TODO: this sets the number as floating point
    QGVAR(numTabletFeeds),
    "SLIDER",
    [LLSTRING(Setting_Tablet_Number_Feeds), LLSTRING(Setting_Tablet_Number_Feeds_Hint)],
    [_modCategory, _tabletCategory],
    [1, 6, 2, 0, false],
    1
] call CBA_fnc_addSetting;

[
    QGVAR(tabletFeedTextureResolution),
    "LIST",
    [LLSTRING(Setting_Tablet_Texture_Resolution), LLSTRING(Setting_Tablet_Texture_Resolution_Hint)],
    [_modCategory, _tabletCategory],
    [
        [512, 1024],
        ["512x512", "1024x1024"],
        1
    ],
    0
] call CBA_fnc_addSetting;

[
    QGVAR(tabletFeedTextureResolutionFullscreen),
    "LIST",
    [LLSTRING(Setting_Tablet_Texture_Resolution), LLSTRING(Setting_Tablet_Texture_Resolution_Hint)], //TODO: Share this between small and fullscreen?
    [_modCategory, _tabletCategory],
    [
        [1024, 2048],
        ["1024x1024", "2048x2048"],
        1
    ],
    0
] call CBA_fnc_addSetting;

[
    QGVAR(tabletFeedDealWithAspectRatio),
    "LIST",
    [LLSTRING(Setting_Tablet_Texture_AspectRatio_Method), LLSTRING(Setting_Tablet_Texture_AspectRatio_Method_Hint)],
    [_modCategory, _tabletCategory],
    [
        [R2T_METHOD_SHRINK, R2T_METHOD_ZOOMCROP],
        ["Shrink-To-Fit", "Zoom-And-Crop"], //TODO: Localize these
        0
    ],
    0
] call CBA_fnc_addSetting;

[
    QGVAR(tabletFeedDealWithAspectRatioFullscreen),
    "LIST",
    [LLSTRING(Setting_Tablet_Texture_AspectRatio_Method), LLSTRING(Setting_Tablet_Texture_AspectRatio_Method_Hint)], //TODO: Share this between small and fullscreen?
    [_modCategory, _tabletCategory],
    [
        [R2T_METHOD_SHRINK, R2T_METHOD_ZOOMCROP],
        ["Shrink-To-Fit", "Zoom-And-Crop"], //TODO: Localize these
        0
    ],
    0
] call CBA_fnc_addSetting;

[
    QGVAR(tabletDesktopBackgroundMode),
    "LIST",
    [LLSTRING(Setting_Tablet_Desktop_Background_Mode), LLSTRING(Setting_Tablet_Desktop_Background_Mode_Hint)],
    [_modCategory, _tabletCategory],
    [[0, 1, 2], ["Preset", "Custom", "Color"], 0], //TODO: Localize these
    2
] call CBA_fnc_addSetting;

[
    QGVAR(tabletDesktopBackgroundPreset),
    "LIST",
    [LLSTRING(Setting_Tablet_Desktop_Background_Preset), LLSTRING(Setting_Tablet_Desktop_Background_Preset_Hint)],
    [_modCategory, _tabletCategory],
    [[
        QPATHTOEF(data,img\ui\desktop\classic\tablet_desktop_background_0_co.paa),
        QPATHTOEF(data,img\ui\desktop\classic\tablet_desktop_background_1_co.paa)
    ],
    [
        "Swoosh",
        "Blue-ish"
    ], 0],
    2
] call CBA_fnc_addSetting;

[
    QGVAR(tabletDesktopColor),
    "COLOR",
    [LLSTRING(Setting_Tablet_Desktop_Color), LLSTRING(Setting_Tablet_Desktop_Color_Hint)],
    [_modCategory, _tabletCategory],
    [0, 0.443, 0.348],
    2
] call CBA_fnc_addSetting;

[   //These images get cached the first time they are used from their path
    QGVAR(tabletDesktopCustomImageName),
    "EDITBOX",
    [LLSTRING(Setting_Tablet_Desktop_Custom_Image), LLSTRING(Setting_Tablet_Desktop_Custom_Image_Hint)],
    [_modCategory, _tabletCategory],
    "example_custom_tablet_desktop_background_co.jpg",
    2
] call CBA_fnc_addSetting;
