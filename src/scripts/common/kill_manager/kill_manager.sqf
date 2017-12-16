_unit = _this select 0;
_killer = _this select 1;
_side = side _killer;
_nameKiller = name _killer;

if ( !isDedicated ) then {

	if ( isPlayer _unit || isPlayer _killer || (!isMultiplayer && ((_unit in (units group player)) || (_killer in (units group player)) ))) then {
	
		[_unit, _killer] call killspam_add;
		
	};
	
};

sleep 1;