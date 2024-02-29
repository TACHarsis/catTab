#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

disableSerialization;

params ["_display", ["_config", configNull]];

private _fnc_createListCtrl = {
    params ["_display", "_rect", "_ctrlGrp", "_selChangedCallback"];
    private _listCtrl = _display ctrlCreate ["cTab_RscCombo_Tablet", -1, _ctrlGrp];

    _listCtrl ctrlSetPosition _rect;
    _listCtrl ctrlCommit 0;

    _listCtrl setVariable [QGVAR(LBSelChangedCallback), _selChangedCallback];

    _listCtrl ctrlAddEventHandler ["LBSelChanged", {
        params ["_ctrl"];
        private _isBusy = _ctrl getVariable [QGVAR(busy), false];
        if(_isBusy) exitWith {};

        private _callback = _ctrl getVariable [QGVAR(LBSelChangedCallback), {}];
        _this call _callback;
    }];

    _listCtrl setVariable [QGVAR(camIdx), _i];

    (_listCtrl)
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

    (_listCtrlsList)
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

private _fnc_hCamListSelChangedCallback = {
    params ["_control", "_lbCurSel"];

    if (!GVAR(openStart) && (_lbCurSel != -1)) then {
        private _frameIdx = _ctrl getVariable [QGVAR(frameIdx), -1];
        [
            QGVARMAIN(Tablet_dlg),
            [
                [
                    GVAR(hCamSettingsNames) # _frameIdx,
                    _control lbData _lbCurSel
                ]
            ]
        ] call FUNC(setSettings);
    };
};

private _hcamListCtrlGrp = _display displayCtrl IDC_CTAB_GROUP_HCAM_SOURCE_GRP;
private _hCamListCtrls = [_display, _hcamListCtrlGrp, _fnc_hCamListSelChangedCallback] call _fnc_createVideoSourceLists;
uiNamespace setVariable [QGVAR(HCAMListCtrls), _hCamListCtrls];

private _fnc_createVideoFeedGroupCtrl = {
    params ["_display", "_feedType", "_renderTargetID", "_fnc_controlsCreationFunction", "_frameGrpCtrl", ["_isFullscreen", false, [true]]];

    private _contentGrpCtrl = _display ctrlCreate ["cTab_Tablet_FrameBox", -1, _frameGrpCtrl];
    private _contentCtrlsHash = createHashmap;
    _contentGrpCtrl setVariable [QGVAR(feed_contentCtrlsHash), _contentCtrlsHash];

    private _videoCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _contentGrpCtrl];
    private _renderTargetName = format ["%1RenderTarget%2", _feedType, _renderTargetID];
    _videoCtrl ctrlSetText format ["#(argb,%2,%2,1)r2t(%1,1)", _renderTargetName, GVAR(tabletFeedTextureResolution)];
    _videoCtrl setVariable [QGVAR(renderTargetName), _renderTargetName];
    _contentGrpCtrl setVariable [QGVAR(videoCtrl), _videoCtrl];

    private _tvStaticCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _contentGrpCtrl];
    _contentCtrlsHash set [FEED_STATIC, [_tvStaticCtrl, [0, 0, 1, 1]]];
    _tvStaticCtrl ctrlSetText "#(ai,512,512,9)perlinNoise(256,256,0.5,1)";
    _tvStaticCtrl ctrlShow false;
    private _statusBigCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _contentGrpCtrl];
    _contentCtrlsHash set [FEED_STATUS_BIG, [_statusBigCtrl, [0, 0, 1, 1]]];

    private _statusTextDimension = 512;
    private _statusTextFontSize = 0.3;
    private _textPattern = format ["#(rgb,%1,%1,3)text(1,1,""EtelkaMonospaceProBold"",%2,""#0000ff7f"",""#ff0000"",""%3"")", _statusTextDimension, "%1", "%2"];
    _statusBigCtrl setVariable [QGVAR(textPattern), _textPattern];
    _statusBigCtrl ctrlSetText format [_textPattern, _statusTextFontSize, "UNINITIALIZED"];
    _statusBigCtrl ctrlShow false;

    private _controllerCtrl = [_display, _contentGrpCtrl, _contentCtrlsHash, _isFullscreen] call _fnc_controlsCreationFunction;

    [_controllerCtrl, _feedType] call FUNC(onLoadVideoDisplayController);

    _contentGrpCtrl setVariable [QGVAR(feed_controllerCtrl), _controllerCtrl];

    (_contentGrpCtrl)
};

private _fnc_createFramedVideoSlotUIs = {
    params ["_display", "_feedType", "_fnc_createVideoFeedGroupCtrl", "_fnc_controlsCreationFunction", "_startIDC"];

    private _ctrlGrp = _display displayCtrl IDC_CTAB_GROUP_VIDEO_FRAME;
    private _grpRect = ctrlPosition _ctrlGrp;

    private _videoSlotUIDataList = [];
    //TODO: find good values for 1 and 2 screens
    private _maxFrameHeight = ((_grpRect # 3) / (2 max ceil (GVAR(numTabletFeeds) / 2)));
    private _maxFrameWidth = ((_grpRect # 2) * 0.475) min (_grpRect # 2) / 2;

    //TODO: Use settings names here by index, to associate the frame with
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
        _frameGrpCtrl ctrlShow false;

        private _backgroundRect = [0, 0, _frameArea # 2, _frameArea # 3];
        private _backgroundCtrl = _display ctrlCreate ["cTab_IGUIBack", -1, _frameGrpCtrl];
        _frameGrpCtrl setVariable [QGVAR(backgroundCtrl), _backgroundCtrl];

        private _contentGrpCtrl = [_display, _feedType, _i, _fnc_controlsCreationFunction, _frameGrpCtrl] call _fnc_createVideoFeedGroupCtrl;
        _frameGrpCtrl setVariable [QGVAR(contentGrpCtrl), _contentGrpCtrl];

        //TODO: Implement proper display of currently selected feed
        // private _selectedIconCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _frameGrpCtrl];
        // _selectedIconCtrl ctrlSetText format ["#(argb,%2,%2,1)r2t(%1,1)", _renderTargetName, GVAR(tabletFeedTextureResolution)];
        // _selectedIconCtrl setVariable [QGVAR(renderTargetName), _renderTargetName];
        //_frameGrpCtrl setVariable [QGVAR(feed_selectedIconCtrl), _selectedIconCtrl];

        private _toggleButtonCtrl = _display ctrlCreate ["Ctab_RscButton_Tablet_VideoToggle", -1, _frameGrpCtrl];
        _toggleButtonCtrl ctrlSetText "<<";
        _frameGrpCtrl setVariable [QGVAR(toggleButtonCtrl), _toggleButtonCtrl];

        [_frameGrpCtrl, _foldingDirection] call FUNC(onLoadVideoDisplayFrame);

        _frameGrpCtrl setVariable [QGVAR(feedType), _feedType];
        _frameGrpCtrl setVariable [QGVAR(frameIdx), _i];
        _frameGrpCtrl setVariable [QGVAR(uiVarName), format [QGVAR(%1_%2), _feedType, _i]];


        private _videoSlotUIData = [_frameGrpCtrl];
        _videoSlotUIDataList pushBack _videoSlotUIData;
    };

    (_videoSlotUIDataList)
};
private _fnc_createOSDHints = {
    params ["_contentGrpCtrl", "_hintFontHeight", "_contentHash", "_isFullscreen"];

    private _visionHintCtrl = _display ctrlCreate ["cTab_RscText_VideoFeed", -1, _contentGrpCtrl];
    _visionHintCtrl ctrlSetText LLSTRING(Video_Feed_Hint_Vision);
    _visionHintCtrl ctrlSetFontHeight _hintFontHeight;
    private _hintTextHeight = (ctrlTextHeight _visionHintCtrl) * 1.75;
    private _visionHintCtrlRelPos = [
        [0.55, (0.98 - 4 * _hintTextHeight), 0.5, 0.05],
        [0.60, (0.98 - 2 * _hintTextHeight), 0.5, 0.05]
    ];
    _contentHash set [FEED_HINT_VISION, [_visionhintCtrl,   _visionHintCtrlRelPos select _isFullscreen]];

    private _zoomhintCtrl = _display ctrlCreate ["cTab_RscText_VideoFeed", -1, _contentGrpCtrl];
    _zoomhintCtrl ctrlSetText LLSTRING(Video_Feed_Hint_Zoom);
    _zoomhintCtrl ctrlSetFontHeight _hintFontHeight;
    private _zoomhintCtrlRelPos = [
        [0.55, (0.98 - 3 * _hintTextHeight), 0.5, 0.05],
        [0.60, (0.98 - 1.5 * _hintTextHeight), 0.5, 0.05]
    ];
    _contentHash set [FEED_HINT_ZOOM,   [_zoomhintCtrl,     _zoomhintCtrlRelPos select _isFullscreen]];

    private _togglehintCtrl = _display ctrlCreate ["cTab_RscText_VideoFeed", -1, _contentGrpCtrl];
    _togglehintCtrl ctrlSetText LLSTRING(Video_Feed_Hint_Toggle);
    _togglehintCtrl ctrlSetFontHeight _hintFontHeight;
    private _togglehintCtrlRelPos = [
        [0.55, (0.98 - 2 * _hintTextHeight), 0.5, 0.05],
        [0.60, (0.98 - 1 * _hintTextHeight), 0.5, 0.05]
    ];
    _contentHash set [FEED_HINT_TOGGLE, [_togglehintCtrl,   _togglehintCtrlRelPos select _isFullscreen]];
};

private _fnc_createUAVControls = { //TODO: This has to be kept in sync with the fullscren variant below, but there is duplicate code and I hate it
    params ["_display", "_contentGrpCtrl", "_contentHash", "_isFullscreen"];

    private _fnc_setTextFactor = {
        if(!_isFullscreen) exitWith {};
        params ["_ctrl"];
        _ctrl ctrlSetFontHeight (ctrlFontHeight _ctrl) * 2;
    };

    private _nameCtrl = _display ctrlCreate ["cTab_RscText_VideoFeed", -1, _contentGrpCtrl];
    _nameCtrl ctrlSetText "Drone Dronedottir";
    _nameCtrl ctrlSetBackgroundColor [0, 0, 0, 0.2];
    private _nameCtrlRelPos = [
        [0, 0, 1, 0.1],
        [0, 0, 1, 0.05]
    ];
    _contentHash set [FEED_NAME,        [_nameCtrl,         _nameCtrlRelPos select _isFullscreen]];
    [_nameCtrl] call _fnc_setTextFactor;

    #define FUEL_SIZE_FACTOR 0.7
    private _fuelFontHeight = (ctrlFontHeight _nameCtrl) * FUEL_SIZE_FACTOR;
    private _fuelCtrl = _display ctrlCreate ["cTab_RscText_VideoFeed", -1, _contentGrpCtrl];
    _fuelCtrl ctrlSetText "-10=%";
    _fuelCtrl ctrlSetFontHeight _fuelFontHeight;
    private _fuelCtrlRelPos = [
        [0.88 - TEXT_MARGIN, 0, 0.1, 0.075],
        [0.88 - TEXT_MARGIN, 0, 0.1, 0.0375]
    ];
    _contentHash set [FEED_FUEL,        [_fuelCtrl,         _fuelCtrlRelPos select _isFullscreen]];
    // we derive our font height from the name ctrl after it has been adjusted, so we're fine

    private _fuelIconCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _contentGrpCtrl];
    _fuelIconCtrl ctrlSetTextColor [0, 1, 0, 1];
    _fuelIconCtrl ctrlSetText "\a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\fuelwarning_ca.paa";
    private _fuelIconCtrlRelPos = [
        [0.88 - ARMA_UI_RATIO_W(0.075), TEXT_MARGIN, ARMA_UI_RATIO_W(0.075), 0.075 - TEXT_MARGIN],
        [0.88 - ARMA_UI_RATIO_W(0.075 * FUEL_SIZE_FACTOR - TEXT_MARGIN), 0, ARMA_UI_RATIO_W(0.075 * FUEL_SIZE_FACTOR - TEXT_MARGIN), 0.075 * FUEL_SIZE_FACTOR - TEXT_MARGIN]
    ];
    _contentHash set [FEED_FUEL_ICON,   [_fuelIconCtrl,     _fuelIconCtrlRelPos select _isFullscreen]];

    private _hintFontHeight = (ctrlFontHeight _nameCtrl) * 0.7;
    [_contentGrpCtrl, _hintFontHeight, _contentHash, _isFullscreen] call _fnc_createOSDHints;

    private _controllerCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _contentGrpCtrl];
    _controllerCtrl setVariable [QGVAR(canDisable), true];
    _controllerCtrl ctrlSetActiveColor [1, 0, 0, 1];
    private _controllerCtrlRelPos = [
        [0, 0, 1, 1],
        [0, 0, 1, 1]
    ];
    _contentHash set [FEED_CONTROLLER, [_controllerCtrl,    _controllerCtrlRelPos select _isFullscreen]];

    (_controllerCtrl)
};

private _uavVideoSlotUIs = [_display, VIDEO_FEED_TYPE_UAV, _fnc_createVideoFeedGroupCtrl, _fnc_createUAVControls, IDC_CTAB_UAV_FRAME_0] call _fnc_createFramedVideoSlotUIs;
uiNamespace setVariable [QGVAR(UAVVideoSlotUIs), _uavVideoSlotUIs];

private _fnc_createHCamControls = { //TODO: This has to be kept in sync with the fullscren variant below, but there is duplicate code and I hate it
    params ["_display", "_contentGrpCtrl", "_contentHash", "_isFullscreen"];

    private _fnc_setTextFactor = {
        if(!_isFullscreen) exitWith {};
        params ["_ctrl"];
        _ctrl ctrlSetFontHeight (ctrlFontHeight _ctrl) * 2;
    };
    private _nameCtrl = _display ctrlCreate ["cTab_RscText_VideoFeed", -1, _contentGrpCtrl];
    _nameCtrl ctrlSetText "Name Nameson";
    private _nameCtrlRelPos = [
        [0, 0.1, 1, 0.1],
        [0, 0.05, 1, 0.05]
    ];
    _contentHash set [FEED_NAME,            [_nameCtrl,             _nameCtrlRelPos select _isFullscreen]];
    [_nameCtrl] call _fnc_setTextFactor;

    private _heartBeatIconCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _contentGrpCtrl];
    _heartBeatIconCtrl ctrlSetText "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIcons\u50_ca.paa";

    private _heartBeatIconCtrlRelPos = [
        [0, 0, ARMA_UI_RATIO_W(0.1), 0.1],
        [0, 0, ARMA_UI_RATIO_W(0.05), 0.05]
    ];
    _contentHash set [FEED_HEARTBEAT_ICON,  [_heartBeatIconCtrl,    _heartBeatIconCtrlRelPos select _isFullscreen]];
    [_heartBeatIconCtrl] call _fnc_setTextFactor;

    private _heartBeatTextCtrl = _display ctrlCreate ["cTab_RscText_VideoFeed", -1, _contentGrpCtrl];
    _heartBeatTextCtrl ctrlSetText "132456789";
    private _heartBeatTextCtrlRelPos = [
        [ARMA_UI_RATIO_W(0.1), 0, ARMA_UI_RATIO_W(0.9), 0.1],
        [ARMA_UI_RATIO_W(0.05), 0, ARMA_UI_RATIO_W(0.9), 0.05]
    ];
    _contentHash set [FEED_HEARTBEAT_TEXT,  [_heartBeatTextCtrl,    _heartBeatTextCtrlRelPos select _isFullscreen]];
    [_heartBeatTextCtrl] call _fnc_setTextFactor;

    private _hintFontHeight = (ctrlFontHeight _nameCtrl) * 0.7;
    [_contentGrpCtrl, _hintFontHeight, _contentHash, _isFullscreen] call _fnc_createOSDHints;

    // needs to be created last so it overlays all others
    private _controllerCtrl = _display ctrlCreate ["cTab_RscPicture", -1, _contentGrpCtrl];
    _controllerCtrl setVariable [QGVAR(canDisable), true];
    _controllerCtrl ctrlSetActiveColor [1, 0, 0, 1];
    private _controllerCtrlRelPos = [
        [0, 0, 1, 1],
        [0, 0, 1, 1]
    ];
    _contentHash set [FEED_CONTROLLER, [_controllerCtrl,            _controllerCtrlRelPos select _isFullscreen]];

    (_controllerCtrl)
};

private _hCamVideoSlotUIs = [_display, VIDEO_FEED_TYPE_HCAM, _fnc_createVideoFeedGroupCtrl, _fnc_createHCamControls, IDC_CTAB_HCAM_FRAME_0] call _fnc_createFramedVideoSlotUIs;
uiNamespace setVariable [QGVAR(HCAMVideoSlotUIs), _hCamVideoSlotUIs];
private _fnc_createFullscreenVideoSlotUI = {
    params ["_display", "_feedType", "_fnc_controlsCreationFunction", "_fullscreenGrpCtrl"];
    private _fullscreenGrpRect = ctrlPosition _fullscreenGrpCtrl;
    _fullscreenGrpRect params ["_SAX", "_SAY", "_SAW", "_SAH"];
    private ["_maxContentRect"];
    switch (GVAR(tabletFeedDealWithAspectRatioFullscreen)) do {
        case (R2T_METHOD_SHRINK) : {
            // if we shrink the texture, we shrink the content rect, too
            _maxContentRect = [[0, 0, _fullscreenGrpRect # 2, _fullscreenGrpRect # 3], R2T_METHOD_SHRINK, ALIGN_CENTER] call FUNC(positionTextureR2T);
        };
        case (R2T_METHOD_ZOOMCROP) : {
            // if we zoom and crop, we use the available area fully
            _maxContentRect = [0, 0, _fullscreenGrpRect # 2, _fullscreenGrpRect # 3];
        };
    };
    private _backgroundRect = [0, 0, _fullscreenGrpRect # 2, _fullscreenGrpRect # 3];
    private _backgroundCtrl = _display ctrlCreate ["cTab_IGUIBack", -1, _fullscreenGrpCtrl];
    _backgroundCtrl ctrlSetBackgroundColor [0.2, 0.2, 0.2, 1];
    _backgroundCtrl ctrlSetPosition _backgroundRect;
    _backgroundCtrl ctrlCommit 0;

    private _contentGrpCtrl = [_display, _feedType, "Full", _fnc_controlsCreationFunction, _fullscreenGrpCtrl, true] call _fnc_createVideoFeedGroupCtrl;
    private _contentCtrlsHash = _contentGrpCtrl getVariable QGVAR(feed_contentCtrlsHash);
    [_contentGrpCtrl, _maxContentRect, GVAR(tabletFeedDealWithAspectRatioFullscreen), _committTime] call FUNC(setVideoFeedContentGroupRect);
    _fullscreenGrpCtrl setVariable [QGVAR(contentGrpCtrl), _contentGrpCtrl];

    private _videoSlotUIData = [_fullscreenGrpCtrl];
    _fullscreenGrpCtrl ctrlShow false;

    (_videoSlotUIData)
};
private _fullscreenUAVListGrp = _display displayCtrl IDC_CTAB_UAV_FULLSCREEN_LIST;
_uavListCtrls pushBack ([_display, ctrlPosition _fullscreenUAVListGrp, _fullscreenUAVListGrp, _fnc_uavListSelChangedCallback] call _fnc_createListCtrl);
_uavVideoSlotUIs pushBack ([_display, VIDEO_FEED_TYPE_UAV, _fnc_createUAVControls, _display displayCtrl IDC_CTAB_UAV_FULLSCREEN_CNTNT] call _fnc_createFullscreenVideoSlotUI);

private _fullscreenHCamListGrp = _display displayCtrl IDC_CTAB_HCAM_FULLSCREEN_LIST;
_hCamListCtrls pushBack ([_display, ctrlPosition _fullscreenHCamListGrp, _fullscreenHCamListGrp, _fnc_hCamListSelChangedCallback] call _fnc_createListCtrl);
_hCamVideoSlotUIs pushBack ([_display, VIDEO_FEED_TYPE_HCAM, _fnc_createHCamControls, _display displayCtrl IDC_CTAB_HCAM_FULLSCREEN_CNTNT] call _fnc_createFullscreenVideoSlotUI);
