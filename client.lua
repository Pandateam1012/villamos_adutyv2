local admins = {}
local nearadmins = {}
local gamertags = {}
local adminthread = false
local isInUi = false

local duty = false
local ruha = false
local group = "user"
local tag = false
local ids = false
local god = false
local speed = false
local invisible = false
local noragdoll = false
local white = false
local orang = false
local pink = false
local red = false
local gren = false
local yelw = false

RegisterCommand('admenu', function(s, a, r)
    ESX.TriggerServerCallback("villamos_aduty:openPanel", function(allow, _group, players) 
        if not allow then return Config.Notify(_U("no_perm")) end 
        SendNUIMessage({
            type = "setplayers",
            players = players
        })
        group = _group 
        UpdateNui()
        SetNuiState(true)
    end)
end)
RegisterKeyMapping('admenu', _U("open_menu"), 'keyboard', 'o')

function SetNuiState(state)
    SetNuiFocus(state, state)
	isInUi = state

	SendNUIMessage({
		type = "show",
		enable = state
	})
end

RegisterNUICallback('goto', function(data, cb)
    if not duty then return Config.Notify(_U("no_perm")) end 
    local playerId = data.playerId
    ExecuteCommand('goto ' .. playerId)
    TriggerServerEvent('villamos_aduty:goto', playerId)
    cb('ok')
end)

RegisterNUICallback('bring', function(data, cb)
    if not duty then return Config.Notify(_U("no_perm")) end 
    local playerId = data.playerId
    ExecuteCommand('bring ' .. playerId)
    TriggerServerEvent('villamos_aduty:bring', playerId)
    cb('ok')
end)

RegisterNUICallback('exit', function(data, cb)
    SetNuiState(false)
    cb('ok')
end)

RegisterNUICallback('update', function(data, cb)
    ESX.TriggerServerCallback("villamos_aduty:openPanel", function(allow, _group, players) 
        if not allow then return SetNuiState(false) end 
        SendNUIMessage({
            type = "setplayers",
            players = players
        })
        group = _group 
        UpdateNui()
    end)
    cb('ok')
end)

RegisterNUICallback('locales', function(data, cb)
    local nuilocales = {}
    if not Config.Locale or not Locales[Config.Locale] then return print("^1SCRIPT ERROR: Invilaid locales configuartion") end
    for k, v in pairs(Locales[Config.Locale]) do 
        if string.find(k, "nui") then 
            nuilocales[k] = v
        end 
    end 
    cb(nuilocales)
end)

RegisterNUICallback('duty', function(data, cb)
    TriggerServerEvent('villamos_aduty:setDutya', data.enable)
    cb('ok')
end)

RegisterNUICallback('tag', function(data, cb)
    ToggleTag(data.enable, true, true)
    cb('ok')
end)
RegisterNUICallback('spectate', function(data, cb)
    if not duty then return Config.Notify(_U("no_perm")) end 
    local playerId = data.playerId
    exports.fl_spectate:spectatePlayer(playerId)
    SetNuiState(false)
    TriggerServerEvent('villamos_aduty:spectate', playerId)
    cb('ok')
end)
RegisterNUICallback('ids', function(data, cb)
    ToggleIds(data.enable, true, true)
    cb('ok')
end)

RegisterNUICallback('god', function(data, cb)
    ToggleGod(data.enable, true, true)
    cb('ok')
end)

RegisterNUICallback('speed', function(data, cb)
    ToggleSpeed(data.enable, true, true)
    cb('ok')
end)

RegisterNUICallback('invisible', function(data, cb)
    ToggleInvisible(data.enable, true, true)
    cb('ok')
end)

RegisterNUICallback('noragdoll', function(data, cb)
    ToggleNoragdoll(data.enable, true, true)
    cb('ok')
end)

RegisterNUICallback('ruha', function(data, cb)
    ruha(data.enable, true)
    cb('ok')
end)
RegisterNUICallback('white', function(data, cb)
    white(data.enable, true)
    cb('ok')
end)
RegisterNUICallback('orang', function(data, cb)
    orang(data.enable, true)
    cb('ok')
end)
RegisterNUICallback('pink', function(data, cb)
    pink(data.enable, true)
    cb('ok')
end)
RegisterNUICallback('red', function(data, cb)
    red(data.enable, true)
    cb('ok')
end)
RegisterNUICallback('gren', function(data, cb)
    gren(data.enable, true)
    cb('ok')
end)
RegisterNUICallback('yelw', function(data, cb)
    yelw(data.enable, true)
    cb('ok')
end)

RegisterNUICallback('coords', function(data, cb)
    ActionCoords()
    cb('ok')
end)

RegisterNUICallback('heal', function(data, cb)
    ActionHeal()
    cb('ok')
end)

RegisterNUICallback('marker', function(data, cb)
    ActionMarker()
    cb('ok')
end)

RegisterNUICallback('gotoplayer', function(data, cb)
    gotoplayer()
    print(id)
    cb('ok')
end)

RegisterNUICallback('bringplayer', function(data, cb)
    bringplayer()
    cb('ok')
end)

function UpdateNui()
    SendNUIMessage({
        type = "setstate",
        state = {
            group = group,
            duty = duty,
            tag = tag,
            ids = ids,
            god = god,
            speed = speed,
            invisible = invisible,
            noragdoll = noragdoll,
        }
    })
end 

if Config.Commands then 
    RegisterCommand('adduty', function(s, a, r)
        TriggerServerEvent('villamos_aduty:setDutya', not duty)
    end)

    RegisterCommand('adtag', function(s, a, r)
        ToggleTag(not tag, true, true)
    end)

    RegisterCommand('adids', function(s, a, r)
        ToggleIds(not ids, true, true)
    end)

    RegisterCommand('adgod', function(s, a, r)
        ToggleGod(not god, true, true)
    end)

    RegisterCommand('adspeed', function(s, a, r)
        ToggleSpeed(not speed, true, true)
    end)

    RegisterCommand('adinvisible', function(s, a, r)
        ToggleInvisible(not invisible, true, true)
    end)

    RegisterCommand('adnoragdoll', function(s, a, r)
        ToggleNoragdoll(not noragdoll, true, true)
    end)

    RegisterCommand('adcoords', function(s, a, r)
        ActionCoords(a[1])
    end)

    RegisterCommand('adheal', function(s, a, r)
        ActionHeal()
    end)

    RegisterCommand('admarker', function(s, a, r)
        ActionMarker()
    end)

    TriggerEvent('chat:addSuggestion', '/adcoords', _U("command_coords_help"), {
        { name="type", help="vec3, vec4, obj3, obj4, json3, json4" }
    })
end 

function ruha()
    if not duty then return Config.Notify(_U("no_perm")) end
end



function white(state)
    if not duty then return Config.Notify(_U("no_perm")) end 
    whiteruha = state
    if whiteruha == true then
    TriggerEvent('skinchanger:loadClothes', skin, {
        ['helmet_1'] = 91, ['helmet_2'] = 9, 
        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
        ['torso_1'] = 178, ['torso_2'] = 9,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 1,
        ['pants_1'] = 77, ['pants_2'] = 9,
        ['shoes_1'] = 55, ['shoes_2'] = 9
    })
    end
    if whiteruha == false then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if not skin then return end 
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
end

function red(state)
    if not duty then return Config.Notify(_U("no_perm")) end 
    redruha = state
    if redruha == true then
    TriggerEvent('skinchanger:loadClothes', skin, {
        ['helmet_1'] = 91, ['helmet_2'] = 5, 
        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
        ['torso_1'] = 178, ['torso_2'] = 5,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 1,
        ['pants_1'] = 77, ['pants_2'] = 5,
        ['shoes_1'] = 55, ['shoes_2'] = 5
    })
    end
    if redruha == false then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if not skin then return end 
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
end

function pink(state)
    if not duty then return Config.Notify(_U("no_perm")) end 
    pinkruha = state
    if pinkruha == true then
    TriggerEvent('skinchanger:loadClothes', skin, {
        ['helmet_1'] = 91, ['helmet_2'] = 4, 
        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
        ['torso_1'] = 178, ['torso_2'] = 4,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 1,
        ['pants_1'] = 77, ['pants_2'] = 4,
        ['shoes_1'] = 55, ['shoes_2'] = 4
    })
    end
    if pinkruha == false then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if not skin then return end 
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
end

function orang(state)
    if not duty then return Config.Notify(_U("no_perm")) end 
    orangruha = state
    if orangruha == true then
    TriggerEvent('skinchanger:loadClothes', skin, {
        ['helmet_1'] = 91, ['helmet_2'] = 2, 
        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
        ['torso_1'] = 178, ['torso_2'] = 2,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 1,
        ['pants_1'] = 77, ['pants_2'] = 2,
        ['shoes_1'] = 55, ['shoes_2'] = 2
    })
    end
    if orangruha == false then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if not skin then return end 
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
end

function gren(state)
    if not duty then return Config.Notify(_U("no_perm")) end 
    grenruha = state
    if grenruha == true then
    TriggerEvent('skinchanger:loadClothes', skin, {
        ['helmet_1'] = 91, ['helmet_2'] = 1, 
        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
        ['torso_1'] = 178, ['torso_2'] = 1,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 1,
        ['pants_1'] = 77, ['pants_2'] = 1,
        ['shoes_1'] = 55, ['shoes_2'] = 1
    })
    end
    if grenruha == false then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if not skin then return end 
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
end

function yelw(state)
    if not duty then return Config.Notify(_U("no_perm")) end 
    yelwruha = state
    if yelwruha == true then
    TriggerEvent('skinchanger:loadClothes', skin, {
        ['helmet_1'] = 91, ['helmet_2'] = 0, 
        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
        ['torso_1'] = 178, ['torso_2'] = 0,
        ['decals_1'] = 0, ['decals_2'] = 0,
        ['arms'] = 1,
        ['pants_1'] = 77, ['pants_2'] = 0,
        ['shoes_1'] = 55, ['shoes_2'] = 0
    })
    end
    if yelwruha == false then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if not skin then return end 
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
end

RegisterNetEvent('villamos_aduty:setDuty', function(state, group)
    if not Config.Admins[group] then return end 
    if state then 
        duty = true 
        tag = true
        if Config.Admins[group].ped then 
            if IsModelInCdimage(Config.Admins[group].ped) and IsModelValid(Config.Admins[group].ped) then
                RequestModel(Config.Admins[group].ped)
                while not HasModelLoaded(Config.Admins[group].ped) do
                    Wait(10)
                end
                SetPlayerModel(PlayerId(), Config.Admins[group].ped)
                SetModelAsNoLongerNeeded(Config.Admins[group].ped)
            else 
                print("^1WARNING: Invalid ped in config for group: "..group)
            end
        end 
    else 
        if Config.Admins[group].ped then 
            TriggerEvent('skinchanger:getSkin', function(skin)
                local model = skin.sex == 1 and `mp_f_freemode_01` or `mp_m_freemode_01`
                
                if IsModelInCdimage(model) and IsModelValid(model) then
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(10)
                    end
                    SetPlayerModel(PlayerId(), model)
                    SetModelAsNoLongerNeeded(model)
                    TriggerEvent('skinchanger:loadSkin', skin)
                    TriggerEvent('esx:restoreLoadout')
                end
            end)
        elseif Config.Admins[group].cloth then 
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if not skin then return end 
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end 
        ToggleIds(false, false, false)
        ToggleSpeed(false, false, false)
        ToggleGod(false, false, false)
        ToggleInvisible(false, false, false)
        ToggleNoragdoll(false, false, false)
        tag = false
        duty = false
    end 
    UpdateNui()
end)

function ToggleGod(state, usenotify, toglog) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    god = state
    SetPlayerInvincible(PlayerId(), god)
    if usenotify then 
        Config.Notify(_U("god", (god and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end if toglog then if Config.togglelog == true then
    TriggerServerEvent('villamos_aduty:toggod', god)
    end end
    CreateThread(function()
        while god do
            Wait(3000)
            local player = PlayerId()
            if not GetPlayerInvincible(player) then 
                SetPlayerInvincible(player, true)
            end
        end
    end)
end 

function ToggleTag(state, usenotify, toglog) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    tag = state
    if toglog then if Config.togglelog == true then
        TriggerServerEvent('villamos_aduty:setTag', tag)
    end end
    if usenotify then 
        Config.Notify(_U("tag", (tag and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
end 

function ToggleIds(state, usenotify, toglog) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    ids = state
    if not ids then 
        for _, v in pairs(gamertags) do 
            RemoveMpGamerTag(v.tag)
        end 
        gamertags = {}
    end 
    if usenotify then 
        Config.Notify(_U("ids", (ids and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end if toglog then if Config.togglelog == true then
    TriggerServerEvent('villamos_aduty:togid', ids)
    end end
    CreateThread(function()
        while ids do
            for i = 0, 255 do
                if NetworkIsPlayerActive(i) then
                    local ped = GetPlayerPed(i)

                    if not gamertags[i] or gamertags[i].ped ~= ped or not IsMpGamerTagActive(gamertags[i].tag) then
                        local nameTag = ('%s [%d]'):format(GetPlayerName(i), GetPlayerServerId(i))
                
                        if gamertags[i] then
                            RemoveMpGamerTag(gamertags[i].tag)
                        end
                
                        gamertags[i] = {
                            tag = CreateFakeMpGamerTag(ped, nameTag, false, false, '', 0),
                            ped = ped
                        }
                        SetMpGamerTagName(gamertags[i].tag, nameTag)
                        SetMpGamerTagAlpha(gamertags[i].tag, 2, 255)
                    end
              
                    SetMpGamerTagVisibility(gamertags[i].tag, 0, true)
                    SetMpGamerTagVisibility(gamertags[i].tag, 2, true)
                elseif gamertags[i] then
                    RemoveMpGamerTag(gamertags[i].tag)
                    gamertags[i] = nil
                end
            end
            Wait(1000)
        end
    end)
end 

function ToggleSpeed(state, usenotify, toglog) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    speed = state
    SetRunSprintMultiplierForPlayer(PlayerId(), speed and 1.4 or 1.0)
    if usenotify then 
        Config.Notify(_U("speed", (speed and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
    if toglog then if Config.togglelog == true then
    TriggerServerEvent('villamos_aduty:togsped', speed)
    end end
    CreateThread(function()
        while speed do
            Wait(1)
            SetSuperJumpThisFrame(PlayerId())
        end
    end)
end 


function ToggleInvisible(state, usenotify, toglog) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    invisible = state
    SetEntityVisible(PlayerPedId(), not invisible)
    if not invisible and tag then 
	ToggleTag(false, true)
    end 
    if usenotify then 
        Config.Notify(_U("invisible", (invisible and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
    if toglog then if Config.togglelog == true then
    TriggerServerEvent('villamos_aduty:toginvisible', invisible)
    end end
end 

function ToggleNoragdoll(state, usenotify, toglog) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    noragdoll = state
    SetPedCanRagdoll(PlayerPedId(), not noragdoll)
    if usenotify then 
        Config.Notify(_U("no_ragdoll", (noragdoll and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
    if toglog then if Config.togglelog == true then
    TriggerServerEvent('villamos_aduty:tognoragdoll', noragdoll)
    end end
end 


function ActionCoords(format) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local text = "vector3("..coords.x..", "..coords.y..", "..coords.z..")"
    if format == "vec4" then 
        text = "vector4("..coords.x..", "..coords.y..", "..coords.z..", "..heading..")"
    elseif format == "obj3" then 
        text = "{ x = "..coords.x..", y = "..coords.y..", z = "..coords.z.." }"
    elseif format == "obj4" then 
        text = "{ x = "..coords.x..", y = "..coords.y..", z = "..coords.z..", h = "..heading.."}"
    elseif format == "json3" then 
        text = '{ "x" : '..coords.x..', "y" : '..coords.y..', "z" : '..coords.z..' }'
    elseif format == "json4" then 
        text = '{ "x" : '..coords.x..', "y" : '..coords.y..', "z" : '..coords.z..', "h" : '..heading..'}'
    end 
    if not isInUi then 
        SetNuiFocus(true, true)
    end 
    SendNUIMessage({
        type = "copy",
        copy = text
    })
    Wait(300)
    if not isInUi then 
        SetNuiFocus(false, false)
    end 
    Config.Notify(_U("coords_copied"))
end 

function ActionHeal() 
    if not duty then return Config.Notify(_U("no_perm")) end 
    local ped = PlayerPedId()
    TriggerEvent('esx_status:set', 'hunger', 1000000)
    TriggerEvent('esx_status:set', 'thirst', 1000000)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    Config.Notify(_U("healed"))
end 

function ActionMarker()
    if not duty then return Config.Notify(_U("no_perm")) end 
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local starttime = GetGameTimer()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if not DoesBlipExist(WaypointHandle) then return Config.Notify(_U("no_waypoint")) end 
    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
    local _, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, 999.0)
    SetPedCoordsKeepVehicle(ped, waypointCoords.x, waypointCoords.y, zPos+2.0)
    FreezeEntityPosition(ped, true)
    while not HasCollisionLoadedAroundEntity(ped) do
        RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zPos)
        if (GetGameTimer() - starttime) > 1000 then
            SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z+2.0)
            break
        end
        Wait(1)
    end
    FreezeEntityPosition(ped, false)
    Config.Notify(_U("teleported"))
end 


CreateThread(function()
    local txd = CreateRuntimeTxd("duty")
    if not HasStreamedTextureDictLoaded("duty") then
        return print("^1SCRIPT ERROR: Can't create texture dict 'duty'")
    end 
    for i=1, #Config.Icons do
		CreateRuntimeTextureFromImage(txd, Config.Icons[i], "icons/"..Config.Icons[i]..".png")
	end
    for k, v in pairs(Config.Admins) do 
        if v.logo and not GetTextureResolution("duty", v.logo) then 
            return print("^1SCRIPT ERROR: A texture ("..v.logo..") is missing for group: "..k)
        end 
    end 
    while true do 
        local coords = GetEntityCoords(PlayerPedId())
        nearadmins = {}
        for id, data in pairs(admins) do
            local player = GetPlayerFromServerId(id)
            local ped = GetPlayerPed(player)
            if player ~= -1 and ped ~= 0 and #(coords - GetEntityCoords(ped)) < 30 then 
                nearadmins[id] = data
                nearadmins[id].ped = ped
            end
        end

        if next(nearadmins) and not adminthread then 
            CreateThread(function()
                adminthread = true 
                while next(nearadmins) do 
                    for _, data in pairs(nearadmins) do 
                        local headcoords = GetWorldPositionOfEntityBone(data.ped, GetPedBoneIndex(data.ped, 31086))
                        DrawText3D(headcoords+vector3(0.0, 0.0, 0.4), data.label, data.color)
                        if data.logo then 
                            DrawMarker(9, headcoords+vector3(0.0, 0.0, 0.7), 0.0, 0.0, 0.0, 90.0, 90.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, true, false, 2, true, "duty", data.logo, false)
                        end 
                    end 
                    Wait(3)
                end 
                adminthread = false 
            end)
        end 
        
        Wait(1000)
    end 
end)

RegisterNetEvent('villamos_aduty:sendData', function(data)
    admins = data
end)

function DrawText3D(coords, text, color) 
    SetDrawOrigin(coords)
    SetTextScale(0.0, 0.4)
    SetTextFont(4)
    SetTextColour(color.r, color.g, color.b, 255)
    SetTextCentre(1)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
	AddTextComponentString(text)
	EndTextCommandDisplayText(0, 0)
    ClearDrawOrigin()
end
