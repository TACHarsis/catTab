#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_setSettings
     Author(s):
        Gundy

     Description:
        Write cTab settings. Will call cTab_updateInterface for any setting that changed.

    Parameters:
        0: STRING - Name of uiNamespace display / dialog variable
        1: ARRAY  - Property pair(s) to write in the form of [["propertyName",propertyValue],[...]]
        (Optional)
        2: BOOLEAN - If set to false, do not update interface (default true)
        3: BOOLEAN - If set to true, update interface even if the values haven't changed (default false)
     Returns:
         BOOLEAN - If settings could be stored

     Example:
        [QGVARMAIN(Tablet_dlg),[[QSETTING_CURRENT_MAP_TYPE,QMAP_TYPE_SAT],[QSETTING_MAP_SCALE_DISPLAY,"4"]]] call Ctab_ui_fnc_setSettings;
        // Update mapWorldPos and update the interface even if the value has not changed
        [QGVARMAIN(Tablet_dlg),[[QSETTING_MAP_WORLD_POS,getPosASL vehicle player]],true,true] call Ctab_ui_fnc_setSettings;
        // Update mapWorldPos and mapScale, but do not update the interface
        [QGVARMAIN(Tablet_dlg),[[QSETTING_MAP_WORLD_POS,getPosASL vehicle player],[QSETTING_MAP_SCALE_DISPLAY,"2"]],false] call Ctab_ui_fnc_setSettings;
*/
params ["_displayName","_properties", ["_updateInterface", true, [false]], ["_forceInterfaceUpdate", false, [true]]];

private _propertyGroupName = GVAR(displayPropertyGroups) get (_displayName);

// Exit with FALSE if uiNamespace variable cannot be found in Ctab_ui_DisplayPropertyGroups
if (isNil "_propertyGroupName") exitWith {false};

private _commonProperties = GVAR(settings) get QSETTINGS_COMMON;
private _groupProperties = GVAR(settings) getOrDefault [_propertyGroupName, []];

// Write multiple property pairs. If they exist in _groupProperties, write them there, else write them to COMMON. Only write if they exist and have changed.
private _commonPropertiesUpdate = createHashMap;
private _combinedPropertiesUpdate = createHashMap;
{
    _x params ["_key", "_value"];
    _currentValue = _groupProperties get _key;
    if !(isNil "_currentValue") then { // Hit
        if !(_currentValue isEqualTo _value) exitWith {
            _combinedPropertiesUpdate set [_key,_value];
            _groupProperties set [_key,_value];
        };
        if (_forceInterfaceUpdate) then {
            _combinedPropertiesUpdate set [_key,_value];
        };
    } else  { // No Hit
        // check common value
        _currentValue = _commonProperties get _key;
        if !(isNil "_currentValue") then { // Hit in common
            if !(_currentValue isEqualTo _value) then {
                _commonPropertiesUpdate set [_key,_value];
                _commonProperties  set [_key,_value];
            } else {
                if (_forceInterfaceUpdate) then {
                    _commonPropertiesUpdate  set [_key,_value];
                };
            };
        };
    };
} forEach _properties;
GVAR(settings) set [_propertyGroupName,_groupProperties];
GVAR(settings) set [QSETTINGS_COMMON,_commonProperties];

// Finally, call an interface update for the updated properties, but only if the currently interface uses the same property group, if not, pass changed common properties only.
if !(isNil QGVAR(ifOpen)) then {
    if (_updateInterface) then {
        if (    ((GVAR(displayPropertyGroups) get (GVAR(ifOpen) select 1)) == _propertyGroupName) && 
                {count _combinedPropertiesUpdate > 0}
        ) then {
            [_combinedPropertiesUpdate] call FUNC(updateInterface);
        } else {
            if (count _commonPropertiesUpdate > 0) then {
                [_commonPropertiesUpdate] call FUNC(updateInterface);
            };
        };
    };
};

! (_combinedPropertiesUpdate isEqualTo [] && _combinedPropertiesUpdate isEqualTo [])
