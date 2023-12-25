#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
/*
    Name: Ctab_ui_fnc_createUavCam
    
    Author(s):
        Gundy, Cat Harsis

    Description:
        Set up UAV camera and display on supplied render target
        Modified to include lessons learned from KK's excellent tutorial: http://killzonekid.com/arma-scripting-tutorials-uav-r2t-and-pip/
    
    Parameters:
        0: OBJECT - UAV
        1: INTEGER - Camera Index
    
    Returns:
        BOOLEAN - If UAV cam could be set up or not
    
    Example:
        [_uavVehicle, 0] call Ctab_ui_fnc_createUavCam;
*/

params [["_uav", objNull, [objNull]], ["_camID", "", [""]]];

if(_camID isEqualTo "") exitWith {false};

private _camSetting = GVAR(uavCamSettings) getOrDefault [_camID, []];
if(_camSetting isEqualTo []) exitWith {false};
_camSetting params ["_camIdx", "_settingsName", "_uavNetID", "_idc"];

private _uavFrameCtrls = uiNamespace getVariable [QGVAR(UAVFrameCtrls), []];
// if(count _uavFrameCtrls <= _camIdx) exitWith {false};

// also does null-check
if !(alive _uav) exitWith {false};

// exit if requested UAV could not be found
if(!(_uav in GVARMAIN(UAVList))) exitWith {false};
private _frameCtrls = _uavFrameCtrls # _camIdx;
_frameCtrls params ["_frameGrp", "", "_videoCtrl"];
private _videoControllerCtrl = _frameGrp getVariable [QGVAR(videoController), controlNull];

if(_videoControllerCtrl isEqualTo controlNull) exitWith {false};
if(_videoCtrl isEqualTo controlNull) exitWith {false};
private _renderTargetName = _videoCtrl getVariable [QGVAR(renderTargetName), ""];

private _existingTarget = _videoControllerCtrl getVariable [QGVAR(cameraTarget), objNull];
if(!isNull _existingTarget && _existingTarget == _uav) exitWith {true};

// now that all checks have passed, remove existing UAV camera
[_camID] call FUNC(deleteUAVcam);

private _content = _frameGrp getVariable [QGVAR(content), []];
private _nameTextCtrl = _content # 1 # 0;

// retrieve memory point name from vehicle config
private _config = (configFile >> "CfgVehicles" >> typeOf _uav);
private _camPosMemPt = getText (_config >> "uavCameraGunnerPos");
private _camDirMemPt = getText (_config >> "uavCameraGunnerDir");

// If memory points could be retrieved, create camera
if (_camPosMemPt isNotEqualTo "" && {_camDirMemPt isNotEqualTo ""}) then {
    private _cam = "camera" camCreate [0, 0,0 ];
    _cam attachTo [_uav, [0, 0, 0], _camPosMemPt, true];
    // set up cam on render target
    _cam cameraEffect ["INTERNAL", "BACK", _renderTargetName];
    //private _turretPath = [];
    //private _visionMode = _uav currentVisionMode [];
    private _visionMode = [0, 0];
    _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
    _cam camSetFov 0.1; // set zoom
    _cam camCommit 0;
    private _newCam = [_camID, _uav, _renderTargetName, _cam, _frameGrp];
    GVAR(UAVCamsData) set [_camID, _newCam];

    _videoControllerCtrl ctrlEnable true;
    _videoControllerCtrl setVariable [QGVAR(cameraTarget), _uav];
    _videoControllerCtrl setVariable [QGVAR(cameraTargetType), "UAV"];
    private _visionModes = _uav getVariable [QGVAR(visionModes), [[0, 0], [1, 0], [2, 0]]];
    private _currentVisionMode = _uav getVariable [QGVAR(currentVisionMode), 0];
    _uav setVariable [QGVAR(visionModes), _visionModes];
    _uav setVariable [QGVAR(currentVisionMode), _currentVisionMode];
    private _fov = _uav getVariable [QGVAR(targetFovHash), 0.75];
    _uav setVariable [QGVAR(targetFovHash), _fov];

    //_nameTextCtrl ctrlSetText (name _uav);
    _nameTextCtrl ctrlSetText (getText (configfile >> "cfgVehicles" >> typeOf _uav >> "displayname"));
};

// set up event handler
if (count GVAR(UAVCamsData) > 0) exitWith {
    if (isNil QGVAR(uavEventHandle)) then {
        GVAR(uavEventHandle) = [
            {
                private _removedUAVs = [];
                {
                    if(count _y == 0) then { continue; };

                    _y params ["_camID", "_uav","_renderTargetName","_cam","_frameGrp"];

                    if(ctrlShown _frameGrp) then {
                        if (alive _uav) then {
                            private _fov = _uav getVariable [QGVAR(targetFovHash), 0.75];
                            _cam camSetFov _fov;

                            private _visionModes = _uav getVariable [QGVAR(visionModes), [[0, 0]]];
                            private _currentVisionMode = _uav getVariable [QGVAR(currentVisionMode), 0];
                            private _visionMode = _visionModes # _currentVisionMode;
                            _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
                            //TODO: Set the mode on the actual drone with setTurretOpticsMode? Will need a dirty flag so it doesn't just get overridden all the time

                            _cam camCommit 0.1;
                        } else {
                            _removedUAVs pushBack _camID;
                        };
                    };
                } foreach GVAR(UAVCamsData);
                {
                    [_x] call FUNC(deleteUAVcam);
                } foreach _removedUAVs;
            },
            0
        ] call CBA_fnc_addPerFrameHandler;
    };
    //[QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV, _uav call BIS_fnc_netId]]] call FUNC(setSettings); // that just sets what has been set to call this?!
};

true
