if ( isDedicated ) exitWith {};

if ( isNil "sector_timer" ) then { sector_timer = 0 };

params [ "_camp", "_status" ];
private [ "_campname" ];

_campname = [_camp] call KPLIB_fnc_getCampName;

if ( _status == 0 ) then {
    [ "lib_camp_built", [ _campname ] ] call BIS_fnc_showNotification;
};

if ( _status == 1 ) then {
    [ "lib_camp_attacked", [ _campname ] ] call BIS_fnc_showNotification;
    "opfor_capture_marker" setMarkerPosLocal _camp;
    sector_timer = GRLIB_vulnerability_timer;
};

if ( _status == 2 ) then {
    [ "lib_camp_lost", [ _campname ] ] call BIS_fnc_showNotification;
    "opfor_capture_marker" setMarkerPosLocal markers_reset;
    sector_timer = 0;
};

if ( _status == 3 ) then {
    [ "lib_camp_safe", [ _campname ] ] call BIS_fnc_showNotification;
    "opfor_capture_marker" setMarkerPosLocal markers_reset;
    sector_timer = 0;
};
