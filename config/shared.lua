Config = {}

Config.Locale = "hu" -- en, hu

Config.Commands = true

Config.ChatLogs = true -- true/false Chatre való logolás (Minden ami a panelhez kapcsolódó aztat logolni fogja!) (A PLAYEREK MINDIG TUDJÁK HASZNÁLNI A /adlog PARANCSOT!)
                        -- EZ CSAK AZT TUDJA HOGY ALAPBÓL KI/BE KAPCSOLJA A CHATRE LOGOLÁST
Config.Notifye = "ox" -- esx, ox, okok, codem

Config.AdminZone = {
    blipSprite = 487,
}

Config.Admintext = {
    height = 0.5,
    spin = true,
    bobupandown = true,
    facecamera = true
}

Config.Icons = {
    "marvel"
}

Config.Perms = {
    "admin",
    "owner"
}

local clothes = {
    ["admin"] = { 
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 0, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 0,
            ['shoes_1'] = 55, ['shoes_2'] = 0,
        }, 
        female = {
            ['helmet_1'] = 114, ['helmet_2'] = 24, 
            ['tshirt_1'] = 14, ['tshirt_2'] = 0, 
            ['torso_1'] = 180, ['torso_2'] = 5,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 14,
            ['pants_1'] = 79, ['pants_2'] = 5,
            ['shoes_1'] = 58, ['shoes_2'] = 5,
        } 
    },
    ["owner"] = { 
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 2, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 2,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 2,
            ['shoes_1'] = 55, ['shoes_2'] = 2,
        }, 
        female = {
            ['helmet_1'] = 114, ['helmet_2'] = 24, 
            ['tshirt_1'] = 14, ['tshirt_2'] = 0, 
            ['torso_1'] = 180, ['torso_2'] = 2,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 14,
            ['pants_1'] = 79, ['pants_2'] = 2,
            ['shoes_1'] = 58, ['shoes_2'] = 2,
        } 
    }
}



Config.Admins = { --a pedet vagy a logót vagy a ruhát ha nem szeretnéd használni állítsd falsera
["admin"] = { tag = "Adminisztrátor", logo = false, cloth  = clothes, color = "#dd42f5"}, -- Hex Kód ot is lehet használni!
["admin2"] = { tag = "[ADMIN 2]", logo = false, color = { r = 162, g = 0, b = 0 }},
["owner"] = { tag = "[ADMIN]", logo = "marvel", cloth  = clothes, color = "#005cff"},
}



if not IsDuplicityVersion() then 
    Config.Notify = function(msg)
        if Config.Notifye == "esx" then
            TriggerEvent("esx:showNotification", msg)
        elseif Config.Notifye == "ox" then
            lib.notify({
                title = 'Admin Rendszer',
                description = msg,
                type = 'info'
            })
        elseif Config.Notifye == "codem" then
            TriggerEvent('codem-notification:Create', msg, 'info', 'Admin Rendszer', 5000)
        elseif Config.Notifye == "okok" then
            exports['okokNotify']:Alert('Admin Rendszer', msg, 5000, 'info', false)
        end
    end 
end 
