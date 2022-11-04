#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_userMarkerListUpdate
    
    Author(s):
        Gundy

    Description:
        Update lists of user markers by finding extracting all the user markers with the right encryption key and then translate the marker data in to a format so that it can be drawn quicker.
        CC: Only called on client
        
    Parameters:
        NONE
    
    Returns:
        Nothing
    
    Example:
        call Ctab_ui_fnc_userMarkerListUpdate;
*/

private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
private _tempList = [];
{
    _tempList pushBack [_x select 0,_x select 1 call FUNC(userMarkerTranslate)];
} foreach (GVAR(userMarkerLists) getOrDefault [_playerEncryptionKey, []]);

GVAR(userMarkerListTranslated) = _tempList;
