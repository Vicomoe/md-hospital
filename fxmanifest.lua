fx_version 'cerulean'
game 'gta5'

author 'MD-Hospital (Zombie Survival)'
description 'Sistema médico: timer muerte 120s + respawn menu + ox_target + ox_inventory shops/stashes'
version '3.0.1'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
    'client/death_system.lua',
    'client/hospital_functions.lua',
    'client/respawn_menu.lua',
}

server_scripts {
    'server/main.lua',
    'server/death_system.lua',
    'server/revive_system.lua',
    'server/medical_items.lua',
}

dependencies {
    'qb-core',
    'ox-lib',
    'ox-target',
    'ox_inventory',
    'origen_notify',
}

exports {
    'ClearDeathState',
}