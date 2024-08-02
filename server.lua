local inDuty = {} 
local tags = {}
local dutyTimes = json.decode(LoadResourceFile(GetCurrentResourceName(), "data.json")) or {}

ESX.RegisterServerCallback("villamos_aduty:openPanel", function(source, cb)
    local xAdmin = ESX.GetPlayerFromId(source)
    if not IsAdmin(xAdmin.getGroup()) then return cb(false) end
    local players = {}
    local play = ESX.GetPlayers()
    local test = xAdmin.source
    for i=1, #play do
        local xPlayer = ESX.GetPlayerFromId(play[i])
        
        if xPlayer then 
            players[#players+1] = {
                id = xPlayer.source,
                name = GetPlayerName(xPlayer.source),
                group = xPlayer.getGroup(),
                job = xPlayer.getJob().label
            }
        end
    end

    cb(true, xAdmin.getGroup(), players)
end)

------------------------------------------------------
------------#Logok------------------------------------

function IsAdmin(playerGroup)
    for _, perm in ipairs(Config.Perms) do
        if playerGroup == perm then
            return true
        end
    end
    return false
end


function GetAdmins()
    local admins = {}
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and IsAdmin(xPlayer.getGroup()) then
            table.insert(admins, xPlayer.source)
        end
    end
    return admins
end


function SendLogToAdmins(template, args)
    local admins = GetAdmins()
    for _, adminId in ipairs(admins) do
        TriggerClientEvent('chat:addMessage', adminId, {
            template = template,
            args = args
        })
    end
end

RegisterNetEvent('villamos_aduty:goto', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local admincucc = xPlayer.getGroup()
    local playerId = data.playerId
    if admincucc ~= 'user' then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:lightblue;">Odateleportált </span> ({3}) ({4}) hoz/hez</div>', { xPlayer.getName(), xPlayer.source, playerId.source, playerId.getName() })
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. 'Odateleportált ' .. GetPlayerName(playerId.source), playerId.source .. ' hoz/hez')
    end
end)

RegisterNetEvent('villamos_aduty:bring', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local admincucc = xPlayer.getGroup()
    local playerId = data.playerId
    if admincucc ~= 'user' then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:lightred;">Magához hoszta </span> ({3}) ({4}) játékost</div>', { xPlayer.getName(), xPlayer.source, playerId.source, playerId.getName() })
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. 'Magához hoszta ' .. GetPlayerName(playerId.source), playerId.source .. ' játékost')
    end
end)


RegisterNetEvent('villamos_aduty:togid', function(ids)
    local xPlayer = ESX.GetPlayerFromId(source)
    local admincucc = xPlayer.getGroup()
    if admincucc ~= 'user' then
        if ids == false then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> az ID-ket </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta az ID-ket')
        elseif ids == true then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>az ID-ket </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta az ID-ket')
        end
    end
end)

RegisterNetEvent('villamos_aduty:toggod', function(god)
    local xPlayer = ESX.GetPlayerFromId(source)
    local admincucc = xPlayer.getGroup()
    if admincucc ~= 'user' then
        if god == false then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> a halhatatlanságot </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a halhatatlanságot')
        elseif god == true then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>a halhatatlanságot </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a halhatatlanságot')
        end
    end
end)

RegisterNetEvent('villamos_aduty:togsped', function(speed)
    local xPlayer = ESX.GetPlayerFromId(source)
    local admincucc = xPlayer.getGroup()
    if admincucc ~= 'user' then
        if speed == false then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> a gyorsaságot </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a gyorsaságot')
        elseif speed == true then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>a gyorsaságot </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a gyorsaságot')
        end
    end
end)

RegisterNetEvent('villamos_aduty:toginvisible', function(invisible)
    local xPlayer = ESX.GetPlayerFromId(source)
    local admincucc = xPlayer.getGroup()
    if admincucc ~= 'user' then
        if invisible == false then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> a láthatatlanságot </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a láthatatlanságot')
        elseif invisible == true then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>a láthatatlanságot </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a láthatatlanságot')
        end
    end
end)

RegisterNetEvent('villamos_aduty:tognoragdoll', function(noragdoll)
    local xPlayer = ESX.GetPlayerFromId(source)
    local admincucc = xPlayer.getGroup()
    if admincucc ~= 'user' then
        if noragdoll == false then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> a noragdoll-t </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a noragdoll-t')
        elseif noragdoll == true then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>a noragdoll-t </div>', { xPlayer.getName(), xPlayer.source })
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a noragdoll-t')
        end
    end
end)


------------------------------------------------------
------------#Logok------------------------------------
RegisterNetEvent('villamos_aduty:setDutya', function(enable)
    local xPlayer = ESX.GetPlayerFromId(source)
    if inDuty[xPlayer.source] then 
        TriggerClientEvent("villamos_aduty:setDuty", xPlayer.source, false, inDuty[xPlayer.source].group)
        if tags[xPlayer.source] then 
            tags[xPlayer.source] = nil
            TriggerClientEvent("villamos_aduty:sendData", -1, tags)
        end 
        local dutyMinutes = math.floor((os.time() - inDuty[xPlayer.source].start) / 60)
        inDuty[xPlayer.source] = nil
        Config.Notify(-1, _U("went_offduty", GetPlayerName(xPlayer.source)))

        dutyTimes[xPlayer.identifier] = (dutyTimes[xPlayer.identifier] or 0) + dutyMinutes
        SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(dutyTimes), -1)
        LogToDiscord(GetPlayerName(xPlayer.source), false, FormatMinutes(dutyTimes[xPlayer.identifier] or 0), FormatMinutes(dutyMinutes))
    else 
        local group = Config.DiscordTags and GetDiscordRole(xPlayer.source) or xPlayer.getGroup()

        if not group or not Config.Admins[group] then return Config.Notify(xPlayer.source, _U("cant_duty")) end 

        inDuty[xPlayer.source] = {
            ped = Config.Admins[group].ped,
            tag = { label = Config.Admins[group].tag .. " " .. GetPlayerName(xPlayer.source), color = Config.Admins[group].color, logo = Config.Admins[group].logo },
            group = group,
            start = os.time()
        }
        TriggerClientEvent("villamos_aduty:setDuty", xPlayer.source, true, group)
        Config.Notify(-1, _U("went_onduty", GetPlayerName(xPlayer.source)))

        tags[xPlayer.source] = inDuty[xPlayer.source].tag
        TriggerClientEvent("villamos_aduty:sendData", -1, tags)

        LogToDiscord(GetPlayerName(xPlayer.source), true, FormatMinutes((dutyTimes[xPlayer.identifier] or 0))) 
    end 
end)

AddEventHandler('playerDropped', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not inDuty[xPlayer.source] then return end
    if tags[xPlayer.source] then 
        tags[xPlayer.source] = nil
        TriggerClientEvent("villamos_aduty:sendData", -1, tags)
    end 
    local dutyMinutes = math.floor((os.time() - inDuty[xPlayer.source].start) / 60)
    inDuty[xPlayer.source] = nil
    Config.Notify(-1, _U("went_offduty", GetPlayerName(xPlayer.source)))

    dutyTimes[xPlayer.identifier] = (dutyTimes[xPlayer.identifier] or 0) + dutyMinutes
    SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(dutyTimes), -1)
    LogToDiscord(GetPlayerName(xPlayer.source), false, FormatMinutes(dutyTimes[xPlayer.identifier] or 0), FormatMinutes(dutyMinutes))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    TriggerClientEvent("villamos_aduty:sendData", source, tags)
end)

function LogToDiscord(name, duty, alltime, time)
    if not Config.Webhook then return end 
    local connect = {
        {
            ["color"] = (duty and 27946 or 10616832),
            ["title"] = "**".. name .."**",
            ["description"] = (duty and _U("went_onduty", name) or _U("went_offduty", name)),
            ["fields"] = {
                {
                    ["name"] = _U("alltime"),
                    ["value"] = alltime,
                    ["inline"] = true
                },
                {
                    ["name"] = _U("dutytime"),
                    ["value"] = time or "-",
                    ["inline"] = true
                },
            },
            ["author"] = {
                ["name"] = "Marvel Studios",
                ["url"] = "https://discord.gg/yKnCYAUcp2",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/917181033626087454/954753156821188658/marvel1.png"
            },
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %X").." | villamos_aduty :)",
            },
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end

function logdclog(color, name, message, alltime, time)
    if not Config.Webhook then return end 
    local connect = {
        {
            ["color"] = color, -- ZÜLD: 27946 PIROS: 10616832
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["author"] = {
                ["name"] = "Marvel Studios",
                ["url"] = "https://discord.gg/yKnCYAUcp2",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/917181033626087454/954753156821188658/marvel1.png"
            },
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %X").." | villamos_aduty :)",
            },
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end


function FormatMinutes(m)
    local minutes = m % 60
	local hours = math.floor((m - minutes) / 60)
	return hours.." h "..minutes.." m"
end

function GetPlayerDiscord(src)
    local identifiers = GetPlayerIdentifiers(src)

    for i=1, #identifiers do
        if string.find(identifiers[i], 'discord:') then
            return string.sub(identifiers[i], 9)
        end
    end

    return nil
end
function GetDiscordRole(src)
    local api = Config.DiscordTimeOut
    local discordId = GetPlayerDiscord(src)
    local info

    if not discordId then return nil end 

    PerformHttpRequest("https://discordapp.com/api/guilds/" .. Config.GuildId .. "/members/" .. discordId, function(errorCode, resultData, resultHeaders)
        api = 0
        if not resultData then return end 
        local roles = json.decode(resultData).roles
        for v=1, #roles do 
            for role, _ in pairs(Config.Admins) do
                if roles[v] == role then
                    info = role
                    break
                end
            end
        end
    end, "GET", "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot " .. Config.BotToken})

    while api > 0 do 
        Wait(100)
        api = api - 100
    end 

    return info
end 

exports('GetDutys', function()
    return inDuty
end)

exports('IsInDuty', function(src) 
    return inDuty[src] and true or false
end)
