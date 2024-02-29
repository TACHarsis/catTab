#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
/*
    Name: Ctab_ui_fnc_createVideoSourceCam
    Author(s):
        Gundy, Cat Harsis

    Description:
        Set up video source camera and display on supplied render target
        Modified to include lessons learned from KK's excellent tutorial: http://killzonekid.com/arma-scripting-tutorials-uav-r2t-and-pip/
    Parameters:
        0: STRING - Video source type
        1: OBJECT - Unit to attach cam to
        2: STRING - Camera ID equals setting name
    Returns:
        BOOLEAN - If cam could be set up or not
    Example:
        [_type, _unit, ""] call Ctab_ui_fnc_createVideoSourceCam;
*/

params ["_type", ["_unitNetID", "", [""]], ["_camID", "", [""]]];
// WARNING ["Creating cam for %1", _unit];
if(_camID isEqualTo "") exitWith {
    WARNING_2("[VideoSourceCamCreation] Could not create Video Source Cam: missing camera ID. Type: %1, UnitNetID: %2",_type,_unitNetID);
    (false)
};


private _context = GVAR(videoSourcesContext) get _type;
private _slotSettings = _context get QGVAR(slotSettings);
private _frameGroupCtrls = [] call (_context get QGVAR(fnc_getVideoSlotUIs));
private _videoSourcesHash = _context get QGVAR(sourcesHash);
private _videoSourceData = _videoSourcesHash getOrDefault [_unitNetID, []];

private _slotSetting = _slotSettings getOrDefault [_camID, []];
if(_slotSetting isEqualTo []) exitWith {
    WARNING_2("[VideoSourceCamCreation] Could not create Video Source Cam: unable to retrieve slot setting. Type: %1, camera ID %2",_type,_camID);
    (false)
};


_slotSetting params ["_slotIdx", "_slotSettingsName", "_slotIDC"];
if(count _frameGroupCtrls <= _slotIdx) exitWith {
    WARNING_3("[VideoSourceCamCreation] Could not create Video Source Cam: slot index out of bounds. Type: %1, camera ID %2, slotIdx: %2",_type,_camID,_slotIdx);
    (false)
};


// exit if requested data could not be found
if(_videoSourceData isEqualTo []) exitWith {
    WARNING_3("[VideoSourceCamCreation] Could not create Video Source Cam: video source data empty. Type: %1, camera ID %2, slotIdx: %2",_type,_camID,_slotIdx);
    (false)
};


private _frameGroupCtrls = _frameGroupCtrls # _slotIdx;
// WARNING ["CreateVideo Source _frameGroupCtrls: %1", _frameGroupCtrls];

_frameGroupCtrls params ["_frameGrpCtrl"];
// WARNING ["CreateVideo Source allVariables _frameGrpCtrl: %1", allVariables _frameGrpCtrl];
private _contentGrpCtrl = _frameGrpCtrl getVariable QGVAR(contentGrpCtrl);
// WARNING ["CreateVideo Source _contentGrpCtrl: %1", _contentGrpCtrl];
private _videoControllerCtrl = _contentGrpCtrl getVariable [QGVAR(feed_controllerCtrl), controlNull];
private _videoCtrl = _contentGrpCtrl getVariable QGVAR(videoCtrl);
// WARNING ["CreateVideo Source _videoControllerCtrl: %1", _videoControllerCtrl];

if(_videoControllerCtrl isEqualTo controlNull) exitWith {
    WARNING_3("[VideoSourceCamCreation] Could not create Video Source Cam: could not find video controller control. Type: %1, camera ID %2, slotIdx: %2",_type,_camID,_slotIdx);
    (false)
};


if(_videoCtrl isEqualTo controlNull) exitWith {
    WARNING_3("[VideoSourceCamCreation] Could not create Video Source Cam: could not find video control. Type: %1, camera ID %2, slotIdx: %2",_type,_camID,_slotIdx);
    (false)
};


private _renderTargetName = _videoCtrl getVariable [QGVAR(renderTargetName), ""];
// now that all checks have passed, remove existing video source camera
[_type, _camID] call FUNC(deleteVideoSourceCam);

//TAG: video source data
_videoSourceData params ["", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];

private _cam = objNull;
private _unitExists = !isNull _unit;
// if(true) exitWith {false};
if(_unitExists) then {
    private _existingTarget = _videoControllerCtrl getVariable [QGVAR(cameraTarget), objNull];
    if!(!isNull _existingTarget && _existingTarget == _unit) then {
        private _fnc_getCameraSettings = _context get QGVAR(fnc_getCameraSettings);
        private _cameraSettings = [_unit] call _fnc_getCameraSettings;
        _cameraSettings params ["_offset", "_memoryPoint"];
        if(!isNil "_memoryPoint") then {
            //TODO: memorypoint not existing on some UAVs causes error here
            _cam = "camera" camCreate [0, 0,0 ];
            _cam attachTo [_unit, _offset, _memoryPoint, true];
            // set up cam on render target
            _cam cameraEffect ["INTERNAL", "BACK", _renderTargetName];
            //TODO: Pull allowed vision modes from context
            private _defaultVisionMode = [0, 0];
            _renderTargetName setPiPEffect [_defaultVisionMode # 0, _defaultVisionMode # 1];
            _cam camSetFov 0.1; // set zoom
            _cam camCommit 0;

            private _visionModes = _unit getVariable [QGVAR(visionModes), [[0, 0], [1, 0], [2, 0]]];
            private _currentVisionMode = _unit getVariable [QGVAR(currentVisionMode), 0];
            _unit setVariable [QGVAR(visionModes), _visionModes];
            _unit setVariable [QGVAR(currentVisionMode), _currentVisionMode];
            private _fov = _unit getVariable [QGVAR(targetFovHash), 0.75];
            _unit setVariable [QGVAR(targetFovHash), _fov];
            _videoControllerCtrl ctrlEnable true;
            _videoControllerCtrl setVariable [QGVAR(cameraTarget), _unit];
        };
    };
};

//TAG: cam data
private _newCamData = [_type, _unitNetID, _videoSourceData, _camID, _cam, _renderTargetName, _contentGrpCtrl];
private _renderCamerasData = _context get QGVAR(renderCamerasData);
_renderCamerasData set [_camID, _newCamData];

private _fnc_initContent = _context get QGVAR(fnc_initContent);
[_videoSourceData, _contentGrpCtrl] call _fnc_initContent;

true
