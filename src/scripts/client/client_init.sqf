if ( isDedicated ) exitWith {};

SecondsToTime=compile preprocessfile "scripts\client\common\seconds_to_time.sqf";
SideMarkers=compile preprocessfile "scripts\client\side_markers\side_markers_init.sqf";
Earplugs=compileFinal preprocessFileLineNumbers "scripts\client\spawn_manager\simpleEP.sqf";
SideMarkers=compile preprocessfile "scripts\client\side_markers\side_markers_init.sqf";

call compileFinal preprocessFileLineNumbers "scripts\client\fps\fps_monitor_init.sqf";
call compile preprocessfile "scripts\client\spawn_manager\spawn_manager_init.sqf";
call compile preprocessfile "scripts\client\ui\ui_manager_init.sqf";
call compile preprocessfile "scripts\client\ui\task_updates_init.sqf";
call compile preprocessfile "scripts\client\ui\scoreboard_init.sqf";
call compile preprocessfile "scripts\client\admin_commands\admin_commands_init.sqf";
call compile preprocessfile "scripts\client\arsenal_manager\arsenal_manager_init.sqf";
call compile preprocessfile "scripts\client\recruit_manager\recruit_manager_init.sqf";


[] spawn {

	["ui.forceBlack"] spawn CBA_fnc_localEvent;
	sleep 2;
	
	["Welcome to clashpoint."] spawn BIS_fnc_infoText;
	
	sleep 2;
	
	_init=[ 1 ];
	if( !server_ready || !zonesReady ) then {
		_init = _init + [ 2 ];
	};
	
	{ 
	
		["Initialising..."] spawn BIS_fnc_infoText;
		sleep 12.5;
	
	} forEach _init;
		
	waitUntil{ zonesReady };
	
	["Initialising done."] spawn BIS_fnc_infoText;
	
	sleep 10;
		

	["spawns.force_respawn"] spawn CBA_fnc_localEvent;
	sleep 10;
	["ui.reset"] spawn CBA_fnc_localEvent;
	
};