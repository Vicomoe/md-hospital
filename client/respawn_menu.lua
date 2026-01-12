-- MENÚS ADICIONALES OX_LIB (OPCIONAL)
local lib = exports.ox_lib

-- 🏪 TIENDA MÉDICOS
RegisterNetEvent('md-hospital:client:openShop', function()
    local options = {}
    
    for _, item in pairs(Config.MedicalItems or {}) do
        table.insert(options, {
            title = item.label,
            description = ('💰 $%d'):format(item.price),
            icon = 'pills',
            onSelect = function()
                TriggerServerEvent('md-hospital:server:buyItem', item.name)
                lib.notify({
                    title = '✅ Compra realizada',
                    description = ('Has comprado %s'):format(item.label),
                    type = 'success',
                    duration = 2000
                })
            end
        })
    end
    
    lib.registerContext({
        id = 'hospital_shop',
        title = '🛒 Tienda Médica',
        options = options
    })
    
    lib.showContext('hospital_shop')
    
    print('^2[MD-Hospital]^7 Tienda médica abierta con ' .. #options .. ' items')
end)