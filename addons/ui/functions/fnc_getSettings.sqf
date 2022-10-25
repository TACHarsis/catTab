#include "script_component.hpp"
/*
 	Name: Ctab_ui_fnc_getSettings
 	
 	Author(s):
		Gundy

 	Description:
		Read cTab settings

	Parameters:
		0: STRING - Name of uiNamespace display / dialog variable
	(Optional)
		1: STRING - Name of individual property to read
 	
 	Returns:
 	(If only parameter 0 is specified)
		ARRAY - All property pairs for that display / dialog are returned, like so: [["propertyName1",propertyValue1],["propertyName2",propertyValue2]]
			If the uiNamespace variable cannot be found in cTabDisplayPropertyGroups, nil is returned.
	(If parameter 1 is specified)
		ANY - Value of individual property, nil if it does not exist
 	
 	Example:
		// Return all settings for Tablet
		[QGVARMAIN(Tablet_dlg)] call Ctab_ui_fnc_getSettings;
		
		// Return available map types for Tablet
		[QGVARMAIN(Tablet_dlg),"mapTypes"] call Ctab_ui_fnc_getSettings;
*/
params ["_displayName","_property"];

private _propertyGroupName = [GVAR(displayPropertyGroups),_displayName] call EFUNC(core,getFromPairs);

// Exit with nil if uiNamespace variable cannot be found in cTabDisplayPropertyGroups
if (isNil "_propertyGroupName") exitWith {nil};

// Fetch common and interface group specific property pairs
private _commonProperties = [GVAR(settings),"COMMON"] call EFUNC(core,getFromPairs);
private _groupProperties = [GVAR(settings),_propertyGroupName] call EFUNC(core,getFromPairs);
if (isNil "_groupProperties") then {_groupProperties = [];};

// Return value of requested property

if (count _this == 2) exitWith {
	private _value = [_groupProperties,_property] call EFUNC(core,getFromPairs);
	if (isNil "_value") then {
		_value = [_commonProperties,_property] call EFUNC(core,getFromPairs);
	};
	if (isNil "_value") then {nil} else {_value}
};

// Return list of all property pairs
private _combinedProperties = [] + _commonProperties;
{
	[_combinedProperties,_x select 0,_x select 1] call BIS_fnc_setToPairs;
} forEach _groupProperties;

_combinedProperties
