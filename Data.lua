local ROLE_TANK, ROLE_HEAL, ROLE_MDD, ROLE_RDD = ROLE_TANK, ROLE_HEAL, ROLE_MDD, ROLE_RDD

db = {}

db.tableElixirPrice = {
    [17628] = 120,
    [17539] = 80,
    [11474] = 80,
    [11390] = 40,
    [10692] = 40,
    [17538] = 80,
    [17038] = 80,
    [11334] = 40,
    [11405] = 20,
    [16329] = 80,
    [16323] = 40,
    [10667] = 40,
    [10669] = 40,
    [17626] = 120,
    [17540] = 80,
    [11348] = 40,
    [17537] = 40,
    [11371] = 20,
    [3593] = 20,
    [10668] = 40,
    [17627] = 120,
    [21920] = 20,
    [23161] = 80, -- Конь погибели

    -- Food
    [22730] = 20,
    [18192] = 20,
    [18125] = 20,
    [25661] = 20,
    [19710] = 20,
    [25804] = 20,
    [18141] = 20,
    [18194] = 20,
    [24799] = 20,
};

db.tableClassSpecElexir = {
    ['ROGUE'] = {
        [ROLE_MDD] = {
            [17538] = true,
            [17038] = true,
            [11334] = true,
            [11405] = true,
            [16329] = true,
            [16323] = true,
            [10667] = true,
            [10669] = true,

            [18192] = true,
            [18125] = true,
        },
    },
    ['WARLOCK'] = {
        [ROLE_RDD] = {
            [17628] = true,
            [17539] = true,
            [11474] = true,
            [11390] = true,
            [10692] = true,
            [23161] = true, -- Конь погибели

            [22730] = true,
        },
    },
    ['MAGE'] = {
        [ROLE_RDD] = {
            [17628] = true,
            [17539] = true,
            [11390] = true,
            [10692] = true,
            [21920] = true,

            [22730] = true,
        },
    },
    ['HUNTER'] = {
        [ROLE_RDD] = {
            [17538] = true,
            [11334] = true,
            [16323] = true,
            [10669] = true,

            [18192] = true,
            [18125] = true,
        },
    },
    ['WARRIOR'] = {
        [ROLE_MDD] = {
            [17538] = true,
            [17038] = true,
            [17537] = true,
            [11334] = true,
            [11405] = true,
            [16329] = true,
            [16323] = true,
            [10667] = true,
            [10669] = true,

            [18192] = true,
            [18125] = true,
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
            [16329] = true,
            [16323] = true,
            [10668] = true,

            [25661] = true,
            [19710] = true,
            [25804] = true,
        },
    },
    ['PALADIN'] = {
        [ROLE_MDD] = {
            [17539] = true,
            [17538] = true,
            [17038] = true,
            [11390] = true,
            [16329] = true,
            [16323] = true,
            [10667] = true,
            [10669] = true,

            [24799] = true,
            [19710] = true,
            [25804] = true,
            [18194] = true,
        },
        [ROLE_HEAL] = {
            [17627] = true,
            [24363] = true,
            [10692] = true,

            [18141] = true,
            [22730] = true,
            [18194] = true,
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
            [16329] = true,
            [16323] = true,
            [10668] = true,

            [25661] = true,
            [19710] = true,
            [25804] = true,
            [18194] = true,
        },
    },
    ['PRIEST'] = {
        [ROLE_RDD] = {
            [17628] = true,
            [17539] = true,
            [11474] = true,
            [11390] = true,
            [10692] = true,

            [22730] = true,
        },
        [ROLE_HEAL] = {
            [17627] = true,
            [24363] = true,
            [10692] = true,

            [18141] = true,
            [22730] = true,
            [18194] = true,
        },
    },
    ['DRUID'] = {
        [ROLE_RDD] = {
            [17628] = true,
            [17539] = true,
            [11390] = true,
            [10692] = true,

            [22730] = true,
        },
        [ROLE_HEAL] = {
            [17627] = true,
            [24363] = true,
            [10692] = true,

            [18141] = true,
            [22730] = true,
            [18194] = true,
        },
        [ROLE_MDD] = {
            [17538] = true,
            [17038] = true,
            [11334] = true,
            [11405] = true,
            [16329] = true,
            [16323] = true,
            [10667] = true,
            [10669] = true,

            [18192] = true,
            [18125] = true,
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
            [16329] = true,
            [16323] = true,
            [10668] = true,

            [25661] = true,
            [18192] = true,
            [19710] = true,
            [25804] = true,
        },
    },
};

db.tableRequiredElexir = {
    ['ROGUE'] = {
        [ROLE_MDD] = {
            [17538] = true,
        },
    },
    ['WARLOCK'] = {
        [ROLE_RDD] = {
            [17539] = true,
            [11474] = true,

            [23161] = true, -- Конь погибели
        },
    },
    ['MAGE'] = {
        [ROLE_RDD] = {
            [17539] = true,
        },
    },
    ['HUNTER'] = {
        [ROLE_RDD] = {
            [17538] = true,
        },
    },
    ['WARRIOR'] = {
        [ROLE_MDD] = {
            [17538] = true,
        },
    },
    ['PALADIN'] = {
        [ROLE_MDD] = {
            [17538] = true,
        },
    },
    ['PRIEST'] = {
        [ROLE_RDD] = {
            [17539] = true,
            [11474] = true,
        },
    },
    ['DRUID'] = {
        [ROLE_RDD] = {
            [17539] = true,
        },
        [ROLE_MDD] = {
            [17538] = true,
        },
    },
};

db.tableRequiredTankElixir = {
    [11348] = true,
    [25804] = true,
}

db.fireResistFlask = {
    [7233]=30,
    [17543]=100,
--    [23161]=100, -- Конь погибели
};

db.fireResistJuju = 16326;

db.juju = {
    [16329] = true,
    [16323] = true,
};