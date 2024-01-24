#include "script_component.hpp"
params ["_unitNetID"];
{
    private _type = _x;
    private _context = _y;
    private _sourcesHash = _context get QGVAR(sourcesHash);
    if(_unitNetID in _sourcesHash) then
    {
        private _sourceData = _sourcesHash deleteAt _unitNetID;
        [QGVAR(videoSourceRemoved), [_type, _sourceData]] call CBA_fnc_localEvent;
    };
} foreach GVAR(videoSourcesContext);
