#include "script_component.hpp"

private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
Ctab_player setVariable [format ["cTab_messages_%1",_playerEncryptionKey],[]];
