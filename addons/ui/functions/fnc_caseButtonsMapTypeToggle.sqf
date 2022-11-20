#include "script_component.hpp"

/*
Function to toggle mapType to the next one in the list of available map types
Parameter 0: String of uiNamespace variable for which to toggle to mapType for
Returns Nothing
*/
params ["_displayName"];

private _mapTypes = [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings);
private _currentMapType = [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings);
private _currentMapTypeIndex = [_mapTypes,_currentMapType] call BIS_fnc_findInPairs;

private _nextMapTypeIndex = [
    _mapTypes # (_currentMapTypeIndex + 1) # 0,
    _mapTypes # 0 # 0
    ] select (_currentMapTypeIndex == count _mapTypes - 1);

[_displayName,[[QSETTING_CURRENT_MAP_TYPE,_nextMapTypeIndex]]] call FUNC(setSettings);
