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
GVARMAIN(UAVVideoSources) = createHashMap;
GVARMAIN(hCamVideoSources) = createHashMap;

// set current player object in Ctab_player and run a check on every frame to see if there is a change
Ctab_player = objNull;

GVAR(checkForPlayerChangePFH) = [{
    if !(Ctab_player isEqualTo (missionNamespace getVariable ["BIS_fnc_moduleRemoteControl_unit", player])) then {
        Ctab_player = missionNamespace getVariable ["BIS_fnc_moduleRemoteControl_unit", player];

        //prep the arrays that will hold ctab data
        GVARMAIN(BFTMembers) = [];
        GVARMAIN(BFTGroups) = [];
        GVARMAIN(BFTvehicles) = [];
        GVARMAIN(UAVVideoSources) = createHashMap;
        GVARMAIN(hCamVideoSources) = createHashMap;
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

// define items thatE enable head cam
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

#include "setupVideoSourceContext.inc.sqf"

addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator", "_useEffects"];
    private _unitNetID = _unit call BIS_fnc_netId;
    {
        private _type = _x;
        private _sourcesHash = _y get QGVAR(sourcesHash);
        if(_unitNetID in _sourcesHash) exitWith
        {
            [_type, _unitNetID] call FUNC(updateVideoSource);
        };
    } foreach GVAR(videoSourcesContext);
}];

//TODO: Test to see if we catch the initialized inventory this time or if it still reports a false negative on units that should start with camera items
private _fnc_onSourceInit = {
    params ["_unit"];

    private _type = switch (true) do {
        case (_unit isKindOf "CAManBase"): { VIDEO_FEED_TYPE_HCAM };
        case (_unit isKindOf "UAV"): { VIDEO_FEED_TYPE_UAV };
        default { "" };
    };
    if(_type isNotEqualTo "") then {
        private _unitNetID = _unit call BIS_fnc_netId;
        [
            {
                params ["_type", "_unitNetID"];
                private _context = GVAR(videoSourcesContext) get _type;
                private _sourcesHash = _context get QGVAR(sourcesHash);

                [_type, _unitNetID, true] call FUNC(updateVideoSource);
            },
            [_type, _unitNetID]
        ] call CBA_fnc_execNextFrame;
    };
};

["CAManBase", "init", _fnc_onSourceInit, true, [], true] call CBA_fnc_addClassEventHandler;
["UAV", "init", _fnc_onSourceInit, true, [], true] call CBA_fnc_addClassEventHandler;

private _fnc_onSourceDeleted = {
    params ["_unit"];

    private _unitNetID = _unit call BIS_fnc_netId;
    {
        private _type = _x;
        private _context = _y;
        private _sourcesHash = _context get QGVAR(sourcesHash);
        if(_unitNetID in _sourcesHash) then {
            // wait till next frame so the unit can go null
            [
                {
                    params ["_type", "_unitNetID", "_unit"];

                    isNull _unit
                },
                {
                    params ["_type", "_unitNetID", "_unit"];
                    [_type, _unitNetID] call FUNC(updateVideoSource);
                },
                [_type, _unitNetID, _unit]
            ] call CBA_fnc_waitUntilAndExecute;
        };
    } foreach GVAR(videoSourcesContext);
};

["CAManBase", "Deleted", _fnc_onSourceDeleted, true, [], true] call CBA_fnc_addClassEventHandler;
["UAV", "Deleted", _fnc_onSourceDeleted, true, [], true] call CBA_fnc_addClassEventHandler;

GVAR(videoSourceUpdatePFHID) = [
    {
        {
            private _type = _x;
            private _context = _y;
            private _sourcesHash = _context get QGVAR(sourcesHash);
            private _units = [] call (_context get QGVAR(fnc_getUnits));
            {
                private _unit = _x;
                private _unitNetID = _unit call BIS_fnc_netId;
                private _sourceData = _sourcesHash getOrDefault [_unitNetID, []];
                private _known = _sourceData isNotEqualTo [];
                private _fnc_prepareUnit = _context get QGVAR(fnc_prepareUnit);
                private _isEnabled = [_unit] call _fnc_prepareUnit;

                if(!_known && _isEnabled) then {
                    // this is basically picking up stragglers that didn't have their inventory loaded at init time.
                    [_type, _unitNetID, true] call FUNC(updateVideoSource);
                };
                if(_known) then {
                    //TAG: video source data
                    _sourceData params ["_unitNetID", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];
                    if(_enabled isNotEqualTo _isEnabled) then {
                        [_type, _unitNetID] call FUNC(updateVideoSource);
                    };
                };
            } foreach _units;
        } foreach GVAR(videoSourcesContext);
    },
    1
] call CBA_fnc_addPerFrameHandler;
