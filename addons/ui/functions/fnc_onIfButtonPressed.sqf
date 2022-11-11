#include "script_component.hpp"

/*
Function handling IF_Main keydown event
Based on player equipment and the vehicle type he might be in, open or close a cTab device as Main interface.
No Parameters
Returns TRUE when action was taken (interface opened or closed)
Returns FALSE when no action was taken (i.e. player has no cTab device / is not in cTab enabled vehicle)
*/

params [["_interfaceKey", 0, [1]]];

if (GVAR(openStart)) exitWith {false};



if (GVAR(uavViewActive)) then {
    objNull remoteControl (gunner GVAR(currentUAV));
    vehicle Ctab_player switchCamera 'internal';
    GVAR(uavViewActive) = false;

    _interfaceKey = 2;
};

if (!isNil QGVAR(ifOpen) && {GVAR(ifOpen) select 0 == _interfaceKey}) exitWith {
    // close us
    [] call FUNC(close);
};

private _previousInterface = "";
if !(isNil QGVAR(ifOpen)) then {
    _previousInterface = GVAR(ifOpen) select 1;
    // close other
    [] call FUNC(close);
};

private _player = Ctab_player;
private _vehicle = vehicle _player;

private _deviceTAD = [
    {[_player,_vehicle,QSETTINGS_TAD] call EFUNC(core,unitInEnabledVehicleSeat)},
    {GVAR(playerVehicleIcon) = getText (configFile/"CfgVehicles"/typeOf _vehicle/"Icon"); [QGVARMAIN(TAD_dsp),QGVARMAIN(TAD_dlg)] select _this}
];

private _deviceAndroid = [
    {[_player,["ItemAndroid"]] call EFUNC(core,checkGear)},
    {[QGVARMAIN(Android_dsp),QGVARMAIN(Android_dlg)] select _this}
];

private _deviceMicroDAGR = [
    {[_player,["ItemMicroDAGR"]] call EFUNC(core,checkGear)},
    //CC: If we also have a tablet, the microDAGR gets to draw cooler shit
    { GVAR(microDAGRmode) = [2,0] select ([_player,["ItemcTab"]] call EFUNC(core,checkGear)); [QGVARMAIN(microDAGR_dsp),QGVARMAIN(microDAGR_dlg)] select _this} 
];

private _deviceFBCB2 = [
    {[_player,_vehicle,QSETTINGS_FBCB2] call EFUNC(core,unitInEnabledVehicleSeat)},
    {QGVARMAIN(FBCB2_dlg)}
];

private _deviceTablet = [
    {[_player,["ItemcTab"]] call EFUNC(core,checkGear)},
    {QGVARMAIN(Tablet_dlg)}
];

//CC: Main order: TAD dsp, Android dsp, DAGR dsp, FBCB2 Vehicle, Tablet
//CC: Secondary order: TAD dlg, FBCB2, Android dlg, DAGR dlg, Tablet
//CC: Tertiary order: Tablet, Android dlg, DAGR dlg, TAD dlg, FBCB2
    
private _devices = switch (_interfaceKey) do {
    case (0) /*main*/         : {[_deviceTAD,_deviceAndroid,_deviceMicroDAGR,_deviceFBCB2,_deviceTablet]};
    case (1) /*secondary*/    : {[_deviceTAD,_deviceFBCB2,_deviceAndroid,_deviceMicroDAGR,_deviceTablet]};
    case (2) /*tertiary*/    : {[_deviceTablet,_deviceAndroid,_deviceMicroDAGR,_deviceTAD,_deviceFBCB2]};
    default {[[{false},{}]]};
};

private _interfaceName = ({
    if(call (_x # 0)) exitWith { _interfaceKey call (_x # 1) };
    ""
} foreach _devices);

if (_interfaceName != "" && _interfaceName != _previousInterface) exitWith {
    // queue the start up of the interface as we might still have one closing down
    [{
        params ["_mode", "_pfhID"];
        if (isNil QGVAR(ifOpen)) then {
            [_pfhID] call CBA_fnc_removePerFrameHandler;
            (_mode) call FUNC(open);
        };
    },0,[_interfaceKey,_interfaceName,_player,_vehicle]] call CBA_fnc_addPerFrameHandler;

    true
};

false