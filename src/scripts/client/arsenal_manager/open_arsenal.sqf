if ( isDedicated ) exitWith {};

[ "arsenal.open" ] call CBA_fnc_localEvent;

[ "Open", true ] spawn BIS_fnc_arsenal;

sleep 3;

waitUntil { isnull ( uinamespace getvariable "RSCDisplayArsenal" ) };

[ "arsenal.closed" ] call CBA_fnc_localEvent;

sleep 3;

respawn_loadout = [ player, ["repetitive"] ] call F_getLoadout;

player commandChat "Your loadout will be saved across respawns!";