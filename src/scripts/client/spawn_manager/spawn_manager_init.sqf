if ( isDedicated ) exitWith {};

lastRespawn=serverTime;
SpawnManager = {

	_newUnit = _this select 0;
	_corpse = _this select 1;
	
	_fresh = _this select 2;
	if( isNil "_fresh" ) then { _fresh=false; };
	
	
	player commandChat "You've respawned!";
	_placeholder = vehicle player;
	_side = side player;
	_grp = creategroup _side;
	
	_unit = _grp createUnit [ missionNamespace getVariable (format [ "%1_starter", _side ]), getPos _placeholder, [], 0, "NONE" ];
	_unit setRank "COLONEL";

	selectPlayer _unit;
	
	sleep 0.1;
	deleteVehicle _placeholder;
	

	if( !_fresh ) then {
	
		if( !isPlayer ( leader group player ) ) then {
		
			group player selectLeader player;
			
		};
		
	}else{
	
		[ player ] joinSilent grpNull;
	
	};

	if ( isNil "respawn_loadout" || count respawn_loadout < 1 ) then {
	
		removeAllWeapons player;
		player linkItem "NVGoggles";
		
	} else {
	
		[ player, respawn_loadout ] call F_setLoadout;
		
	};

	player setCustomAimCoef 0.35;
	player setUnitRecoilCoefficient 0.6;

	if (!isNil "param_stamina") then {
		if ( param_stamina == 0 ) then {
			player enableStamina false;
		} else {
			player enableStamina true;
		};
	};
	
	player call btc_qr_fnc_unit_init;

	[] spawn SideMarkers;
	[] call Earplugs;
	[] call ArsenalAction;
	[] call RecruitAction;
	
	[] call FPSMON_fnc_monitor; 
	[ 5 ] call FPSMON_fnc_monitor;
	
	1 fadeSound 1;
	
	player setVariable [ "player.ready", true ];
	
};


["spawns.force_respawn", {

	[] spawn {
	
		if( !alive player || (serverTime - lastRespawn) <= 15 ) exitWith {};
		
		lastRespawn=serverTime;
		
	
		["ui.forceBlack", []] spawn CBA_fnc_localEvent;
		["Re deploying..."] spawn BIS_fnc_infoText;
				
		_basepos = [ 0, 0, 0 ];
		_side = side player;
		
		_respawnName = "";
		if( _side == resistance ) then { _respawnName = "respawn_guerilla"; }else{ _respawnName = format[ "respawn_%1", _side ]; };
		
		while { (_basepos) select 0 == 0 } do {
		
			_basepos = getMarkerPos _respawnName;
		
		};
		
		player setpos [((_basepos  select 0) + 4) - (random 8),((_basepos select 1) + 4) - (random 8),0];
		
		sleep 2;
		
		player setDamage 0;
		player setFatigue 0;
		
		["ui.reset"] spawn CBA_fnc_localEvent;
	
		
		[ player, ObjNull, true ] call SpawnManager;
		
	};

}] call CBA_fnc_addEventHandler;