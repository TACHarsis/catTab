#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_centerMap
     Author(s):
        Gundy

     Description:
        Center BFT Map on currently relevant unit's position
    Parameters:
        0: STRING - Name of uiNamespace display / dialog variable
     Returns:
        BOOLEAN - TRUE
     Example:
        ['Ctab_TAD_dlg'] call Ctab_ui_fnc_centerMap;
*/
params ["_displayName"];

if (isNil QGVAR(ifOpen)) exitWith {true};
private _displayName = GVAR(ifOpen) select 1;
private _mode = "";
if(_displayName isEqualTo QGVARMAIN(Tablet_dlg)) then {
   _mode = [QGVARMAIN(Tablet_dlg), QSETTING_MODE] call FUNC(getSettings);
};

private _focusUnit = (switch (_mode) do {
    case (QSETTING_MODE_CAM_UAV): { [Ctab_player, GVAR(selectedUAV)] select !isNull GVAR(selectedUAV) };
    case (QSETTING_MODE_CAM_HCAM): { [Ctab_player, GVAR(selectedHCam)] select !isNull GVAR(selectedHCam) };
    default { Ctab_player }
});

[_displayName, [[QSETTING_MAP_WORLD_POS, getPosASL vehicle _focusUnit]], true, true] call FUNC(setSettings);

true
