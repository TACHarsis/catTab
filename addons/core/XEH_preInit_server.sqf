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
    GVARMAIN(vehicleClassesFBCB2_server) = ["MRAP_01_base_F", "MRAP_02_base_F", "MRAP_03_base_F", "Wheeled_APC_F", "Tank", "Truck_01_base_F", "Truck_03_base_F"];
};
publicVariable QGVARMAIN(vehicleClassesFBCB2_server);

// define vehicles that have TAD  and broadcast it
if (isArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(vehicleClassesTAD))) then {
    GVARMAIN(vehicleClassesTAD_server) = getArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(vehicleClassesTAD));
} else {
    GVARMAIN(vehicleClassesTAD_server) = ["Helicopter", "Plane"];
};
publicVariable QGVARMAIN(vehicleClassesTAD_server);

// define items that have a helmet camera and broadcast it
if (isArray (ConfigFile >> QGVARMAIN(settings) >> QGVARMAIN(helmetClasses))) then {
    GVARMAIN(helmetClasses_server) = getArray (ConfigFile >> QGVARMAIN(settings) >> QGVAR(helmetClasses));
} else {
    GVARMAIN(helmetClasses_server) = ["H_HelmetB_light", "H_Helmet_Kerry", "H_HelmetSpecB", "H_HelmetO_ocamo", "BWA3_OpsCore_Fleck_Camera", "BWA3_OpsCore_Schwarz_Camera", "BWA3_OpsCore_Tropen_Camera"];
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

private _fnc_setOriginalSide = {
    params ["_unit"];
    [
        {
            params ["_unit"];
            _unit setVariable [QGVAR(originalSide), side _unit];
            _unit setVariable [QGVAR(currentSide), side _unit];
        },
        [_unit]
    ] call CBA_fnc_execNextFrame;
};

["CAManBase", "init", _fnc_setOriginalSide, true, [], true] call CBA_fnc_addClassEventHandler;
["UAV", "init", _fnc_setOriginalSide, true, [], true] call CBA_fnc_addClassEventHandler;

addMissionEventHandler ["GroupCreated", {
    params ["_group"];
    _group addEventHandler ["UnitJoined", {
        if(!local _group) exitWith {};

        params ["_group", "_unit"];
        private _sideGroup = side _group;
        private _sideUnit = side _unit;
        if(_sideGroup isEqualTo _sideUnit) then {
            _unit setVariable [QGVAR(originalGroup), _group];
        } else {
            // are we captive?
        };
    }];
    _group addEventHandler ["UnitLeft", {
        if(!local _group) exitWith {};

        params ["_group", "_unit"];
        if(!alive _unit) then {
            private _canonicalGroup = _unit getVariable [QGVAR(originalGroup), grpNull];
        };
    }];
}];

addMissionEventHandler ["GroupDeleted", {
    params ["_group"];
    if(!local _group) exitWith {};
}];

//TODO: Use this in Arma 2.16
// addMissionEventHandler ["EntityDeleted", {
//     params ["_entity"];
//     private _unitNetID = _entity call BIS_fnc_netId;
//     {
//         private _type = _x;
//         private _sourcesHash = _y;
//         if(_unitNedID in _sourcesHash) exitWith 
//         {
//             [_type] call FUNC(updateVideoSourceList);
//         } foreach _sourcesHash;
//     } foreach GVAR(videoSourcesContext);
// }];

addMissionEventHandler ["EntityKilled", {
    if(!local _group) exitWith {};
    params ["_unit", "_killer", "_instigator", "_useEffects"];
    private _unitNetID = _unit call BIS_fnc_netId;
}];
[
    {
        private _changedSides = (allUnits + allDeadMen) select {
            private _unit = _x;
            private _unitSide = side _unit;
            private _currentSide = _unit getVariable [QGVAR(currentSide), sideUnknown];
            private _canonicalSide = _unit getVariable [QGVAR(originalSide), _unitSide];
            //TODO: when all runs well, collapse this
            if(_unitSide isNotEqualTo _currentSide) then {
                LOG_3("[SERVER] unit (%1) changed sides from (%2) to (%3)",_unit,_currentSide,_unitSide);
                if(_currentSide isNotEqualTo civilian) then { // we were not civilian
                    if(_unitSide isNotEqualTo civilian) then { // we switched to a different combatant side
                        LOG_3("[SERVER] unit (%1) has become %2, which is probably intentional, so we update the side (%3)",_unit,_unitSide,_canonicalSide);
                        _unit setVariable [QGVAR(originalSide), _unitSide, true];
                    } else {
                        LOG_3("[SERVER] unit (%1) has become civilian. Probably dead (%2) or uncon (%3)?",_unit,!alive _unit,lifeState _unit);
                    };
                } else { // we were civilian
                    if(_unitSide isNotEqualTo _canonicalSide) then { // we went uncon and woke up a different faction? xD
                        LOG_3("[SERVER] unit (%1), formerly %2 has become %3 while being civilian in the meantime. Weird.",_unit,_canonicalSide,_unitSide);
                    } else {
                        LOG_3("[SERVER] unit (%1) has probably woken up and has returned to original side.",_unit,_canonicalSide,_unitSide);
                    };
                };
                _unit setVariable [QGVAR(currentSide), _unitSide, true];

                true
            } else { false };
        };
    },
    1
] call CBA_fnc_addPerFrameHandler;
