if ( !isServer ) exitWith { };


_place = 10;
{
	
	_side = _x;
	
	_campName = format[ "%1Camp", _side ];
	_flagName = format[ "%1Flag", _side ];
	_respawnName =  [format[ "respawn_%1", _side ], "resistance", "guerilla"] call ReplaceString;
	
	_camp = [ "camp", [ 0, _place, 0 ], [ 0, 0, 0], 10, true ] call LARs_fnc_spawnComp;
	
	_flag = (nearestObject [ [ 0, _place, 0 ], "Flag_White_F" ]);
	_flag setFlagTexture ( [ sidesFlagData, _side ] call CBA_fnc_hashGet ); 
	_flag setFlagSide ( [ sidesRealData, _side ] call CBA_fnc_hashGet ); 
	
	_respawn = [ _respawnName, getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition"), "ICON", [ 0.5, 0.5 ], "PERSIST" ] call CBA_fnc_createMarker;
	
	missionNamespace setVariable [ _campName, _camp ]; publicVariable _campName;
	missionNamespace setVariable [ _flagName, _flag ]; publicVariable _flagName;
	missionNamespace setVariable [ _respawnName, _respawn ]; publicVariable _respawnName;

	_place = _place + 100;
	
} forEach [ "west", "east", "resistance" ];


["zones.new_zone", {

	_newZoneName = selectedZoneData select 0;
	_newZoneRadius = selectedZoneData select 1;
	_newZonePosition = selectedZoneData select 2;
	_newZoneBases = selectedZoneData select 3;
	
	{
	
		_side = _x select 0;
		_sideFlag = missionNamespace getVariable format[ "%1Flag", _side ];
		_sideSpawn = missionNamespace getVariable format[ "respawn_%1", [ _side, "resistance", "guerilla"] call ReplaceString ];
		
		_basePos = (_x select 1) findEmptyPosition [ 1, 25, "B_Heli_Light_01_F" ];
		
		_sideSpawn setMarkerPos _basePos;
		
		[ getPos _sideFlag, _basePos, 25 ] call SHK_moveObjects;
		
		{
		
			_x setVectorUp (surfaceNormal position _x);
		
		} forEach ([ missionNamespace getVariable format[ "%1Camp", _side ] ] call LARs_fnc_getCompObjects);
	
	} forEach _newZoneBases;
	
	[ "bases.ready" ] call CBA_fnc_globalEvent;

}] call CBA_fnc_addEventHandler;