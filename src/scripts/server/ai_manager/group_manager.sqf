_groupnb = param_ai_groups;
_side = _this select 0;
_group_ret = grpNull;
_idx = 0;
_groups = [];

if (isNil "west_groupspool") then {

	west_groupspool = [];
	east_groupspool = [];
	resistance_groupspool = [];
	
	while { count west_groupspool < _groupnb } do { west_groupspool = west_groupspool + [createGroup WEST] };
	while { count east_groupspool < _groupnb } do { east_groupspool = east_groupspool + [createGroup EAST] };
	while { count resistance_groupspool < _groupnb } do { resistance_groupspool = resistance_groupspool + [createGroup RESISTANCE] };
	
};

switch ( _side ) do {
    case west: { 
		_groups = west_groupspool;
	};
    case east: { 
		_groups = east_groupspool;
	};
	case resistance: { 
		_groups = resistance_groupspool;
	};
    default { };
};

while { _idx < count _groups && isNull _group_ret } do {
	if ( isNull (_groups select _idx) ) then { 
		if ( _side == WEST ) then { west_groupspool set [_idx, createGroup WEST]; };
		if ( _side == EAST ) then { east_groupspool set [_idx, createGroup EAST]; };
		if ( _side == RESISTANCE ) then { resistance_groupspool set [_idx, createGroup RESISTANCE]; };
	};
	if ( count (units (_groups select _idx)) == 0 ) then { _group_ret = (_groups select _idx) } else { _idx = _idx + 1; } ;
};

_group_ret;