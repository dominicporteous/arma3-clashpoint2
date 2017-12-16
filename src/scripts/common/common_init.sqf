call compile preprocessfile "scripts\common\data\data_init.sqf";
call compile preprocessfile "scripts\common\debug\debug_init.sqf";
call compile preprocessfile "scripts\common\params\fetch_params_init.sqf";
call compile preprocessfile "scripts\common\SHK_pos\shk_pos_init.sqf";
call compile preprocessfile "scripts\common\functions\functions_init.sqf";
call compile preprocessfile "scripts\common\kill_manager\killfeed_init.sqf";
call compile preprocessfile "scripts\common\bon_recruit_units\init.sqf";

KillManager=compile preprocessfile "scripts\common\kill_manager\kill_manager.sqf";