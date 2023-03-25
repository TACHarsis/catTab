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
        0: ARRAY - Property pairs in the form of [["propertyName",propertyValue],[...]]
     
     Returns:
        BOOLEAN - Always true
     
     Example:
        [[[QSETTING_CURRENT_MAP_TYPE,QMAP_TYPE_SAT],[QSETTING_MAP_SCALE_DISPLAY,"4"]]] call Ctab_ui_fnc_updateInterface;
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
    _displaySettings = [_displayName] call FUNC(getSettings);
    _interfaceInit = true;
};

private _mode = _displaySettings get QSETTING_MODE;
if (isNil "_mode") then {
    _mode = [_displayName,QSETTING_MODE] call FUNC(getSettings);
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
            if(_isDialog) exitWith{};

            private _useAltPosition = _value;
            
            // get the current position of the background control
            private _backgroundPositionInfo = [_displayName] call FUNC(getBackgroundPosition);
            _backgroundPositionInfo params ["_curBackgroundPos", "_configBackgroundPos"];

            private _position = [
                profilenamespace getVariable [format["IGUI_%1_X",_displayName],_configBackgroundPos # 0 ],
                profilenamespace getVariable [format["IGUI_%1_Y",_displayName],_configBackgroundPos # 1 ]
            ];
            private _positionAlt = [
                profilenamespace getVariable format["IGUI_%1_alt_X",_displayName],
                profilenamespace getVariable format["IGUI_%1_alt_Y",_displayName]
            ];

            private _backgroundProxy = [_configBackgroundPos#0,_configBackgroundPos#1];
            private _offset = ([_position, _positionAlt] select _useAltPosition) vectorDiff _backgroundProxy;

            [_displayName, _offset] call FUNC(setInterfacePosition);
        };
        // ------------ DIALOG POSITION ------------
        case (QSETTING_POSITION_DIALOG) : {
            private _backgroundOffset = _value;
            if (_isDialog) then {
                if (_backgroundOffset isEqualTo []) then {
                    _backgroundOffset = if (_interfaceInit) then {
                            [0,0]
                        } else {
                            // reset to defaults
                            private _backgroundPosition = [_displayName] call FUNC(getBackgroundPosition);
                            [(_backgroundPosition select 1 select 0) - (_backgroundPosition select 0 select 0),(_backgroundPosition select 1 select 1) - (_backgroundPosition select 0 select 1)]
                        };
                };
                if !(_backgroundOffset isEqualTo [0,0]) then {
                    // move by offset
                    [_displayName,_backgroundOffset] call FUNC(setInterfacePosition);
                };
            };
        };
        // ------------ BRIGHTNESS ------------
        // Value ranges from 0 to 1, 0 being off and 1 being full brightness
        case (QSETTING_BRIGHTNESS) : {
            private _osdCtrl = _display displayCtrl IDC_CTAB_BRIGHTNESS;
            if !(isNull _osdCtrl) then {
                private _brightness = _value;
                private _nightMode = [_displayName,QSETTING_NIGHT_MODE] call FUNC(getSettings);
                // if we are running night mode, lower the brightness proportionally
                if !(isNil "_nightMode") then {
                    if (_nightMode isEqualTo 1 || {_nightMode isEqualTo 2 && (sunOrMoon < 0.2)}) then {_brightness = _brightness * 0.7};
                };
                _osdCtrl ctrlSetBackgroundColor [0,0,0,1 - _brightness];
            };
        };

        // ------------ NIGHT MODE ------------
        // 0 = day mode, 1 = night mode, 2 = automatic
        case (QSETTING_NIGHT_MODE) : {
            // transform nightMode into boolean
            private _nightMode = (_value isEqualTo 1 || {_value isEqualTo 2 && (sunOrMoon < 0.2)});
            private _background = switch (true) do {
                case (_displayName in [QGVARMAIN(TAD_dsp),QGVARMAIN(TAD_dlg)]) : {
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
                    [_displayName,[
                            [QSETTING_BRIGHTNESS,[_displayName,QSETTING_BRIGHTNESS] call FUNC(getSettings)]
                        ],true,true] call FUNC(setSettings);
                };
            };
        };

        // ------------ MODE ------------
        case (QSETTING_MODE) : {
            GVAR(userPos) = [];
            
            private _displayItems = switch (true) do {                
                case (_displayName isEqualTo QGVARMAIN(Tablet_dlg)) : {
                    [3301,3302,3303,3304,3305,3306,3307,
                    IDC_CTAB_MARKER_MENU_MAIN,
                    IDC_CTAB_GROUP_DESKTOP,
                    IDC_CTAB_GROUP_UAV_LIST,
                    IDC_CTAB_GROUP_UAV_VIDEO,
                    IDC_CTAB_GROUP_HCAM_VIDEO,
                    IDC_CTAB_GROUP_HCAM_LIST,
                    IDC_CTAB_GROUP_MESSAGE,
                    IDC_CTAB_MINIMAPBG,
                    //IDC_CTAB_HCAMMAP,
                    //IDC_CTAB_UAVMAP,
                    IDC_CTAB_SCREEN,
                    IDC_CTAB_SCREEN_TOPO,
                    IDC_CTAB_HCAM_FULL,
                    IDC_CTAB_UAVGUNNER_FULL,
                    IDC_CTAB_OSD_HOOK_GRID,
                    IDC_CTAB_OSD_HOOK_ELEVATION,
                    IDC_CTAB_OSD_HOOK_DST,
                    IDC_CTAB_OSD_HOOK_DIR,
                    IDC_CTAB_NOTIFICATION]
                };
                case (_displayName isEqualTo QGVARMAIN(Android_dlg)) : {
                    [3301,3302,3303,3304,3305,3306,3307,
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
                    IDC_CTAB_NOTIFICATION]
                };
                case (_displayName in [QGVARMAIN(FBCB2_dlg)]) : {
                    [3301,3302,3303,3304,3305,3306,3307,
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
                    [3301,3302,3303,3304,3305,3306,3307,
                    IDC_CTAB_MARKER_MENU_MAIN,
                    IDC_CTAB_NOTIFICATION]
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
                            [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
                            [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
                        ] call BIS_fnc_getFromPairs);
                        
                        private _mapTools = [_displayName,QSETTING_MAP_TOOLS] call FUNC(getSettings);
                        if (!isNil "_mapTools" && {_mapTools}) then {
                            _displayItemsToShow append [
                                IDC_CTAB_OSD_HOOK_GRID,
                                IDC_CTAB_OSD_HOOK_ELEVATION,
                                IDC_CTAB_OSD_HOOK_DST,
                                IDC_CTAB_OSD_HOOK_DIR
                            ];
                        };
                        
                        //CC: this is 100% android specific code >
                        private _showMenu = [_displayName,QSETTING_SHOW_MENU] call FUNC(getSettings);
                        if (!isNil "_showMenu" && {_showMenu}) then    {
                            _displayItemsToShow pushBack IDC_CTAB_GROUP_MENU;
                        }; //<
                        
                        _btnActCtrl ctrlSetTooltip "";
                        // update scale and world position when not on interface init
                        if !(_interfaceInit) then {
                            if (_isDialog) then {
                                [_displayName,[
                                        [QSETTING_MAP_SCALE_DIALOG,[_displayName,QSETTING_MAP_SCALE_DIALOG] call FUNC(getSettings)],
                                        [QSETTING_MAP_WORLD_POS,[_displayName,QSETTING_MAP_WORLD_POS] call FUNC(getSettings)]
                                    ],true,true] call FUNC(setSettings);
                            };
                        };
                    };
                    // ---------- UAV -----------
                    case (QSETTING_MODE_CAM_UAV) : {
                        _displayItemsToShow pushBack ([
                            [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
                            [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
                        ] call BIS_fnc_getFromPairs);

                        _displayItemsToShow append [
                            IDC_CTAB_GROUP_UAV_LIST
                            //IDC_CTAB_GROUP_UAV_VIDEO
                            //IDC_CTAB_MINIMAPBG,
                            //IDC_CTAB_UAVMAP
                        ];

                        if(!isNull GVAR(currentUAV)) then {
                            _displayItemsToShow pushBack IDC_CTAB_GROUP_UAV_VIDEO;
                        };
                        _btnActCtrl ctrlSetTooltip "View Gunner Optics";
                        [_displayName,[
                                [QSETTING_CAM_UAV,[_displayName,QSETTING_CAM_UAV] call FUNC(getSettings)]
                            ],true,true] call FUNC(setSettings);

                        // update scale and world position when not on interface init
                        if !(_interfaceInit) then {
                            if (_isDialog) then {
                                [_displayName,[
                                        [QSETTING_MAP_SCALE_DIALOG,[_displayName,QSETTING_MAP_SCALE_DIALOG] call FUNC(getSettings)],
                                        [QSETTING_MAP_WORLD_POS,[_displayName,QSETTING_MAP_WORLD_POS] call FUNC(getSettings)]
                                    ],true,true] call FUNC(setSettings);
                            };
                        };
                    };
                    // ---------- HELMET CAM -----------
                    case (QSETTING_MODE_CAM_HELMET) : {
                        _displayItemsToShow pushBack ([
                            [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
                            [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
                        ] call BIS_fnc_getFromPairs);

                        _displayItemsToShow append [
                            IDC_CTAB_GROUP_HCAM_LIST
                            // IDC_CTAB_MINIMAPBG,
                            // IDC_CTAB_HCAMMAP
                        ];
                        if(!isNil QGVAR(helmetCamData)) then {
                            _displayItemsToShow pushBack IDC_CTAB_GROUP_HCAM_VIDEO;
                        };
                        _btnActCtrl ctrlSetTooltip "Toggle Fullscreen";
                        [] call FUNC(updateListControlHelmetCams);
                        [_displayName,[
                                [QSETTING_CAM_HELMET,[_displayName,QSETTING_CAM_HELMET] call FUNC(getSettings)]
                            ],true,true] call FUNC(setSettings);

                        if !(_interfaceInit) then {
                            if (_isDialog) then {
                                [_displayName,[
                                        [QSETTING_MAP_SCALE_DIALOG,[_displayName,QSETTING_MAP_SCALE_DIALOG] call FUNC(getSettings)],
                                        [QSETTING_MAP_WORLD_POS,[_displayName,QSETTING_MAP_WORLD_POS] call FUNC(getSettings)]
                                    ],true,true] call FUNC(setSettings);
                            };
                        };
                    };
                    // ---------- FULLSCREEN UAV GUNNER -----------
                    case (QSETTING_MODE_CAM_UAVGUNNER_FULL) : {
                        _displayItemsToShow pushBack IDC_CTAB_UAVGUNNER_FULL;
                        private _data = [_displayName,QSETTING_CAM_UAV] call FUNC(getSettings);
                        _btnActCtrl ctrlSetTooltip "Toggle Fullscreen";
                        private _uavGunnerFullVideoImage = _display displayCtrl IDC_CTAB_UAVGUNNER_FULL;
                        [
                            (_data call BIS_fnc_objectFromNetId),
                            [
                                [1,"UAVGunnerFullRenderTarget",_uavGunnerFullVideoImage]
                            ]
                        ] spawn FUNC(createUAVCam);
                    };
                    // ---------- FULLSCREEN HELMET CAM -----------
                    case (QSETTING_MODE_CAM_HELMET_FULL) : {
                        _displayItemsToShow pushBack IDC_CTAB_HCAM_FULL;
                        private _data = [_displayName,QSETTING_CAM_HELMET] call FUNC(getSettings);
                        _btnActCtrl ctrlSetTooltip "Toggle Fullscreen";
                        private _helmetFullVideoImage = _display displayCtrl IDC_CTAB_HCAM_FULL;
                        ['helmetCamFullRenderTarget', _data, _helmetFullVideoImage, _helmetFullVideoImage] spawn FUNC(createHelmetCam);
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
                
                // hide every _displayItems not in _displayItemsToShow
                {(_display displayCtrl _x) ctrlShow (_x in _displayItemsToShow)} foreach _displayItems;
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
                private _mapScaleMin = [_displayName,QSETTING_MAP_SCALE_MIN] call FUNC(getSettings);
                private _mapScaleMax = [_displayName,QSETTING_MAP_SCALE_MAX] call FUNC(getSettings);

                // pick the next best scale that is an even multiple of the minimum map scale... It does tip in favour of the larger scale due to the use of logarithm, so its not perfect
                _mapScaleKm = _mapScaleMin * 2 ^ round (log (_mapScaleKm / _mapScaleMin) / log (2));
                _mapScaleKm = [_mapScaleMin, _mapScaleMin,_mapScaleMax] call BIS_fnc_clamp;
                
                if (_mapScaleKm != (_value)) then {
                    [_displayName,[
                            [QSETTING_MAP_SCALE_DISPLAY,_mapScaleKm]
                        ],false] call FUNC(setSettings);
                };
                GVAR(mapScale) = _mapScaleKm / GVAR(mapScaleFactor);
                
                private _osdCtrl = _display displayCtrl IDC_CTAB_OSD_MAP_SCALE;
                if !(isNull _osdCtrl) then {
                    // divide by 2 because we want to display the radius, not the diameter
                    private _mapScaleTxt = if (_mapScaleKm > 1) then {
                            _mapScaleKm / 2
                    } else {
                        [_mapScaleKm / 2,0,1] call CBA_fnc_formatNumber
                    };
                    _osdCtrl ctrlSetText format ["%1",_mapScaleTxt];    
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
            if (_mode in [QSETTING_MODE_BFT,QSETTING_MODE_CAM_UAV,QSETTING_MODE_CAM_HELMET]) then {
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
            if (_mode isEqualTo QSETTING_MODE_CAM_HELMET) then {
                if (_isDialog) then {
                    GVAR(trackCurrentHCam) = _value;
                };
            };
        };
        // ------------ MAP TYPE ------------
        case (QSETTING_CURRENT_MAP_TYPE) : {
            private _targetMapName = _value;
            private _mapTypes = [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings);
            if ((count _mapTypes > 1) && (_mode in [QSETTING_MODE_BFT,QSETTING_MODE_CAM_UAV,QSETTING_MODE_CAM_HELMET])) then {
                
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
        case (QSETTING_CAM_UAV) : {
            if (_mode isNotEqualTo QSETTING_MODE_CAM_UAV) exitWith {};
            private _gunnerRenderTarget = switch (_mode) do {
                case (QSETTING_MODE_CAM_UAV) : {"uavGunnerRenderTarget"};
                case (QSETTING_MODE_CAM_UAVGUNNER_FULL) : {"UAVGunnerFullRenderTarget"};
                default {nil};
            };
            private _uav = _value call BIS_fnc_objectFromNetId;
            GVAR(currentUAV) = _uav;

            private _videoGroup = _display displayCtrl IDC_CTAB_GROUP_UAV_VIDEO;
            private _gunnerVideoImage = _display displayCtrl IDC_CTAB_UAVGUNNERDISPLAY;
            private _driverVideoImage = _display displayCtrl IDC_CTAB_UAVDRIVERDISPLAY;
            
            
            if !(isNull _uav) then {
                private _mapCtrl = _display displayCtrl ([
                            [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
                            [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
                        ] call BIS_fnc_getFromPairs);

                [
                    _uav,
                    [
                        [0,"uavDriverRenderTarget",_driverVideoImage],
                        [1,_gunnerRenderTarget,_gunnerVideoImage]
                    ]
                ] spawn FUNC(createUavCam);
                _videoGroup ctrlShow true;
            } else {
                [] call FUNC(deleteUAVcam);
                _videoGroup ctrlShow false;
            };
            [QGVAR(UAVSelected), [GVAR(currentUAV)]] call CBA_fnc_localEvent;
        };
        // ------------ HCAM ------------
        case (QSETTING_CAM_HELMET) : {
            if (_mode isNotEqualTo QSETTING_MODE_CAM_HELMET) exitWith {};
            private _renderTarget = switch (_mode) do {
                case (QSETTING_MODE_CAM_HELMET) : {"helmetCamRenderTarget"};
                case (QSETTING_MODE_CAM_HELMET_FULL) : {"helmetCamFullRenderTarget"};
                default {nil};
            };
            if (isNil "_renderTarget") exitWith {};
            
            private _videoGroup = _display displayCtrl IDC_CTAB_GROUP_HCAM_VIDEO;
            private _helmetVideoImage = _display displayCtrl IDC_CTAB_HCAMDISPLAY;
            private _helmetVideoControl = _display displayCtrl IDC_CTAB_HCAMCONTROLLAYER;

            private _unit = _value call BIS_fnc_objectFromNetId;
            if (!isNull _unit) then {
                [_renderTarget,_value,_helmetVideoImage, _helmetVideoControl] spawn FUNC(createHelmetCam);
                _videoGroup ctrlShow true;
            } else {
                [] call FUNC(deleteHelmetCam);
                _videoGroup ctrlShow false;
            };
        };
        // ------------ MAP TOOLS ------------
        case (QSETTING_MAP_TOOLS) : {
            GVAR(drawMapTools) = _value;
            if (_mode isEqualTo QSETTING_MODE_BFT) then {
                private _osdCtrl = controlNull;
                if !(_displayName in [QGVARMAIN(TAD_dlg),QGVARMAIN(TAD_dsp)]) then {
                    {
                        _osdCtrl = _display displayCtrl _x;
                        if !(isNull _osdCtrl) then {
                            _osdCtrl ctrlShow GVAR(drawMapTools);
                        };
                    } foreach [IDC_CTAB_OSD_HOOK_GRID,IDC_CTAB_OSD_HOOK_DIR,IDC_CTAB_OSD_HOOK_DST,IDC_CTAB_OSD_HOOK_ELEVATION];
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
            [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
            [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
        ] call BIS_fnc_getFromPairs);
    };
    if (isNil "_targetMapScale") then {
        _targetMapScale = ctrlMapScale _targetMapCtrl;
    };
    if (isNil "_targetMapWorldPos") then {
        _targetMapWorldPos = [_targetMapCtrl] call FUNC(ctrlMapCenter);
    };
    _targetMapCtrl ctrlMapAnimAdd [0,_targetMapScale,_targetMapWorldPos];
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
        [{
            [_this select 1] call CBA_fnc_removePerFrameHandler;
            setMousePosition (_this select 0);
        },0,_mousePos] call CBA_fnc_addPerFrameHandler;
    };
    
    _loadingCtrl ctrlShow false;
    while {ctrlShown _loadingCtrl} do {};
};

// call notification system
if (_interfaceInit) then {[] call FUNC(processNotifications)};

true
