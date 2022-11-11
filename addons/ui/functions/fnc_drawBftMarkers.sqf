#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_drawBftMarkers
     
     Author(s):
        Gundy, Riouken

     Description:
        Draw BFT markers
        
        List format:
            Index 0: Unit object
            Index 1: Path to icon A
            Index 2: Path to icon B (either group size or wingmen)
            Index 3: Text to display
            Index 4: String of group index

    
    Parameters:
        0: OBJECT  - Map control to draw BFT icons on
        1: INTEGER - Mode, draw normal, 1 = draw for TAD, 2 = draw for MicroDAGR
     
     Returns:
        BOOLEAN - Always TRUE
     
     Example:
        [_ctrlScreen,0] call Ctab_ui_fnc_drawBftMarkers;
*/
params ["_ctrlScreen","_mode"];
//CC: This is very awkward code. The mode switches the drawing of Vehicles and Groups for different devices

private _vehicles = [];
private _playerVehicle = vehicle Ctab_player;
private _playerGroup = group Ctab_player;
private _mountedLabels = [];

if (_mode != 2) then {
    
    private _selectedUAV = GVAR(currentUAV);
    private _selectedUAVPos = if(isNil "_selectedUAV") then {[0,0,0]} else {getPosASL _selectedUAV};
    // ------------------ UAV Sight/Lock Lines ------------------
    {
        private _uav = _x;
        private _uavPosition = getPosASL _uav;
        private _isSelectedUAV = !isNil "_selectedUAV" && {_uav isEqualTo _selectedUAV};
        private _uavLineColor = [[1,1,1,1],[1,0,0.5,1]] select (_isSelectedUAV);
        
        private _lineTargetPos = GVAR(mapCursorPos);
        private _camLockedTo = _uav lockedCameraTo [];
        private _camIsLocked = !(isNil "_camLockedTo");
        
        if (_camIsLocked) then {
            _lineTargetPos = if((typeName _camLockedTo) isEqualTo "ARRAY") then { _camLockedTo } else { [] call {getPosASL _camLockedTo} };
        };
        
        if (_isSelectedUAV || _camIsLocked) then {
            _ctrlScreen drawLine [
                _uavPosition,
                _lineTargetPos,
                _uavLineColor
            ];
        };
        
        if (_camIsLocked) then {
            _ctrlScreen drawIcon [
                "\A3\ui_f\data\GUI\Cfg\KeyFrameAnimation\IconControlPoint_ca.paa",
                _uavLineColor,
                _lineTargetPos,
                GVAR(iconSize)/2,GVAR(iconSize)/2,
                0,"",0,GVAR(textSize),"TahomaB","right"
            ];
        };
    } foreach GVARMAIN(UAVList);
    // ------------------ VEHICLES ------------------
    {
        _x params ["_vehicle","_unitIcon","_airIcon","_name","_groupID"];

        private _text = if (GVAR(textEnabled)) then {_name} else {""};
        private _pos = getPosASL _vehicle;
        private _isSelectedUAV = ! isNil QGVAR(currentUAV) && {! isNull GVAR(currentUAV)} && {GVAR(currentUAV) isEqualTo _vehicle};
        private _isPlayerVehicle = _vehicle isEqualTo _playerVehicle;
        private _hasAirContactIcon = _airIcon isNotEqualTo "";
        private _vehicleInPlayerGroup = group _vehicle isEqualTo _playerGroup;
        
        if (_mode == 1 && _hasAirContactIcon && !_isPlayerVehicle) then { // Drawing on TAD && vehicle is an air contact
            if (_groupID != "") then {
                // air contact is in our group
                _ctrlScreen drawIcon [
                    _airIcon,
                    GVAR(airContactColor),
                    _pos,
                    GVAR(airContactSize),GVAR(airContactSize),
                    direction _vehicle,"",0,GVAR(textSize),"TahomaB","right"
                ];
                _ctrlScreen drawIcon [
                    "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                    GVAR(airContactColor),
                    _pos,
                    GVAR(textSize),0, // << wtf?
                    0,_groupID,0,GVAR(airContactGroupTxtSize) * 0.8,"TahomaB","center"];
            } else {
                // air contact is _not_ in our group
                _ctrlScreen drawIcon [
                    _airIcon,
                    GVAR(TADOwnIconColor),
                    _pos,
                    GVAR(airContactSize),GVAR(airContactSize),
                    direction _vehicle,"",0,GVAR(textSize),"TahomaB","right"
                ];
                if (GVAR(textEnabled)) then {
                    _ctrlScreen drawIcon [
                        "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                        GVAR(TADOwnIconColor),
                        _pos,
                        GVAR(airContactDummySize),GVAR(airContactDummySize),
                        0,_text,0,GVAR(textSize),"TahomaB","right"
                    ];
                };
            };
        } else { // Draw on anything but TAD
            if (!_isPlayerVehicle) exitWith { // player is not sitting in this vehicle            
                _ctrlScreen drawIcon [
                    _unitIcon,
                    [GVAR(colorBLUFOR), [0,1,0,1]] select (_isSelectedUAV),
                    //GVAR(colorBLUFOR),
                    _pos,
                    GVAR(iconSize),GVAR(iconSize),
                    0,_text,0,GVAR(textSize),"TahomaB","right"
                ];
            };
            if (!_vehicleInPlayerGroup) then { // player is not in the same group as this vehicle
                _ctrlScreen drawIcon [
                    "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                    GVAR(colorBLUFOR),
                    _pos,
                    GVAR(iconSize),GVAR(iconSize),
                    0,_text,0,GVAR(textSize),"TahomaB","right"
                ];
            };
        };
        _vehicles pushBack _vehicle;
    } foreach GVAR(bftVehicleIcons);

    // ------------------ GROUPS ------------------
    {
        _x params ["_group", "_leader", "_icon","_sizeIcon", "_groupIdx", "_unknown"];
        // name is never used
        private _veh = vehicle (_leader);
        
        // See if the group leader's vehicle is in the list of drawn vehicles
        private _vehIndex = _vehicles find _veh;
        
        // Only do this if the vehicle has not been drawn yet, or the player is sitting in the same vehicle as the group leader
        if (_vehIndex != -1 || {_veh == _playerVehicle}) then {
            if (GVAR(textEnabled)) then {
                // we want to draw text and the group leader is in a vehicle that has already been drawn
                private _text = _groupIdx;
                // _vehIndex == -1 means that the player sits in the vehicle
                if (_vehIndex == -1 || {(groupID group _veh) != _text}) then {
                    // group name is not the same as that of the vehicle the leader is sitting in
                    private _mountedIndex = _mountedLabels find _veh;
                    if (_mountedIndex != -1) then {
                        private _mountedLabels set [_mountedIndex + 1,(_mountedLabels select (_mountedIndex + 1)) + "/" + (_text)];
                    } else {
                        _mountedLabels pushBack _veh;
                        _mountedLabels pushBack _text;
                    };
                };
            };
        } else {
            private _text = if (GVAR(textEnabled)) then {_groupIdx} else {""};
            private _pos = getPosASL _veh;
            
            _ctrlScreen drawIcon [
                _icon,
                GVAR(colorBLUFOR),
                _pos,GVAR(iconSize),GVAR(iconSize),
                0,_text,0,GVAR(textSize),"TahomaB","right"
            ];
            _ctrlScreen drawIcon [
                _sizeIcon,
                GVAR(colorBLUFOR),
                _pos,
                GVAR(groupOverlayIconSize),GVAR(groupOverlayIconSize),
                0,"",0,GVAR(textSize),"TahomaB","right"
            ];
        };
    } foreach GVAR(bftGroupIcons);
};

// ------------------ MEMBERS ------------------
private _mountedLabels = [];
{
    _x params ["_unit", "_icon", "_unknown", "_name", "_groupIdx"];
    // name is never used
    private _vehicle = vehicle (_unit);
    
    // make sure we are still in the same team
    if (group Ctab_player isEqualTo group (_unit)) then {
        
        // get the fire-team color
        private _teamColor = GVAR(teamColors) select (["MAIN","RED","GREEN","BLUE","YELLOW"] find (assignedTeam (_unit)));
        
        if (_mode != 2 && {_vehicle == _playerVehicle || {_vehicle in _vehicleicles}}) exitWith {
            if (GVAR(textEnabled)) then {
                // we want to draw text on anything but MicroDAGR and the unit sits in a vehicle that has already been drawn
                private _mountedIndex = _mountedLabels find _vehicle;
                if (_mountedIndex != -1) then {
                    _mountedLabels set [_mountedIndex + 1,(_mountedLabels select (_mountedIndex + 1)) + "/" + (_groupIdx)];
                } else {
                    _mountedLabels pushBack _vehicle;
                    _mountedLabels pushBack (_groupIdx /* 3 is name, 4 is group idx */);
                };
            };
        };
        if (_vehicle != (_unit)) exitWith {
            // the unit _does_ sit in a vehicle
            private _mountedIndex = _mountedLabels find _vehicle;
            if (_mountedIndex != -1 && GVAR(textEnabled)) then {
                _mountedLabels set [_mountedIndex + 1,(_mountedLabels select (_mountedIndex + 1)) + "/" + (_groupIdx /* 3 is name, 4 is group idx */)];
            } else {
                _mountedLabels pushBack _vehicle;
                if  (GVAR(textEnabled)) then {
                    _mountedLabels pushBack (_groupIdx /* 3 is name, 4 is group idx */);
                };
                if (_isPlayerVehicle) then {
                    _ctrlScreen drawIcon [
                        "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
                        GVAR(colorBLUFOR),
                        getPosASL _vehicle,
                        GVAR(iconSize),GVAR(iconSize),
                        direction _vehicle,"",0,GVAR(textSize),"TahomaB","right"
                    ];
                };
            };
        };
        private _pos = getPosASL _vehicle;
        _ctrlScreen drawIcon [
            _icon,
            _teamColor,
            _pos,
            GVAR(manSize),GVAR(manSize),
            direction _vehicle,"",0,GVAR(textSize),"TahomaB","right"
        ];
        if (GVAR(textEnabled)) then {
            _ctrlScreen drawIcon [
                "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                _teamColor,
                _pos,
                GVAR(manSize),GVAR(manSize),
                0,_groupIdx,0,GVAR(textSize),"TahomaB","right"
            ];
        };
    };
} foreach GVAR(bftMemberIcons);

// ------------------ ADD LABEL TO VEHICLES WITH MOUNTED GROUPS / MEMBERS ------------------
if (GVAR(textEnabled) && !(_mountedLabels isEqualTo [])) then {
    for "_i" from 0 to (count _mountedLabels - 2) step 2 do {
        private _veh = _mountedLabels select _i;
        if (_veh != _playerVehicle) then {
            _ctrlScreen drawIcon [
                "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                GVAR(colorBLUFOR),
                getPosASL _veh,
                GVAR(iconSize),GVAR(iconSize),
                0,_mountedLabels select (_i + 1),0,GVAR(textSize),"TahomaB","left"
            ];
        };
    };
};

true
