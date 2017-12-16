if ( isDedicated ) exitWith {};


["game.point_control_changed", {

	_newSide = _this select 0;
	
	[ format[ "%1 now controls the objective.", _newSide ] ] call debugOut;
	_m = "";
	
	switch ( _newSide ) do {
		case "west": { _m = "Bluefor now controls the objective!" };
		case "east": { _m = "Opfor now controls the objective!" };
		case "resistance": { _m = "The resistance now controls the objective!" };
		case "neutral": { _m = "The objective is now uncontested!" };
		default { };
	};

	_tasktype = "TaskSucceeded";
	if ( playerside != [ sidesRealData, _newSide ] call CBA_fnc_hashGet ) then { _tasktype = "TaskFailed" };
	
	[ _tasktype,[ "", _m ] ] call BIS_fnc_showNotification;

}] call CBA_fnc_addEventHandler;

[] spawn {

	_task_point = nil;
	
	waitUntil{ !isNil "selectedZoneName" && !isNil "currentPoint" && !isNil "west_timer"; };
	
	while{ true } do {
	
		if( count (simpleTasks player) < 1 ) then {
		
			if( !isNil "_task_point" ) then {
			
				player removeSimpleTask _task_point;
			
			};
		
			_task_point = player createSimpleTask ["Clashpoint"];
			_task_point setVariable [ "currentPoint", currentPoint ];
			_task_point setSimpleTaskDestination currentPoint;
			_task_point setSimpleTaskDescription [ format [ "Capture the Objective at %1" , selectedZoneName ], "Clashpoint", "Clashpoint" ];
			_task_point setTaskState "Assigned";
			player setCurrentTask _task_point;
		
		}else{
		
			_task_point setSimpleTaskDestination currentPoint;
			
		};
		
		sleep 10;
	
	};

};
