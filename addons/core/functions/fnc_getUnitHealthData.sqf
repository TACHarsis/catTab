#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineCommonColors.inc"

params ["_unit"];

private _fnc_getHealthDataVanilla = {
    params ["_unit", "_currentDamage"];

    
    // no alpha value on color hints cause we interpolate with a vector function later
    private _damageToBPMArray = [
    //  [damage,    heartbeat,  color hint,     string hint]
        [1,         0,          [0,0,0,1],      "Dead"],
        [0.95,      50,         [1,0,0,1],      "Dying"],
        [0.7,       140,        [1,0.5,0,1],    "Severly Wounded"],
        [0.4,       140,        [1,0.5,0,1],    "Wounded"],
        [0.1,       100,        [1,1,0,1],      "Lightly Wounded"],
        [0,         90,         [0,1,0,1],      "Healthy"]
    ];
    private _maxBPMIdx = count _damageToBPMArray -1;

    private ["_currentBPM", "_colorHint", "_stringHint"];
    switch (_currentDamage) do {
        case (0) : {
            private _bracket = _damageToBPMArray # _maxBPMIdx;
            _currentBPM = _bracket # 1;
            _colorHint = _bracket # 2;
            _stringHint = _bracket # 3;
        };
        case (1) : {
            private _bracket = _damageToBPMArray # 0;
            _currentBPM = _bracket # 1;
            _colorHint = _bracket # 2;
            _stringHint = _bracket # 3;
        };
        default {
            // first entry of return array is highest damage smaller than or equal to current damage value (upper health/lower damage boundary)
            private _lowerDamageBoundary = (_damageToBPMArray select { (_x # 0) <= _currentDamage } ) # 0;
            _colorHint = _lowerDamageBoundary # 1;
            _stringHint = _lowerDamageBoundary # 3;
            // last entry of return array is smallest damage higher than or equal to current damage value (lower health/upper damage boundary)
            private _upperDamageBoundary = (_damageToBPMArray select { (_x # 0) >= _currentDamage } ) # -1;
            private _diffBoundaries = (_upperDamageBoundary # 0) - (_lowerDamageBoundary # 0);
            private _diffUpperToCurrent = (_upperDamageBoundary # 0) - _currentDamage;
            private _damageDelta = if(_diffToUpperCurrent != 0) then { damageDiff / _diffUpperToCurrent } else { 0 };

            _currentBPM = [_upperDamageBoundary # 1, _lowerDamageBoundary # 1, _damageDelta, 1] call BIS_fnc_interpolateConstant;
            _colorHint = [_upperDamageBoundary # 3, _lowerDamageBoundary # 3, _damageDelta, 1] call BIS_fnc_interpolateVectorConstant;
        };
    };

    [_currentBPM, _colorHint, _stringHint]
};

#define DEFAULT_BLOOD_VOLUME 6.0 // in liters
#define BLOOD_VOLUME_CLASS_1_HEMORRHAGE 6.000 // lost less than 15% blood, Class I Hemorrhage
#define BLOOD_VOLUME_CLASS_2_HEMORRHAGE 5.100 // lost more than 15% blood, Class II Hemorrhage
#define BLOOD_VOLUME_CLASS_3_HEMORRHAGE 4.200 // lost more than 30% blood, Class III Hemorrhage
#define BLOOD_VOLUME_CLASS_4_HEMORRHAGE 3.600 // lost more than 40% blood, Class IV Hemorrhage
#define BLOOD_VOLUME_FATAL 3.0 // Lost more than 50% blood, Unrecoverable

private _fnc_getHealthDataACE = {
    params ["_unit", "_currentDamage"];

    private _bloodPressure = _unit getVariable ["ace_medical_bloodPressure", [80, 120]];
    private _heartRate = _unit getVariable ["ace_medical_heartRate", 80];
    private _bloodVolume = _unit getVariable ["ace_medical_bloodVolume", DEFAULT_BLOOD_VOLUME];

    // no alpha value on color hints cause we interpolate with a vector function later
    private _bloodVolumeToBPMArray = [
        //[blood level,                     color hint]
        [BLOOD_VOLUME_FATAL,                [0.25, 0 , 0]],
        [BLOOD_VOLUME_CLASS_4_HEMORRHAGE,   [1, 0.5, 0]],
        [BLOOD_VOLUME_CLASS_3_HEMORRHAGE,   [1, 0.5, 0]],
        [BLOOD_VOLUME_CLASS_2_HEMORRHAGE,   [1, 1, 0]],
        [BLOOD_VOLUME_CLASS_1_HEMORRHAGE,   [0.1, 0.90, 0]],
        [DEFAULT_BLOOD_VOLUME,              [0, 1, 0]]
    ];
    private _maxBloodVolumeIdx = count _bloodVolumeToBPMArray - 1;

    private _colorHint = [1, 1, 1, 1];
    if(!alive _unit) then {
        _colorHint = [0, 0, 0, 1];
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
                // last entry in return array is highest blood volume smaller than or equal to current blood volume (lower blood volume boundary)
                private _lowerBloodVolumeBoundary = (_bloodVolumeToBPMArray select { (_x # 0) <= _bloodVolume } ) # -1;
                // first entry in return array is lowest blood volume larger than or equal to current blood volume (upper blood volume boundary)
                private _upperBloodVolumeBoundary = (_bloodVolumeToBPMArray select { (_x # 0) >= _bloodVolume } ) # 0;
                private _diffBoundaries = ((_upperBloodVolumeBoundary # 0) - (_lowerBloodVolumeBoundary # 0));
                private _diffLowerToCurrent = _bloodVolume - (_lowerBloodVolumeBoundary # 0);
                private _bloodVolumeDelta = if(_diffLowerToCurrent != 0) then { _diffBoundaries / _diffLowerToCurrent };
                //diag_log format ["Lower: %1 vs Upper: %2 for %3", _lowerBloodVolumeBoundary, _upperBloodVolumeBoundary, _bloodVolume];
                _colorHint = [_lowerBloodVolumeBoundary # 1, _upperBloodVolumeBoundary # 1, _bloodVolumeDelta, 1] call BIS_fnc_interpolateVectorConstant;
                //diag_log format ["Interpolated colorHint: %1", _colorHint];
            };
        };
        _colorHint pushBack 1; // add alpha value
    };
    private _stringHint = format["HR %1 | BP %2/%3", _heartRate, _bloodPressure # 0, _bloodPressure # 1];
    //private _stringHint = format["HR %1 | BP %2/%3 [%4](%5){%6}", _heartRate, _bloodPressure # 0, _bloodPressure # 1, _bloodVolume, _colorHint, _currentDamage];
    [_heartRate, _colorHint, _stringHint]
};

private _currentDamage = damage _unit;
//"HEALTHY" (0), "DEAD" (1), "DEAD-RESPAWN"(?), "DEAD-SWITCHING"(?), "INCAPACITATED"(?), "INJURED" (>0.1)
private _lifeState = lifeState _unit;
//"UNCONSCIOUS", "MOVING", "SHOOTING"
private _incapState = incapacitatedState _unit;
private _conscious = !(_lifeState in ["DEAD", "DEAD-RESPAWN", "DEAD-SWITCHING", "INCAPACITATED"]);
private _healthData = [alive _unit, _conscious, 1 - _currentDamage];

if(IS_MOD_LOADED(ace_medical)) then { // yay! Cool ace stuff!
    _healthData append ([_unit, _currentDamage] call _fnc_getHealthDataACE);
} else { // boring vanilla stuff
    _healthData append ([_unit, _currentDamage] call _fnc_getHealthDataVanilla);
};

_healthData
