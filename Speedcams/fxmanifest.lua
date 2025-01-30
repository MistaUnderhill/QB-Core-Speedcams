fx_version 'cerulean'
game 'gta5'

author 'MistaUnderhill'

dependencies {
    'critLobby',
    'oxmysql',
    'qb-core'
}

client_scripts {
    'client/cl_speedtrap_scaleform.lua',
    'client/cl_speedtrap_handle.lua',
    'client/cl_speedtrap_menu.lua',
}

server_scripts {
    'server/sv_speedtrap_handle.lua'
}