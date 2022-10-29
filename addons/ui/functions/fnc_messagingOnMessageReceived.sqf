#include "script_component.hpp"

params["_msgRecipient","_msgTitle","_msgBody","_msgEncryptionKey", "_sender"];

private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
private _msgArray = _msgRecipient getVariable [format [QGVARMAIN(messages_%1),_msgEncryptionKey],[]];
_msgArray pushBack [_msgTitle,_msgBody,0];

_msgRecipient setVariable [format [QGVARMAIN(messages_%1),_msgEncryptionKey],_msgArray];

if (_msgRecipient == Ctab_player && 
	_sender != Ctab_player && 
	{_playerEncryptionKey == _msgEncryptionKey} && 
	{[Ctab_player,["ItemcTab","ItemAndroid"]] call EFUNC(core,checkGear)}) then {
	playSound QGVARMAIN(phoneVibrate);
	
	if (!isNil QGVAR(ifOpen) && {[GVAR(ifOpen) select 1,QSETTING_MODE] call FUNC(getSettings) == QSETTING_MODE_MESSAGES}) then {
		[] call FUNC(messagingLoadGUI);
		
		// add a notification
		private _notificationText = format ["New message from %1",name _sender];
		["MSG",_notificationText,6] call FUNC(addNotification);
	} else {
		GVAR(RscLayerMailNotification) cutRsc [QGVAR(mail_ico_disp), "PLAIN"]; //show
	};
};
