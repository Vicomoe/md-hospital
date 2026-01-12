Config = {}

-- ⏱️ TIMER RESPAWN
Config.RespawnTimer = {
    wait_time = 120,
    show_countdown = true,
}

-- 💰 COSTOS
Config.Costs = {
    respawn_fee = 25,
}

-- 👮 Job médico (si quieres restringir cosas por job/grade)
Config.AmbulanceJob = {
    name = 'ambulance',
}

-- 💊 ITEMS MÉDICOS (enyo-medical / ox_inventory)
Config.MedicalItems = {
    { name = 'bandage',          label = 'Vendaje',            icon = 'fas fa-bandage',           price = 1 },
    { name = 'medkit',           label = 'Kit Médico',         icon = 'fas fa-briefcase-medical', price = 1 },
    { name = 'painkillers',      label = 'Analgésicos',        icon = 'fas fa-pills',             price = 1 },
    { name = 'cefotaxime',       label = 'Cefotaxima',         icon = 'fas fa-syringe',           price = 1 },
    { name = 'ribavirin',        label = 'Ribavirina',         icon = 'fas fa-syringe',           price = 1 },
    { name = 'dexamethasone',    label = 'Dexametasona',       icon = 'fas fa-syringe',           price = 1 },
    { name = 'tranexamic_acid',  label = 'Ácido tranexámico',  icon = 'fas fa-syringe',           price = 1 },
}

-- 🏥 HOSPITALES
Config.Hospitals = {
    ['north'] = {
        name = 'SANTURARIO',

        paramedic = {
            model = 's_m_m_scientist_01',
            pos = vector4(2870.0571, 4646.0552, 48.6645, 185.0014),
        },

        bossmenu = {
            pos = vector3(2838.8313, 4649.5068, 49.8649),
            min_grade = 4
        },

        zone = {
            pos = vector3(2852.8108, 4627.6987, 49.6645),
            size = vector3(200.0, 200.0, 200.0),
        },

        blip = {
            enable = true, -- ✅ TRUE/FALSE
            name = 'Santuario',
            type = 61,
            scale = 0.7,
            color = 2,
            pos = vector3(2852.8108, 4627.6987, 49.6645),
        },

        respawn = {
            {
                bedPoint = vector4(2840.53, 4659.71, 49.42, 24.72),
                spawnPoint = vector4(2851.31, 4657.18, 49.66, 223.67),
                bedType = 'revive',
            },
            {
                bedPoint = vector4(2837.54, 4658.91, 49.42, 24.72),
                spawnPoint = vector4(2851.31, 4657.18, 49.66, 223.67),
                bedType = 'heal',
            },
            {
                bedPoint = vector4(2841.61, 4655.68, 49.42, 200.26),
                spawnPoint = vector4(2851.31, 4657.18, 49.66, 223.67),
                bedType = 'revive',
            },
            {
                bedPoint = vector4(2838.57, 4654.80, 49.42, 200.26),
                spawnPoint = vector4(2851.31, 4657.18, 49.66, 223.67),
                bedType = 'heal',
            },
        },

        stash = {
            ['ems_stash_1'] = {
                slots = 50,
                weight = 250, -- kg
                min_grade = 3,
                label = 'Almacen',
                shared = true,
                pos = vector3(2841.3750, 4650.7456, 49.8649)
            }
        },

        pharmacy = {
            ['ems_shop_1'] = {
                job = true,
                label = 'Pharmacy',
                grade = 4,
                pos = vector3(2844.4658, 4659.9209, 49.8649),
                blip = { enable = false },
                items = Config.MedicalItems
            }
        },

        garage = {
            ['ems_garage_1'] = {
                pedPos = vector4(2874.4014, 4616.6001, 48.6645, 200.2830),
                model = 'mp_m_weapexp_01',
                spawn = vector4(2878.5649, 4611.2051, 49.4283, 10.1339),
                deposit = vector3(2877.2964, 4619.9131, 49.4301),
                driverSpawnCoords = vector3(2870.9202, 4613.3398, 49.6645),

                vehicles = {
                    { label = 'Ambulance', spawn_code = 'ambulance', min_grade = 4, modifications = {} },
                }
            }
        },
    },

    ['south'] = {
        name = 'HOSPITAL',

        paramedic = {
            model = 's_m_m_scientist_01',
            pos = vector4(177.2366, 6596.3032, 30.8468, 191.4113),
        },

        bossmenu = {
            pos = vector3(178.2131, 6609.8530, 31.8465),
            min_grade = 4
        },

        zone = {
            pos = vector3(180.0728, 6601.2480, 32.0474),
            size = vector3(200.0, 200.0, 200.0),
        },

        blip = {
            enable = false, -- ✅ TRUE/FALSE
            name = 'Hospital',
            type = 61,
            scale = 0.7,
            color = 2,
            pos = vector3(180.0728, 6601.2480, 32.0474),
        },

        respawn = {
            {
                bedPoint = vector4(182.1079, 6591.9087, 31.8620, 178.7547),
                spawnPoint = vector4(186.8943, 6592.5869, 31.8553, 229.4724),
                bedType = 'revive',
            },
        },

        stash = {
            ['ems_stash_1'] = {
                slots = 50,
                weight = 50, -- kg
                min_grade = 4,
                label = 'Ems stash',
                shared = true,
                pos = vector3(179.2018, 6604.2944, 32.0473)
            }
        },

        pharmacy = {
            ['ems_shop_1'] = {
                job = true,
                label = 'Pharmacy',
                grade = 4,
                pos = vector3(174.8040, 6610.4756, 31.8544),
                blip = { enable = false },
                items = Config.MedicalItems
            }
        },

        garage = {
            ['ems_garage_1'] = {
                pedPos = vector4(169.5334, 6626.1255, 30.6989, 222.1498),
                model = 'mp_m_weapexp_01',
                spawn = vector4(163.5734, 6622.6201, 31.8496, 228.3703),
                deposit = vector3(163.5734, 6622.6201, 31.8496),
                driverSpawnCoords = vector3(163.0725, 6629.5938, 31.6947),

                vehicles = {
                    { label = 'Ambulance', spawn_code = 'ambulance', min_grade = 4, modifications = {} },
                }
            }
        },
    },
}
