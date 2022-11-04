#include "script_component.hpp"
/*
Function to toggle night mode
Parameter 0: String of uiNamespace variable for which to toggle nightMode for
Returns TRUE
*/

params ["_displayName"];

private _nightMode = [_displayName,QSETTING_NIGHT_MODE] call FUNC(getSettings);

if (_nightMode != 2) then {
    if (_nightMode == 0) then {_nightMode = 1} else {_nightMode = 0};
    [_displayName,[[QSETTING_NIGHT_MODE,_nightMode]]] call FUNC(setSettings);
};

true
