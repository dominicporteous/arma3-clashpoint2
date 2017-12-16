if ( !isServer ) exitWith { };

fnc_cleanup = compileFinal preprocessFileLineNumbers "scripts\server\cleanup\cleanup.sqf";

[] spawn {

	while {true} do {        

		[ ] call fnc_cleanup;

		sleep 60;
		
	};
};