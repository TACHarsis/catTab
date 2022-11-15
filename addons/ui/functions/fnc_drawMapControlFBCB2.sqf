#include "script_component.hpp"
#include "mapControlOptions.hpp"
    
// This is drawn every frame on the android display. fnc
params ["_ctrlScreen"];

[_ctrlScreen, createHashMapFromArray [
    [DMC_DRAW_MARKERS,  [true,0]],
    [DMC_SCALE_POSITION, ""],
    [DMC_HUMAN_AVATAR,  objNull],
    [DMC_DRAW_HOOK,     [0,false]]
]] call FUNC(drawMapControl);
