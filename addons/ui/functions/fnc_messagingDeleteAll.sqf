#include "script_component.hpp"

private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
Ctab_player setVariable [format [QGVARMAIN(messages_%1),_playerEncryptionKey],[]];
