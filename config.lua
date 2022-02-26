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
            ['lighter'] = {        -- Unique identifier of the product. This is the item id that you use in your database for the items. Images has to have the same name as this id.
                label = "Lighter", -- Item label
                buyPrice = 600,    -- The price players can buy this item
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
                buyPrice = 500,
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
        sellJob = 'burgershot', -- The name of the job that can access this shop's sell option. Money goes to the society
        coords = vector3(-1195.2030029297, -892.11022949219, 13.995241165161),
        blip = {
            color = 75,
            sprite = 103,
            scale = 1.0
        },
        cashierPed = {
            ped = 'csb_burgerdrug',
            coords = vector3(-1196.0991210938, -892.66174316406, 12.995241165161),
            heading = 309.31665039063
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
        coords = vector3(420.20349121094, -2063.9948730469, 22.132051467896 ),
        shopName = "Drug Dealer",
        items = {
            ['joint'] = {
                label = "Joint",
                buyPrice = 20,
                maxCount = 50,
                sellPrice = 150,
            },
            ['coke2'] = {
                label = "Cocain",
                buyPrice = 1000,
                maxCount = 50,
                sellPrice = 10,
            },
            ['meth2'] = {
                label = "Meth",
                buyPrice = 600,
                maxCount = 50,
                sellPrice = 10,
            },
        }
    }
}