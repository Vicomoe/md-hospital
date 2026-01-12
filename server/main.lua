local QBCore = exports['qb-core']:GetCoreObject()

local function GetJobAndGrade(Player)
    local job = Player.PlayerData.job
    local jobName = job and job.name or 'unemployed'
    local grade = (job and job.grade and (job.grade.level or job.grade)) or 0
    return jobName, grade
end

local function IsAmbulanceAllowed(Player, minGrade)
    local jobName, grade = GetJobAndGrade(Player)
    if jobName ~= Config.AmbulanceJob.name then return false end
    if minGrade and grade < minGrade then return false end
    return true
end

-- Registrar stashes/shops al iniciar
AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end

    -- Register stashes
    for hospitalId, hospital in pairs(Config.Hospitals) do
        for stashId, stash in pairs(hospital.stash or {}) do
            local slots = stash.slots or 50
            local weightKg = stash.weight or 50
            local weightGrams = weightKg * 1000

            exports.ox_inventory:RegisterStash(
                ('%s_%s'):format(hospitalId, stashId),
                stash.label or 'Stash',
                slots,
                weightGrams,
                stash.shared == true
            )
        end

        -- Register pharmacies as shops
        for shopId, shop in pairs(hospital.pharmacy or {}) do
            local inv = {}
            for _, it in ipairs(shop.items or {}) do
                inv[#inv+1] = {
                    name = it.name,
                    price = it.price or 1,
                    count = it.count or 999999
                }
            end

            exports.ox_inventory:RegisterShop(
                ('%s_%s'):format(hospitalId, shopId),
                {
                    name = shop.label or 'Pharmacy',
                    inventory = inv
                }
            )
        end
    end

    print('^2[MD-Hospital]^7 Ready: stashes/shops registrados')
end)

-- Open pharmacy (server-side grade check)
RegisterNetEvent('md-hospital:server:openPharmacy', function(hospitalId, shopId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.pharmacy or not hospital.pharmacy[shopId] then return end

    local shop = hospital.pharmacy[shopId]
    if shop.job then
        if not IsAmbulanceAllowed(Player, shop.grade or 0) then
            TriggerClientEvent('origen:notify', src, {
                title = 'Acceso denegado',
                description = 'No tienes permisos para usar esta farmacia.',
                icon = 'ban',
                color = 'error',
                duration = 3000
            })
            return
        end
    end

    exports.ox_inventory:openInventory(src, 'shop', { type = ('%s_%s'):format(hospitalId, shopId) })
end)

-- Open stash (server-side grade check)
RegisterNetEvent('md-hospital:server:openStash', function(hospitalId, stashId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.stash or not hospital.stash[stashId] then return end

    local stash = hospital.stash[stashId]
    if not IsAmbulanceAllowed(Player, stash.min_grade or 0) then
        TriggerClientEvent('origen:notify', src, {
            title = 'Acceso denegado',
            description = 'No tienes permisos para abrir este almacén.',
            icon = 'ban',
            color = 'error',
            duration = 3000
        })
        return
    end

    exports.ox_inventory:openInventory(src, 'stash', { id = ('%s_%s'):format(hospitalId, stashId) })
end)

-- Bossmenu stub (solo notifica; si luego quieres integrar qb-management o similar, se cambia aquí)
RegisterNetEvent('md-hospital:server:openBossMenu', function(hospitalId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.bossmenu then return end

    if not IsAmbulanceAllowed(Player, hospital.bossmenu.min_grade or 0) then
        TriggerClientEvent('origen:notify', src, {
            title = 'Acceso denegado',
            description = 'No tienes rango para el bossmenu.',
            icon = 'ban',
            color = 'error'
        })
        return
    end

    TriggerClientEvent('origen:notify', src, {
        title = 'Boss Menu',
        description = 'Stub: aquí puedes conectar qb-bossmenu/qb-management si quieres.',
        icon = 'briefcase',
        color = 'info'
    })
end)

-- Garage menu
RegisterNetEvent('md-hospital:server:openGarage', function(hospitalId, garageId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    local garage = hospital and hospital.garage and hospital.garage[garageId]
    if not garage then return end

    -- En el menú de garaje, aplicamos el min_grade por vehículo.
    TriggerClientEvent('md-hospital:client:openGarageMenu', src, hospitalId, garageId, garage.vehicles or {})
end)

-- Spawn vehicle request (server side check)
RegisterNetEvent('md-hospital:server:spawnGarageVehicle', function(hospitalId, garageId, spawn_code, min_grade)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if not IsAmbulanceAllowed(Player, min_grade or 0) then
        TriggerClientEvent('origen:notify', src, {
            title = 'Acceso denegado',
            description = 'No tienes rango para este vehículo.',
            icon = 'ban',
            color = 'error'
        })
        return
    end

    local hospital = Config.Hospitals[hospitalId]
    local garage = hospital and hospital.garage and hospital.garage[garageId]
    if not garage then return end

    TriggerClientEvent('md-hospital:client:spawnVehicleAt', src, spawn_code, garage.spawn)
end)


local QBCore = exports['qb-core']:GetCoreObject()

local function Notify(src, title, desc, color)
    TriggerClientEvent('origen:notify', src, {
        title = title,
        description = desc,
        icon = (color == 'error' and 'triangle-exclamation') or 'check',
        color = color or 'info',
        duration = 3500
    })
end

QBCore.Commands.Add('heal', 'Curar completamente a un jugador (ADMIN)', {
    { name = 'id', help = 'ID del jugador' }
}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    if not target then return Notify(src, 'Heal', 'ID inválido', 'error') end

    local T = QBCore.Functions.GetPlayer(target)
    if not T then return Notify(src, 'Heal', 'Jugador no encontrado', 'error') end

    TriggerClientEvent('md-hospital:client:adminHealFull', target)
    Notify(src, 'Heal', ('Curado %s'):format(target), 'success')
end, 'admin')

QBCore.Commands.Add('revive', 'Revivir a un jugador (ADMIN)', {
    { name = 'id', help = 'ID del jugador' }
}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    if not target then return Notify(src, 'Revive', 'ID inválido', 'error') end

    local T = QBCore.Functions.GetPlayer(target)
    if not T then return Notify(src, 'Revive', 'Jugador no encontrado', 'error') end

    -- Limpia estado de muerte interno y revive donde esté (sin hospital)
    if exports[GetCurrentResourceName()] and exports[GetCurrentResourceName()].ClearDeathState then
        exports[GetCurrentResourceName()]:ClearDeathState(target)
    end

    TriggerClientEvent('md-hospital:client:adminRevive', target)
    Notify(src, 'Revive', ('Revivido %s'):format(target), 'success')
end, 'admin')

QBCore.Commands.Add('kill', 'Matar a un jugador (ADMIN)', {
    { name = 'id', help = 'ID del jugador' }
}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    if not target then return Notify(src, 'Kill', 'ID inválido', 'error') end

    local T = QBCore.Functions.GetPlayer(target)
    if not T then return Notify(src, 'Kill', 'Jugador no encontrado', 'error') end

    TriggerClientEvent('md-hospital:client:adminKill', target)
    Notify(src, 'Kill', ('Muerto %s'):format(target), 'success')
end, 'admin')
local QBCore = exports['qb-core']:GetCoreObject()

local function GetJobAndGrade(Player)
    local job = Player.PlayerData.job
    local jobName = job and job.name or 'unemployed'
    local grade = (job and job.grade and (job.grade.level or job.grade)) or 0
    return jobName, grade
end

local function IsAmbulanceAllowed(Player, minGrade)
    local jobName, grade = GetJobAndGrade(Player)
    if jobName ~= Config.AmbulanceJob.name then return false end
    if minGrade and grade < minGrade then return false end
    return true
end

-- Función para notificaciones
local function Notify(src, title, desc, color)
    TriggerClientEvent('origen:notify', src, {
        title = title,
        description = desc,
        icon = (color == 'error' and 'triangle-exclamation') or 'check',
        color = color or 'info',
        duration = 3500
    })
end

-- Registrar stashes/shops al iniciar
AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end

    print('^2[MD-Hospital]^7 Registrando stashes y shops...')

    -- Register stashes
    for hospitalId, hospital in pairs(Config.Hospitals) do
        for stashId, stash in pairs(hospital.stash or {}) do
            local slots = stash.slots or 50
            local weightKg = stash.weight or 50
            local weightGrams = weightKg * 1000

            exports.ox_inventory:RegisterStash(
                ('%s_%s'):format(hospitalId, stashId),
                stash.label or 'Stash',
                slots,
                weightGrams,
                stash.shared == true
            )
            
            print('^3[MD-Hospital]^7 Stash registrado: ' .. ('%s_%s'):format(hospitalId, stashId))
        end

        -- Register pharmacies as shops
        for shopId, shop in pairs(hospital.pharmacy or {}) do
            local inv = {}

            for _, it in ipairs(shop.items or {}) do
                inv[#inv+1] = {
                    name = it.name,
                    price = it.price or 1,
                    count = it.count or 999999
                }
            end

            exports.ox_inventory:RegisterShop(
                ('%s_%s'):format(hospitalId, shopId),
                {
                    name = shop.label or 'Pharmacy',
                    inventory = inv
                }
            )
            
            print('^3[MD-Hospital]^7 Shop registrado: ' .. ('%s_%s'):format(hospitalId, shopId))
        end
    end

    print('^2[MD-Hospital]^7 ✅ Ready: stashes/shops registrados correctamente')
end)

-- Open pharmacy (server-side grade check)
RegisterNetEvent('md-hospital:server:openPharmacy', function(hospitalId, shopId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.pharmacy or not hospital.pharmacy[shopId] then return end

    local shop = hospital.pharmacy[shopId]

    if shop.job then
        if not IsAmbulanceAllowed(Player, shop.grade or 0) then
            Notify(src, 'Acceso denegado', 'No tienes permisos para usar esta farmacia.', 'error')
            return
        end
    end

    exports.ox_inventory:openInventory(src, 'shop', { type = ('%s_%s'):format(hospitalId, shopId) })
end)

-- Open stash (server-side grade check)
RegisterNetEvent('md-hospital:server:openStash', function(hospitalId, stashId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.stash or not hospital.stash[stashId] then return end

    local stash = hospital.stash[stashId]

    if not IsAmbulanceAllowed(Player, stash.min_grade or 0) then
        Notify(src, 'Acceso denegado', 'No tienes permisos para abrir este almacén.', 'error')
        return
    end

    exports.ox_inventory:openInventory(src, 'stash', { id = ('%s_%s'):format(hospitalId, stashId) })
end)

-- Bossmenu stub (solo notifica; si luego quieres integrar qb-management o similar, se cambia aquí)
RegisterNetEvent('md-hospital:server:openBossMenu', function(hospitalId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.bossmenu then return end

    if not IsAmbulanceAllowed(Player, hospital.bossmenu.min_grade or 0) then
        Notify(src, 'Acceso denegado', 'No tienes rango para el bossmenu.', 'error')
        return
    end

    Notify(src, 'Boss Menu', 'Stub: aquí puedes conectar qb-bossmenu/qb-management si quieres.', 'info')
end)

-- Garage menu
RegisterNetEvent('md-hospital:server:openGarage', function(hospitalId, garageId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    local garage = hospital and hospital.garage and hospital.garage[garageId]

    if not garage then return end

    -- En el menú de garaje, aplicamos el min_grade por vehículo.
    TriggerClientEvent('md-hospital:client:openGarageMenu', src, hospitalId, garageId, garage.vehicles or {})
end)

-- Spawn vehicle request (server side check)
RegisterNetEvent('md-hospital:server:spawnGarageVehicle', function(hospitalId, garageId, spawn_code, min_grade)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if not IsAmbulanceAllowed(Player, min_grade or 0) then
        Notify(src, 'Acceso denegado', 'No tienes rango para este vehículo.', 'error')
        return
    end

    local hospital = Config.Hospitals[hospitalId]
    local garage = hospital and hospital.garage and hospital.garage[garageId]

    if not garage then return end

    TriggerClientEvent('md-hospital:client:spawnVehicleAt', src, spawn_code, garage.spawn)
end)

-- ADMIN COMMANDS
QBCore.Commands.Add('heal', 'Curar completamente a un jugador (ADMIN)', {
    { name = 'id', help = 'ID del jugador' }
}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    
    if not target then return Notify(src, 'Heal', 'ID inválido', 'error') end
    
    local T = QBCore.Functions.GetPlayer(target)
    if not T then return Notify(src, 'Heal', 'Jugador no encontrado', 'error') end
    
    TriggerClientEvent('md-hospital:client:adminHealFull', target)
    Notify(src, 'Heal', ('Curado: %s'):format(target), 'success')
    print('^2[MD-Hospital]^7 Admin ' .. src .. ' curó al jugador ' .. target)
end, 'admin')

QBCore.Commands.Add('revive', 'Revivir a un jugador (ADMIN)', {
    { name = 'id', help = 'ID del jugador' }
}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    
    if not target then return Notify(src, 'Revive', 'ID inválido', 'error') end
    
    local T = QBCore.Functions.GetPlayer(target)
    if not T then return Notify(src, 'Revive', 'Jugador no encontrado', 'error') end
    
    -- Limpia estado de muerte interno y revive donde esté (sin hospital)
    if exports[GetCurrentResourceName()]:ClearDeathState then
        exports[GetCurrentResourceName()]:ClearDeathState(target)
    end
    
    TriggerClientEvent('md-hospital:client:adminRevive', target)
    Notify(src, 'Revive', ('Revivido: %s'):format(target), 'success')
    print('^2[MD-Hospital]^7 Admin ' .. src .. ' revivió al jugador ' .. target)
end, 'admin')

QBCore.Commands.Add('kill', 'Matar a un jugador (ADMIN)', {
    { name = 'id', help = 'ID del jugador' }
}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    
    if not target then return Notify(src, 'Kill', 'ID inválido', 'error') end
    
    local T = QBCore.Functions.GetPlayer(target)
    if not T then return Notify(src, 'Kill', 'Jugador no encontrado', 'error') end
    
    TriggerClientEvent('md-hospital:client:adminKill', target)
    Notify(src, 'Kill', ('Muerto: %s'):format(target), 'success')
    print('^2[MD-Hospital]^7 Admin ' .. src .. ' mató al jugador ' .. target)
end, 'admin')