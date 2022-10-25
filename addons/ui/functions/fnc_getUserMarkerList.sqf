#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_getUserMarkerList
	
	Author(s):
		Gundy

	Description:
		Issued from a client: Send command to server to receive the current user marker list
		Issued on the server: Send userMarkerList back to client

	Parameters:
		To send request to server
			NONE
		
		When server is receiving request from server
			0: OBJECT - Object local to client that is requesting
		
		When client is receiving the list
			0: ARRAY   - Current user marker list
			1: INTEGER - Current transaction ID
	
	Returns:
		BOOLEAN - TRUE
	
	Example:
		// Client requesting the list from the server
		[player] call Ctab_ui_fnc_getUserMarkerList;
		
		// Client receiving the list from the server
		[[userMarkerList],157] call Ctab_ui_fnc_getUserMarkerList;
*/

param [1, "_transactionID"];
//CC: Thif function is a crime.
call {
	// Send request to Server
	if (count _this == 0) exitWith {
		if (hasInterface && !isServer) then {
			[player] remoteExec [QFUNC(getUserMarkerList), 2];
		};
	};
	
	// Request received by the server to send the current list, make sure its not a client at the same time
	// Only send the list if the transaction ID is not at its initial value, meaning the list is likely to have some meaningful data
	if (count _this == 1) exitWith {
		param [0, "_player"];
		if (isServer && !hasInterface && (GVAR(userMarkerTransactionId) >= 0)) then {
			[GVAR(userMarkerLists),GVAR(userMarkerTransactionId)] remoteExec [QFUNC(getUserMarkerList),_player];
		};
	};

	// Otherwise this is the list and transaction ID received by the client
	param [0, "_userMarkerList"];
	GVAR(userMarkerLists) = _userMarkerList;
	GVAR(userMarkerTransactionId) = _transactionID;

	if (hasInterface) then {call FUNC(updateUserMarkerList);};
};

true
