#include "script_component.hpp"
/*
 	Name: Ctab_ui_fnc_setSettings
 	
 	Author(s):
		Gundy

 	Description:
		Write cTab settings. Will call cTab_updateInterface for any setting that changed.

	Parameters:
		0: STRING - Name of uiNamespace display / dialog variable
		1: ARRAY  - Property pair(s) to write in the form of [["propertyName",propertyValue],[...]]
		
		(Optional)
		2: BOOLEAN - If set to false, do not update interface (default true)
		3: BOOLEAN - If set to true, update interface even if the values haven't changed (default false)
 	
 	Returns:
 		BOOLEAN - If settings could be stored
 	
 	Example:
		[QGVARMAIN(Tablet_dlg),[["mapType","SAT"],["mapScaleDsp","4"]]] call Ctab_ui_fnc_setSettings;
		
		// Update mapWorldPos and update the interface even if the value has not changed
		[QGVARMAIN(Tablet_dlg),[["mapWorldPos",getPosASL vehicle player]],true,true] call Ctab_ui_fnc_setSettings;
		
		// Update mapWorldPos and mapScale, but do not update the interface
		[QGVARMAIN(Tablet_dlg),[["mapWorldPos",getPosASL vehicle player],["mapScaleDsp","2"]],false] call Ctab_ui_fnc_setSettings;
*/
params ["_displayName","_properties", ["_updateInterface", true, [false]], ["_forceInterfaceUpdate", false, [true]]];

private _propertyGroupName = [GVAR(displayPropertyGroups),_this select 0] call EFUNC(core,getFromPairs);

// Exit with FALSE if uiNamespace variable cannot be found in cTabDisplayPropertyGroups
if (isNil "_propertyGroupName") exitWith {false};

private _commonProperties = [GVAR(settings),"COMMON"] call EFUNC(core,getFromPairs);
private _groupProperties = [GVAR(settings),_propertyGroupName] call EFUNC(core,getFromPairs);
if (isNil "_groupProperties") then {_groupProperties = [];};

// Write multiple property pairs. If they exist in _groupProperties, write them there, else write them to COMMON. Only write if they exist and have changed.
private _commonPropertiesUpdate = [];
private _combinedPropertiesUpdate = [];
{
	private _key = _x select 0;
	private _value = _x select 1;
	call {
		_currentValue = [_groupProperties,_key] call EFUNC(core,getFromPairs);
		if !(isNil "_currentValue") exitWith {
			call {
				if !(_currentValue isEqualTo _value) exitWith {
					[_combinedPropertiesUpdate,_key,_value] call BIS_fnc_setToPairs;
					[_groupProperties,_key,_value] call BIS_fnc_setToPairs;
				};
				if (_forceInterfaceUpdate) then {
					[_combinedPropertiesUpdate,_key,_value] call BIS_fnc_setToPairs;
				};
			};
		};
		_currentValue = [_commonProperties,_key] call EFUNC(core,getFromPairs);
		if !(isNil "_currentValue") then {
			call {
				if !(_currentValue isEqualTo _value) then {
					[_commonPropertiesUpdate,_key,_value] call BIS_fnc_setToPairs;
					[_commonProperties,_key,_value] call BIS_fnc_setToPairs;
				};
				if (_forceInterfaceUpdate) then {
					[_commonPropertiesUpdate,_key,_value] call BIS_fnc_setToPairs;
				};
			};
		};
	};
} forEach _properties;
[GVAR(settings),_propertyGroupName,_groupProperties] call BIS_fnc_setToPairs;
[GVAR(settings),"COMMON",_commonProperties] call BIS_fnc_setToPairs;

// Finally, call an interface update for the updated properties, but only if the currently interface uses the same property group, if not, pass changed common properties only.
if !(isNil QGVAR(ifOpen)) then {
	call {
		if !(_updateInterface) exitWith {};
		if ((([GVAR(displayPropertyGroups),GVAR(ifOpen) select 1] call EFUNC(core,getFromPairs)) == _propertyGroupName) && {count _combinedPropertiesUpdate > 0}) exitWith {
			[_combinedPropertiesUpdate] call EFUNC(ui,updateInterface);
		};
		if (count _commonPropertiesUpdate > 0) then {
			[_commonPropertiesUpdate] call EFUNC(ui,updateInterface);
		};
	};
};

if (_combinedPropertiesUpdate isEqualTo [] && _combinedPropertiesUpdate isEqualTo []) exitWith {false};

true
