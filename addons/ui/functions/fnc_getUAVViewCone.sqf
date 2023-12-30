#include "script_component.hpp"

params ["_uav","_uavViewdata"];
//TODO: Cache?
_uavViewData params ["_uavLookOrigin", "_uavLookDir", "_hitOccured", "_aimPoint", "_intersectRayTarget"];

private _los = _aimPoint vectorDiff _uavLookOrigin; 
_los set [2, 0];
private _losOrigin = [_uavLookOrigin # 0,_uavLookOrigin # 1, 0];

private _uavFOV = [0.1, 0.5, getObjectFOV _uav] call BIS_fnc_clamp;
private _halfAngleOfView = atan(_uavFOV);

private _leftLeg = (vectorNormalized _los) vectorMultiply ((vectorMagnitude _los) * 1.25);
private _rightLeg = _leftLeg;
_leftLeg = [_leftLeg, _halfAngleOfView,2] call BIS_fnc_rotateVector3D;
_rightLeg = [_rightLeg, -_halfAngleOfView,2] call BIS_fnc_rotateVector3D;

private _leftCorner = _leftLeg vectorAdd _losOrigin;
private _rightCorner = _rightLeg vectorAdd _losOrigin;

private _uavViewConeVertices = [_losOrigin,_leftCorner];
private _arcVertices = [];
private _angle = 2 * -_halfAngleOfView;
for "_i" from 0 to 1 step 0.05 do {
    _arcVertices pushBack (_losOrigin vectorAdd ([_leftLeg, (_i * _angle),2] call BIS_fnc_rotateVector3D));
};

_uavViewConeVertices append _arcVertices;
_uavViewConeVertices pushBack _rightCorner;
    
_uavViewConeVertices
