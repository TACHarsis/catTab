#include "script_component.hpp"
// DMC_CONDITION            (CODE) condition
// whether to render at all
// DMC_DRAW_MARKERS         (ARRAY,CODE), [(useCursorHighlight),mode] >> Mode is 0 = Normal, 1 = TAD, 2 = MicroDAGR
// draw user and bft markers, whether to use cursor highlight and what "mode" is being drawn
// DMC_SAVE_SCALE_POSITION  *(ANY), value not used
// save current map scale and position, value not used (can be nil) //CC not 100% clear why needed
// DMC_HUMAN_AVATAR         (ARRAY,CODE)DN, [OBJECT/CODE(,OBJECT/CODE,..)]
// draw a human avatar for each unit in array, more generally a circle with an arrow, better name needed. pass objNull to draw at player location
// DMC_VEHICLE_AVATAR       *(STRING,CODE)D
// draw vehicle avatar. will default to same as "human" avatar if no icon string supplied (can be nil)
// DMC_DRAW_HOOK            *(ARRAY,CODE)D, [STRING, BOOL] >> [QDEVICE_GROUND,QDEVICE_AIR]
// Draw "hook" from reference center to mouse cursor (or other way round) and draw instruments that display related data
// DMC_RECENTER             (ARRAY,CODE), [OBJECT/CODE(,SCALAR/CODE)]
// Recenter on object (player if nil) with scale (GVAR(mapScale) if nil)


GVAR(displayDrawOptions) = createHashMapFromArray [
    [QGVARMAIN(Tablet_dlg),     createHashMapFromArray [
                                    [DMC_CONDITION,             {true}],
                                    [DMC_DRAW_MARKERS,          {
                                        params ["_displayName", "_displaySettinggs"];
                                        private _mode = [_displayName,QSETTING_MODE] call FUNC(getSettings);
                                        private _options = [true,[
                                            DMC_BFT_VEHICLES,
                                            DMC_BFT_GROUPS,
                                            DMC_BFT_MEMBERS
                                        ]];
                                        if(_mode isEqualTo QSETTING_MODE_CAM_UAV) then { (_options#1) pushBack DMC_BFT_UAV};

                                        _options
                                    }],
                                    //TODO: this still needs to be made compatible with helmet cam and uav mode.
                                    // [QGVAR(TABLET_UAVS),        createHashMapFromArray [
                                    //                                 [DMC_CONDITION,             {/* !(isNull GVAR(currentUAV)) &&  */(GVAR(currentUAV) isNotEqualTo Ctab_player)}],
                                    //                                 [DMC_SAVE_SCALE_POSITION,   {isNull GVAR(currentUAV)}],
                                    //                                 [DMC_HUMAN_AVATAR,          {[[objNull], [GVAR(currentUAV), objNull]] select GVAR(trackCurrentUAV)}]
                                    // [QGVAR(TABLET_HCAM),          createHashMapFromArray [
                                    //                                 [DMC_CONDITION,             {!(isNil QGVAR(helmetCamData))}],
                                    //                                 [DMC_SAVE_SCALE_POSITION,   {isNil QGVAR(helmetCamData)}],
                                    //                                 [DMC_HUMAN_AVATAR,          {[[objNull], [GVAR(helmetCamData) select 2, objNull]] select !isNil QGVAR(helmetCamData)}]
                                    [DMC_SAVE_SCALE_POSITION,   {true}],
                                    [DMC_RECENTER,              {
                                        params ["_displayName", "_displaySettinggs"];
                                        private _mode = [_displayName,QSETTING_MODE] call FUNC(getSettings);
                                        switch (_mode) do {
                                            case (QSETTING_MODE_CAM_UAV) : {
                                                [[-1,0] select GVAR(trackCurrentUAV), GVAR(currentUAV), GVAR(mapScaleUAV)]
                                            };
                                            case (QSETTING_MODE_CAM_HELMET) : {
                                                [[-1,0] select GVAR(trackCurrentHCam), GVAR(helmetCamData) select 2, GVAR(mapScaleHCam)]
                                            };
                                            default {
                                                [-1, "", ""]
                                            };
                                        }
                                    }],
                                    [DMC_HUMAN_AVATAR,          [objNull]],
                                    [DMC_DRAW_HOOK,             nil]
                                ]
    ],
    [QGVARMAIN(Android_dlg),    createHashMapFromArray [
                                    [DMC_CONDITION,             {true}],
                                    [DMC_DRAW_MARKERS,          [true,[
                                        DMC_BFT_VEHICLES,
                                        DMC_BFT_GROUPS,
                                        DMC_BFT_MEMBERS
                                    ]]],
                                    [DMC_SAVE_SCALE_POSITION,   true],
                                    [DMC_HUMAN_AVATAR,          [objNull]],
                                    [DMC_DRAW_HOOK,             nil]
                                ]
    ],
    [QGVARMAIN(Android_dsp),    createHashMapFromArray [
                                    [DMC_CONDITION,             {true}],
                                    [DMC_DRAW_MARKERS,          [false,[
                                        DMC_BFT_VEHICLES,
                                        DMC_BFT_GROUPS,
                                        DMC_BFT_MEMBERS
                                    ]]],
                                    [DMC_RECENTER,              [player]],
                                    [DMC_HUMAN_AVATAR,          [objNull]]
                                ]
    ],
    [QGVARMAIN(FBCB2_dlg),      createHashMapFromArray [
                                    [DMC_CONDITION,             {true}],
                                    [DMC_DRAW_MARKERS,          [true,[
                                        DMC_BFT_VEHICLES,
                                        DMC_BFT_GROUPS,
                                        DMC_BFT_MEMBERS
                                    ]]],
                                    [DMC_SAVE_SCALE_POSITION,   true],
                                    [DMC_HUMAN_AVATAR,          [objNull]],
                                    [DMC_DRAW_HOOK,             nil]
                                ]
    ],
    [QGVARMAIN(TAD_dsp),        createHashMapFromArray[
                                    [DMC_CONDITION,             {true}],
                                    [DMC_DRAW_MARKERS,          [false,[
                                        DMC_BFT_VEHICLES,
                                        DMC_BFT_GROUPS,
                                        DMC_BFT_MEMBERS
                                    ]]],
                                    [DMC_RECENTER,              [player]],
                                    [DMC_VEHICLE_AVATAR,        {GVAR(playerVehicleIcon)}],
                                    [DMC_TAD_OVERLAY,           nil]
                                ]
    ],
    [QGVARMAIN(TAD_dlg),        createHashMapFromArray [
                                    [DMC_CONDITION,             {true}],
                                    [DMC_DRAW_MARKERS,          [true,[
                                        DMC_BFT_VEHICLES,
                                        DMC_BFT_GROUPS,
                                        DMC_BFT_MEMBERS
                                    ]]],
                                    [DMC_SAVE_SCALE_POSITION,   true],
                                    [DMC_VEHICLE_AVATAR,        {GVAR(playerVehicleIcon)}],
                                    [DMC_DRAW_HOOK,             nil]
                                ]
    ],
    [QGVARMAIN(microDAGR_dsp),  createHashMapFromArray [
                                    [DMC_CONDITION,             {true}],
                                    [DMC_DRAW_MARKERS,          [false,[
                                        DMC_BFT_MEMBERS
                                    ]]],
                                    [DMC_RECENTER,              [player]],
                                    [DMC_HUMAN_AVATAR,          [objNull]]
                                ]
    ],
    [QGVARMAIN(microDAGR_dlg),  createHashMapFromArray [
                                    [DMC_CONDITION,             {true}],
                                    [DMC_DRAW_MARKERS,          [true,[
                                        DMC_BFT_MEMBERS
                                    ]]],
                                    [DMC_SAVE_SCALE_POSITION,   true],
                                    [DMC_HUMAN_AVATAR,          [objNull]],
                                    [DMC_DRAW_HOOK,             nil]
                                ]
    ]
];
