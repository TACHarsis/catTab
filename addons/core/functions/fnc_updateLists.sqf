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

private _BFTMembers = []; // members of player's group
private _BFTgroups = []; // other groups
private _BFTvehicles = []; // all vehicles
private _UAVList =  []; // all remote controllable UAVs
private _hCamList = [];  // units with a helmet cam

private _validSides = call FUNC(getPlayerSides);
private _playerVehicle = vehicle Ctab_player;
private _playerGroup = group Ctab_player;

/*
GVARMAIN(BFTMembers) --- GROUP MEMBERS
*/
{
	if ((_x != Ctab_player) && {[_x,["ItemcTab","ItemAndroid","ItemMicroDAGR"]] call FUNC(checkGear)}) then {
		_BFTMembers pushBack [_x,_x call EFUNC(ui,getInfMarkerIcon),"",name _x,str([_x] call CBA_fnc_getGroupIndex)];
	};
} foreach units Ctab_player;

/*
GVARMAIN(BFTGroups) --- GROUPS
Groups on our side that player is not a member of. Use the leader for positioning if he has a Tablet or Android.
Else, search through the group and use the first member we find equipped with a Tablet or Android for positioning.
*/
{
	if ((side _x in _validSides) && {_x != _playerGroup}) then {
		_leader = objNull;
		call {
			if ([leader _x,["ItemcTab","ItemAndroid"]] call FUNC(checkGear)) exitWith {_leader = leader _x;};
			{
				if ([_x,["ItemcTab","ItemAndroid"]] call FUNC(checkGear)) exitWith {_leader = _x;};
			} foreach units _x;
		};
		if !(IsNull _leader) then {
			_groupSize = count units _x;
			_sizeIcon = call {
				if (_groupSize <= 3) exitWith {"\A3\ui_f\data\map\markers\nato\group_0.paa"};
				if (_groupSize <= 9) exitWith {"\A3\ui_f\data\map\markers\nato\group_1.paa"};
				"\A3\ui_f\data\map\markers\nato\group_2.paa"
			};
			_BFTgroups pushBack [_leader,"\A3\ui_f\data\map\markers\nato\b_inf.paa",_sizeIcon,groupID _x,""];
		};
	};
} foreach allGroups;

/*
GVARMAIN(BFTvehicles) --- VEHICLES
Vehciles on our side, that are not empty and that player is not sitting in.
*/
{
	if ((side _x in _validSides) && {count (crew _x) > 0} && {_x != _playerVehicle}) then {
		_groupID = "";
		_name = "";
		_customName = _x getVariable [QGVARMAIN(groupId),""];
		call {
			if !(_customName isEqualTo "") exitWith {
				_name = _customName;
			};
			if (group _x == _playerGroup) then {
				_groupID = str([_x] call CBA_fnc_getGroupIndex)
			};
			_name = groupID group _x;
		};
		_iconA = "";
		_iconB = "";
		call {
			if (_x isKindOf "MRAP_01_base_F") exitWith {_iconA = QPATHTOEF(data,img\b_mech_inf_wheeled.paa);};
			if (_x isKindOf "MRAP_02_base_F") exitWith {_iconA = QPATHTOEF(data,img\b_mech_inf_wheeled.paa);};
			if (_x isKindOf "MRAP_03_base_F") exitWith {_iconA = QPATHTOEF(data,img\b_mech_inf_wheeled.paa);};
			if (_x isKindOf "Wheeled_APC_F") exitWith {_iconA = QPATHTOEF(data,img\b_mech_inf_wheeled.paa);};
			if (_x isKindOf "Truck_F" && {getNumber (configfile >> "cfgVehicles" >> typeOf _x >> "transportSoldier") > 2}) exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";};
			if (_x isKindOf "Truck_F") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_support.paa";};
			if (_x isKindOf "Car_F") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";};
			if (_x isKindOf "UAV") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_uav.paa";};
			if (_x isKindOf "UAV_01_base_F") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_uav.paa";};
			if (_x isKindOf "Helicopter") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_air.paa"; _iconB = QPATHTOEF(data,img\icon_air_contact_ca.paa);};
			if (_x isKindOf "Plane") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_plane.paa"; _iconB = QPATHTOEF(data,img\icon_air_contact_ca.paa);};
			if (_x isKindOf "Tank" && {getNumber (configfile >> "cfgVehicles" >> typeOf _x >> "transportSoldier") > 6}) exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";};
			if (_x isKindOf "MBT_01_arty_base_F") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_art.paa";};
			if (_x isKindOf "MBT_01_mlrs_base_F") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_art.paa";};
			if (_x isKindOf "MBT_02_arty_base_F") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_art.paa";};
			if (_x isKindOf "Tank") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_armor.paa";};
			if (_x isKindOf "StaticMortar") exitWith {_iconA = "\A3\ui_f\data\map\markers\nato\b_mortar.paa";};
		};
		call {
			if (_iconA isEqualTo "" && {!(_x isKindOf "Static")} && {!(_x isKindOf "StaticWeapon")}) then {_iconA = "\A3\ui_f\data\map\markers\nato\b_unknown.paa";};
			if (_iconA isEqualTo "") exitWith {};
			_BFTvehicles pushBack [_x,_iconA,_iconB,_name,_groupID];
		};
	};
} foreach vehicles;

/*
GVARMAIN(UAVList) --- UAVs
*/
{
	if (side _x in _validSides) then {
		_UAVList pushBack _x;
	};
} foreach allUnitsUav;

/*
GVARMAIN(hCamList) --- HELMET CAMS
Units on our side, that have either helmets that have been specified to include a helmet cam, or ItemCTabHCAM in their inventory.
*/
{
	if (side _x in _validSides) then {
		if (headgear _x in GVARMAIN(helmetClass_has_HCam) || {[_x,["ItemcTabHCam"]] call FUNC(checkGear)}) then {
			_hCamList pushBack _x;
		};
	};
} foreach allUnits;

// array to hold interface update commands
private _updateInterface = [];

// replace the global list arrays in the end so that we avoid them being empty unnecessarily
GVARMAIN(BFTMembers) = [] + _BFTMembers;
GVARMAIN(BFTGroups) = [] + _BFTgroups;
GVARMAIN(BFTvehicles) = [] + _BFTvehicles;
if !(GVARMAIN(UAVList) isEqualTo _UAVList) then {
	GVARMAIN(UAVList) = [] + _UAVList;
	_updateInterface pushBack ["UAVListUpdate",true];
};
if !(GVARMAIN(hCamList) isEqualTo _hCamList) then {
	GVARMAIN(hCamList) = [] + _hCamList;
	_updateInterface pushBack ["hCamListUpdate",true];
};

// call interface updates
if (count _updateInterface > 0) then {
	[_updateInterface] call EFUNC(ui,updateInterface);
};

true
