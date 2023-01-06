#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
#define ANIM_LENGTH 0.3

params ["_ctrlInfo", "_controlIDs", "_screenArea"];
_ctrlInfo params ["_ctrlsGroup", ["_config", configNull, [configNull]]];

private _fnc_onButtonClick = {
    params ["_frameButton"];

    private _isOpen = _frameButton getVariable [QGVAR(isOpen), true];
    _frameButton setVariable [QGVAR(isOpen), !_isOpen];
    _frameButton getVariable QGVAR(states) params ["_stateClosed","_stateOpen"];
    _frameButton getVariable QGVAR(elements) params ["_ctrlsGroup","_videoFrame","_videoImage"];
    private _state = [_stateClosed, _stateOpen] select !_isOpen;
    _state params ["_groupW","_buttonX","_videoX"];

    private _groupCtrlPos = ctrlPosition _ctrlsGroup;
    _groupCtrlPos set [2,_groupW];
    _ctrlsGroup ctrlSetPosition _groupCtrlPos;
    _ctrlsGroup ctrlCommit ANIM_LENGTH;

    private _framePos = ctrlPosition _videoFrame;
    _framePos set [0,_videoX];
    _videoFrame ctrlSetPosition _framePos;
    _videoFrame ctrlCommit ANIM_LENGTH;

    private _videoPos = ctrlPosition _videoImage;
    _videoPos set [0,_videoX];
    _videoImage ctrlSetPosition _videoPos;
    _videoImage ctrlCommit ANIM_LENGTH;

    _frameButton ctrlSetText ([">>","<<"] select !_isOpen);
    private _buttonPos = ctrlPosition _frameButton;
    _buttonPos set [0,_buttonX];
    _frameButton ctrlSetPosition _buttonPos;
    _framebutton ctrlCommit ANIM_LENGTH;
};
[{
    params ["_ctrlsGroup", "_controlIDs", "_screenArea", "_fnc_onButtonClick"];
    _screenArea params ["_SAX","_SAY", "_SAW", "_SAH"];
    _controlIDs params ["_videoImageID","_videoFrameID","_frameButtonID"];

    private _screenAR = getResolution select 4;

    private _usedScreenAreaWidth = _SAW;
    private _usedScreenAreaHeight = _usedScreenAreaWidth / _screenAR * 1.3333333333333;

    // in case we get a weird AR
    if(_usedScreenAreaHeight > _SAH) then {
        _usedScreenAreaHeight = SAH;
        // Is this even correct?
        _usedScreenAreaWidth = _usedScreenAreaHeight * _screenAR / 1.3333333333333;
    };

    // Group
    private _newGroupX = _SAX + 0.002;
    private _newGroupY = _SAY - _usedScreenAreaHeight + _usedScreenAreaHeight * 0.03;
    private _newGroupH = _usedScreenAreaHeight * 0.97 - 0.002;
    private _newGroupPos = [
        _newGroupX,
        _newGroupY,
        _usedScreenAreaWidth,
        _newGroupH
    ];
    _ctrlsGroup ctrlSetPosition _newGroupPos;
    _ctrlsGroup ctrlCommit 0;

    // Video Frame
    private _videoFrame = _ctrlsGroup controlsGroupCtrl _videoFrameID;
    private _newVideoFramePos = [
        0,
        0,
        _usedScreenAreaWidth,
        _usedScreenAreaHeight*0.97
    ];
    _videoFrame ctrlSetPosition _newVideoFramePos;
    _videoFrame ctrlCommit 0;

    // Video Image
    private _videoImage = _ctrlsGroup controlsGroupCtrl _videoImageID;
    private _newVideoImagePos = [
        0,
        _usedScreenAreaWidth*0.02,
        _usedScreenAreaWidth*0.95,
        _usedScreenAreaHeight*0.95
    ];
    _videoImage ctrlSetPosition _newVideoImagePos;
    //_videoImage ctrlSetText "#(argb,1024,1024,1)r2t(uavGunnerRenderTarget,1)";
    _videoImage ctrlCommit 0;

    // Frame Button
    private _frameButton = _ctrlsGroup controlsGroupCtrl _frameButtonID;
    private _newFrameButtonPos = [
        _newVideoImagePos#2,
        _newVideoImagePos#1,
        _usedScreenAreaWidth-_newVideoImagePos#2,
        _newVideoImagePos#3
    ];
    _frameButton ctrlSetPosition _newFrameButtonPos;
    _frameButton ctrlEnable true;
    _frameButton ctrlCommit 0;
    
    // [group width, button X, video X]
    private _stateOpen = [_usedScreenAreaWidth,_newFrameButtonPos#0,0];
    private _stateClosed = [_newFrameButtonPos#2,0,-(_newVideoImagePos#2)];

    _frameButton setVariable [QGVAR(elements), [_ctrlsGroup,_videoFrame,_videoImage]];
    _frameButton setVariable [QGVAR(states), [_stateClosed,_stateOpen]];
    _frameButton setVariable [QGVAR(isOpen), true];
    _frameButton ctrlAddEventHandler ["ButtonClick", _fnc_onButtonClick];
},[_ctrlsGroup,_controlIDs,_screenArea,_fnc_onButtonClick]] call CBA_fnc_execNextFrame;
