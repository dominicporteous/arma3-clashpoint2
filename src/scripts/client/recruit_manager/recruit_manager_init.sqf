if ( isDedicated ) exitWith {};

RecruitAction = {
	
	player addAction ["Recruit AI","scripts\common\bon_recruit_units\open_dialog.sqf","",1,true,true,"","([ player ] call DistanceFromBase) < 25"];
	
};