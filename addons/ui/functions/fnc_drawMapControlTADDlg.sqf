#include "script_component.hpp"
#include "mapControlOptions.hpp"
    
// This is drawn every frame on the android display. fnc
params ["_ctrlScreen"];

[_ctrlScreen, createHashMapFromArray [
    [DMC_DRAW_MARKERS, [true,1]],
    [DMC_SCALE_POSITION, ""],
    [DMC_VEHICLE_AVATAR, GVAR(playerVehicleIcon)],
    [DMC_DRAW_HOOK, [[0,1] select GVAR(drawMapTools), true]]
]] call FUNC(drawMapControl);
