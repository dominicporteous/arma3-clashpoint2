/*
    Author: HallyG
    
    Parameter(s):
    0: [OBJECT] - Object who is 'looking'
    1: [OBJECT] - Object to look for
    2: [NUMBER] - Looker's FOV (OPTIONAL) DEFAULT (70)

    Returns:
    [BOOLEAN]
*/

params [
    ["_looker",objNull,[objNull]],
    ["_target",objNull,[objNull]],
    ["_FOV",70,[0]]
];

if ([ [ _looker ] call  CBA_fnc_getPos, getdir _looker, _FOV, [ _target ] call  CBA_fnc_getPos ] call BIS_fnc_inAngleSector) then {
    if (count (lineIntersectsSurfaces [(AGLtoASL (_looker modelToWorldVisual (_looker selectionPosition "pilot"))), getPosASL _target, _target, _looker, true, 1,"GEOM","NONE"]) > 0) exitWith { false };
    true
} else {
    false
};