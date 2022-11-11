#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

disableSerialization;

GVAR(cTabUserSelIcon) = [[],0,0,0,""];

GVAR(userPos) = [_xPos,_yPos];

private _tempWorldPos = _control posScreenToWorld [_xPos,_yPos];
GVAR(cTabUserSelIcon) set [0,[_tempWorldPos select 0,_tempWorldPos select 1]];

private _time = call EFUNC(core,currentTime);
GVAR(cTabUserSelIcon) set [4,_time];

[IDC_CTAB_MARKER_MENU_MAIN] call FUNC(userMenuSelect);
