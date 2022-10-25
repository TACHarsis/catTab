#include "script_component.hpp"
#include "..\devices\shared\cTab_gui_macros.hpp"

disableSerialization;

private _return = true;
private _display = uiNamespace getVariable (GVAR(ifOpen) select 1);
private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
private _plrLBctrl = _display displayCtrl IDC_CTAB_MSG_RECIPIENTS;
private _msgBodyctrl = _display displayCtrl IDC_CTAB_MSG_COMPOSE;
private _plrList = (uiNamespace getVariable QGVAR(msgPlayerList));

private _indices = lbSelection _plrLBctrl;

if (_indices isEqualTo []) exitWith {false};

private _time = call EFUNC(core,currentTime);
private _msgTitle = format ["%1 - %2:%3 (%4)",_time,groupId group Ctab_player,[Ctab_player] call CBA_fnc_getGroupIndex,name Ctab_player];
private _msgBody = ctrlText _msgBodyctrl;
if (_msgBody isEqualTo "") exitWith {false};
private _recipientNames = "";

{
	private _data = _plrLBctrl lbData _x;
	private _recip = objNull;
	{
		if (_data == str _x) exitWith {_recip = _x;};
	} foreach _plrList;
	
	if !(IsNull _recip) then {
		if (_recipientNames isEqualTo "") then {
			_recipientNames = format ["%1:%2 (%3)",groupId group _recip,[_recip] call CBA_fnc_getGroupIndex,name _recip];
		} else {
			_recipientNames = format ["%1; %2",_recipientNames,name _recip];
		};
		
		private _arguments = [_recip,_msgTitle,_msgBody,_playerEncryptionKey,Ctab_player];

		[QGVARMAIN(msg_receive),_arguments,_recip] call CBA_fnc_targetEvent;
	};
} forEach _indices;

// If the message was sent
if (_recipientNames != "") then {
	private _msgArray = Ctab_player getVariable [format [QGVAR(messages_%1),_playerEncryptionKey],[]];
	_msgArray pushBack [format ["%1 - %2",_time,_recipientNames],_msgBody,2];
	Ctab_player setVariable [format [QGVAR(messages_%1),_playerEncryptionKey],_msgArray];

	if (!isNil QGVAR(ifOpen) && {[GVAR(ifOpen) select 1,"mode"] call FUNC(getSettings) == "MESSAGE"}) then {
		call FUNC(messagingLoadGUI);
	};
	
	// add a notification
	["MSG","Message sent successfully",3] call FUNC(addNotification);
	playSound QGVARMAIN(mailSent);
	// remove message body
	_msgBodyctrl ctrlSetText "";
	// clear selected recipients
	_plrLBctrl lbSetCurSel -1;
};

_return
