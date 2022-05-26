# K5 Shops

![K5 Shops](https://forum.cfx.re/uploads/default/original/4X/d/e/9/de939b927f894f9fab398149d0e9c0f624030488.jpeg)

This is a **free** and **open** Fivem script that uses ESX Framework. The goal of this script is to implement different type of shops on your server, that can accepts multiple types of money. These shops can be used as a pawn shop, a store, or as a buyer only.

## Demo

Watch the demo here: [YouTube](https://www.youtube.com/watch?v=9vnCYj48c_c)

## Dependencies

- es_extended
- esx_addonaccount

The script was tested using **ESX Legacy**. I do not guarantee if it works with other versions

# Download & Installation

To use this script, you need to edit the configuration to fit your needs.

**Using Git**

```
cd resources
git clone https://github.com/kac5a/k5_shops.git [scripts]/k5_shops
```

### Manually

- Download [https://github.com/k5scripts/k5_shops](https://github.com/kac5a/k5_shops)
- Put it in your resources directory

### Installation

Add this in your `server.cfg`:

```
ensure k5_shops
```

# Documentation

## Configuration

In the included config.lua, you will find 3 predefined shops that help you move around. Feel free to delete these shops and add your own.

### Shops

| Key         | Definition                                                                                                  |
| ----------- | ----------------------------------------------------------------------------------------------------------- |
| shopName    | **(string)** This is the display name of the shop                                                           |
| coords      | **(vector3)** These are the coordinates of the shop itself                                                  |
| sellJob     | **(string[])** The name of the jobs that can access the shop's sell tab (can be multiple jobs in a table)   |
| sellOnly    | **(boolean)** If true, the shop will only sell items. It is recommended to use with `infinite = true`       |
| infinite    | **(boolean)** If true, the shop ignores the storage and will sell and buy infinite amount of items          |
| blip        | **(table)** This is the definition of the shop blip. Set this as `nil` if you don't want to add a blip      |
|             | _color_: **(number)** The color of the blip                                                                 |
|             | _sprite_: **(number)** The sprite of the blip                                                               |
|             | _scale_: **(number)** The scale of the blip                                                                 |
| cashierPed  | **(table)** This is the definition of the cashier Ped. Set this as `nil` if you don't want to add a cashier |
|             | _ped_: **(string)** Ped model Id                                                                            |
|             | _coords_: **(vector3)** These are the coordinates of the cashier Ped                                        |
|             | _heading_: **(number)** This is the heading of the cashier Ped                                              |
| paymentType | **(number)** This is the payment type selector for the shop                                                 |
| items       | **(table)** This is the table for the shop items. See below                                                 |

### Items

| Key       | Definition                                                                                                       |
| --------- | ---------------------------------------------------------------------------------------------------------------- |
| label     | **(string)** The display name of the item                                                                        |
| buyPrice  | **(number)** The amount of money players can buy from this shop. If `nil`, the item won't show up in the buy page |
| maxCount  | **(number)** Maximum amount of items the shop can store. Ignored if `infinite=true` in the shop's definition.   |
| sellPrice | **(number)** The amount of money players can sell to this shop. If `nil`, the item won't show up in the sell page  |

## Usage

This script doesn't use an SQL database, instead it uses json files for each shop. these can be found under the
`data/` folder. This is how a data json looks like:

` { "gold": { "count": 5.0 }, "lighter": { "count": 17 }, "phone": { "count": 11 }, "vape": { "count": 30 } }`

You can edit this data even if the script runs on your server. Make sure the shop is not accessed by any players before editing these files. This data is only accessed if a player opens a shop.

### Images

Images are stored in `html/img`

Each shop has a logo at the top left corner. This image has to be PNG and has to have the same name as the key of every shop.
![Config and logo image relation](https://i.imgur.com/cwbSH0F.png)

The products has to have the same name as the key of the items in the items table. These images have to be PNG.
![Config and image relation](https://i.imgur.com/8xxX7VQ.png)

# Last Words

Feel free to fork this repository and edit the script as much as you'd like. It would be appreciated if someone would edit this to work with other frameworks aswell. This is my first public script. It was needed on a server I'm working on. Have fun!
