#include "script_component.hpp"

params ["_ctrlScreen"];

// is disableSerialization really required? If so, not sure this is the right place to call it
disableSerialization;

private _displaySettings = [QGVARMAIN(Tablet_dlg)] call FUNC(getSettings);
private _display = ctrlParent _ctrlScreen;

[QGVARMAIN(Tablet_dlg),_this] call FUNC(drawMapControl);
