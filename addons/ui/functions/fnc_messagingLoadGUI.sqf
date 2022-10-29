#include "script_component.hpp"
#include "..\devices\shared\cTab_gui_macros.hpp"

disableSerialization;

private _return = true;
private _display = uiNamespace getVariable (GVAR(ifOpen) select 1);
private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
private _msgArray = Ctab_player getVariable [format [QGVARMAIN(messages_%1),_playerEncryptionKey],[]];
private _msgControl = _display displayCtrl IDC_CTAB_MSG_LIST;
private _plrlistControl = _display displayCtrl IDC_CTAB_MSG_RECIPIENTS;
lbClear _msgControl;
lbClear _plrlistControl;
private _plrList = playableUnits;
// since playableUnits will return an empty array in single player, add the player if array is empty
if (_plrList isEqualTo []) then {_plrList pushBack Ctab_player};
private _validSides = call EFUNC(core,getPlayerSides);

// turn this on for testing, otherwise not really usefull, since sending to an AI controlled, but switchable unit will send the message to the player themselves
/*if (count _plrList < 1) then { _plrList = switchableUnits;};*/

uiNamespace setVariable [QGVAR(msgPlayerList), _plrList];
// Messages
{
	private _title =  _x select 0;
	private _msgState = _x select 2;
	private _img = call {
		if (_msgState == 0) exitWith {QPATHTOEF(data,img\icoUnopenedmail.paa)};
		if (_msgState == 1) exitWith {QPATHTOEF(data,img\icoOpenmail.paa)};
		if (_msgState == 2) exitWith {QPATHTOEF(data,img\icon_sentMail_ca.paa)};
	};
	private _index = _msgControl lbAdd _title;
	_msgControl lbSetPicture [_index,_img];
	_msgControl lbSetTooltip [_index,_title];
} foreach _msgArray;

{
	if ((side _x in _validSides) && {isPlayer _x} && {[_x,["ItemcTab","ItemAndroid"]] call EFUNC(core,checkGear)}) then {
		private _index = _plrlistControl lbAdd format ["%1:%2 (%3)",groupId group _x,[_x] call CBA_fnc_getGroupIndex,name _x];
		_plrlistControl lbSetData [_index,str _x];
	};
} foreach _plrList;

lbSort [_plrlistControl, "ASC"];

_return
