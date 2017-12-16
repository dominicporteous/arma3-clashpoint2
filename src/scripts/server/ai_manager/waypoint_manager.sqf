_grp = _this select 0;
_side = side leader _grp;
sleep 5;

while { { alive _x } count units _grp > 0 } do {

	[ _grp ] call CBA_fnc_clearWaypoints;

	_grp allowFleeing 0;
	{ 
	
		_x enableAI "ALL"; 
	
		_x doFollow leader _grp; 
		_x disableAI "FSM"; 
		_x disableAI "SUPPRESSION";
		//_x disableAI "COVER";
	
	} foreach units _grp;
	
	if( point_side != str _side ) then {
	
		[ _grp, currentPoint, 1 ] call CBA_fnc_taskAttack;
	
	} else {
	
		[ _grp, currentPoint, 10, 2, false, true ] call CBA_fnc_taskDefend;
	
	};
	
	_grp setSpeedMode "FULL";
	
	sleep 60;
	
};