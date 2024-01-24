#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_lockUavCamTo
    
    Author(s):
        Gundy

    Description:
        Lock the currently selected UAV's gunner camera to the provided coordinates
    
    Parameters:
        0: ARRAY - 2D or 3D position
    
    Returns:
        BOOLEAN - If UAV was found
    
    Example:
        [getPos player] call Ctab_ui_fnc_lockUavCamTo;
*/
params ["_camPos", "_camIdx"];

//TODO: Fix this function, it ignores camidx and only works on selected uav

private _displayName = GVAR(ifOpen) select 1;

if !(isNull GVAR(selectedUAV)) exitWith {
    if (count _camPos == 2) then {
        _camPos = _camPos + [getTerrainHeightASL _camPos];
    };
    GVAR(selectedUAV) lockCameraTo [_camPos, [0]];
    
    true
};

false
