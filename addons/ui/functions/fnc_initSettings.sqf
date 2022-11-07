#include "script_component.hpp"

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
            Example: [1,0,0] (red), [1,1,0,0.5] (semi transparent yellow)

*/
private _modCategory = "CatTab";//LLSTRING(Setting_Cagetory_Mod);

[
    QGVAR(enableAddon),
    "CHECKBOX",
    [LLSTRING(Setting_Enable_Addon), LLSTRING(Setting_Enable_Addon_Hint)],
    [_modCategory],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(androidDesktopColor),
    "COLOR",
    [LLSTRING(Setting_Tablet_Desktop_Color), LLSTRING(Setting_Tablet_Desktop_Color_Hint)],
    [_modCategory],
    [0.239,0.863,0.517],
	2
] call CBA_fnc_addSetting;

[
    QGVAR(tabletDesktopColor),
    "COLOR",
    [LLSTRING(Setting_Tablet_Desktop_Color), LLSTRING(Setting_Tablet_Desktop_Color_Hint)],
    [_modCategory],
    [0,0.443,0.348],
	2
] call CBA_fnc_addSetting;