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
    [QGVARMAIN(Tablet_dlg),QSETTINGS_TABLET],
    [QGVARMAIN(Android_dlg),QSETTINGS_ANDROID],
    [QGVARMAIN(Android_dsp),QSETTINGS_ANDROID],
    [QGVARMAIN(FBCB2_dlg),QSETTINGS_FBCB2],
    [QGVARMAIN(TAD_dsp),QSETTINGS_TAD],
    [QGVARMAIN(TAD_dlg),QSETTINGS_TAD],
    [QGVARMAIN(microDAGR_dsp),QSETTINGS_MICRODAGR],
    [QGVARMAIN(microDAGR_dlg),QSETTINGS_MICRODAGR]
];
GVAR(mapScaleInitialized) = false;
[] call FUNC(initializeMapScale);
[
    { GVAR(mapScaleInitialized)    },
    {
        [] call FUNC(initializeSettings);
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
GVAR(TADOwnIconColor) = [57/255, 255/255, 20/255, 1];


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


// set icon size of own vehicle
GVAR(ownVehicleIconBaseSize) = 18;
GVAR(ownVehicleIconScaledSize) = GVAR(ownVehicleIconBaseSize) / (0.86 / (safezoneH * 0.8));

GVAR(textEnabled) = true;

// Draw Map Tolls (Hook)
GVAR(drawMapTools) = false;
GVAR(mapToolsRangeFormatThreshold) = 750;


// Base defines.
GVAR(uavViewActive) = false;
GVAR(uAVcams) = [];
GVAR(cursorOnMap) = false;
GVAR(mapCursorPos) = [0,0];
GVAR(mapWorldPos) = [];
GVAR(mapScale) = 0.5;

// Initialize all uiNamespace variables
uiNamespace setVariable [QGVARMAIN(Tablet_dlg), displayNull];
uiNamespace setVariable [QGVARMAIN(Android_dlg), displayNull];
uiNamespace setVariable [QGVARMAIN(Android_dsp), displayNull];
uiNamespace setVariable [QGVARMAIN(FBCB2_dlg), displayNull];
uiNamespace setVariable [QGVARMAIN(TAD_dsp), displayNull];
uiNamespace setVariable [QGVARMAIN(TAD_dlg), displayNull];
uiNamespace setVariable [QGVARMAIN(microDAGR_dsp), displayNull];
uiNamespace setVariable [QGVARMAIN(microDAGR_dlg), displayNull];

// Ctab_ui_openStart will be set to true while interface is starting and prevent further open attempts
GVAR(openStart) = false;

GVAR(msgReceiveEHID) = [
    QGVARMAIN(msg_receive), // id kept for potential backwards compatibility
    FUNC(messagingOnMessageReceived)
] call CBA_fnc_addEventHandler;

GVAR(currentUAV) = objNull;

GVAR(notificationCache) = [];

[] call FUNC(initSettings);


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

GVAR(uavListUpdateEHID) = [
    QEGVAR(core,uavListUpdate),
    FUNC(updateListControlUAV)
] call CBA_fnc_addEventHandler;

GVAR(helmetCamListUpdateEHID) = [
    QEGVAR(core,helmetCamListUpdate),
    FUNC(updateListControlHelmetCams)
] call CBA_fnc_addEventHandler;

GVAR(playerChangeEHID) = [
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

GVAR(deviceLostEHID) = [
    QEGVAR(core,deviceLost),
    {
        params ["_displayName"];
        // close interface that might still be open
        [] call FUNC(close)
    }
] call CBA_fnc_addEventHandler;

GVAR(remoteControlFailedEHID) = [
    QGVAR(remoteControlFailed),
    {
        params ["_errorMessage"];
        // show notification
        [QSETTING_MODE_CAM_UAV,_errorMessage,5] call FUNC(addNotification);
    }
]