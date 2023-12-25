#include "script_component.hpp"
#include "..\settings_macros.hpp"
#include "..\devices\shared\cTab_defines.hpp"

disableSerialization;

// ["Number of screens: %1", GVAR(numTabletFeeds)] call EFUNC(core,debugLog);

params ["_display", ["_config", configNull]];

private _fnc_createVideoSourceLists = {
    params ["_display", "_ctrlGrp", "_selChangedCallback"];

    private _listCtrlsList = [];
    private _rect = ctrlPosition _ctrlGrp;
    private _listWidth = (_rect # 2) / GVAR(numTabletFeeds);
    private _listHeight = _rect # 3;

    for "_i" from 0 to (GVAR(numTabletFeeds)-1) do {
        private _listCtrl = _display ctrlCreate ["cTab_RscCombo_Tablet", -1, _ctrlGrp];
        
        private _listRect = [
            _listWidth * _i,
            0,
            _listWidth,
            _listHeight
        ];
        _listCtrl ctrlSetPosition _listRect;
        _listCtrl ctrlCommit 0;

        _listCtrl setVariable [QGVAR(LBSelChangedCallback), _selChangedCallback];
        _listCtrl setVariable [QGVAR(frameIdx), _i];

        _listCtrl ctrlAddEventHandler ["LBSelChanged", {
            params ["_ctrl"];

            private _params = +_this;
            private _callback = _ctrl getVariable [QGVAR(LBSelChangedCallback), {}];
            private _frameIdx = _ctrl getVariable [QGVAR(frameIdx), -1];
            _params pushBack _frameIdx;
            _params call _callback;
        }];

        _listCtrl setVariable [QGVAR(camIdx), _i];

        _listCtrlsList pushBack _listCtrl;
    };

    _listCtrlsList
};

private _fnc_uavListSelChangedCallback = {
    params ["_control", "_lbCurSel", "_frameIdx"];

    if (!GVAR(openStart) && (_lbCurSel != -1)) then {
        [
            QGVARMAIN(Tablet_dlg),
            [
                [
                    GVAR(uavCamSettingsNames) # _frameIdx,
                    _control lbData _lbCurSel
                ]
            ]
        ] call FUNC(setSettings);
    };
};

private _uavListCtrlGrp = _display displayCtrl IDC_CTAB_GROUP_UAV_SOURCE_GRP;
private _uavListCtrls = [_display, _uavListCtrlGrp, _fnc_uavListSelChangedCallback] call _fnc_createVideoSourceLists;
uiNamespace setVariable [QGVAR(UAVListCtrls), _uavListCtrls];
[QEGVAR(core,uavListUpdate), GVARMAIN(UAVList)] call CBA_fnc_localEvent;

private _fnc_hCamListSelChangedCallback = {
    params ["_control", "_lbCurSel", "_frameIdx"];

    if (!GVAR(openStart) && (_lbCurSel != -1)) then {
        [
            QGVARMAIN(Tablet_dlg),
            [
                [
                    GVAR(helmetCamSettingsNames) # _frameIdx,
                    _control lbData _lbCurSel
                ]
            ]
        ] call FUNC(setSettings);
    };
};

private _hcamListCtrlGrp = _display displayCtrl IDC_CTAB_GROUP_HCAM_SOURCE_GRP;
private _hcamListCtrls = [_display, _hcamListCtrlGrp, _fnc_hCamListSelChangedCallback] call _fnc_createVideoSourceLists;
uiNamespace setVariable [QGVAR(HCAMListCtrls), _hcamListCtrls];


private _fnc_createVideoFrames = {
    params ["_display", "_feedType", "_fnc_controlsCreationFunction", "_startIDC"];

    private _ctrlGrp = _display displayCtrl IDC_CTAB_GROUP_VIDEO_FRAME;
    private _grpRect = ctrlPosition _ctrlGrp;

    private _frameCtrlsList = [];
    private _maxFrameHeight = ((_grpRect # 3) / (1 max ceil (GVAR(numTabletFeeds) / 2)));
    private _maxFrameWidth = ((_grpRect # 2) * 0.475) min (_grpRect # 2) / 2;

    for "_i" from 0 to (GVAR(numTabletFeeds)-1) do {
        private _frameAreaX = (_grpRect # 0) + ((_grpRect # 2) - _maxFrameWidth) * (_i % 2);
        private _frameAreaY = (_grpRect # 1) + (_maxFrameHeight * floor (_i / 2));
        
        private _frameArea = [_frameAreaX, _frameAreaY, _maxFrameWidth, _maxFrameHeight];
        private _foldingDirection = (_i % 2); //0, 1, 2, 3 -> left, right, down, up
        private _frameGrp = _display ctrlCreate ["cTab_Tablet_FrameBox", (_startIDC + _i)];
        _frameGrp ctrlSetScrollvalues [0, 0];
        _frameGrp ctrlSetPosition _frameArea;
        _frameGrp ctrlCommit 0;

        private _backgroundRect = [0, 0, _frameArea # 2, _frameArea # 3];
        private _backgroundCtrl = _display ctrlCreate ["cTab_IGUIBack", -1, _frameGrp];
        _backgroundCtrl ctrlSetPosition _backgroundRect;
        _backgroundCtrl ctrlCommit 0;

        private _videoCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrp];
        private _renderTargetName = format ["%1RenderTarget%2", _feedType, _i];
        _videoCtrl ctrlSetText format ["#(argb,%2,%2,1)r2t(%1,1)", _renderTargetName, GVAR(tabletFeedTextureResolutionFullscreen)];
        _videoCtrl setVariable [QGVAR(renderTargetName), _renderTargetName];

        private _toggleButtonCtrl = _display ctrlCreate ["Ctab_RscButton_Tablet_VideoToggle", -1, _frameGrp];
        _toggleButtonCtrl ctrlSetText "<<";

        private _frameCtrls = [_frameGrp, _backgroundCtrl, _videoCtrl, _toggleButtonCtrl];

        // array of content in the form of [videoController, [[contentControl, [relPos]], ..]
        private _controllerAndContent = [_display, _frameArea, _frameCtrls] call _fnc_controlsCreationFunction;
        _frameCtrls append _controllerAndContent;

        _controllerAndContent params ["_videoControllerCtrl", "_contentCtrlsAndPos"];
        _frameGrp setVariable [QGVAR(videoController), _videoControllerCtrl];
        _frameGrp setVariable [QGVAR(content), _contentCtrlsAndPos];
        [_videoControllerCtrl, _feedType] call FUNC(onLoadVideoDisplayController);

        _frameGrp setVariable [QGVAR(videoCtrl), _videoCtrl];

        [
            [_frameGrp], // [ctrlsGroup]
            [ // ctrls
                _contentCtrlsAndPos, // array with controls + relative positioning
                _backgroundCtrl, // background control
                _toggleButtonCtrl // the button to toggle folding
            ],
            _frameArea,
            _foldingDirection
        ] call FUNC(onLoadVideoDisplayFrame);

        _frameGrp ctrlShow false;

        _frameCtrlsList pushBack _frameCtrls;
    };

    _frameCtrlsList
};

private _fnc_createUAVControls = {
    params ["_display", "_frameArea", "_frameCtrls"];
    _frameCtrls params ["_frameGrp", "_backgroundCtrl", "_videoCtrl", "_toggleButtonCtrl"];

    private _nameCtrl = _display ctrlCreate ["cTab_RscText", -1, _frameGrp];
    _nameCtrl ctrlSetText "Drone Dronedottir";

    private _videoControllerCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrp];
    _videoControllerCtrl ctrlSetActiveColor [1, 0, 0, 1];
    [
        _videoControllerCtrl,
        [
            [_videoCtrl,                [0, 0, 1, 1]],
            [_nameCtrl,                 [0, 0, 1, 0.1]],
            [_videoControllerCtrl,      [0, 0, 1, 1]]
        ]
    ]
};

private _uavFrameCtrls = [_display, QSETTING_FEED_TYPE_UAV, _fnc_createUAVControls, IDC_CTAB_UAV_FRAME_0] call _fnc_createVideoFrames;

uiNamespace setVariable [QGVAR(UAVFrameCtrls), _uavFrameCtrls];

private _fnc_createHCamControls = {
    params ["_display", "_frameArea", "_frameCtrls"];
    _frameCtrls params ["_frameGrp", "_backgroundCtrl", "_videoCtrl", "_toggleButtonCtrl"];

    private _heartBeatIconCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrp];
    _heartBeatIconCtrl ctrlSetText "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa";
    private _heartBeatTextCtrl = _display ctrlCreate ["cTab_RscText", -1, _frameGrp];
    _heartBeatTextCtrl ctrlSetText "132456789";
    private _nameCtrl = _display ctrlCreate ["cTab_RscText", -1, _frameGrp];
    _nameCtrl ctrlSetText "Name Nameson";

    // needs to be created last so it overlays all others
    private _videoControllerCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrp];
    _videoControllerCtrl ctrlSetActiveColor [1, 0, 0, 1];
    [
        _videoControllerCtrl,
        [
            [_videoCtrl,                [0, 0, 1, 1]],
            [_heartBeatIconCtrl,        [0, 0, (0.1 / 1.33333), 0.1]],
            [_heartBeatTextCtrl,        [(0.1 / 1.33333), 0, (0.9/ 1.33333), 0.1]],
            [_nameCtrl,                 [0, 0.1, 1, 0.1]],
            [_videoControllerCtrl,      [0, 0, 1, 1]]
        ]
    ]
};

private _hCamFrameCtrls = [_display, QSETTING_FEED_TYPE_HCAM, _fnc_createHCamControls, IDC_CTAB_HCAM_FRAME_0] call _fnc_createVideoFrames;
uiNamespace setVariable [QGVAR(HCAMFrameCtrls), _hCamFrameCtrls];

#define DEFAULT_RATIO 1.3333333333333
private _fnc_createFullScreenVideoFrame = {
    params ["_display", "_feedType", "_fnc_controlsCreationFunction", "_frameGrpIDC"];
    private _frameGrp = _display displayCtrl _frameGrpIDC;
    private _frameGrpPos = ctrlPosition _frameGrp;
    _frameGrpPos params ["_SAX","_SAY", "_SAW", "_SAH"];

    private _screenAR = getResolution select 4;
    private _heightRelToSACW = _SAW / _screenAR * DEFAULT_RATIO;
    private _overflowH = _heightRelToSACW > _SAH;
    private _widthRelToSACH = _SAH * _screenAR / DEFAULT_RATIO;
    private _overflowW = _widthRelToSACH > _SAW;
    
    private ["_contentWidth", "_contentHeight"];
    switch (true) do {
        case (_overflowH || !(_overflowW || _overflowH)) : { // calc width from height, default
            _contentHeight = _SAH;
            _contentWidth = _contentHeight * _screenAR / DEFAULT_RATIO;
        };
        case (_overflowW) : { // calc height from width
            _contentWidth = _SAW;
            _contentHeight = _contentWidth / _screenAR * DEFAULT_RATIO;
        };
    };

    private _backgroundRect = [0, 0, _frameGrpPos # 2, _frameGrpPos # 3];
    private _backgroundCtrl = _display ctrlCreate ["cTab_IGUIBack", -1, _frameGrp];
    _backgroundCtrl ctrlSetPosition _backgroundRect;
    _backgroundCtrl ctrlCommit 0;

    private _contentRect = [((_SAW - _contentWidth) / 2), ((_SAH - _contentHeight) / 2), _contentWidth, _contentHeight];
    private _fullscreenVideoCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrp];
    _fullscreenVideoCtrl ctrlSetPosition _contentRect;
    _fullscreenVideoCtrl ctrlCommit 0;

    private _renderTargetName = format ["%1RenderTargetFull", _feedType];
    _fullscreenVideoCtrl setVariable [QGVAR(renderTargetName), _renderTargetName];
    _fullscreenVideoCtrl ctrlSetText format ["#(argb,%2,%2,1)r2t(%1,1)", _renderTargetName, GVAR(tabletFeedTextureResolution)];;

    private _frameCtrls = [_frameGrp, controlNull, _fullscreenVideoCtrl, controlNull];

    private _controllerAndContent = [_display, ctrlPosition _frameGrp, [_frameGrp, controlNull, _fullscreenVideoCtrl, controlNull]] call _fnc_controlsCreationFunction;
    _controllerAndContent params ["_videoControllerCtrl", "_contentCtrlsAndPos"];
    _frameCtrls append _controllerAndContent;

    // video + content
    {
        _x params ["_contentCtrl", "_ctrlRelSize"];
        private _ctrlPos = [
            (POS_X(_contentRect)) + (POS_W(_contentRect)) * (POS_X(_ctrlRelSize)),
            (POS_Y(_contentRect)) + (POS_H(_contentRect)) * (POS_Y(_ctrlRelSize)),
            (POS_W(_contentRect)) * (POS_W(_ctrlRelSize)),
            (POS_H(_contentRect)) * (POS_H(_ctrlRelSize))
        ];
        _contentCtrl ctrlSetPosition _ctrlPos;
        _contentCtrl ctrlCommit 0;
    } foreach _contentCtrlsAndPos;

    _frameGrp setVariable [QGVAR(videoController), _videoControllerCtrl];
    _frameGrp setVariable [QGVAR(content), _contentCtrlsAndPos];
    [_videoControllerCtrl, _feedType] call FUNC(onLoadVideoDisplayController);

    _frameGrp setVariable [QGVAR(videoCtrl), _fullscreenVideoCtrl];
    _frameGrp ctrlShow false;

    _frameCtrls
};

_uavFrameCtrls pushBack ([_display, QSETTING_FEED_TYPE_UAV, _fnc_createUAVControls, IDC_CTAB_UAVGUNNER_FULL] call _fnc_createFullScreenVideoFrame);
_hCamFrameCtrls pushBack ([_display, QSETTING_FEED_TYPE_HCAM, _fnc_createHCamControls, IDC_CTAB_HCAM_FULL] call _fnc_createFullScreenVideoFrame);
