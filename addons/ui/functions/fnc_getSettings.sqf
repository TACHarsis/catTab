#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_getSettings
     Author(s):
        Gundy

     Description:
        Read cTab settings

    Parameters:
        0: STRING - Name of uiNamespace display / dialog variable
    (Optional)
        1: STRING - Name of individual property to read
     Returns:
     (If only parameter 0 is specified)
        ARRAY - All property pairs for that display / dialog are returned, like so: [["propertyName1",propertyValue1],["propertyName2",propertyValue2]]
            If the uiNamespace variable cannot be found in Ctab_ui_DisplayPropertyGroups, nil is returned.
    (If parameter 1 is specified)
        ANY - Value of individual property, nil if it does not exist
     Example:
        // Return all settings for Tablet
        [QGVARMAIN(Tablet_dlg)] call Ctab_ui_fnc_getSettings;
        // Return available map types for Tablet
        [QGVARMAIN(Tablet_dlg),QSETTING_MAP_TYPES] call Ctab_ui_fnc_getSettings;
*/
params ["_displayName",["_property",""]];

private _propertyGroupName = GVAR(displayPropertyGroups) get _displayName;

// Exit with nil if uiNamespace variable cannot be found in Ctab_ui_DisplayPropertyGroups
if (isNil "_propertyGroupName") exitWith {nil};

// Fetch common and interface group specific property pairs
private _commonProperties = GVAR(settings) get QSETTINGS_COMMON;
private _groupProperties = GVAR(settings) getOrDefault [_propertyGroupName, []];

// Return value of requested property
if (_property isNotEqualTo "") exitWith {
     _groupProperties getOrDefault [_property, _commonProperties getOrDefault [_property, nil]]
};

// Return list of all property pairs
private _combinedProperties = + _commonProperties;
{
    _combinedProperties set [_x,_y];
} forEach _groupProperties;

_combinedProperties
