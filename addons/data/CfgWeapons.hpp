class CfgWeapons {
	class ItemCore;
 	class InventoryItem_Base_F;
	class ItemcTab: ItemCore {
		descriptionshort = "DK10 Rugged Tablet PC";
		descriptionuse = "<t color='#9cf953'>Use: </t>Show Commander's Tablet";
		displayname = "Rugged Tablet";
		picture = QPATHTOF(img\icon_dk10.paa);
		model = QPATHTOF(models\itemDK10.p3d);
		scope = 2;
		//TODO: Do not count it as GPS. We do not want it to enable vanilla GPS. Also we want it to show up under Misc Items
		simulation = "ItemGPS";
		class ItemInfo {	
			mass = 56;
		};
		author = LEGACY_AUTHOR;
	};
	
	class ItemAndroid: ItemcTab {
		descriptionshort = "GD300 Rugged Wearable Computer";
		descriptionuse = "<t color='#9cf953'>Use: </t>Show Android Based BFT";
		displayname = "GD300 Android";
		picture = QPATHTOF(img\icon_Android.paa);
		model = QPATHTOF(models\itemAndroid.p3d);
		class ItemInfo {
			mass = 5;
		};
		author = LEGACY_AUTHOR;
	};

	class ItemMicroDAGR: ItemcTab {
		descriptionshort = "HNV-2930 Micro Defense Advanced GPS Receiver";
		descriptionuse = "<t color='#9cf953'>Use: </t>Show Android Based BFT";
		displayname = "MicroDAGR";
		picture = QPATHTOF(img\icon_MicroDAGR.paa);
		model = QPATHTOF(models\itemMicroDAGR.p3d);
		class ItemInfo {
			mass = 6;
		};
		author = LEGACY_AUTHOR;
	};
	
	class ItemcTabHCam: ItemCore {
		descriptionshort = "HD Helmet Mounted Camera";
		descriptionuse = "<t color='#9cf953'>Use: </t>Used to record and stream video";
		displayname = "Helmet Camera";
		picture = QPATHTOF(img\cTab_helmetCam_ico.paa);
		scope = 2;
		//TODO: Does this have to be a mine detector?
		simulation = "ItemMineDetector";
		detectRange = -1;
		type = 0;
		class ItemInfo: InventoryItem_Base_F {
			mass = 4;
		};
		author = LEGACY_AUTHOR;
	};	
};
