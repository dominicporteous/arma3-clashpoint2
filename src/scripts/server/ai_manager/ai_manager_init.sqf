if ( !isServer ) exitWith { };

["game.enable_ai", {

	[ "Starting watch for ai.." ] call debugOut;
	
	[] spawn {
	
		while { winner == "" } do {
		
			{
			
				_side = _x;
				_grp = [ _side ] call GroupManager;
				
				if ( !isNull _grp ) then { 
					[ _grp, false ] spawn CreateAIGroup; 
				};
				
				sleep 7;
			
			} forEach [ west, east, resistance ];
		
			sleep 10;
		
		};
		
	};
	
}] call CBA_fnc_addEventHandler;