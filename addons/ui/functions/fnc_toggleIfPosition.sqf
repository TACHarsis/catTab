#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_toggleIfPosition
    
    Author(s):
        Gundy
    
    Description:
        Toggle position of interface (display only) from left to right or reset dialog to default position
        
    
    Parameters:
        NONE
    
    Returns:
        BOOLEAN - TRUE
    
    Example:
        [] call Ctab_ui_fnc_toggleIfPosition;
*/

// bail if there is no interface open
if (isNil QGVAR(ifOpen)) exitWith {false};

private _displayName = GVAR(ifOpen) select 1;

if ([_displayName] call FUNC(isDialog)) then {
    // reset position to default
    [_displayName,[[QSETTING_POSITION_DIALOG,[]]],true,true] call FUNC(setSettings);
} else {
    private _dspIfPosition = [_displayName,QSETTING_POSITION_DISPLAY] call FUNC(getSettings);
    // toggle position
    [_displayName,[[QSETTING_POSITION_DISPLAY,!_dspIfPosition]]] call FUNC(setSettings);
};

true
