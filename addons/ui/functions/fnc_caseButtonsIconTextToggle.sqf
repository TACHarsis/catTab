#include "script_component.hpp"

/*
Function to toggle text next to BFT icons
Parameter 0: String of uiNamespace variable for which to toggle showIconText for
Returns TRUE
*/

params ["_displayName"];

if (GVAR(textEnabled)) then {GVAR(textEnabled) = false} else {GVAR(textEnabled) = true};
[_displayName,[[QSETTING_SHOW_ICON_TEXT,GVAR(textEnabled)]]] call FUNC(setSettings);

true
