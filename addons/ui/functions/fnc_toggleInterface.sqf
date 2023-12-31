#include "script_component.hpp"

// _interfaceName can be nil, then it just falls through and closes the current interface on the way
params ["_interfaceName"];

if (GVAR(openStart)) exitWith {};

private _vehicle = vehicle player;

private _previousInterface = "";
if !(isNil QGVAR(ifOpen)) then {
    _previousInterface = GVAR(ifOpen) select 1;
    // close other
    [] call FUNC(close);
};

if (_interfaceName != "" && _interfaceName != _previousInterface) exitWith {
    // queue the start up of the interface as we might still have one closing down
    [{
        params ["_mode", "_pfhID"];
        if (isNil QGVAR(ifOpen)) then {
            [_pfhID] call CBA_fnc_removePerFrameHandler;
            (_mode) call FUNC(open);
        };
    }, 0, [DEVICE_KEY_ORDER_ACE, _interfaceName, player, _vehicle]] call CBA_fnc_addPerFrameHandler;

    true
};

false
