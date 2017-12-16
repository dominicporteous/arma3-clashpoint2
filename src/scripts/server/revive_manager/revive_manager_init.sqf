if ( !isServer ) exitWith { };

[] spawn {

	while { true } do {

		{
		
			_unit = _x;
			_side = side _unit;
			
			if( _unit != _x && _unit getVariable [ "btc_qr_initialized", false ] ) then {
			
				//{ _unit call btc_qr_fnc_unit_init; } remoteExec ["bis_fnc_call", 0]; 
				_unit call btc_qr_fnc_unit_init;
				_unit setVariable [ "btc_qr_initialized", true, true ];
				
			};
		
		} forEach allUnits;
		
		sleep 2.5;

	};

};