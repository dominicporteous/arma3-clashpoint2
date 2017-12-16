if ( isDedicated ) exitWith {};

if ( isNil "ui_visible" ) then { ui_visible = true;  };

["game.round_start", {


}] call CBA_fnc_addEventHandler;

[] spawn {
	
	_separator = parseText "<br />==============================<br />";
	_newline = parseText "<br />";
	
	waitUntil{ !isNil "selectedZoneName" && !isNil "currentPoint" && !isNil "west_timer"; };

	while { true } do {

		if( ui_visible ) then {
		
			_spawn_protection = player getVariable [ "spawn_protected", false ];
		
			_scoreboard = [];
	
			_scoreboard pushBack parseText "<t size='3'>Clashpoint 2</t>";
			_scoreboard pushBack _separator;
			_scoreboard pushBack parseText format [ "<t size='1'>Current Clash: %1</t>", selectedZoneName ];
			_scoreboard pushBack _separator;
			_scoreboard pushBack _newline;
			_scoreboard pushBack _newline;
			
							
			{
			
				_side = _x;
				_sideHex = [ sidesHexData, _side ] call CBA_fnc_hashGet;
				_sideFlag = [ sidesFlagData, _side ] call CBA_fnc_hashGet;
				
				_size = "1.5";
				_decoration = "";
				
				if( _side == point_side ) then {
				
					_size = "1.75";
					_decoration = " underline='true'";
				
				};
				
				_scoreboard pushBack parseText format [ "<t align='left' size='%1'%2 color='%3'> <img image='%4' />  %5</t>", _size, _decoration, _sideHex, _sideFlag, toUpper _side ];
				_scoreboard pushBack parseText format [ "<t align='right' size='%1' >%2</t>", _size, missionNamespace getVariable format [ "%1_score", _side ] ];
				_scoreboard pushBack _newline;
				_scoreboard pushBack _newline;
				_scoreboard pushBack parseText format [ "<t size='%1' color='%2'>%3 remaining</t>", _size, _sideHex, [ missionNamespace getVariable format [ "%1_timer", _side ] ] call SecondsToTime ];
				_scoreboard pushBack _newline;
				_scoreboard pushBack _newline;
				_scoreboard pushBack _newline;
				
			} forEach [ "west", "east", "resistance" ];
			
			_scoreboard pushBack _separator;
			_scoreboard pushBack parseText "<t size='1'>v0.01</t>";
			_scoreboard pushBack _separator;
			_scoreboard pushBack _newline;
			
			if( _spawn_protection ) then {
			
				_scoreboard pushBack parseText "<t size='1.5' color='#fff600'>Spawn Protection Active</t>";
				
			} else {
				
				_scoreboard pushBack _newline;
			
			};
			
			_scoreboard pushBack _newline;
			_scoreboard pushBack _newline;
			
			_txt = composeText _scoreboard; 
		

			hintSilent _txt;
		
		}
	
	};

};