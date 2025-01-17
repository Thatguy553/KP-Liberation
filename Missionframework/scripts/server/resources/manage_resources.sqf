scriptName "manage_resources";

waitUntil {!isNil "KPLIB_saveLoaded"};
waitUntil {!isNil "KPLIB_production"};
waitUntil {KPLIB_saveLoaded};

sectors_recalculating = false;
sectors_timer = false;

["Production management started", "PRODUCTION"] call KPLIB_fnc_log;
private _start = 0;
while {KPLIB_endgame == 0} do {

    recalculate_sectors = false;

    if (((count (allPlayers - entities "HeadlessClient_F")) > 0) && ((count KPLIB_production) > 0)) then {
        waitUntil {sleep 0.5; !sectors_recalculating};
        sectors_recalculating = true;

        private _time_update = false;
        if (sectors_timer) then {_time_update = true; sectors_timer = false;};

        _start = diag_tickTime;
        if (KPLIB_production_debug > 0) then {[format ["Production interval started: %1 - _time_update: %2", diag_tickTime, _time_update], "PRODUCTION"] call KPLIB_fnc_log;};

        private _tempProduction = [];
        {
            private _storageArray = [];
            private _supplyValue = 0;
            private _ammoValue = 0;
            private _fuelValue = 0;
            private _time = _x select 8;

            private _storage = nearestObjects [(markerPos (_x select 1)), [KPLIB_b_smallStorage], 100];
            _storage = _storage select {(_x getVariable ["KPLIB_storage_type",-1]) == 1};
            if ((count _storage) > 0) then {
                _storage = (_storage select 0);
                _storageArray = [(getPosATL _storage),(getDir _storage),(vectorUpVisual _storage)];

                if (_time_update) then {

                    if ((_time - 1) < 1) then {
                        _time = KPLIB_production_interval;

                        if (((count (attachedObjects _storage)) < 12) && !((_x select 7) == 3)) then {
                            private _crateType = KPLIB_b_crateSupply;
                            switch (_x select 7) do {
                                case 1: {_crateType = KPLIB_b_crateAmmo; stats_ammo_produced = stats_ammo_produced + 100;};
                                case 2: {_crateType = KPLIB_b_crateFuel; stats_fuel_produced = stats_fuel_produced + 100;};
                                default {_crateType = KPLIB_b_crateSupply; stats_supplies_produced = stats_supplies_produced + 100;};
                            };

                            private _crate = [_crateType, 100, getPosATL _storage] call KPLIB_fnc_createCrate;
                            [_crate, _storage] call KPLIB_fnc_crateToStorage;
                        };
                    } else {
                        _time = _time - 1;
                    };
                };

                {
                    switch ((typeOf _x)) do {
                        case KPLIB_b_crateSupply: {_supplyValue = _supplyValue + (_x getVariable ["KPLIB_crate_value",0]);};
                        case KPLIB_b_crateAmmo: {_ammoValue = _ammoValue + (_x getVariable ["KPLIB_crate_value",0]);};
                        case KPLIB_b_crateFuel: {_fuelValue = _fuelValue + (_x getVariable ["KPLIB_crate_value",0]);};
                        default {[format ["Invalid object (%1) at storage area", (typeOf _x)], "ERROR"] call KPLIB_fnc_log;};
                    };
                } forEach (attachedObjects _storage);
            };

            _tempProduction pushBack [
                (markerText (_x select 1)),
                (_x select 1),
                (_x select 2),
                _storageArray,
                (_x select 4),
                (_x select 5),
                (_x select 6),
                (_x select 7),
                _time,
                _supplyValue,
                _ammoValue,
                _fuelValue
            ];
            if (KPLIB_production_debug > 0) then {[format ["Production Update: %1", _tempProduction select _forEachIndex], "PRODUCTION"] call KPLIB_fnc_log;};
        } forEach KPLIB_production;

        _tempProduction sort true;

        KPLIB_production = +_tempProduction;
        sectors_recalculating = false;
    };
    if (KPLIB_production_debug > 0) then {[format ["Production interval finished - Time needed: %1 seconds", diag_tickTime - _start], "PRODUCTION"] call KPLIB_fnc_log;};
    waitUntil {sleep 1; recalculate_sectors};
};
