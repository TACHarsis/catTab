#include "script_component.hpp"
#include "mapControlOptions.hpp"
    
// This is drawn every frame on the TAD display. fnc
params ["_ctrlScreen"];

[_ctrlScreen, createHashMapFromArray [
    [DMC_DRAW_MARKERS,  [false,1]],
    [DMC_RECENTER,      objNull],
    [DMC_VEHICLE_AVATAR, GVAR(playerVehicleIcon)],
    [DMC_TAD_OVERLAY, nil]
]] call FUNC(drawMapControl);
