private [ "_minfobdist", "_minsectordist", "_distfob", "_clearedtobuildfob", "_distsector", "_clearedtobuildsector", "_idx" ];

if ( count GRLIB_all_fobs >= GRLIB_maximum_fobs ) exitWith {
    hint format [ localize "STR_HINT_FOBS_EXCEEDED", GRLIB_maximum_fobs ];
};

_minfobdist = 1000;
if (KP_liberation_MinSectorBuildDistance == 1) then {
    _minsectordist = GRLIB_capture_size + KP_liberation_FobRange;
} else {
    _minsectordist = KP_liberation_MinSectorBuildDistance;
};
_distfob = 1;
_clearedtobuildfob = true;
_distsector = 1;
_clearedtobuildsector = true;

FOB_build_in_progress = true;
publicVariable "FOB_build_in_progress";

// Check if building too close to another FOB
_idx = 0;
while { (_idx < (count GRLIB_all_fobs)) && _clearedtobuildfob } do {
    if ( player distance (GRLIB_all_fobs select _idx) < _minfobdist ) then {
        _clearedtobuildfob = false;
        _distfob = player distance (GRLIB_all_fobs select _idx);
    };
    _idx = _idx + 1;
};

// Check if building too close to sectors
_idx = 0;
if(_clearedtobuildfob) then {
    while { (_idx < (count sectors_allSectors)) && _clearedtobuildsector } do {
        if ( player distance (markerPos (sectors_allSectors select _idx)) < _minsectordist ) then {
            _clearedtobuildsector = false;
            _distsector = player distance (markerPos (sectors_allSectors select _idx));
        };
        _idx = _idx + 1;
    };
};

// Error message handling for scenarios of FOB being too close to another FOB or Sector
if (!_clearedtobuildfob) then {
    hint format [localize "STR_FOB_BUILDING_IMPOSSIBLE",floor _minfobdist,floor _distfob];
    FOB_build_in_progress = false;
    publicVariable "FOB_build_in_progress";
} else {
    if ( !_clearedtobuildsector ) then {
        hint format [localize "STR_FOB_BUILDING_IMPOSSIBLE_SECTOR",floor _minsectordist,floor _distsector];
        FOB_build_in_progress = false;
        publicVariable "FOB_build_in_progress";
    } else {
        buildtype = 99;
        dobuild = 1;
        deleteVehicle (_this select 0);
    };
};
