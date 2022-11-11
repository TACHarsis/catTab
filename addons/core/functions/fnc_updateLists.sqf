#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_updateLists
    
    Author(s):
        Gundy, Riouken

    Description:
        Update lists of cTab units and vehicles
        Lists updated:
            GVARMAIN(BFTMembers)
            GVARMAIN(BFTGroups)
            GVARMAIN(BFTvehicles)
            GVARMAIN(UAVList)
            GVARMAIN(hCamList)
        
        List format (all except GVARMAIN(hCamList)):
            Index 0: Unit object
            Index 1: Path to icon A
            Index 2: Path to icon B (either group size or wingmen)
            Index 3: Text to display
            Index 4: String of group index
    
    Parameters:
        NONE
    
    Returns:
        BOOLEAN - Always TRUE
    
    Example:
        call Ctab_ui_fnc_updateLists;
*/

private _bftMembers = []; // members of player's group
private _bftGroups = []; // other groups
private _bftVehicles = []; // all vehicles
private _uavList =  []; // all remote controllable UAVs
private _hCamList = [];  // units with a helmet cam

private _validSides = call FUNC(getPlayerSides);
private _playerVehicle = vehicle Ctab_player;
private _playerGroup = group Ctab_player;

/*
GVARMAIN(BFTMembers) --- GROUP MEMBERS
*/
{
    if ((_x != Ctab_player) && {[_x,["ItemcTab","ItemAndroid","ItemMicroDAGR"]] call FUNC(checkGear)}) then {
        _bftMembers pushBack _x;
    };
} foreach units Ctab_player;

/*
GVARMAIN(BFTGroups) --- GROUPS
Groups on our side that player is not a member of. Use the leader for positioning if he has a Tablet or Android.
Else, search through the group and use the first member we find equipped with a Tablet or Android for positioning.
*/
{
    private _group = _x;
    if ((side _group in _validSides) && {_group != _playerGroup}) then {
        _leader = objNull;
        if ([leader _group,["ItemcTab","ItemAndroid"]] call FUNC(checkGear)) then {
            _leader = leader _group;
        } else {
            {
                private _unit = _x;
                if ([_unit,["ItemcTab","ItemAndroid"]] call FUNC(checkGear)) then {
                    _leader = _unit;
                };
            } foreach units _group;
        };
        if !(IsNull _leader) then {
            _bftGroups pushBack [_group, _leader];
        };
    };
} foreach allGroups;

/*
GVARMAIN(BFTvehicles) --- VEHICLES
Vehciles on our side, that are not empty and that player is not sitting in.
*/
{
    if ((side _x in _validSides) && {count (crew _x) > 0} && {_x != _playerVehicle}) then {
        _bftVehicles pushBack _x;
    };
} foreach vehicles;

/*
GVARMAIN(UAVList) --- UAVs
*/
{
    if (side _x in _validSides) then {
        _uavList pushBack _x;
    };
} foreach allUnitsUav;

/*
GVARMAIN(hCamList) --- HELMET CAMS
Units on our side, that have either helmets that have been specified to include a helmet cam, or ItemCTabHCAM in their inventory.
*/
{
    if (side _x in _validSides) then {
        private _headgear = headgear _x;
        private _camera = getNumber (configfile >> "CfgWeapons" >> _headgear >> "CTAB_Camera");
        if (_camera isNotEqualTo 0 ||
            {_headgear in GVARMAIN(helmetClass_has_HCam)} ||
            {[_x,["ItemcTabHCam"]] call FUNC(checkGear)}) then {
            _hCamList pushBack _x;
        };
    };
} foreach allUnits;

// array to hold interface update commands
private _updateInterface = createHashMap;

// replace the global list arrays in the end so that we avoid them being empty unnecessarily
if !(GVARMAIN(BFTMembers) isEqualTo _bftMembers) then {
    GVARMAIN(BFTMembers) = [] + _bftMembers;
    [QGVAR(bftMemberListUpdate), [GVARMAIN(BFTMembers)]] call CBA_fnc_localEvent;
};

if !(GVARMAIN(BFTGroups) isEqualTo _bftGroups) then {
    GVARMAIN(BFTGroups) = [] + _bftGroups;
    [QGVAR(bftGroupListUpdate), [GVARMAIN(BFTGroups)]] call CBA_fnc_localEvent;
};

if !(GVARMAIN(BFTvehicles) isEqualTo _bftVehicles) then {
    GVARMAIN(BFTvehicles) = [] + _bftVehicles;
    [QGVAR(bftVehicleListUpdate), [GVARMAIN(BFTvehicles)]] call CBA_fnc_localEvent;
};

if !(GVARMAIN(UAVList) isEqualTo _uavList) then {
    GVARMAIN(UAVList) = [] + _uavList;
    [QGVAR(uavListUpdate), GVARMAIN(UAVList)] call CBA_fnc_localEvent;
};

if !(GVARMAIN(hCamList) isEqualTo _hCamList) then {
    GVARMAIN(hCamList) = [] + _hCamList;
    [QGVAR(helmetCamListUpdate), GVARMAIN(hCamList)] call CBA_fnc_localEvent;
};

true
