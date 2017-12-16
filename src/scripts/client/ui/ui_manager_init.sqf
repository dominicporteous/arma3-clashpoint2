if ( isDedicated ) exitWith {};

isBlack=false;

	
["ui.forceBlack", {

	isBlack=false;
	
	sleep 1;
	
	[] spawn{
	
		_text = _this select 0;
		if( isNil "_text" ) then { _text=""; };
		
		_isStructuredText = _this select 0;
		if( isNil "_isStructuredText" ) then { _isStructuredText=false; };
	
		isBlack=true;
		while { isBlack } do {
		
			2 cutText [ _text, "PLAIN", 0, true, _isStructuredText ];
			cutText ["", "BLACK FADED", 0];
			
			sleep 5;
		
		};
	
	
	}

}] call CBA_fnc_addEventHandler;


["ui.fadeIn", {

	if( isBlack ) then {

		isBlack=false;
		
		_this spawn BIS_fnc_infoText;

		cutText ["", "BLACK IN", 0];
		
	};

}] call CBA_fnc_addEventHandler;

["ui.reset", {

	isBlack=false;
	cutText ["", "PLAIN", 0 ];
	2 cutText ["", "PLAIN", 0 ];

}] call CBA_fnc_addEventHandler;