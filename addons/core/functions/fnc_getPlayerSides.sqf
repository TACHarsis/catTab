#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_getPlayerSides
    Author(s):
        Gundy

    Description:
        Compile a list of valid sides based on the set encryption keys of the current player

    Parameters:
        NONE
    Returns:
        ARRAY - List of sides that share cTab data with the player unit
    Example:
        _validSides = call Ctab_ui_fnc_getPlayerSides;
*/

private _return = [];
private _playerEncryptionKey = [] call FUNC(getPlayerEncryptionKey);

switch (_playerEncryptionKey) do {
    case GVARMAIN(encryptionKey_west) : {_return pushBack west};
    case GVARMAIN(encryptionKey_east) : {_return pushBack east};
    case GVARMAIN(encryptionKey_guer) : {_return pushBack resistance};
    case GVARMAIN(encryptionKey_civ)  : {_return pushBack civilian};
};

_return
