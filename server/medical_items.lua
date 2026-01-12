local QBCore = exports['qb-core']:GetCoreObject()

-- Registrar items médicos como usables desde qb-core
-- Además de lo que haga enyo-medical, estos items curarán si se usan directamente

for _, it in ipairs(Config.MedicalItems or {}) do
    QBCore.Functions.CreateUseableItem(it.name, function(source)
        local src = source
        local ped = PlayerPedId()
        
        -- Validar que no esté muerto
        if IsEntityDead(ped) then
            TriggerEvent('origen:notify', {
                title = it.label or it.name,
                description = 'No puedes usar esto mientras estés muerto.',
                icon = 'ban',
                color = 'error'
            })
            return
        end
        
        -- Curación ligera de fallback
        TriggerClientEvent('md-hospital:client:adminHealFull', src)
        TriggerClientEvent('origen:notify', src, {
            title = it.label or it.name,
            description = 'Aplicado correctamente.',
            icon = 'pills',
            color = 'success'
        })
        
        print('^2[MD-Hospital]^7 Jugador ' .. src .. ' ha usado: ' .. it.name)
    end)
end

print('^2[MD-Hospital]^7 ✅ ' .. #Config.MedicalItems .. ' items médicos registrados como usables')