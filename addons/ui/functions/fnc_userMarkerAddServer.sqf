#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_UserMarkerAddServer
    
    Author(s):
        Gundy, Cat Harsis
    
    Description:
        Add a new user marker to the list and broadcast it. This function is remoteExec'd on the server.
    
    Parameters:
        0: STRING  - Encryption Key for this marker
        1: ARRAY   - markerData
    
    Returns:
        Nothing
    
    Example:
        // Client requesting marker addition and server receiving request
        ["bluefor",[[1714.35,5716.82],0,0,0,"12:00",player]] remoteExec ["Ctab_ui_fnc_UserMarkerAddServer", 2];    
*/
if !(isServer) exitWith {};

params ["_encryptionKey","_markerData"];


// Increase transaction ID
GVAR(userMarkerTransactionIdServer) = GVAR(userMarkerTransactionIdServer) + 1;
_transactionId = GVAR(userMarkerTransactionIdServer);

// Add marker data to list
private _userMarkerList = GVAR(userMarkerListsServer) getOrDefault [_encryptionKey, []];
if(_userMarkerList isEqualTo []) then { GVAR(userMarkerListsServer) set [_encryptionKey, _userMarkerList]};
_userMarkerList pushBack [_transactionId, _markerData];

// Send UserMarkerAdd command to all clients
[_encryptionKey,[_transactionId,_markerData],_transactionId] remoteExec [QFUNC(UserMarkerAdd)];
