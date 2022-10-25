#include "script_component.hpp"

/*
Function handling IF_Secondary keydown event
Based on player equipment and the vehicle type he might be in, open or close a cTab device as Secondary interface.
No Parameters
Returns TRUE when action was taken (interface opened or closed)
Returns FALSE when no action was taken (i.e. player has no cTab device / is not in cTab enabled vehicle)
*/

if (GVAR(openStart)) exitWith {false};

private _previousInterface = "";

if (GVAR(uavViewActive)) exitWith {
	objNull remoteControl (gunner GVAR(actUAV));
	vehicle Ctab_player switchCamera 'internal';
	GVAR(uavViewActive) = false;
	call FUNC(onIfTertiaryPressed);

	true
};
private _ifTypesPrimary = 0;
private _ifTypesSecondary = 1;
private _ifTypesTertiary = 2;
if (!isNil QGVAR(ifOpen) && {GVAR(ifOpen) select 0 == _ifTypesSecondary}) exitWith {
	// close Secondary
	call FUNC(close);

	true
};

if !(isNil QGVAR(ifOpen)) then {
	_previousInterface = GVAR(ifOpen) select 1;

	// close Main / Tertiary
	call FUNC(close);
};

private _player = Ctab_player;
private _vehicle = vehicle _player;
private _interfaceName = call {

	//CC: Secondary order: TAD, FBCB2, Android, DAGR, Tablet

	if ([_player,_vehicle,"TAD"] call EFUNC(core,unitInEnabledVehicleSeat)) exitWith {
		GVAR(playerVehicleIcon) = getText (configFile/"CfgVehicles"/typeOf _vehicle/"Icon");

		QGVARMAIN(TAD_dlg)
	};

	if ([_player,_vehicle,"FBCB2"] call EFUNC(core,unitInEnabledVehicleSeat)) exitWith {QGVARMAIN(FBCB2_dlg)};
	
	// secondary == dlg
	if ([_player,["ItemAndroid"]] call EFUNC(core,checkGear)) exitWith {QGVARMAIN(Android_dlg)};

	if ([_player,["ItemMicroDAGR"]] call EFUNC(core,checkGear)) exitWith {
		//CC: If we also have a tablet, the microDAGR gets to draw cooler shit
		GVAR(microDAGRmode) = if ([_player,["ItemcTab"]] call EFUNC(core,checkGear)) then {0} else {2};

		QGVARMAIN(microDAGR_dlg)
	};

	if ([_player,["ItemcTab"]] call EFUNC(core,checkGear)) exitWith {QGVARMAIN(Tablet_dlg)};

	// default
	""
};

if (_interfaceName != "" && _interfaceName != _previousInterface) exitWith {
	// queue the start up of the interface as we might still have one closing down
	[{
		params ["_mode", "_pfhID"];

		if (isNil QGVAR(ifOpen)) then {
			[_pfhID] call CBA_fnc_removePerFrameHandler;
			(_mode) call FUNC(open);
		};
	},0,[_ifTypesSecondary,_interfaceName,_player,_vehicle]] call CBA_fnc_addPerFrameHandler;

	true
};

false
