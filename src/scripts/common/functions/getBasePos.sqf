_side = nil;
if( (_this select 0) in [ east, west, resistance ] ) then {
	_side = (_this select 0);	
} else {

	_side = side (_this select 0);

};

_respawnName = "";
if( _side == resistance ) then { _respawnName = "respawn_guerilla"; }else{ _respawnName = format[ "respawn_%1", _side ]; };

_basepos = getMarkerPos _respawnName;

_basepos;