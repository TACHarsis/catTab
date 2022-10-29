#include "script_component.hpp"
#include "..\devices\shared\cTab_gui_macros.hpp"

params ["","_index"];

disableSerialization;

private _return = true;

private _display = uiNamespace getVariable (GVAR(ifOpen) select 1);
private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
private _msgArray = Ctab_player getVariable [format [QGVARMAIN(messages_%1),_playerEncryptionKey],[]];
private _msgName = (_msgArray select _index) select 0;
private _msgtxt = (_msgArray select _index) select 1;
private _msgState = (_msgArray select _index) select 2;
if (_msgState == 0) then {
	_msgArray set [_index,[_msgName,_msgtxt,1]];
	Ctab_player setVariable [format [QGVARMAIN(messages_%1),_playerEncryptionKey],_msgArray];
};

[] call FUNC(messagingLoadGUI);

private _txtControl = _display displayCtrl IDC_CTAB_MSG_CONTENT;
_txtControl ctrlSetText  _msgtxt;

_return
