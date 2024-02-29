#include "script_component.hpp"
ADDON = false;
PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;
ADDON = true;
// Slot IDs
// #define GOGGLES          603
#define HEADGEAR         605
// #define MAP              608
// #define COMPASS          609
// #define WATCH            610
// #define RADIO            611
// #define GPS              612
// #define HMD              616
// #define BINOCULARS       617
// #define VEST             701
// #define UNIFORM          801
// #define BACKPACK         901
private _fnc_slotItemChanged = {
    params ["_unit", "_item", "_slot", "_assigned"];
    if(!local _group) exitWith {};
    private _wasEnabled = _unit getVariable [QGVAR(cameraHelmet), false];
    private _isEnabled = false;
    if(_slot isEqualTo HEADGEAR) then {
        private _camera = getNumber (configfile >> "CfgWeapons" >> _item >> "CTAB_Camera");
        _isEnabled = (_camera isNotEqualTo 0) || {_item in GVARMAIN(helmetClasses)};
        LOG_4("SLOTITEM CHANGED on %1: %2 > %3 [%4]",_unit,_slot,_item,_assigned);
        LOG_1("Set to enabled: %1",_isEnabled);
        _unit setVariable [QGVAR(cameraHelmet), _isEnabled, true];
        if(hasInterface) then {
            private _unitNetID = _unit call BIS_fnc_netId;
            [VIDEO_FEED_TYPE_HCAM, _unitNetID] call FUNC(updateVideoSource);
        }
    };
};
["CAManBase", "SlotItemChanged", _fnc_slotItemChanged, true, [], true] call CBA_fnc_addClassEventHandler;
