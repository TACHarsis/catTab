#include "script_component.hpp"
/*
Function to adjust brightness
Parameter 0: String of uiNamespace variable for which to increase brightness for
Parameter 1: Integer amount to adjust brightness by
Returns TRUE
*/
params ["_displayName", ["_adjustment", 0, [1]]];
private _brightness = [_displayName,QSETTING_BRIGHTNESS] call FUNC(getSettings);
_brightness = _brightness + _adjustment;
_brightness = [_brightness, 0.5, 1] call BIS_fnc_clamp;
[_displayName,[[QSETTING_BRIGHTNESS,_brightness]]] call FUNC(setSettings);
true
