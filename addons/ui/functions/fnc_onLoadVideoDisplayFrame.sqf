#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"
#define ANIM_LENGTH 0.3
#define DEFAULT_RATIO 1.3333333333333
#define SA_MARGIN 0.004

#define BUTTON_EXTENT_LR    (0.020)
#define BUTTON_EXTENT_UD    (0.026)

params ["_ctrlInfo", "_controls", "_screenArea", ["_foldDirection", 0, [0]]];
_ctrlInfo params ["_frameCtrl", ["_config", configNull, [configNull]]];

private _fnc_onButtonClick = {
    params ["_buttonCtrl"];

    private _frameCtrl = _buttonCtrl getVariable QGVAR(frameGroup);
    private _currentState = _frameCtrl getVariable [QGVAR(state), false];
    [_frameCtrl, !_currentState] call (_frameCtrl getVariable QGVAR(_fnc_fold));
};

private _fnc_foldFrame = {
    params ["_frameCtrl", "_newState"];
    _frameCtrl setVariable [QGVAR(state), _newState];

    private _foldingOffset = _frameCtrl getVariable QGVAR(foldingOffset);
    
    _frameCtrl getVariable QGVAR(elements) params ["_buttonCtrl", "_backgroundCtrl", "_content"];
    private _buttonTexts = _buttonCtrl getVariable QGVAR(buttonTexts);
    private _stateFactor = [1, -1] select _newState;

    // controlsGroup
    private _groupPos = ctrlPosition _frameCtrl;
    _groupPos = [
        POS_X(_groupPos) + GROUP_X(_foldingOffset) * _stateFactor,
        POS_Y(_groupPos) + GROUP_Y(_foldingOffset) * _stateFactor,
        POS_W(_groupPos) + GROUP_W(_foldingOffset) * _stateFactor,
        POS_H(_groupPos) + GROUP_H(_foldingOffset) * _stateFactor
    ];
    
    _frameCtrl ctrlSetPosition _groupPos;
    _frameCtrl ctrlCommit ANIM_LENGTH;
    // frame
    private _backgroundPos = ctrlPosition _backgroundCtrl;
    _backgroundPos set [0, POS_X(_backgroundPos) + CONTENT_X(_foldingOffset) * _stateFactor];
    _backgroundPos set [1, POS_Y(_backgroundPos) + CONTENT_Y(_foldingOffset) * _stateFactor];
    _backgroundCtrl ctrlSetPosition _backgroundPos;
    _backgroundCtrl ctrlCommit ANIM_LENGTH;

    // content
    {
        _x params ["_contentCtrl", "_ctrlRelSize"];
        
        private _contentCtrlPos = ctrlPosition _contentCtrl;
        _contentCtrlPos set [0, POS_X(_contentCtrlPos) + CONTENT_X(_foldingOffset) * _stateFactor];
        _contentCtrlPos set [1, POS_Y(_contentCtrlPos) + CONTENT_Y(_foldingOffset) * _stateFactor];
        _contentCtrl ctrlSetPosition _contentCtrlPos;
        _contentCtrl ctrlCommit ANIM_LENGTH;
    } foreach _content;

    // button
    _buttonCtrl ctrlSetText (_buttonTexts select _newState);
    private _buttonPos = ctrlPosition _buttonCtrl;
    _buttonPos set [0, POS_X(_buttonPos) + CONTENT_X(_foldingOffset) * _stateFactor];
    _buttonPos set [1, POS_Y(_buttonPos) + CONTENT_Y(_foldingOffset) * _stateFactor];
    _buttonCtrl ctrlSetPosition _buttonPos;
    _buttonCtrl ctrlCommit ANIM_LENGTH;
};


//NOTE: We are assuming an AR with W>H for the video image. H>W might blow in your face, but who plays arma like that?
[
    {
        params ["_frameCtrl", "_controls", "_screenArea", "_foldDirection", "_fnc_onButtonClick", "_fnc_foldFrame"];
        _screenArea params ["_SAX","_SAY", "_SAW", "_SAH"];

        _controls params ["_content", "_backgroundCtrl", "_buttonCtrl"];
        private _screenAR = getResolution select 4;

        // actually used area and video area, button area
        private ["_constrainedHeight", "_constrainedWidth"];
        _constrainedHeight = -2;
        _constrainedWidth = -3;
        switch (_foldDirection) do {
            case 0 /* fold left */;
            case 1 /* fold right */ : {
                _constrainedWidth = _SAW - BUTTON_EXTENT_LR;
                _constrainedHeight = _SAH;
            };
            case 2  /* fold down */;
            case 3  /* fold up */ : {
                _constrainedWidth = _SAW;
                _constrainedHeight = _SAH - BUTTON_EXTENT_UD;
            };
            default { throw format ["Not a valid folding direction: %1", _foldDirection] };
        };

        private _heightRelToSACW = _constrainedWidth / _screenAR * DEFAULT_RATIO;
        private _overflowH = _heightRelToSACW > _SAH;
        private _widthRelToSACH = _constrainedHeight * _screenAR / DEFAULT_RATIO;
        private _overflowW = _widthRelToSACH > _SAW;
        
        private ["_contentWidth", "_contentHeight"];
        switch (true) do {
            case (_overflowH || !(_overflowW || _overflowH)) : { // calc width from height, default
                _contentHeight = _constrainedHeight;
                _contentWidth = _contentHeight * _screenAR / DEFAULT_RATIO;
            };
            case (_overflowW) : { // calc height from width
                _contentWidth = _constrainedWidth;
                _contentHeight = _contentWidth / _screenAR * DEFAULT_RATIO;
            };
        };

        private ["_usedScreenAreaWidth", "_usedScreenAreaHeight"];
        private ["_backgroundWidth", "_backgroundHeight"];
        private ["_buttonWidth", "_buttonHeight"];
        switch (_foldDirection) do {
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
        private ["_backgroundPos", "_contentPos", "_buttonPos", "_groupPos"];
        private ["_foldingOffset"];
        private ["_buttonTexts"];
        switch (_foldDirection) do {
            case 0 /* fold left */ : {
                _foldingOffset = [
                    0, 0,               // group x,y
                    -_contentWidth, 0,  // group w,h
                    -_contentWidth, 0   // content x,y
                ];
                _groupPos = [
                    _SAX,
                    _SAY,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight
                ];
                _backgroundPos = [
                    0,
                    0,
                    _usedScreenAreaWidth - _buttonWidth,
                    _usedScreenAreaHeight
                ];
                _contentPos = [
                    0,
                    0.002,
                    _contentWidth,
                    _contentHeight
                ];
                _buttonPos = [
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
                _groupPos = [
                    _SAX + (_SAW - _usedScreenAreaWidth),
                    _SAY,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight
                ];
                _backgroundPos = [
                    _buttonWidth,
                    0,
                    _usedScreenAreaWidth - _buttonWidth,
                    _usedScreenAreaHeight
                ];
                _contentPos = [
                    _buttonWidth,
                    0.002,
                    _contentWidth,
                    _contentHeight
                ];
                _buttonPos = [
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
                _groupPos = [
                    _SAX,
                    _SAY + (_SAH - _usedScreenAreaHeight),
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight
                ];
                _backgroundPos = [
                    0,
                    _buttonHeight,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight - _buttonHeight
                ];
                _contentPos = [
                    0.002,
                    _buttonHeight,
                    _contentWidth,
                    _contentHeight
                ];
                _buttonPos = [
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
                _groupPos = [
                    _SAX,
                    _SAY,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight
                ];
                _backgroundPos = [
                    0,
                    0,
                    _usedScreenAreaWidth,
                    _usedScreenAreaHeight - _buttonHeight
                ];
                _contentPos = [
                    0.002,
                    0,
                    _contentWidth,
                    _contentHeight
                ];
                _buttonPos = [
                    0,
                    _contentHeight,
                    _buttonWidth,
                    _buttonHeight
                ];
                _buttonTexts = ["\/\/", "/\/\"];
            };
        };

        // group
        _frameCtrl ctrlSetPosition _groupPos;
        _frameCtrl ctrlCommit 0;
        // background
        _backgroundCtrl ctrlSetPosition _backgroundPos;
        _backgroundCtrl ctrlCommit 0;

        // video + content
        {
            _x params ["_contentCtrl", "_ctrlRelSize"];
            private _ctrlPos = [
                (POS_X(_contentPos)) + (POS_W(_contentPos)) * (POS_X(_ctrlRelSize)),
                (POS_Y(_contentPos)) + (POS_H(_contentPos)) * (POS_Y(_ctrlRelSize)),
                (POS_W(_contentPos)) * (POS_W(_ctrlRelSize)),
                (POS_H(_contentPos)) * (POS_H(_ctrlRelSize))
            ];
            _contentCtrl ctrlSetPosition _ctrlPos;
            _contentCtrl ctrlCommit 0;
        } foreach _content;

        // button
        _buttonCtrl ctrlSetPosition _buttonPos;
        _buttonCtrl ctrlEnable true;
        _buttonCtrl ctrlSetText (_buttonTexts select true);
        _buttonCtrl ctrlCommit 0;

        _buttonCtrl setVariable [QGVAR(frameGroup), _frameCtrl];
        _buttonCtrl setVariable [QGVAR(buttonTexts), _buttonTexts];
        _buttonCtrl ctrlAddEventHandler ["ButtonClick", _fnc_onButtonClick];

        _frameCtrl setVariable [QGVAR(elements), [_buttonCtrl, _backgroundCtrl, _content]];
        _frameCtrl setVariable [QGVAR(foldingOffset), _foldingOffset];
        _frameCtrl setVariable [QGVAR(state), true];
        _frameCtrl setVariable [QGVAR(_fnc_fold), _fnc_foldFrame];

        [
            {
                params ["_frameCtrl"];
                [_frameCtrl, true] call _fnc_foldFrame;
            },
            [
                _frameCtrl
            ]
        ] call CBA_fnc_execNextFrame;
    },
    [
        _frameCtrl,
        _controls,
        _screenArea,
        _foldDirection,
        _fnc_onButtonClick,
        _fnc_foldFrame
    ]
] call CBA_fnc_execNextFrame;
