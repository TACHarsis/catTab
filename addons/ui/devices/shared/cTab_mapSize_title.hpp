// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Gundy
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.
//CC: This whole thing only exists to get the specifications of the current cartography
class GVAR(mapSize_dsp){
    idd = IDD_CTAB_MAPSIZE;
    onLoad = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(mapSize_dsp),_this select 0]));
    fadein = 0;
    fadeout = 0;
    duration = 10e10;
    controlsBackground[] = {};
    objects[] = {};
    class controls {
        class mapSize: cTab_RscMapControl {
            idc = IDC_CTAB_MAPSCALE;
            type = CT_MAP; // better than map_main, markers are not required and it starts positioned in map center
            x = QUOTE(safeZoneXAbs + safeZoneWAbs); // positioned outside of view
            y = QUOTE(safeZoneY + safeZoneH); // positioned outside of view
            w = QUOTE(0.01); // width is not important as we don't use it
            h = QUOTE(10); // height is important to be large as it should be more precise when reading back world coordinates
            scaleMin = 0.001;
            scaleDefault = 0.001; // 0.001 is the correct scale to figure out the scaling factor
            maxSatelliteAlpha = 0; // make the map topographical

            // basically prevent that anything gets rendered as its not required
            ptsPerSquareSea = QUOTE(10000);
            ptsPerSquareTxt = QUOTE(10000);
            ptsPerSquareCLn = QUOTE(10000);
            ptsPerSquareExp = QUOTE(10000);
            ptsPerSquareCost = QUOTE(10000);
            ptsPerSquareFor = QUOTE(10000);
            ptsPerSquareForEdge = QUOTE(10000);
            ptsPerSquareRoad = QUOTE(10000);
            ptsPerSquareObj = QUOTE(10000);
        };
    };
};
