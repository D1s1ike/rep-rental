local blips = {}
currentRental = 0
local npcs = {}

local function notify(message, notifyType, duration)
    if Framework.Notification then
        Framework.Notification(message, notifyType, duration)
        return
    end

    lib.notify({
        description = message,
        type = notifyType or 'inform',
        duration = duration,
    })
end

local function spawnVeh(_data, _id)
    local location = Config.Locations[_id]
    if not location then
        return false
    end

    _data.coords = location.spawnpoint
    if IsAnyVehicleNearPoint(_data.coords.x, _data.coords.y, _data.coords.z, 2.0) then
        notify(Lang.error.obstacle.label, Lang.error.obstacle.type, Lang.error.obstacle.time)
        return false
    end
    local netID = lib.callback.await("rep-rental:callback:spawnVeh", false, _data)
    if not netID then
        return false
    end
    while not NetworkDoesNetworkIdExist(netID) do
        Wait(100)
    end
    local car = NetToVeh(netID)
    while not DoesEntityExist(car) do
        Wait(100)
        car = NetToVeh(netID)
    end
    local vehPlate = 'RENT'..lib.string.random('.')..lib.string.random('.')..lib.string.random('.')..lib.string.random('.')
    SetVehicleNumberPlateText(car, vehPlate)
    SetVehicleEngineOn(car, true, true)
    SetVehicleDirtLevel(car, 0.0)
    SetVehRadioStation(car, 'OFF')
    exports['rcore_fuel']:SetFuel(car, 100)
    local r1, g1, b1 = _data.color:match("rgb%((%d+), (%d+), (%d+)%)")
    SetVehicleCustomPrimaryColour(car, tonumber(r1), tonumber(g1), tonumber(b1))
    Wait(100)
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', vehPlate)
    TriggerEvent('qb-vehiclekeys:client:AddKeys', vehPlate)
    TaskWarpPedIntoVehicle(cache.ped, car, -1)
    TriggerServerEvent("rep-rental:server:giveRentalPaper", vehPlate, Framework.getVehName(_data.model))
    return true
end

local function openMenu(_index)
    Framework.openMenu(_index)
end

exports("openMenu", openMenu)

CreateThread(function()
    for _, info in pairs(Config.Locations) do
        if info.blip then
            blips[_] = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
            SetBlipSprite(blips[_], info.blip.sprite)
            SetBlipDisplay(blips[_], 4)
            SetBlipScale(blips[_], 0.6)
            SetBlipColour(blips[_], info.blip.colour)
            SetBlipAsShortRange(blips[_], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.blip.label)
            EndTextCommandSetBlipName(blips[_])
        end
        if info.ped then
            local model = lib.requestModel(info.ped.hash)
            local ped = CreatePed(0, model, info.coords.x, info.coords.y, info.coords.z, info.coords.w, false, true)
            PlaceObjectOnGroundProperly(ped)
            SetEntityHeading(ped, info.coords.w)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
            npcs[#npcs + 1] = ped

            local locationIndex = _
            exports.ox_target:addLocalEntity(ped, {
                {
                    label = Lang.npc.button1.label,
                    icon = 'fas fa-car',
                    onSelect = function()
                        Framework.openMenu(locationIndex)
                    end
                },
                {
                    label = Lang.npc.button3.label,
                    icon = 'fas fa-undo',
                    onSelect = function()
                        TriggerServerEvent('rep-rental:server:returnVehicle')
                    end
                },
            })
        end
    end
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    currentRental = 0
    cb({ ok = true })
end)

RegisterNUICallback('setLocale', function(_, cb)
    cb(Lang)
end)

RegisterNUICallback('rent', function(data, cb)
    local id = currentRental
    if not id or not Config.Locations[id] then
        cb({ ok = false })
        return
    end

    cb({ ok = true })

    if Config.DriverLicense[data.type] then
        local hasLicense = lib.callback.await('rep-rental:callback:checkLicense', false, Config.DriverLicense[data.type])
        if hasLicense then
            spawnVeh(data, id)
        else
            notify(Lang.error.license.label, Lang.error.license.type, Lang.error.license.time)
        end
    else
        spawnVeh(data, id)
    end
end)

RegisterNUICallback('init', function(_, cb)
    cb(1)
    SendNUIMessage({
        action = 'loadLocales',
        data = {}
    })
    SendNUIMessage({
        action = 'setLocale',
        data = Lang
    })
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    for _, ped in pairs(npcs) do
        DeleteEntity(ped)
    end
    for i, v in pairs(blips) do
        RemoveBlip(v)
    end
end)
