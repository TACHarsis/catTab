#include "script_component.hpp"

//CC: Switches between Map/BFT and messaging screen

params ["_displayName"];

if(isNil "_displayName") then {
    _displayName = GVAR(ifOpen) # 1;
};

private _mode = [_displayName,QSETTING_MODE] call FUNC(getSettings);

if (_displayName == QGVARMAIN(Android_dlg)) then {
    if (_mode != QSETTING_MODE_BFT) then {
        _mode = QSETTING_MODE_BFT;
    } else {
        _mode = QSETTING_MODE_MESSAGES;
    };
};

[_displayName,[[QSETTING_MODE,_mode]]] call FUNC(setSettings);

true
