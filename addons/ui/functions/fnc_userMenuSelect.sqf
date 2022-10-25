#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_userMenuSelect
	
	Author(s):
		Gundy, Riouken
	
	Description:
		Process user menu select events, initiated by "devices\shared\cTab_markerMenu_controls.hpp"
		
	
	Parameters:
		0: INTEGER - Type of user menu select event - if this doesn't match a valid type it will be considered to be an IDC
	
	Returns:
		BOOLEAN - TRUE
	
	Example:
		[1] call Ctab_ui_fnc_userMenuSelect;
*/

#include "..\devices\shared\cTab_gui_macros.hpp"

params ["_type"];

disableSerialization;


private _displayName = GVAR(ifOpen) select 1;
private _display = (uiNamespace getVariable _displayName);

private _idcToShow = 0;

call {
	// send GVAR(cTabUserSelIcon) to server
	if (_type == 1) exitWith {
		GVAR(cTabUserSelIcon) pushBack Ctab_player;
		[call EFUNC(core,getPlayerEncryptionKey),GVAR(cTabUserSelIcon)] call FUNC(addUserMarker);
	};
	
	// Lock UAV cam to clicked position
	if (_type == 2) exitWith {
		[GVAR(cTabUserSelIcon) select 0] call FUNC(lockUavCamTo);
	};

	_idcToShow = call {
		if (_type == 11) exitWith {3301};
		if (_type == 12) exitWith {3303};
		if (_type == 13) exitWith {3304};
		if (_type == 14) exitWith {
			if (GVAR(cTabUserSelIcon) select 1 != 0) then {
				GVAR(cTabUserSelIcon) set [2,0];
				3304
			} else {3307};
		};
		if (_type == 21) exitWith {3305};
		if (_type == 31) exitWith {3306};
		_type;
	};
};

// Hide all menu controls
{ctrlShow [_x,false];} foreach [IDC_CTAB_MARKER_MENU_MAIN,3301,3302,3303,3304,3305,3306,3307];

// Bring the menu control we want to show into position and show it
if (_idcToShow != 0) then {
	private _control = _display displayCtrl _idcToShow;
	if !(isNull _control) then {
		private _controlPos = ctrlPosition _control;
		
		// figure out screen edge positions and where the edges of the control would be if we were just to move it blindly to userPos
		private _screenPos = ctrlPosition (_display displayCtrl IDC_CTAB_LOADINGTXT);
		private _screenEdgeX = (_screenPos select 0) + (_screenPos select 2);
		private _screenEdgeY = (_screenPos select 1) + (_screenPos select 3);
		private _controlEdgeX = (GVAR(userPos) select 0) + (_controlPos select 2);
		private _controlEdgeY = (GVAR(userPos) select 1) + (_controlPos select 3);
		
		// if control would be clipping the right edge, correct control position
		if (_controlEdgeX > _screenEdgeX) then {
			_controlPos set [0,_screenEdgeX - (_controlPos select 2)];
		} else {
			_controlPos set [0,GVAR(userPos) select 0];
		};
		// if control would be clipping the bottom edge, correct control position
		if (_controlEdgeY > _screenEdgeY) then {
			_controlPos set [1,_screenEdgeY - (_controlPos select 3)];
		} else {
			_controlPos set [1,GVAR(userPos) select 1];
		};
		
		// move to position and show
		_control ctrlSetPosition _controlPos;
		_control ctrlCommit 0;
		_control ctrlShow true;
		ctrlSetFocus _control;
	};
};

true
