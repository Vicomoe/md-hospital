local lib = exports.ox_lib
local QBCore = exports['qb-core']:GetCoreObject()

local isDead = false
local showRespawnKey = false
local secondsLeft = 0

local function OpenRespawnMenu()
    local options = {}
    
    for hospitalId, hospital in pairs(Config.Hospitals) do
        table.insert(options, {
            title = hospital.name,
            description = ('Reaparecer aquí ($%s)'):format(Config.Costs.respawn_fee),
            icon = 'hospital',
            onSelect = function()
                TriggerServerEvent('md-hospital:server:respawnPlayer', hospitalId)
            end
        })
    end
    
    lib.registerContext({
        id = 'md_hospital_respawn_menu',
        title = '🏥 Elegir hospital',
        options = options
    })
    
    lib.showContext('md_hospital_respawn_menu')
end

local function ShowRespawnPrompt()
    showRespawnKey = true
    lib.showTextUI('[E] Reaparecer en Hospital', { position = 'top-center', icon = 'hospital' })
    
    CreateThread(function()
        while isDead and showRespawnKey do
            Wait(0)
            
            if IsControlJustPressed(0, 38) then -- E key
                lib.hideTextUI()
                showRespawnKey = false
                OpenRespawnMenu()
                return
            end
        end
    end)
end

local function StartDeathTimer()
    secondsLeft = Config.RespawnTimer.wait_time
    
    CreateThread(function()
        while isDead and secondsLeft > 0 do
            Wait(1000)
            secondsLeft -= 1
            
            if Config.RespawnTimer.show_countdown then
                lib.notify({
                    title = '⏱️ Tiempo para respawn',
                    description = ('%d segundos restantes'):format(secondsLeft),
                    type = 'inform',
                    duration = 800
                })
            end
            
            TriggerServerEvent('md-hospital:server:updateRespawnTimer', secondsLeft)
        end
        
        -- Cuando el timer termina, mostrar prompt
        if isDead then
            ShowRespawnPrompt()
        end
    end)
end

local function HandlePlayerDeath()
    if isDead then return end
    
    isDead = true
    showRespawnKey = false
    
    -- Notificar al servidor
    TriggerServerEvent('md-hospital:server:playerDied')
    
    -- Notificación al cliente
    lib.notify({
        title = '💀 Muerte',
        description = ('Espera %d segundos para poder reaparecer.'):format(Config.RespawnTimer.wait_time),
        type = 'error',
        duration = 4000
    })
    
    -- Iniciar timer
    StartDeathTimer()
end

-- ✅ Detector robusto de muerte
CreateThread(function()
    while true do
        Wait(400)
        
        local ped = PlayerPedId()
        
        if DoesEntityExist(ped) then
            -- Si no estamos muertos pero lo detectamos, iniciar secuencia
            if not isDead and IsEntityDead(ped) then
                HandlePlayerDeath()
            end
            
            -- Si estamos marcados como muertos pero ya no lo estamos, limpiar
            if isDead and not IsEntityDead(ped) then
                isDead = false
                showRespawnKey = false
                lib.hideTextUI()
            end
        end
    end
end)

-- 🔁 Respawn desde servidor (con coords)
RegisterNetEvent('md-hospital:client:doRespawn', function(spawnPoint)
    local ped = PlayerPedId()
    
    -- Fade out
    DoScreenFadeOut(300)
    Wait(350)
    
    -- Teleportar si tenemos spawnPoint
    if spawnPoint then
        SetEntityCoordsNoOffset(ped, spawnPoint.x, spawnPoint.y, spawnPoint.z, false, false, false)
        SetEntityHeading(ped, spawnPoint.w or 0.0)
    end
    
    -- Resurrección de red
    NetworkResurrectLocalPlayer(GetEntityCoords(ped), (spawnPoint and spawnPoint.w) or 0.0, true, false)
    ClearPedTasksImmediately(ped)
    
    -- Restablecer vida y armadura
    SetEntityHealth(ped, 200)
    SetPedArmour(ped, 0)
    
    -- Limpiar estado de muerte
    isDead = false
    showRespawnKey = false
    lib.hideTextUI()
    
    -- Fade in
    DoScreenFadeIn(300)
    
    -- Notificación de éxito
    lib.notify({
        title = '✅ Reaparecido',
        description = 'Has reaparecido en el hospital.',
        type = 'success',
        duration = 3000
    })
end)

-- ☠️ Kill remoto admin
RegisterNetEvent('md-hospital:client:adminKill', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 0)
    
    lib.notify({
        title = '☠️ Muerto',
        description = 'Has sido eliminado por un administrador.',
        type = 'error',
        duration = 3000
    })
end)

-- 🩹 Heal remoto admin
RegisterNetEvent('md-hospital:client:adminHealFull', function()
    local ped = PlayerPedId()
    
    -- Solo curar si estamos vivos
    if IsEntityDead(ped) then return end
    
    SetEntityHealth(ped, 200)
    SetPedArmour(ped, 0)
    
    lib.notify({
        title = '🩹 Curado',
        description = 'Has sido curado completamente.',
        type = 'success',
        duration = 2000
    })
end)

-- 💀 Revive remoto admin
RegisterNetEvent('md-hospital:client:adminRevive', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    -- Fade out
    DoScreenFadeOut(300)
    Wait(350)
    
    -- Resurrección en lugar actual
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    ClearPedTasksImmediately(ped)
    
    -- Restablecer vida y armadura
    SetEntityHealth(ped, 200)
    SetPedArmour(ped, 0)
    
    -- Limpiar estado de muerte
    isDead = false
    showRespawnKey = false
    lib.hideTextUI()
    
    -- Fade in
    DoScreenFadeIn(300)
    
    lib.notify({
        title = '✅ Revivido',
        description = 'Has sido revivido por un administrador.',
        type = 'success',
        duration = 3000
    })
end)