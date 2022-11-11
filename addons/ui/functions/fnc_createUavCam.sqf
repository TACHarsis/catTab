#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_createUavCam
    
    Author(s):
        Gundy

    Description:
        Set up UAV camera and display on supplied render target
        Modified to include lessons learned from KK's excellent tutorial: http://killzonekid.com/arma-scripting-tutorials-uav-r2t-and-pip/
    
    Parameters:
        0: STRING - Name of UAV (format used from `str uavObject`)
        1: ARRAY  - List of arrays with seats with render targets
            0: INTEGER - Seat
                0 = DRIVER
                1 = GUNNER
            1: STRING  - Name of render target
    
    Returns:
        BOOLEAN - If UAV cam could be set up or not
    
    Example:
        [str _uavVehicle,[[0,"rendertarget8"],[1,"rendertarget9"]]] call Ctab_ui_fnc_createUavCam;
*/
params ["_data","_uavCams", "_uavMapCtrl"];

private _uav = objNull;

// see if given UAV name is still in the list of valid UAVs
{
    if (_data == _x) exitWith {_uav = _x;};
} foreach GVARMAIN(UAVList);

// remove exisitng UAV cameras
[] call FUNC(deleteUAVcam);

// exit if requested UAV could not be found
if (isNull _uav) exitWith {false};

// exit if requested UAV is not alive
if !(alive _uav) exitWith {false};

{
    _x params ["_seat", "_renderTargetName"];

    // check existing cameras
    _cam = objNull;
    private _camPosMemPt = "";
    private _camDirMemPt = "";
    
    private _seatName = switch (_seat) do {
        case (0) : {"Driver"};
        case (1) : {"Gunner"};
        default {""};
    };
    if (_seatName != "") then {
        // retrieve memory point names from vehicle config
        _camPosMemPt = getText (configFile >> "CfgVehicles" >> typeOf _uav >> "uavCamera" + _seatName + "Pos");
        _camDirMemPt = getText (configFile >> "CfgVehicles" >> typeOf _uav >> "uavCamera" + _seatName + "Dir");
    };
    // If memory points could be retrieved, create camera
    if ((_camPosMemPt != "") && (_camDirMemPt != "")) then {
        private _cam = "camera" camCreate [0,0,0];
        _cam attachTo [_uav,[0,0,0],_camPosMemPt];
        // set up cam on render target
        _cam cameraEffect ["INTERNAL","BACK",_renderTargetName];
        private _turretPath = if (_seat == 1) then {
            private _visionMode = _uav currentVisionMode [];
            _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
            _cam camSetFov 0.1; // set zoom
            []
        } else {
            private _visionMode = _uav currentVisionMode [-1];
            _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
            _cam camSetFov 0.5; // set default zoom
            [-1]
        };
        _cam camCommit 0;
        GVAR(uAVcams) pushBack [_uav,_renderTargetName,_cam,_camPosMemPt,_camDirMemPt, _turretPath];
    };
} foreach _uavCams;

// set up event handler
if !(GVAR(uAVcams) isEqualTo []) exitWith {
    if (isNil QGVAR(uavEventHandle)) then {
        GVAR(uavEventHandle) = [
            {
                params ["_uavMapCtrl", "_handle"];
                if(ctrlShown _uavMapCtrl) then {
                    private _removedUAVs = [];
                    {
                        _x params  ["_uav","_renderTargetName","_cam","_camPosMemPt","_camDirMemPt", "_turretPath"];
                        
                        if (alive _uav) then {
                            private _dir = (_uav selectionPosition (_camPosMemPt)) vectorFromTo (_uav selectionPosition (_camDirMemPt));
                            _cam setVectorDirAndUp [_dir,_dir vectorCrossProduct [-(_dir select 1), _dir select 0, 0]];
                            private _visionMode = _uav currentVisionMode _turretPath;
                            _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
                            _cam camCommit 0;
                        } else {
                            _removedUAV pushBack _cam;
                        };
                    } foreach GVAR(uAVcams);
                    {
                        [_x] call FUNC(deleteUAVcam);
                    } foreach _removedUAVs;
                };
            },
            0,
            _uavMapCtrl
        ] call CBA_fnc_addPerFrameHandler;
    };
    GVAR(currentUAV) = _uav;
    true
};

false
