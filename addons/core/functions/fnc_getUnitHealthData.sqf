#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineCommonColors.inc"

params ["_unit"];

//TODO: Tripple check that the code to select the color actually does what it should

private _fnc_getHealthDataVanilla = {
    params ["_unit"];

    private _damageToBPMArray = [
        [1, 0, "Dead", [0,0,0,1]],
        [0.95, 50, "Dying", [1,0,0,1]],
        [0.7, 140, "Severly Wounded", [1,0.5,0,1]],
        [0.4, 140, "Wounded", [1,0.5,0,1]],
        [0.1, 100, "Lightly Wounded",[1,1,0,1]],
        [0, 90, "Healthy", [0,1,0,1]]
    ];
    private _maxBPMIdx = count _damageToBPMArray -1;

    private _damage = damage _unit;
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
            private _lowerBound = (_damageToBPMArray select { (_x # 0) <= _damage } ) # 0;
            _currentBPM = _lowerBound # 1;
            _stringHint = _lowerBound # 2;
            _colorHint = _lowerBound # 3;
            private _upperBound = (_damageToBPMArray select { (_x # 0) >= _damage } ) # 0;

            _currentBPM = [_lowerBound # 1, _upperBound # 1, _damage, 1] call BIS_fnc_interpolateConstant;
        };
    };

    [_currentBPM, _stringHint, _colorHint]
};

#define DEFAULT_BLOOD_VOLUME 6.0 // in liters
#define BLOOD_VOLUME_CLASS_1_HEMORRHAGE 6.000 // lost less than 15% blood, Class I Hemorrhage
#define BLOOD_VOLUME_CLASS_2_HEMORRHAGE 5.100 // lost more than 15% blood, Class II Hemorrhage
#define BLOOD_VOLUME_CLASS_3_HEMORRHAGE 4.200 // lost more than 30% blood, Class III Hemorrhage
#define BLOOD_VOLUME_CLASS_4_HEMORRHAGE 3.600 // lost more than 40% blood, Class IV Hemorrhage
#define BLOOD_VOLUME_FATAL 3.0 // Lost more than 50% blood, Unrecoverable

private _fnc_getHealthDataACE = {
    params ["_unit"];

    private _bloodPressure = _unit getVariable ["ace_medical_bloodPressure", [80, 120]];
    private _heartRate = _unit getVariable ["ace_medical_heartRate", 80];
    private _bloodVolume = _unit getVariable ["ace_medical_bloodVolume", DEFAULT_BLOOD_VOLUME];

    private _bloodVolumeToBPMArray = [
        [BLOOD_VOLUME_FATAL, [0.25, 0 , 0]],
        [BLOOD_VOLUME_CLASS_4_HEMORRHAGE, [1, 0.5, 0]],
        [BLOOD_VOLUME_CLASS_3_HEMORRHAGE, [1, 0.5, 0]],
        [BLOOD_VOLUME_CLASS_2_HEMORRHAGE, [1, 1, 0]],
        [BLOOD_VOLUME_CLASS_1_HEMORRHAGE, [0.1, 0.90, 0]],
        [DEFAULT_BLOOD_VOLUME, [0, 1, 0]]
    ];
    private _maxBloodVolumeIdx = count _bloodVolumeToBPMArray - 1;

    private _colorHint = [1, 1, 1];
    if(!alive _unit) then {
        _colorHint = [0, 0, 0];
    } else {
        switch (true) do {
            case (_bloodVolume >= DEFAULT_BLOOD_VOLUME) : {
                private _bracket = _bloodVolumeToBPMArray # _maxBloodVolumeIdx;
                _colorHint = _bracket # 1;
            };
            case (_bloodVolume <= BLOOD_VOLUME_FATAL) : {
                private _bracket = _bloodVolumeToBPMArray # 0;
                _colorHint = _bracket # 1;
            };
            default {
                private _lowerBound = (_bloodVolumeToBPMArray select { (_x # 0) <= _bloodVolume } ) # 0;
                // _colorHint = _lowerBound # 1;
                private _upperBound = (_bloodVolumeToBPMArray select { (_x # 0) >= _bloodVolume } ) # 0;
                private _range = ((_upperBound # 0) - (_lowerBound # 0));
                //diag_log format ["Lower: %1 vs Upper: %2 for %3", _lowerBound, _upperBound, _bloodVolume];
                private _delta = if(_range == 0) then {
                    0
                } else {
                    _range / (_bloodVolume - (_lowerBound # 0))
                };

                _colorHint = [_lowerBound # 1, _upperBound # 1, _delta, 1] call BIS_fnc_interpolateVectorConstant;
                //diag_log format ["Interpolated colorHint: %1", _colorHint];
            };
        };
    };
    _colorHint pushBack 1;
    [_heartRate, format["HR %1 | BP %2/%3", _heartRate, _bloodPressure # 0, _bloodPressure # 1], _colorHint]
};

private _damage = damage _unit;
//"HEALTHY" (0), "DEAD" (1), "DEAD-RESPAWN"(?), "DEAD-SWITCHING"(?), "INCAPACITATED"(?), "INJURED" (>0.1)
private _lifeState = lifeState _unit;
//"UNCONSCIOUS", "MOVING", "SHOOTING"
private _incapState = incapacitatedState _unit;

private _conscious = !(_lifeState in ["DEAD", "DEAD-RESPAWN", "DEAD-SWITCHING", "INCAPACITATED"] );

private _healtData = [alive _unit, _conscious, 1-_damage];

if(IS_MOD_LOADED(ace_medical)) then { // yay! Cool ace stuff!
    _healtData append ([_unit] call _fnc_getHealthDataACE);
} else { // boring vanilla stuff
    _healtData append ([_unit] call _fnc_getHealthDataVanilla);
};

_healtData
