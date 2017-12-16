_markers = [];

while { alive player } do {

	{
	
		deleteMarkerLocal _x;
	
	} forEach _markers;


	{
	
		_unit = _x;
		_side = side _unit;
		
		if( side player == _side || ( [] call debugEnabled ) && !(captive _unit) ) then {
		
			_sm = createMarkerlocal [ format[ "sm_%1", str _unit ], position _unit ];
			_sm setMarkerShapeLocal "ICON";
			_sm setMarkerTypeLocal "mil_dot";
			_sm setMarkerColorLocal ( [ sidesColorData, toLower str _side ] call CBA_fnc_hashGet );
			
			
			if( isPlayer _unit ) then {
			
				_sm setMarkerTextLocal format["Player: %1", name _unit ]
			
			} else {
			
				if( leader group _x == _x ) then {
				
					_sm setMarkerTextLocal format["Group: %1", str group _x ]
				
				};
			
			};
			
			_markers pushBack _sm;
			
		};
	
	} forEach allUnits;
	
	sleep 1;
	
};

{
	
	deleteMarkerLocal _x;

} forEach _markers;