Config = {}

Config.Locale = "hu" -- en, hu

Config.Commands = true

Config.ChatLogs = true -- true/false Chatre való logolás (Minden ami a panelhez kapcsolódó aztat logolni fogja!) (A PLAYEREK MINDIG TUDJÁK HASZNÁLNI A /adlog PARANCSOT!)
                        -- EZ CSAK AZT TUDJA HOGY ALAPBÓL KI/BE KAPCSOLJA A CHATRE LOGOLÁST
Config.Notifye = "ox" -- esx, ox, okok, codem

Config.Icons = {
    "marvel"
}



Config.Perms = {
    "admin",
    "owner"
}

Config.Admins = { --a pedet vagy a logót vagy a ruhát ha nem szeretnéd használni állítsd falsera
["admin"] = { tag = "[ADMIN]", logo = false, ped = false, color = { r = 162, g = 0, b = 0 }},
["admin2"] = { tag = "[ADMIN 2]", logo = false, ped = false, color = { r = 162, g = 0, b = 0 }},
["owner"] = { tag = "[ADMIN]", logo = "marvel", ped = "mp_f_freemode_01", color = { r = 162, g = 0, b = 0 }},
}

Config.Clothes = {
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

    ["admin1"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 1, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 1,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 1,
            ['shoes_1'] = 55, ['shoes_2'] = 1,
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

    ["admin2"] = {
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
            ['torso_1'] = 180, ['torso_2'] = 5,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 14,
            ['pants_1'] = 79, ['pants_2'] = 5,
            ['shoes_1'] = 58, ['shoes_2'] = 5,
        }
    },

    ["admin3"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 3, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 3,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 3,
            ['shoes_1'] = 55, ['shoes_2'] = 3,
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

    ["admin4"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 4, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 4,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 4,
            ['shoes_1'] = 55, ['shoes_2'] = 4,
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

    ["admin5"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 5, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 5,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 5,
            ['shoes_1'] = 55, ['shoes_2'] = 5,
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

    ["admin6"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 6, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 6,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 6,
            ['shoes_1'] = 55, ['shoes_2'] = 6,
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

    ["admin7"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 7, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 7,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 7,
            ['shoes_1'] = 55, ['shoes_2'] = 7,
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

    ["admin8"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 8, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 8,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 8,
            ['shoes_1'] = 55, ['shoes_2'] = 8,
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

    ["admin9"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 9, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 9,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 9,
            ['shoes_1'] = 55, ['shoes_2'] = 9,
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

    ["admin10"] = {
        male = {
            ['helmet_1'] = 91, ['helmet_2'] = 10, 
            ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
            ['torso_1'] = 178, ['torso_2'] = 10,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 77, ['pants_2'] = 10,
            ['shoes_1'] = 55, ['shoes_2'] = 10,
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
