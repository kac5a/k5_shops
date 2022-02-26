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
			itemsWithInventoryCount[k].inventoryCount = xPlayer.getInventoryItem(k).count
			if shopItemCount[k] ~= nil then
				itemsWithInventoryCount[k].count = shopItemCount[k].count
			else
				itemsWithInventoryCount[k].count = 0
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
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local cantCarry = false
	local shopItemCount = loadShop(data.shopName)

	for k, v in pairs(data.payData) do
		if xPlayer.canCarryItem(v.name, v.amount) then
			xPlayer.removeAccountMoney(account, v.amount * v.price)
			xPlayer.addInventoryItem(v.name, v.amount)
			shopItemCount[v.name].count = shopItemCount[v.name].count - v.amount
		else
			cantCarry = true
		end
	end

	saveShop(data.shopName, shopItemCount)

	if cantCarry then notifySv(playerId, Config.Locales[Config.Locale].CantCarry) end

	TriggerClientEvent('k5_shops:closeUI', playerId)
end)

RegisterServerEvent("k5_shops:sellItems")
AddEventHandler("k5_shops:sellItems", function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cantCarry = false
	local shopItemCount = loadShop(data.shopName)
	local account = nil

	if Config.Shops[data.shopName].sellJob == nil or (xPlayer.job and xPlayer.job.name == Config.Shops[data.shopName].sellJob) then
		if data.paymentType == 1 then
			account = "money"
		elseif data.paymentType == 2 then
			account = "bank"
		elseif data.paymentType == 3 then
			account = "black_money"
		end
		if Config.Shops[data.shopName].sellJob == nil then 
			for k, v in pairs(data.payData) do
				xPlayer.removeInventoryItem(v.name, v.amount)
				xPlayer.addAccountMoney(account, v.amount * v.price)
				shopItemCount[v.name].count = shopItemCount[v.name].count + v.amount
			end
		elseif xPlayer.job.name == Config.Shops[data.shopName].sellJob then
			TriggerEvent("esx_addonaccount:getSharedAccount", "society_"..Config.Shops[data.shopName].sellJob, function(account)
				if account ~= nil then
					for k, v in pairs(data.payData) do
						xPlayer.removeInventoryItem(v.name, v.amount)
						account.addMoney(v.amount * v.price)
						shopItemCount[v.name].count = shopItemCount[v.name].count + v.amount
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
end)

RegisterServerEvent("k5_shops:lockShop")
AddEventHandler("k5_shops:lockShop", function(shopName)
	Config.Shops[shopName].locked = source
end)

RegisterServerEvent("k5_shops:unlockShop")
AddEventHandler("k5_shops:unlockShop", function(shopName)
	Config.Shops[shopName].locked = nil
end)