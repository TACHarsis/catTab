#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
/*
     Name: Ctab_ui_fnc_createHelmetCam
     
     Author(s):
        Gundy, Riouken, Cat Harsis

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
params [["_unit", objNull, [objNull]], ["_camID", "", [""]]];
if(_camID isEqualTo "") exitWith {false};
private _camSetting = GVAR(helmetCamSettings) getOrDefault [_camID, []];
if(_camSetting isEqualTo []) exitWith {false};
_camSetting params ["_camIdx", "_settingsName", "_unitNetID", "_idc"];
if(_camIdx < -1) exitWith {false};
private _hCamFrameCtrls = uiNamespace getVariable [QGVAR(HCAMFrameCtrls), []];
// exit if requested unit is not alive, also does null check
if !(alive _unit) exitWith {false};
// exit if requested unit could not be found
if(!(_unit in GVARMAIN(hCamList))) exitWith {false};
private _frameCtrls = _hCamFrameCtrls # _camIdx;
_frameCtrls params ["_frameGrp", "", "_videoCtrl"];
private _videoControllerCtrl = _frameGrp getVariable [QGVAR(videoController), controlNull];

if(_videoControllerCtrl isEqualTo controlNull) exitWith {false};
if(_videoCtrl isEqualTo controlNull) exitWith {false};
private _renderTargetName = _videoCtrl getVariable [QGVAR(renderTargetName), ""];
if(_renderTargetName isEqualTo "") exitWith {false};
private _existingTarget = _videoControllerCtrl getVariable [QGVAR(cameraTarget), objNull];
if(!isNull _existingTarget && _existingTarget == _unit) exitWith {true};
// now that all checks have passed, remove existing UAV camera
[_camID] call FUNC(deleteHelmetCam);

private _content = _frameGrp getVariable [QGVAR(content), []];
private _heartIconCtrl = _content # 1 # 0;
private _heartTextIconCtrl = _content # 2 # 0;
private _nameTextCtrl = _content # 3 # 0;

private _camOffSet = [];
private _targetOffSet = [];
private _unitVehicle = vehicle _unit;

    // should unit not be in a vehicle
if (_unitVehicle isKindOf "CAManBase") then {
        _camOffSet = [0.12, 0, 0.15];
        _targetOffSet = [0, 8, 1];
} else {
    // if unit is in a vehilce, see if 3rd person view is allowed
    // 3rd person view (0 = disabled, 1 = enabled, 2 = enabled for vehicles only (Since  Arma 3 v1.99))
    if (difficultyOption "3rdPersonView" > 0) exitWith {
        _unit = _unitVehicle;
        // Might want to calculate offsets based on the actual vehicle dimensions in the future
        _camOffSet = [0, -8, 4];
        _targetOffSet = [0, 8, 2];
    };
    // if unit is in a vehicle and 3rd person view is not allowed
    _unit = objNull;
};

// if there is no valid unit or we are not allowed to set up a helmet cam in these conditions, drop out of full screen view
if (isNull _unit) exitWith {
    [QGVARMAIN(Tablet_dlg), [[QSETTING_MODE, QSETTING_MODE_CAM_HCAM]]] call FUNC(setSettings);
};

private _cam = "camera" camCreate getPosATL _unit;
_cam camPrepareFov 0.700;
_cam camCommitPrepared 0;

if (vehicle _unit == _unit) then {
    _cam attachTo [_unit, _camOffSet, "head", true];
} else {
    _cam attachTo [_unit, _camOffSet];
};
_cam cameraEffect ["INTERNAL", "BACK", _renderTargetName];
private _newCam = [_camID, _unit, _renderTargetName, _cam, _frameGrp, _heartIconCtrl, _heartTextIconCtrl];
GVAR(HelmetCamsData) set [_camID, _newCam];

_videoControllerCtrl ctrlEnable true;
_videoControllerCtrl setVariable [QGVAR(cameraTarget), _unit];
_videoControllerCtrl setVariable [QGVAR(cameraTargetType), "HelmetCam"];

private _visionModes = _unit getVariable [QGVAR(visionModes), [[0, 0], [1, 0]]];
private _currentVisionMode = _unit getVariable [QGVAR(currentVisionMode), 0];
_unit setVariable [QGVAR(visionModes), _visionModes];
_unit setVariable [QGVAR(currentVisionMode), _currentVisionMode];
private _fov = _unit getVariable [QGVAR(targetFovHash), 0.75];
_unit setVariable [QGVAR(targetFovHash), _fov];

_nameTextCtrl ctrlSetText (name _unit);
_heartTextIconCtrl ctrlSetText "90bpm 80/60";
_heartIconCtrl setVariable [QGVAR(time), 0];

//TODO: Tripple  check that the heartbeat animation is actually the right frequency and comment how and why, so I don't have to do this again
if(isNil QGVAR(helmetEventHandle)) then {
    GVAR(helmetEventHandle) = [
        {
            private _removedHCams = [];
            {
                if(count _y == 0) then { continue; };

                _y params ["_camID", "_unit", "_renderTargetName", "_cam", "_frameGrp", "_heartIconCtrl", "_heartTextIconCtrl"];
                if(ctrlShown _frameGrp) then {
                    private _fov = _unit getVariable [QGVAR(targetFovHash), 0.7];
                    _cam camSetFov _fov;

                    private _visionModes = _unit getVariable [QGVAR(visionModes), [[0, 0]]];
                    private _currentVisionMode = _unit getVariable [QGVAR(currentVisionMode), 0];
                    private _visionMode = _visionModes # _currentVisionMode;
                    _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];

                    _cam camCommit 0.1;

                    private _healthData = [_unit] call EFUNC(core,getUnitHealthData);
                    _healthData params ["_alive", "_conscious", "_health", "_bpm", "_stringHint", "_colorHint"];
                    _heartIconCtrl ctrlSetTextColor _colorHint;
                    _heartTextIconCtrl ctrlSetTextColor _colorHint;
                    _heartTextIconCtrl ctrlSetText _stringHint;

                    if(_bpm > 0) then {
                        private _wavePeriod = (60/_bpm);

                        private _iconTime = _heartIconCtrl getVariable [QGVAR(time), 0];

                        _iconTime = (_iconTime + diag_deltaTime) % _wavePeriod;

                        _heartIconCtrl setVariable [QGVAR(time), _iconTime];

                        private _images = [
                            "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa",
                            "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u75_ca.paa",
                            "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u100_ca.paa",
                            "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u75_ca.paa"
                        ];
                        private _timePerImage = _wavePeriod / (count _images + 1);
                        private _imageIdx = floor (_iconTime / _timePerImage);
                        if(_imageIdx == 5) then { diag_log "LOOOOOOOOOOOOOOL"};
                        _heartIconCtrl ctrlSetText (_images # _imageIdx);
                    } else {
                        _heartIconCtrl ctrlSetText "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\d100_ca.paa";
                    };
                };

            } foreach GVAR(HelmetCamsData);
        },
        0
    ] call CBA_fnc_addPerFrameHandler;
};
