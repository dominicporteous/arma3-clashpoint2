if ( isDedicated ) exitWith {};

_mod = _this select 0;
_playerName = name player;


_hasMod = isClass (configFile >> "CfgPatches" >> _mod);

if( !_hasMod ) then {
	
	format [ "#kick %1", _playerName ] remoteExec ["serverCommand", 2]; 
	
};