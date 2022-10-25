#define CATTAB "CatTAB"

class CfgNotifications {
	class GVAR(UavNotAval) {
		title = CATTAB;
		iconPicture = QPATHTOEF(data,img\15th_rugged_tab_ico.paa);
		iconText = "";
		color[] = {1,1,1,1};
		description = "%1";
		duration = 5;
		priority = 7;
		difficulty[] = {};
	};
	
	class GVAR(newMsg) {
		title = CATTAB;
		iconPicture = QPATHTOEF(data,img\icoUnopenedmail.paa);
		iconText = "";
		color[] = {1,1,1,1};
		description = "%1";
		duration = 4;
		priority = 7;
		difficulty[] = {};
	};

	class GVAR(MsgSent) {
		title = CATTAB;
		iconPicture = QPATHTOEF(data,img\icoUnopenedmail.paa);
		iconText = "";
		color[] = {1,1,1,1};
		description = "Your message has been sent.";
		duration = 4;
		priority = 7;
		difficulty[] = {};
	};	
};
