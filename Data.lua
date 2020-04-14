local ROLE_TANK, ROLE_HEAL, ROLE_MDD, ROLE_RDD = ROLE_TANK, ROLE_HEAL, ROLE_MDD, ROLE_RDD

CEPGP_db = {}

CEPGP_db.tableElixirPrice = {
    [17539] = 80,
    [11474] = 80,
    [11390] = 40,
    [10692] = 40,
    [17538] = 80,
    [17038] = 80,
    [11405] = 20,
    [16329] = 80,
    [16323] = 40,
    [10667] = 40,
    [10669] = 40,
    [11348] = 40,
    [3593] = 20,
    [10668] = 40,
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
    [22790] = 20,
};


CEPGP_db.tableClassSpecElexir = {
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
            [25804] = true,
        },
    },
    ['WARLOCK'] = {
        [ROLE_RDD] = {
            [17539] = true,
            [11474] = true,
            [11390] = true,
            [10692] = true,
            [23161] = true, -- Конь погибели

            [22730] = true,
            [25804] = true,
        },
    },
    ['MAGE'] = {
        [ROLE_RDD] = {
            [17539] = true,
            [11390] = true,
            [10692] = true,
            [21920] = true,

            [22730] = true,
            [25804] = true,
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
            [25804] = true,
        },
        [ROLE_MDD] = {  -- I'm crazy and I know it
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
            [25804] = true,
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
            [25804] = true,
        },
        [ROLE_TANK] = {
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
            [24363] = true,
            [10692] = true,

            [18141] = true,
            [22730] = true,
            [18194] = true,
            [25804] = true,
            [22790] = true,
        },
        [ROLE_TANK] = {
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
            [17539] = true,
            [11474] = true,
            [11390] = true,
            [10692] = true,

            [22730] = true,
            [25804] = true,
        },
        [ROLE_HEAL] = {
            [24363] = true,
            [10692] = true,

            [18141] = true,
            [22730] = true,
            [18194] = true,
            [25804] = true,
            [22790] = true,
        },
    },
    ['DRUID'] = {
        [ROLE_RDD] = {
            [17539] = true,
            [11390] = true,
            [10692] = true,

            [22730] = true,
            [25804] = true,
        },
        [ROLE_HEAL] = {
            [24363] = true,
            [10692] = true,

            [18141] = true,
            [22730] = true,
            [18194] = true,
            [25804] = true,
            [22790] = true,
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
            [25804] = true,
        },
        [ROLE_TANK] = {
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

CEPGP_db.tableRequiredElexir = {
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
        [ROLE_MDD] = {
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

CEPGP_db.tableRequiredTankElixir = {
    [11348] = true,
    [25804] = true,
}

CEPGP_db.fireResistJuju = 16326;

CEPGP_db.beforeRaidBuffs = {
    ['ROGUE'] = {
        [ROLE_MDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22817] = 200,
            [22818] = 50,
            [23768] = 200,
            [23736] = 150,
            [23735] = 100,
            [23737] = 50,
        },
    },
    ['WARLOCK'] = {
        [ROLE_RDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 200,
            [22818] = 50,
            [23768] = 200,
            [23766] = 150,
            [23737] = 100,

            [23161] = 1,  -- КОНЬ ПОГИБЕЛИ
        },
    },
    ['MAGE'] = {
        [ROLE_RDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 200,
            [22818] = 50,
            [23768] = 200,
            [23766] = 150,
            [23737] = 100,
        },
    },
    ['HUNTER'] = {
        [ROLE_RDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22817] = 200,
            [22818] = 50,
            [23768] = 200,
            [23736] = 150,
            [23766] = 100,
            [23737] = 50,
        },
        [ROLE_MDD] = {  -- I'm crazy and I know it
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22817] = 200,
            [22818] = 50,
            [23768] = 200,
            [23736] = 150,
            [23766] = 100,
            [23737] = 50,
        },
    },
    ['WARRIOR'] = {
        [ROLE_MDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22817] = 200,
            [22818] = 50,
            [23768] = 200,
            [23736] = 100,
            [23735] = 150,
            [23737] = 50,
        },
        [ROLE_TANK] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22817] = 200,
            [22818] = 50,
            [23737] = 200,
            [23768] = 150,
            [23735] = 100,
            [23736] = 50,
            [23767] = 50,
        },
    },
    ['PALADIN'] = {
        [ROLE_MDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 100,
            [22817] = 100,
            [22818] = 50,
            [23768] = 200,
            [23735] = 150,
            [23766] = 100,
            [23737] = 50,
        },
        [ROLE_HEAL] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 200,
            [22818] = 50,
            [23766] = 200,
            [23738] = 150,
            [23737] = 100,
        },
        [ROLE_TANK] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 100,
            [22817] = 100,
            [22818] = 50,
            [23737] = 200,
            [23768] = 150,
            [23735] = 100,
            [23766] = 50,
            [23767] = 50,
        },
    },
    ['PRIEST'] = {
        [ROLE_RDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 200,
            [22818] = 50,
            [23768] = 200,
            [23766] = 150,
            [23737] = 100,
        },
        [ROLE_HEAL] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 200,
            [22818] = 50,
            [23766] = 200,
            [23738] = 150,
            [23737] = 100,
        },
    },
    ['DRUID'] = {
        [ROLE_RDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 200,
            [22818] = 50,
            [23768] = 200,
            [23766] = 150,
            [23737] = 100,
        },
        [ROLE_HEAL] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22820] = 200,
            [22818] = 50,
            [23766] = 200,
            [23738] = 150,
            [23737] = 100,
        },
        [ROLE_MDD] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22817] = 200,
            [22818] = 50,
            [23768] = 200,
            [23736] = 150,
            [23735] = 100,
            [23737] = 50,
        },
        [ROLE_TANK] = {
            [22888] = 250,
            [15366] = 250,
            [24425] = 250,
            [22817] = 200,
            [22818] = 50,
            [23737] = 200,
            [23768] = 150,
            [23735] = 100,
            [23736] = 50,
            [23767] = 50,
        },
    },

}

