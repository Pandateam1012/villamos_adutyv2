Config.DiscordTags = false
Config.GuildId = ""
Config.BotToken = "" --NE RAKD ELÉ A Bot szót!!!!! csak a token amit kimásolsz!!
Config.DiscordTimeOut = 1500

Config.Webhook = ''

Config.Notify = function(src, msg)
    if Config.NotTypeSV == "ox" then
        Notifyox(src,{title = "Rendzser", description = msg, icon = "info", iconAnimation = "beat", type = "success", duration = 4000})
    elseif Config.NotTypeSV == "esx" then
        TriggerClientEvent("esx:showNotification", src, msg)
    end
end 

function Notifyox(id, data)
    TriggerClientEvent("ox_lib:notify", id, data)
end