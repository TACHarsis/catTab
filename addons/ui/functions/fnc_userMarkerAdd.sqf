#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_UserMarkerAdd
	
	Author(s):
		Gundy, Cat Harsis
	
	Description:
		Add a new user marker to the list on the client. This function is remoteExec'd on the client.
	
	Parameters:
		0: STRING  - Encryption Key for this marker
		1: ARRAY   - markerData
		2: INTEGER - Transaction ID
	
	Returns:
		Nothing
	
	Example:
		// Client receiving marker addition from server
		["bluefor",[21,[[1714.35,5716.82],0,0,0,"12:00",player]],157] remotExec ["Ctab_ui_fnc_UserMarkerAdd"];
*/
if!(hasInterface) exitWith {};

params ["_encryptionKey","_markerData","_transactionId"];

if (isNil "_transactionId") exitWith { diag_log "userMarkerAdd: SENT IN ERROR; NO TRANSACTION ID";};

if (GVAR(userMarkerTransactionId) == _transactionId) exitWith {};
if (GVAR(userMarkerTransactionId) != (_transactionId -1)) exitWith {
	// get full list
	["Transaction ID check failed! Had %1, received %2. Requesting user marker list.",GVAR(userMarkerTransactionId),_transactionId] call bis_fnc_error;
	[player] remoteExec [QFUNC(userMarkerListGetServer), 2];
};
GVAR(userMarkerTransactionId) = _transactionId;

private _userMarkerList = GVAR(userMarkerLists) getOrDefault [_encryptionKey, []];
if(_userMarkerList isEqualTo []) then { GVAR(userMarkerLists) set [_encryptionKey, _userMarkerList]};
_userMarkerList pushBack _markerData;

// only update the user marker list if the marker was added to the player's side
if (_encryptionKey == call EFUNC(core,getPlayerEncryptionKey)) then {
	[] call FUNC(userMarkerListUpdate);
	
	// add notification if marker was issued by someone else
	if ((_markerData select 1 select 5) != Ctab_player) then {
		[QSETTING_MODE_BFT,format ["New marker at #%1",mapGridPosition (_markerData select 1 select 0)],20] call FUNC(addNotification);
	} else {
		[QSETTING_MODE_BFT,"Marker added succesfully",3] call FUNC(addNotification);
	};
};
