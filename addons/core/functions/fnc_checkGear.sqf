#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_checkGear
     Author(s):
        Gundy

     Description:
        Check a units gear for certain items
    Parameters:
        0: OBJECT - Unit object to check gear on
        1: ARRAY  - Array of item names to search for
     Returns:
        BOOLEAN - If at least one of the items passed in parameter 1 was found or not
     Example:
        _playerHasCtabItem = [player,[QITEM_TABLET,QITEM_ANDROID,QITEM_MICRODAGR]] call Ctab_ui_fnc_checkGear;
*/

params ["_unit", "_items"];

private _chk_all_items = items _unit;
_chk_all_items append (assignedItems _unit);
_chk_all_items pushBack (goggles _unit);

// Some "units" don't return assignedItems, for example the Headquater module
if (isNil "_chk_all_items") exitWith {false};

{_x in _chk_all_items} count _items > 0
