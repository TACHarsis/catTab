#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_userMarkerDelete
	
	Author(s):
		Gundy, Cat Harsis

	Description:
		Delete user placed marker at provided index. This function is remoteExec'd from the server.

	Parameters:
		0: STRING  - Encryption Key for this marker
		1: INTEGER - Index position of marker to delete
	Optional:
		2: INTEGER - Transaction ID
	
	Returns:
		Nothing
	
	Example:
		// Client receiving request for marker deletion (from server)
		["bluefor",5,158] remoteExec ["Ctab_ui_fnc_userMarkerDelete"];
*/
if !(hasInterface) exitWith {};

params ["_encryptionKey","_markerIndex","_transactionId"];

if(!isNil "_transactionId") exitWith{};

if (GVAR(userMarkerTransactionId) == _transactionId) exitWith {};
if (GVAR(userMarkerTransactionId) != (_transactionId -1)) exitWith {
	// get full list
	["Transaction ID check failed! Had %1, received %2. Requesting user marker list.",GVAR(userMarkerTransactionId),_transactionId] call bis_fnc_error;
	[player] remoteExec [QFUNC(userMarkerListGetServer), 2];
};
GVAR(userMarkerTransactionId) = _transactionId;

// get the marker list that corresponds to the encryption key
private _userMarkerList = GVAR(userMarkerLists) getOrDefault [_encryptionKey,[]];
if(_userMarkerList isEqualTo []) exitWith {};

// try to find the marker to be removed
private _removeIndex = -1;
{
	if (_x select 0 == _markerIndex) exitWith {_removeIndex = _forEachIndex};
} forEach _userMarkerList;

// if the marker could be found, remove it
if (_removeIndex != -1) then {
	_userMarkerList deleteAt _removeIndex;
	GVAR(userMarkerLists) set [_encryptionKey,_userMarkerList];
	// only update the user marker list if the marker was deleted from the player's side
	if (_encryptionKey == call EFUNC(core,getPlayerEncryptionKey)) then {
		[] call FUNC(userMarkerListUpdate);
	};
};