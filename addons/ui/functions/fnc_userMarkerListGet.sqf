#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_userMarkerListGet
	
	Author(s):
		Gundy, Cat Harsis

	Description:
		Send userMarkerList back to client

	Parameters:
			0: ARRAY   - Current user marker list
			1: INTEGER - Current transaction ID
	
	Returns:
		Nothing
	
	Example:
		// Client receiving the list from the server
		[[userMarkerList],157] remoteExec ["Ctab_ui_fnc_userMarkerListGet"];
*/

if !(hasInterface) exitWith {};

params ["_userMarkerList", "_transactionID"];

// this is the list and transaction ID received by the client
GVAR(userMarkerLists) = _userMarkerList;
GVAR(userMarkerTransactionId) = _transactionID;

call [nil, FUNC(userMarkerListUpdate)] select hasInterface;
