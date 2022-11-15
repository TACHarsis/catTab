#include "script_component.hpp"
#include "mapControlOptions.hpp"

params ["_ctrlScreen"];

if (isNil QGVAR(helmetCams)) exitWith {};
private _camHost = GVAR(helmetCams) select 2;

[_ctrlScreen, createHashMapFromArray [
    [DMC_DRAW_MARKERS,  [false,0]],
    [DMC_RECENTER,      _camHost],
    [DMC_HUMAN_AVATAR,  _camHost],
    [DMC_HUMAN_AVATAR,  objNull]
]] call FUNC(drawMapControl);
