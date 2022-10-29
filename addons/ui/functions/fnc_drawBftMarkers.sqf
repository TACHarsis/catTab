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
private _drawText = GVAR(BFTtxt);


if (_mode != 2) then {
	// ------------------ VEHICLES ------------------
	{
		private _veh = _x select 0;
		private _iconB = _x select 2;
		private _text = if (_drawText) then {_x select 3} else {""};
		private _groupID = _x select 4 /* 3 is name, 4 is group idx */;
		private _pos = getPosASL _veh;
		
		if (_mode == 1 && {_iconB != "" && {_veh != _playerVehicle}}) then { // Drawing on TAD && vehicle is an air contact
			if (_groupID != "") then {
				// air contact is in our group
				_ctrlScreen drawIcon [_iconB,GVAR(airContactColor),_pos,GVAR(airContactSize),GVAR(airContactSize),direction _veh,"",0,GVAR(txtSize),"TahomaB","right"];
				_ctrlScreen drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",GVAR(airContactColor),_pos,0,0,0,_groupID,0,GVAR(airContactGroupTxtSize) * 0.8,"TahomaB","center"];
			} else {
			// air contact is _not_ in our group
			_ctrlScreen drawIcon [_iconB,GVAR(TADOwnIconColor),_pos,GVAR(airContactSize),GVAR(airContactSize),direction _veh,"",0,GVAR(txtSize),"TahomaB","right"];
			if (_drawText) then {
				_ctrlScreen drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",GVAR(TADOwnIconColor),_pos,GVAR(airContactDummySize),GVAR(airContactDummySize),0,_text,0,GVAR(txtSize),"TahomaB","right"];
			};
			};
		} else { // Draw on anything but TAD
			if (_veh != _playerVehicle) exitWith { // player is not sitting in this vehicle			
				_ctrlScreen drawIcon [
					_x select 1,
					GVAR(colorBlue),
					_pos,
					GVAR(iconSize),GVAR(iconSize),
					0,_text,0,GVAR(txtSize),"TahomaB","right"
				];
			};
			if (group _veh != _playerGroup) then { // player is not in the same group as this vehicle
				_ctrlScreen drawIcon [
					"\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
					GVAR(colorBlue),
					_pos,
					GVAR(iconSize),GVAR(iconSize),
					0,_text,0,GVAR(txtSize),"TahomaB","right"
				];
			};
		};
		_vehicles pushBack _veh;
	} foreach GVARMAIN(BFTvehicles);

	// ------------------ GROUPS ------------------
	{
		private _veh = vehicle (_x select 0);
		
		// See if the group leader's vehicle is in the list of drawn vehicles
		private _vehIndex = _vehicles find _veh;
		
		// Only do this if the vehicle has not been drawn yet, or the player is sitting in the same vehicle as the group leader
		if (_vehIndex != -1 || {_veh == _playerVehicle}) then {
			if (_drawText) then {
				// we want to draw text and the group leader is in a vehicle that has already been drawn
				private _text = _x select 3;
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
			private _text = if (_drawText) then {_x select 3} else {""};
			private _pos = getPosASL _veh;
			_ctrlScreen drawIcon [_x select 1,GVAR(colorBlue),_pos,GVAR(iconSize),GVAR(iconSize),0,_text,0,GVAR(txtSize),"TahomaB","right"];
			_ctrlScreen drawIcon [_x select 2,GVAR(colorBlue),_pos,GVAR(groupOverlayIconSize),GVAR(groupOverlayIconSize),0,"",0,GVAR(txtSize),"TahomaB","right"];
		};
	} foreach GVARMAIN(BFTGroups);
};

// ------------------ MEMBERS ------------------
private _mountedLabels = [];
{
	private _veh = vehicle (_x select 0);
	
	// make sure we are still in the same team
	if (group Ctab_player isEqualTo group (_x select 0)) then {
		
		// get the fire-team color
		private _teamColor = GVAR(colorTeam) select (["MAIN","RED","GREEN","BLUE","YELLOW"] find (assignedTeam (_x select 0)));
		
		if (_mode != 2 && {_veh == _playerVehicle || {_veh in _vehicles}}) exitWith {
			if (_drawText) then {
				// we want to draw text on anything but MicroDAGR and the unit sits in a vehicle that has already been drawn
				private _mountedIndex = _mountedLabels find _veh;
				if (_mountedIndex != -1) then {
					_mountedLabels set [_mountedIndex + 1,(_mountedLabels select (_mountedIndex + 1)) + "/" + (_x select 4)];
				} else {
					_mountedLabels pushBack _veh;
					_mountedLabels pushBack (_x select 4 /* 3 is name, 4 is group idx */);
				};
			};
		};
		if (_veh != (_x select 0)) exitWith {
			// the unit _does_ sit in a vehicle
			private _mountedIndex = _mountedLabels find _veh;
			if (_mountedIndex != -1 && _drawText) then {
				_mountedLabels set [_mountedIndex + 1,(_mountedLabels select (_mountedIndex + 1)) + "/" + (_x select 4 /* 3 is name, 4 is group idx */)];
			} else {
				_mountedLabels pushBack _veh;
				if  (_drawText) then {
					_mountedLabels pushBack (_x select 4 /* 3 is name, 4 is group idx */);
				};
				if (_veh != _playerVehicle) then {
					_ctrlScreen drawIcon ["\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",GVAR(colorBlue),getPosASL _veh,GVAR(iconSize),GVAR(iconSize),direction _veh,"",0,GVAR(txtSize),"TahomaB","right"];
				};
			};
		};
		private _pos = getPosASL _veh;
		_ctrlScreen drawIcon [
			_x select 1,
			_teamColor,
			_pos,
			GVAR(manSize),GVAR(manSize),
			direction _veh,"",0,GVAR(txtSize),"TahomaB","right"
		];
		if (_drawText) then {
			_ctrlScreen drawIcon [
				"\A3\ui_f\data\map\Markers\System\dummy_ca.paa",
				_teamColor,
				_pos,
				GVAR(manSize),GVAR(manSize),
				0,_x select 4 /* 3 is name, 4 is group idx */,0,GVAR(txtSize),"TahomaB","right"
			];
		};
	};
} foreach GVARMAIN(BFTMembers);

// ------------------ ADD LABEL TO VEHICLES WITH MOUNTED GROUPS / MEMBERS ------------------
if (_drawText && !(_mountedLabels isEqualTo [])) then {
	for "_i" from 0 to (count _mountedLabels - 2) step 2 do {
		private _veh = _mountedLabels select _i;
		if (_veh != _playerVehicle) then {
			_ctrlScreen drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",GVAR(colorBlue),getPosASL _veh,GVAR(iconSize),GVAR(iconSize),0,_mountedLabels select (_i + 1),0,GVAR(txtSize),"TahomaB","left"];
		};
	};
};

true
