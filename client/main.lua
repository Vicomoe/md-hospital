local QBCore = exports['qb-core']:GetCoreObject()

local function CreateHospitalBlips()
    for _, hospital in pairs(Config.Hospitals) do
        if hospital.blip and hospital.blip.enable then
            local b = AddBlipForCoord(hospital.blip.pos.x, hospital.blip.pos.y, hospital.blip.pos.z)
            
            SetBlipSprite(b, hospital.blip.type or 61)
            SetBlipScale(b, hospital.blip.scale or 0.7)
            SetBlipColour(b, hospital.blip.color or 2)
            SetBlipAsShortRange(b, true)
            
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(hospital.blip.name or hospital.name or 'Hospital')
            EndTextCommandSetBlipName(b)
            
            print('^2[MD-Hospital]^7 Blip creado para: ' .. (hospital.blip.name or hospital.name or 'Hospital'))
        end
    end
end

-- Crear blips al iniciar
CreateThread(function()
    Wait(1000)
    CreateHospitalBlips()
    print('^2[MD-Hospital]^7 ✅ Sistema de blips inicializado')
end)