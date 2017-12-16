if ( isDedicated ) exitWith {};

_dist_base = 25;
		
		
ArsenalAction = {

	player addAction ["Open Arsenal","scripts\client\arsenal_manager\open_arsenal.sqf","",1,true,true,"","([ player ] call DistanceFromBase) < 25"];

};
	
if ( isNil "respawn_loadout" ) then { respawn_loadout = []; };
if ( isNil "arsenal_preload" ) then { ["Preload"] call BIS_fnc_arsenal; arsenal_preload = true; };