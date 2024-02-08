#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

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
    _x params ["_title", "_msgBody", "_msgState"];

    private _img = switch (_msgState) do {
        case (0) : {QPATHTOEF(data,img\ui\messaging\icoUnopenedmail.paa)};
        case (1) : {QPATHTOEF(data,img\ui\messaging\icoOpenmail.paa)};
        case (2) : {QPATHTOEF(data,img\ui\messaging\icon_sentMail_ca.paa)};
        default {""}; //CC: some default here in case we add more types?
    };
    private _index = _msgControl lbAdd _title;
    _msgControl lbSetPicture [_index,_img];
    private _preview = _msgBody select [0, 15 min (count _msgBody)];
    _msgControl lbSetTooltip [_index,_preview];
} foreach _msgArray;

//TODO: messages are not compatible with the whole new setup yet?
{
    //TODO: that "isPlayer" check, was that me or was the old code? Cause it makes no sense to check if we're *the* player, not *any* human player
    if ((side _x in _validSides) /*&& {isPlayer _x}*/ && {[_x, [QITEM_TABLET, QITEM_ANDROID]] call EFUNC(core,checkGear)}) then {
        private _index = _plrlistControl lbAdd format ["%1:%2 (%3)", groupId group _x, groupId _x, name _x];
        _plrlistControl lbSetData [_index,str _x];
    };
} foreach _plrList;

lbSort [_plrlistControl, "ASC"];

_return
