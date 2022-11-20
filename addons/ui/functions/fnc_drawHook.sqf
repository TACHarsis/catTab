#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
/*
     Name: Ctab_ui_fnc_drawHook

     Author(s):
        Gundy

     Description:
        Calculate and draw hook distance, direction, grid, elevation and arrow

    Parameters:
        0: OBJECT   - Display used to write hook direction, distance and grid to
        0: OBJECT   - Map control to draw arrow on
        2: ARRAY    - Position A, unit position
        3: ARRAY    - Position B, cursor position
        4: STROMG   - Instrument Mode, [QDEVICE_GROUND, QDEVICE_AIR] determines which values will be displayed
        5: BOOLEAN  - Reference Mode, FALSE = unit to cursor, TRUE = cursor to unit

     Returns:
        Nothing

     Example:
        [_display,_ctrlScreen,_playerPos,GVAR(mapCursorPos),0,false] call Ctab_ui_fnc_drawHook;
*/
params ["_display","_displayName","_ctrlScreen","_pos","_secondPos"];

private _drawMapTools = [_displayName, QSETTING_MAP_TOOLS] call FUNC(getSettings);
if !(_drawMapTools) exitWith {};
private _referenceMode = [_displayName, QSETTING_HOOK_REFERENCE_MODE] call FUNC(getSettings);
private _instrumentMode = [_displayName, QSETTING_DEVICE_ENVIRONMENT] call FUNC(getSettings);

private _positions = [[_secondPos,_pos],[_pos,_secondPos]] select _referenceMode;
private _dirToSecondPos = _positions call EFUNC(core,dirTo);
private _dstToSecondPos = _positions call EFUNC(core,distance2D);

// draw arrow from current position to map centre
_ctrlScreen drawArrow [_positions#0,_positions#1,GVAR(mapToolsHookColor)];

switch (_instrumentMode) do {
    case (QDEVICE_GROUND) : {
        (_display displayCtrl IDC_CTAB_OSD_HOOK_GRID) ctrlSetText format ["%1",mapGridPosition _secondPos];
        (_display displayCtrl IDC_CTAB_OSD_HOOK_ELEVATION) ctrlSetText format ["%1m",round getTerrainHeightASL _secondPos];
        (_display displayCtrl IDC_CTAB_OSD_HOOK_DIR) ctrlSetText format ["%1° %2",[_dirToSecondPos,3] call CBA_fnc_formatNumber,[_dirToSecondPos] call EFUNC(core,degreeToOctant)];
        private _dstText = [
            format ["%1m", [_dstToSecondPos,3] call CBA_fnc_formatNumber],
            format ["%1km",[_dstToSecondPos / 1000,1,2] call CBA_fnc_formatNumber]
        ] select (_dstToSecondPos > GVAR(mapToolsRangeFormatThreshold));
        (_display displayCtrl IDC_CTAB_OSD_HOOK_DST) ctrlSetText _dstText;
    };
    case (QDEVICE_AIR) : {
        (_display displayCtrl IDC_CTAB_OSD_HOOK_GRID) ctrlSetText format ["%1",mapGridPosition _secondPos];
        (_display displayCtrl IDC_CTAB_OSD_HOOK_ELEVATION) ctrlSetText format ["%1m",[round getTerrainHeightASL _secondPos,3] call CBA_fnc_formatNumber];
        (_display displayCtrl IDC_CTAB_OSD_HOOK_DIR) ctrlSetText format ["%1°/%2",[_dirToSecondPos,3] call CBA_fnc_formatNumber,[_dstToSecondPos / 1000,2,1] call CBA_fnc_formatNumber];
    };
};
