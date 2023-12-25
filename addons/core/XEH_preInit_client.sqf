#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

// Exit if this is machine has no interface, i.e. is a headless client (HC)
if !(hasInterface) exitWith {};
// Set up side specific encryption keys
GVARMAIN(encryptionKey_west) = "b";
GVARMAIN(encryptionKey_east) = "o";

GVARMAIN(encryptionKey_guer) = switch (true) do {
    private _indyLikesWest = [west,resistance] call BIS_fnc_areFriendly;
    private _indyLikesEast = [east,resistance] call BIS_fnc_areFriendly;
    case (_indyLikesWest && !_indyLikesEast) : { GVARMAIN(encryptionKey_west) };
    case (_indyLikesEast && !_indyLikesWest) : { GVARMAIN(encryptionKey_east) };
    default {"i"};
};

GVARMAIN(encryptionKey_civ) = "c";

// Set up empty lists
GVARMAIN(BFTMembers) = [];
GVARMAIN(BFTgroups) = [];
GVARMAIN(BFTvehicles) = [];
GVARMAIN(UAVList) = [];
GVARMAIN(hCamList) = [];

// set current player object in Ctab_player and run a check on every frame to see if there is a change
Ctab_player = objNull;

GVAR(checkForPlayerChangePFH) = [{
    if !(Ctab_player isEqualTo (missionNamespace getVariable ["BIS_fnc_moduleRemoteControl_unit", player])) then {
        Ctab_player = missionNamespace getVariable ["BIS_fnc_moduleRemoteControl_unit", player];
        
        //prep the arrays that will hold ctab data
        GVARMAIN(BFTMembers) = [];
        GVARMAIN(BFTGroups) = [];
        GVARMAIN(BFTvehicles) = [];
        GVARMAIN(UAVList) = [];
        GVARMAIN(hCamList) = [];
        call FUNC(updateLists);

        [QGVAR(playerChanged), Ctab_player] call CBA_fnc_localEvent;
    };
}] call CBA_fnc_addPerFrameHandler;


// define vehicles that have FBCB2 monitor
GVARMAIN(vehicleClassesFBCB2) = [
    GVARMAIN(vehicleClassesFBCB2_server),
    ["MRAP_01_base_F", "MRAP_02_base_F", "MRAP_03_base_F", "Wheeled_APC_F", "Tank", "Truck_01_base_F", "Truck_03_base_F"]
    ] select isNil QGVARMAIN(vehicleClassesFBCB2_server);

// strip list of invalid config names and duplicates to save time checking through them later
private _classNamesFBCB2VehiclesValidated = [];
{
    if (isClass (configfile >> "CfgVehicles" >> _x) && _classNamesFBCB2VehiclesValidated find _x == -1) then {
        _classNamesFBCB2VehiclesValidated pushBack _x;
    };
} foreach GVARMAIN(vehicleClassesFBCB2);
GVARMAIN(vehicleClassesFBCB2) = [] + _classNamesFBCB2VehiclesValidated;

// define vehicles that have TAD
GVARMAIN(vehicleClassesTAD) = [
    GVARMAIN(vehicleClassesTAD_server),
    ["Helicopter","Plane"]
] select isNil QGVARMAIN(vehicleClassesTAD_server);

// strip list of invalid config names and duplicates to save time checking through them later
private _classNamesTADVehiclesValidated = [];
{
    if (isClass (configfile >> "CfgVehicles" >> _x) && _classNamesTADVehiclesValidated find _x == -1) then {
        _classNamesTADVehiclesValidated pushBack _x;
    };
} foreach GVARMAIN(vehicleClassesTAD);
GVARMAIN(vehicleClassesTAD) = [] + _classNamesTADVehiclesValidated;

// define items that enable head cam
GVARMAIN(helmetClasses) = [
        GVARMAIN(helmetClasses_server),
        ["H_HelmetB_light", "H_Helmet_Kerry", "H_HelmetSpecB", "H_HelmetO_ocamo", "BWA3_OpsCore_Fleck_Camera", "BWA3_OpsCore_Schwarz_Camera", "BWA3_OpsCore_Tropen_Camera"]
] select isNil QGVARMAIN(helmetClasses_server);

// strip list of invalid config names and duplicates to save time checking through them later
private _classNamesHelmetValidated = [];
{
    if (isClass (configfile >> "CfgWeapons" >> _x) && _classNamesHelmetValidated find _x == -1) then {
        _classNamesHelmetValidated pushBack _x;
    };
} foreach GVARMAIN(helmetClasses);
// iterate through all class names and add child classes, so we end up with a list of helmet classes that have the defined helmet classes as parents 
{
    _childClasses = "inheritsFrom _x == (configfile >> 'CfgWeapons' >> '" + _x + "')" configClasses (configfile >> "CfgWeapons");
    {
        _childClassName = configName _x;
        if (_classNamesHelmetValidated find _childClassName == -1) then {
            _classNamesHelmetValidated pushBack configName _x;
        };
    } foreach _childClasses;
} forEach _classNamesHelmetValidated;
GVARMAIN(helmetClasses) = [] + _classNamesHelmetValidated;

// add updatePulse event handler triggered periodically by the server
[
    QGVARMAIN(updatePulse),
    FUNC(updateLists)
] call CBA_fnc_addEventHandler;
