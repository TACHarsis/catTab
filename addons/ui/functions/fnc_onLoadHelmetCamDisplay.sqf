#include "script_component.hpp"

params ["_videoImage", ["_config", configNull]];
private _ctrlsGroup = ctrlParentControlsGroup _videoImage;

private _videoPos = ctrlPosition _videoImage;
private _ctrlsGroupPos = ctrlPosition _ctrlsGroup;

private _originalHeight = _ctrlsGroupPos#3;
private _originalY = _ctrlsGroupPos#1;

private _screenAR = getResolution select 4;

private _videoWidth = _ctrlsGroupPos#3;
private _videoHeight = _videoWidth / _screenAR * 1.3333333333333;

private _heightDiff = abs(_videoHeight-_originalHeight);
private _newGroupY = _originalY+_heightDiff;

private _newVideoPos = [0, 0, _videoWidth, _videoHeight];

_videoImage ctrlEnable true;

_videoImage ctrlSetPosition _newVideoPos;
_videoImage ctrlSetText "#(argb,1024,1024,1)r2t(helmetCamRenderTarget,1)";
_videoImage ctrlCommit 0;


_ctrlsGroup ctrlSetPosition [_ctrlsGroupPos#0,_newGroupY,_videoWidth,_videoHeight];
_ctrlsGroup ctrlCommit 0;

_videoImage setVariable [QGVAR(hCamFovHash),createHashMap];
_videoImage ctrlAddEventHandler ["MouseZChanged",{
    if(isNil QGVAR(helmetCamData)) exitWith {};
    params ["_control","_value"];

    private _fovHash = _control getVariable [QGVAR(hCamFovHash),createHashMap];
    GVAR(helmetCamData) params ["_cam","_target","_unit"];
    private _fov = _fovHash getOrDefault [_unit call BIS_fnc_netId,0.7];
    private _newFoV = if(_value < 0) then { _fov + 0.07} else { _fov - 0.07};
    // that needs a more geometric stepping
    _newFoV = [_newFoV,0.3,0.75] call BIS_fnc_clamp;

    _fovHash set [_unit call BIS_fnc_netId,_newFoV];
}];