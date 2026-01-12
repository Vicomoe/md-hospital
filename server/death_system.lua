local QBCore = exports['qb-core']:GetCoreObject()

local PlayerDeathStatus = {} -- [src] = { timer = seconds }

local function GetRandomSpawnPoint(hospitalId)
    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.respawn or #hospital.respawn == 0 then return nil end
    
    local entry = hospital.respawn[math.random(#hospital.respawn)]
    return entry.spawnPoint
end

RegisterNetEvent('md-hospital:server:playerDied', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    PlayerDeathStatus[src] = { timer = Config.RespawnTimer.wait_time }
    print('^3[MD-Hospital]^7 Jugador ' .. src .. ' ha muerto. Timer: ' .. Config.RespawnTimer.wait_time .. 's')
end)

RegisterNetEvent('md-hospital:server:updateRespawnTimer', function(secondsLeft)
    local src = source
    
    if PlayerDeathStatus[src] then
        PlayerDeathStatus[src].timer = tonumber(secondsLeft) or PlayerDeathStatus[src].timer
    end
end)

RegisterNetEvent('md-hospital:server:respawnPlayer', function(hospitalId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Validar que el hospital exista
    if not Config.Hospitals[hospitalId] then
        TriggerClientEvent('origen:notify', src, {
            title = 'Error',
            description = 'Hospital no válido.',
            icon = 'triangle-exclamation',
            color = 'error'
        })
        return
    end

    -- Timer check - CORRECCIÓN: Validar correctamente si PlayerDeathStatus existe
    if not PlayerDeathStatus[src] or PlayerDeathStatus[src].timer > 0 then
        TriggerClientEvent('origen:notify', src, {
            title = 'Respawn',
            description = 'Aún no puedes reaparecer. Espera a que termine el timer.',
            icon = 'clock',
            color = 'error'
        })
        return
    end

    -- Money check
    local cost = Config.Costs.respawn_fee or 0

    if cost > 0 and Player.Functions.GetMoney('cash') < cost then
        TriggerClientEvent('origen:notify', src, {
            title = 'Respawn',
            description = ('Necesitas $%s'):format(cost),
            icon = 'dollar',
            color = 'error'
        })
        return
    end

    if cost > 0 then
        Player.Functions.RemoveMoney('cash', cost, 'md-hospital-respawn')
        TriggerClientEvent('origen:notify', src, {
            title = 'Respawn',
            description = ('Se te cobró $%s'):format(cost),
            icon = 'dollar',
            color = 'error'
        })
    end

    local spawnPoint = GetRandomSpawnPoint(hospitalId)

    if not spawnPoint then
        TriggerClientEvent('origen:notify', src, {
            title = 'Error',
            description = 'Hospital sin spawnPoint configurado.',
            icon = 'triangle-exclamation',
            color = 'error'
        })
        return
    end

    PlayerDeathStatus[src] = nil
    
    print('^2[MD-Hospital]^7 Jugador ' .. src .. ' ha reaparecido en: ' .. hospitalId)
    TriggerClientEvent('md-hospital:client:doRespawn', src, spawnPoint)
end)

-- Cuando el NPC revive al jugador
RegisterNetEvent('md-hospital:server:npcReviveRequest', function(hospitalId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    print('^3[MD-Hospital]^7 NPC está reviviendo al jugador ' .. src)
    
    -- Limpiar estado de muerte
    exports[GetCurrentResourceName()]:ClearDeathState(src)
    
    -- Reaparece directamente en el hospital elegido (spawnPoint aleatorio)
    TriggerServerEvent('md-hospital:server:respawnPlayer', hospitalId)
end)

-- Export útil para limpiar muerte desde admin/medic/npc
exports('ClearDeathState', function(src)
    PlayerDeathStatus[src] = nil
    print('^2[MD-Hospital]^7 Estado de muerte limpiado para jugador: ' .. src)
end)

-- Limpiar cuando el jugador se desconecta
AddEventHandler('playerDropped', function()
    local src = source
    PlayerDeathStatus[src] = nil
    print('^2[MD-Hospital]^7 Jugador ' .. src .. ' desconectado. Estado limpiado.')
end)