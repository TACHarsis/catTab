#include "script_component.hpp"
#include "mapControlOptions.hpp"
    
// This is drawn every frame on the android display. fnc
params ["_ctrlScreen"];

[_ctrlScreen, createHashMapFromArray [
    [DMC_DRAW_MARKERS,  [false,0]],
    [DMC_RECENTER,      objNull],
    [DMC_HUMAN_AVATAR,  objNull]
]] call FUNC(drawMapControl);
