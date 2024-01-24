#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
#define ANIM_LENGTH 0.3
#define SA_MARGIN 0.004

#define BUTTON_EXTENT_LR    (0.020)
#define BUTTON_EXTENT_UD    (0.026)

params ["_frameGrpCtrl", ["_foldingDirection", 0, [0]]];

private _fnc_onButtonClick = {
    params ["_toggleButtonCtrl"];

    private _frameGrpCtrl = _toggleButtonCtrl getVariable QGVAR(frameGrpCtrl);
    private _currentState = _frameGrpCtrl getVariable [QGVAR(state), false];
    [_frameGrpCtrl, !_currentState] call (_frameGrpCtrl getVariable QGVAR(fnc_fold));
};

private _fnc_foldFrame = {
    params ["_frameGrpCtrl", "_newState"];
    //TODO: Handle this more gracefully with a buffer instead of just denying it.
    if(!ctrlCommitted _frameGrpCtrl) exitWith {};
    if(isNil "_newState") then {
        _newState = !(_frameGrpCtrl getVariable [QGVAR(state), false]);
    };
    _frameGrpCtrl setVariable [QGVAR(state), _newState];

    private _foldingOffset = _frameGrpCtrl getVariable QGVAR(foldingOffset);

    private _backgroundCtrl = _frameGrpCtrl getVariable QGVAR(backgroundCtrl);
    private _toggleButtonCtrl = _frameGrpCtrl getVariable QGVAR(toggleButtonCtrl);
    private _contentGrpCtrl = _frameGrpCtrl getVariable QGVAR(contentGrpCtrl);

    // diag_log format ["[FOLD]: _backgroundCtrl: %1, _toggleButtonCtrl: %2, _contentGrpCtrl: %3", _backgroundCtrl, _toggleButtonCtrl, _contentGrpCtrl];

    private _buttonTexts = _toggleButtonCtrl getVariable QGVAR(buttonTexts);
    private _stateFactor = [1, -1] select _newState;

    // controlsGroup
    private _groupRect = ctrlPosition _frameGrpCtrl;
    _groupRect = [
        POS_X(_groupRect) + GROUP_X(_foldingOffset) * _stateFactor,
        POS_Y(_groupRect) + GROUP_Y(_foldingOffset) * _stateFactor,
        POS_W(_groupRect) + GROUP_W(_foldingOffset) * _stateFactor,
        POS_H(_groupRect) + GROUP_H(_foldingOffset) * _stateFactor
    ];
    _frameGrpCtrl ctrlSetPosition _groupRect;
    _frameGrpCtrl ctrlCommit ANIM_LENGTH;
    // frame
    private _backgroundRect = ctrlPosition _backgroundCtrl;
    _backgroundRect set [0, POS_X(_backgroundRect) + CONTENT_X(_foldingOffset) * _stateFactor];
    _backgroundRect set [1, POS_Y(_backgroundRect) + CONTENT_Y(_foldingOffset) * _stateFactor];
    _backgroundCtrl ctrlSetPosition _backgroundRect;
    _backgroundCtrl ctrlCommit ANIM_LENGTH;

    private _contentGrpCtrlRect = ctrlPosition _contentGrpCtrl;
    _contentGrpCtrlRect set [0, POS_X(_contentGrpCtrlRect) + CONTENT_X(_foldingOffset) * _stateFactor];
    _contentGrpCtrlRect set [1, POS_Y(_contentGrpCtrlRect) + CONTENT_Y(_foldingOffset) * _stateFactor];
    _contentGrpCtrl ctrlSetPosition _contentGrpCtrlRect;
    // diag_log format ["[FOLD]: _contentGrpCtrl: %1, _contentGrpCtrlRect: %2", _contentGrpCtrl, _contentGrpCtrlRect];
    _contentGrpCtrl ctrlCommit ANIM_LENGTH;

    // button
    _toggleButtonCtrl ctrlSetText (_buttonTexts select _newState);
    private _buttonRect = ctrlPosition _toggleButtonCtrl;
    _buttonRect set [0, POS_X(_buttonRect) + CONTENT_X(_foldingOffset) * _stateFactor];
    _buttonRect set [1, POS_Y(_buttonRect) + CONTENT_Y(_foldingOffset) * _stateFactor];
    _toggleButtonCtrl ctrlSetPosition _buttonRect;
    _toggleButtonCtrl ctrlCommit ANIM_LENGTH;
};
//NOTE: We are assuming an AR with W>H for the video image. H>W might blow in your face, but who plays arma like that?
[
    {
        params ["_frameGrpCtrl", "_foldingDirection", "_fnc_onButtonClick", "_fnc_foldFrame"];
        private _frameRect = ctrlPosition _frameGrpCtrl;
        _frameRect params ["_frameRect_X", "_frameRect_Y", "_frameRect_W", "_frameRect_H"];
        private _backgroundCtrl = _frameGrpCtrl getVariable QGVAR(backgroundCtrl);
        private _toggleButtonCtrl = _frameGrpCtrl getVariable QGVAR(toggleButtonCtrl);
        private _contentGrpCtrl = _frameGrpCtrl getVariable QGVAR(contentGrpCtrl);

        private ["_maxScreenRect"];
        switch (GVAR(tabletFeedDealWithAspectRatio)) do {
            case (R2T_METHOD_SHRINK) : {
                // if we shrink the texture, we shrink the frame around it, too
                _maxScreenRect = [_screenRect, R2T_METHOD_SHRINK, ALIGN_UPLEFT] call FUNC(positionTextureR2T);
            };
            case (R2T_METHOD_ZOOMCROP) : {
                // if we zoom and crop, we use the available area fully
                _maxScreenRect = [_frameRect_X, _frameRect_Y, _frameRect_W, _frameRect_H];
            };
        };
        // diag_log format ["[LOADVIDEOFRAME]: _frameRect: %1, _maxScreenRect: %2", _frameRect, _maxScreenRect];

        //TODO: Text and figure out how well up/down works and if it should be optional, also if the same alignment problem exists
        // actually used content and video area, minus button area (and margins?)
        private ["_contentWidth", "_contentHeight"];
       //TODO: this needs adjustment for the x,y, too, right?
        switch (_foldingDirection) do {
            case 0 /* fold left */;
            case 1 /* fold right */ : {
                _contentWidth = (_maxScreenRect # 2) - BUTTON_EXTENT_LR;
                _contentHeight = (_maxScreenRect # 3);
            };
            case 2  /* fold down */;
            case 3  /* fold up */ : {
                _contentWidth = (_maxScreenRect # 2);
                _contentHeight = (_maxScreenRect # 3) - BUTTON_EXTENT_UD;
            };
            default { throw format ["Not a valid folding direction: %1", _foldingDirection] };
        };

        private ["_usedScreenAreaWidth", "_usedScreenAreaHeight"];
        private ["_backgroundWidth", "_backgroundHeight"];
        private ["_buttonWidth", "_buttonHeight"];
        switch (_foldingDirection) do {
            case 0 /* fold left */;
            case 1  /* fold right */ : {
                _buttonWidth = BUTTON_EXTENT_LR;
                _usedScreenAreaWidth = _contentWidth + _buttonWidth;
                _backgroundWidth = _contentWidth;
                _usedScreenAreaHeight = _contentHeight + SA_MARGIN;
                _backgroundHeight = _usedScreenAreaHeight;
                _buttonHeight = _usedScreenAreaHeight;
            };
            case 2  /* fold down */;
            case 3  /* fold up */ : {
                _usedScreenAreaWidth = _contentWidth + SA_MARGIN;
                _backgroundWidth = _usedScreenAreaWidth;
                _buttonWidth = _usedScreenAreaWidth;
                _buttonHeight = BUTTON_EXTENT_UD;
                _usedScreenAreaHeight = _contentHeight + _buttonHeight;
                _backgroundHeight = _contentHeight;
            };
        };
        private ["_backgroundRect", "_contentRect", "_buttonRect", "_groupRect"];
        private ["_foldingOffset"];
        private ["_buttonTexts"];
        private ["_alignment"];
        switch (_foldingDirection) do {
            case 0 /* fold left */ : {
                _foldingOffset = [
                    0, 0,               // group x,y
                    -_contentWidth, 0,  // group w,h
                    -_contentWidth, 0   // content x,y
                ];
                _groupRect = [
                    _frameRect_X,
                    _frameRect_Y,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight
                ];
                _backgroundRect = [
                    0,
                    0,
                    _usedScreenAreaWidth - _buttonWidth,
                    _usedScreenAreaHeight
                ];
                _contentRect = [
                    0,
                    0.002,
                    _contentWidth,
                    _contentHeight
                ];
                _buttonRect = [
                    _contentWidth,
                    0,
                    _buttonWidth,
                    _buttonHeight
                ];
                _buttonTexts = [">>", "<<"];
            };
            case 1  /* fold right */ : {
                _foldingOffset = [
                    _contentWidth, 0,   // group x,y
                    -_contentWidth, 0,   // group w,h
                    0, 0                // content x,y
                ];
                _groupRect = [
                    _frameRect_X + (_frameRect_W - _usedScreenAreaWidth),
                    _frameRect_Y,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight
                ];
                _backgroundRect = [
                    _buttonWidth,
                    0,
                    _usedScreenAreaWidth - _buttonWidth,
                    _usedScreenAreaHeight
                ];
                _contentRect = [
                    _buttonWidth,
                    0.002,
                    _contentWidth,
                    _contentHeight
                ];
                _buttonRect = [
                    0,
                    0,
                    _buttonWidth,
                    _buttonHeight
                ];
                _buttonTexts = ["<<", ">>"];
            };
            case 2  /* fold down */ : {
                _foldingOffset = [
                    0, _contentHeight,  // group x,y
                    0, _contentHeight,  // group w,h
                    0, 0                // content x,y
                ];
                _groupRect = [
                    _frameRect_X,
                    _frameRect_Y + (_frameRect_H - _usedScreenAreaHeight),
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight
                ];
                _backgroundRect = [
                    0,
                    _buttonHeight,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight - _buttonHeight
                ];
                _contentRect = [
                    0.002,
                    _buttonHeight,
                    _contentWidth,
                    _contentHeight
                ];
                _buttonRect = [
                    0,
                    0,
                    _buttonWidth,
                    _buttonHeight
                ];
                _buttonTexts = ["/\/\", "\/\/"];
            };
            case 3  /* fold up */ : {
                _foldingOffset = [
                    0, 0,               // group x,y
                    0, -_contentHeight, // group w,h
                    0, -_contentHeight  // content x,y
                ];
                _groupRect = [
                    _frameRect_X,
                    _frameRect_Y,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight
                ];
                _backgroundRect = [
                    0,
                    0,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight - _buttonHeight
                ];
                _contentRect = [
                    0.002,
                    0,
                    _contentWidth,
                    _contentHeight
                ];
                _buttonRect = [
                    0,
                    _contentHeight,
                    _buttonWidth,
                    _buttonHeight
                ];
                _buttonTexts = ["\/\/", "/\/\"];
            };
        };

        private _committTime = 0;
        // group
        _frameGrpCtrl ctrlSetPosition _groupRect;
        _frameGrpCtrl ctrlCommit _committTime;
        // background
        _backgroundCtrl ctrlSetPosition _backgroundRect;
        _backgroundCtrl ctrlCommit _committTime;
        // video + content
        [_contentGrpCtrl, _contentRect, GVAR(tabletFeedDealWithAspectRatio), _committTime] call FUNC(setVideoFeedContentGroupRect);
        // diag_log format ["[LOADVIDEOFRAME]: _groupRect: %1, _contentRect: %2, _backgroundRect: %3", _groupRect, _contentRect, _backgroundRect];
        // button
        _toggleButtonCtrl ctrlSetPosition _buttonRect;
        _toggleButtonCtrl ctrlEnable true;
        _toggleButtonCtrl ctrlSetText (_buttonTexts select true);
        _toggleButtonCtrl ctrlCommit _committTime;

        _toggleButtonCtrl setVariable [QGVAR(frameGrpCtrl), _frameGrpCtrl];
        _toggleButtonCtrl setVariable [QGVAR(buttonTexts), _buttonTexts];
        _toggleButtonCtrl ctrlAddEventHandler ["ButtonClick", _fnc_onButtonClick];

        _frameGrpCtrl setVariable [QGVAR(foldingOffset), _foldingOffset];
        _frameGrpCtrl setVariable [QGVAR(state), true];
        _frameGrpCtrl setVariable [QGVAR(fnc_fold), _fnc_foldFrame];

        [
            {
                params ["_frameGrpCtrl"];
                [_frameGrpCtrl, true] call _fnc_foldFrame;
            },
            [
                _frameGrpCtrl
            ]
        ] call CBA_fnc_execNextFrame;
    },
    [
        _frameGrpCtrl,
        _foldingDirection,
        _fnc_onButtonClick,
        _fnc_foldFrame
    ]
] call CBA_fnc_execNextFrame;
