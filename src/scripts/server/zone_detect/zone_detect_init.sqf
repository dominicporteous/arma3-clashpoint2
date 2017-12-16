if ( !isServer ) exitWith { };

zonesReady = false; publicVariable "zonesReady";

_zoneData = [ [],[] ] call CBA_fnc_hashCreate;

_mapLocations = nearestLocations [[worldSize / 2, worldsize / 2, 0], ["NameCity","NameCityCapital","NameVillage","NameLocal"], 25000];
_aoLocations = [];
_aoRadius = 300;
_zoneRaduis = 100;

_i = 0;
{

	_i = _i + 1;
	_locName = text _x;
	_locPos = getPos _x;
	
	_e = [ _aoLocations, { (_this select 0) == _locName }] call CBA_fnc_select;
	if( count _e == 0 ) then {
	
		_b = nearestObjects [ _locPos, ["House", "Building"], 250 ];
		[ format [ "Found loc %1, %2 buildings", _locName, count _b ] ] call debugOut;
		
		_buildings = [ _b, { count ([ _this ] call BIS_fnc_buildingPositions) < 5 } ] call CBA_fnc_reject; 
		
		if( count _buildings > 0 ) then { 
		
			_position = getPos (selectRandom _buildings);

			_markerName = format [ "locationmarker.%1", _i ];
			_markerText = format[ "Name: %1, Type: %2, Imp: %3", _locName, type _x, importance _x ];
			_markerPos = _position;
			
			if( count _markerPos > 0 ) then {
			
				_aoLocations pushBack [ _locName, _markerPos, importance _x ];
				
				[ format [ "Found loc %1 at %2", _locName, _markerPos ] ] call debugOut;
				
			};
			
		};
	
	}
	
} forEach _mapLocations;


[ _aoLocations, true] call CBA_fnc_shuffle;
_aoLocations = ( _aoLocations select [0, 50] );

{

	_name = _x select 0;
	_position = _x select 1;
	_value = _x select 2;
	
	if( call debugEnabled ) then {
		
		_marker = [ format [ "locationmarker.%1", _name ], _position, "ICON", [ 0.5, 0.5 ], "PERSIST" ] call CBA_fnc_createMarker;
		
		_marker setMarkerText _name;  
		_marker setMarkerType "hd_dot"; 
	
	};
	
	_sides = [ "west", "east", "resistance" ];
	_basesPos = [];
	_maxTries = 100;
	_tries = 0;
	
	while { ( count _basesPos < 3 ) && ( _tries <= _maxTries ) } do {
	
		_basesPos = [];
		_tries = _tries + 1;
		
		_randomStart = random [ 0, 180, 360 ];
		_i = 0;
		{
			_i = _i + 1;
			_side = _x;
			
			_phi = _randomStart + ( _i * 120 );
			_x = cos(_phi);
			_y = sin(_phi);

			_posVector = [_x * (_aoRadius), _y * (_aoRadius), 0];
			_radiusPos = _position vectorAdd _posVector;
			
			//_spawn = [ _radiusPos, 0, 20, 0, 0, 10 ] call BIS_fnc_findSafePos;
			_spawn = [ _radiusPos, 10 ] call SHK_pos;
			
			_pos = [];
			_pTries = 0;
			while{ count _pos == 0  && ( _pTries <= _maxTries ) } do {

				//_pos = _spawn findEmptyPosition [ 1, 10, "B_Heli_Light_01_F" ];
				_pos = [ _spawn, 10 ] call SHK_pos;
				_pTries = _pTries + 1;

			};
			
			if( count _pos > 0 && (_position distance _pos < 500) && (_position distance _pos > 200) && (count (nearestTerrainObjects [_pos, ["ROCK","ROCKS","QUAY"], 50]) == 0) )  then {
	
				_surface = toLower( surfaceType _pos );
			
				if( (_surface find "beach" < 0) && (_surface find "water" < 0) && (_surface find "rock" < 0) && count ( nearestObjects [ _pos, ["A3_Structures_F_Naval_Piers","A3_Structures_F_EPC_Civ_Accessories"], 50] ) == 0 ) then {
			
					_basesPos pushBack [ _name, _side, _pos ];
					
					[ format [ "Found base, took %1 tries of %2.", _tries, _maxTries ] ] call debugOut;
					
				};
				
			};
			
		} forEach  _sides;
	
	};
	
	if( count _basesPos == 3 ) then {
	
		_aoData = [];
		_aoData pushBack _name;
		_aoData pushBack _aoRadius;
		_aoData pushBack _position;
		
		
		_baseData = [];
		{
		
			_name = _x select 0;
			_side = _x select 1;
			_pos = _x select 2;
			
			_sideColor = [ sidesColorData, _side ] call CBA_fnc_hashGet;
			_sideReal = [ sidesRealData, _side ] call CBA_fnc_hashGet;
			
			if( call debugEnabled ) then {
				
				_base = [ format[ "%1.base.%2", _name, _side ], _pos, "ICON", [ 0.5, 0.5 ], "COLOR:", _sideColor, "PERSIST" ] call CBA_fnc_createMarker;
						
				_base setMarkerType "hd_dot"; 
				_base setMarkerText format[ "%1 %2 Base", _name, toUpper(_side) ];
				
			};
			_baseData pushBack [ _side, _pos ];
			
			[ format [ "Found %1 base for %2 at %3", _side, _name, _pos ] ] call debugOut;
		
		} forEach _basesPos;
		
		_aoData pushBack _baseData;
		
		[ _zoneData, _name, _aoData ] call CBA_fnc_hashSet;
	
	} else {
	
		_aoLocations = _aoLocations - [ _x ]
	
	}

} forEach _aoLocations;

{

	_name = _x select 0;
	_position = _x select 1;
	_value = _x select 2;

	if( call debugEnabled ) then {
	
	_marker = [ _name, _position, "ELLIPSE", [ _aoRadius, _aoRadius ], "COLOR:", "ColorOpfor", "PERSIST" ] call CBA_fnc_createMarker;

	};
	
} forEach _aoLocations;

zoneRadius = _zoneRaduis; publicVariable "zoneRadius";
availableZones = [ _zoneData ] call CBA_fnc_hashKeys; publicVariable "availableZones";
zoneData = _zoneData; publicVariable "zoneData";
zonesReady = true; publicVariable "zonesReady";

[ format [ "Zone init done." ] ] call debugOut;
