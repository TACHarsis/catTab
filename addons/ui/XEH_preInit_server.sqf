#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.
#include "devices\shared\cTab_gui_macros.hpp"

// Exit if this is machine has no interface, i.e. is a headless client (HC)
if !(hasInterface) exitWith {};

GVAR(userMarkerListsServer) = createHashMap;
GVAR(userMarkerTransactionIdServer) = -1;