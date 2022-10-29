#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_userMarkerDeleteServer
	
	Author(s):
		Gundy

	Description:
		Delete user placed marker at provided index and broadcast the result. This function is remoteExec'd on the server.

	Parameters:
		0: STRING  - Encryption Key for this marker
		1: INTEGER - Index position of marker to delete
		2: INTEGER - Transaction ID
	
	Returns:
		BOOLEAN - TRUE
	
	Example:
		// Client requesting marker deletion and server receiving request
		["bluefor",5] remoteExec ["Ctab_ui_fnc_userMarkerDeleteServer", 2];
*/
if !(isServer) exitWith {};

params ["_encryptionKey","_markerIndex","_transactionId"];

// get the marker list that corresponds to the encryption key
private _userMarkerList = GVAR(userMarkerListsServer) get [_encryptionKey,[]];
if(_userMarkerList isEqualTo []) exitWith {};

// try to find the marker to be removed
private _removeIndex = -1;
{
	if (_x select 0 == _markerIndex) exitWith {_removeIndex = _forEachIndex};
} forEach _userMarkerList;

// if the marker could be found, remove it
if (_removeIndex != -1) then {
	_userMarkerList deleteAt _removeIndex;
	GVAR(userMarkerListsServer) set [_encryptionKey,_userMarkerList];
	
	// Send userMarkerDelete command to all clients
	GVAR(userMarkerTransactionIdServer) = GVAR(userMarkerTransactionIdServer) + 1;
	[_encryptionKey,_markerIndex,GVAR(userMarkerTransactionIdServer)] remoteExec [QFUNC(userMarkerDelete)];
};
