#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_updateLists
    Author(s):
        Gundy, Riouken, Cat Harsis

    Description:
        Update lists of cTab units and vehicles
        Lists updated:
            GVARMAIN(BFTMembers)
            GVARMAIN(BFTGroups)
            GVARMAIN(BFTvehicles)
            GVARMAIN(UAVVideoSources)
            GVARMAIN(hCamVideoSources)
        Format
            Index 0: Unit object/group
            Index 1: group leader (only for groups list)
    Parameters:
        NONE
    Returns:
        nothing
    Example:
        call Ctab_ui_fnc_updateLists;
*/

private _validSides = call FUNC(getPlayerSides);

/*
GVARMAIN(BFTMembers) --- GROUP MEMBERS
*/
private _bftMembers = (units Ctab_player) select {
    (_x != Ctab_player) &&
    { [_x, [QITEM_TABLET, QITEM_ANDROID, QITEM_MICRODAGR]] call FUNC(checkGear) }
};

if !(GVARMAIN(BFTMembers) isEqualTo _bftMembers) then {
    GVARMAIN(BFTMembers) = +_bftMembers;
    [QGVAR(bftMemberListUpdate), [GVARMAIN(BFTMembers)]] call CBA_fnc_localEvent;
};

/*
GVARMAIN(BFTGroups) --- GROUPS
Groups on our side that player is not a member of. Use the leader for positioning if he has a Tablet or Android.
Else, search through the group and use the first member we find equipped with a Tablet or Android for positioning.
*/
private _playerGroup = group Ctab_player;
private _bftGroups = []; // other groups
{
    {
        private _group = _x;
        if (_group != _playerGroup) then {
            _ctabLeader = objNull;
            if ([leader _group,[QITEM_TABLET, QITEM_ANDROID]] call FUNC(checkGear)) then {
                _ctabLeader = leader _group;
            } else {
                {
                    private _unit = _x;
                    if ([_unit,[QITEM_TABLET, QITEM_ANDROID]] call FUNC(checkGear)) then {
                        _ctabLeader = _unit;
                    };
                } foreach units _group;
            };
            if !(IsNull _ctabLeader) then {
                _bftGroups pushBack [_group, _ctabLeader];
            };
        };
    } foreach (groups _x);
} foreach _validSides;

if !(GVARMAIN(BFTGroups) isEqualTo _bftGroups) then {
    GVARMAIN(BFTGroups) = +_bftGroups;
    [QGVAR(bftGroupListUpdate), [GVARMAIN(BFTGroups)]] call CBA_fnc_localEvent;
};

/*
GVARMAIN(BFTvehicles) --- VEHICLES
Vehciles on our side, that are not empty and that player is not sitting in.
*/
private _playerVehicle = vehicle Ctab_player;
private _bftVehicles = vehicles select {
    count (crew _x) > 0 &&
    {side _x in _validSides} &&
    {_x != _playerVehicle} 
};

if !(GVARMAIN(BFTvehicles) isEqualTo _bftVehicles) then {
    GVARMAIN(BFTvehicles) = +_bftVehicles;
    [QGVAR(bftVehicleListUpdate), [GVARMAIN(BFTvehicles)]] call CBA_fnc_localEvent;
};
