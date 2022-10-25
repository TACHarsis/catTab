#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_getBackgroundPosition
	
	Author(s):
		Gundy
	
	Description:
		Get the current and config position of the interface background element
	
	Parameters:
		0: STRING - uiNamespace variable name of interface
	
	Returns:
		ARRAY - interface position and config position
			0: ARRAY - interface position in the form of [x,y,w,h]
			1: ARRAY - interface config position in the form of [x,y,w,h], empty array if background could not be found
	
	Example:
		[QGVARMAIN(Tablet_dlg)] call Ctab_ui_fnc_getBackgroundPosition;
*/

#include "..\devices\shared\cTab_gui_macros.hpp"
params ["_displayName"];

private _display = uiNamespace getVariable _displayName;
private _isDialog = [_displayName] call FUNC(isDialog);

// get both classes "controls" and "controlsBackground" if they exist
private _displayConfigContainers = if (_isDialog) then {
		"true" configClasses (configFile >> _displayName)
	} else {
		"true" configClasses (configFile >> "RscTitles" >> _displayName)
	};

// get the class name and current position
private _backgroundCtrl = _display displayCtrl IDC_CTAB_BACKGROUND;
private _backgroundClassName = ctrlClassName _backgroundCtrl;
private _backgroundPosition = ctrlPosition _backgroundCtrl;

// CC: TODO: read this from gui grids instead
// get the original position of the background control
private _backgroundConfigPosition = [];
{
	if (isClass _x) then {
		if (isClass (_x >> _backgroundClassName)) exitWith {
			_backgroundConfigPosition = [
					getNumber (_x >> _backgroundClassName >> "x"),
					getNumber (_x >> _backgroundClassName >> "y"),
					getNumber (_x >> _backgroundClassName >> "w"),
					getNumber (_x >> _backgroundClassName >> "h")
				];
		};
	};
} forEach _displayConfigContainers;

[_backgroundPosition,_backgroundConfigPosition]
