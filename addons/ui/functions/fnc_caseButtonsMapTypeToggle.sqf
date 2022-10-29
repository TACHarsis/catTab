#include "script_component.hpp"

/*
Function to toggle mapType to the next one in the list of available map types
Parameter 0: String of uiNamespace variable for which to toggle to mapType for
Returns TRUE
*/
params ["_displayName"];

private _mapTypes = [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings);
private _currentMapType = [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings);
private _currentMapTypeIndex = [_mapTypes,_currentMapType] call BIS_fnc_findInPairs;

if (_currentMapTypeIndex == count _mapTypes - 1) then {
	[_displayName,[[QSETTING_CURRENT_MAP_TYPE,_mapTypes select 0 select 0]]] call FUNC(setSettings);
} else {
	[_displayName,[[QSETTING_CURRENT_MAP_TYPE,_mapTypes select (_currentMapTypeIndex + 1) select 0]]] call FUNC(setSettings);
};

true
