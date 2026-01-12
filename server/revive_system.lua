local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('md-hospital:server:npcReviveRequest', function(hospitalId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- El NPC revive al jugador (sin coste extra aquí; si quieres, pon coste).
    exports[GetCurrentResourceName()]:ClearDeathState(src)

    -- Reaparece directamente en el hospital elegido (spawnPoint aleatorio)
    TriggerEvent('md-hospital:server:respawnPlayer', hospitalId)
end)

RegisterNetEvent('md-hospital:server:useBed', function(hospitalId, bedIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.respawn or not hospital.respawn[bedIndex] then return end

    -- En cama: si revive, revivimos; si heal, curamos a full si está vivo
    local bed = hospital.respawn[bedIndex]
    local bedType = bed.bedType or 'heal'

    if bedType == 'revive' thenlocal QBCore = exports['qb-core']:GetCoreObject()

-- Usar cama de revivir
RegisterNetEvent('md-hospital:server:useBed', function(hospitalId, bedIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hospital = Config.Hospitals[hospitalId]
    if not hospital or not hospital.respawn or not hospital.respawn[bedIndex] then
        TriggerClientEvent('origen:notify', src, {
            title = 'Error',
            description = 'Cama no configurada.',
            icon = 'triangle-exclamation',
            color = 'error'
        })
        return
    end

    local bed = hospital.respawn[bedIndex]
    local bedType = bed.bedType or 'heal'

    if bedType == 'revive' then
        -- Limpiar estado de muerte y revivir
        exports[GetCurrentResourceName()]:ClearDeathState(src)
        TriggerClientEvent('md-hospital:client:doRespawn', src, bed.spawnPoint)
        
        TriggerClientEvent('origen:notify', src, {
            title = 'Hospital',
            description = 'Has sido revivido en la cama.',
            icon = 'bed',
            color = 'success'
        })
        
        print('^2[MD-Hospital]^7 Jugador ' .. src .. ' revivido en cama de hospital: ' .. hospitalId)
        return
    end

    -- heal: curar si no está muerto
    if bedType == 'heal' then
        TriggerClientEvent('md-hospital:client:adminHealFull', src)
        
        TriggerClientEvent('origen:notify', src, {
            title = 'Hospital',
            description = 'Has sido tratado en la cama.',
            icon = 'bed',
            color = 'success'
        })
        
        print('^2[MD-Hospital]^7 Jugador ' .. src .. ' curado en cama de hospital: ' .. hospitalId)
    end
end)
        exports[GetCurrentResourceName()]:ClearDeathState(src)
        TriggerClientEvent('md-hospital:client:doRespawn', src, bed.spawnPoint)
        return
    end

    -- heal: curar si no está muerto (si está muerto, que use revive o respawn normal)
    TriggerClientEvent('md-hospital:client:adminHealFull', src)
    TriggerClientEvent('origen:notify', src, {
        title = 'Hospital',
        description = 'Has sido tratado en la cama.',
        icon = 'bed',
        color = 'success'
    })
end)
