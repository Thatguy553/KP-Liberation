private [ "_mincampdist", "_minsectordist", "_distcamp", "_clearedtobuildfob", "_distsector", "_clearedtobuildsector", "_idx" ];

if ( count KPLIB_all_camps >= KP_liberation_MaxCamps ) exitWith {
    hint format [ localize "STR_HINT_FOBS_EXCEEDED", KP_liberation_MaxCamps ];
};

_mincampdist = 1000;
if (KP_liberation_MinSectorBuildDistanceCamp == 1) then {
    _minsectordist = GRLIB_capture_size + KP_liberation_FobRange;
} else {
    _minsectordist = KP_liberation_MinSectorBuildDistanceCamp;
};
_distcamp = 1;
_clearedtobuildfob = true;
_distsector = 1;
_clearedtobuildsector = true;

CAMP_build_in_progress = true;
publicVariable "CAMP_build_in_progress";

// Check if building too close to another FOB
_idx = 0;
while { (_idx < (count KPLIB_all_camps)) && _clearedtobuildfob } do {
    if ( player distance (KPLIB_all_camps select _idx) < _mincampdist ) then {
        _clearedtobuildfob = false;
        _distcamp = player distance (KPLIB_all_camps select _idx);
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
    hint format [localize "STR_FOB_BUILDING_IMPOSSIBLE",floor _mincampdist,floor _distcamp];
    CAMP_build_in_progress = false;
    publicVariable "CAMP_build_in_progress";
} else {
    if ( !_clearedtobuildsector ) then {
        hint format [localize "STR_FOB_BUILDING_IMPOSSIBLE_SECTOR",floor _minsectordist,floor _distsector];
        CAMP_build_in_progress = false;
        publicVariable "CAMP_build_in_progress";
    } else {
        buildtype = 98;
        dobuild = 1;
        deleteVehicle (_this select 0);
    };
};
