fx_version 'adamant'

game 'gta5'

description 'admin duty by 6osvillamos Edited by Pandascripts'

version '1.2.3'
lua54 'yes'

ui_page 'html/index.html'

files {
	"icons/*.png",
	"html/**"
}

shared_scripts {
	'@es_extended/imports.lua',
	'config/shared.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'@ox_lib/init.lua'
}

server_scripts {
	'config/server.lua',
	'server.lua'
}

client_scripts {
	'client.lua'
}

dependencies {
	'ox_lib',
	'fl_spectate',
	'es_extended'
}
