#include "script_component.hpp"
#include "mapControlOptions.hpp"

params ["_ctrlScreen"];

if (isNil QGVAR(currentUAV) || {isNull GVAR(currentUAV)}) exitWith {};
if (GVAR(currentUAV) == Ctab_player) exitWith {};

private _camHost = GVAR(helmetCams) select 2;

[_ctrlScreen, createHashMapFromArray [
    [DMC_DRAW_MARKERS,  [false,0]],
    [DMC_RECENTER, GVAR(currentUAV)],
    [DMC_HUMAN_AVATAR, GVAR(currentUAV)],
    [DMC_HUMAN_AVATAR, objNull]
]] call FUNC(drawMapControl);
