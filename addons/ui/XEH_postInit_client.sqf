#include "script_component.hpp"

#include "initKeybinds.inc.sqf"

if(IS_MOD_LOADED(ace_common)) then {
    #include "initAceActions.inc.sqf"
};

if (isNil QGVAR(videoFeedsPFHID)) then {
    GVAR(videoFeedsPFHID) = [
        {
            {
                private _type = _x;
                private _context = _y;
                private _sourcesHash = _context get QGVAR(sourcesHash);
                private _fnc_isSelected = _context get QGVAR(fnc_isSelected);
                private _fnc_updateFrameGrp = _context get QGVAR(fnc_updateFrameGrp);
                private _renderCameraDatas = _context get QGVAR(renderCamerasData);
                {
                    private _renderCamData = _y;
                    if(count _renderCamData == 0) then {continue;}; 
                    _renderCamData params ["_type", "_unitNetID", "_videoSourceData", "_camID", "_cam", "_renderTargetName", "_contentGrpCtrl"];

                    if(ctrlShown _contentGrpCtrl) then {
                        // private _contentGrpCtrl = _frameGrpCtrl getVariable QGVAR(contentGrpCtrl);
                        private _contentHash = _contentGrpCtrl getVariable QGVAR(feed_contentCtrlsHash);

                        private _sourceData = _sourcesHash get _unitNetID;
                        //TAG: video source data
                        _sourceData params ["", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];

                        private _camDamaged = _status in [LOST, DESTROYED];
                        private _camOffline = _status in [LOST, DESTROYED, OFFLINE];

                        private _tvStaticCtrl = (_contentHash get FEED_STATIC) # 0;
                        _tvStaticCtrl ctrlShow _camDamaged;
                        // _tvStaticCtrl ctrlSetText "#(ai,512,512,9)perlinNoise(256,256,0,1)";
                        // private _ditherDimension = 16;
                        // _tvStaticCtrl ctrlSetText format ["#(ai,%1,%1,1)dither(0,150)", _ditherDimension];

                        private _statusBigCtrl = (_contentHash get FEED_STATUS_BIG) # 0;
                        private _textPattern = _statusBigCtrl getVariable QGVAR(textPattern);

                        private _statusText = (GVAR(statusStrings) # _status);
                        private _fontSize = 0.3;
                        #define TW_LIMIT 0.6
                        private _textWidth = _statusText getTextWidth ["EtelkaMonospaceProBold", _fontSize];
                        if(_textWidth > TW_LIMIT) then {
                            _fontSize = (TW_LIMIT / _textWidth) * _fontSize;
                        };
                        private _newStatusString = format [_textPattern, _fontSize, (GVAR(statusStrings) # _status)];
                        _statusBigCtrl ctrlSetText _newStatusString;
                        //_statusBigCtrl ctrlSetText "#(rgb,512,512,3)text(0,0,""Caveat"",0.3,""#0000ff7f"",""#ff0000"",""Hallo\nWelt"")";
                        private _ctrlWasShown = ctrlshown _statusBigCtrl;
                        _statusBigCtrl ctrlshow _camOffline;

                        private _videoCtrl = _contentGrpCtrl getVariable QGVAR(videoCtrl);
                        private _renderTextureEnabled = !isNull _cam && !isNull _unit;
                        if(_renderTextureEnabled) then {
                            private _fov = _unit getVariable [QGVAR(targetFovHash), 0.75];
                            _cam camSetFov _fov;

                            private _visionModes = _unit getVariable [QGVAR(visionModes), [[0, 0]]];
                            private _currentVisionMode = _unit getVariable [QGVAR(currentVisionMode), 0];
                            private _visionMode = _visionModes # _currentVisionMode;
                            _renderTargetName setPiPEffect [_visionMode # 0, _visionMode # 1];
                            //TODO: Set the mode on the actual drone with setTurretOpticsMode? Will need a dirty flag so it doesn't just get overridden all the time
                            _cam camCommit 0.1;
                            //TODO: implement this properly
                            private _isSelected = _unit call _fnc_isSelected;

                            _videoCtrl ctrlSetTextColor ([[1, 1, 1, 1], [1, 0.95, 0.95, 1]] select _isSelected);
                        };
                        _videoCtrl ctrlShow _renderTextureEnabled;

                        _renderCamData call _fnc_updateFrameGrp;
                    };
                } foreach _renderCameraDatas;
            } foreach GVAR(videoSourcesContext);
        },
        0
    ] call CBA_fnc_addPerFrameHandler;
};

if (isNil QGVAR(animatedControlsPFHID)) then {
    GVAR(animatedControlsPFHID) = [
        {
            private _toRemove = [];
            {
                private _ctrl = _x;
                if(isNull _ctrl) then {
                    _toRemove pushBack _ctrl;
                    continue;
                };
                private _animationParams = _ctrl getVariable [QGVAR(animationParams), []];
                if(_animationParams isEqualTo []) then {
                    _toRemove pushBack _ctrl;
                    WARNING_1("Control [%1] is not set up to be animated. Removing from queue.",_ctrl);
                    continue;
                };
                // heartbeat delta time is the time spent in the curren animation (so 0..runtime)
                // retrieve previous animation delta time
                private _deltaTime = _ctrl getVariable [QGVAR(animDeltaTime), 0];
                _animationParams params ["_frameArray", "_runtime"];
                // calc new animation delta time
                _deltaTime = (_deltaTime + diag_deltaTime) % _runtime;
                _ctrl setVariable [QGVAR(animDeltaTime), _deltaTime];

                if(!ctrlShown _ctrl) then {continue};

                private _timePerImage = _runtime / (count _frameArray);
                private _imageIdx = floor (_deltaTime / _timePerImage);
                _ctrl ctrlSetText (_frameArray # _imageIdx);
                // INFO_1("Debug Animation: [%1] %2 @ %3 >> %4",_ctrl,_deltaTime,_runtime,_imageIdx);
            } foreach GVAR(animatedCtrls);

            GVAR(animatedCtrls) = GVAR(animatedCtrls) - _toRemove;
        },
        0
    ] call CBA_fnc_addPerFrameHandler;
};
