local QBCore = exports['qb-core']:GetCoreObject()

local spawnedNPCs = {}

local function LoadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    RequestModel(hash)
    
    while not HasModelLoaded(hash) do Wait(0) end
    
    return hash
end

local function SpawnParamedic(hospitalId, data)
    local hash = LoadModel(data.model)
    local ped = CreatePed(4, hash, data.pos.x, data.pos.y, data.pos.z, data.pos.w, false, true)
    
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    
    exports.ox_target:addLocalEntity(ped, {
        {
            name = ('md_paramedic_%s'):format(hospitalId),
            icon = 'fa-solid fa-user-doctor',
            label = '🏥 Pedir reanimación',
            distance = 2.0,
            onSelect = function()
                TriggerServerEvent('md-hospital:server:npcReviveRequest', hospitalId)
            end,
        }
    })
    
    spawnedNPCs[#spawnedNPCs+1] = ped
    print('^2[MD-Hospital]^7 Paramédico spawneado en: ' .. hospitalId)
end

local function AddBedTargets(hospitalId, respawnList)
    for idx, bed in ipairs(respawnList or {}) do
        local coords = vector3(bed.bedPoint.x, bed.bedPoint.y, bed.bedPoint.z)
        
        local bedLabel = (bed.bedType == 'heal') and '🏥 Usar cama (curar)' or '💀 Usar cama (revivir)'
        
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.4,
            debug = false,
            options = {
                {
                    name = ('md_bed_%s_%s'):format(hospitalId, idx),
                    icon = 'fa-solid fa-bed',
                    label = bedLabel,
                    distance = 1.6,
                    onSelect = function()
                        TriggerServerEvent('md-hospital:server:useBed', hospitalId, idx)
                    end,
                }
            }
        })
    end
end

local function AddPharmacyTargets(hospitalId, pharmacyTable)
    for shopId, shop in pairs(pharmacyTable or {}) do
        exports.ox_target:addSphereZone({
            coords = shop.pos,
            radius = 1.6,
            debug = false,
            options = {
                {
                    name = ('md_pharmacy_%s_%s'):format(hospitalId, shopId),
                    icon = 'fa-solid fa-prescription-bottle-medical',
                    label = '💊 ' .. (shop.label or 'Pharmacy'),
                    distance = 2.0,
                    onSelect = function()
                        TriggerServerEvent('md-hospital:server:openPharmacy', hospitalId, shopId)
                    end,
                }
            }
        })
    end
end

local function AddStashTargets(hospitalId, stashTable)
    for stashId, stash in pairs(stashTable or {}) do
        exports.ox_target:addSphereZone({
            coords = stash.pos,
            radius = 1.6,
            debug = false,
            options = {
                {
                    name = ('md_stash_%s_%s'):format(hospitalId, stashId),
                    icon = 'fa-solid fa-box-open',
                    label = '📦 ' .. (stash.label or 'Stash'),
                    distance = 2.0,
                    onSelect = function()
                        TriggerServerEvent('md-hospital:server:openStash', hospitalId, stashId)
                    end,
                }
            }
        })
    end
end

local function AddBossMenuTargets(hospitalId, bossmenu)
    if not bossmenu or not bossmenu.pos then return end
    
    exports.ox_target:addSphereZone({
        coords = bossmenu.pos,
        radius = 1.6,
        debug = false,
        options = {
            {
                name = ('md_bossmenu_%s'):format(hospitalId),
                icon = 'fa-solid fa-briefcase',
                label = '👔 Boss Menu',
                distance = 2.0,
                onSelect = function()
                    TriggerServerEvent('md-hospital:server:openBossMenu', hospitalId)
                end,
            }
        }
    })
end

local function AddGarageTargets(hospitalId, garageTable)
    for garageId, garage in pairs(garageTable or {}) do
        exports.ox_target:addSphereZone({
            coords = vector3(garage.pedPos.x, garage.pedPos.y, garage.pedPos.z),
            radius = 2.0,
            debug = false,
            options = {
                {
                    name = ('md_garage_%s_%s'):format(hospitalId, garageId),
                    icon = 'fa-solid fa-car',
                    label = '🚑 Garaje EMS',
                    distance = 2.5,
                    onSelect = function()
                        TriggerServerEvent('md-hospital:server:openGarage', hospitalId, garageId)
                    end,
                }
            }
        })
    end
end

-- Inicializar todos los targets cuando la resource inicie
CreateThread(function()
    Wait(1500)
    
    print('^2[MD-Hospital]^7 Inicializando targets de hospitalidad...')
    
    for hospitalId, hospital in pairs(Config.Hospitals) do
        if hospital.paramedic then
            SpawnParamedic(hospitalId, hospital.paramedic)
        end
        
        AddBedTargets(hospitalId, hospital.respawn)
        AddPharmacyTargets(hospitalId, hospital.pharmacy)
        AddStashTargets(hospitalId, hospital.stash)
        AddBossMenuTargets(hospitalId, hospital.bossmenu)
        AddGarageTargets(hospitalId, hospital.garage)
    end
    
    print('^2[MD-Hospital]^7 ✅ Todos los targets inicializados correctamente')
end)