Config.DiscordTags = false
Config.GuildId = ""
Config.BotToken = "" --NE RAKD ELÉ A Bot szót!!!!! csak a token amit kimásolsz!!
Config.DiscordTimeOut = 1500

Config.Webhook = false

Config.Notify = function(src, msg)
    if Config.Notifye == "esx" then
        TriggerClientEvent("esx:showNotification", src, msg)
    elseif Config.Notifye == "ox" then
        TriggerClientEvent('ox_lib:notify', src, {
            id = 'admin_notification',
            title = 'Admin Rendszer',
            description = msg,
            type = 'inform',
            position = 'top',
            duration = 5000,
            style = {
                backgroundColor = '#16213e',
                color = '#f8f9fa',
                borderRadius = '12px',
                boxShadow = '0 4px 20px rgba(0, 0, 0, 0.3)',
                padding = '18px',
                minWidth = '320px',
                maxWidth = '420px',
                ['.title'] = {
                    fontSize = '17px',
                    fontWeight = '600',
                    marginBottom = '10px',
                    color = '#4cc9f0',
                    textShadow = '0 1px 2px rgba(0,0,0,0.3)'
                },
                ['.description'] = {
                    fontSize = '14px',
                    color = 'rgba(248, 249, 250, 0.9)',
                    lineHeight = '1.5',
                    textShadow = '0 1px 1px rgba(0,0,0,0.2)'
                }
            },
            icon = 'shield-halved',
            iconColor = '#4cc9f0',
            iconAnimation = 'beatFade',
            showDuration = false
        })
    elseif Config.Notifye == "codem" then
        TriggerClientEvent('codem-notification:Create', src, msg, 'info', 'Admin Rendszer', 5000)
    elseif Config.Notifye == "okok" then
        TriggerClientEvent('okokNotify:Alert', src, 'Admin Rendszer', msg, 5000, 'info', false)
    end
end 