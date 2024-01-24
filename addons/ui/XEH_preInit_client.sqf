#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.
#include "devices\shared\cTab_defines.hpp"

// Exit if this is machine has no interface, i.e. is a headless client (HC)
if !(hasInterface) exitWith {};

// Get a rsc layer for for our displays
GVAR(RscLayer) = [QUOTE(PREFIX)] call BIS_fnc_rscLayer;
GVAR(RscLayerMailNotification) = [GVAR(mailNotification)] call BIS_fnc_rscLayer;

// Set up user markers
GVAR(userMarkerTransactionId) = -1;
GVAR(userMarkerLists) = createHashMap;
GVAR(userMarkerListTranslated) = [];
[player] remoteExec [QFUNC(userMarkerListGetServer), 2];

GVAR(displayPropertyGroups) = createHashMapFromArray [
    [QGVARMAIN(Tablet_dlg),     QSETTINGS_TABLET],
    [QGVARMAIN(Android_dlg),    QSETTINGS_ANDROID],
    [QGVARMAIN(Android_dsp),    QSETTINGS_ANDROID],
    [QGVARMAIN(FBCB2_dlg),      QSETTINGS_FBCB2],
    [QGVARMAIN(TAD_dsp),        QSETTINGS_TAD],
    [QGVARMAIN(TAD_dlg),        QSETTINGS_TAD],
    [QGVARMAIN(microDAGR_dsp),  QSETTINGS_MICRODAGR],
    [QGVARMAIN(microDAGR_dlg),  QSETTINGS_MICRODAGR]
];

[] call FUNC(initializeDeviceMapSettings);


GVAR(mapScaleInitialized) = false;
[] call FUNC(initializeMapScale);

[
    { GVAR(mapScaleInitialized)    },
    {
        [] call FUNC(initializeDeviceSettings);
    }
] call CBA_fnc_waitUntilAndExecute;
// set air contact  color to purple
GVAR(airContactColor) = [255/255, 0/255, 255/255, 1];
// set misc color to neon yellow (CC: used for helmet cam and uav icon in their respective views, but also for the highlighted user marker!!?)
GVAR(miscColor) = [243/255, 243/255, 21/255, 1];
// vehicle icon color is neon green
GVAR(mapToolsPlayerVehicleIconColor) = [57/255, 255/255, 20/255, 1];
// direction arrow / hook is neon yellow
GVAR(mapToolsHookColor) = [243/255, 243/255, 21/255, 1];
// set TAD own icon color to neon green
GVAR(TADOwnSideColor) = [57/255, 255/255, 20/255, 1];

GVAR(selectedUAVColor) = [0,1,0,1];

// set base colors from BI -- Helps keep colors matching if user changes colors in options.
GVAR(colorBLUFOR) = [
    profilenamespace getvariable ['Map_BLUFOR_R',0],
    profilenamespace getvariable ['Map_BLUFOR_G',1],
    profilenamespace getvariable ['Map_BLUFOR_B',1],
    profilenamespace getvariable ['Map_BLUFOR_A',0.8]
];

GVAR(colorOPFOR) = [
    profilenamespace getvariable ['Map_OPFOR_R',0],
    profilenamespace getvariable ['Map_OPFOR_G',1],
    profilenamespace getvariable ['Map_OPFOR_B',1],
    profilenamespace getvariable ['Map_OPFOR_A',0.8]
];

GVAR(colorINDEPENDENT) = [
    profilenamespace getvariable ['Map_Independent_R',0],
    profilenamespace getvariable ['Map_Independent_G',1],
    profilenamespace getvariable ['Map_Independent_B',1],
    profilenamespace getvariable ['Map_Independent_A',0.8]
];

// Define Fire-Team colors
// MAIN,RED,GREEN,BLUE,YELLOW
GVAR(teamColors) = [
    [0,0,200/255,0.8], // Fireteam Blue
    [200/255,0,0,0.8], // Fireteam Red
    [0,199/255,0,0.8], // Fireteam Green
    [0,0,200/255,0.8], // Fireteam Blue
    [225/255,225/255,0,0.8] // Fireteam Yellow
];

GVAR(UAVLineColor) = [1,1,1,1];
GVAR(UAVLineColorSelected) = [1,0,0.5,1];

// set icon size of own vehicle
GVAR(ownVehicleIconBaseSize) = 18;
GVAR(ownVehicleIconScaledSize) = GVAR(ownVehicleIconBaseSize) / (0.86 / (safezoneH * 0.8));

// Draw Map Tolls (Hook)
GVAR(drawMapTools) = false;
GVAR(mapToolsRangeFormatThreshold) = 750;


// Base defines.
GVAR(uavViewActive) = false;
GVAR(UAVCamsData) = createHashMap;
GVAR(HelmetCamsData) = createHashMap;
GVAR(cursorOnMap) = false;
GVAR(mapCursorPos) = [0,0];
GVAR(mapWorldPos) = [];
GVAR(mapScale) = 0.5;

// Initialize all uiNamespace variables
uiNamespace setVariable [QGVARMAIN(Tablet_dlg),     displayNull];
uiNamespace setVariable [QGVARMAIN(Android_dlg),    displayNull];
uiNamespace setVariable [QGVARMAIN(Android_dsp),    displayNull];
uiNamespace setVariable [QGVARMAIN(FBCB2_dlg),      displayNull];
uiNamespace setVariable [QGVARMAIN(TAD_dsp),        displayNull];
uiNamespace setVariable [QGVARMAIN(TAD_dlg),        displayNull];
uiNamespace setVariable [QGVARMAIN(microDAGR_dsp),  displayNull];
uiNamespace setVariable [QGVARMAIN(microDAGR_dlg),  displayNull];

// Ctab_ui_openStart will be set to true while interface is starting and prevent further open attempts
GVAR(openStart) = false;

GVAR(msgReceiveEHID) = [
    QGVARMAIN(msg_receive), // id kept for potential backwards compatibility
    FUNC(messagingOnMessageReceived)
] call CBA_fnc_addEventHandler;

GVAR(uavCamSettings) = createHashMapFromArray [
    [QSETTING_CAM_UAV_0, [0, QSETTING_CAM_UAV_0, IDC_CTAB_UAV_FRAME_0 + 0]],
    [QSETTING_CAM_UAV_1, [1, QSETTING_CAM_UAV_1, IDC_CTAB_UAV_FRAME_0 + 1]],
    [QSETTING_CAM_UAV_2, [2, QSETTING_CAM_UAV_2, IDC_CTAB_UAV_FRAME_0 + 2]],
    [QSETTING_CAM_UAV_3, [3, QSETTING_CAM_UAV_3, IDC_CTAB_UAV_FRAME_0 + 3]],
    [QSETTING_CAM_UAV_4, [4, QSETTING_CAM_UAV_4, IDC_CTAB_UAV_FRAME_0 + 4]],
    [QSETTING_CAM_UAV_5, [5, QSETTING_CAM_UAV_5, IDC_CTAB_UAV_FRAME_0 + 5]],
    [QSETTING_CAM_UAV_FULL, [-1, QSETTING_CAM_UAV_FULL, -9999]]
];

GVAR(helmetCamSettings) = createHashMapFromArray [
    [QSETTING_CAM_HCAM_0, [0, QSETTING_CAM_HCAM_0, IDC_CTAB_HCAM_FRAME_0 + 0]],
    [QSETTING_CAM_HCAM_1, [1, QSETTING_CAM_HCAM_1, IDC_CTAB_HCAM_FRAME_0 + 1]],
    [QSETTING_CAM_HCAM_2, [2, QSETTING_CAM_HCAM_2, IDC_CTAB_HCAM_FRAME_0 + 2]],
    [QSETTING_CAM_HCAM_3, [3, QSETTING_CAM_HCAM_3, IDC_CTAB_HCAM_FRAME_0 + 3]],
    [QSETTING_CAM_HCAM_4, [4, QSETTING_CAM_HCAM_4, IDC_CTAB_HCAM_FRAME_0 + 4]],
    [QSETTING_CAM_HCAM_5, [5, QSETTING_CAM_HCAM_5, IDC_CTAB_HCAM_FRAME_0 + 5]],
    [QSETTING_CAM_HCAM_FULL, [-1, QSETTING_CAM_HCAM_FULL, -9999]]
];

GVAR(uavCamSettingsNames) = [QSETTING_CAM_UAV_0, QSETTING_CAM_UAV_1, QSETTING_CAM_UAV_2, QSETTING_CAM_UAV_3, QSETTING_CAM_UAV_4, QSETTING_CAM_UAV_5, QSETTING_CAM_UAV_FULL];
GVAR(hCamSettingsNames) = [QSETTING_CAM_HCAM_0, QSETTING_CAM_HCAM_1, QSETTING_CAM_HCAM_2, QSETTING_CAM_HCAM_3, QSETTING_CAM_HCAM_4, QSETTING_CAM_HCAM_5, QSETTING_CAM_HCAM_FULL];

//TODO: change selected UAV/HCAM to netID instead? Or distinguish between the selected UAV/Unit and the selected UI element/source?
GVAR(selectedUAV) = objNull;
GVAR(selectedHCam) = objNull;
GVAR(trackCurrentUAV)= false;
GVAR(trackCurrentHCam) = false;

GVAR(notificationCache) = [];

GVAR(bftMemberIcons) = [];
GVAR(bftMemberListUpdateEHID) = [
    QEGVAR(core,bftMemberListUpdate),
    FUNC(updateBFTMemberIconList)
] call CBA_fnc_addEventHandler;

GVAR(bftGroupIcons) = [];
GVAR(bftGroupListUpdateEHID) = [
    QEGVAR(core,bftGroupListUpdate),
    FUNC(updateBFTGroupIconList)
] call CBA_fnc_addEventHandler;

GVAR(bftVehicleIcons) = [];
GVAR(bftVehicleListUpdateEHID) = [
    QEGVAR(core,bftVehicleListUpdate),
    FUNC(updateBFTVehicleIconList)
] call CBA_fnc_addEventHandler;

GVAR(sourceRemovedSlotBuffer) = [];

[
    QEGVAR(core,videoSourceRemoved),
    {
        params ["_type", "_sourceData"];
        //TAG: video source data
        _sourceData params ["_unitNetID", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];

        private _context = GVAR(videoSourcesContext) get _type;
        private _settingsNames = _context get QGVAR(slotSettingsNames);
        private _displayName = GVAR(ifOpen) select 1;
        private _selectedSettingsNames = _settingsNames select {
            private _settingName = _x;
            private _data = [_displayName, _settingName] call FUNC(getSettings);
            (_data isEqualTo _unitNetID)
        };
        if(_selectedSettingsNames isNotEqualTo []) then {
            GVAR(sourceRemovedSlotBuffer) pushBackUnique [_unitNetID, _selectedSettingsNames, _displayName];
        };

        [_type, true] call FUNC(updateListControls);
    }
] call CBA_fnc_addEventHandler;

[
    QEGVAR(core,videoSourceAdded),
    {
        params ["_type", "_sourceData"];
        [_type, true] call FUNC(updateListControls);
    }
] call CBA_fnc_addEventHandler;

[
    QEGVAR(core,videoSourceReplaced),
    {
        params ["_oldUnitNetID", "_newUnitNetID"];
        private _idx = GVAR(sourceRemovedSlotBuffer) findIf {(_x # 0) isEqualTo _oldUnitNetID};
        if(_idx == -1) exitWith {};

        private _buffer = GVAR(sourceRemovedSlotBuffer) deleteAt _idx;
        _buffer params ["", "_selectedSettingsNames", "_displayName"];
        {
            private _settingName = _x;
            private _data = [_displayName, _settingName] call FUNC(getSettings);
            if(_data isEqualTo _newUnitNetID || {_data isNotEqualTo ""}) then {continue}; // don't replace a new selection and don't bother if we're already set
            [_displayName, [[_settingName, _newUnitNetID]]] call FUNC(setSettings);
            // diag_log format ["Replacing %1 with %2 in slot %3", _corpseNetID, _unitNetID, _settingName];
        } foreach _selectedSettingsNames;
    }
] call CBA_fnc_addEventHandler;


#include "setupVideoSourceContext.inc.sqf"

[
    QGVAR(UAVSelected),
    {
        params ["_newSources", "_removedSources", "_lostSources"];
        [VIDEO_FEED_TYPE_UAV] call FUNC(updateListControls);
    }
] call CBA_fnc_addEventHandler;

[
    QGVAR(HelmetSelected),
    {
        [VIDEO_FEED_TYPE_HCAM] call FUNC(updateListControls);
    }
] call CBA_fnc_addEventHandler;

[
    QEGVAR(core,playerChanged),
    {
        params ["_ctabPlayer"];

        // close any interface that might still be open
        [] call FUNC(close);
        // retrieve associate user markers
        [] call FUNC(userMarkerListUpdate);
        // remove msg notification
        GVAR(RscLayerMailNotification) cutText ["", "PLAIN"];
    }
] call CBA_fnc_addEventHandler;

[
    QEGVAR(core,deviceLost),
    {
        params ["_displayName"];
        // close interface that might still be open
        [] call FUNC(close)
    }
] call CBA_fnc_addEventHandler;

[
    QGVAR(remoteControlFailed),
    {
        params ["_errorMessage"];
        // show notification
        [QSETTING_MODE_CAM_UAV,_errorMessage,5] call FUNC(addNotification);
    }
] call CBA_fnc_addEventHandler;

GVAR(animatedCtrls) = [];

GVAR(heartbeatAnimationArray) = [
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u75_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u75_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u100_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u75_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u75_ca.paa"
];
GVAR(heartbeatDeathIcon) = "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\d100_ca.paa";

GVAR(statusStrings) = [
    LLSTRING(Video_Source_Status_Long_Offline),     //OFFLINE         0
    LLSTRING(Video_Source_Status_Long_Online),      //ONLINE          1
    LLSTRING(Video_Source_Status_Long_Destroyed),   //DESTROYED       2
    LLSTRING(Video_Source_Status_Long_Lost)         //LOST            3
];

#ifdef DEBUG_MODE_FULL
GVAR(uavSelectedEHID) = [
    QGVAR(UAVSelected),
    {
        params ["_uav"];
        if(isNull GVAR(selectedUAV) && !isNil QGVAR(uavDebugPFH)) then {
            GVAR(uavDebugPFH) call CBA_fnc_removePerFrameHandler;
            GVAR(uavDebugPFH) = nil;
        };

        if(!isNull GVAR(selectedUAV) && isNil QGVAR(uavDebugPFH)) then {
            GVAR(uavDebugPFH) = [{
                if(isNull Ctab_ui_currentUAV) exitWith {};
                params ["","_pfhID"];
                private _uav = GVAR(selectedUAV);

                private _uavViewData = [_uav] call FUNC(getUAVViewData);
                _uavViewData params ["_uavLookOrigin","_uavLookDir","_hitOccured","_aimPoint","_intersectRayTarget"];

                drawLine3D [_uavLookOrigin, _aimPoint, [1,0,0,1]];
                drawIcon3D ["\A3\ui_f\data\GUI\Cfg\KeyFrameAnimation\IconCamera_ca.paa", [1,1,1,1], _aimPoint, 0,0,0,format ["AimPoint: %1",_aimPoint]];
                drawIcon3D ["\A3\ui_f\data\GUI\Cfg\KeyFrameAnimation\IconCamera_ca.paa", [1,1,1,1],_uavLookOrigin, 0,0,0,format [" BegPos: %1", _uavLookOrigin]];
                drawIcon3D ["\A3\ui_f\data\GUI\Cfg\KeyFrameAnimation\IconCamera_ca.paa", [1,1,1,1],_uavLookOrigin vectorAdd _uavLookDir, 0,0,0,format ["Dir(rel)): %1", _dir]];
                drawIcon3D ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa", [1,1,1,1],_intersectRayTarget, 1,1,0,format ["RayTarget: %1", _intersectRayTarget]];
                drawLine3D [_uavLookOrigin, _uavLookOrigin vectorAdd _uavLookDir, [0,0,0,1]];
                drawLine3D [_uavLookOrigin, getPos player, [0,1,0,1]];
                drawLine3D [_uavLookOrigin, _intersectRayTarget, [0,0,1,1]];
            },0] call CBA_fnc_addPerFrameHandler;
        }
    }
] call CBA_fnc_addEventHandler;
#endif
