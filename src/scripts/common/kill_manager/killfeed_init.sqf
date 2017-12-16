HALs_ticker_killfeed = []; 


HALs_fnc_killFeed = {
	// Author: HallyG
	// Put this in your init.sqf

	// Known Issues
	//["UAVs show up when killed", "Vehicles kill players if they blow up", "UAV TURRETS", "VEHICLE CRASHES counts as roadkill themselves"];
	
	if (hasInterface) then {
		[] spawn {
			waitUntil {!isNull (findDisplay 46)};

			HALs_fnc_setupTicker = {
				waitUntil {!isNull (findDisplay 46)};
				if !(isNil "HALs_ticker_control") exitWith {};
				
				disableSerialization;
				missionNameSpace setVariable ["HALs_ticker_control", 2000];

				_ctrl = (findDisplay 46) ctrlCreate ["RscControlsGroupNoScrollbars", 1999];
				_ctrl ctrlSetPosition [
					(0.01 * safezoneW + safezoneX),
					safezoneY + 0.1 * safezoneH,
					(0.75 * safezoneW),
					(0.6 * safezoneH)
				];
				
				_ctrl ctrlCommit 0;

				HALs_updateDelay = 0.25;
				HALs_lastUpdate = diag_tickTime;

				addMissionEventHandler ["EachFrame", {
					if (diag_tickTime > HALs_lastUpdate) then {
						HALs_lastUpdate = diag_tickTime + HALs_updateDelay;

						if (count HALs_ticker_killfeed > 0) then {
							[ HALs_ticker_killfeed deleteAt 0 ] call HALs_fnc_updateTicker;
						};
					} 
				}];
			};
			
			HALs_fnc_updateTicker = {
				if (isNil "HALs_ticker_control") then {
					[] call HALs_fnc_setupTicker;
				};
				
				params [["_message", "", [""]]];
				
				disableSerialization;
				
				private _controlGroup = (findDisplay 46) displayCtrl 1999;
				private _controls = (allControls (findDisplay 46)) select {ctrlParentControlsGroup _x isEqualTo ((findDisplay 46) displayCtrl 1999)};
				private _control = missionNameSpace getVariable ["HALs_ticker_control", 2000];
				
				{ctrlDelete _x} forEach (_controls select {ctrlFade _x isEqualTo 1});
				_controls = (allControls (findDisplay 46)) select {ctrlParentControlsGroup _x isEqualTo ((findDisplay 46) displayCtrl 1999)};
				
				{	
					_pos = ctrlPosition _x;
					_pos set [1, (_pos select 1) - (safeZoneH * 0.02)];

					_x ctrlSetPosition _pos;
					_x ctrlCommit 0.25;
				} forEach _controls;
				
				
				private _ctrl = (findDisplay 46) ctrlCreate ["RscStructuredText", _control, _controlGroup];
				_ctrl ctrlSetPosition [0, (safeZoneH * 0.02) * 5, 0.6 * safezoneW, 0.1];
				_ctrl ctrlSetStructuredText parseText _message;
				_ctrl ctrlCommit 0;
				
				_ctrl ctrlSetFade 1;
				_ctrl ctrlCommit 10;
				
				missionNameSpace setVariable ["HALs_ticker_control", _control + 1];
			};
			
			[] call HALs_fnc_setupTicker;
		};
		
		HALs_fnc_parseKill = {
			params [["_killed", objNull], ["_killer", objNull], "_instigator", "_projectile"];
			
			private _info = switch (true) do {
				case (_killed isEqualTo _killer): {"SUICIDE"};
				case (isNull _killer): {"KILLED"};
				case (isNull _instigator): {"KILLED"};
				case ((toUpper getText (configfile >> "CfgAmmo" >> _projectile >> "simulation")) isEqualTo "SHOTGRENADE"): {"Grenade"};
				case ((toUpper getText (configfile >> "CfgAmmo" >> _projectile >> "simulation")) isEqualTo "SHOTSHELL"): {"EGLM HE"};
				case ((toUpper getText (configfile >> "CfgAmmo" >> _projectile >> "simulation")) isEqualTo "SHOTMINE"): {"Explosive"};
				
				case (!(isNull _killer) && (isNull _instigator)): {
					_instigator = [UAVControl vehicle _killer select 0, _killer] select (isNull (UAVControl vehicle _killer select 0));
					"Roadkill"
				};

				case (!isNull _instigator): {
					if !(_killer isEqualTo _instigator) then { 
						_return = "";
						if (isNil {vehicle _instigator currentWeaponTurret (assignedVehicleRole _instigator select 1)}) then {
							_return = getText (configfile >> "CfgVehicles" >> typeOf vehicle _instigator >> "displayName")
						} else {
							_return = getText (configfile >> "CfgWeapons" >> vehicle _instigator currentWeaponTurret (assignedVehicleRole _instigator select 1) >> "displayName");
						};
						_return
					} else {
						["NULL", getText (configfile >> "cfgWeapons" >> [currentWeapon _instigator] call BIS_fnc_baseWeapon >> "displayName")] select (isClass (configfile >> "cfgWeapons" >> currentWeapon _instigator));
					};
				};
				default {"NULL"};
			};
			
			_killerColour = ["#1a66b3", "#991a1a", "#1a991a", "#660080"] select (([west, east, resistance, civilian] find (side group _killer)) max 0);
			_killedColour = ["#1a66b3", "#991a1a", "#1a991a", "#660080"] select (([west, east, resistance, civilian] find (side group _killed)) max 0);
			_instigatorColour = ["#1a66b3", "#991a1a", "#1a991a", "#660080"] select (([west, east, resistance, civilian] find (side group _instigator)) max 0);
			_killed = [getText (configFile >> "cfgVehicles" >> typeOf _killed >> "displayName"), name _killed] select (isPlayer _killed);
			_killer = [getText (configFile >> "cfgVehicles" >> typeOf _killer >> "displayName"), name _killer] select (isPlayer _killer);
			_instigator = [getText (configFile >> "cfgVehicles" >> typeOf _instigator >> "displayName"), name _instigator] select (isPlayer _instigator);

			HALs_ticker_killfeed pushBack format [
				"<t align='left'>%1</t>",
				format ["<t color=%2 size = '1'>%1</t> <t size = '1'>[%3]</t> <t color=%5 size = '1'>%4</t>",
					[_instigator, _killer] select (_instigator isEqualTo ""),
					str ([_instigatorColour, _killerColour] select (_instigator isEqualTo "")),
					_info,
					_killed,
					str _killedColour
				]
			];
			
		};
	};

	if (isServer) then {

		addMissionEventHandler ["EntityKilled", {
			params ["_killed", "_killer", "_instigator"];

			if (!(_killed iskindOf "CAManBase")) exitWith {};
			
			private _projectile = _killed getVariable ["lastDamageSource", ""];
			private _killer = _killed getVariable ["lastDamageShooter", ""];
			
			//[ _killed, _killer, _instigator, _projectile ] call HALs_fnc_parseKill;
			
			[ _killed, _killer, _instigator, _projectile ] remoteExec ["HALs_fnc_parseKill", 0]; 
			
		}];
		
		[] spawn {
		
			sleep 10;
		
			while { true } do {
		
				{
				
					if( !(_x getVariable [ "HALs_HandleDamage", false ]) ) then {
				
						// Following is used to register grenade kills etc
						_x addEventHandler ["HandleDamage", {
							params ["_unit", "_selection", "_damage", "_shooter", "_projectile", "_hitPointIndex"];
									
							if (!isNull _shooter) then {
								_unit setVariable ["lastDamageSource", _projectile, true];
								_unit setVariable ["lastDamageShooter", _shooter, true];
								// Possibly use getShotParents here
							};
						}];
						
						_x setVariable [ "HALs_HandleDamage", true, true ]
					
					};
					
				} forEach allUnits;
				
				sleep 10;
			
			};
			
		};
		
	};
};

[] call HALs_fnc_killFeed;