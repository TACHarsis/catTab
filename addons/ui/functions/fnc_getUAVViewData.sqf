#include "script_component.hpp"
params ["_uav"];
//TODO: Cache?
private _camPosMemPt = getText (configFile >> "CfgVehicles" >> typeOf _uav >> "uavCamera" + "Gunner" + "Pos");
private _camDirMemPt = getText (configFile >> "CfgVehicles" >> typeOf _uav >> "uavCamera" + "Gunner" + "Dir");
private _uavLookDirPos = _uav selectionPosition (_camDirMemPt);
private _uavLookDir = _uav vectorModelToWorld ((_uav selectionPosition (_camPosMemPt)) vectorFromTo (_uavLookDirPos));
private _uavLookOrigin = _uav ModelToWorld _uavLookDirPos;
private _uavLookOriginASL = AGLToASL _uavLookOrigin;
private _intersectRayTarget = _uavLookOrigin vectorAdd (_uavLookDir vectorMultiply 3000);
private _intersections = lineIntersectsSurfaces [_uavLookOriginASL, (AGLToASL _intersectRayTarget), _uav];
private _hitOccured = count _intersections > 0;
private _aimPointASL = if(_hitOccured) then { (_intersections select 0 select 0) } else { _intersectRayTarget };
private _aimPoint = ASLToAGL _aimPointASL;
[_uavLookOrigin, _uavLookDir, _hitOccured, _aimPoint, _intersectRayTarget]
