if ( isDedicated ) exitWith {};

["skipTime", {

    parseNumber (_this select 0) remoteExec ["skipTime"];
	
}, "adminLogged"] call CBA_fnc_registerChatCommand;

["skipZone", {

    ["game.skip_zone"] spawn CBA_fnc_globalEvent;
	
}, "adminLogged"] call CBA_fnc_registerChatCommand;


["endGame", {

    ["game.end"] spawn CBA_fnc_globalEvent;
	
}, "adminLogged"] call CBA_fnc_registerChatCommand;



["toggleDebug", {

    if( debug ) then {
	
		debug=false;
		systemChat "Debug now disabled!";
	
	}else{
	
		debug=true;
		systemChat "Debug now enabled!";
	
	};
	
}, "adminLogged"] call CBA_fnc_registerChatCommand;