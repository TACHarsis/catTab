#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_close
	
	Author(s):
		Gundy
	
	Description:
		Initiates the closing of currently open interface
	
	Parameters:
		No Parameters
	
	Returns:
		BOOLEAN - TRUE
	
	Example:
		[] call Ctab_ui_fnc_close;
*/

if !(isNil QGVAR(ifOpen)) then {
	// [_ifType,_displayName,_player,_playerKilledEhId,_vehicle,_vehicleGetOutEhId]
	private _displayName = GVAR(ifOpen) select 1;
	private _display = uiNamespace getVariable _displayName;
	
	_display closeDisplay 0;
	if !([_displayName] call EFUNC(ui,isDialog)) then {
		[] call EFUNC(ui,onIfclose);
	};
};

true
