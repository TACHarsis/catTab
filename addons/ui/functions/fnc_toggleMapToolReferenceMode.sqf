#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_toggleMapToolReferenceMode
     Author(s):
        Gundy

     Description:
        Toggle direction of hook
    Parameters:
        0: STRING - Name of uiNamespace variable for interface
     Returns:
        Nothing
     Example:
        GVAR(drawMapTools) = call Ctab_ui_fnc_toggleMapToolReferenceMode;
*/

params ["_displayName"];

private _currentlyOutwards = [_displayName,QSETTING_HOOK_REFERENCE_MODE] call FUNC(getSettings);

[_displayName,[[QSETTING_HOOK_REFERENCE_MODE,!_currentlyOutwards]]] call FUNC(setSettings);
