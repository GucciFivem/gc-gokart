local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {}
hasCarro = false

function spawncarro()
    local carro = 'veto2'
    RequestModel(carro)
        while not HasModelLoaded(carro) do
            Wait(100)
        end

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        local vehicle = CreateVehicle(carro, coords.x - 1 , coords.y + 0.75, coords.z, GetEntityHeading(ped), true, false)
        SetPedIntoVehicle(ped, vehicle, -1)
        SetVehicleNumberPlateText(vehicle, "VETO")
        SetVehicleColours(vehicle, 0, 0)
        SetVehicleEnginePowerMultiplier(vehicle, 50.0)
        exports['lj-fuel']:SetFuel(vehicle, 100.0)
        QBCore.Functions.Notify('Go-kart rented', 'success', 4000)
        hasCarro = true
end -- spawncarro

CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = Config.PedModel,
        coords = vector4(1991.59, 3778.53, 31.18, 118.03), 
        minusOne = false, 
        freeze = true, 
        invincible = true, 
        blockevents = true,
        target = { 
            options = {
                {
                    type = 'client',
                    event = 'gc-carro',
                    icon = 'fas fa-car',
                    label = 'Rent a go-kart',
                },
                {
                    type = 'client',
                    event = 'return-carro',
                    icon = 'fas fa-key',
                    label = 'Return the go-kart',
                    
                    canInteract = function()
                        if hasCarro then return true else return false end
                    end
                },
                distance = 1.5
            },
        },
    })
end)

RegisterNetEvent('gc-carro', function()
    spawncarro()
end)

RegisterNetEvent('return-carro', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        hasCarro = false
    end
    QBCore.Functions.Notify('Go-kart returned', 'success', 4000)
end)