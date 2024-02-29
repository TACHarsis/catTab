#include "script_component.hpp"

params ["_contentCtrlsHash", "_contentArea", ["_commitTime", 0, [1]]];

{
    _y params ["_contentCtrl", "_ctrlRelSize"];
    private _ctrlPos = [
        (POS_X(_contentArea)) + (POS_W(_contentArea)) * (POS_X(_ctrlRelSize)),
        (POS_Y(_contentArea)) + (POS_H(_contentArea)) * (POS_Y(_ctrlRelSize)),
        (POS_W(_contentArea)) * (POS_W(_ctrlRelSize)),
        (POS_H(_contentArea)) * (POS_H(_ctrlRelSize))
    ];
    _contentCtrl ctrlSetPosition _ctrlPos;
    _contentCtrl ctrlCommit _commitTime;
} foreach _contentCtrlsHash;
