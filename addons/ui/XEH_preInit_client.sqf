#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.
#include "devices\shared\cTab_gui_macros.hpp"

// Exit if this is machine has no interface, i.e. is a headless client (HC)
if !(hasInterface) exitWith {};

// Get a rsc layer for for our displays
GVAR(RscLayer) = ["cTab"] call BIS_fnc_rscLayer;
GVAR(RscLayerMailNotification) = ["cTab_mailNotification"] call BIS_fnc_rscLayer;

// Set up user markers
GVAR(userMarkerTransactionId) = -1;
GVAR(userMarkerLists) = [];
[] call FUNC(getUserMarkerList);

GVAR(getUserMarkerList) = [];

/*
Figure out the scaling factor based on the current map (island) being played
Requires the scale of the map control to be at 0.001
*/
call {
	private ["_displayName","_display","_mapCtrl","_mapScreenPos","_mapScreenX_left","_mapScreenH","_mapScreenY_top","_mapScreenY_middle","_mapWorldY_top","_mapWorldY_middle"];
	
	_displayName = QGVARMAIN(mapSize_dsp);
	GVAR(RscLayer) cutRsc [_displayName,"PLAIN",0, false];
	while {isNull (uiNamespace getVariable _displayName)} do {};
	_display = uiNamespace getVariable _displayName;
	_mapCtrl = _display displayCtrl 1110;

	// get the screen postition of _mapCtrl as [x, y, w, h]
	_mapScreenPos = ctrlPosition _mapCtrl;

	// Find the screen coordinate for the left side
	_mapScreenX_left = _mapScreenPos select 0;
	// Find the screen height
	_mapScreenH	= _mapScreenPos select 3;
	// Find the screen coordinate for top Y 
	_mapScreenY_top = _mapScreenPos select 1;
	// Find the screen coordinate for middle Y 
	_mapScreenY_middle = _mapScreenY_top + _mapScreenH / 2;

	// Get world coordinate for top Y in meters
	_mapWorldY_top = (_mapCtrl ctrlMapScreenToWorld [_mapScreenX_left,_mapScreenY_top]) select 1;
	// Get world coordinate for middle Y in meters
	_mapWorldY_middle = (_mapCtrl ctrlMapScreenToWorld [_mapScreenX_left,_mapScreenY_middle]) select 1;

	// calculate the difference between top and middle world coordinates, devide by the screen height and return
	GVAR(mapScaleFactor) = (abs(_mapWorldY_middle - _mapWorldY_top)) / _mapScreenH;

	_display closeDisplay 0;
	uiNamespace setVariable [_displayName, displayNull];
};

GVAR(mapScale)UAV = 0.8 / GVAR(mapScaleFactor);
GVAR(mapScale)HCam = 0.3 / GVAR(mapScaleFactor);

GVAR(displayPropertyGroups) = [
	[QGVARMAIN(Tablet_dlg),"Tablet"],
	[QGVARMAIN(Android_dlg),"Android"],
	[QGVARMAIN(Android_dsp),"Android"],
	[QGVARMAIN(FBCB2_dlg),"FBCB2"],
	[QGVARMAIN(TAD_dsp),"TAD"],
	[QGVARMAIN(TAD_dlg),"TAD"],
	[QGVARMAIN(microDAGR_dsp),"MicroDAGR"],
	[QGVARMAIN(microDAGR_dlg),"MicroDAGR"]
];

GVAR(settings) = [];

[GVAR(settings),"COMMON",[
	["mode","BFT"],
	["mapScaleMin",0.1],
	["mapScaleMax",2 ^ round(sqrt(2666 * GVAR(mapScaleFactor) / 1024))]
]] call BIS_fnc_setToPairs;

[GVAR(settings),"Main",[
]] call BIS_fnc_setToPairs;

[GVAR(settings),"Tablet",[
	["dlgIfPosition",[]],
	["mode","DESKTOP"],
	["showIconText",true],
	["mapWorldPos",[]],
	["mapScaleDsp",2],
	["mapScaleDlg",2],
	["mapTypes",[["SAT",IDC_CTAB_SCREEN],["TOPO",IDC_CTAB_SCREEN_TOPO]]],
	["mapType","SAT"],
	["uavCam",""],
	["hCam",""],
	["mapTools",true],
	["nightMode",2],
	["brightness",0.9]
]] call BIS_fnc_setToPairs;

[GVAR(settings),"Android",[
	["dlgIfPosition",[]],
	["dspIfPosition",false],
	["mode","BFT"],
	["showIconText",true],
	["mapWorldPos",[]],
	["mapScaleDsp",0.4],
	["mapScaleDlg",0.4],
	["mapTypes",[["SAT",IDC_CTAB_SCREEN],["TOPO",IDC_CTAB_SCREEN_TOPO]]],
	["mapType","SAT"],
	["showMenu",false],
	["mapTools",true],
	["nightMode",2],
	["brightness",0.9]
]] call BIS_fnc_setToPairs;

[GVAR(settings),"FBCB2",[
	["dlgIfPosition",[]],
	["mapWorldPos",[]],
	["showIconText",true],
	["mapScaleDsp",2],
	["mapScaleDlg",2],
	["mapTypes",[["SAT",IDC_CTAB_SCREEN],["TOPO",IDC_CTAB_SCREEN_TOPO]]],
	["mapType","SAT"],
	["mapTools",true]
]] call BIS_fnc_setToPairs;

/*
TAD setup
*/
// set icon size of own vehicle on TAD
GVAR(TADOwnIconBaseSize) = 18;
GVAR(TADownIconScaledSize) = GVAR(TADOwnIconBaseSize) / (0.86 / (safezoneH * 0.8));
// set TAD font colour to neon green
GVAR(TADfontColour) = [57/255, 255/255, 20/255, 1];
// set TAD group colour to purple
GVAR(TADgroupColour) = [255/255, 0/255, 255/255, 1];
// set TAD highlight colour to neon yellow
GVAR(TADhighlightColour) = [243/255, 243/255, 21/255, 1];

[GVAR(settings),"TAD",[
	["dlgIfPosition",[]],
	["dspIfPosition",false],
	["mapWorldPos",[]],
	["showIconText",true],
	["mapScaleDsp",2],
	["mapScaleDlg",2],
	["mapScaleMin",1],
	["mapTypes",[["SAT",IDC_CTAB_SCREEN],["TOPO",IDC_CTAB_SCREEN_TOPO],["BLK",IDC_CTAB_SCREEN_BLACK]]],
	["mapType","SAT"],
	["mapTools",true],
	["nightMode",0],
	["brightness",0.8]
]] call BIS_fnc_setToPairs;

/*
microDAGR setup
*/
// set MicroDAGR font colour to neon green
GVAR(MicroDAGRfontColour) = [57/255, 255/255, 20/255, 1];
// set MicroDAGR group colour to purple
GVAR(MicroDAGRgroupColour) = [25/255, 25/255, 112/255, 1];
// set MicroDAGR highlight colour to neon yellow
GVAR(MicroDAGRhighlightColour) = [243/255, 243/255, 21/255, 1];

[GVAR(settings),"MicroDAGR",[
	["dlgIfPosition",[]],
	["dspIfPosition",false],
	["mapWorldPos",[]],
	["showIconText",true],
	["mapScaleDsp",0.4],
	["mapScaleDlg",0.4],
	["mapTypes",[["SAT",IDC_CTAB_SCREEN],["TOPO",IDC_CTAB_SCREEN_TOPO]]],
	["mapType","SAT"],
	["mapTools",true],
	["nightMode",2],
	["brightness",0.9]
]] call BIS_fnc_setToPairs;

// set base colors from BI -- Helps keep colors matching if user changes colors in options.
_r = profilenamespace getvariable ['Map_BLUFOR_R',0];
_g = profilenamespace getvariable ['Map_BLUFOR_G',0.8];
_b = profilenamespace getvariable ['Map_BLUFOR_B',1];
_a = profilenamespace getvariable ['Map_BLUFOR_A',0.8];
GVAR(colorBlue) = [_r,_g,_b,_a];

_r = profilenamespace getvariable ['Map_OPFOR_R',0];
_g = profilenamespace getvariable ['Map_OPFOR_G',1];
_b = profilenamespace getvariable ['Map_OPFOR_B',1];
_a = profilenamespace getvariable ['Map_OPFOR_A',0.8];
GVAR(colorRed) = [_r,_g,_b,_a];

_r = profilenamespace getvariable ['Map_Independent_R',0];
_g = profilenamespace getvariable ['Map_Independent_G',1];
_b = profilenamespace getvariable ['Map_Independent_B',1];
_a = profilenamespace getvariable ['Map_OPFOR_A',0.8];
GVAR(colorGreen) = [_r,_g,_b,_a];

// Define Fire-Team colors
// MAIN,RED,GREEN,BLUE,YELLOW
GVAR(colorTeam) = [GVAR(colorBlue),[200/255,0,0,0.8],[0,199/255,0,0.8],[0,0,200/255,0.8],[225/255,225/255,0,0.8]];


// Beginning text and icon size
GVAR(txtFctr) = 12;
call FUNC(caseButtonsApplyTextSize);

GVAR(BFTtxt) = true;

// Draw Map Tolls (Hook)
GVAR(drawMapTools) = false;

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

//CC: Maybe split messages in core and ui?
// Set up the array that will hold text messages.
player setVariable ["ctab_messages",[]];

// GVAR(openStart) will be set to true while interface is starting and prevent further open attempts
GVAR(openStart) = false;

private _msgReceiveEHID = [QGVARMAIN(msg_receive),
	{
		params["_msgRecipient","_msgTitle","_msgBody","_msgEncryptionKey", "_sender"];
		private _playerEncryptionKey = call EFUNC(core,getPlayerEncryptionKey);
		private _msgArray = _msgRecipient getVariable [format ["cTab_messages_%1",_msgEncryptionKey],[]];
		_msgArray pushBack [_msgTitle,_msgBody,0];
		
		_msgRecipient setVariable [format ["cTab_messages_%1",_msgEncryptionKey],_msgArray];
		
		if (_msgRecipient == Ctab_player && _sender != Ctab_player && {_playerEncryptionKey == _msgEncryptionKey} && {[Ctab_player,["ItemcTab","ItemAndroid"]] call EFUNC(core,checkGear)}) then {
			playSound QGVARMAIN(phoneVibrate);
			
			if (!isNil QGVAR(ifOpen) && {[GVAR(ifOpen) select 1,"mode"] call FUNC(getSettings) == "MESSAGE"}) then {
				call FUNC(messagingLoadGUI);
				
				// add a notification
				private _notificationText = format ["New message from %1",name _sender];
				["MSG",_notificationText,6] call FUNC(addNotification);
			} else {
				GVAR(RscLayerMailNotification) cutRsc [QGVAR(mail_ico_disp), "PLAIN"]; //show
			};
		};
	}
] call CBA_fnc_addEventHandler;

GVAR(actUAV) = nullObj;

GVAR(notificationCache) = [];
