#include "script_component.hpp"
/*
Function to toggle showMenu
Parameter 0: String of uiNamespace variable for which to toggle showMenu for
Returns TRUE
*/
params["_displayName"];
private _showMenu = [_displayName,QSETTING_SHOW_MENU] call FUNC(getSettings);
_showMenu = !_showMenu;
[_displayName,[[QSETTING_SHOW_MENU,_showMenu]]] call FUNC(setSettings);
true
