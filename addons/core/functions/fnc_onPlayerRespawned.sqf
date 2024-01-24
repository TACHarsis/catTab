#include "script_component.hpp"

params ["_unit", "_corpse"];

private _corpseNetID = _corpse call BIS_fnc_netId;

[_corpseNetID] call FUNC(removeVideoSource);
GVAR(deadExclusionList) pushBack _corpseNetID;
private _unitNetID = _unit call BIS_fnc_netId;
[VIDEO_FEED_TYPE_HCAM, _unitNetID, true] call FUNC(updateVideoSource);

[QGVAR(videoSourceReplaced), [_corpseNetID, _unitNetID]] call CBA_fnc_localEvent;
