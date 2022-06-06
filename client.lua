ESX = nil

local openShop = nil
local loadedPeds = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        ESX.PlayerData = ESX.GetPlayerData()
		Citizen.Wait(0)
	end

    while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPos = GetEntityCoords(PlayerPedId())

        for k, v in pairs(Config.Shops) do
            local distance = #(v.coords - playerPos)
            if distance < 2.0 then
                sleep = 1
                DrawText3D(v.coords[1], v.coords[2], v.coords[3]," ~w~[~b~E~w~] "..v.shopName)
                if IsControlJustReleased(0, 38) then
                    local userJob = ESX.PlayerData.job.name
                    local isInJobs = false
                    
                    if v.sellJob ~= nil then
                        for k, v in pairs(v.sellJob) do
                            if v == userJob then
                                isInJobs = true
                            end
                        end
                    end

                    if v.sellOnly and v.sellJob ~= nil and not isInJobs then
                        ESX.ShowNotification(Config.Locales[Config.Locale].IncorrectJob)
                    else
                        ESX.TriggerServerCallback('k5_shops:getInitalData', function(open, shopData, itemsWithInventoryCount, playerJob)
                            if open then
                                local shopData = v
                                shopData.items = itemsWithInventoryCount
                                shopData.playerJob = playerJob
                                shopData.shopId = k
                                openShop = k
                                TriggerServerEvent("k5_shops:lockShop", openShop)
                                SetNuiFocus(true, true)
                                SendNUIMessage({
                                    action = "open",
                                    data = shopData
                                })
                            else
                                ESX.ShowNotification(Config.Locales[Config.Locale].AlreadyOpen)
                            end
                        end, k)
                    end
                end
            end

            if distance > 2.0 and openShop == k then
                closeUI()
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Shops) do
        if v.blip then
            local blip = AddBlipForCoord(v.coords)

            SetBlipSprite(blip, v.blip.sprite)
            SetBlipScale(blip, v.blip.scale)
            SetBlipColour(blip, v.blip.color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.shopName)
            EndTextCommandSetBlipName(blip)
        end

        if v.cashierPed then
            SpawnPed(v.cashierPed)
        end
    end
end)

function SpawnPed(data)
    RequestModel(data.ped)
    while not HasModelLoaded(data.ped)  do
        Wait(100)
    end
    
    local ped = CreatePed(1, data.ped, data.coords[1], data.coords[2], data.coords[3], data.heading, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedCanBeTargetted(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
  
    table.insert(loadedPeds, ped)
end

RegisterNetEvent('k5_shops:resetUI')
AddEventHandler('k5_shops:resetUI', function(shopName)
    ESX.TriggerServerCallback('k5_shops:getInitalData', function(shopData, itemsWithInventoryCount, playerJob)
        local shopData = Config.Shops[shopName]
        shopData.items = itemsWithInventoryCount
        shopData.playerJob = playerJob
        shopData.shopId = shopName
        SendNUIMessage({
            action = "reset",
            data = shopData
        })
    end, shopName)
end)

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		closeUI()
    elseif data.action == "buyItems" then
        TriggerServerEvent("k5_shops:checkMoney", data.data)
    elseif data.action == "sellItems" then
        TriggerServerEvent("k5_shops:sellItems", data.data)
    end
end)

function closeUI()
    SendNUIMessage({
        action = "close"
    })
    SetNuiFocus(false, false)
    TriggerServerEvent("k5_shops:unlockShop", openShop)
    openShop = nil
end

RegisterNetEvent('k5_shops:closeUI')
AddEventHandler('k5_shops:closeUI', function()
    closeUI()
end)

function DrawText3D(x, y, z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.002+ factor, 0.03, 0, 0, 0, 200)
end