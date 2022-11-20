#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_drawBftMarkers
     
     Author(s):
        Gundy, Riouken, Cat Harsis

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
        1: INTEGER - Mode, 0 = draw normal, 1 = draw for TAD, 2 = draw for MicroDAGR
     
     Returns:
        Nothing
     
     Example:
        [_ctrlScreen,0] call Ctab_ui_fnc_drawBftMarkers;
*/
params ["_ctrlScreen","_displayName", "_bftOptions"];
//CC: This is very awkward code. The mode switches the drawing of Vehicles and Groups for different devices

// record of vehicles we have drawn this frame
private _processedVehicles = [];

private _playerVehicle = vehicle Ctab_player;
private _playerGroup = group Ctab_player;
private _selectedUAV = objNull;

private _mountedLabelHash = createHashMap;

private _displayOptions = [_displayName] call FUNC(getSettings);
private _drawText = _displayOptions getOrDefault [QSETTING_SHOW_ICON_TEXT,false];
private _displayEnvironmentType = _displayOptions getOrDefault [QSETTING_DEVICE_ENVIRONMENT,QDEVICE_GROUND];

if(DMC_BFT_UAV in _bftOptions) then {
    _selectedUAV = GVAR(currentUAV);

    private _selectedUAVPos = if(isNull _selectedUAV) then {[0,0,0]} else {getPosASL _selectedUAV};
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
};

if(DMC_BFT_VEHICLES in _bftOptions) then {
    // ------------------ VEHICLES* ------------------
    //                          * that the player is not sitting in
    {
        _x params ["_vehicle","_type","_name","_unitIcon"];

        private _text = if (_drawText) then {_name} else {""};
        private _pos = getPosASL _vehicle;
        private _vehicleGroup = group _vehicle;

        private _isSelectedUAV = _selectedUAV isEqualTo _vehicle;
        private _isPlayerVehicle = _vehicle isEqualTo _playerVehicle;
        private _isAirType = _type isEqualTo "Air";
        private _isInPlayerGroup = _vehicleGroup isEqualTo _playerGroup;
        private _displayIsAirDevice = _displayEnvironmentType isEqualTo QDEVICE_AIR;
        private _drawAsWings = _displayIsAirDevice && _isAirType; // Drawing on TAD && vehicle is an air contact

        _processedVehicles pushBack _vehicle;

        if(_isPlayerVehicle && _isInPlayerGroup) then {continue};
        if(!_drawAsWings && _isPlayerVehicle) then {continue}; 


        if(_isPlayerVehicle) then { // draw the player vehicle
            _ctrlScreen drawIcon [
                "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                GVAR(colorBLUFOR),
                _pos,
                GVAR(iconSize),GVAR(iconSize),
                0,_text,0,GVAR(textSize),"TahomaB","right"
            ];

            continue
        };

        private _icon = [
            _unitIcon,
            QPATHTOEF(data,img\map\markers\icon_air_contact_ca.paa)
        ] select _drawAsWings;

        private _iconSize = [
            GVAR(iconSize),
            GVAR(airContactSize)
        ] select _drawAsWings;

        private _angle = [
            0,
            direction _vehicle
        ] select _drawAsWings;

        private _iconColor = if(_drawAsWings) then { 
            [
                GVAR(TADOwnSideColor),
                GVAR(airContactColor)
            ] select _isInPlayerGroup
        } else {
            [
                GVAR(colorBLUFOR), 
                GVAR(selectedUAVColor)
            ] select (_isSelectedUAV)
        };

        _ctrlScreen drawIcon [
            _icon,
            _iconColor,
            _pos,
            _iconSize,_iconSize,
            _angle,"",0,GVAR(textSize),"TahomaB","right"
        ];

        if !(_drawAsWings) then { continue };
        if !(_isInPlayerGroup || _drawText) then { continue };

        if (_isInPlayerGroup) then {
            // air contact is in our group
            _ctrlScreen drawIcon [
                "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                GVAR(airContactColor),
                _pos,
                0,0,
                0,_groudIdx,0,GVAR(airContactGroupTxtSize) * 0.8,"TahomaB","center"];
        } else {
            // air contact is _not_ in our group
            _ctrlScreen drawIcon [
                "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                GVAR(TADOwnSideColor),
                _pos,
                GVAR(airContactDummySize),GVAR(airContactDummySize),
                0,_text,0,GVAR(textSize),"TahomaB","right"
            ];
        };
    } foreach GVAR(bftVehicleIcons);

    // catch vehicles that our group members are sitting in, too
    if(_drawText) then {
        {
            _x params ["_unit", "_icon", "_unknown", "_name", "_groupId"];
            //CC: name is never used
            private _unitVehicle = vehicle (_unit);
            private _unitGroup = group (_unit);
            private _playerGroup = group Ctab_player;
            private _isPlayerVehicle = _unitVehicle == _playerVehicle;
            
            if !(_drawText) then { continue };

            if (_isPlayerVehicle || {_unitVehicle in _processedVehicles}) then {
                // we want to draw text on anything but MicroDAGR and the unit sits in a vehicle that has already been drawn or in player vehicle that doesn't get drawn
                private _mountedLabel = _mountedLabelHash getOrDefault [_unitVehicle, ""];
                _mountedLabelHash set [
                            _unitVehicle, 
                            [_groupId,format ["%1/%2",_mountedLabel, _groupId]] select (_mountedLabel isEqualTo "")
                        ];
                
                continue
            };
        } foreach GVAR(bftMemberIcons);
    };
};

if(DMC_BFT_GROUPS in _bftOptions) then {
    // ------------------ GROUPS ------------------
    {
        _x params ["_group", "_ctabLeader", "_icon","_sizeIcon"];
        // _ctabLeader may not be leader of group but first non-leader unit with ctab device
        private _groupId = groupId _group;
        private _ctabLeaderVehicle = vehicle (_ctabLeader);
        
        if(_ctabLeaderVehicle isNotEqualTo _ctabLeader) then { // ctabLeader is in a vehicle
            if !(_drawText) exitWith {};

            //CC: This does not draw the ctab leader if they're in a vehicle that is not of our side. Maybe that's a base to cover? 

            // Only do this if the vehicle has not been drawn yet, or the player is sitting in the same vehicle as the ctab leader
            private _isPlayerVehicle = _ctabLeaderVehicle == _playerVehicle;
            
            // See if the ctab leader's vehicle is in the list of drawn vehicles
            private _vehicleWasDrawnBefore = _ctabLeaderVehicle in _processedVehicles;

            if (_isPlayerVehicle || // either is player vehicle (and has not been drawn before) or ctab leader sits in vehicle of other group
                (_vehicleWasDrawnBefore && {(groupID group _ctabLeaderVehicle) != _groupId})) then {
                    
                // group name is not the same as that of the vehicle the ctab leader is sitting in
                private _mountedLabel = _mountedLabelHash getOrDefault [_ctabLeaderVehicle, ""];
                _mountedLabelHash set [
                    _ctabLeaderVehicle, 
                    [_groupId,format ["%1/%2",_mountedLabel, _groupId]] select (_mountedLabel isEqualTo "")
                ];
            };
        } else {
            private _text = ["", _groupId] select _drawText;
            private _pos = getPosASL _ctabLeaderVehicle;
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


if(DMC_BFT_MEMBERS in _bftOptions) then {
    // ------------------ MEMBERS* ------------------
    //                          * of player group
    {
        _x params ["_unit", "_icon", "_unknown", "_name", "_groupId"];
        //CC: name is never used
        private _unitVehicle = vehicle (_unit);
        private _isPlayerVehicle = _unitVehicle == _playerVehicle;
        
        // get the fire-team color
        private _teamColor = GVAR(teamColors) select (["MAIN","RED","GREEN","BLUE","YELLOW"] find (assignedTeam (_unit)));

        if (_unit isNotEqualTo _unitVehicle) then {
            // the unit _does_ sit in a vehicle
            private _mountedLabel = _mountedLabelHash getOrDefault [_unitVehicle, ""];
            private _hasMountedLabel = _mountedLabel isNotEqualTo "";

            if(_drawText) then { // if text enabled we set/add to mounted Label
                _mountedLabelHash set [_unitVehicle, [format["%1/%2", _mountedLabel,_groupId], _groupId] select _hasMountedLabel];
            } else {
                if(_hasMountedLabel) then { // no text, but still register vehicle?
                    _mountedLabelHash set [_unitVehicle, ""];
                } else { // no drawing text, nor mounting label exists, implying it's already drawn

                    if (!_isPlayerVehicle) then {
                        _ctrlScreen drawIcon [
                            "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
                            GVAR(colorBLUFOR),
                            getPosASL _unitVehicle,
                            GVAR(iconSize),GVAR(iconSize),
                            direction _unitVehicle,"",0,GVAR(textSize),"TahomaB","right"
                        ];
                    };
                };
            };
        } else { // does not sit in a vehicle 
            private _pos = getPosASL _unitVehicle;
            _ctrlScreen drawIcon [
                _icon,
                _teamColor,
                _pos,
                GVAR(manSize),GVAR(manSize),
                direction _unitVehicle,"",0,GVAR(textSize),"TahomaB","right"
            ];
            if (_drawText) then {
                _ctrlScreen drawIcon [
                    "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                    _teamColor,
                    _pos,
                    GVAR(manSize),GVAR(manSize),
                    0,_groupId,0,GVAR(textSize),"TahomaB","right"
                ];
            };
        };
    } foreach GVAR(bftMemberIcons);
};


// ------------------ DRAW LABELs ON VEHICLES WITH MOUNTED GROUPS / MEMBERS ------------------
if (_drawText && (_mountedLabelHash isNotEqualTo createHashMap)) then {
    for "_i" from 0 to (count _mountedLabelHash - 2) step 2 do {
        private _vehicle = _mountedLabelHash select _i;
        if (_vehicle != _playerVehicle) then {
            _ctrlScreen drawIcon [
                "\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
                GVAR(colorBLUFOR),
                getPosASL _vehicle,
                GVAR(iconSize),GVAR(iconSize),
                0,_mountedLabelHash select (_i + 1),0,GVAR(textSize),"TahomaB","left"
            ];
        };
    };
};
