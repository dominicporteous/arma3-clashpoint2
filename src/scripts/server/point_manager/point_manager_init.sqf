if ( !isServer ) exitWith { };

["game.watch_point", {

	[ "Starting watch for sides.." ] call debugOut;
	point_side="start";
	thislist=nil;

	[] spawn {
		
		while { winner == "" } do {
		
			thislist = list point_trigger;
			
			if( winner == "" && !isNil "thislist" ) then {
				
				if ( WEST countside thislist == 0 && EAST countside thislist == 0 && RESISTANCE countside thislist == 0 && point_side != "" ) then {
				
					point_side = "";
					publicVariable "point_side";
					
					PointFlag_neutral setpos currentPoint;
					
					PointFlag_west setpos flag_reset;
					PointFlag_east setpos flag_reset;
					PointFlag_resistance setpos flag_reset;
					
					[ "game.point_control_changed", [ "neutral" ] ] spawn CBA_fnc_globalEvent;
					
				};

				if ( ( WEST countside thislist >  ( RESISTANCE countside thislist ) ) && ( WEST countside thislist > ( EAST countside thislist ) ) && point_side != "west" ) then {
				
					point_side = "west";
					publicVariable "point_side";
					
					PointFlag_west setpos currentPoint;
					
					PointFlag_east setpos flag_reset;
					PointFlag_resistance setpos flag_reset;
					PointFlag_neutral setpos flag_reset;
					
					[ "game.point_control_changed", [ "west" ] ] spawn CBA_fnc_globalEvent;
					
				};

				if ( ( EAST countside thislist > ( WEST countside thislist ) ) && ( EAST countside thislist > ( RESISTANCE countside thislist ) ) && point_side != "east" ) then {
				
					point_side = "east";
					publicVariable "point_side";
					
					PointFlag_east setpos currentPoint;
					
					PointFlag_west setpos flag_reset;
					PointFlag_resistance setpos flag_reset;
					PointFlag_neutral setpos flag_reset;
					
					[ "game.point_control_changed", [ "east" ] ] spawn CBA_fnc_globalEvent;
					
				};
				
				if ( ( RESISTANCE countside thislist > ( WEST countside thislist ) ) && ( RESISTANCE countside thislist >  ( EAST countside thislist ) ) && point_side != "resistance" ) then {
				
					point_side = "resistance";
					publicVariable "point_side";
					
					PointFlag_resistance setpos currentPoint;
					
					PointFlag_west setpos flag_reset;
					PointFlag_east setpos flag_reset;
					PointFlag_neutral setpos flag_reset;
					
					[ "game.point_control_changed", [ "resistance" ] ] spawn CBA_fnc_globalEvent;
					
				};

			};
			sleep 1;
		};

	};
		
}] call CBA_fnc_addEventHandler;