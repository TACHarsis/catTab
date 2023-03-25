#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
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
        ["helmetCamRenderTarget",str player] spawn Ctab_ui_fnc_createHelmetCam;
*/
params ["_renderTarget", "_data", "_videoImage", "_videoController"];

private _ctrlGrp = ctrlParentControlsGroup _videoImage;
private _heartIcon = _ctrlGrp controlsGroupCtrl IDC_CTAB_HCAMICON1;
private _heartTextIcon = _ctrlGrp controlsGroupCtrl IDC_CTAB_HCAMICON2;
private _nameIcon = _ctrlGrp controlsGroupCtrl IDC_CTAB_HCAMICON3;

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

// delete old camera, fuck optimization
[] call FUNC(deleteHelmetCam);

// only continue if there is no helmet cam currently set up
if !(isNil QGVAR(helmetCamData)) exitWith {true};

private _target = "Sign_Sphere10cm_F" createVehicleLocal position player;
hideObject _target;
_target attachTo [_unit,_targetOffSet];

private _cam = "camera" camCreate getPosATL _unit;
_cam camPrepareFov 0.700;
//_cam camPrepareTarget _target;
_cam camCommitPrepared 0;

if (vehicle _unit == _unit) then {
    _cam attachTo [_unit,_camOffSet,"head", true];
} else {
    _cam attachTo [_unit,_camOffSet];
};
_cam cameraEffect ["INTERNAL","BACK",_renderTarget];

GVAR(helmetCamData) = [_cam,_target,_unit];


_videoImage ctrlEnable true;
_videoImage setVariable [QGVAR(cameraTarget), _unit];
_videoImage setVariable [QGVAR(cameraTargetType), "HelmetCam"];
_videoController setVariable [QGVAR(videoTarget), _videoImage];

private _visionModes = _unit getVariable [QGVAR(visionModes), [[0,0],[1,0]]];
private _currentVisionMode = _unit getVariable [QGVAR(currentVisionMode), 0];
_unit setVariable [QGVAR(visionModes), _visionModes];
_unit setVariable [QGVAR(currentVisionMode), _currentVisionMode];
private _fov = _unit getVariable [QGVAR(targetFovHash),0.75];
_unit setVariable [QGVAR(targetFovHash),_fov];

_nameIcon ctrlSetText (name _unit);
_heartTextIcon ctrlSetText "90bpm 80/60";
_heartIcon setVariable [QGVAR(time), 0];

[QGVARMAIN(Tablet_dlg),[[QSETTING_CAM_HELMET,_unit call BIS_fnc_netId]]] call FUNC(setSettings);

private _fnc_updateHelmetCam = {
    if(isNil QGVAR(helmetCamData)) exitWith {};

    params ["_params", "_handle"];
    _params params ["_videoImage", "_heartIcon", "_heartTextIcon", "_renderTarget"];
    if(ctrlShown _videoImage) then {

        private _removedHCams = [];

        GVAR(helmetCamData) params  ["_cam","_target","_unit"];;

        private _fov = _unit getVariable [QGVAR(targetFovHash),0.7];
        _cam camSetFov _fov;

        private _visionModes = _unit getVariable [QGVAR(visionModes), [[0,0]]];
        private _currentVisionMode = _unit getVariable [QGVAR(currentVisionMode), 0];
        private _visionMode = _visionModes # _currentVisionMode;
        _renderTarget setPiPEffect [_visionMode # 0, _visionMode # 1];

        _cam camCommit 0.1;

        private _healthData = [_unit] call EFUNC(core,getUnitHealthData);
        _healthData params ["_alive", "_conscious", "_health", "_bpm", "_stringHint", "_colorHint"];

        _heartIcon ctrlSetTextColor _colorHint;
        _heartTextIcon ctrlSetTextColor _colorHint;
        _heartTextIcon ctrlSetText _stringHint;

        if(_bpm > 0) then {
            private _wavePeriod = (60/_bpm);

            private _iconTime = _heartIcon getVariable [QGVAR(time), 0];

            _iconTime = (_iconTime + diag_deltaTime) % _wavePeriod;

            _heartIcon setVariable [QGVAR(time), _iconTime];

            private _images = [
                "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa",
                "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u75_ca.paa",
                "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u100_ca.paa",
                "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u75_ca.paa"
            ];
            private _timePerImage = _wavePeriod / (count _images + 1);
            private _imageIdx = floor (_iconTime / _timePerImage);
            if(_imageIdx == 5) then { diag_log "LOOOOOOOOOOOOOOL"};
            _heartIcon ctrlSetText (_images # _imageIdx);
        } else {
            _heartIcon ctrlSetText "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\d100_ca.paa";
        };
    };
};

GVAR(helmetEventHandle) = [
    _fnc_updateHelmetCam,
    0,
    [_videoImage, _heartIcon, _heartTextIcon, _renderTarget]
] call CBA_fnc_addPerFrameHandler;

[QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_HELMET, _unit call BIS_fnc_netId]]] call FUNC(setSettings);

