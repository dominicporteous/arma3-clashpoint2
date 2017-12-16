if ( !isServer ) exitWith { };

sidesCASData = [[
	[ west, west_cas ],
	[ east, east_cas ],
	[ resistance, resistance_cas ]
], "" ] call CBA_fnc_hashCreate;
publicVariable "sidesCASData";


GetRandomUnitFromSide = {

	_side = _this select 0;
	
	_units = ([] call CBA_fnc_players);
	_unitsSide = [ _units, { side _this != _side } ] call CBA_fnc_reject;

	_unit = ObjNull;
	if( count _unitsSide > 0 ) then {
		
		_unit = _unitsSide call BIS_fnc_selectRandom;
		
	};
	
	_unit;

};

call compile preprocessFileLineNumbers "scripts\server\support_manager\simpleMortar.sqf";

AssignArtySupport = {

	_unit = _this select 0;
	
	_center = createCenter sideLogic;
	_logicGroup = createGroup _center;
	
	_pos = [ [ _unit ] call GetBasePos, 10, (floor (random 360)) ] call BIS_fnc_relPos;
	
	_provider = _logicGroup createUnit [ "SupportProvider_Virtual_Artillery", _pos, [], 0, "FORM" ];
	_requester = _logicGroup createUnit [ "SupportRequester", _pos, [], 0, "FORM" ];
	
	{
	
		_provider setVariable [ _x select 0, _x select 1 ];
		
	}forEach [
		["BIS_SUPP_vehicles", [ "B_Mortar_01_F" ] ],
		["BIS_SUPP_vehicleinit", "_this setVehicleAmmo 0.15" ],
		["BIS_SUPP_filter", "SIDE" ]
		
	];
	
	{
	
		[ _requester, _x, 0 ] call BIS_fnc_limitSupport;
		
	}forEach [
		"Artillery",
		"CAS_Heli",
		"CAS_Bombing",
		"UAV",
		"Drop",
		"Transport"
	];
	[ _requester, "Artillery", 1 ] call BIS_fnc_limitSupport;
	
	[ _unit, _requester, _provider ] remoteExec [ "BIS_fnc_addSupportLink", _unit ];
	
	
};

AssignCasSupport = {

	_unit = _this select 0;
	_sideCAS = ( [ sidesCASData, side _unit ] call CBA_fnc_hashGet );
	
	_center = createCenter sideLogic;
	_logicGroup = createGroup _center;
	
	_base = [ _unit ] call GetBasePos;
	_pos = [ _base, 4500, 10000, 0, 2, 0, 1 ] call BIS_fnc_findSafePos;
	
	_provider = _logicGroup createUnit [ "SupportProvider_Virtual_CAS_Bombing", _pos, [], 0, "FORM" ];
	_requester = _logicGroup createUnit [ "SupportRequester", _pos, [], 0, "FORM" ];
	
	{
	
		_provider setVariable [ _x select 0, _x select 1 ];
		
	}forEach [
		[ "BIS_SUPP_vehicles", _sideCAS ],
		[ "BIS_SUPP_vehicleinit", "_this setVehicleAmmo 0.15" ],
		[ "BIS_SUPP_filter", "SIDE" ]
		
	];
	
	{
	
		[ _requester, _x, 0 ] call BIS_fnc_limitSupport;
		
	}forEach [
		"Artillery",
		"CAS_Heli",
		"CAS_Bombing",
		"UAV",
		"Drop",
		"Transport"
	];
	[ _requester, "CAS_Bombing", 1 ] call BIS_fnc_limitSupport;
	
	[ _unit, _requester, _provider ] remoteExec [ "BIS_fnc_addSupportLink", _unit ];
	
};


west_supportcalls=0; publicVariable "west_supportcalls";
east_supportcalls=0; publicVariable "east_supportcalls";
resistance_supportcalls=0; publicVariable "resistance_supportcalls";


["game.round_start", {

	west_supportcalls=0; publicVariable "west_supportcalls";
	east_supportcalls=0; publicVariable "east_supportcalls";
	resistance_supportcalls=0; publicVariable "resistance_supportcalls";

} ] call CBA_fnc_addEventHandler;

[ "game.point_control_changed", {

	if( param_support != 1 ) exitWith {};

	_newSide = _this select 0;
	if ( _newSide == "neutral" ) exitWith {};
	
	
	_timer = missionNamespace getVariable [ format [ "%1_timer", _newSide ] , "" ];
	_percent = ( _timer / param_round_duration ) * 100;

	_supportSide = selectRandom ([ "west", "east", "resistance" ] - [ _newSide ]);
	_calls = missionNamespace getVariable [ format [ "%1_supportcalls", _newSide ] , "" ];
	
	[ format [ "ps: %1, t: %2, c: %3, p: %4, ss: %5", _newSide, _timer, _calls, _percent, _supportSide ] ] call debugOut;
	
	if ( _percent > 75 ) exitWith {};
	
	if ( _percent < 25 && _calls > 3 ) exitWith {};
	if ( _percent < 50 && _calls > 2 ) exitWith {};
	
	_realSide = [ sidesRealData, toLower str _supportSide ] call CBA_fnc_hashGet;
	_unit = [ _realSide ] call GetRandomUnitFromSide;
	
	_calls = _calls + 1;
	missionNamespace setVariable [ format [ "%1_supportcalls", _newSide ] , _calls, true ];
	
	_support = selectRandom [ "mortar", AssignArtySupport, "mortar", AssignCASSupport, "mortar" ];
	
	if ( isNull _unit || str _support == "mortar" ) exitWith {
	
		[ currentPoint, _realSide ] spawn SimpleMortar;
	
	};
	
	[ _unit ] spawn _support;
	
} ] call CBA_fnc_addEventHandler;
