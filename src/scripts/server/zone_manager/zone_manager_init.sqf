if ( !isServer ) exitWith { };

currentPoint = [ 0, 0, 0 ]; publicVariable "currentPoint";

["zones.choose_zone", {
	
	_availableZones = [ zoneData ] call CBA_fnc_hashKeys;

	_selectedZoneName = selectRandom _availableZones;
	_selectedZoneData = [ zoneData, _selectedZoneName ] call CBA_fnc_hashGet;

	[ format[ "Selected Zone: %1 - Data: %2", _selectedZoneName, _selectedZoneData ] ] call debugOut;
	
	selectedZoneName = _selectedZoneName; publicVariable "selectedZoneName";
	selectedZoneData = _selectedZoneData; publicVariable "selectedZoneData";
	
	currentPoint = selectedZoneData select 2; publicVariable "currentPoint";

	["zones.new_zone"] spawn CBA_fnc_globalEvent;
	
}] call CBA_fnc_addEventHandler;



["zones.new_zone", {

	

}] call CBA_fnc_addEventHandler;