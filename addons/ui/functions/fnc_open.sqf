#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_open
    
    Author(s):
        Gundy
    
    Description:
        Handles dialog / display startup and registering of event handlers
        
        This function will define GVAR(ifOpen), using the following format:
            Parameter 0: Interface type, 0 = Main, 1 = Secondary, 2 = Tertiary, 3 = ACE action
            Parameter 1: Name of uiNameSpace variable for display / dialog (i.e. QGVARMAIN(Tablet_dlg))
            Parameter 2: Unit we registered the killed eventhandler for
            Parameter 3: ID of registered eventhandler for killed event 
            Parameter 4: Vehicle we registered the GetOut eventhandler for (even if no EH is registered)
            Parameter 5: ID of registered eventhandler for GetOut event (nil if no EH is registered)
            Parameter 6: ID of registered eventhandler for Draw3D event (nil if no EH is registered)
            Parameter 7: ID of registered eventhandler A.C.E medical_onUnconscious event (nil if no EH is registered)
            Parameter 8: ID of registered eventhandler A.C.E playerInventoryChanged event (nil if no EH is registered)
    
    Parameters:
        0: INTEGER - Interface type, 0 = Main, 1 = Secondary, 2 = Tertiary
        1: STRING  - Name of uiNameSpace variable for display / dialog (i.e. QGVARMAIN(Tablet_dlg))
        2: OBJECT  - Unit to register killed eventhandler for
        3: OBJECT  - Vehicle to register GetOut eventhandler for
    
    Returns:
        BOOLEAN - TRUE
    
    Example:
        // open TAD display as main interface type
        [0,QGVARMAIN(TAD_dsp),player,vehicle player] call Ctab_ui_fnc_open;
*/

#include "..\devices\shared\cTab_defines.hpp"

params ["_interfaceType", "_displayName", "_player", "_vehicle"];

if (GVAR(openStart) || (!isNil QGVAR(ifOpen))) exitWith {false};
GVAR(openStart) = true;

private _isDialog = [_displayName] call FUNC(isDialog);

GVAR(ifOpen) = [ // parameter details see header
/*Parameter 0*/    _interfaceType,
/*Parameter 1*/    _displayName,
/*Parameter 2*/    _player,
/*Parameter 3*/    _player addEventHandler ["killed", {[] call FUNC(close)}],
/*Parameter 4*/    _vehicle,
/*Parameter 5*/    nil,
/*Parameter 6*/    nil,
/*Parameter 7*/    nil,
/*Parameter 8*/    nil
];

if (_vehicle != _player && (_isDialog || _displayName in [QGVARMAIN(TAD_dsp)])) then {
    GVAR(ifOpen) set [5,
            _vehicle addEventHandler ["GetOut", {if ((_this # 2) == Ctab_player) then {[] call FUNC(close);}}]
    ];
};

// Set up event handler to update display header / footer
if (_displayName in [QGVARMAIN(TAD_dsp), QGVARMAIN(TAD_dlg)]) then {
    GVAR(ifOpen) set [6,
        addMissionEventHandler ["Draw3D", {
            private _display = uiNamespace getVariable (GVAR(ifOpen) select 1);
            private _veh = vehicle Ctab_player;
            private _playerPos = getPosASL _veh;
        
            // update time
            (_display displayCtrl IDC_CTAB_OSD_TIME) ctrlSetText call EFUNC(core,currentTime);
            
            // update grid position
            (_display displayCtrl IDC_CTAB_OSD_GRID) ctrlSetText format ["%1", mapGridPosition _playerPos];
            
            // update current heading
            (_display displayCtrl IDC_CTAB_OSD_DIR_DEGREE) ctrlSetText format ["%1°", [direction _veh, 3] call CBA_fnc_formatNumber];
            
            // update current elevation (ASL) on TAD
            (_display displayCtrl IDC_CTAB_OSD_ELEVATION) ctrlSetText format ["%1m", [round (_playerPos select 2), 4] call CBA_fnc_formatNumber];
        }]
    ];
} else {
    GVAR(ifOpen) set [6,
        addMissionEventHandler ["Draw3D", {
            private _display = uiNamespace getVariable (GVAR(ifOpen) select 1);
            private _veh = vehicle Ctab_player;
            private _heading = direction _veh;
            // update time
            (_display displayCtrl IDC_CTAB_OSD_TIME) ctrlSetText call EFUNC(core,currentTime);
            
            // update grid position
            (_display displayCtrl IDC_CTAB_OSD_GRID) ctrlSetText format ["%1", mapGridPosition getPosASL _veh];
            
            // update current heading
            (_display displayCtrl IDC_CTAB_OSD_DIR_DEGREE) ctrlSetText format ["%1°", [_heading, 3] call CBA_fnc_formatNumber];
            (_display displayCtrl IDC_CTAB_OSD_DIR_OCTANT) ctrlSetText format ["%1", [_heading] call EFUNC(core,degreeToOctant)];
        }]
    ];
};


// If ace_medical is used, register with medical_onUnconscious event
if (IS_MOD_LOADED(ace_medical)) then {
    GVAR(ifOpen) set [7,
        ["ace_unconscious", {
            params ["_player", "_effectNum"];
            if (_player == Ctab_player && _effectNum) then {
                [] call FUNC(close);
            };
        }] call ace_common_fnc_addEventHandler
    ];
};

// If ace_common is used, register with playerInventoryChanged event
if (IS_MOD_LOADED(ace_common)) then {
    GVAR(ifOpen) set [8,
        ["playerInventoryChanged", {
            _this call EFUNC(core,onPlayerInventoryChanged);
        }] call ace_common_fnc_addEventHandler
    ];
};

if (_isDialog) then {
    // Check if map and / or a dialog is open and close them
    if (visibleMap) then {openMap false};
    while {dialog} do {
         closeDialog 0;
    };
    createDialog _displayName;
} else {
    GVAR(RscLayer) cutRsc [_displayName, "PLAIN", 0, false];
};

true
