if (!isServer) exitWith {};

params [ "_new_camp", "_create_camp_building" ];
private [ "_camp_building", "_camp_pos" ];

KPLIB_all_camps pushback _new_camp;
publicVariable "KPLIB_all_camps";

if ( _create_camp_building ) then {
    _camp_pos = [ (_new_camp select 0) + 15, (_new_camp select 1) + 2, 0 ];
    [_camp_pos, 20, true] call KPLIB_fnc_createClearance;
    _camp_building = CAMP_typename createVehicle _camp_pos;
    _camp_building setpos _camp_pos;
    _camp_building setVectorUp [0,0,1];
    [_camp_building] call KPLIB_fnc_addObjectInit;
    sleep 1;
};

[] spawn KPLIB_fnc_doSave;

sleep 3;
[_new_camp, 0] remoteExec ["remote_call_camp"];

stats_camps_built = stats_camps_built + 1;

CAMP_build_in_progress = false;
publicVariable "CAMP_build_in_progress";
