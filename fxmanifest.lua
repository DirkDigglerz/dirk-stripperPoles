 
fx_version 'cerulean' 
lua54 'yes' 
games { 'rdr3', 'gta5' } 
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.' 
author 'DirkScripts' 
description 'Stripper Pole System (CUSTOM)' 
version '1.0.0' 
 
shared_script{ 
  '@ox_lib/init.lua',
  'usersettings/config.lua', 
  'usersettings/labels.lua', 
  'src/shared/utils.lua', 
} 
 
client_script { 
  'src/client/init.lua', 
  'src/client/modules/*.lua', 
} 
 
server_script { 
  'src/server/init.lua', 
  'src/server/modules/*.lua', 
} 
 
dependencies { 
  'dirk-core', 
} 
 
escrow_ignore{ 
  'usersettings/*.*', 
  'src/client/modules/open_functions.lua', 
  'src/server/modules/open_functions.lua', 
  'src/shared/modules/open_functions.lua', 
} 
 
 
