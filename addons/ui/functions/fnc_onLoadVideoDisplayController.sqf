#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

params ["_videoController", "_feedType"];

#define FACTOR_ZOOM_OUT 0.5
#define FACTOR_ZOOM_IN 2
#define FOV_MIN 0.01
#define FOV_MAX 0.75

private _fnc_onMouseWheel = {
    params ["_videoController", "_value"];

    private _cameraTarget = _videoController getVariable [QGVAR(cameraTarget), objNull];
    private _cameraTargetType = _videoController getVariable [QGVAR(cameraTargetType), ""];
    if(isNull _cameraTarget) exitWith {};

    private _fov = _cameraTarget getVariable [QGVAR(targetFovHash), FOV_MAX];
    private _newFoV = if(_value < 0) then { _fov * FACTOR_ZOOM_IN} else { _fov * FACTOR_ZOOM_OUT};
    _newFoV = [_newFoV, FOV_MIN, FOV_MAX] call BIS_fnc_clamp;
    _cameraTarget setVariable [QGVAR(targetFovHash), _newFoV];
};

private _fnc_onMouseClick = {
    params ["_videoController", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    private _cameraTarget = _videoController getVariable [QGVAR(cameraTarget), objNull];
    if(_cameraTarget isEqualTo objNull) exitWith {};

    if(_button == 1) exitWith {
        private _visionModes = _cameraTarget getVariable [QGVAR(visionModes), [[0, 0]]];
        private _currentVisionMode = _cameraTarget getVariable [QGVAR(currentVisionMode), 0];
        private _nextVisionMode = [_currentVisionMode + 1, 0] select ((_currentVisionMode + 1) >= count _visionModes);
        _cameraTarget setVariable [QGVAR(currentVisionMode), _nextVisionMode];
    };
    if(_button == 0) exitWith {
        private _feedType = _videoController getVariable QGVAR(feedType);
        switch (_feedType) do {
            case (QSETTING_FEED_TYPE_UAV): {
                [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_SELECTED, _cameraTarget call BIS_fnc_netId]]] call FUNC(setSettings);
            };
            case (QSETTING_FEED_TYPE_HCAM): {
                [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_HCAM_SELECTED, _cameraTarget call BIS_fnc_netId]]] call FUNC(setSettings);
            };
        };
    };
};

private _fnc_onMouseDoubleClick = {
    params ["_videoController", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    private _cameraTarget = _videoController getVariable [QGVAR(cameraTarget), objNull];
    if(isNull _cameraTarget) exitWith {};

    private _feedType = _videoController getVariable QGVAR(feedType);
    switch (_feedType) do {
        case (QSETTING_FEED_TYPE_UAV): {
            [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_SELECTED, _cameraTarget call BIS_fnc_netId]]] call FUNC(setSettings);
        };
        case (QSETTING_FEED_TYPE_HCAM): {
            [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_HCAM_SELECTED, _cameraTarget call BIS_fnc_netId]]] call FUNC(setSettings);
        };
    };
    if(_button == 0) exitWith {
        [] call FUNC(caseButtonsOnACTButton);
    };
};

[
    {
        params ["_videoController", "_feedType", "_fnc_onMouseWheel", "_fnc_onMouseClick", "_fnc_onMouseDoubleClick"];
        
        _videoController ctrlEnable true;
        _videoController setVariable [QGVAR(feedType), _feedType];
        _videoController setVariable [QGVAR(targetFovHash), createHashMap];
        //_videoController ctrlAddEventHandler ["SetFocus", { params ["_control"]; (ctrlParent (ctrlParent _control )) displayCtrl ; }];
        _videoController ctrlAddEventHandler ["MouseZChanged", _fnc_onMouseWheel];
        _videoController ctrlAddEventHandler ["MouseButtonClick", _fnc_onMouseClick];
        _videoController ctrlAddEventHandler ["MouseButtonDblClick", _fnc_onMouseDoubleClick];
    },
    [_videoController, _feedType, _fnc_onMouseWheel, _fnc_onMouseClick, _fnc_onMouseDoubleClick]
] call CBA_fnc_execNextFrame;
