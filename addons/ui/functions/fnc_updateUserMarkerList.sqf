#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_updateUserMarkerList
	
	Author(s):
		Gundy

	Description:
		Update lists of user markers by finding extracting all the user markers with the right encryption key and then translate the marker data in to a format so that it can be drawn quicker.
		
	Parameters:
		NONE
	
	Returns:
		BOOLEAN - Always TRUE
	
	Example:
		call Ctab_ui_fnc_updateUserMarkerList;
*/

private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);

private _tempList = [];
{
	_tempList pushBack [_x select 0,_x select 1 call FUNC(translateUserMarker)];
} foreach ([GVAR(userMarkerLists),_playerEncryptionKey,[]] call EFUNC(core,getFromPairs));

GVAR(userMarkerList) = _tempList;

true
