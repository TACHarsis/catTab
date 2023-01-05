#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

// define vehicles that have FBCB2 monitor and broadcast it
if (isArray (ConfigFile >> QGVARMAIN(settings) >> QGVARMAIN(vehicleClassesFBCB2))) then {
    GVARMAIN(vehicleClassesFBCB2_server) = getArray (ConfigFile >> QGVARMAIN(settings) >> QGVARMAIN(vehicleClassesFBCB2));
} else {
    GVARMAIN(vehicleClassesFBCB2_server) = ["MRAP_01_base_F","MRAP_02_base_F","MRAP_03_base_F","Wheeled_APC_F","Tank","Truck_01_base_F","Truck_03_base_F"];
};
publicVariable QGVARMAIN(vehicleClassesFBCB2_server);

// define vehicles that have TAD  and broadcast it
if (isArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(vehicleClassesTAD))) then {
    GVARMAIN(vehicleClassesTAD_server) = getArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(vehicleClassesTAD));
} else {
    GVARMAIN(vehicleClassesTAD_server) = ["Helicopter","Plane"];
};
publicVariable QGVARMAIN(vehicleClassesTAD_server);

// define items that have a helmet camera and broadcast it
if (isArray (ConfigFile >> QGVARMAIN(settings) >> QGVARMAIN(helmetClasses))) then {
    GVARMAIN(helmetClasses_server) = getArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(helmetClasses));
} else {
    GVARMAIN(helmetClasses_server) = ["H_HelmetB_light","H_Helmet_Kerry","H_HelmetSpecB","H_HelmetO_ocamo","BWA3_OpsCore_Fleck_Camera","BWA3_OpsCore_Schwarz_Camera","BWA3_OpsCore_Tropen_Camera"];
};
publicVariable QGVARMAIN(vehicleClassesTAD_server);

[
    { time > 0 },
    {[
        {   // name retained for backwards compatibility
            [QGVARMAIN(updatePulse)] call CBA_fnc_globalEvent;
        },
        30
    ]  call CBA_fnc_addPerFrameHandler;}
] call CBA_fnc_waitUntilAndExecute;
