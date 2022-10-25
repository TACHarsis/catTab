#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_deleteUserMarker
	
	Author(s):
		Gundy

	Description:
		Delete user placed marker at provided index and broadcast the result. This function is called on the server.

	Parameters:
		0: STRING  - Encryption Key for this marker
		1: INTEGER - Index position of marker to delete
	Optional:
		2: INTEGER - Transaction ID
	
	Returns:
		BOOLEAN - TRUE
	
	Example:
		// Client requesting marker deletion and server receiving request
		["bluefor",5] call Ctab_ui_fnc_deleteUserMarker;
		
		// Client receiving request for marker deletion (from server)
		["bluefor",5,158] call Ctab_ui_fnc_deleteUserMarker;
*/
params ["_encryptionKey","_markerIndex","_transactionId"];
private ["_userMarkerList","_removeIndex"];

call {
	// If received on the server
	if (isServer) exitWith {
		if (isNil "_transactionId") then { // not set when initiated from client
			// get the marker list that corresponds to the encryption key
			_userMarkerList = [GVAR(userMarkerLists),_encryptionKey] call EFUNC(core,getFromPairs);

			// try to find the marker to be removed
			_removeIndex = -1;
			{
				if (_x select 0 == _markerIndex) exitWith {_removeIndex = _forEachIndex};
			} forEach _userMarkerList;
			
			// if the marker could be found, remove it
			if (_removeIndex != -1) then {
				_userMarkerList deleteAt _removeIndex;
				[GVAR(userMarkerLists),_encryptionKey,_userMarkerList] call EFUNC(core,setToPairs);
				
				// Send deleteUserMarker command to all clients
				GVAR(userMarkerTransactionId) = GVAR(userMarkerTransactionId) + 1;
				[_encryptionKey,_markerIndex,GVAR(userMarkerTransactionId)] remoteExec [QFUNC(deleteUserMarker)];
				
				// If this was run on a client-server (i.e. in single player or locally hosted), update the marker list
				if (hasInterface && {_encryptionKey == call EFUNC(core,getPlayerEncryptionKey)}) then {
					call FUNC(updateUserMarkerList);
				};
			};
		};
	};

	// If received on a client, sent by the server
	if (hasInterface && !isNil "_transactionId") exitWith {
		call {
			if (GVAR(userMarkerTransactionId) == _transactionId) exitWith {};
			if (GVAR(userMarkerTransactionId) != (_transactionId -1)) exitWith {
				// get full list
				["Transaction ID check failed! Had %1, received %2. Requesting user marker list.",GVAR(userMarkerTransactionId),_transactionId] call bis_fnc_error;
				[] call FUNC(getUserMarkerList);
			};
			GVAR(userMarkerTransactionId) = _transactionId;
			
			// get the marker list that corresponds to the encryption key
			_userMarkerList = [GVAR(userMarkerLists),_encryptionKey] call EFUNC(core,getFromPairs);

			// try to find the marker to be removed
			_removeIndex = -1;
			{
				if (_x select 0 == _markerIndex) exitWith {_removeIndex = _forEachIndex};
			} forEach _userMarkerList;
			
			// if the marker could be found, remove it
			if (_removeIndex != -1) then {
				_userMarkerList deleteAt _removeIndex;
				[GVAR(userMarkerLists),_encryptionKey,_userMarkerList] call EFUNC(core,setToPairs);
				// only update the user marker list if the marker was deleted from the player's side
				if (_encryptionKey == call EFUNC(core,getPlayerEncryptionKey)) then {
					call FUNC(updateUserMarkerList);
				};
			};
		};
	};
	
	// If received on a client, to be sent to the server
	if (hasInterface) then {
		[this] remoteExec [QFUNC(deleteUserMarker), 2];
	};
};

true
