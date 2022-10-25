#include "script_component.hpp"
#include "..\devices\shared\cTab_gui_macros.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

params ["_mainPop", "_sendingCtrlArry"];

disableSerialization;

GVAR(cTabUserSelIcon) = [[],0,0,0,""];

private _cntrlScreen = _sendingCtrlArry select 0;

_sendingCtrlArry params ["","","_xPos", "_yPos"];

GVAR(userPos) = [_xPos,_yPos];

private _tempWorldPos = _cntrlScreen posScreenToWorld [_xPos,_yPos];
GVAR(cTabUserSelIcon) set [0,[_tempWorldPos select 0,_tempWorldPos select 1]];

private _time = call EFUNC(core,currentTime);
GVAR(cTabUserSelIcon) set [4,_time];

[_mainPop] call FUNC(userMenuSelect);
