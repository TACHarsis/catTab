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
params ["_camPos"];

private _displayName = GVAR(ifOpen) select 1;
private _uav = objNull;
private _uavNetId = [_displayName,QSETTING_CAM_UAV] call FUNC(getSettings);
private _uav = _uavNetId call BIS_fnc_objectFromNetId;

// see if given UAV name is still in the list of valid UAVs
if! (_uav in GVARMAIN(UAVList)) exitWith {};

if(isNull _uav) then {
    _uav = GVAR(currentUAV);
};

if !(isNull _uav) exitWith {
    
    if (count _camPos == 2) then {
        _camPos = _camPos + [getTerrainHeightASL _camPos];
    };
    _uav lockCameraTo [_camPos,[0]];
    
    true
};

false