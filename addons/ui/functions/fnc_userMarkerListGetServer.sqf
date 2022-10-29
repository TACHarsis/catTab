#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_userMarkerListGet
	
	Author(s):
		Gundy, Cat Harsis

	Description:
		Sent as command to server to request the current user marker list

	Parameters:
			NONE
	
	Returns:
		Nothing
	
	Example:
		// Client requesting the list from the server
		[player] remoteExec ["Ctab_ui_fnc_userMarkerListGet"];
*/

if !(isServer) exitWith {};

params ["_player"];

if (!isNil QGVAR(userMarkerTransactionIdServer) && {GVAR(userMarkerTransactionIdServer) >= 0}) then {
	[GVAR(userMarkerListsServer),GVAR(userMarkerTransactionIdServer)] remoteExec [QFUNC(userMarkerListGet),_player];
};
