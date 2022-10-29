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
	[_displayName,[[QSETTING_MODE,QSETTING_MODE_BFT]]] call FUNC(setSettings);
	true
};
if (_dikCode == DIK_F2 && {_displayName in [QGVARMAIN(Tablet_dlg)]}) exitWith {
	[_displayName,[[QSETTING_MODE,QSETTING_MODE_CAM_UAV]]] call FUNC(setSettings);
	true
};
if (_dikCode == DIK_F3 && {_displayName in [QGVARMAIN(Tablet_dlg)]}) exitWith {
	[_displayName,[[QSETTING_MODE,QSETTING_MODE_CAM_HELMET]]] call FUNC(setSettings);
	true
};
if (_dikCode == DIK_F4 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg)]}) exitWith {
	[_displayName,[[QSETTING_MODE,QSETTING_MODE_MESSAGES]]] call FUNC(setSettings);
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
	private _ctrlScreen = _display displayCtrl ([
		[_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
		[_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
	] call BIS_fnc_getFromPairs);

	private _markerIndex = [_ctrlScreen,GVAR(mapCursorPos)] call FUNC(userMarkerFind);
	if (_markerIndex != -1) then {
		[call EFUNC(core,getPlayerEncryptionKey),_markerIndex] remoteExec [QFUNC(userMarkerDeleteServer), 2];
	};
	true
};

false
