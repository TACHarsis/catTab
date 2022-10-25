#include "script_component.hpp"
/*
 	Name: Ctab_ui_fnc_onIfKeyDown
 	
 	Author(s):
		Gundy, Riouken

 	Description:
		Process onKeyDown events from cTab dialogs
		
	
	Parameters:
		0: OBJECT  - Display that called the onKeyDown event
		1: INTEGER - DIK code of onKeyDown event
		2: BOOLEAN - Shift key pressed
		3: BOOLEAN - Ctrl key pressed
		4: BOOLEAN - Alt key pressed
 	
 	Returns:
		BOOLEAN - If onKeyDown event was acted upon
 	
 	Example:
		[_display,_dikCode,_shiftKey,_ctrlKey,_altKey] call Ctab_ui_fnc_onIfKeyDown;
*/

#include "\a3\editor_f\Data\Scripts\dikCodes.h"

params ["_display","_dikCode","_shiftKey","_ctrlKey","_altKey"];

private _displayName = GVAR(ifOpen) select 1;

if (_dikCode == DIK_F1 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg)]}) exitWith {
	[_displayName,[["mode","BFT"]]] call FUNC(setSettings);
	true
};
if (_dikCode == DIK_F2 && {_displayName in [QGVARMAIN(Tablet_dlg)]}) exitWith {
	[_displayName,[["mode","UAV"]]] call FUNC(setSettings);
	true
};
if (_dikCode == DIK_F3 && {_displayName in [QGVARMAIN(Tablet_dlg)]}) exitWith {
	[_displayName,[["mode","HCAM"]]] call FUNC(setSettings);
	true
};
if (_dikCode == DIK_F4 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg)]}) exitWith {
	[_displayName,[["mode","MESSAGE"]]] call FUNC(setSettings);
	true
};
if (_dikCode == DIK_F5 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(TAD_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]}) exitWith {
	[_displayName] call FUNC(toggleMapTools);
	true
};
if (_dikCode == DIK_F6 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(TAD_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]}) exitWith {
	[_displayName] call FUNC(caseButtonsMapTypeToggle);
	true
};
if (_dikCode == DIK_F7 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(TAD_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]}) exitWith {
	[_displayName] call FUNC(caseButtonsCenterMapOnPlayerPosition);
	true
};
if (_dikCode == DIK_DELETE && {GVAR(cursorOnMap)}) exitWith {
	private _mapTypes = [_displayName,"mapTypes"] call FUNC(getSettings);
	private _currentMapType = [_displayName,"mapType"] call FUNC(getSettings);
	private _currentMapTypeIndex = [_mapTypes,_currentMapType] call BIS_fnc_findInPairs;
	private _ctrlScreen = _display displayCtrl (_mapTypes select _currentMapTypeIndex select 1);
	private _markerIndex = [_ctrlScreen,GVAR(mapCursorPos)] call FUNC(findUserMarker);
	if (_markerIndex != -1) then {
		[call EFUNC(core,getPlayerEncryptionKey),_markerIndex] call FUNC(deleteUserMarker);
	};
	true
};

false
