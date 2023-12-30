#include "script_component.hpp"

params ["_mapCtrl", "_cursorPos", "_dikCode", "_modifierKeys", "_slotIdx", "_slotSettingsNames", "_slotSettings", "_camDataHash", "_currentSlotSettingName", "_followSettingName", "_fnc_closestFeedSource"];
_modifierKeys params ["_shiftKey", "_ctrlKey", "_altKey"];
private _display = ctrlParent _mapCtrl;
private _closestSource = [_ctrlScreen, _cursorPos] call _fnc_closestFeedSource;
private _closestFeedSourceNetID = _closestSource call BIS_fnc_netId;
private _selectedSourceNetID = [QGVARMAIN(Tablet_dlg), _currentSlotSettingName] call FUNC(getSettings);
private _selectedSource = _selectedSourceNetID call BIS_fnc_objectFromNetId;
private _assignedSettingName = _slotSettingsNames # _slotIdx;
private _assignedSourceNetID = [QGVARMAIN(Tablet_dlg), _assignedSettingName] call FUNC(getSettings);
private _assignedSource = _assignedSourceNetID call BIS_fnc_objectFromNetId;

private _fnc_assignToFrameSlot = {
    params [["_sourceNetID", "", [""]]];
    // NOTE: using _assignedSettingName as local variable from parent scope for convenience
    [QGVARMAIN(Tablet_dlg), [[_assignedSettingName, _sourceNetID]], true, true] call FUNC(setSettings);
};
private _fnc_select = {
    params [["_sourceNetID", "", [""]]];
    // NOTE: using _currentSlotSettingName as local variable from parent scope for convenience
    [QGVARMAIN(Tablet_dlg), [[_currentSlotSettingName, _sourceNetID]], true, true] call FUNC(setSettings);
};
private _fnc_toggleFollow = {
    params ["_follow"];
    // NOTE: using _followSettingName as local variable from parent scope for convenience
    if(isNil "_follow") then {
        private _following = [QGVARMAIN(Tablet_dlg), _followSettingName] call FUNC(getSettings);
        _follow = !_following;
    };
    [QGVARMAIN(Tablet_dlg), [[_followSettingName, _follow]], true, true] call FUNC(setSettings);
};
private _fnc_toggleAssignedFrame = {
    // NOTE: using _camDataHash, _assignedSettingName as local variables from parent scope for convenience
    private _camData = _camDataHash get _assignedSettingName;
    _camData params ["_camID", "_object", "_renderTargetName", "_cam", "_frameCtrl"];
    [_frameCtrl] call (_frameCtrl getVariable QGVAR(_fnc_fold));
};
switch (true) do {
    case (_ctrlKey) : {
        if (!isNull _selectedSource) then { // we have sth selected already
            if (_selectedSource isNotEqualTo _assignedSource) then { // it's different from the source in the slot
                //setting new selected source
                // ["CTRL+%1 pressed. Saving selected %2 to frame %3", keyName _dikCode, _selectedSource, _slotIdx] call FUNCMAIN(debugLog);
                [_selectedSourceNetID] call _fnc_assignToFrameSlot;
            };
        } else { // we have nothing selected right now
            if !(isNull _closestSource) then { // there is a valid source nearby
                //select and assign to slot
                // ["CTRL+%1 pressed. Saving nearby %2 to frame %3", keyName _dikCode, _closestSource, _slotIdx] call FUNCMAIN(debugLog);
                [_closestFeedSourceNetID] call _fnc_select;
                [_closestFeedSourceNetID] call _fnc_assignToFrameSlot;
            } else { // there no valid source nearby
                // deselect current soure and unassign slot
                // ["CTRL+%1 pressed. Nothing selected nor nearby. Deselecting frame %2", keyName _dikCode, _slotIdx] call FUNCMAIN(debugLog);
                [] call _fnc_select;
                [] call _fnc_assignToFrameSlot;
            };
        };
    };
    case (_shiftKey) : {};
    case (_altKey) : {
        if(!isNull _assignedSource) then {
            // toggle frame folding
            [_assignedSourceNetID] call _fnc_toggleAssignedFrame;
        };
    };
    default {
        if !(isNull _assignedSource) then {
            if(_assignedSource isNotEqualTo _selectedSource) then { // we do not have it selected right now
                //recall respective UAV
                // ["Pressed %1, selecting %2 from slot %3.", keyName _dikCode, _assignedSource, _slotIdx] call FUNCMAIN(debugLog);
                [_assignedSourceNetID] call _fnc_select;
            } else { // we already have it selected, so toggle follow
                [] call _fnc_toggleFollow;
            };
        } else {
            // deselect current uav
            // ["Pressed %1, but there was no source assigned to slot %2.", keyName _dikCode, _slotIdx] call FUNCMAIN(debugLog);
            [] call _fnc_select;
        };
    };
};
