ESX = nil

local notifySv = function(source, msg, type)
    TriggerClientEvent("esx:showNotification", source, msg)
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('k5_shops:getInitalData', function(source, cb, shopName)
	if not Config.Shops[shopName].locked or Config.Shops[shopName].locked == source then
		local xPlayer = ESX.GetPlayerFromId(source)
		local shopItemCount = loadShop(shopName)
		local itemsWithInventoryCount = Config.Shops[shopName].items
		for k, v in pairs(itemsWithInventoryCount) do
			if xPlayer.getInventoryItem(k) then
				itemsWithInventoryCount[k].inventoryCount = xPlayer.getInventoryItem(k).count
				if shopItemCount[k] ~= nil then
					itemsWithInventoryCount[k].count = shopItemCount[k].count
				else
					itemsWithInventoryCount[k].count = 0
				end
			else
				print("^8ERROR: ^7This item is not registered in your inventory: ^3"..k.."^7")
			end
		end
		cb(true, Config.Shops[shopName], itemsWithInventoryCount, xPlayer.job.name)
	else
		cb(false)
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	for k, v in pairs(Config.Shops) do
		if v.locked == source then
			Config.Shops[k].locked = nil
		end
	end
end)


function loadShop(shopName)
	local shopCountData = {}
	local loadFile = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data/"..shopName..".json"))
	if loadFile == nil then
		for k, v in pairs(Config.Shops[shopName].items) do
			shopCountData[k] = {}
			shopCountData[k].count = 0
		end
		SaveResourceFile(GetCurrentResourceName(), "./data/"..shopName..".json", json.encode(shopCountData), -1)
	else
		shopCountData = loadFile
		for k, v in pairs(Config.Shops[shopName].items) do
			if shopCountData[k] == nil then
				shopCountData[k] = {}
				shopCountData[k].count = 0
			end
		end
	end

	return shopCountData

end

function saveShop(shopName, data)
	SaveResourceFile(GetCurrentResourceName(), "./data/"..shopName..".json", json.encode(data), -1)
end

RegisterServerEvent("k5_shops:checkMoney")
AddEventHandler("k5_shops:checkMoney", function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if data.paymentType == 1 then
		if xPlayer.getAccount('money').money < data.price then
			notifySv(source, Config.Locales[Config.Locale].NotEnoughCash)
			TriggerClientEvent('k5_shops:closeUI', source)
		else
			TriggerEvent("k5_shops:buyItems", source, data, 'money')
		end
	elseif data.paymentType == 2 then
		if xPlayer.getAccount('bank').money <data. price then
			notifySv(source, Config.Locales[Config.Locale].NotEnoughBank)
			TriggerClientEvent('k5_shops:closeUI', source)
		else
			TriggerEvent("k5_shops:buyItems", source, data, 'bank')
		end
	elseif data.paymentType == 3 then
		if xPlayer.getAccount('black_money').money <data. price then
			notifySv(source, Config.Locales[Config.Locale].NotEnoughBlackMoney)
			TriggerClientEvent('k5_shops:closeUI', source)
		else
			TriggerEvent("k5_shops:buyItems", source, data, 'black_money')
		end
	end
end)

RegisterServerEvent("k5_shops:buyItems")
AddEventHandler("k5_shops:buyItems", function(playerId, data, account)
	if not Config.Shops[data.shopName].transaction then
		Config.Shops[data.shopName].transaction = true
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local cantCarry = false
		local shopItemCount = loadShop(data.shopName)

		for k, v in pairs(data.payData) do
			if xPlayer.canCarryItem(v.name, tonumber(v.amount)) then
				xPlayer.removeAccountMoney(account, tonumber(v.amount) * tonumber(v.price))
				xPlayer.addInventoryItem(v.name, tonumber(v.amount))
				shopItemCount[v.name].count = tonumber(shopItemCount[v.name].count) - tonumber(v.amount)
			else
				cantCarry = true
			end
		end

		saveShop(data.shopName, shopItemCount)

		if cantCarry then notifySv(playerId, Config.Locales[Config.Locale].CantCarry) end

		TriggerClientEvent('k5_shops:closeUI', playerId)
	end
end)

RegisterServerEvent("k5_shops:sellItems")
AddEventHandler("k5_shops:sellItems", function(data)
	if not Config.Shops[data.shopName].transaction then
		Config.Shops[data.shopName].transaction = true
		local xPlayer = ESX.GetPlayerFromId(source)
		local cantCarry = false
		local shopItemCount = loadShop(data.shopName)
		local account = nil
		local isInJobs = false

		if Config.Shops[data.shopName].sellJob ~= nil then
			for k, v in pairs(Config.Shops[data.shopName].sellJob) do
				if v == xPlayer.job.name then isInJobs = true end
			end
		end

		if Config.Shops[data.shopName].sellJob == nil or isInJobs then
			if data.paymentType == 1 then
				account = "money"
			elseif data.paymentType == 2 then
				account = "bank"
			elseif data.paymentType == 3 then
				account = "black_money"
			end
			if Config.Shops[data.shopName].sellJob == nil then 
				for k, v in pairs(data.payData) do
					xPlayer.removeInventoryItem(v.name, tonumber(v.amount))
					xPlayer.addAccountMoney(account, tonumber(v.amount) * tonumber(v.price))
					shopItemCount[v.name].count = tonumber(shopItemCount[v.name].count) + tonumber(v.amount)
				end
			elseif isInJobs then
				TriggerEvent("esx_addonaccount:getSharedAccount", "society_"..xPlayer.job.name, function(account)
					if account ~= nil then
						for k, v in pairs(data.payData) do
							xPlayer.removeInventoryItem(v.name, tonumber(v.amount))
							account.addMoney(tonumber(v.amount) * tonumber(v.price))
							shopItemCount[v.name].count = tonumber(shopItemCount[v.name].count) + tonumber(v.amount)
						end
					end
				end)
			end

			saveShop(data.shopName, shopItemCount)

			TriggerClientEvent('k5_shops:closeUI', source)
		else
			TriggerClientEvent('k5_shops:closeUI', source)
			notifySv(source, Config.Locales[Config.Locale].IncorrectJob)
		end
	end
end)

RegisterServerEvent("k5_shops:lockShop")
AddEventHandler("k5_shops:lockShop", function(shopName)
	Config.Shops[shopName].locked = source
end)

RegisterServerEvent("k5_shops:unlockShop")
AddEventHandler("k5_shops:unlockShop", function(shopName)
	Config.Shops[shopName].locked = nil
	Config.Shops[shopName].transaction = nil
end)