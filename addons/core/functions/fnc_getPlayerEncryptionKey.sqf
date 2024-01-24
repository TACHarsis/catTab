#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_getPlayerEncryptionKey
    Author(s):
        Gundy

    Description:
        Return the used encryption key for the currently controlled unit

    Parameters:
        NONE
    Returns:
        STRING - Encryption key
    Example:
        _playerEncryptionKey = call Ctab_ui_fnc_getPlayerEncryptionKey;
*/

missionNamespace getVariable [format [QGVARMAIN(encryptionKey_%1), side Ctab_player],""];
