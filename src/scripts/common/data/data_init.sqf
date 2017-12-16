sidesColorData = [[
	[ "west", "colorBLUFOR" ],
	[ "east", "colorOPFOR" ],
	[ "resistance", "colorIndependent" ]
], "colorWhite" ] call CBA_fnc_hashCreate;
publicVariable "sidesColorData";

sidesHexData = [[
	[ "west", "#0057c9" ],
	[ "east", "#c90000" ],
	[ "resistance", "#00c91e" ]
], "#FFFFFF" ] call CBA_fnc_hashCreate;
publicVariable "sidesHexData";

sidesRealData = [[
	[ "west", west ],
	[ "east", east ],
	[ "resistance", resistance ]
], civilian ] call CBA_fnc_hashCreate;
publicVariable "sidesRealData";

sidesFlagData = [[
	[ "west", "\A3\Data_F\Flags\Flag_blue_CO.paa" ],
	[ "east", "\A3\Data_F\Flags\Flag_red_CO.paa" ],
	[ "resistance", "\A3\Data_F\Flags\Flag_green_CO.paa" ]
], "\A3\Data_F\Flags\Flag_white_CO.paa" ] call CBA_fnc_hashCreate;
publicVariable "sidesFlagData";