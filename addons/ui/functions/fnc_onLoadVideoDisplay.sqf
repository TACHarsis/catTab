#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

params ["_videoImage", ["_config", configNull, [configNull]]];


private _fnc_onMouseWheel = {
    params ["_videoImage","_value"];

    private _cameraTarget = _videoImage getVariable [QGVAR(cameraTarget), objNull];
    private _cameraTargetType = _videoImage getVariable [QGVAR(cameraTargetType), ""];
    if(isNull _cameraTarget) exitWith {};

    private _fov = _cameraTarget getVariable [QGVAR(targetFovHash), 0.75];
    private _newFoV = if(_value < 0) then { _fov * 2} else { _fov * 0.5};
    _newFoV = [_newFoV, 0.01, 0.75] call BIS_fnc_clamp;
    _cameraTarget setVariable [QGVAR(targetFovHash), _newFoV];
};

private _fnc_onMouseDown = {
    params ["_videoImage", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

    if(_button == 0) exitWith {
        [] call FUNC(caseButtonsOnACTButton);
    };
    if(_button == 1) exitWith {
        private _target = _videoImage getVariable [QGVAR(cameraTarget), objNull];
        if(_target isEqualTo objNull) exitWith {};

        private _visionModes = _target getVariable [QGVAR(visionModes), [[0,0]]];
        private _currentVisionMode = _target getVariable [QGVAR(currentVisionMode), 0];
        private _nextVisionMode = [_currentVisionMode + 1, 0] select ((_currentVisionMode + 1) >= count _visionModes);
        _target setVariable [QGVAR(currentVisionMode), _nextVisionMode];
    };
};

[{
    params ["_videoImage", "_fnc_onMouseWheel", "_fnc_onMouseDown"];
    
    _videoImage ctrlEnable true;
    _videoImage setVariable [QGVAR(targetFovHash),createHashMap];
    //_videoImage ctrlAddEventHandler ["SetFocus", { params ["_control"]; (ctrlParent (ctrlParent _control )) displayCtrl ; }];
    _videoImage ctrlAddEventHandler ["MouseZChanged",_fnc_onMouseWheel];
    _videoImage ctrlAddEventHandler ["MouseButtonUp",_fnc_onMouseDown];
},[_videoImage,_fnc_onMouseWheel, _fnc_onMouseDown]] call CBA_fnc_execNextFrame;
