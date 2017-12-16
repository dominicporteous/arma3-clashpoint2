params [ "_grp", "_reinforcements" ];

private _side = side _grp;
private _basepos = [];
private _pos = [];
private _squad = [];
private _units_to_spawn = 5;

if ( point_side == str _side ) then {
	_units_to_spawn = 3;
};

switch ( _side ) do {
    case west: { 
		_basepos = getpos westFlag;
		_squad = west_pool;
	};
    case east: { 
		_basepos = getpos eastFlag;
		_squad = east_pool;
	};
	case resistance: { 
		_basepos = getpos resistanceFlag;
		_squad = resistance_pool;
	};
    default { };
};

_spawnangle = random 360;
_spawndistance = 18 + (random 6);

_spawn = [(_basepos select 0) + (_spawndistance * (cos _spawnangle)), (_basepos select 1) + (_spawndistance * (sin _spawnangle))];
_pos = [];
while{ count _pos == 0 } do {

	_pos = _spawn findEmptyPosition [ 5, 150, "B_Heli_Light_01_F" ];

};
[ format[ "Spawning new AI %1 man group for %2 at %3", _units_to_spawn, _side, _pos ] ] call debugOut;

if ( _units_to_spawn > 0 ) then {

	_i = 0;
	while { _i < _units_to_spawn } do {
	
		_rank = "private";
		if ( _i == 0 ) then { _rank = "lieutenant"; };
		if ( _i == 1 ) then { _rank = "sergeant"; };
		
		(_squad select _i) createUnit [_pos, _grp,"", 0.5, _rank];
		_i = _i + 1;
		
	};

	{ 
	
		_x addMPEventHandler ["MPKilled", { [ _this ] spawn KillManager }];
		_x doFollow leader _grp;
		
	} foreach (units _grp);

	[ _grp ] call WaypointManager;

};