#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_updateInterface

     Author(s):
        Gundy

     Description:
        Update current interface (display or dialog) to match current settings.
        If no parameters are specified, all interface elements are updated

    Parameters:
    (Optional)
        0: ARRAY - Property pairs in the form of [["propertyName", propertyValue], [...]]

     Returns:
        BOOLEAN - Always true

     Example:
        [[[QSETTING_CURRENT_MAP_TYPE, QMAP_TYPE_SAT], [QSETTING_MAP_SCALE_DISPLAY, "4"]]] call Ctab_ui_fnc_updateInterface;
*/
#include "..\devices\shared\cTab_defines.hpp"

params ["_displaySettings"];

disableSerialization;

if (isNil QGVAR(ifOpen)) exitWith {false};
private _displayName = GVAR(ifOpen) select 1;
private _display = uiNamespace getVariable _displayName;
private _interfaceInit = false;
private _loadingCtrl = _display displayCtrl IDC_CTAB_LOADINGTXT;
private _targetMapCtrl = controlNull;
private _targetMapScale = nil;
private _targetMapWorldPos = nil;
private _isDialog = [_displayName] call FUNC(isDialog);

if (isNil "_displaySettings") then {
    // Retrieve all settings for the currently open interface
    _displaySettings = [
            _displayName
        ] call FUNC(getSettings);
    _interfaceInit = true;
};

private _mode = _displaySettings get QSETTING_MODE;
if (isNil "_mode") then {
    _mode = [
        _displayName,
        QSETTING_MODE
    ] call FUNC(getSettings);
    _loadingCtrl = displayNull;
} else {
    // show "Loading" control to hide all the action while its going on
    if !(isNull _loadingCtrl) then {
        _loadingCtrl ctrlShow true;
        while {!ctrlShown _loadingCtrl} do {};
    };
};

{
    private _key = _x;
    private _value = _y;
    switch (_key) do {
    // ------------ DISPLAY POSITION ------------
        case (QSETTING_POSITION_DISPLAY) : {
            if(_isDialog) exitWith {};

            private _useAltPosition = _value;

            // get the current position of the background control
            private _backgroundPositionInfo = [_displayName] call FUNC(getBackgroundPosition);
            _backgroundPositionInfo params ["_curBackgroundPos", "_configBackgroundPos"];

            private _position = [
                profilenamespace getVariable [format["IGUI_%1_X", _displayName], _configBackgroundPos # 0 ],
                profilenamespace getVariable [format["IGUI_%1_Y", _displayName], _configBackgroundPos # 1 ]
            ];
            private _positionAlt = [
                profilenamespace getVariable format["IGUI_%1_alt_X", _displayName],
                profilenamespace getVariable format["IGUI_%1_alt_Y", _displayName]
            ];

            private _backgroundProxy = [_configBackgroundPos # 0, _configBackgroundPos # 1];
            private _offset = ([_position, _positionAlt] select _useAltPosition) vectorDiff _backgroundProxy;

            [_displayName, _offset] call FUNC(setInterfacePosition);
        };
        // ------------ DIALOG POSITION ------------
        case (QSETTING_POSITION_DIALOG) : {
            private _backgroundOffset = _value;
            if (_isDialog) then {
                if (_backgroundOffset isEqualTo []) then {
                    _backgroundOffset = if (_interfaceInit) then {
                            [0, 0]
                        } else {
                            // reset to defaults
                            private _backgroundPosition = [_displayName] call FUNC(getBackgroundPosition);
                            [(_backgroundPosition select 1 select 0) - (_backgroundPosition select 0 select 0), (_backgroundPosition select 1 select 1) - (_backgroundPosition select 0 select 1)]
                        };
                };
                if !(_backgroundOffset isEqualTo [0, 0]) then {
                    // move by offset
                    [_displayName, _backgroundOffset] call FUNC(setInterfacePosition);
                };
            };
        };
        // ------------ BRIGHTNESS ------------
        // Value ranges from 0 to 1, 0 being off and 1 being full brightness
        case (QSETTING_BRIGHTNESS) : {
            private _osdCtrl = _display displayCtrl IDC_CTAB_BRIGHTNESS;
            if !(isNull _osdCtrl) then {
                private _brightness = _value;
                private _nightMode = [
                        _displayName,
                        QSETTING_NIGHT_MODE
                    ] call FUNC(getSettings);
                // if we are running night mode, lower the brightness proportionally
                if !(isNil "_nightMode") then {
                    if (_nightMode isEqualTo 1 || {_nightMode isEqualTo 2 && (sunOrMoon < 0.2)}) then {_brightness = _brightness * 0.7};
                };
                _osdCtrl ctrlSetBackgroundColor [0, 0, 0, (1 - _brightness)];
            };
        };

        // ------------ NIGHT MODE ------------
        // 0 = day mode, 1 = night mode, 2 = automatic
        case (QSETTING_NIGHT_MODE) : {
            // transform nightMode into boolean
            private _nightMode = (_value isEqualTo 1 || {_value isEqualTo 2 && (sunOrMoon < 0.2)});
            private _background = switch (true) do {
                case (_displayName in [QGVARMAIN(TAD_dsp), QGVARMAIN(TAD_dlg)]) : {
                    [QPATHTOEF(data,img\ui\display_frames\TAD_background_ca.paa), QPATHTOEF(data,img\ui\display_frames\TAD_background_night_ca.paa)] select _nightMode
                };
                case (_displayName in [QGVARMAIN(Android_dsp),QGVARMAIN(Android_dlg)]) : {
                    [QPATHTOEF(data,img\ui\display_frames\android_background_ca.paa), QPATHTOEF(data,img\ui\display_frames\android_background_night_ca.paa)] select _nightMode
                };
                case (_displayName in [QGVARMAIN(microDAGR_dsp),QGVARMAIN(microDAGR_dlg)]) : {
                    [QPATHTOEF(data,img\ui\display_frames\microDAGR_background_ca.paa), QPATHTOEF(data,img\ui\display_frames\microDAGR_background_night_ca.paa)] select _nightMode
                };
                case (_displayName in [QGVARMAIN(Tablet_dlg)]) : {
                    [QPATHTOEF(data,img\ui\display_frames\tablet_background_ca.paa), QPATHTOEF(data,img\ui\display_frames\tablet_background_night_ca.paa)] select _nightMode
                };
                default {""};
            };
            if (_background != "") then {
                (_display displayCtrl IDC_CTAB_BACKGROUND) ctrlSetText _background;
                // call brightness adjustment if this is outside of interface init
                if !(_interfaceInit) then {
                    [
                        _displayName,
                        [
                            [
                                QSETTING_BRIGHTNESS,
                                [
                                    _displayName,
                                    QSETTING_BRIGHTNESS
                                ] call FUNC(getSettings)
                            ]
                        ],
                        true,
                        true
                    ] call FUNC(setSettings);
                };
            };
        };

        // ------------ MODE ------------
        case (QSETTING_MODE) : {
            GVAR(userPos) = [];

            private _displayItems = switch (true) do {
                case (_displayName isEqualTo QGVARMAIN(Tablet_dlg)) : {
                    private _dynamicFrameCtrls = 
                        (GVAR(uavCamSettingsNames) apply { (GVAR(uavCamSettings) get _x) # 2})
                        + (GVAR(helmetCamSettingsNames) apply { (GVAR(helmetCamSettings) get _x) # 2});
                    [
                        3301, 3303, 3304, 3305, 3306, 3307,
                        IDC_CTAB_MARKER_MENU_MAIN,
                        IDC_CTAB_GROUP_DESKTOP,
                        IDC_CTAB_GROUP_HCAM_SOURCE_GRP,
                        IDC_CTAB_GROUP_UAV_SOURCE_GRP,
                        IDC_CTAB_GROUP_MESSAGE,
                        IDC_CTAB_SCREEN,
                        IDC_CTAB_SCREEN_TOPO,
                        IDC_CTAB_OSD_HOOK_GRID,
                        IDC_CTAB_OSD_HOOK_ELEVATION,
                        IDC_CTAB_OSD_HOOK_DST,
                        IDC_CTAB_OSD_HOOK_DIR,
                        IDC_CTAB_NOTIFICATION,
                        IDC_CTAB_UAV_FULLSCREEN,
                        IDC_CTAB_HCAM_FULLSCREEN
                    ]
                    + _dynamicFrameCtrls
                };
                case (_displayName isEqualTo QGVARMAIN(Android_dlg)) : {
                    [
                        3301, 3302, 3303, 3304, 3305, 3306, 3307,
                        IDC_CTAB_MARKER_MENU_MAIN,
                        IDC_CTAB_GROUP_MENU,
                        IDC_CTAB_GROUP_MESSAGE,
                        IDC_CTAB_GROUP_COMPOSE,
                        IDC_CTAB_SCREEN,
                        IDC_CTAB_SCREEN_TOPO,
                        IDC_CTAB_OSD_HOOK_GRID,
                        IDC_CTAB_OSD_HOOK_ELEVATION,
                        IDC_CTAB_OSD_HOOK_DST,
                        IDC_CTAB_OSD_HOOK_DIR,
                        IDC_CTAB_NOTIFICATION
                    ]
                };
                case (_displayName in [QGVARMAIN(FBCB2_dlg)]) : {
                    [
                        3301, 3303, 3304, 3305, 3306, 3307,
                        IDC_CTAB_MARKER_MENU_MAIN,
                        IDC_CTAB_NOTIFICATION,
                        IDC_CTAB_GROUP_MESSAGE,
                        IDC_CTAB_SCREEN,
                        IDC_CTAB_SCREEN_TOPO,
                        IDC_CTAB_OSD_HOOK_GRID,
                        IDC_CTAB_OSD_HOOK_ELEVATION,
                        IDC_CTAB_OSD_HOOK_DST,
                        IDC_CTAB_OSD_HOOK_DIR
                    ]
                };
                case (_displayName in [QGVARMAIN(TAD_dlg)]) : {
                    [
                        3301, 3302, 3303, 3304, 3305, 3306, 3307,
                        IDC_CTAB_MARKER_MENU_MAIN,
                        IDC_CTAB_NOTIFICATION
                    ]
                };
                default {[IDC_CTAB_NOTIFICATION]};
            };
            if !(_displayItems isEqualTo []) then {
                private _btnActCtrl = _display displayCtrl IDC_CTAB_BTNACT;
                private _displayItemsToShow = [];

                switch (_mode) do {
                    // ---------- DESKTOP -----------
                    case (QSETTING_MODE_DESKTOP) : {
                        _displayItemsToShow pushback IDC_CTAB_GROUP_DESKTOP;
                        _btnActCtrl ctrlSetText "";
                        _btnActCtrl ctrlSetTooltip "";
                    };
                    // ---------- BFT -----------
                    case (QSETTING_MODE_BFT) : {
                        _displayItemsToShow pushBack ([
                            [
                                _displayName,
                                QSETTING_MAP_TYPES
                            ] call FUNC(getSettings),
                            [
                                _displayName,
                                QSETTING_CURRENT_MAP_TYPE
                            ] call FUNC(getSettings)
                        ] call BIS_fnc_getFromPairs);

                        private _mapTools = [
                                _displayName,
                                QSETTING_MAP_TOOLS
                            ] call FUNC(getSettings);
                        if (!isNil "_mapTools" && {_mapTools}) then {
                            _displayItemsToShow append [
                                IDC_CTAB_OSD_HOOK_GRID,
                                IDC_CTAB_OSD_HOOK_ELEVATION,
                                IDC_CTAB_OSD_HOOK_DST,
                                IDC_CTAB_OSD_HOOK_DIR
                            ];
                        };

                        //CC: this is 100% android specific code >
                        private _showMenu = [
                                _displayName,
                                QSETTING_SHOW_MENU
                            ] call FUNC(getSettings);
                        if (!isNil "_showMenu" && {_showMenu}) then {
                            _displayItemsToShow pushBack IDC_CTAB_GROUP_MENU;
                        }; //<

                        _btnActCtrl ctrlSetTooltip "";
                        // update scale and world position when not on interface init
                        if !(_interfaceInit) then {
                            if (_isDialog) then {
                                [
                                    _displayName,
                                    [
                                        [
                                            QSETTING_MAP_SCALE_DIALOG,
                                            [
                                                _displayName,
                                                QSETTING_MAP_SCALE_DIALOG
                                            ] call FUNC(getSettings)
                                        ],
                                        [
                                            QSETTING_MAP_WORLD_POS,
                                            [
                                                _displayName,
                                                QSETTING_MAP_WORLD_POS
                                            ] call FUNC(getSettings)
                                        ]
                                    ],
                                    true,
                                    true
                                ] call FUNC(setSettings);
                            };
                        };
                    };
                    // ---------- UAV -----------
                    case (QSETTING_MODE_CAM_UAV) : {
                        [QSETTING_CAM_UAV_FULL] call FUNC(deleteUAVCam);
                        [] call FUNC(deleteHelmetCam);

                        [] call FUNC(updateListControlUAV);
                        private _currentMapIDC = [
                            [
                                _displayName,
                                QSETTING_MAP_TYPES
                            ] call FUNC(getSettings),
                            [
                                _displayName,
                                QSETTING_CURRENT_MAP_TYPE
                            ] call FUNC(getSettings)
                        ] call BIS_fnc_getFromPairs;

                        _displayItemsToShow append [
                            IDC_CTAB_GROUP_UAV_SOURCE_GRP,
                            _currentMapIDC
                        ];

                        _btnActCtrl ctrlSetTooltip "View Gunner Optics";
                        {
                            private _camID = _x;
                            _y params ["_camIdx", "_camSettingName", "_idc"];
                            private _uavNetID = [
                                _displayName,
                                _camSettingName
                            ] call FUNC(getSettings);
                            [
                                _displayName,
                                [
                                    [
                                        _camSettingName,
                                        _uavNetID
                                    ]
                                ],
                                true,
                                true
                            ] call FUNC(setSettings);

                            if(_uavNetID isNotEqualTo "") then {
                                _displayItemsToShow pushBack _idc;
                            };
                        } foreach GVAR(uavCamSettings);

                        // update scale and world position when not on interface init
                        if !(_interfaceInit) then {
                            if (_isDialog) then {
                                [
                                    _displayName,
                                    [
                                        [
                                            QSETTING_MAP_SCALE_DIALOG,
                                            [
                                                _displayName,
                                                QSETTING_MAP_SCALE_DIALOG
                                            ] call FUNC(getSettings)
                                        ],
                                        [
                                            QSETTING_MAP_WORLD_POS,
                                            [
                                                _displayName,
                                                QSETTING_MAP_WORLD_POS
                                            ] call FUNC(getSettings)
                                        ]
                                    ],
                                    true,
                                    true
                                ] call FUNC(setSettings);
                            };
                        };
                    };
                    // ---------- HCAM CAM -----------
                    case (QSETTING_MODE_CAM_HCAM) : {
                        [] call FUNC(deleteUAVCam);
                        [QSETTING_CAM_HCAM_FULL] call FUNC(deleteHelmetCam);

                        [] call FUNC(updateListControlHelmetCams);
                        private _currentMapIDC = [
                            [
                                _displayName,
                                QSETTING_MAP_TYPES
                            ] call FUNC(getSettings),
                            [
                                _displayName,
                                QSETTING_CURRENT_MAP_TYPE
                            ] call FUNC(getSettings)
                        ] call BIS_fnc_getFromPairs;

                        _displayItemsToShow append [
                            IDC_CTAB_GROUP_HCAM_SOURCE_GRP,
                            _currentMapIDC
                        ];

                        _btnActCtrl ctrlSetTooltip "Toggle Fullscreen";
                        {
                            private _camID = _x;
                            _y params ["_camIdx", "_camSettingName", "_idc"];
                            private _unitNetID = [
                                _displayName,
                                _camSettingName
                            ] call FUNC(getSettings);
                            [
                                _displayName,
                                [
                                    [
                                        _camSettingName,
                                        _unitNetID
                                    ]
                                ],
                                true,
                                true
                            ] call FUNC(setSettings);

                            if(_unitNetID isNotEqualTo "") then {
                                _displayItemsToShow pushBack _idc;
                            };
                        } foreach GVAR(helmetCamSettings);

                        if !(_interfaceInit) then {
                            if (_isDialog) then {
                                [
                                    _displayName,
                                    [
                                        [
                                            QSETTING_MAP_SCALE_DIALOG,
                                            [
                                                _displayName,
                                                QSETTING_MAP_SCALE_DIALOG
                                            ] call FUNC(getSettings)
                                        ],
                                        [
                                            QSETTING_MAP_WORLD_POS,
                                            [
                                                _displayName,
                                                QSETTING_MAP_WORLD_POS
                                            ] call FUNC(getSettings)
                                        ]
                                    ],
                                    true,
                                    true
                                ] call FUNC(setSettings);
                            };
                        };
                    };
                    // ---------- FULLSCREEN UAV GUNNER -----------
                    case (QSETTING_MODE_CAM_UAV_FULL) : {
                        [] call FUNC(deleteUAVCam);
                        [] call FUNC(deleteHelmetCam);

                        _displayItemsToShow pushBack IDC_CTAB_UAV_FULLSCREEN;
                        private _data = [
                                _displayName,
                                QSETTING_CAM_UAV_SELECTED
                            ] call FUNC(getSettings);
                        [
                            _displayName,
                            [
                                [QSETTING_CAM_UAV_FULL, _data]
                            ],
                            true,
                            true
                        ] call FUNC(setSettings);
                        [] call FUNC(updateListControlUAV);
                        private _uav = _data call BIS_fnc_objectFromNetId;

                        _btnActCtrl ctrlSetTooltip "Toggle Fullscreen";
                        [
                            _uav,
                            QSETTING_CAM_UAV_FULL
                        ] spawn FUNC(createUavCam);
                    };
                    // ---------- FULLSCREEN HCAM CAM -----------
                    case (QSETTING_MODE_CAM_HCAM_FULL) : {
                        [] call FUNC(deleteUAVCam);
                        [] call FUNC(deleteHelmetCam);

                        _displayItemsToShow pushBack IDC_CTAB_HCAM_FULLSCREEN;
                        private _data = [
                                _displayName,
                                QSETTING_CAM_HCAM_SELECTED
                            ] call FUNC(getSettings);
                        [
                            _displayName,
                            [
                                [QSETTING_CAM_HCAM_FULL, _data]
                            ],
                            true,
                            true
                        ] call FUNC(setSettings);
                        [] call FUNC(updateListControlHelmetCams);
                        private _unit = _data call BIS_fnc_objectFromNetId;

                        _btnActCtrl ctrlSetTooltip "Toggle Fullscreen";
                        [
                            _unit,
                            QSETTING_CAM_HCAM_FULL
                        ] spawn FUNC(createHelmetCam);
                    };
                    // ---------- MESSAGING -----------
                    case (QSETTING_MODE_MESSAGES) : {
                        _displayItemsToShow pushBack IDC_CTAB_GROUP_MESSAGE;
                        [] call FUNC(messagingLoadGUI);
                        GVAR(RscLayerMailNotification) cutText ["", "PLAIN"];
                        _btnActCtrl ctrlSetTooltip "";
                    };
                    // ---------- MESSAGING COMPOSE -----------
                    case (QSETTING_MODE_MESSAGES_COMPOSE) : {
                        _displayItemsToShow pushBack IDC_CTAB_GROUP_COMPOSE;
                        [] call FUNC(messagingLoadGUI);
                    };
                };

                private _shownControls = [];
                private _hiddenControls = [];
                private _invalidControls = [];

                _displayItemsToShow = _displayItemsToShow arrayIntersect _displayItemsToShow;
                // hide every _displayItems not in _displayItemsToShow
                {
                    private _control = (_display displayCtrl _x);
                    private _shown = _x in _displayItemsToShow;
                    if(isNil "_control" || isNull _control) then {
                        _invalidControls pushBack _x;
                    } else {
                        if(! (_control in _shownControls) && ! (_control in _hiddenControls)) then {
                            ([_hiddenControls, _shownControls] select _shown) pushBack _control;
                        };
                        
                    };
                    _control ctrlShow _shown;
                } foreach _displayItems;

////////////////////// really ugly deug stuff ////////////////////////
                private _fnc_debugItems = {
                    params ["_shownControls", "_hiddenControls", "_invalidControls", "_displayItems", "_displayItemsToShow"];
                diag_log format ["Setting up Control visibility"];
                diag_log format ["to show: %1", _displayItemsToShow];
                diag_log format ["total known: %1", _displayItems];

                    private _hiddenControlsString = (_hiddenControls apply { format ["[%2] (%1)", ctrlClassName _x, _x]}) joinString endl;
                    if(count _invalidControls > 0) then {
                        ["Found invalid control IDC during interface update:
            %1", _invalidControls joinString ", "] call FUNCMAIN(debugLog);
                    };
                    private _shownControlsString = (_shownControls apply { format ["
            [%2] (%1)", ctrlClassName _x, _x]}) joinString "";
                    ["    Interface Update
            Mode:   %1

        Controls shown:
            %2", _mode, _shownControlsString] call FUNCMAIN(debugLog);
                    ["        Controls hidden:
    %1", _hiddenControlsString] call FUNCMAIN(debugLog);
                };

                //[_shownControls, _hiddenControls, _invalidControls, _displayItems, _displayItemsToShow] call _fnc_debugItems;
//////////////////////////////////////////////

            };
        };
        // ------------ SHOW ICON TEXT ------------
        case (QSETTING_SHOW_ICON_TEXT) : {
            private _osdCtrl = _display displayCtrl IDC_CTAB_OSD_TXT_TGGL;
            if !(isNull _osdCtrl) then {
                private _text = if (_value) then {"ON"} else {"OFF"};
                _osdCtrl ctrlSetText _text;
            };
        };
        // ------------ MAP SCALE DSP------------
        case (QSETTING_MAP_SCALE_DISPLAY) : {
            if (_mode isEqualTo QSETTING_MODE_BFT && !_isDialog) then {
                private _mapScaleKm = _value;
                // pre-Calculate map scales
                private _mapScaleMin = [
                        _displayName,
                        QSETTING_MAP_SCALE_MIN
                    ] call FUNC(getSettings);
                private _mapScaleMax = [
                        _displayName,
                        QSETTING_MAP_SCALE_MAX
                    ] call FUNC(getSettings);

                // pick the next best scale that is an even multiple of the minimum map scale... It does tip in favour of the larger scale due to the use of logarithm, so its not perfect
                _mapScaleKm = _mapScaleMin * 2 ^ round (log (_mapScaleKm / _mapScaleMin) / log (2));
                _mapScaleKm = [_mapScaleMin, _mapScaleMin, _mapScaleMax] call BIS_fnc_clamp;

                if (_mapScaleKm != (_value)) then {
                    [
                        _displayName,
                        [
                            [QSETTING_MAP_SCALE_DISPLAY, _mapScaleKm]
                        ],
                        false
                    ] call FUNC(setSettings);
                };
                GVAR(mapScale) = _mapScaleKm / GVAR(mapScaleFactor);

                private _osdCtrl = _display displayCtrl IDC_CTAB_OSD_MAP_SCALE;
                if !(isNull _osdCtrl) then {
                    // divide by 2 because we want to display the radius, not the diameter
                    private _mapScaleTxt = if (_mapScaleKm > 1) then {
                            _mapScaleKm / 2
                    } else {
                        [_mapScaleKm / 2, 0, 1] call CBA_fnc_formatNumber
                    };
                    _osdCtrl ctrlSetText format ["%1", _mapScaleTxt];
                };
            };
        };
        // ------------ MAP SCALE DLG------------
        case (QSETTING_MAP_SCALE_DIALOG) : {
            if (_mode isEqualTo QSETTING_MODE_BFT && _isDialog) then {
                private _mapScaleKm = _value;
                _targetMapScale = _mapScaleKm / GVAR(mapScaleFactor) * 0.86 / (safezoneH * 0.8);
            };
        };
        // ------------ MAP WORLD POSITION ------------
        case (QSETTING_MAP_WORLD_POS) : {
            if (_mode in [QSETTING_MODE_BFT, QSETTING_MODE_CAM_UAV, QSETTING_MODE_CAM_HCAM]) then {
                if (_isDialog) then {
                    _mapWorldPos = _value;
                    if !(_mapWorldPos isEqualTo []) then {
                        _targetMapWorldPos = _mapWorldPos;
                    };
                };
            };
        };
        // ------------ FOLLOW UAV POSITION ------------
        case (QSETTING_FOLLOW_UAV) : {
            if (_mode isEqualTo QSETTING_MODE_CAM_UAV) then {
                if (_isDialog) then {
                    GVAR(trackCurrentUAV) = _value;
                };
            };
        };
        // ------------ FOLLOW HCAM POSITION ------------
        case (QSETTING_FOLLOW_HCAM) : {
            if (_mode isEqualTo QSETTING_MODE_CAM_HCAM) then {
                if (_isDialog) then {
                    GVAR(trackCurrentHCam) = _value;
                };
            };
        };
        // ------------ MAP TYPE ------------
        case (QSETTING_CURRENT_MAP_TYPE) : {
            private _targetMapName = _value;
            private _mapTypes = [
                    _displayName,
                    QSETTING_MAP_TYPES
                ] call FUNC(getSettings);
            if ((count _mapTypes > 1) && (_mode in [QSETTING_MODE_BFT, QSETTING_MODE_CAM_UAV, QSETTING_MODE_CAM_HCAM])) then {

                _targetMapCtrl = _display displayCtrl ([
                    _mapTypes,
                    _targetMapName /*target map type name*/
                ] call BIS_fnc_getFromPairs);

                if (!_interfaceInit && _isDialog) then {
                    private _previousMapCtrl = controlNull;
                    {
                        private _previousMapIDC = _x # 1;
                        _previousMapCtrl = _display displayCtrl _previousMapIDC;
                        if (ctrlShown _previousMapCtrl) exitWith {};
                        _previousMapCtrl = controlNull;
                    } foreach _mapTypes;
                    // See if _targetMapCtrl is already being shown
                    if ((!ctrlShown _targetMapCtrl) && (_targetMapCtrl != _previousMapCtrl)) then {
                        // Update _targetMapCtrl to scale and position of _previousMapCtrl
                        if (isNil "_targetMapScale") then {_targetMapScale = ctrlMapScale _previousMapCtrl;};
                        if (isNil "_targetMapWorldPos") then {_targetMapWorldPos = [_previousMapCtrl] call FUNC(ctrlMapCenter)};
                    };
                };

                // Hide all unwanted map types
                {
                    if (_x select 0 isNotEqualTo _targetMapName) then {
                        (_display displayCtrl (_x select 1)) ctrlShow false;
                    };
                } foreach _mapTypes;

                // Update OSD element if it exists
                private _osdCtrl = _display displayCtrl IDC_CTAB_OSD_MAP_TGGL;
                if !(isNull _osdCtrl) then {_osdCtrl ctrlSetText _targetMapName;};

                // show correct map contorl
                if !(ctrlShown _targetMapCtrl) then {
                    _targetMapCtrl ctrlShow true;
                    // wait until map control is shown, otherwise we can get in trouble with ctrlMapAnimCommit later on, depending on timing
                    while {!ctrlShown _targetMapCtrl} do {};
                };
            };
        };
        // ------------ UAV CAM ------------
        case (QSETTING_CAM_UAV_0);
        case (QSETTING_CAM_UAV_1);
        case (QSETTING_CAM_UAV_2);
        case (QSETTING_CAM_UAV_3);
        case (QSETTING_CAM_UAV_4);
        case (QSETTING_CAM_UAV_5) : {
            if (_mode isNotEqualTo QSETTING_MODE_CAM_UAV) exitWith {};
            private _camSetting = GVAR(uavCamSettings) getOrDefault [_key, []];
            _camSetting params ["_camIdx", "_settingsName", "_idc"];

            private _uav = _value call BIS_fnc_objectFromNetId;
            private _frameGrp = _display displayCtrl _idc;
            if !(isNull _uav) then {
                [
                    _uav,
                    _settingsName
                ] spawn FUNC(createUavCam);
                _frameGrp ctrlShow true;
                [QGVAR(UAVSelected), [_uav]] call CBA_fnc_localEvent;
            } else {
                [_settingsName] call FUNC(deleteUAVcam);
                _frameGrp ctrlShow false;
                [] call FUNC(updateListControlUAV);
            };
        };
        case (QSETTING_CAM_UAV_FULL) : {
            if (_mode isNotEqualTo QSETTING_MODE_CAM_UAV_FULL) exitWith {};
            private _camSetting = GVAR(uavCamSettings) getOrDefault [_key, []];
            _camSetting params ["_camIdx", "_settingsName", "_uavNetID", "_idc"];

            private _uav = _value call BIS_fnc_objectFromNetId;
            if !(isNull _uav) then {
                [
                    _uav,
                    _settingsName
                ] spawn FUNC(createUavCam);
            } else {
                [_settingsName] call FUNC(deleteUAVcam);
                [QGVARMAIN(Tablet_dlg), [[QSETTING_MODE, QSETTING_MODE_CAM_UAV]]] call FUNC(setSettings);
            };
        };
        case (QSETTING_CAM_UAV_SELECTED) : {
            if !(_mode in [QSETTING_MODE_CAM_UAV, QSETTING_MODE_CAM_UAV_FULL]) exitWith {};
            private _uav = _value call BIS_fnc_objectFromNetId;
            GVAR(selectedUAV) = _uav;
        };
        // ------------ HCAM ------------
        case (QSETTING_CAM_HCAM_0);
        case (QSETTING_CAM_HCAM_1);
        case (QSETTING_CAM_HCAM_2);
        case (QSETTING_CAM_HCAM_3);
        case (QSETTING_CAM_HCAM_4);
        case (QSETTING_CAM_HCAM_5) : {
            if (_mode isNotEqualTo QSETTING_MODE_CAM_HCAM) exitWith {};
            private _camSetting = GVAR(helmetCamSettings) getOrDefault [_key, []];
            _camSetting params ["_camIdx", "_settingsName", "_idc"];

            private _unit = _value call BIS_fnc_objectFromNetId;
            private _frameGrp = _display displayCtrl _idc;
            if !(isNull _unit) then {
                [
                    _unit,
                    _settingsName
                ] spawn FUNC(createHelmetCam);
                _frameGrp ctrlShow true;
                [QGVAR(HelmetSelected), [_unit]] call CBA_fnc_localEvent;
            } else {
                [_settingsName] call FUNC(deleteHelmetCam);
                _frameGrp ctrlShow false;
                [] call FUNC(updateListControlHelmetCams);
            };
        };
        case (QSETTING_CAM_HCAM_FULL) : {
            if (_mode isNotEqualTo QSETTING_MODE_CAM_HCAM_FULL) exitWith {};
            private _camSetting = GVAR(helmetCamSettings) getOrDefault [_key, []];
            _camSetting params ["_camIdx", "_settingsName", "_unitNetID", "_idc"];

            private _unit = _value call BIS_fnc_objectFromNetId;
            if !(isNull _unit) then {
                [
                    _unit,
                    _settingsName
                ] spawn FUNC(createHelmetCam);
            } else {
                [_settingsName] call FUNC(deleteHelmetCam);
                [QGVARMAIN(Tablet_dlg), [[QSETTING_MODE, QSETTING_MODE_CAM_HCAM]]] call FUNC(setSettings);
            };
        };
        case (QSETTING_CAM_HCAM_SELECTED) : {
            if !(_mode in [QSETTING_MODE_CAM_HCAM, QSETTING_MODE_CAM_HCAM_FULL]) exitWith {};
            private _unit = _value call BIS_fnc_objectFromNetId;
            GVAR(selectedHCam) = _unit;
        };
        // ------------ MAP TOOLS ------------
        case (QSETTING_MAP_TOOLS) : {
            GVAR(drawMapTools) = _value;
            if (_mode isEqualTo QSETTING_MODE_BFT) then {
                private _osdCtrl = controlNull;
                if !(_displayName in [QGVARMAIN(TAD_dlg), QGVARMAIN(TAD_dsp)]) then {
                    {
                        _osdCtrl = _display displayCtrl _x;
                        if !(isNull _osdCtrl) then {
                            _osdCtrl ctrlShow GVAR(drawMapTools);
                        };
                    } foreach [IDC_CTAB_OSD_HOOK_GRID, IDC_CTAB_OSD_HOOK_DIR, IDC_CTAB_OSD_HOOK_DST, IDC_CTAB_OSD_HOOK_ELEVATION];
                };
                _osdCtrl = _display displayCtrl IDC_CTAB_OSD_HOOK_TGGL1;
                if !(isNull _osdCtrl) then {
                    private _text = if (_value) then {"OWN"} else {"CURS"};
                    _osdCtrl ctrlSetText _text;
                };
                _osdCtrl = _display displayCtrl IDC_CTAB_OSD_HOOK_TGGL2;
                if !(isNull _osdCtrl) then {
                    private _text = if (_value) then {"CURS"} else {"OWN"};
                    _osdCtrl ctrlSetText _text;
                };
            };
        };
        // ------------ MENU ------------
        case (QSETTING_SHOW_MENU) : {
            private _osdCtrl = _display displayCtrl IDC_CTAB_GROUP_MENU;
            if !(isNull _osdCtrl) then {
                if (_mode isEqualTo QSETTING_MODE_BFT) then {
                    _osdCtrl ctrlShow (_value);
                };
            };
        };
    };
    // ----------------------------------
} forEach _displaySettings;

// update scale and world position if we have to. If so, fill in the blanks and make the changes
if ((!isNil "_targetMapScale") || (!isNil "_targetMapWorldPos")) then {
    if (isNull _targetMapCtrl) then {
        _targetMapCtrl = _display displayCtrl ([
            [
                _displayName,
                QSETTING_MAP_TYPES
            ] call FUNC(getSettings),
            [
                _displayName,
                QSETTING_CURRENT_MAP_TYPE
            ] call FUNC(getSettings)
        ] call BIS_fnc_getFromPairs);
    };
    if (isNil "_targetMapScale") then {
        _targetMapScale = ctrlMapScale _targetMapCtrl;
    };
    if (isNil "_targetMapWorldPos") then {
        _targetMapWorldPos = [_targetMapCtrl] call FUNC(ctrlMapCenter);
    };
    _targetMapCtrl ctrlMapAnimAdd [0, _targetMapScale, _targetMapWorldPos];
    ctrlMapAnimCommit _targetMapCtrl;
    while {!(ctrlMapAnimDone _targetMapCtrl)} do {};
};

// now hide the "Loading" control since we are done
if !(isNull _loadingCtrl) then {
    // move mouse cursor to the center of the screen if its a dialog
    if (_interfaceInit && _isDialog) then {
        private _ctrlPos = ctrlPosition _loadingCtrl;
        // put the mouse position in the center of the screen
        private _mousePos = [(_ctrlPos select 0) + ((_ctrlPos select 2) / 2),(_ctrlPos select 1) + ((_ctrlPos select 3) / 2)];
        // delay moving the mouse cursor by one frame using a PFH, for some reason its not working without
        [
            {
                [_this select 1] call CBA_fnc_removePerFrameHandler;
                setMousePosition (_this select 0);
            },
            0,
            _mousePos
        ] call CBA_fnc_addPerFrameHandler;
    };

    _loadingCtrl ctrlShow false;
    while {ctrlShown _loadingCtrl} do {};
};

// call notification system
if (_interfaceInit) then {[] call FUNC(processNotifications)};

true
