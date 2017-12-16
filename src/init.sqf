enableSaving [ false, false ];

resistance setFriend [west, 0];
west setFriend [resistance, 0];

resistance setFriend [east, 0];
east setFriend [resistance, 0];

weather_offset = 75;

// Get a debug messages
debug = false;

call compileFinal preprocessFileLineNumbers "scripts\common\common_init.sqf";
call compile preprocessFileLineNumbers "=BTC=_q_revive\config.sqf";

switch ( param_units ) do {
    case 1: { call compileFinal preprocessFileLineNumbers "classnames\classnames_vanilla_2.sqf"; };
	case 2: { call compileFinal preprocessFileLineNumbers "classnames\classnames_rhs.sqf"; };
	case 3: { call compileFinal preprocessFileLineNumbers "classnames\classnames_unsung.sqf"; };
	case 4: { call compileFinal preprocessFileLineNumbers "classnames\classnames_ifa3.sqf"; };
    default { call compileFinal preprocessFileLineNumbers "classnames\classnames_vanilla.sqf"; };
};

// Client init
if ( !isDedicated ) then {

	["cba_main"] call RequireMod;

	call compileFinal preprocessFileLineNumbers "scripts\client\client_init.sqf";

};


// Server init
if ( isServer ) then{

	call compileFinal preprocessFileLineNumbers "scripts\server\server_init.sqf";
	
};
