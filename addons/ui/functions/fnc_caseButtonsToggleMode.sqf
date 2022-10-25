#include "script_component.hpp"

//CC: Switches between Map/BFT and messaging screen

params ["_displayName"];

private _mode = [_displayName,"mode"] call FUNC(getSettings);


if (_displayName == QGVARMAIN(Android_dlg)) then {
	if (_mode != "BFT") then {
		_mode = "BFT";
	} else {
		_mode = "MESSAGE";
	};
};

[_displayName,[["mode",_mode]]] call FUNC(setSettings);

true
