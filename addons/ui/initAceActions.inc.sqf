private _fnc_conditionFBCB2 = { [Ctab_player, vehicle Ctab_player, QSETTINGS_FBCB2] call EFUNC(core,unitInEnabledVehicleSeat) };
private _fnc_conditionTAD = { [Ctab_player, vehicle Ctab_player, QSETTINGS_TAD] call EFUNC(core,unitInEnabledVehicleSeat) };
private _fnc_getDeviceActions = {
    [
        [
            "",
            QGVARMAIN(Android_dlg),     QGVAR(deviceAndroid_dlg),   [LLSTRING(ACE_Open_Android_Dlg)],
            "ItemAndroid"
        ],
        [
            QGVAR(deviceAndroid_dlg),
            QGVARMAIN(Android_dsp),     QGVAR(deviceAndroid_dsp),   [LLSTRING(ACE_Open_Android_Dsp), LLSTRING(ACE_Close_Android_Dsp)],
            "ItemAndroid"
        ],
        [
            "",
            QGVARMAIN(FBCB2_dlg),       QGVAR(deviceFBCB2_dlg),     [LLSTRING(ACE_Open_FBCB2_Dlg)],
            "", _fnc_conditionFBCB2
        ],
        [
            "",
            QGVARMAIN(microDAGR_dlg),   QGVAR(deviceMicroDAGR_dlg), [LLSTRING(ACE_Open_MicroDAGR_Dlg)],
            "ItemMicroDAGR"
        ],
        [
            QGVAR(deviceMicroDAGR_dlg),
            QGVARMAIN(microDAGR_dsp),   QGVAR(deviceMicroDAGR_dsp), [LLSTRING(ACE_Open_MicroDAGR_Dsp), LLSTRING(ACE_Close_MicroDAGR_Dsp)],
            "ItemMicroDAGR"
        ],
        [
            "",
            QGVARMAIN(Tablet_dlg),     QGVAR(deviceTablet_dlg),    [LLSTRING(ACE_Open_Tablet_Dlg)],
            "ItemcTab"
        ],
        [
            "",
            QGVARMAIN(TAD_dlg),        QGVAR(deviceTAD_dlg),       [LLSTRING(ACE_Open_TAD_Dlg)],
            "", _fnc_conditionTAD
        ],
        [
            QGVAR(deviceTAD_dlg),
            QGVARMAIN(TAD_dsp),        QGVAR(deviceTAD_dsp),       [LLSTRING(ACE_Open_TAD_Dsp), LLSTRING(ACE_Close_TAD_Dsp)],
        "", _fnc_conditionTAD
        ]
    ] apply {
        _x params ["_parent", "_interfaceName", "_id", "_texts", "_item", ["_condition", {true}, [{}]]];
        private _modifierFunction = {
            params ["_target", "_player", "_params", "_actionData"];
            _params params ["_ifaceName", "", "", "_texts"];

            if !(isNil QGVAR(ifOpen)) then { // something is open
                private _currentIfaceName = GVAR(ifOpen) select 1;
                _actionData set [1, _texts select (_currentIfaceName isEqualTo _ifaceName)]; // action display name
            };
        };
        private _deviceAction = [
            _id, _texts # 0,
            "",
            {
                params ["_target", "_player", "_params"];
                _params params ["_ifaceName", "_item", "", ""];
                [_ifaceName] call FUNC(toggleInterface);

                true
            },
            {
                params ["_target", "_player", "_params"];
                _params params ["_ifaceName", "_item", "_condition", ""];
                
                private _hasItem = (_item isEqualTO "") || { [player, [_item]] call EFUNC(core,checkGear) };
                private _enabled = _hasItem && ([] call _condition);
                _enabled
            },
            {},
            [_interfaceName, _item, _condition, _texts],
            nil,
            nil,
            [/*showDisabled (false)*/false, /*enableInside (false)*/false, /*canCollapse (false)*/true, /*runOnHover (false)*/false, /*doNotCheckLOS (false)*/false],
            [{}, _modifierFunction] select (count _texts > 1)
        ] call ace_interact_menu_fnc_createAction;
        [_parent, _deviceAction]
    }
};

private _cattabCategoryAction = [
        QGVAR(cattab), LLSTRING(ACE_CatTab),
        "",
        { true },
        {
            params ["_target", "_player", "_params"];
            _params params ["_fnc_conditionFBCB2", "_fnc_conditionTAD"];
            private _hasItem = [player, ["ItemAndroid", "ItemMicroDAGR", "ItemcTab"]] call EFUNC(core,checkGear);
            private _enabled = _hasItem || { [] call _fnc_conditionFBCB2 } || { [] call _fnc_conditionTAD} ;
            _enabled
        },
        {},
        [_fnc_conditionFBCB2, _fnc_conditionTAD],
        nil,
        nil,
        [/*showDisabled (false)*/false, /*enableInside (false)*/true, /*canCollapse (false)*/true, /*runOnHover (false)*/false, /*doNotCheckLOS (false)*/false],
        {}
    ] call ace_interact_menu_fnc_createAction;
private _return = [player, 1, ["ACE_SelfActions"], _cattabCategoryAction] call ace_interact_menu_fnc_addActionToObject;

private _deviceActions = [] call _fnc_getDeviceActions;
{
    _x params ["_parent", "_action"];
    private _actionPath = ( if(_parent isEqualTo "") then {
        ["ACE_SelfActions", QGVAR(cattab)]
    } else {
        ["ACE_SelfActions", QGVAR(cattab), _parent]
    }
    );
    private _return = [player, 1, _actionPath, _action] call ace_interact_menu_fnc_addActionToObject;
} foreach _deviceActions;
