#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_createHelmetCam
     
     Author(s):
        Gundy, Riouken

     Description:
        Set up helmet camera and display on supplied render target
    
    Parameters:
        0: STRING - Render target
        1: STRING - Name of unit with helmet camera (format used from `str unitObject`)
     
     Returns:
        BOOLEAN - If helmet cam could be set up or not
     
     Example:
        ["rendertarget12",str player] spawn Ctab_ui_fnc_createHelmetCam;
*/
params ["_renderTarget","_data"];

private _unit = _data call BIS_fnc_objectFromNetId;
private _camOffSet = [];
private _targetOffSet = [];
private _unitVehicle = vehicle _unit;

if !(isNull _unit) then {
        // should unit not be in a vehicle
    if (_unitVehicle isKindOf "CAManBase") then {
            _camOffSet = [0.12,0,0.15];
            _targetOffSet = [0,8,1];
    } else {
        // if unit is in a vehilce, see if 3rd person view is allowed
        // 3rd person view (0 = disabled, 1 = enabled, 2 = enabled for vehicles only (Since  Arma 3 v1.99))
        if (difficultyOption "3rdPersonView" > 0) exitWith {
            _unit = _unitVehicle;
            // Might want to calculate offsets based on the actual vehicle dimensions in the future
            _camOffSet = [0,-8,4];
            _targetOffSet = [0,8,2];
        };
        // if unit is in a vehicle and 3rd person view is not allowed
        _unit = objNull;
    };
};

// if there is no valid unit or we are not allowed to set up a helmet cam in these conditions, drop out of full screen view
if (IsNull _unit) exitWith {
    [QGVARMAIN(Tablet_dlg),[[QSETTING_MODE,QSETTING_MODE_CAM_HELMET]]] call FUNC(setSettings);
};

// if there is already a camera, see if its the same one we are about to set up
// if true, render to given target (in case the target has changed), else delete the camera so we can create a new one
if !(isNil QGVAR(helmetCams)) then {
    private _oldCam = GVAR(helmetCams) select 0;
    private _oldUnit = GVAR(helmetCams) select 2;
    if (_oldUnit isEqualTo _unit) then {
        _oldCam cameraEffect ["INTERNAL","BACK",_renderTarget];
    } else {
        private _nop = [] call FUNC(deleteHelmetCam);
        waitUntil {_nop};
    };
};

// only continue if there is no helmet cam currently set up
if !(isNil QGVAR(helmetCams)) exitWith {true};

private _target = "Sign_Sphere10cm_F" createVehicleLocal position player;
hideObject _target;
_target attachTo [_unit,_targetOffSet];

private _cam = "camera" camCreate getPosATL _unit;
_cam camPrepareFov 0.700;
_cam camPrepareTarget _target;
_cam camCommitPrepared 0;

if (vehicle _unit == _unit) then {
    _cam attachTo [_unit,_camOffSet,"Head"];
} else {
    _cam attachTo [_unit,_camOffSet];
};
_cam cameraEffect ["INTERNAL","BACK",_renderTarget];

GVAR(helmetCams) = [_cam,_target,_unit];