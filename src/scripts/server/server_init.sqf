if ( !isServer ) exitWith { };

server_ready=false; publicVariable "server_ready";

SHK_moveObjects=compile preprocessfile "scripts\server\move_objects\move_objects_init.sqf";
CreateAIGroup=compile preprocessfile "scripts\server\ai_manager\create_ai_group.sqf";
GroupManager=compile preprocessfile "scripts\server\ai_manager\group_manager.sqf";
WaypointManager=compile preprocessfile "scripts\server\ai_manager\waypoint_manager.sqf";


call compile preprocessfile "scripts\server\zone_detect\zone_detect_init.sqf";
call compile preprocessfile "scripts\server\point_manager\point_manager_init.sqf";
call compile preprocessfile "scripts\server\base_manager\base_manager_init.sqf";
call compile preprocessfile "scripts\server\zone_manager\zone_manager_init.sqf";
call compile preprocessfile "scripts\server\support_manager\support_manager_init.sqf";
call compile preprocessfile "scripts\server\ai_manager\ai_manager_init.sqf";
call compile preprocessfile "scripts\server\revive_manager\revive_manager_init.sqf";
call compile preprocessfile "scripts\server\spawn_protection\spawn_protection_init.sqf";
call compile preprocessfile "scripts\server\cleanup\cleanup_init.sqf";

[] spawn compile preprocessfile "scripts\server\game_manager\game_manager_init.sqf";

server_ready=true; publicVariable "server_ready";

sleep 10;

["game.start" ] spawn CBA_fnc_globalEvent;