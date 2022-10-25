#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_onIfOpen
	
	Author(s):
		Gundy
	
	Description:
		Handles dialog / display setup, called by "onLoad" event
	
	Parameters:
		0: Display
	
	Returns:
		BOOLEAN - TRUE
	
	Example:
		// open TAD display as main interface type
		[_dispaly] call Ctab_ui_fnc_onIfOpen;
*/

uiNamespace setVariable [GVAR(ifOpen) select 1,_this select 0];

[] call FUNC(updateInterface);

GVAR(openStart) = false;

true
