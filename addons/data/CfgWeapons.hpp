class CfgWeapons {
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;
    class ItemcTab: CBA_MiscItem {
        descriptionshort = "DK10 Rugged Tablet PC";
        descriptionuse = "<t color='#9cf953'>Use: </t>Show Commander's Tablet";
        displayname = "Rugged Tablet";
        picture = QPATHTOF(img\icons\icon_dk10.paa);
        model = QPATHTOF(models\itemDK10.p3d);
        scope = 2;
        class ItemInfo : CBA_MiscItem_ItemInfo {
            mass = 20;
        };
        author = LEGACY_AUTHOR;
    };
    
    class ItemAndroid: ItemcTab {
        descriptionshort = "GD300 Rugged Wearable Computer";
        descriptionuse = "<t color='#9cf953'>Use: </t>Show Android Based BFT";
        displayname = "GD300 Android";
        picture = QPATHTOF(img\icons\icon_Android.paa);
        model = QPATHTOF(models\itemAndroid.p3d);
        class ItemInfo : CBA_MiscItem_ItemInfo {
            mass = 5;
        };
        author = LEGACY_AUTHOR;
    };

    class ItemMicroDAGR: ItemcTab {
        descriptionshort = "HNV-2930 Micro Defense Advanced GPS Receiver";
        descriptionuse = "<t color='#9cf953'>Use: </t>Show Android Based BFT";
        displayname = "MicroDAGR";
        picture = QPATHTOF(img\icons\icon_MicroDAGR.paa);
        model = QPATHTOF(models\itemMicroDAGR.p3d);
        class ItemInfo : CBA_MiscItem_ItemInfo {
            mass = 6;
        };
        author = LEGACY_AUTHOR;
    };
    
    class ItemcTabHCam: CBA_MiscItem {
        descriptionshort = "HD Helmet Mounted Camera";
        descriptionuse = "<t color='#9cf953'>Use: </t>Used to record and stream video";
        displayname = "Helmet Camera";
        picture = QPATHTOF(img\icons\icon_helmetCam.paa);
        scope = 2;
        class ItemInfo : CBA_MiscItem_ItemInfo {
            mass = 4;
        };
        author = LEGACY_AUTHOR;
    };
};
