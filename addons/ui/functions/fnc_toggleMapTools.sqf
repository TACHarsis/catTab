#include "script_component.hpp"
/*
 	Name: Ctab_ui_fnc_toggleMapTools
 	
 	Author(s):
		Gundy

 	Description:
		Toggle drawing of map tools
		
	
	Parameters:
		0: STRING - Name of uiNamespace variable for interface
 	
 	Returns:
		BOOLEAN - Draw map tools
 	
 	Example:
		GVAR(drawMapTools) = call Ctab_ui_fnc_toggleMapTools;
*/

params ["_displayName"];

private _currentMapTools = [_displayName,QSETTING_MAP_TOOLS] call FUNC(getSettings);

private _newMapTools = !_currentMapTools;

[_displayName,[[QSETTING_MAP_TOOLS,_newMapTools]]] call FUNC(setSettings);

_newMapTools
