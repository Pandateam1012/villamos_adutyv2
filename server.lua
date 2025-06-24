local inDuty = {} 
local tags = {}
local dutyTimes = json.decode(LoadResourceFile(GetCurrentResourceName(), "data.json")) or {}
local useOkokChat = GetResourceState('okokChat') == 'started' or GetResourceState('okokChatV2') == 'started'
local adminLoggingStates = {}

local function DebugPrint(msg)
    if Config.debug then
        print("[DEBUG] " .. msg)
    end
end

function IsAdminLoggingEnabled(source)
    if adminLoggingStates[source] == nil then
        adminLoggingStates[source] = Config.ChatLogs
    end
    return adminLoggingStates[source]
end

function NormalizePlayerName(playerName)
    if not playerName then return "Unknown" end
    
    local normalizedName = string.gsub(playerName, "[^%w%s_-]", "")
    
    if normalizedName == "" then
        normalizedName = "Player"
    end
    
    if string.len(normalizedName) > 14 then
        normalizedName = string.sub(normalizedName, 1, 20) .. "..."
    end
    
    return normalizedName
end

RegisterServerEvent('esx:setGroup')
AddEventHandler('esx:setGroup', function(source, group)
    local player = ESX.GetPlayerFromId(source)
    if inDuty[source] then
        inDuty[source].group = group
        if tags[source] then
            local adminConfig = Config.Admins[group]
            if adminConfig then
                local normalizedName = NormalizePlayerName(GetPlayerName(source))
                tags[source] = {
                    label = adminConfig.tag .. "~w~ | " .. normalizedName,
                    color = adminConfig.color,
                    logo = adminConfig.logo
                }
            else
                tags[source] = nil
            end
            TriggerClientEvent("villamos_aduty:sendData", -1, tags)
        end
        
        TriggerClientEvent("villamos_aduty:setDuty", source, true, group)
        DebugPrint("Admin csoport beállítva: " .. GetPlayerName(source) .. " - " .. group)
    end
end)

if Config.Tips then
    local tips = {
        "Használd a /adlog parancsot az admin log kikapcsolásához!",
        "Jelentések megtekintése: /reports",
        "Használd a /admenu parancsot az admin menü megnyitásához!",
    }
    
    local function BroadcastTip()
        local tip = tips[math.random(#tips)]
        for _, playerId in ipairs(GetAdmins()) do
            TriggerClientEvent("chat:addMessage", playerId, { 
                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(214, 74, 74, 0.6); border-radius: 8px; border: 0.0px solid #e63946"><i class="fas fa-wrench"></i> <span style="color:#f04d9f">[Tip] </span>{0}</span></div>',
                args = { tip },
            })
        end
    end
    
    Citizen.CreateThread(function()
        while true do
            Wait(15 * 60 * 1000)
            BroadcastTip()
            DebugPrint("Tipp elküldve az adminoknak")
        end
    end)
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

local function sendAdminLog(admin, title, message)
    local xPlayer = ESX.GetPlayerFromId(admin) 
    if not xPlayer or not inDuty[xPlayer.source] then 
        print(('[villamos_adutyv2] WARNING: sendAdminLog called for player %s who is not on duty or xPlayer is nil.'):format(admin))
        return 
    end
    
    local normalizedName = NormalizePlayerName(GetPlayerName(admin))
    local playername = " "..normalizedName.. " ["..admin.."]" or " Ismeretlen Admin" 
    local admins = GetAdmins() 

    for _, adminId in ipairs(admins) do
        if IsAdminLoggingEnabled(adminId) then
            if useOkokChat then
                local background = 'linear-gradient(90deg, rgba(26, 26, 46, 0.9) 0%, rgba(67, 97, 238, 0.9) 100%)'
                local color = '#4361ee'
                local icon = 'fa-solid fa-hammer'
                TriggerEvent('okokChat:ServerMessage', background, color, icon, title, playername, message, adminId, " ") 
            else
                TriggerClientEvent("chat:addMessage", adminId, { 
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(22, 33, 62, 0.6); border-radius: 8px; border: 0.0px solid #e63946"><i class="fas fa-wrench"></i> <span style="color:#4cc9f0">[Log] </span>{1}</span> {0}</div>',
                    args = { message, playername },
                })
            end
        end
    end
end

RegisterNetEvent('villamos_aduty:sendlog')
AddEventHandler('villamos_aduty:sendlog', function(uzi)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local group = Config.DiscordTags and GetDiscordRole(xPlayer.source) or xPlayer.getGroup()

        if not group or not Config.Admins[group] then 
            return Config.Notify(xPlayer.source, "Nincs jogosultságod ehhez a logoláshoz!")
        end 

        sendAdminLog(source, "Admin Log", uzi) 
        DebugPrint("Admin log üzenet elküldve: " .. uzi)
    end
end)

lib.callback.register('villamos_aduty:getAllJobs', function(source)
    local players = ESX.GetPlayers()
    local jobs = {}

    for _, playerId in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            local jobName = xPlayer.job.label .. " - " .. xPlayer.job.grade_label
            table.insert(jobs, {id = playerId, job = jobName}) 
        end
    end

    DebugPrint("Munkák lekérdezve: " .. GetPlayerName(source))
    return jobs
end)

function formatMoney(amount)
    if type(amount) ~= "number" then return "0" end
    
    local negative = amount < 0
    amount = math.abs(amount)
    
    if amount == 0 then return "0" end
    if amount < 1000 then return tostring(math.floor(amount)) end
    
    local exponent = math.min(math.floor(math.log(amount) / math.log(1000)), 30)
    local divisor = 1000 ^ exponent
    local value = amount / divisor
    
    local formatted
    if value >= 100 then
        formatted = string.format("%.0f", value)
    elseif value >= 10 then
        formatted = string.format("%.1f", value)
    else
        formatted = string.format("%.2f", value)
    end
    
    local suffix = getSuffix(exponent)
    formatted = formatted .. suffix
    
    if negative then
        formatted = "-" .. formatted
    end
    
    return formatted
end

function getSuffix(exponent)
    local suffixes = {"K","M","B","T","Qa","Qi","Sx","Sp","O","N",
                     "Dc","UDc","DDc","TDc","QaDc","QiDc","SxDc","SpDc","ODc","NDc",
                     "Vg","UVg","DVg","TVg","QaVg","QiVg","SxVg","SpVg","OVg","NVg"}
    return exponent <= #suffixes and suffixes[exponent] or "e"..(exponent*3)
end

lib.callback.register("villamos_aduty:openPanel", function(source)
    local xAdmin = ESX.GetPlayerFromId(source)
    if not xAdmin or not IsAdmin(xAdmin.getGroup()) then return false end
    
    local players = {}
    local play = ESX.GetPlayers()
    
    for i = 1, #play do
        local xPlayer = ESX.GetPlayerFromId(play[i])
        if xPlayer then
            local cash = tonumber(ESX.Math.Round(xPlayer.getMoney() or 0))
            local bank = tonumber(ESX.Math.Round(xPlayer.getAccount("bank").money or 0))
            local normalizedName = NormalizePlayerName(GetPlayerName(xPlayer.source))
            
            players[#players+1] = {
                id = xPlayer.source,
                name = normalizedName or "Unknown",
                group = xPlayer.getGroup() or "user",
                job = (xPlayer.getJob().label or "Unknown") .. " - " .. (xPlayer.getJob().grade_label or "0"),
                Penz = formatMoney(cash).. " $",
                bank = formatMoney(bank).. " $",
                duty = inDuty[xPlayer.source]
            }
        end
    end

    DebugPrint("Admin panel megnyitva: " .. GetPlayerName(source))
    return true, xAdmin.getGroup(), players
end)

RegisterNetEvent('villamos_aduty:setTag')
AddEventHandler('villamos_aduty:setTag', function(enable)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not inDuty[xPlayer.source] then 
        return 
    end

    local group = Config.DiscordTags and GetDiscordRole(xPlayer.source) or xPlayer.getGroup()
    if not group or not Config.Admins[group] then
        return
    end

    if enable then
        local normalizedName = NormalizePlayerName(GetPlayerName(source))
        tags[source] = {
            label = Config.Admins[group].tag .. "~w~ | " .. normalizedName,
            color = Config.Admins[group].color,
            logo = Config.Admins[group].logo
        }
    else
        tags[source] = nil
    end
    
    TriggerClientEvent("villamos_aduty:sendData", -1, tags)
    DebugPrint("Admin tag beállítása: " .. (enable and "bekapcsolva" or "kikapcsolva") .. " - " .. GetPlayerName(source))
end)

local activeAdminZones = {} 

RegisterNetEvent("villamos_aduty:Adminzone", function(state, coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = Config.DiscordTags and GetDiscordRole(xPlayer.source) or xPlayer.getGroup()
    local color = Config.Admins[group].color
    
    if not inDuty[xPlayer.source] then return end 
    
    if state then
        local zoneId = #activeAdminZones + 1
        activeAdminZones[zoneId] = {
            creator = source,
            coords = coords,
            color = color
        }
        TriggerClientEvent("villamos_aduty:CreateAdminzone", -1, state, coords, color, zoneId)
        DebugPrint("Admin zóna létrehozva: " .. GetPlayerName(source))
    else
        for zoneId, zoneData in pairs(activeAdminZones) do
            if zoneData.creator == source then
                TriggerClientEvent("villamos_aduty:CreateAdminzone", -1, false, nil, nil, zoneId)
                activeAdminZones[zoneId] = nil
                DebugPrint("Admin zóna törölve: " .. GetPlayerName(source))
            end
        end
    end
end)

RegisterNetEvent('villamos_aduty:setDutya', function(enable)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not enable and inDuty[xPlayer.source] then 
        for zoneId, zoneData in pairs(activeAdminZones) do
            if zoneData.creator == source then
                TriggerClientEvent("villamos_aduty:CreateAdminzone", -1, false, nil, nil, zoneId)
                activeAdminZones[zoneId] = nil
            end
        end
        
        TriggerClientEvent("villamos_aduty:setDuty", xPlayer.source, false, inDuty[xPlayer.source].group)
        local group = Config.DiscordTags and GetDiscordRole(xPlayer.source) or xPlayer.getGroup()
        if tags[xPlayer.source] then 
            tags[xPlayer.source] = nil
            TriggerClientEvent("villamos_aduty:sendData", -1, tags)
        end 
        local dutyMinutes = math.floor((os.time() - inDuty[xPlayer.source].start) / 60)
        inDuty[xPlayer.source] = nil
        local normalizedName = NormalizePlayerName(GetPlayerName(xPlayer.source))
        TriggerEvent("villamos_aduty:sendlog", Config.Admins[group].tag .." ".._U("went_offduty", normalizedName))
        Config.Notify(-1, Config.Admins[group].tag .." ".._U("went_offduty", normalizedName))

        dutyTimes[xPlayer.identifier] = (dutyTimes[xPlayer.identifier] or 0) + dutyMinutes
        SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(dutyTimes), -1)
        LogToDiscord(normalizedName, false, FormatMinutes(dutyTimes[xPlayer.identifier] or 0), FormatMinutes(dutyMinutes))
        DebugPrint("Admin duty kikapcsolva: " .. normalizedName)
    else 
        local group = Config.DiscordTags and GetDiscordRole(xPlayer.source) or xPlayer.getGroup()

        if not group or not Config.Admins[group] then return Config.Notify(xPlayer.source, _U("cant_duty")) end 

        adminLoggingStates[source] = Config.ChatLogs

        local normalizedName = NormalizePlayerName(GetPlayerName(xPlayer.source))
        inDuty[xPlayer.source] = {
            ped = Config.Admins[group].ped,
            tag = { label = Config.Admins[group].tag .. "~w~ | " .. normalizedName, color = Config.Admins[group].color, logo = Config.Admins[group].logo },
            group = group,
            start = os.time()
        }
        TriggerClientEvent("villamos_aduty:setDuty", xPlayer.source, true, group)
        Config.Notify(-1, Config.Admins[group].tag .." ".._U("went_onduty", normalizedName))
        TriggerEvent("villamos_aduty:sendlog", Config.Admins[group].tag .." ".._U("went_onduty", normalizedName))
        DebugPrint("Admin duty bekapcsolva: " .. normalizedName)

        tags[xPlayer.source] = inDuty[xPlayer.source].tag
        TriggerClientEvent("villamos_aduty:sendData", -1, tags)
        LogToDiscord(normalizedName, true, FormatMinutes((dutyTimes[xPlayer.identifier] or 0))) 
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
    local normalizedName = NormalizePlayerName(GetPlayerName(xPlayer.source))
    Config.Notify(-1, _U("went_offduty", normalizedName))

    dutyTimes[xPlayer.identifier] = (dutyTimes[xPlayer.identifier] or 0) + dutyMinutes
    SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(dutyTimes), -1)
    LogToDiscord(normalizedName, false, FormatMinutes(dutyTimes[xPlayer.identifier] or 0), FormatMinutes(dutyMinutes))
    DebugPrint("Játékos kilépett, admin duty kikapcsolva: " .. normalizedName)
end)

lib.callback.register("villamos_adutyv2:gettime", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local time = nil
    local File = LoadResourceFile(GetCurrentResourceName(), "data.json")
    for i, v in pairs(json.decode(File)) do
        if i == xPlayer.identifier then
            time = FormatMinutes(v)
        end
    end
    DebugPrint("Duty idő lekérdezve: " .. GetPlayerName(source))
    return time
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    TriggerClientEvent("villamos_aduty:sendData", source, tags)
    DebugPrint("Játékos betöltve: " .. GetPlayerName(source))
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
                ["url"] = "https://discord.gg/esnawXn5q5",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/917181033626087454/954753156821188658/marvel1.png"
            },
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %X").." | villamos_aduty :)",
            },
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
    DebugPrint("Discord log elküldve: " .. name .. " - " .. (duty and "duty bekapcsolva" or "duty kikapcsolva"))
end

function FormatMinutes(m)
    local minutes = m % 60
    local hours = math.floor((m - minutes) / 60)
    return hours.." h "..minutes.." m"
end

function IsAdmin(group)
    for i=1, #Config.Perms do 
        if Config.Perms[i] == group then 
            return true 
        end 
    end 

    return false
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

exports('sendAdminLog', function(source, title, message)
    return sendAdminLog(source, title, message) 
end)

exports('IsInDuty', function(src) 
    return inDuty[src] and true or false
end)

RegisterCommand('adlog', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then 
        local group = Config.DiscordTags and GetDiscordRole(xPlayer.source) or xPlayer.getGroup()
        if not group or not Config.Admins[group] then return Config.Notify(xPlayer.source, _U("cant_duty")) end 
    
        local currentState = IsAdminLoggingEnabled(source)
        adminLoggingStates[source] = not currentState
        
        local statusMsg = adminLoggingStates[source] and "Admin log bekapcsolva" or "Admin log kikapcsolva"
        Config.Notify(xPlayer.source, statusMsg)
        DebugPrint("Admin log állapota megváltozott: " .. statusMsg .. " - " .. GetPlayerName(source))
    end
end, false)

RegisterNetEvent('villamos_aduty:sendcoord')
AddEventHandler('villamos_aduty:sendcoord', function(targetServerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local group = Config.DiscordTags and GetDiscordRole(xPlayer.source) or xPlayer.getGroup()
    if not group or not Config.Admins[group] then return Config.Notify(xPlayer.source, _U("cant_duty")) end 

    local xTarget = ESX.GetPlayerFromId(targetServerId)
    if xTarget then
        local targetPed = GetPlayerPed(xTarget.source)
        local coord = GetEntityCoords(targetPed)
        TriggerClientEvent('villamos_aduty:getcoords', source, coord)
        DebugPrint("Koordináták elküldve: " .. GetPlayerName(source) .. " -> " .. GetPlayerName(targetServerId))
    else
    end
end)

RegisterServerEvent("villamos_aduty:requestCoordUpdate")
AddEventHandler("villamos_aduty:requestCoordUpdate", function(targetId)
    local src = source
    local targetPlayer = GetPlayerPed(targetId)
    if targetPlayer then
        local coords = GetEntityCoords(targetPlayer)
        TriggerClientEvent("villamos_aduty:forceUpdateCoords", src, coords, targetId)
        DebugPrint("Koordináta frissítés kérése: " .. GetPlayerName(src) .. " -> " .. GetPlayerName(targetId))
    end
end)

lib.callback.register("villamos_aduty:kickPlayer", function(source, targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsAdmin(xPlayer.getGroup()) then return false end
    DropPlayer(targetId, _U("kicked_message"))
    DebugPrint("Játékos kirúgva: " .. GetPlayerName(targetId) .. " by " .. GetPlayerName(source))
    return true
end)

lib.callback.register("villamos_aduty:gotoPlayer", function(source, targetId)
    local xTarget = ESX.GetPlayerFromId(targetId)
    local xAdmin = ESX.GetPlayerFromId(source)

    if not xAdmin or not xTarget then return false end
    if not inDuty[xAdmin.source] then return false end
    if xTarget then 
        xAdmin.setCoords(xTarget.getCoords(true))
        DebugPrint("Admin teleportált: " .. GetPlayerName(source) .. " -> " .. GetPlayerName(targetId))
        return true 
    end
    return false
end)

lib.callback.register("villamos_aduty:getPlayerCoords", function(source, targetId)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if xTarget then
        DebugPrint("Játékos koordináták lekérdezve: " .. GetPlayerName(targetId) .. " by " .. GetPlayerName(source))
        return true, xTarget.getCoords(true)
    end
    return false, nil
end)

lib.callback.register("villamos_aduty:bring", function(source, targetId)
    local xAdmin = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xAdmin or not xTarget then return false end
    if not inDuty[xAdmin.source] then return false end
    
    local adminCoords = xAdmin.getCoords(true)
    xTarget.setCoords(adminCoords)
    DebugPrint("Játékos behozva: " .. GetPlayerName(targetId) .. " by " .. GetPlayerName(source))
    return true
end)

lib.callback.register("villamos_aduty:getadmintag", function(source, targetId)
    local xPlayer = ESX.GetPlayerFromId(targetId)
    if not xPlayer then return end
    DebugPrint("Admin tag lekérdezve: " .. GetPlayerName(targetId) .. " by " .. GetPlayerName(source))
    return Config.Admins[xPlayer.getGroup()].tag
end)