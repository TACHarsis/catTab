// This file is only relevant on the server.

class GVARMAIN(settings) {
    // define vehicle classes that are equipped with FBCB2 devices
    GVARMAIN(vehicleClass_has_FBCB2)[] = {
        "MRAP_01_base_F",
        "MRAP_02_base_F",
        "MRAP_03_base_F",
        "Wheeled_APC_F",
        "Tank",
        "Truck_01_base_F",
        "Truck_03_base_F"
    };

    // define vehicle classes that are equipped with TAD devices
    GVARMAIN(vehicleClass_has_TAD)[] = {"Helicopter","Plane"};

    // define helmet classes that are equipped with a helmet cam
    GVARMAIN(helmetClass_has_HCam)[] = {
        "H_HelmetB_light",
        "H_Helmet_Kerry",
        "H_HelmetSpecB",
        "H_HelmetO_ocamo",
        "BWA3_OpsCore_Fleck_Camera",
        "BWA3_OpsCore_Schwarz_Camera",
        "BWA3_OpsCore_Tropen_Camera",
        "rhsusf_opscore_ut_pelt_nsw_cam",
        "rhsusf_opscore_paint_pelt_nsw_cam",
        "rhsusf_opscore_mc_cover_pelt_cam",
        "rhsusf_opscore_fg_pelt_cam",
        "rhsusf_opscore_ut_pelt_cam"
    };
};