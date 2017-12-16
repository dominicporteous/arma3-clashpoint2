////////////////////////////////////////////////////////////////////////
// SIMPLE MORTAR SCRIPT
// Based on script from https://forums.bistudio.com/forums/topic/145498-simple-mortar-script/
//
// [ [1,2] ] spawn SimpleMortar;
//
// OPTIONAL
// [Position, NumRounds, AmmoType, Spread, TravelTime, Delay, ReloadTime, Side ] execVM "mortar.sqf";
//
// Position    - Number of rounds to fire (number)              - [0,0,0]
// NumRounds    - Number of rounds to fire (number)             - 3
// AmmoType     - Config ammo name (string)                     - "Sh_120mm_HE"
// Spread       - Accuracy of each round (meters)               - 30
// TravelTime   - Delay between firing and splash (seconds)     - 10
// Delay        - Delay between each battery (seconds)          - 3
// ReloadTime   - Delay between fire missions (seconds)         - 10
// Side         - Side of artillary (east, west) etc            - west
//////////////////////////////////////////////////////////////////////


SimpleMortar = {

	private ["_position", "_side", "_roundType", "_radiusSpread", "_travelTime", "_delay", "_reloadtime", "_HQ", "_marker"];

	_pos = _this select 0;
	_position = [ _pos, 0, 20, 0, 0, 10 ] call BIS_fnc_findSafePos;
	
	
	_side = [_this,1,west,[sideUnknown]] call BIS_fnc_param;
	_rounds = [_this,2,5,[0]] call BIS_fnc_param;
	_roundType = [_this,3,"Sh_120mm_HE",[""]] call BIS_fnc_param;
	_radiusSpread = [_this,4,30,[0]] call BIS_fnc_param;
	_travelTime = [_this,5,10,[0]] call BIS_fnc_param;
	_delay =  [_this,6,1,[0]] call BIS_fnc_param;

	[[ _position, _travelTime ], {
	
		_position = _this select 0;
		_travelTime = _this select 1;
	
		_HQ = [side player,"HQ"];
	
		_HQ sideChat "Target location recieved, ordanance is inbound. Out.";
	
		_marker = createMarkerLocal [ format ["arty.call.%1", serverTime ], _position ];
		_marker setMarkerTypeLocal "hd_destroy";
		_marker setMarkerColorLocal "ColorBlack";
		_marker setMarkerTextLocal "HE Mortar Shells";
		
		_HQ sideChat format ["Rounds complete. ETA %1 second(s). Out", _travelTime];
	
	
		[ _marker, _travelTime ] spawn {
		
			_marker = _this select 0;
			_travelTime = _this select 1;
			
			_x = 0;
			while { _x < _travelTime } do {
			
				_marker setMarkerTextLocal format [ "HE Mortar Shells (ETA %1s)", (_travelTime - _x) ];
			
				_x = _x+1;
				sleep 1;
			
			};
			
			deleteMarkerLocal _marker;
		
		};
		
		sleep _travelTime - 1;
		_HQ sideChat "Splash. Out.";
	
	}] remoteExec ["BIS_fnc_spawn", _side];
	
	[[ _side ], {
	
		_side = _this select 0;
		
		if( _side == side player ) exitWith {};
	
		_HQ = [side player,"HQ"];
	
		_HQ sideChat "Be advised. Enemy ordanance is inbound. Out.";
	
	}] remoteExec ["BIS_fnc_spawn"];
	
	sleep _travelTime;
	

	for "_round" from 1 to _rounds do {
	
	   sleep 0.5;
	   
	   _mortarPos = [(_position select 0)-_radiusSpread*sin(random 360),(_position select 1)-_radiusSpread*cos(random 360),200];
	   _bomb = _roundType createVehicle _mortarPos;
	   
	   [_bomb, -90, 0] call BIS_fnc_setPitchBank;
	   
	   _bomb setVelocity [0,0,-100];
	   sleep _delay - 0.5;
	   
	};

};