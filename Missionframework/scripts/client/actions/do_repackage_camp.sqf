dorepackage = 0;

createDialog "liberation_repackage_fob";
waitUntil {sleep 0.1; dialog};
waitUntil {sleep 0.1; !dialog || !alive player || dorepackage != 0};

if (dorepackage > 0) then {
    closeDialog 0;
    waitUntil {sleep 0.1; !dialog};

    private _camp = [] call KPLIB_fnc_getNearestCamp;

    if !(_camp isEqualTo []) then {
        KPLIB_all_camps = KPLIB_all_camps - [_camp];
        KP_liberation_clearances deleteAt (KP_liberation_clearances findIf {(_x select 0) isEqualTo _camp});
        publicVariable "KPLIB_all_camps";
        publicVariable "KP_liberation_clearances";
    };

    {deleteVehicle _x} forEach (((getPos player) nearobjects [CAMP_typename, 250]) select {getObjectType _x >= 8});

    sleep 0.5;

    private _spawnpos = zeropos;
    while {_spawnpos distance2d zeropos < 1000} do {
        _spawnpos = (getPos player) findEmptyPosition [10, 250, 'B_Heli_Transport_01_F'];
        if (_spawnpos isEqualTo []) then {_spawnpos = zeropos;};
    };

    if (dorepackage == 1) then {
        private _campbox = CAMP_box_typename createVehicle _spawnpos;
        [_campbox] call KPLIB_fnc_addObjectInit;
    };

    if (dorepackage == 2) then {
        private _campTruck = CAMP_truck_typename createVehicle _spawnpos;
        [_campTruck] call KPLIB_fnc_addObjectInit;
    };
    hint localize "STR_CAMP_REPACKAGE_HINT";
};
