#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

/*
Function called when DELETE button is pressed in messaging mode
Parameter 0: Name of uiNameSpace variable of display
Returns false if nothing was selected for deletion, else returns true
*/
params ["_displayName"];

private _display = uiNamespace getVariable _displayName;
private _msgLbCtrl = _display displayCtrl IDC_CTAB_MSG_LIST;
private _msgLbSelection = lbSelection _msgLbCtrl;

if (count _msgLbSelection == 0) exitWith {false};
private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
private _msgArray = Ctab_player getVariable [format [QGVARMAIN(messages_%1),_playerEncryptionKey],[]];

// run through the selection backwards as otherwise the indices won't match anymore
for "_i" from (count _msgLbSelection) to 0 step -1 do {
    _msgArray deleteAt (_msgLbSelection select _i);
};
Ctab_player setVariable [format [QGVARMAIN(messages_%1),_playerEncryptionKey],_msgArray];

private _msgTextCtrl = _display displayCtrl IDC_CTAB_MSG_CONTENT;
_msgTextCtrl ctrlSetText "No Message Selected";
[] call FUNC(messagingLoadGUI);

true
