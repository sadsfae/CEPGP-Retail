local ROLE_TANK, ROLE_HEAL, ROLE_MDD, ROLE_RDD = ROLE_TANK, ROLE_HEAL, ROLE_MDD, ROLE_RDD

db = {}

db.tableElixirPrice = {
    [17628] = 120,
    [17539] = 80,
    [11474] = 80,
    [11390] = 40,
    [17538] = 80,
    [17038] = 80,
    [11334] = 40,
    [11405] = 20,
    [17626] = 120,
    [17540] = 80,
    [11348] = 40,
    [17537] = 40,
    [11371] = 20,
    [3593] = 20,
    [17627] = 120,
    [23161] = 100, -- Конь погибели
};

db.tableClassSpecElexir = {
    ['ROGUE'] = {
        [ROLE_MDD] = {
            [17538] = true,
            [17038] = true,
            [11334] = true,
            [11405] = true,
        },
    },
    ['WARLOCK'] = {
        [ROLE_RDD] = {
            [17628] = true,
            [17539] = true,
            [11474] = true,
            [11390] = true,
            [23161] = true, -- Конь погибели
        },
    },
    ['MAGE'] = {
        [ROLE_RDD] = {
            [17628] = true,
            [17539] = true,
            [11390] = true,
        },
    },
    ['HUNTER'] = {
        [ROLE_RDD] = {
            [17538] = true,
            [11334] = true,
        },
    },
    ['WARRIOR'] = {
        [ROLE_MDD] = {
            [17538] = true,
            [17038] = true,
            [17537] = true,
            [11334] = true,
            [11405] = true,
        },
        [ROLE_TANK] = {
            [17626] = true,
            [17540] = true,
            [17538] = true,
            [17038] = true,
            [11348] = true,
            [17537] = true,
            [11405] = true,
            [11371] = true,
            [3593] = true,
        },
    },
    ['PALADIN'] = {
        [ROLE_MDD] = {
            [17539] = true,
            [17538] = true,
            [17038] = true,
            [11390] = true,
        },
        [ROLE_HEAL] = {
            [17627] = true,
            [24363] = true,
        },
        [ROLE_TANK] = {
            [17626] = true,
            [17540] = true,
            [17538] = true,
            [17038] = true,
            [11348] = true,
            [17537] = true,
            [11405] = true,
            [11371] = true,
            [3593] = true,
        },
    },
    ['PRIEST'] = {
        [ROLE_RDD] = {
            [17628] = true,
            [17539] = true,
            [11474] = true,
            [11390] = true,
        },
        [ROLE_HEAL] = {
            [17627] = true,
            [24363] = true,
        },
    },
    ['DRUID'] = {
        [ROLE_RDD] = {
            [17628] = true,
            [17539] = true,
            [11390] = true,
        },
        [ROLE_HEAL] = {
            [17627] = true,
            [24363] = true,
        },
        [ROLE_MDD] = {
            [17538] = true,
            [17038] = true,
            [11334] = true,
            [11405] = true,
        },
        [ROLE_TANK] = {
            [17626] = true,
            [17540] = true,
            [17538] = true,
            [17038] = true,
            [11348] = true,
            [17537] = true,
            [11405] = true,
            [11371] = true,
            [3593] = true,
        },
    },
};

db.tableFoodPrice = {
    [22730]=20,
    [18192]=20,
    [18125]=20,
    [25661]=20,
    [19710]=20,
    [25804]=20,
    [18141]=20,
    [18194]=20,
    [24799]=20,
};

db.fireResistFlask = {
    [7233]=30,
    [17543]=100,
--    [23161]=100, -- Конь погибели
}