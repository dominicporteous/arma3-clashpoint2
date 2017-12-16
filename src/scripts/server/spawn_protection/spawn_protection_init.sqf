if ( !isServer ) exitWith { };

[] spawn {

	_protection_distance = 50;
	_protected_units = [];

	while { true } do {

		{
			_side = side _x;
			_respawn = "";
			if( _side == resistance ) then { _respawn = "respawn_guerilla"; }else{ _respawn = format[ "respawn_%1", _side ]; };
			
			if( !isNil "_respawn" ) then {
			
				if ( ( ([ _x ] call CBA_fnc_getPos) distance ([ _respawn ] call CBA_fnc_getPos) ) <= _protection_distance ) then {
				
					if ( !( _x in _protected_units ) ) then {
						
						_protected_units = _protected_units + [_x];
						
						_x setdamage 0;
						_x setfatigue 0;
						_x allowDamage false;
						
						if( !(isPlayer _x) ) then {
						
							_x setCaptive true;
						
						};
						
						_x disableAI "AUTOTARGET";
						_x disableAI "TARGET";
						
						_x setVariable [ "spawn_protected", true, true ];
						
					};
					
				} else {
				
					if ( _x in _protected_units ) then {
					
						_protected_units = _protected_units - [_x];
						
						_x allowDamage true;
						_x setCaptive false;
						
						_x enableAI "AUTOTARGET";
						_x enableAI "TARGET";
						
						_x setVariable [ "spawn_protected", false, true ];
						
					};
					
				};
				
			};
			
		} foreach allUnits;
		
		sleep 0.2;
		
	};
	
};