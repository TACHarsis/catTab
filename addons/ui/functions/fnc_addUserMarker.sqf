#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_addUserMarker
	
	Author(s):
		Gundy
	
	Description:
		Add a new user marker to the list and broadcast it. This function is called on the server.
	
	Parameters:
		0: STRING  - Encryption Key for this marker
		1: ARRAY   - markerData
	Optional:
		2: INTEGER - Transaction ID
	
	Returns:
		BOOLEAN - Always TRUE
	
	Example:
		// Client requesting marker addition and server receiving request
		["bluefor",[[1714.35,5716.82],0,0,0,"12:00",player]]call Ctab_ui_fnc_addUserMarker;
		
		// Client receiving marker addition (from server)
		["bluefor",[21,[[1714.35,5716.82],0,0,0,"12:00",player]],157]call Ctab_ui_fnc_addUserMarker;
*/

params ["_encryptionKey","_markerData","_transactionId"];

call {
	// If received on the server
	if (isServer) exitWith {
		if (isNil "_transactionId") then { // not set when initiated from client
			// Increase transaction ID
			GVAR(userMarkerTransactionId) = GVAR(userMarkerTransactionId) + 1;
			_transactionId = GVAR(userMarkerTransactionId);
			
			// Add marker data to list
			[GVAR(userMarkerLists),_encryptionKey,[[_transactionId,_markerData]]] call EFUNC(core,addToPairs);
			
			// Send addUserMarker command to all clients
			[_encryptionKey,[_transactionId,_markerData],_transactionId] remoteExec [QFUNC(addUserMarker)];
			
			// If this was run on a client-server (i.e. in single player or locally hosted), update the marker list
			if (hasInterface && {_encryptionKey == call EFUNC(core,getPlayerEncryptionKey)}) then {
				call FUNC(updateUserMarkerList);
				if ((_markerData select 5) != Ctab_player) then {
					["BFT",format ["New marker at #%1",mapGridPosition (_markerData select 0)],20] call FUNC(addNotification);
				} else {
					["BFT","Marker added succesfully",3] call FUNC(addNotification);
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
			[GVAR(userMarkerLists),_encryptionKey,[_markerData]] call EFUNC(core,addToPairs);
			// only update the user marker list if the marker was added to the player's side
			if (_encryptionKey == call EFUNC(core,getPlayerEncryptionKey)) then {
				call FUNC(updateUserMarkerList);
				
				// add notification if marker was issued by someone else
				if ((_markerData select 1 select 5) != Ctab_player) then {
					["BFT",format ["New marker at #%1",mapGridPosition (_markerData select 1 select 0)],20] call FUNC(addNotification);
				} else {
					["BFT","Marker added succesfully",3] call FUNC(addNotification);
				};
			};
		};
	};

	// If received on a client, to be sent to the server
	if (hasInterface) then {
		[_this] remoteExec [QFUNC(addUserMarker), 2];
	};
};

true
