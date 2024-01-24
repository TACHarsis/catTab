#include "script_component.hpp"
params [["_rectOuter", [0, 0, 0, 0], [[]], [4]], ["_rectInner", [0, 0, 0, 0], [[]], [ 4]], ["_alignment", ALIGN_CENTER, [1]]];
if(_alignment < 0) exitWith { _rectInner };
if(_alignment > NUM_ALIGNMENTS) then {
    _alignment = ALIGN_CENTER;
};
_rectInner params ["", "", "_rectInnerW", "_rectInnerH"];
_rectOuter params ["", "", "_rectOuterW", "_rectOuterH"];
private _overFlowW = _rectInnerW - _rectOuterW;
private _overFlowH = _rectInnerH - _rectOuterH;
private _xAlignC = -0.5 * _overFlowW;
private _xAlignR = -_overFlowW;
private _yAlignC = -0.5 * _overFlowH;
private _yAlignB = -_overFlowH;
private _alignments = [
/*ALIGN_CENTERLEFT*/        [0,         _yAlignC],
/*ALIGN_CENTER*/            [_xAlignC,  _yAlignC],
/*ALIGN_CENTERRIGHT*/       [_xAlignR,  _yAlignC],
/*ALIGN_UPLEFT*/            [0,         0],
/*ALIGN_UPCENTER*/          [_xAlignC,  0],
/*ALIGN_UPRIGHT*/           [_xAlignR,  0],
/*ALIGN_LOLEFT*/            [0,         _yAlignB],
/*ALIGN_LOCENTER*/          [_xAlignC,  _yAlignB],
/*ALIGN_LORIGHT*/           [_xAlignR,  _yAlignB]
];
private _return = (_alignments # _alignment) + [_rectInnerW, _rectInnerH];
_return
