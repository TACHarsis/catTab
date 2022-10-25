#include "script_component.hpp"
/*
 	Name: Ctab_ui_fnc_unitInEnabledVehicleSeat
 	
 	Author(s):
		Gundy

 	Description:
		Determines if a unit sits in the front-section of a cTab enabled vehicle.
		The front seciton-of a vehilce is defined as:
			- Ground vehicles, everyone in the same compartment as the driver, including the driver. Excluded are people sitting in the cargo / passenger compartment of a Truck or APC
			- Aircraft, pilot and co-pilot / gunner, but not door gunners or any passengers
	
	Parameters:
		0: OBJECT - Unit object to check
		1: OBJECT - Vehicle to check against
		2: STRING - String of device to check for (current options are: "FBCB2" and "TAD")
 	
 	Returns:
		BOOLEAN - True if unit is in the front-section of a cTab enabled vehicle, false if not
 	
 	Example:
		_playerHasCtabItem = [player,["ItemcTab","ItemAndroid","ItemMicroDAGR"]] call Ctab_ui_fnc_unitInEnabledVehicleSeat;
*/

params ["_unit","_vehicle","_type"];

private _return = false;

// Check if vehicle is a parachute, if so, return false
if (_vehicle isKindOf "ParachuteBase") exitWith {false};

private _typeClassList = switch (_type) do {
    case "FBCB2": { GVARMAIN(vehicleClass_has_FBCB2) };
	case "TAD": { GVARMAIN(vehicleClass_has_TAD) };
	default { [] };
};

{
	if (_vehicle isKindOf _x) exitWith {
		call {
			if (_unit == driver _vehicle) exitWith {_return = true;};
			if (_type == "FBCB2") exitWith {
				call {
					private _cargoIndex = _vehicle getCargoIndex _unit; // 0-based seat number in cargo, -1 if not in cargo
					if (_cargoIndex == -1) exitWith {_return = true;}; // if not in cargo, _unit must be gunner or commander
					private _cargoCompartments = getArray (configFile/"CfgVehicles"/typeOf _vehicle/"cargoCompartments");
					if (count _cargoCompartments > 1) then {
						// assume the vehicle setup is correct if there is more than one cargo compartment
						private _cargoIsCoDriver = getArray (configFile/"CfgVehicles"/typeOf _vehicle/"cargoIsCoDriver");
						if (_cargoIndex < count _cargoIsCoDriver - 1) then {_return = true;};
					} else {
						// assume the vehicle setup is not correct if there is just one cargo compartment
						private _transportSoldier = getNumber (configFile/"CfgVehicles"/typeOf _vehicle/"transportSoldier");
						// assume that if a vehicle carries less than 5 passengers, they all sit with the driver
						If (_transportSoldier < 5) then {_return = true;};
					};
				};
			};
			if (_type == "TAD") then {
				if (_unit == _vehicle call FUNC(getCopilot)) then {_return = true};
			};
		};
	};
} forEach _typeClassList;

_return
