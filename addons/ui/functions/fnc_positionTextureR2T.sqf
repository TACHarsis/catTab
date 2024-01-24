#include "script_component.hpp"
params ["_rect", ["_method", R2T_METHOD_SHRINK, [-1]], ["_alignment", DO_NOT_ALIGN, [1]]];
private _rectCnt = count _rect;
if(_rectCnt != 2 && _rectCnt != 4) exitWith { throw format ["[ShrinkToFit] Wrong number of arguments: %1, expected 2 or 4", _rectCnt] };
if(_rectCnt == 2) then {
    _rect = [0, 0, _rect # 0, _rect # 1];
};
_rect params ["_rectX", "_rectY", "_rectW", "_rectH"];
if(_method >= NUM_R2T_METHODS || _method < 0) then {
    _method = R2T_METHOD_SHRINK;
};
private _screenAR = getResolution select 4;
private _heightFromWidth = _rectW / _screenAR * ARMA_UI_RATIO;
private _widthFromHeight = _rectH * _screenAR / ARMA_UI_RATIO;
private _originalULCorner = [_rectX, _rectY];
// private _originalULCorner = [0, 0];
private _overflowPerMethods = [
/*R2T_METHOD_SHRINK */  [
                            _originalULCorner + [_widthFromHeight, _rectH], // either we fit perfectly, or using full width would cause a vertical overflow, calc width from height therefore
                            _originalULCorner + [_rectW, _heightFromWidth] // using full height would cause horizontal overflow, calc height from using full width instead
                        ],
/*R2T_METHOD_ZOOMCROP*/ [
                            _originalULCorner + [_rectW, _heightFromWidth], // width fits and we overflow vertically
                            _originalULCorner + [_widthFromHeight, _rectH] // height fits and we overflow horizontally
                        ]
];
private _screenAR = getResolution select 4;
private _wouldOverflowWidth = (_rectH * _screenAR / ARMA_UI_RATIO) > _rectW;
private _unalignedContentRect = (_overflowPerMethods # _method) select _wouldOverflowWidth;
[_rect, _unalignedContentRect, _alignment] call FUNC(alignRectInRect)
