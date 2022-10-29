#include "script_component.hpp"
#include "..\devices\shared\cTab_gui_macros.hpp"

if (isNil QGVAR(ifOpen)) exitWith {};

private _displayName = GVAR(ifOpen) select 1;
private _displaySettings = [_displayName] call FUNC(getSettings);
private _mode = _displaySettings get QSETTING_MODE;

if (isNil "_mode") exitWith {};

if (_mode isEqualTo QSETTING_MODE_CAM_HELMET) then {
	private _data = [_displayName,QSETTING_CAM_HELMET] call FUNC(getSettings);
	private _hcamListCtrl = _display displayCtrl IDC_CTAB_CTABHCAMLIST;

	// Populate list of HCAMs
	lbClear _hcamListCtrl;
	_hcamListCtrl lbSetCurSel -1;
	{
		private _index = _hcamListCtrl lbAdd format ["%1:%2 (%3)",groupId group _x,[_x] call CBA_fnc_getGroupIndex,name _x];
		_hcamListCtrl lbSetData [_index,str _x];
	} foreach GVARMAIN(hCamList);

	lbSort [_hcamListCtrl, "ASC"];
	if (_data != "") then {
		// Find last selected hCam and select if found
		for "_i" from 0 to (lbSize _hcamListCtrl - 1) do {
			if (_data isEqualTo (_hcamListCtrl lbData _i)) exitWith {
				if ((lbCurSel _hcamListCtrl) != _i) then {
					_hcamListCtrl lbSetCurSel _i;
				};
			};
		};
		// If no hCam could be selected, clear last selected hCam
		if ((lbCurSel _hcamListCtrl )isEqualTo -1) then {
			[_displayName,[[QSETTING_CAM_HELMET,""]]] call FUNC(setSettings);
		};
	};
};
