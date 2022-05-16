-- DON'T TOUCH THESE --
Config = {}
Config.Shops = {}
Config.Locales = {}
-----------------------

Config.Locale = 'en' --Language option. Edit the locale.lua file to add more, or translate the texts


Config.Shops = {
    ['pawnshop'] = { -- Shop ID. The shop logo has to have the same name as PNG.
        shopName = "Pawn Shop", -- Shop label
        coords = vector3(412.65530395508, 314.03158569336, 103.02070617676), -- Location of the 3D text
        blip = {
            color = 12, -- Blip color
            sprite = 280, -- Blip sprite
            scale = 1.0 -- Blip sclae
        },
        cashierPed = {
            ped = 'cs_jimmyboston', -- Ped model of the cashier. If you don't want a ped, just delete this table, or set 'cashierPed = nil'
            coords = vector3(412.53118896484, 314.32400512695, 102.02098083496), -- Coordinates of the Ped
            heading =  205.25927734375 -- Heading of the ped
        },
        paymentType = 1, -- What account do you want the shop to use? (players will pay/receive this type of money when they buy/sell)
                            --1 = cash 
                            --2 = bank 
                            --3 = black money
        items = {
            -------------------------------------------------------------
            -- MAKE SURE EACH ITEM IS REGISTERED IN YOUR INVENTORY SYSTEM,
            -- OTHERWISE THE SCRIPT WON'T WORK PROPERLY !!
            -------------------------------------------------------------

            ['lighter'] = {        -- Unique identifier of the product. This is the item id that you use in your database for the items. Images has to have the same name as this id.
                label = "Lighter", -- Item label
                buyPrice = 600,    -- The price players can buy this item.
                maxCount = 150,    -- Maximum amount the shop can store. If infinite=true, this number is ignored.
                sellPrice = 200,   -- The price players can sell this item to the shop
            },
            ['vape'] = {
                label = "Vape",
                buyPrice = 400,
                maxCount = 100,
                sellPrice = 100,
            },
            ['phone'] = {
                label = "Phone",
                buyPrice = nil, -- If nil, the item won't show up in the buy page.
                maxCount = 50,
                sellPrice = 100,
            },
            ['gold'] = {
                label = "Gold",
                buyPrice = 1200,
                maxCount = 50,
                sellPrice = 2000,
            },
            
        }
    },
    ['burgershot'] = {
        shopName = "BurgerShot",
        sellJob = {'police'}, -- The name of the jobs that can access this shop's sell option. Money goes to the society
        coords = vector3(-1198.8856201172, -882.81433105469, 13.348832130432),
        blip = {
            color = 75,
            sprite = 103,
            scale = 1.0
        },
        cashierPed = {
            ped = 'csb_burgerdrug',
            coords = vector3(-1198.7757568359, -882.98065185547, 12.349102020264),
            heading = 34.899082183838
        },
        paymentType = 1,
        items = {
            ['sandwich'] = {
                label = "Sandwich",
                buyPrice = 200,
                maxCount = 50,
                sellPrice = 150,
            },
            ['cola'] = {
                label = "Cola",
                buyPrice = 50,
                maxCount = 50,
                sellPrice = 10,
            },
        }
    },
    ['dealer'] = {
        paymentType = 3,
        sellOnly = true, -- If true, the shop doesn't have a buy tab.
        infinite = true, -- If true, the stop doesn't keep track of the storage, palyers can sell and buy as many items as they want.
        coords = vector3(420.7734375, -2064.4226074219, 22.116249084473),
        shopName = "Drug Dealer",
        items = {
            ['joint'] = {
                label = "Joint",
                buyPrice = 20,
                maxCount = 50,
                sellPrice = 150,
            },
            ['coke'] = {
                label = "Cocaine",
                buyPrice = 1000,
                maxCount = 50,
                sellPrice = 10,
            },
            ['meth'] = {
                label = "Meth",
                buyPrice = 600,
                maxCount = 50,
                sellPrice = 10,
            },
        }
    }
}