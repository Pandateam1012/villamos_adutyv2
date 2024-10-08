local inDuty = {} 
local tags = {}
local adminLogStatus = {}

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

RegisterCommand('adlog', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()
    
    if IsAdmin(adminGroup) then

        if adminLogStatus[source] == nil then
            adminLogStatus[source] = true
        end

        adminLogStatus[source] = not adminLogStatus[source]

        local status = adminLogStatus[source] and 'bekapcsolva' or 'kikapcsolva'
        TriggerClientEvent('esx:showNotification', source, 'Admin logok állapota: ' .. status)
    else
        TriggerClientEvent('esx:showNotification', source, 'Nincs jogosultságod ehhez a parancshoz.')
    end
end, false)

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

RegisterNetEvent('villamos_aduty:goto', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()

    if IsAdmin(adminGroup) then
        local targetPlayer = ESX.GetPlayerFromId(targetId)

        if targetPlayer then
            local logEnabled = adminLogStatus[source] ~= false

            if logEnabled then
                local logMessage = '<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:lightblue;">Odateleportált </span> ({2}) ({3}) hoz/hez</div>'
                SendLogToAdmins(logMessage, { xPlayer.getName(), xPlayer.source, targetPlayer.getName(), targetPlayer.source })
            end
                logdclog(11393254, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' odateleportált ' .. GetPlayerName(targetPlayer.source) .. ' hoz/hez')
        end
    end
end)


RegisterNetEvent('villamos_aduty:bring', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()

    if IsAdmin(adminGroup) then
        local targetPlayer = ESX.GetPlayerFromId(targetId)

        if targetPlayer then
            local logEnabled = adminLogStatus[source] ~= false

            if logEnabled then
            local logMessage = '<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:lightblue;">Odavitte </span> ({2}) ({3}) hoz/hez</div>'
            SendLogToAdmins(logMessage, { xPlayer.getName(), xPlayer.source, targetPlayer.getName(), targetPlayer.source })
            end
            logdclog(11393254, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' odateleportált ' .. GetPlayerName(targetPlayer.source) .. ' hoz/hez')
        end
    end
end)


RegisterNetEvent('villamos_aduty:togid', function(ids)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()

    if IsAdmin(adminGroup) then
        if ids == false then
            local logEnabled = adminLogStatus[source] ~= false

            if logEnabled == true then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> az ID-ket </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta az ID-ket')
        elseif ids == true then
            local logEnabled = adminLogStatus[source] ~= false

            if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>az ID-ket </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta az ID-ket')
        end
    end
end)

RegisterNetEvent('villamos_aduty:toggod', function(god)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()

    if IsAdmin(adminGroup) then
        
        if god == false then
            local logEnabled = adminLogStatus[source] ~= false

            if logEnabled == true then
                SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> a halhatatlanságot </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a halhatatlanságot')
        elseif god == true then
            if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>a halhatatlanságot </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a halhatatlanságot')
        end
    end
end)

RegisterNetEvent('villamos_aduty:togsped', function(speed)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()

    if IsAdmin(adminGroup) then
        local logEnabled = adminLogStatus[source] ~= false


        if speed == false then
            if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> a gyorsaságot </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a gyorsaságot')
        elseif speed == true then
            if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>a gyorsaságot </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a gyorsaságot')
        end
    end
end)

RegisterNetEvent('villamos_aduty:spectate', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()

    if IsAdmin(adminGroup) then
        local targetPlayer = ESX.GetPlayerFromId(targetId)

        if targetPlayer then
            local logEnabled = adminLogStatus[source] ~= false

            if logEnabled then
                local logMessage = '<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:lightblue;">Spectateli </span> ({2}) ({3}) -t</div>'
                SendLogToAdmins(logMessage, { xPlayer.getName(), xPlayer.source, targetPlayer.getName(), targetPlayer.source })
            end
            logdclog(11393254, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' Spectateli ' .. GetPlayerName(targetPlayer.source) .. ' -t')
        end
    end
end)


RegisterNetEvent('villamos_aduty:toginvisible', function(invisible)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()

    if IsAdmin(adminGroup) then
        local logEnabled = adminLogStatus[source] ~= false
        if invisible == false then
            if logEnabled == true then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> a láthatatlanságot </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a láthatatlanságot')
        elseif invisible == true then
            if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>a láthatatlanságot </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a láthatatlanságot')
        end
    end
end)

RegisterNetEvent('villamos_aduty:tognoragdoll', function(noragdoll)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminGroup = xPlayer.getGroup()

    if IsAdmin(adminGroup) then
        local logEnabled = adminLogStatus[source] ~= false

            
        if noragdoll == false then
            if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span> a noragdoll-t </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a noragdoll-t')
        elseif noragdoll == true then
            if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>a noragdoll-t </div>', { xPlayer.getName(), xPlayer.source })
            end
            logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a noragdoll-t')
    end
    end
end)

RegisterNetEvent('villamos_aduty:setTag', function(enable, tag)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not inDuty[xPlayer.source] then return end 

    tags[xPlayer.source] = enable and inDuty[xPlayer.source].tag or nil

    if tag == true then
        if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:green;">bekapcsolta </span>az admin Tag et </div>', { xPlayer.getName(), xPlayer.source })
        end
        logdclog(27946, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' bekapcsolta a noragdoll-t')
    elseif tag == true then
        if logEnabled then
            SendLogToAdmins('<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:red;">kikapcsolta </span>az admin Tag et </div>', { xPlayer.getName(), xPlayer.source })
        end
        logdclog(10616832, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' kikapcsolta a noragdoll-t')
    end
    TriggerClientEvent("villamos_aduty:sendData", -1, tags)
end)

------------------------------------------------------
------------#Logok------------------------------------


RegisterNetEvent("villamos_aduty:SendAnon", function(message)
    local adminGroup = xAdmin.getGroup()

    if IsAdmin(adminGroup) then

local author = GetPlayerName(source)
TriggerClientEvent('txcl:showAnnouncement', -1, message, author)
    end
end)

RegisterNetEvent("villamos_aduty:kickplayer", function(playerId, reason)
    local xAdmin = ESX.GetPlayerFromId(source)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local adminGroup = xAdmin.getGroup()

    if IsAdmin(adminGroup) then
        local targetPlayer = ESX.GetPlayerFromId(playerId)

        if targetPlayer then
            local logEnabled = adminLogStatus[source] ~= false

            if logEnabled then
                local logMessage = '<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 420px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;">LOG » ({1}) ({0}) » <span style="color:lightblue;">Kickelte </span> ({2}) ({3}) -t, Indok: ({4})</div>'
                SendLogToAdmins(logMessage, { xPlayer.getName(), xPlayer.source, targetPlayer.getName(), targetPlayer.source, reason })
            end
            logdclog(11393254, GetPlayerName(xPlayer.source), GetPlayerName(xPlayer.source) .. ' Kickelte ' .. GetPlayerName(targetPlayer.source) .. ' -t, Indok: ' .. reason)
        end
    end
    xPlayer.kick("Ki lettél kickelve a szerverről, indok: " .. reason)
end)


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


Citizen.CreateThread( function()
    updatePath = "/Pandateam1012/villamos_adutyv2" 
    resourceName = ""..GetCurrentResourceName()..""
    
    function checkVersion(err,responseText, headers)
        curVersion = LoadResourceFile(GetCurrentResourceName(), "version")
    
        if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
            print("^0[^3WARNING^0] " .. resourceName .. " is ^1NOT ^0up to date!")
            print("^0[^3WARNING^0] Your Version: ^1" .. curVersion .. "^0")
            print("^0[^3WARNING^0] Latest Version: ^2" .. responseText .. "^0")
            print("^0[^3WARNING^0] Get the latest Version from: ^2https://github.com" .. updatePath .. "^0")
        elseif tonumber(curVersion) > tonumber(responseText) then
            print("You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online i advise you to update ( or downgrade? )")
        else
            print("^0[^2INFO^0] " .. resourceName .. " is up to date! (^2" .. curVersion .. "^0)")
        end
    end
    
    PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
    end)