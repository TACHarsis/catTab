#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineCommonColors.inc"

private _fnc_getHealthDataVanilla = {
    params ["_unit"];

    private _damage = damage _unit;
    //"HEALTHY" (0), "DEAD" (1), "DEAD-RESPAWN"(?), "DEAD-SWITCHING"(?), "INCAPACITATED"(?), "INJURED" (>0.1)
    private _lifeState = lifeState _unit;
    //"UNCONSCIOUS", "MOVING", "SHOOTING"
    private _incapState = incapacitatedState _unit;

    private _conscious = !(_lifeState in ["DEAD", "DEAD-RESPAWN", "DEAD-SWITCHING", "INCAPACITATED"] );
    private _alive = _damage < 1;

    private _damageToBPMArray = [
        [1, 0, "Dead", [0,0,0,1]],
        [0.95, 50, "Dying", [1,0,0,1]],
        [0.7, 140, "Severly Wounded", [1,0.5,0,1]],
        [0.4, 140, "Wounded", [1,0.5,0,1]],
        [0.1, 100, "Lightly Wounded",[1,1,0,1]],
        [0, 90, "Healthy", [0,1,0,1]]
    ];
    private _maxBPMIdx = count _damageToBPMArray -1;

    private ["_currentBPM", "_stringHint", "_colorHint"];
    switch (_damage) do {
        case (0) : {
            private _bracket = _damageToBPMArray # _maxBPMIdx;
            _currentBPM = _bracket # 1;
            _stringHint = _bracket # 2;
            _colorHint = _bracket # 3;
        };
        case (1) : {
            private _bracket = _damageToBPMArray # 0;
            _currentBPM = _bracket # 1;
            _stringHint = _bracket # 2;
            _colorHint = _bracket # 3;
        };
        default {
            private _lowerBound = (_damageToBPMArray select { _x # 0 <= _damage } ) # 0;
            _currentBPM = _lowerBound # 1;
            _stringHint = _lowerBound # 2;
            _colorHint = _lowerBound # 3;
            private _upperBound = (_damageToBPMArray select { _x # 0 >= _damage } ) # 0;

            _currentBPM = [_lowerBound # 1, _upperBound # 1, _damage, 1] call BIS_fnc_interpolateConstant;
        };
    };

    [_alive, _conscious, 1-_damage, _currentBPM, _stringHint, _colorHint]
};

private _fnc_getHealthDataACE = {
    throw "NOTIMPLEMENTED";
};

params ["_unit"];

if(IS_MOD_LOADED(ace_medical)) then { // yay! Cool ace stuff!
    [_unit] call _fnc_getHealthDataVanilla // SIKE!
} else { // boring vanilla stuff
    [_unit] call _fnc_getHealthDataVanilla
};
