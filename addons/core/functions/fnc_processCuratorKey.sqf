#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_userMarkerTranslate
	
	Author(s):
		michail-nikolaev (nkey, TFAR)

	Description:
		For a given curator key press event, find a matching key handler that was registered with CBA's keybind system. If a match was found, execute the corresponding CBA key handler event.
	
	Parameters:
		0: ARRAY  - KeyDown / KeyUp event attributes
		1: STRING - "keyDown" or "keyUp"
	
	Returns:
		BOOLEAN - If event was found and executed upon
	
	Example:
		(findDisplay 312) displayAddEventHandler ["KeyDown", "[_this, 'keydown'] call Ctab_ui_fnc_processCuratorKey"];
		(findDisplay 312) displayAddEventHandler ["KeyUp", "[_this, 'keyup'] call Ctab_ui_fnc_processCuratorKey"];
*/

params ["_pressed", "_keyUpOrDown"];

private _result = false;


_processKeys = {
	params ["_mods","_key_pressed","_handler"];
// CC: TODO: that prefix might not be accurate anymore	
	if ([_key, "ctab_"] call CBA_fnc_find == 0) then {
		
		if ((_key_pressed == _pressed select 1) and {(_mods select 0) isEqualTo (_pressed select 2)} and {(_mods select 1) isEqualTo  (_pressed select 3)} and {(_mods select 2) isEqualTo (_pressed select 4)}) exitWith {
			_result = call _handler;
		};
	};
};

[if (_keyUpOrDown isEqualTo "keyup") then {CBA_events_keyhandlers_up} else {CBA_events_keyhandlers_down}, _processKeys] call CBA_fnc_hashEachPair;

_result
