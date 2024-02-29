#include "script_component.hpp"

params ["_ctrlsGrpCtrl", "_rect", "_aspectRatioMethod", ["_commitTime", 0, [1]]];

_ctrlsGrpCtrl ctrlSetPosition _rect;
_ctrlsGrpCtrl ctrlCommit _commitTime;
//TODO: Should we do a waitUntil for the commit to finish before proceeding or just let it all happen in parallel?

private _contentCtrlsHash = _contentGrpCtrl getVariable QGVAR(feed_contentCtrlsHash);
private _ctrlsGrpCtrlRect = ctrlPosition _ctrlsGrpCtrl;
private _contentRect = [0, 0, _rect # 2, _rect # 3];

[_contentCtrlsHash, _contentRect, _commitTime] call FUNC(fitContentControlsByRelativeSize);

private _videoCtrl = _contentGrpCtrl getVariable QGVAR(videoCtrl);
private _ratioFixedTextureRect = [_contentRect, _aspectRatioMethod, ALIGN_CENTER] call FUNC(positionTextureR2T);
_videoCtrl ctrlSetPosition _ratioFixedTextureRect;
_videoCtrl ctrlCommit _commitTime;
