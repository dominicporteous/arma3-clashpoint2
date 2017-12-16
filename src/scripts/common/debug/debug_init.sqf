if (isNil "debug") then { debug=false; };

debugOut = {

	if( !debug ) exitWith { };

	_message =  [ _this, " " ] call CBA_fnc_join;

	systemChat _message;
	diag_log _message;

};

debugEnabled = {

	(debug);

}