-- Resource Metadata
fx_version 'bodacious'
games { 'gta5' }

author 'kac5a'
description 'BikeRental'
version '1.0.0'

client_scripts {
    'config.lua',
    'locale.lua',
    'data/**/*.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'locale.lua',
    'data/**/*.lua',
    'server.lua'
}

ui_page "html/index.html"

files({
    'html/**'
})

dependencies {
    'es_extended',
    'esx_addonaccount',
}