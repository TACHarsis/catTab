#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

// define vehicles that have FBCB2 monitor and broadcast it
if (isArray (ConfigFile >> QGVARMAIN(settings) >> QGVARMAIN(vehicleClass_has_FBCB2))) then {
	GVARMAIN(vehicleClass_has_FBCB2_server) = getArray (ConfigFile >> QGVARMAIN(settings) >> QGVARMAIN(vehicleClass_has_FBCB2));
} else {
	GVARMAIN(vehicleClass_has_FBCB2_server) = ["MRAP_01_base_F","MRAP_02_base_F","MRAP_03_base_F","Wheeled_APC_F","Tank","Truck_01_base_F","Truck_03_base_F"];
};
publicVariable QGVARMAIN(vehicleClass_has_FBCB2_server);

// define vehicles that have TAD  and broadcast it
if (isArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(vehicleClass_has_TAD))) then {
	GVARMAIN(vehicleClass_has_TAD_server) = getArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(vehicleClass_has_TAD));
} else {
	GVARMAIN(vehicleClass_has_TAD_server) = ["Helicopter","Plane"];
};
publicVariable QGVARMAIN(vehicleClass_has_TAD_server);

// define items that have a helmet camera and broadcast it
if (isArray (ConfigFile >> QGVARMAIN(settings) >> QGVARMAIN(helmetClass_has_HCam))) then {
	GVARMAIN(helmetClass_has_HCam_server) = getArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(helmetClass_has_HCam));
} else {
	GVARMAIN(helmetClass_has_HCam_server) = ["H_HelmetB_light","H_Helmet_Kerry","H_HelmetSpecB","H_HelmetO_ocamo","BWA3_OpsCore_Fleck_Camera","BWA3_OpsCore_Schwarz_Camera","BWA3_OpsCore_Tropen_Camera"];
};
publicVariable QGVARMAIN(vehicleClass_has_TAD_server);



[] spawn {
	waituntil {time > 0};
	sleep .1;
	
	while {true} do { // name retained for backwards compatibility
		[QGVARMAIN(updatePulse)] call CBA_fnc_globalEvent;
		sleep 30;
	};
};
