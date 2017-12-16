if ( !isServer ) exitWith { };

firstround = true;

winner = ""; publicVariable "winner";
point_side = ""; publicVariable "point_side";
current_roundstate = 0; publicVariable "current_roundstate";


west_score = 0; publicVariable "west_score";
east_score = 0; publicVariable "east_score";
resistance_score = 0; publicVariable "resistance_score";

if ( isNil "managed_vehicles" ) then { managed_vehicles = []  };

_flag_reset = [ 0, 0, 0 ];
flag_reset = _flag_reset; publicVariable "flag_reset";

_point_trigger = createTrigger [ "EmptyDetector", [ 0, 0, 0 ]];
_point_trigger setTriggerArea [ zoneRadius, zoneRadius, 0, false ];
_point_trigger setTriggerActivation [ "ANY", "PRESENT", true ];
point_trigger = _point_trigger; publicVariable "point_trigger";


_place = 10;
{

	_side = _x;
	
	_flagName = format[ "PointFlag_%1", _side ];
	
	_flag = "Flag_White_F" createVehicle [ 100, _place, 0 ];
	_flag setFlagTexture ( [ sidesFlagData, _side] call CBA_fnc_hashGet ); 
	_flag setFlagSide ( [ sidesRealData, _side] call CBA_fnc_hashGet ); 
	
	missionNamespace setVariable [ _flagName, _flag ]; publicVariable _flagName;

	_place = _place + 100;
	
} forEach [ "west", "east", "resistance", "neutral" ];


["game.start", {

	[ "zones.choose_zone" ] spawn CBA_fnc_globalEvent;
	
	sleep 5;
	
	["game.round_start" ] spawn CBA_fnc_globalEvent;

}] call CBA_fnc_addEventHandler;

["game.end", {

	sleep 2;

	"SideScore" call BIS_fnc_endMissionServer;

}] call CBA_fnc_addEventHandler;


["zones.new_zone", {

	point_trigger setPos currentPoint;

}] call CBA_fnc_addEventHandler;


["game.round_start", {

	current_roundstate = 0; publicVariable "current_roundstate";
	winner = ""; publicVariable "winner";
	
	_hours = -1;
	if ( firstround ) then {
	
		_hours = 7;
		
	} else {
	
		_hours = floor (random 24);
		if(param_day_or_night == 1) then {
			_hours = (floor (random 12)) + 6;
		};
		if(param_day_or_night == 2) then {
			_hours = (floor (random 2));
		};
		
	};
	
	_minutes = floor (random 60);
	timeofdayvar = _hours;
	
	server_date = [date select 0, date select 1, date select 2, _hours, _minutes]; publicVariable "server_date";
	setDate server_date;
	

	if( firstround ) then {
	
		firstround = false;
		
	} else {
	
		_weather = (((random (100 + weather_offset)) - weather_offset) / 100.0);
		if ( _weather < 0 ) then { _weather = 0 };
		if ( param_weather == 1 ) then {
			_weather = 0.25;
		};
		server_weather = _weather; publicVariable "server_weather";

		if(isDedicated) then {
		
			0 setOvercast server_weather;
			_fog = 0;
			
			if(server_weather > 0.65) then {
				_fog = 0.2;
			};
			
			if(server_weather > 0.95) then {
				_fog = 0.7;
			};
			
			0 setFog _fog;
			
			forceWeatherChange;
			
		};
		
	};

	{
		if ( !isPlayer _x ) then {
			deletevehicle _x;
			_x removeAllEventHandlers "MPKilled";
		};
	} foreach allunits;

	current_roundstate = 1; publicVariable "current_roundstate";

	["spawns.force_respawn"] spawn CBA_fnc_globalEvent;

	sleep 5;
	
	west_timer = param_round_duration; publicVariable "west_timer";
	east_timer = param_round_duration; publicVariable "east_timer";
	resistance_timer = param_round_duration; publicVariable "resistance_timer";
	
	point_side = ""; publicVariable "point_side";
	
	[ "game.start_timer" ] spawn CBA_fnc_globalEvent;
	[ "game.watch_point" ] spawn CBA_fnc_globalEvent;
	[ "game.enable_ai" ] spawn CBA_fnc_globalEvent;
	
	
	["ui.fadeIn", ["Done!"]] spawn CBA_fnc_globalEvent;

	["spawns.force_respawn"] spawn CBA_fnc_globalEvent;
	
	[ "game.round_started" ] spawn CBA_fnc_globalEvent;
	
	[] spawn {
	
		sleep 10;

		["ui.reset"] spawn CBA_fnc_globalEvent;
	
	};

}] call CBA_fnc_addEventHandler;


["game.round_end", {
	
	["ui.forceBlack", []] spawn CBA_fnc_globalEvent;
	["Starting new round..."] spawn BIS_fnc_infoText;
	
	
	{
		if ( !isPlayer _x ) then {
			_x removeAllEventHandlers "MPKilled";
			deletevehicle _x;
		};
	} foreach allunits;
	
	
	{ deletevehicle _x; } foreach managed_vehicles;
	managed_vehicles = [];
	
	[ "zones.choose_zone" ] spawn CBA_fnc_globalEvent;
	
	sleep 15;
	
	[ "game.round_start" ] spawn CBA_fnc_globalEvent;

}] call CBA_fnc_addEventHandler;



["game.start_timer", {
	
	[ "Starting watch for timer.." ] call debugOut;
	
	[] spawn {
	
		while { west_timer > 0 && east_timer > 0 && resistance_timer > 0 } do {
		
			if ( point_side == "west" ) then { west_timer = west_timer - 1; publicVariable "west_timer"; };
			
			if ( point_side == "east" ) then { east_timer = east_timer - 1; publicVariable "east_timer"; };
			
			if ( point_side == "resistance" ) then { resistance_timer = resistance_timer - 1; publicVariable "resistance_timer"; };
			
			sleep 1;
		};
		
		if ( west_timer <= 0 ) then {
			
			[ "Winner is west" ] call debugOut;
		
			winner = "west"; publicVariable "winner";
			west_score = west_score + 1; publicVariable "west_score";
			
		};
		
		if ( east_timer <= 0 ) then {
		
			["Winner is east"] call debugOut;
		
			winner = "east"; publicVariable "winner";
			east_score = east_score + 1; publicVariable "east_score";
			
		};
		
		if ( resistance_timer <= 0 ) then {
		
			["Winner is resistance"] call debugOut;
			
			winner = "resistance"; publicVariable "winner";
			resistance_score = resistance_score + 1; publicVariable "resistance_score";
			
		};
		
		sleep 1;
		
		current_roundstate = 2; publicVariable "current_roundstate";
		
		[ "Round ended" ] call debugOut;
		[ format ["Winner: %1 - Scores: %2", winner, [ west_score, east_score, resistance_score, west_timer, east_timer, resistance_timer ] ] ] call debugOut;
		
		sleep 2;
		
		[ "game.round_end" ] spawn CBA_fnc_globalEvent;
		
	};

}] call CBA_fnc_addEventHandler;

["game.skip_zone", {

	current_roundstate=2; publicVariable "current_roundstate";

}] call CBA_fnc_addEventHandler;



["game.point_control_changed", {

	_newSide = _this select 0;
	
	[ format[ "%1 now controls the objective.", _newSide ] ] call debugOut;

}] call CBA_fnc_addEventHandler;
	