#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
/*
     Name: Ctab_ui_fnc_drawHook
     
     Author(s):
        Gundy

     Description:
        Calculate and draw hook distance, direction, grid, elevation and arrow
    
    Parameters:
        0: OBJECT  - Display used to write hook direction, distance and grid to
        0: OBJECT  - Map control to draw arrow on
        2: ARRAY   - Position A
        3: ARRAY   - Position B
        4: INTEGER - Mode, 0 = Reference is A, 1 = Reference is B
        5: BOOLEAN - TAD, TRUE = TAD
     
     Returns:
        BOOLEAN - Always TRUE
     
     Example:
        [_display,_ctrlScreen,_playerPos,GVAR(mapCursorPos),0,false] call Ctab_ui_fnc_drawHook;
*/
params ["_display","_ctrlScreen","_pos","_secondPos","_mode", "_isTAD"];

// draw arrow from current position to map centre
private _dirToSecondPos = if (_mode == 0) then {
        _ctrlScreen drawArrow [_pos,_secondPos,GVAR(mapToolsHookColor)];

        [_pos,_secondPos] call EFUNC(core,dirTo)
    } else {
        _ctrlScreen drawArrow [_secondPos,_pos,GVAR(mapToolsHookColor)];

        [_secondPos,_pos] call EFUNC(core,dirTo)
    };

private _dstToSecondPos = [_pos,_secondPos] call EFUNC(core,distance2D);
// Call this if we are drawing for a TAD
if (_isTAD) then {
    (_display displayCtrl IDC_CTAB_OSD_HOOK_GRID) ctrlSetText format ["%1",mapGridPosition _secondPos];
    (_display displayCtrl IDC_CTAB_OSD_HOOK_ELEVATION) ctrlSetText format ["%1m",[round getTerrainHeightASL _secondPos,3] call CBA_fnc_formatNumber];
    (_display displayCtrl IDC_CTAB_OSD_HOOK_DIR) ctrlSetText format ["%1°/%2",[_dirToSecondPos,3] call CBA_fnc_formatNumber,[_dstToSecondPos / 1000,2,1] call CBA_fnc_formatNumber];
} else {
    (_display displayCtrl IDC_CTAB_OSD_HOOK_GRID) ctrlSetText format ["%1",mapGridPosition _secondPos];
    (_display displayCtrl IDC_CTAB_OSD_HOOK_ELEVATION) ctrlSetText format ["%1m",round getTerrainHeightASL _secondPos];
    (_display displayCtrl IDC_CTAB_OSD_HOOK_DIR) ctrlSetText format ["%1° %2",[_dirToSecondPos,3] call CBA_fnc_formatNumber,[_dirToSecondPos] call EFUNC(core,degreeToOctant)];
    private _dstText = [
        format ["%1m", [_dstToSecondPos,3] call CBA_fnc_formatNumber],
        format ["%1km",[_dstToSecondPos / 1000,1,2] call CBA_fnc_formatNumber]
    ] select (_dstToSecondPos > GVAR(mapToolsRangeFormatThreshold));
    (_display displayCtrl IDC_CTAB_OSD_HOOK_DST) ctrlSetText _dstText;
};

true
