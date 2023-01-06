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
        [str _uavVehicle,[[0,"uavDriverRenderTarget"],[1,"uavGunnerRenderTarget"]]] call Ctab_ui_fnc_createUavCam;
*/
params ["_data","_uavCams"];

#include "..\devices\shared\cTab_defines.hpp"

private _uav = objNull;
// see if given UAV name is still in the list of valid UAVs
{
    if (_data isEqualTo _x) exitWith {_uav = _x;};
} foreach GVARMAIN(UAVList);

// remove exisitng UAV cameras
[] call FUNC(deleteUAVcam);

// exit if requested UAV could not be found
if (isNull _uav) exitWith {false};

// exit if requested UAV is not alive
if !(alive _uav) exitWith {false};

{
    _x params ["_seat", "_renderTargetName", "_videoImage"];
    if(_videoImage isEqualTo controlNull) then { continue };
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
            //private _visionMode = _uav currentVisionMode [];
            private _visionMode = [0,0];
            _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
            _cam camSetFov 0.1; // set zoom
            []
        } else { // driver
            //private _visionMode = _uav currentVisionMode [-1];
            private _visionMode = [0,0];
            _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
            _cam camSetFov 0.75; // set default zoom
            [-1]
        };
        _cam camCommit 0;
        private _newCam = [_uav,_renderTargetName,_cam,_videoImage,_camPosMemPt,_camDirMemPt, _turretPath];
        GVAR(uAVcamsData) pushBack _newCam;

        _videoImage ctrlEnable true;
        _videoImage setVariable [QGVAR(cameraTarget), _uav];
        _videoImage setVariable [QGVAR(cameraTargetType), "UAV"];
        private _visionModes = _uav getVariable [QGVAR(visionModes), [[0,0],[1,0],[2,0]]];
        private _currentVisionMode = _uav getVariable [QGVAR(currentVisionMode), 0];
        _uav setVariable [QGVAR(visionModes), _visionModes];
        _uav setVariable [QGVAR(currentVisionMode), _currentVisionMode];
        private _fov = _uav getVariable [QGVAR(targetFovHash),0.75];
        _uav setVariable [QGVAR(targetFovHash),_fov];
    };
} foreach _uavCams;

// set up event handler
if !(GVAR(uAVcamsData) isEqualTo []) exitWith {
    if (isNil QGVAR(uavEventHandle)) then {
        GVAR(uavEventHandle) = [
            {
                private _removedUAVs = [];
                {
                    _x params  ["_uav","_renderTargetName","_cam","_videoImage", "_camPosMemPt","_camDirMemPt", "_turretPath"];

                    if(ctrlShown _videoImage) then {
                        if (alive _uav) then {
                            private _fov = _uav getVariable [QGVAR(targetFovHash),0.75];
                            _cam camSetFov _fov;
                            private _dir = (_uav selectionPosition (_camPosMemPt)) vectorFromTo (_uav selectionPosition (_camDirMemPt));
                            _cam setVectorDirAndUp [_dir,_dir vectorCrossProduct [-(_dir select 1), _dir select 0, 0]];
                            //private _visionMode = _uav currentVisionMode _turretPath;
                            private _visionModes = _uav getVariable [QGVAR(visionModes), [[0,0]]];
                            private _currentVisionMode = _uav getVariable [QGVAR(currentVisionMode), 0];
                            private _visionMode = _visionModes # _currentVisionMode;
                            //diag_log format["Setting new vision mode on renderTarget (%1): %2", _renderTargetName, [_visionMode # 0, _visionMode # 1]];
                            _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
                            _cam camCommit 0.1;
                        } else {
                            _removedUAV pushBack _cam;
                        };
                    };
                } foreach GVAR(uAVcamsData);
                {
                    [_x] call FUNC(deleteUAVcam);
                } foreach _removedUAVs;
            },
            0
        ] call CBA_fnc_addPerFrameHandler;
    };
    [QGVARMAIN(Tablet_dlg),[[QSETTING_CAM_UAV,_uav call BIS_fnc_netId]]] call FUNC(setSettings);
};
