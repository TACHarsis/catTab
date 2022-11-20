#include "script_component.hpp"

/*
Function to toggle text next to BFT icons
Parameter 0: String of uiNamespace variable for which to toggle showIconText for
Returns TRUE
*/

params ["_displayName"];

private _drawText = [_displayName, QSETTING_SHOW_ICON_TEXT] call FUNC(getSettings);

_drawText = !_drawText;

[_displayName,[[QSETTING_SHOW_ICON_TEXT,_drawText]]] call FUNC(setSettings);

true
