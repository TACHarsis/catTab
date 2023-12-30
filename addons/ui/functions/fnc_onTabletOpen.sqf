#include "script_component.hpp"
#include "..\settings_macros.hpp"
#include "..\devices\shared\cTab_defines.hpp"

disableSerialization;

// ["Number of screens: %1", GVAR(numTabletFeeds)] call FUNCMAIN(debugLog);

params ["_display", ["_config", configNull]];

private _fnc_createListCtrl = {
    params ["_display", "_rect", "_ctrlGrp", "_selChangedCallback"];
    private _listCtrl = _display ctrlCreate ["cTab_RscCombo_Tablet", -1, _ctrlGrp];


    _listCtrl ctrlSetPosition _rect;
    _listCtrl ctrlCommit 0;

    _listCtrl setVariable [QGVAR(LBSelChangedCallback), _selChangedCallback];

    _listCtrl ctrlAddEventHandler ["LBSelChanged", {
        params ["_ctrl"];
        private _callback = _ctrl getVariable [QGVAR(LBSelChangedCallback), {}];
        _this call _callback;
    }];

    _listCtrl setVariable [QGVAR(camIdx), _i];

    _listCtrl
};

private _fnc_createVideoSourceLists = {
    params ["_display", "_ctrlGrp", "_selChangedCallback"];

    private _listCtrlsList = [];
    private _rect = ctrlPosition _ctrlGrp;
    private _listWidth = (_rect # 2) / GVAR(numTabletFeeds);
    private _listHeight = _rect # 3;
    for "_i" from 0 to (GVAR(numTabletFeeds)-1) do {
        private _listRect = [
                _listWidth * _i,
                0,
                _listWidth,
                _listHeight
            ];
        private _listCtrl = [_display, _listRect, _ctrlGrp, _selChangedCallback] call _fnc_createListCtrl;
        _listCtrl setVariable [QGVAR(frameIdx), _i];

        _listCtrlsList pushBack _listCtrl;
    };

    _listCtrlsList
};

private _fnc_uavListSelChangedCallback = {
    params ["_control", "_lbCurSel"];

    if (!GVAR(openStart) && (_lbCurSel != -1)) then {
        private _frameIdx = _ctrl getVariable [QGVAR(frameIdx), -1];
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
    params ["_control", "_lbCurSel"];

    if (!GVAR(openStart) && (_lbCurSel != -1)) then {
        private _frameIdx = _ctrl getVariable [QGVAR(frameIdx), -1];
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
private _hCamListCtrls = [_display, _hcamListCtrlGrp, _fnc_hCamListSelChangedCallback] call _fnc_createVideoSourceLists;
uiNamespace setVariable [QGVAR(HCAMListCtrls), _hCamListCtrls];

private _fnc_createVideoFrames = {
    params ["_display", "_feedType", "_fnc_controlsCreationFunction", "_startIDC"];

    private _ctrlGrp = _display displayCtrl IDC_CTAB_GROUP_VIDEO_FRAME;
    private _grpRect = ctrlPosition _ctrlGrp;

    private _frameDataList = [];
    //TODO: find good values for 1 and 2 screens
    private _maxFrameHeight = ((_grpRect # 3) / (2 max ceil (GVAR(numTabletFeeds) / 2)));
    private _maxFrameWidth = ((_grpRect # 2) * 0.475) min (_grpRect # 2) / 2;

    for "_i" from 0 to (GVAR(numTabletFeeds)-1) do {
        private _frameAreaX = (_grpRect # 0) + ((_grpRect # 2) - _maxFrameWidth) * (_i % 2);
        private _frameAreaY = (_grpRect # 1) + (_maxFrameHeight * floor (_i / 2));

        //TODO: might be easiest to just put all of the content into a content group ctrl of their own, nesting ftw
        private _frameArea = [_frameAreaX, _frameAreaY, _maxFrameWidth, _maxFrameHeight];
        private _foldingDirection = (_i % 2); //0, 1, 2, 3 -> left, right, down, up
        private _frameGrpCtrl = _display ctrlCreate ["cTab_Tablet_FrameBox", (_startIDC + _i)];
        _frameGrpCtrl ctrlSetScrollvalues [0, 0];
        _frameGrpCtrl ctrlSetPosition _frameArea;
        _frameGrpCtrl ctrlCommit 0;
        private _backgroundRect = [0, 0, _frameArea # 2, _frameArea # 3];
        private _backgroundCtrl = _display ctrlCreate ["cTab_IGUIBack", -1, _frameGrpCtrl];
        _backgroundCtrl ctrlSetPosition _backgroundRect;
        _backgroundCtrl ctrlCommit 0;

        private _videoCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrpCtrl];
        private _renderTargetName = format ["%1RenderTarget%2", _feedType, _i];
        _videoCtrl ctrlSetText format ["#(argb,%2,%2,1)r2t(%1,1)", _renderTargetName, GVAR(tabletFeedTextureResolution)];
        _videoCtrl setVariable [QGVAR(renderTargetName), _renderTargetName];

        // TODO: Implement proper display of currently selected feed
        // private _selectedIconCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrpCtrl];
        // _selectedIconCtrl ctrlSetText format ["#(argb,%2,%2,1)r2t(%1,1)", _renderTargetName, GVAR(tabletFeedTextureResolution)];
        // _selectedIconCtrl setVariable [QGVAR(renderTargetName), _renderTargetName];

        private _toggleButtonCtrl = _display ctrlCreate ["Ctab_RscButton_Tablet_VideoToggle", -1, _frameGrpCtrl];
        _toggleButtonCtrl ctrlSetText "<<";

        private _frameData = [_frameGrpCtrl, _backgroundCtrl, _videoCtrl, _toggleButtonCtrl];
        // array of content in the form of [videoController, [[contentControl, [relPos]], ..]
        private _contentCtrls = [_display, _frameArea, _frameData] call _fnc_controlsCreationFunction;
        _frameData append _contentCtrls;

        _contentCtrls params ["_controllerCtrl", "_contentCtrlsHash"];
        _frameGrpCtrl setVariable [QGVAR(feed_controllerCtrl), _controllerCtrl];
        _frameGrpCtrl setVariable [QGVAR(feed_contentCtrlsHash), _contentCtrlsHash];
        //_frameGrpCtrl setVariable [QGVAR(feed_selectedIconCtrl), _selectedIconCtrl];
        [_controllerCtrl, _feedType] call FUNC(onLoadVideoDisplayController);

        _frameGrpCtrl setVariable [QGVAR(feed_videoCtrl), _videoCtrl];

        [
            _frameGrpCtrl, // [ctrlsGroup]
            [ // ctrls
                _contentCtrlsHash, // array with controls + relative positioning
                _backgroundCtrl, // background control
                _toggleButtonCtrl // the button to toggle folding
            ],
            _frameArea,
            _foldingDirection
        ] call FUNC(onLoadVideoDisplayFrame);

        _frameGrpCtrl ctrlShow false;

        _frameDataList pushBack _frameData;
    };

    _frameDataList
};

private _fnc_createUAVControls = {
    params ["_display", "_frameArea", "_frameData"];
    _frameData params ["_frameGrpCtrl", "_backgroundCtrl", "_videoCtrl", "_toggleButtonCtrl"];

    private _nameCtrl = _display ctrlCreate ["cTab_RscText", -1, _frameGrpCtrl];
    _nameCtrl ctrlSetText "Drone Dronedottir";

    private _controllerCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrpCtrl];
    _controllerCtrl ctrlSetActiveColor [1, 0, 0, 1];
    [
        _controllerCtrl,
        createHashMapFromArray [
            [
                FEED_NAME,
                [_nameCtrl,                 [0, 0, 1, 0.1]]
            ],
            [
                FEED_CONTROLLER,
                [_controllerCtrl,      [0, 0, 1, 1]]
            ]
        ]
    ]
};

private _uavFrameCtrls = [_display, QSETTING_FEED_TYPE_UAV, _fnc_createUAVControls, IDC_CTAB_UAV_FRAME_0] call _fnc_createVideoFrames;
uiNamespace setVariable [QGVAR(UAVFrameCtrls), _uavFrameCtrls];

private _fnc_createHCamControls = {
    params ["_display", "_frameArea", "_frameData"];
    _frameData params ["_frameGrpCtrl", "_backgroundCtrl", "_videoCtrl", "_toggleButtonCtrl"];

    private _heartBeatIconCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrpCtrl];
    _heartBeatIconCtrl ctrlSetText "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa";
    private _heartBeatTextCtrl = _display ctrlCreate ["cTab_RscText", -1, _frameGrpCtrl];
    _heartBeatTextCtrl ctrlSetText "132456789";
    private _nameCtrl = _display ctrlCreate ["cTab_RscText", -1, _frameGrpCtrl];
    _nameCtrl ctrlSetText "Name Nameson";

    // needs to be created last so it overlays all others
    private _controllerCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrpCtrl];
    _controllerCtrl ctrlSetActiveColor [1, 0, 0, 1];
    [
        _controllerCtrl,
        createHashMapFromArray [
            [
                FEED_NAME,
                [_nameCtrl,                 [0, 0.1, 1, 0.1]]
            ],
            [
                FEED_CONTROLLER,
                [_controllerCtrl,      [0, 0, 1, 1]]
            ],
            [
                HEARTBEAT_ICON,
                [_heartBeatIconCtrl,        [0, 0, (0.1 / ARMA_UI_RATIO), 0.1]]
            ],
            [
                HEARTBEAT_TEXT,
                [_heartBeatTextCtrl,        [(0.1 / ARMA_UI_RATIO), 0, (0.9 / ARMA_UI_RATIO), 0.1]]
            ]
        ]
    ]
};

private _hCamFrameCtrls = [_display, QSETTING_FEED_TYPE_HCAM, _fnc_createHCamControls, IDC_CTAB_HCAM_FRAME_0] call _fnc_createVideoFrames;
uiNamespace setVariable [QGVAR(HCAMFrameCtrls), _hCamFrameCtrls];


private _fnc_createFullScreenVideoFrame = {
    params ["_display", "_feedType", "_fnc_controlsCreationFunction", "_frameGrpCtrl"];
    private _frameGrpRect = ctrlPosition _frameGrpCtrl;
    _frameGrpRect params ["_SAX","_SAY", "_SAW", "_SAH"];

//TODO: There is a small gap below the fullscreen + cropped image, probably misaligned or shortened background? Could background just be hardcoded anyway?
    private _ratioFixedTextureArea = [_frameGrpRect, GVAR(tabletFeedDealWithAspectRatioFullscreen), ALIGN_CENTER] call FUNC(positionTextureR2T);
    _frameGrpRect params ["", "", "_contentWidth", "_contentHeight"];

    private _backgroundRect = [0, 0, _frameGrpRect # 2, _frameGrpRect # 3];
    private _backgroundCtrl = _display ctrlCreate ["cTab_IGUIBack", -1, _frameGrpCtrl];
    _backgroundCtrl ctrlSetBackgroundColor [0.2, 0.2, 0.2, 1];
    _backgroundCtrl ctrlSetPosition _backgroundRect;
    _backgroundCtrl ctrlCommit 0;

    //TODO: fix content rect to texture rect? Otherwise heartbeat icon may float in bar atop of shrunk fullscreen video
    //      could be combined with positioning content differently for fullscreen anyway?
    private _contentRect = [((_SAW - _contentWidth) / 2), ((_SAH - _contentHeight) / 2), _contentWidth, _contentHeight];
    private _fullscreenVideoCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrpCtrl];
    _fullscreenVideoCtrl ctrlSetPosition _ratioFixedTextureArea;
    _fullscreenVideoCtrl ctrlCommit 0;

    private _renderTargetName = format ["%1RenderTargetFull", _feedType];
    _fullscreenVideoCtrl setVariable [QGVAR(renderTargetName), _renderTargetName];
    _fullscreenVideoCtrl ctrlSetText format ["#(argb,%2,%2,1)r2t(%1,1)", _renderTargetName, GVAR(tabletFeedTextureResolutionFullscreen)];;

    private _frameData = [_frameGrpCtrl, controlNull, _fullscreenVideoCtrl, controlNull];

    private _contentCtrls = [_display, ctrlPosition _frameGrpCtrl, [_frameGrpCtrl, controlNull, _fullscreenVideoCtrl, controlNull]] call _fnc_controlsCreationFunction;
    _contentCtrls params ["_controllerCtrl", "_contentCtrlsHash"];
    _frameData append _contentCtrls;

    [_contentCtrlsHash, _contentRect, 0] call FUNC(fitContentControlsByRelativeSize);

    _frameGrpCtrl setVariable [QGVAR(feed_controllerCtrl), _controllerCtrl];
    _frameGrpCtrl setVariable [QGVAR(feed_contentCtrlsHash), _contentCtrlsHash];
    [_controllerCtrl, _feedType] call FUNC(onLoadVideoDisplayController);

    _frameGrpCtrl setVariable [QGVAR(feed_videoCtrl), _fullscreenVideoCtrl];
    _frameGrpCtrl ctrlShow false;

    _frameData
};

private _fullscreenUAVListGrp = _display displayCtrl IDC_CTAB_UAV_FULLSCREEN_LIST;
_uavListCtrls pushBack ([_display, ctrlPosition _fullscreenUAVListGrp, _fullscreenUAVListGrp, _fnc_uavListSelChangedCallback] call _fnc_createListCtrl);
_uavFrameCtrls pushBack ([_display, QSETTING_FEED_TYPE_UAV, _fnc_createUAVControls, _display displayCtrl IDC_CTAB_UAV_FULLSCREEN_CNTNT] call _fnc_createFullScreenVideoFrame);
private _fullscreenHCamListGrp = _display displayCtrl IDC_CTAB_HCAM_FULLSCREEN_LIST;
_hCamListCtrls pushBack ([_display, ctrlPosition _fullscreenHCamListGrp, _fullscreenHCamListGrp, _fnc_hCamListSelChangedCallback] call _fnc_createListCtrl);
_hCamFrameCtrls pushBack ([_display, QSETTING_FEED_TYPE_HCAM, _fnc_createHCamControls, _display displayCtrl IDC_CTAB_HCAM_FULLSCREEN_CNTNT] call _fnc_createFullScreenVideoFrame);
