#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

// Exit if this is machine has no interface, i.e. is a headless client (HC)
if !(hasInterface) exitWith {};
// Set up side specific encryption keys
if (isNil QGVARMAIN(encryptionKey_west)) then {
	GVARMAIN(encryptionKey_west) = "b";
};
if (isNil QGVARMAIN(encryptionKey_east)) then {
	GVARMAIN(encryptionKey_east) = "o";
};
if (isNil QGVARMAIN(encryptionKey_guer)) then {
	GVARMAIN(encryptionKey_guer) = call {
		if (([west,resistance] call BIS_fnc_areFriendly) and {!([east,resistance] call BIS_fnc_areFriendly)}) exitWith {
			"b"
		};
		if (([east,resistance] call BIS_fnc_areFriendly) and {!([west,resistance] call BIS_fnc_areFriendly)}) exitWith {
			"o"
		};
		"i"
	};
};
if (isNil QGVARMAIN(encryptionKey_civ)) then {
	GVARMAIN(encryptionKey_civ) = "c";
};

// Set up empty lists
GVARMAIN(BFTMembers) = [];
GVARMAIN(BFTgroups) = [];
GVARMAIN(BFTvehicles) = [];
GVARMAIN(UAVList) = [];
GVARMAIN(hCamList) = [];

// set current player object in Ctab_player and run a check on every frame to see if there is a change
Ctab_player = objNull;

GVAR(checkForPlayerChangePFH) = [{
	if !(Ctab_player isEqualTo (missionNamespace getVariable ["BIS_fnc_moduleRemoteControl_unit",player])) then {
		Ctab_player = missionNamespace getVariable ["BIS_fnc_moduleRemoteControl_unit",player];
		// close any interface that might still be open
		call EFUNC(ui,close);
		//prep the arrays that will hold ctab data
		GVARMAIN(BFTMembers) = [];
		GVARMAIN(BFTGroups) = [];
		GVARMAIN(BFTvehicles) = [];
		GVARMAIN(UAVList) = [];
		GVARMAIN(hCamList) = [];
		call FUNC(updateLists);
		call EFUNC(ui,updateUserMarkerList);
		// remove msg notification
		EGVAR(ui,RscLayerMailNotification) cutText ["", "PLAIN"];
	};
}] call CBA_fnc_addPerFrameHandler;


// define vehicles that have FBCB2 monitor
if (isNil QGVARMAIN(vehicleClass_has_FBCB2)) then {
	if !(isNil "") then {
		GVARMAIN(vehicleClass_has_FBCB2) = ;
	} else {
		GVARMAIN(vehicleClass_has_FBCB2) = ["MRAP_01_base_F","MRAP_02_base_F","MRAP_03_base_F","Wheeled_APC_F","Tank","Truck_01_base_F","Truck_03_base_F"];
	};
};
// strip list of invalid config names and duplicates to save time checking through them later
_classNames = [];
{
	if (isClass (configfile >> "CfgVehicles" >> _x) && _classNames find _x == -1) then {
		_classNames pushBack _x;
	};
} foreach GVARMAIN(vehicleClass_has_FBCB2);
GVARMAIN(vehicleClass_has_FBCB2) = [] + _classNames;

// define vehicles that have TAD
if (isNil QGVAR(vehicleClass_has_TAD)) then {
	if !(isNil "") then {
		GVARMAIN(vehicleClass_has_TAD) = ;
	} else {
		GVARMAIN(vehicleClass_has_TAD) = ["Helicopter","Plane"];
	};
};
// strip list of invalid config names and duplicates to save time checking through them later
_classNames = [];
{
	if (isClass (configfile >> "CfgVehicles" >> _x) && _classNames find _x == -1) then {
		_classNames pushBack _x;
	};
} foreach GVARMAIN(vehicleClass_has_TAD);
GVARMAIN(vehicleClass_has_TAD) = [] + _classNames;

// define items that enable head cam
if (isNil QGVARMAIN(helmetClass_has_HCam)) then {
	if !(isNil "") then {
		GVARMAIN(helmetClass_has_HCam) = ;
	} else {
		GVARMAIN(helmetClass_has_HCam) = ["H_HelmetB_light","H_Helmet_Kerry","H_HelmetSpecB","H_HelmetO_ocamo","BWA3_OpsCore_Fleck_Camera","BWA3_OpsCore_Schwarz_Camera","BWA3_OpsCore_Tropen_Camera"];
	};
};
// strip list of invalid config names and duplicates to save time checking through them later
_classNames = [];
{
	if (isClass (configfile >> "CfgWeapons" >> _x) && _classNames find _x == -1) then {
		_classNames pushBack _x;
	};
} foreach GVARMAIN(helmetClass_has_HCam);
// iterate through all class names and add child classes, so we end up with a list of helmet classes that have the defined helmet classes as parents 
{
	_childClasses = "inheritsFrom _x == (configfile >> 'CfgWeapons' >> '" + _x + "')" configClasses (configfile >> "CfgWeapons");
	{
		_childClassName = configName _x;
		if (_classNames find _childClassName == -1) then {
			_classNames pushBack configName _x;
		};
	} foreach _childClasses;
} forEach _classNames;
GVARMAIN(helmetClass_has_HCam) = [] + _classNames;

// add updatePulse event handler triggered periodically by the server
[QGVARMAIN(updatePulse),FUNC(updateLists)] call CBA_fnc_addEventHandler;

//CC: There must be a nicer way
//Main loop to add the key handler to the unit.
[] spawn {
	waitUntil {sleep 0.1;!(IsNull (findDisplay 46))};
	// if player is curator (ZEUS), setup key handlers
	waitUntil {sleep 0.1;!(isNull player)};
	sleep 2;
	if (player in (call BIS_fnc_listCuratorPlayers)) then {	
		[] spawn {
			while {true} do {
				waitUntil {sleep 0.1;!(isNull (findDisplay 312))};			
				(findDisplay 312) displayAddEventHandler ["KeyDown",{[_this,'keydown'] call FUNC(processCuratorKey)}];
				(findDisplay 312) displayAddEventHandler ["KeyUp",{[_this,'keyup'] call FUNC(processCuratorKey)}];
				waitUntil {sleep 0.1;isNull (findDisplay 312)};
			};
		};
	};
};
