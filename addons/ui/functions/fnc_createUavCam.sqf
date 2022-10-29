#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_createUavCam
	
	Author(s):
		Gundy

	Description:
		Set up UAV camera and display on supplied render target
		Modified to include lessons learned from KK's excellent tutorial: http://killzonekid.com/arma-scripting-tutorials-uav-r2t-and-pip/
	
	Parameters:
		0: STRING - Name of UAV (format used from `str uavObject`)
		1: ARRAY  - List of arrays with seats with render targets
			0: INTEGER - Seat
				0 = DRIVER
				1 = GUNNER
			1: STRING  - Name of render target
	
	Returns:
		BOOLEAN - If UAV cam could be set up or not
	
	Example:
		[str _uavVehicle,[[0,"rendertarget8"],[1,"rendertarget9"]]] call Ctab_ui_fnc_createUavCam;
*/
params ["_data","_uavCams"];

private _uav = objNull;

// see if given UAV name is still in the list of valid UAVs
{
	if (_data == str _x) exitWith {_uav = _x;};
} foreach GVARMAIN(UAVList);

// remove exisitng UAV cameras
[] call FUNC(deleteUAVcam);

// exit if requested UAV could not be found
if (isNull _uav) exitWith {false};

// exit if requested UAV is not alive
if !(alive _uav) exitWith {false};

{
	private _seat = _x select 0;
	private _renderTarget = _x select 1;
	// check existing cameras
	_cam = objNull;
	private _camPosMemPt = "";
	private _camDirMemPt = "";
	
	private _seatName = switch (_seat) do {
		case (0) : {"Driver"};
		case (1) : {"Gunner"};
		default {""};
	};
	if (_seatName != "") then {
		// retrieve memory point names from vehicle config
		_camPosMemPt = getText (configFile >> "CfgVehicles" >> typeOf _uav >> "uavCamera" + _seatName + "Pos");
		_camDirMemPt = getText (configFile >> "CfgVehicles" >> typeOf _uav >> "uavCamera" + _seatName + "Dir");
	};
	// If memory points could be retrieved, create camera
	if ((_camPosMemPt != "") && (_camDirMemPt != "")) then {
		private _cam = "camera" camCreate [0,0,0];
		_cam attachTo [_uav,[0,0,0],_camPosMemPt];
		// set up cam on render target
		_cam cameraEffect ["INTERNAL","BACK",_renderTarget];
		if (_seat == 1) then {
			_renderTarget setPiPEffect [2]; // IR view
			_cam camSetFov 0.1; // set zoom
		} else {
			_cam camSetFov 0.5; // set default zoom
		};
		GVAR(uAVcams) pushBack [_uav,_renderTarget,_cam,_camPosMemPt,_camDirMemPt];
	};
} foreach _uavCams;

// set up event handler
if !(GVAR(uAVcams) isEqualTo []) exitWith {
	if (isNil QGVAR(uavEventHandle)) then {
		GVAR(uavEventHandle) = addMissionEventHandler ["Draw3D",{
			{
				if !(isNil "_x") then {
					private _uav = _x select 0;
					private _cam = _x select 2;
					if (alive _uav) then {
						private _dir = (_uav selectionPosition (_x select 3)) vectorFromTo (_uav selectionPosition (_x select 4));
						_cam setVectorDirAndUp [_dir,_dir vectorCrossProduct [-(_dir select 1), _dir select 0, 0]];
					} else {
						[_cam] call FUNC(deleteUAVcam);
					};
				};
			} foreach GVAR(uAVcams);
		}];
	};
	GVAR(actUAV) = _uav;
	true
};

false
