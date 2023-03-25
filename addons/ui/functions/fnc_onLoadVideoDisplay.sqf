#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

params ["_videoController", ["_config", configNull, [configNull]]];


private _fnc_onMouseWheel = {
    params ["_videoController","_value"];

    private _cameraTarget = _videoController getVariable [QGVAR(cameraTarget), objNull];
    private _cameraTargetType = _videoController getVariable [QGVAR(cameraTargetType), ""];
    if(isNull _cameraTarget) exitWith {};

    private _fov = _cameraTarget getVariable [QGVAR(targetFovHash), 0.75];
    private _newFoV = if(_value < 0) then { _fov * 2} else { _fov * 0.5};
    _newFoV = [_newFoV, 0.01, 0.75] call BIS_fnc_clamp;
    _cameraTarget setVariable [QGVAR(targetFovHash), _newFoV];
};

private _fnc_onMouseDown = {
    params ["_videoController", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

    if(_button == 0) exitWith {
        [] call FUNC(caseButtonsOnACTButton);
    };
    if(_button == 1) exitWith {
        private _target = _videoController getVariable [QGVAR(cameraTarget), objNull];
        if(_target isEqualTo objNull) exitWith {};

        private _visionModes = _target getVariable [QGVAR(visionModes), [[0,0]]];
        private _currentVisionMode = _target getVariable [QGVAR(currentVisionMode), 0];
        private _nextVisionMode = [_currentVisionMode + 1, 0] select ((_currentVisionMode + 1) >= count _visionModes);
        _target setVariable [QGVAR(currentVisionMode), _nextVisionMode];
    };
};

[{
    params ["_videoController", "_fnc_onMouseWheel", "_fnc_onMouseDown"];
    
    _videoController ctrlEnable true;
    _videoController setVariable [QGVAR(targetFovHash),createHashMap];
    //_videoController ctrlAddEventHandler ["SetFocus", { params ["_control"]; (ctrlParent (ctrlParent _control )) displayCtrl ; }];
    _videoController ctrlAddEventHandler ["MouseZChanged",_fnc_onMouseWheel];
    _videoController ctrlAddEventHandler ["MouseButtonUp",_fnc_onMouseDown];
},[_videoController,_fnc_onMouseWheel, _fnc_onMouseDown]] call CBA_fnc_execNextFrame;
