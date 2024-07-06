Config.DiscordTags = false
Config.GuildId = ""
Config.BotToken = "" --NE RAKD ELÉ A Bot szót!!!!! csak a token amit kimásolsz!!
Config.DiscordTimeOut = 1500

Config.Webhook = ''

Config.Notify = function(src, msg)
    TriggerClientEvent("esx:showNotification", src, msg)
end 