---@diagnostic disable: missing-parameter

local admins,nearadmins,playerJobs, gamertags = {}, {}, {}, {}
local duty, group, tag ,ids, god, speed, invisible, adminzone, noragdoll, idsThread, Spectating, isInUi, adminthread, time = false, "user", false, false, false, false, false, false, false, nil, false, false, false, "0h 00m"
local AdminZones, Adminthread, currentZoneColor
local playerBlips = false
lastposition = nil
-- LOG EVENT

local function DebugPrint(msg)
    if Config.debug then
        print("[DEBUG] " .. msg)
    end
end

local function sendlog(uzi)
    DebugPrint("Log küldése: " .. uzi)
    TriggerServerEvent('villamos_aduty:sendlog', uzi)
end

RegisterCommand('admenu', function(s, a, r)
    DebugPrint("Admin menü megnyitása kérelmezve")
    lib.callback("villamos_aduty:openPanel", false, function(allow, _group, players)
        if not allow then 
            DebugPrint("Nincs jogosultság az admin menü megnyitásához")
            return Config.Notify(_U("no_perm")) 
        end 
        
        DebugPrint("Admin menü megnyitva, csoport: " .. _group .. ", játékosok száma: " .. #players)
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
    DebugPrint("NUI állapot váltása: " .. tostring(state))
    SetNuiFocus(state, state)
	isInUi = state

	SendNUIMessage({
		type = "show",
		enable = state
	})
end

local coords = nil
local spectateCoords = nil
local targetServerId = nil

RegisterNetEvent("villamos_aduty:getcoords")
AddEventHandler("villamos_aduty:getcoords", function(coord)
    DebugPrint("Koordináták megkapva: " .. tostring(coord))
    coords = coord
    spectateCoords = coord
end)

RegisterNetEvent("villamos_aduty:forceUpdateCoords")
AddEventHandler("villamos_aduty:forceUpdateCoords", function(coord, serverId)
    DebugPrint("Kényszerített koordináta frissítés - ID: " .. serverId .. ", koordináták: " .. tostring(coord))
    if serverId == targetServerId then
        spectateCoords = coord
        coords = coord
        DebugPrint("Célpont koordinátái frissítve")
    end
end)

function SpectatePlayer(targetId)
    DebugPrint("Megfigyelés indítása - célpont ID: " .. targetId)
    local playerServerId = GetPlayerServerId(PlayerId())
    targetServerId = targetId
    
    if not duty then 
        DebugPrint("Nincs admin szolgálatban - megfigyelés megtagadva")
        Config.Notify(_U("no_perm"))
        return 
    end

    Spectating = not Spectating
    DebugPrint("Megfigyelés állapot: " .. tostring(Spectating))
    
    if Spectating then
        DebugPrint("Megfigyelés indítása - kezdeti koordináták lekérése")
        local success, initialCoords = lib.callback.await("villamos_aduty:getPlayerCoords", false, targetServerId)
        if not success then 
            DebugPrint("Nem sikerült lekérni a játékos koordinátáit")
            Spectating = false
            return Config.Notify(_U("spectate_failed")) 
        end
        
        DebugPrint("Kezdeti koordináták sikeresen lekérve")
        local playerPed = PlayerPedId()
        lastposition = GetEntityCoords(playerPed)
        DebugPrint("Utolsó pozíció mentve: " .. tostring(lastposition))
        
        ToggleTag(false, false)
        ToggleInvisible(true, false)
        DebugPrint("Tag és láthatóság beállítva")
        
        if lib.progressBar({
            duration = 1000,
            label = 'Betöltés...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
        }) then
            DebugPrint("Betöltési folyamat elkezdve")
            TriggerServerEvent("villamos_aduty:sendcoord", targetServerId)
            local attempts = 0
            local maxAttempts = 2
            
            while attempts < maxAttempts and not spectateCoords do
                DebugPrint("Koordináták várakozás - kísérlet: " .. attempts)
                Wait(500)
                attempts = attempts + 1
                
                if attempts % 3 == 0 then
                    DebugPrint("Koordináták újra kérelmezése")
                    TriggerServerEvent("villamos_aduty:sendcoord", targetServerId)
                end
            end
            
            if not spectateCoords then
                DebugPrint("Spectate koordináták nem érkeztek meg, kezdeti koordináták használata")
                spectateCoords = initialCoords
                coords = initialCoords
            end
            
            if not spectateCoords then
                DebugPrint("Hiba: Nem sikerült koordinátákat lekérni")
                Config.Notify('Nem sikerült lekérni a koordinátákat')
                Spectating = false
                return
            end
            
            DebugPrint("Fókusz és kollízió beállítása")
            SetFocusArea(spectateCoords.x, spectateCoords.y, spectateCoords.z, 0.0, 0.0, 0.0)
            RequestCollisionAtCoord(spectateCoords.x, spectateCoords.y, spectateCoords.z)
            
            local streamingTimer = 0
            while streamingTimer < 8000 do 
                Wait(100)
                streamingTimer = streamingTimer + 100
                RequestCollisionAtCoord(spectateCoords.x, spectateCoords.y, spectateCoords.z)
                
                if HasCollisionLoadedAroundEntity(playerPed) then
                    DebugPrint("Kollízió betöltve")
                    break
                end
            end
            
            DebugPrint("Megfigyelési mód beállítások alkalmazása")
            ToggleIds(true, false)
            FreezeEntityPosition(playerPed, true)
            
            DoScreenFadeOut(100)
            Wait(100)
            
            local offsetX = math.random(-15, 15)
            local offsetY = math.random(-15, 15)
            local offsetZ = math.random(-20, -5) 
            
            DebugPrint("Játékos pozíció beállítása offset-tel: " .. offsetX .. ", " .. offsetY .. ", " .. offsetZ)
            SetEntityCoordsNoOffset(playerPed, 
                spectateCoords.x + offsetX, 
                spectateCoords.y + offsetY, 
                spectateCoords.z + offsetZ, 
                false, false, false
            )
            
            RequestCollisionAtCoord(spectateCoords.x, spectateCoords.y, spectateCoords.z)
            
            Wait(1000) 
            
            local targetPlayer = GetPlayerFromServerId(targetServerId)
            
            if targetPlayer == -1 or not DoesEntityExist(GetPlayerPed(targetPlayer)) then
                DebugPrint("Célpont játékos nem található - kamera mód")
                SetFocusPosAndVel(spectateCoords.x, spectateCoords.y, spectateCoords.z, 0.0, 0.0, 0.0)
                NetworkConcealPlayer(PlayerId(), true, false)
                
                CreateSpectateCamera(spectateCoords)
            else
                DebugPrint("Célpont játékos megtalálva - spectator mód")
                local targetPed = GetPlayerPed(targetPlayer)
                NetworkSetInSpectatorMode(true, targetPed)
            end
            
            DoScreenFadeIn(100)
            DebugPrint("Megfigyelés teljesen beállítva")
            
        else
            DebugPrint("Betöltési folyamat megszakítva")
            Spectating = false
            return
        end
    end

    CreateThread(function()
        DebugPrint("Megfigyelési input kezelő thread indítva")
        while Spectating do
            Wait(0)
            
            if IsControlJustPressed(0, 38) then
                DebugPrint("Kilépés gomb megnyomva")
                Unspectate()
                break
            end

            if targetServerId then
                local playerId = GetPlayerFromServerId(targetServerId)
                
                if playerId ~= -1 and DoesEntityExist(GetPlayerPed(playerId)) then
                    local playerPed = GetPlayerPed(playerId)
                    local health = math.max(0, (GetEntityHealth(playerPed) - 100))
                    local armour = GetPedArmour(playerPed)
                    
                    local displayText = ""
                    local infoItems = {}
                    
                    if health > 0 then
                        table.insert(infoItems, string.format("HP: %d%%", health))
                    end
                    
                    if armour > 0 then
                        table.insert(infoItems, string.format("Pajzs: %d%%", armour))
                    end
                    
                    local adminRank = GetPlayerAdminRank(playerId) 
                    if adminRank and adminRank ~= "" then
                        table.insert(infoItems, string.format("Admin: %s", adminRank))
                    end
                    
                    if #infoItems > 0 then
                        displayText = table.concat(infoItems, " | ") .. " | [E] Kilépés"
                    else
                        displayText = "[E] Kilépés"
                    end
                    
                    lib.showTextUI(displayText, {
                        position = 'bottom-center',
                        icon = 'eye',
                        style = {
                            borderRadius = 12,
                            backgroundColor = '#16213e',
                            color = '#f8f9fa',
                            boxShadow = '0 4px 20px rgba(0, 0, 0, 0.3)',
                            padding = '12px 24px',
                            fontSize = '14px',
                            fontWeight = '500',
                            textShadow = '0 1px 1px rgba(0,0,0,0.2)',
                            minWidth = '320px',
                            maxWidth = '420px'
                        }
                    })
                else
                    if GetGameTimer() % 2000 < 10 then 
                        DebugPrint("Koordináta frissítés kérése célponttól")
                        TriggerServerEvent("villamos_aduty:requestCoordUpdate", targetServerId)
                    end
                    
                    lib.showTextUI('Játékos betöltése... Kérlek várj | [E] Kilépés', {
                        position = 'bottom-center',
                        icon = 'eye',
                        style = {
                            borderRadius = 12,
                            backgroundColor = '#16213e',
                            color = '#f8f9fa',
                            boxShadow = '0 4px 20px rgba(0, 0, 0, 0.3)',
                            padding = '12px 24px',
                            fontSize = '14px',
                            fontWeight = '500',
                            textShadow = '0 1px 1px rgba(0,0,0,0.2)',
                            minWidth = '320px',
                            maxWidth = '420px'
                        }
                    })
                end
            end
            
            Wait(100) 
        end
        DebugPrint("Megfigyelési UI elrejtve")
        lib.hideTextUI()
    end)
    
    CreateThread(function()
        DebugPrint("Megfigyelési koordináta frissítő thread indítva")
        while Spectating do
            Wait(2 * 1000)
            
            if targetServerId then
                local playerId = GetPlayerFromServerId(targetServerId)
                
                if playerId == -1 or not DoesEntityExist(GetPlayerPed(playerId)) then
                    DebugPrint("Célpont nem létezik - koordináta frissítés szükséges")
                    local success, newCoords = lib.callback.await("villamos_aduty:getPlayerCoords", false, targetServerId)
                    if success and newCoords then
                        local currentCoords = GetEntityCoords(PlayerPedId())
                        local distance = #(currentCoords - vector3(newCoords.x, newCoords.y, newCoords.z))
                        DebugPrint("Új koordináták lekérve - távolság: " .. distance)
                        
                        if distance > 500 then 
                            DebugPrint("Nagy távolság - fade out és teleportálás")
                            DoScreenFadeOut(300)
                            Wait(300)
                            
                            SetFocusArea(newCoords.x, newCoords.y, newCoords.z, 0.0, 0.0, 0.0)
                            RequestCollisionAtCoord(newCoords.x, newCoords.y, newCoords.z)
                            
                            local streamWait = 0
                            while streamWait < 5000 do
                                Wait(100)
                                streamWait = streamWait + 100
                                RequestCollisionAtCoord(newCoords.x, newCoords.y, newCoords.z)
                            end
                        end
                        
                        spectateCoords = newCoords
                        local playerPed = PlayerPedId()
                        
                        DebugPrint("Spectator mód újrabeállítása")
                        NetworkSetInSpectatorMode(false, playerPed)
                        Wait(200)
                        
                        local offsetX = math.random(-15, 15)
                        local offsetY = math.random(-15, 15)
                        local offsetZ = math.random(5, 20)
                        
                        SetEntityCoordsNoOffset(playerPed, 
                            spectateCoords.x + offsetX, 
                            spectateCoords.y + offsetY, 
                            spectateCoords.z + offsetZ, 
                            false, false, false
                        )
                        
                        Wait(800)
                        
                        SetFocusPosAndVel(spectateCoords.x, spectateCoords.y, spectateCoords.z, 0.0, 0.0, 0.0)
                        NetworkConcealPlayer(PlayerId(), true, false)
                        
                        if distance > 500 then
                            DoScreenFadeIn(300)
                        end
                        
                        local newTargetPlayer = GetPlayerFromServerId(targetServerId)
                        if newTargetPlayer ~= -1 and DoesEntityExist(GetPlayerPed(newTargetPlayer)) then
                            DebugPrint("Új célpont megtalálva - spectator mód bekapcsolása")
                            local targetPed = GetPlayerPed(newTargetPlayer)
                            NetworkSetInSpectatorMode(true, targetPed)
                        end
                    end
                else
                    local targetPed = GetPlayerPed(playerId)
                    if DoesEntityExist(targetPed) then
                        local coords = GetEntityCoords(targetPed)
                        spectateCoords = coords
                        
                        if not NetworkIsInSpectatorMode() then
                            DebugPrint("Spectator mód újrakapcsolása")
                            NetworkSetInSpectatorMode(true, targetPed)
                        end
                    end
                end
            end
        end
        DebugPrint("Koordináta frissítő thread leállítva")
    end)
end

function GetPlayerAdminRank(playerId)
    DebugPrint("Admin rang lekérése - játékos ID: " .. playerId)
    local targetServerId = GetPlayerServerId(playerId)
    if targetServerId then
        local success, adminRank = lib.callback.await("villamos_aduty:getadmintag", false, targetServerId)
        if success and adminRank then
            DebugPrint("Admin rang sikeresen lekérve: " .. adminRank)
            return adminRank
        else
            DebugPrint("Admin rang lekérése sikertelen")
        end
    end
    return nil
end

function CreateSpectateCamera(coords)
    DebugPrint("Megfigyelő kamera létrehozása")
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, coords.x, coords.y, coords.z + 10.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, true)
    
    CreateThread(function()
        DebugPrint("Kamera frissítő thread indítva")
        while Spectating do
            if spectateCoords then
                SetCamCoord(cam, spectateCoords.x, spectateCoords.y, spectateCoords.z + 10.0)
                PointCamAtCoord(cam, spectateCoords.x, spectateCoords.y, spectateCoords.z)
            end
            Wait(500)
        end
        
        DebugPrint("Kamera megsemmisítése")
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(cam, false)
    end)
end

function Unspectate()
    if not Spectating then 
        DebugPrint("Nem vagy megfigyelési módban")
        return 
    end
    
    DebugPrint("Megfigyelés befejezése")
    local playerPed = PlayerPedId()
    
    NetworkSetInSpectatorMode(false, playerPed)
    SetEntityVisible(playerPed, true, false)
    
    if lastposition then
        DebugPrint("Visszatérés utolsó pozícióhoz")
        DoScreenFadeOut(300)
        Wait(300)
        
        RequestCollisionAtCoord(lastposition.x, lastposition.y, lastposition.z)
        
        local timer = 0
        while not HasCollisionLoadedAroundEntity(playerPed) and timer < 5000 do
            RequestCollisionAtCoord(lastposition.x, lastposition.y, lastposition.z)
            Wait(100)
            timer = timer + 100
        end
        
        FreezeEntityPosition(playerPed, false)
        SetEntityCoordsNoOffset(playerPed, lastposition.x, lastposition.y, lastposition.z, false, false, false)
        
        Wait(500)
        DoScreenFadeIn(300)
    else
        DebugPrint("Nincs mentett pozíció")
        FreezeEntityPosition(playerPed, false)
    end
    
    ClearFocus()
    NetworkConcealPlayer(PlayerId(), false, false)
    
    lib.hideTextUI()
    Config.Notify('Megfigyelés vége')
    ToggleTag(true, false)
    ToggleIds(false, false)
    ToggleInvisible(false, false)
    Spectating = false
    lastposition = nil
    spectateCoords = nil
    coords = nil
    targetServerId = nil
    DebugPrint("Megfigyelés teljesen befejezve")
end

RegisterCommand("unspectate", function()
    DebugPrint("Unspectate parancs végrehajtva")
    Unspectate()
end)

RegisterKeyMapping('unspectate', 'Unspectate', 'keyboard', 'e')

RegisterNUICallback('spectate', function(data)
    DebugPrint("NUI spectate callback - ID: " .. data.id)
    if not duty then 
        DebugPrint("Nincs jogosultság a megfigyeléshez")
        Config.Notify(_U("no_perm"))
        return 
    end
    
    SpectatePlayer(data.id)
end)

RegisterNUICallback('update', function(data, cb)
    DebugPrint("NUI update callback")
    lib.callback("villamos_aduty:openPanel", false, function(allow, _group, players)
        if not allow then 
            DebugPrint("Frissítési jogosultság megtagadva")
            return SetNuiState(false) 
        end 
        
        DebugPrint("Játékos lista frissítve")
        SendNUIMessage({
            type = "setplayers",
            players = players
        })
        group = _group 
    end)
    cb('ok')
end)

RegisterNUICallback('exit', function(data, cb)
    DebugPrint("NUI kilépés")
    SetNuiState(false)
    cb('ok')
end)

RegisterNUICallback('kick', function(data, cb)
    DebugPrint("Játékos kirúgása - ID: " .. data.id)
    lib.callback("villamos_aduty:kickPlayer", false, function(success)
        if success then 
            DebugPrint("Kirúgás sikeres")
            cb('ok') 
        else
            DebugPrint("Kirúgás sikertelen")
        end
    end, data.id)
end)

RegisterNUICallback('goto', function(data, cb)
    DebugPrint("Goto parancs - ID: " .. data.id)
    lib.callback("villamos_aduty:gotoPlayer", false, function(success)
        if success then
            DebugPrint("Goto sikeres")
            Config.Notify(_U("player_brought"))
        else
            DebugPrint("Goto sikertelen")
            Config.Notify(_U("no_perm"))
        end
        cb('ok')
    end, data.id)
end)

RegisterNUICallback('bring', function(data, cb)
    DebugPrint("Bring parancs - ID: " .. data.id)
    lib.callback("villamos_aduty:bring", false, function(success)
        if success then
            DebugPrint("Bring sikeres")
            Config.Notify(_U("player_brought"))
        else
            DebugPrint("Bring sikertelen")
            Config.Notify(_U("no_perm"))
        end
        cb('ok')
    end, data.id)
end)

RegisterNUICallback('locales', function(data, cb)
    DebugPrint("Locale-k lekérése")
    local nuilocales = {}
    if not Config.Locale or not Locales[Config.Locale] then 
        DebugPrint("Hibás locale konfiguráció")
        return print("^1SCRIPT ERROR: Invilaid locales configuartion") 
    end
    for k, v in pairs(Locales[Config.Locale]) do 
        if string.find(k, "nui") then 
            nuilocales[k] = v
        end 
    end 
    DebugPrint("Locale-k elküldve")
    cb(nuilocales)
end)

RegisterNUICallback('duty', function(data, cb)
    DebugPrint("Szolgálat váltása: " .. tostring(data.enable))
    TriggerServerEvent('villamos_aduty:setDutya', data.enable)
    cb('ok')
end)

RegisterNUICallback('tag', function(data, cb)
    DebugPrint("Tag váltása: " .. tostring(data.enable))
    ToggleTag(data.enable, true)
    sendlog(_U("taglog", data.enable and _U("enabledlog") or _U("disabledlog")))
    cb('ok')
end)

RegisterNUICallback('ids', function(data, cb)
    DebugPrint("IDs váltása: " .. tostring(data.enable))
    ToggleIds(data.enable, true)
    sendlog(_U("idlog", data.enable and _U("enabledlog") or _U("disabledlog")))
    cb('ok')
end)

RegisterNUICallback('god', function(data, cb)
    DebugPrint("God mód váltása: " .. tostring(data.enable))
    ToggleGod(data.enable, true)
    sendlog(_U("godmodelog", data.enable and _U("enabledlog") or _U("disabledlog")))
    cb('ok')
end)

RegisterNUICallback('speed', function(data, cb)
    DebugPrint("Sebesség váltása: " .. tostring(data.enable))
    ToggleSpeed(data.enable, true)
    sendlog(_U("spedlog", data.enable and _U("enabledlog") or _U("disabledlog")))
    cb('ok')
end)

RegisterNUICallback('invisible', function(data, cb)
    DebugPrint("Láthatatlanság váltása: " .. tostring(data.enable))
    ToggleInvisible(data.enable, true)
    sendlog(_U("invisiblelog", data.enable and _U("enabledlog") or _U("disabledlog")))
    cb('ok')
end)

RegisterNUICallback('adminzone', function(data, cb)
    DebugPrint("Admin zóna váltása: " .. tostring(data.enable))
    Toggleadminzone(data.enable, true)
    sendlog(_U("adminzonelog", data.enable and _U("enabledlog") or _U("disabledlog")))
    cb('ok')
end)


RegisterNUICallback('noragdoll', function(data, cb)
    DebugPrint("No ragdoll váltása: " .. tostring(data.enable))
    ToggleNoragdoll(data.enable, true)
    sendlog(_U("no_ragdolllog", data.enable and _U("enabledlog") or _U("disabledlog")))
    cb('ok')
end)

RegisterNUICallback('coords', function(data, cb)
    DebugPrint("Koordináták másolása")
    ActionCoords()
    cb('ok')
end)

RegisterNUICallback('heal', function(data, cb)
    DebugPrint("Gyógyítás")
    ActionHeal()
    cb('ok')
end)

RegisterNUICallback('marker', function(data, cb)
    DebugPrint("Marker teleportálás")
    ActionMarker()
    cb('ok')
end)

function UpdateNui()
    DebugPrint("NUI frissítése")
    lib.callback("villamos_adutyv2:gettime", false, function(time)
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
                adminzone = adminzone,
                playerBlips = playerBlips,
                noragdoll = noragdoll,
                timeinduty = time or "0h 00m"
            }
        })
        DebugPrint("NUI állapot frissítve")
    end)
end 

if Config.Commands then 
    DebugPrint("Parancsok regisztrálása")
    RegisterCommand('adduty', function(s, a, r)
        DebugPrint("Adduty parancs végrehajtva")
        TriggerServerEvent('villamos_aduty:setDutya', not duty)
    end)

    RegisterCommand('adtag', function(s, a, r)
        DebugPrint("Adtag parancs végrehajtva")
        ToggleTag(not tag, true)
    end)

    RegisterCommand('adids', function(s, a, r)
        DebugPrint("Adids parancs végrehajtva")
        ToggleIds(not ids, true)
    end)

    RegisterCommand('adgod', function(s, a, r)
        DebugPrint("Adgod parancs végrehajtva")
        ToggleGod(not god, true)
    end)

    RegisterCommand('adspeed', function(s, a, r)
        DebugPrint("Adspeed parancs végrehajtva")
        ToggleSpeed(not speed, true)
    end)

    RegisterCommand('adinvisible', function(s, a, r)
        DebugPrint("Adinvisible parancs végrehajtva")
        ToggleInvisible(not invisible, true)
    end)

    RegisterCommand('adzone', function(s, a, r)
        DebugPrint("Adzone parancs végrehajtva")
        Toggleadminzone(not adminzone, true)
    end)

    RegisterCommand('adnoragdoll', function(s, a, r)
        DebugPrint("Adnoragdoll parancs végrehajtva")
        ToggleNoragdoll(not noragdoll, true)
    end)

    RegisterCommand('adcoords', function(s, a, r)
        DebugPrint("Adcoords parancs végrehajtva - formátum: " .. (a[1] or "alapértelmezett"))
        ActionCoords(a[1])
    end)

    RegisterCommand('adheal', function(s, a, r)
        DebugPrint("Adheal parancs végrehajtva")
        ActionHeal()
    end)

    RegisterCommand('admarker', function(s, a, r)
        DebugPrint("Admarker parancs végrehajtva")
        ActionMarker()
    end)

    TriggerEvent('chat:addSuggestion', '/adcoords', _U("command_coords_help"), {
        { name="type", help="vec3, vec4, obj3, obj4, json3, json4" }
    })
end 
local function DebugPrint(uzenet)
    if Config.debug then
        print("[HIBAKERESO] " .. uzenet)
    end
end

RegisterNetEvent('villamos_aduty:setDuty', function(state, group)
    if not Config.Admins[group] then return end 
    if state then 
        duty = true 
        group = group  
        tag = true
        TriggerServerEvent('villamos_aduty:setTag', true)
        lib.callback("villamos_adutyv2:gettime", false, function(time)
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
                    playerBlips = playerBlips,
                    adminzone = adminzone,
                    noragdoll = noragdoll,
                    timeinduty = time or "0h 00m"
                }
            })
        end)
        if tag then
            TriggerServerEvent('villamos_aduty:setTag', true)
        end

        if adminzone then
            TriggerServerEvent("villamos_aduty:Adminzone", true, GetEntityCoords(PlayerPedId()))
        end

        if Config.Admins[group].ped then 
            if IsModelInCdimage(Config.Admins[group].ped) and IsModelValid(Config.Admins[group].ped) then
                RequestModel(Config.Admins[group].ped)
                while not HasModelLoaded(Config.Admins[group].ped) do
                    Wait(10)
                end
                SetPlayerModel(PlayerId(), Config.Admins[group].ped)
                SetModelAsNoLongerNeeded(Config.Admins[group].ped)
            else 
                DebugPrint("Ervenytelen ped a configban a csoporthoz: "..group)
            end 
        elseif Config.Admins[group].cloth then 
            TriggerEvent('skinchanger:getSkin', function(skin)
                if not skin then 
                    DebugPrint("Hiba: Nem sikerult betolteni a skint. A jatekos teljesen be van toltve?")
                    return 
                end
            
                local clothing = (skin.sex == 1 and Config.Admins[group].cloth[group].female or Config.Admins[group].cloth[group].male)
                if clothing then
                    TriggerEvent('skinchanger:loadClothes', skin, clothing)
                else
                    DebugPrint("Hiba: Nem talalhato ruha config a csoporthoz: " .. group)
                end
            end)
            
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
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
            end)
        end 

        ToggleIds(false, false)
        ToggleSpeed(false, false)
        ToggleGod(false, false)
        ToggleInvisible(false, false)
        TriggerServerEvent("villamos_aduty:Adminzone", false, nil)
        Toggleadminzone(false, false)
        ToggleNoragdoll(false, false)
        ToggleTag(false, false)
        tag = false
        duty = false
        group = "user"
    end 
    UpdateNui()
end)

function ToggleGod(state, usenotify) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    god = state
    SetEntityInvincible(PlayerPedId(), god)
    SetEntityProofs(PlayerPedId(), god, god, god, god, god, god, god, god)
    SetPedCanRagdoll(PlayerPedId(), god)
    if usenotify then 
        Config.Notify(_U("god", (god and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
end 

function ToggleTag(state, usenotify) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    
    tag = state
    
    TriggerServerEvent('villamos_aduty:setTag', tag)
    
    if usenotify then 
        Config.Notify(_U("tag", (tag and _U("enabled") or _U("disabled"))))
    end 
    
    UpdateNui()
end

function ToggleIds(state, usenotify)
    if not duty then return Config.Notify(_U("no_perm")) end 
    ids = state

    if not ids then
        for _, v in pairs(gamertags) do
            RemoveMpGamerTag(v.tag)
        end
        gamertags = {}

        if idsThread then
            TerminateThread(idsThread)
            idsThread = nil
        end
    else
        if idsThread then return end

        idsThread = CreateThread(function()
            while ids do
                lib.callback('villamos_aduty:getAllJobs', false, function(jobs)
                    playerJobs = {}

                    for _, data in ipairs(jobs) do
                        local playerId = tonumber(data.id)
                        playerJobs[playerId] = data.job
                    end

                    for i = 0, 255 do
                        if NetworkIsPlayerActive(i) then
                            local ped = GetPlayerPed(i)
                            local serverId = tonumber(GetPlayerServerId(i))
                            local jobInfo = playerJobs[serverId] or "Unknown Job"

                            if gamertags[i] and gamertags[i].job == jobInfo then
                                goto continue
                            end

                            if gamertags[i] then
                                RemoveMpGamerTag(gamertags[i].tag)
                            end

                            local nameTag = ('%s [%d] %s'):format(GetPlayerName(i), serverId, jobInfo)
                            local tag = CreateFakeMpGamerTag(ped, nameTag, false, false, '', 0)

                            SetMpGamerTagName(tag, nameTag)
                            SetMpGamerTagAlpha(tag, 2, 255)
                            SetMpGamerTagVisibility(tag, 0, true)
                            SetMpGamerTagVisibility(tag, 2, true)

                            gamertags[i] = {
                                tag = tag,
                                ped = ped,
                                job = jobInfo
                            }

                            ::continue::
                        elseif gamertags[i] then
                            RemoveMpGamerTag(gamertags[i].tag)
                            gamertags[i] = nil
                        end
                    end
                end)

                Wait(5000)
            end

            idsThread = nil
        end)
    end

    if usenotify then
        Config.Notify(_U("ids", (ids and _U("enabled") or _U("disabled"))))
        UpdateNui()
    end
end

function ToggleSpeed(state, usenotify) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    speed = state
    SetRunSprintMultiplierForPlayer(PlayerId(), speed and 1.4 or 1.0)
    if usenotify then 
        Config.Notify(_U("speed", (speed and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
    CreateThread(function()
        while speed do
            Wait(1)
            SetSuperJumpThisFrame(PlayerId())
        end
    end)
end 

function ToggleInvisible(state, usenotify) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    invisible = state
    SetEntityVisible(PlayerPedId(), not invisible)
	ToggleTag(not invisible, false)
    if usenotify then 
        Config.Notify(_U("invisible", (invisible and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
end 

function Toggleadminzone(state, usenotify) 
    adminzone = state
    if not adminzone then TriggerServerEvent("villamos_aduty:Adminzone", false, nil) end
    TriggerServerEvent("villamos_aduty:Adminzone", adminzone, GetEntityCoords(PlayerPedId()))    
    if usenotify then 
        Config.Notify(_U("adminzone", (adminzone and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
end 

function ToggleNoragdoll(state, usenotify) 
    if not duty then return Config.Notify(_U("no_perm")) end 
    noragdoll = state
    SetPedCanRagdoll(PlayerPedId(), not noragdoll)
    if usenotify then 
        Config.Notify(_U("no_ragdoll", (noragdoll and _U("enabled") or _U("disabled")) ))
        UpdateNui()
    end 
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

local text_scale = 0.35
local text_font = 6
local color_white = {255, 255, 255, 255}
local _color = {r = 255, g = 255, b = 255, a = 255}
local colorCache = {}

local function GetColor(color)
    if colorCache[color] then
        return colorCache[color]
    end
    
    _color.r, _color.g, _color.b = 255, 255, 255
    
    if type(color) == "string" and color:sub(1, 1) == "#" then
        local hex = color:sub(2)
        if #hex == 6 then
            _color.r = tonumber(hex:sub(1, 2), 16) or 255
            _color.g = tonumber(hex:sub(3, 4), 16) or 255
            _color.b = tonumber(hex:sub(5, 6), 16) or 255
            
            if _color.r > 255 then _color.r = 255 elseif _color.r < 0 then _color.r = 0 end
            if _color.g > 255 then _color.g = 255 elseif _color.g < 0 then _color.g = 0 end
            if _color.b > 255 then _color.b = 255 elseif _color.b < 0 then _color.b = 0 end
            
            colorCache[color] = {r = _color.r, g = _color.g, b = _color.b}
        end
    elseif type(color) == "table" then
        if color.r and color.g and color.b then
            _color.r, _color.g, _color.b = color.r, color.g, color.b
            
            if _color.r > 255 then _color.r = 255 elseif _color.r < 0 then _color.r = 0 end
            if _color.g > 255 then _color.g = 255 elseif _color.g < 0 then _color.g = 0 end
            if _color.b > 255 then _color.b = 255 elseif _color.b < 0 then _color.b = 0 end
        elseif #color >= 3 then
            _color.r, _color.g, _color.b = color[1], color[2], color[3]
            
            if _color.r > 255 then _color.r = 255 elseif _color.r < 0 then _color.r = 0 end
            if _color.g > 255 then _color.g = 255 elseif _color.g < 0 then _color.g = 0 end
            if _color.b > 255 then _color.b = 255 elseif _color.b < 0 then _color.b = 0 end
        end
    end
    
    return _color
end

local function DrawText3D(coords, text, color)
    local col = GetColor(color)
    
    SetDrawOrigin(coords.x, coords.y, coords.z)
    SetTextScale(text_scale, text_scale)
    SetTextFont(text_font)
    SetTextColour(col.r, col.g, col.b, 255)
    SetTextCentre(1)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(0, 0)
    ClearDrawOrigin()
end

local adminData = {}
local activeAdmins = {}
local adminCount = 0

CreateThread(function()
    local config_height = Config.Admintext.height
    local config_logo_height = Config.Admintext.height + 0.4
    local config_bobupandown = Config.Admintext.bobupandown
    local config_facecamera = Config.Admintext.facecamera
    local config_spin = Config.Admintext.spin
    
    local txd = CreateRuntimeTxd("duty")
    if not HasStreamedTextureDictLoaded("duty") then
        return DebugPrint("Nem sikerult letrehozni a 'duty' texture dictionary-t")
    end
    
    for i=1, #Config.Icons do
        CreateRuntimeTextureFromImage(txd, Config.Icons[i], "icons/"..Config.Icons[i]..".png")
    end
    
    for k, v in pairs(Config.Admins) do 
        if v.logo and not GetTextureResolution("duty", v.logo) then 
            DebugPrint("Egy texture ("..v.logo..") hianzik a csoporthoz: "..k)
        end 
    end
    
    local heightOffset = vector3(0.0, 0.0, config_height)
    local iconOffset = vector3(0.0, 0.0, config_logo_height)
    
    local renderActive = false
    
    while true do 
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for i=1, adminCount do
            activeAdmins[i] = nil
        end
        adminCount = 0
        
        for id, data in pairs(admins) do
            local player = GetPlayerFromServerId(id)
            local ped = GetPlayerPed(player)
            
            if player ~= -1 and ped ~= 0 then
                local pedCoords = GetEntityCoords(ped)
                local distance = #(coords - pedCoords)
                
                if distance < 30 then
                    if not adminData[id] then
                        adminData[id] = {
                            label = data.label,
                            color = data.color,
                            logo = data.logo,
                            ped = ped,
                            boneIndex = GetPedBoneIndex(ped, 31086)
                        }
                    else
                        if adminData[id].ped ~= ped then
                            adminData[id].ped = ped
                            adminData[id].boneIndex = GetPedBoneIndex(ped, 31086)
                        end
                    end
                    
                    adminCount = adminCount + 1
                    activeAdmins[adminCount] = adminData[id]
                end
            end
        end
        
        if adminCount > 0 and not renderActive then
            CreateThread(function()
                renderActive = true
                
                local markerType = 9
                local dirX, dirY, dirZ = 0.0, 0.0, 0.0
                local rotX, rotY, rotZ = 90.0, 90.0, 0.0
                local scaleX, scaleY, scaleZ = 1.0, 1.0, 1.0
                local r, g, b, a = 255, 255, 255, 255
                local bobUpAndDown = config_bobupandown
                local faceCamera = config_facecamera
                local p19 = 2
                local rotate = config_spin
                local textureDict = "duty"
                local p22 = false
                
                while adminCount > 0 do
                    for i=1, adminCount do
                        local admin = activeAdmins[i]
                        local headCoords = GetWorldPositionOfEntityBone(admin.ped, admin.boneIndex)
                        
                        if headCoords then
                            local textPos = vector3(
                                headCoords.x,
                                headCoords.y,
                                headCoords.z + config_height
                            )
                            DrawText3D(textPos, admin.label, admin.color)
                            
                            if admin.logo then
                                local iconPos = vector3(
                                    headCoords.x,
                                    headCoords.y,
                                    headCoords.z + config_logo_height
                                )
                                DrawMarker(
                                    markerType,
                                    iconPos.x, iconPos.y, iconPos.z,
                                    dirX, dirY, dirZ,
                                    rotX, rotY, rotZ,
                                    scaleX, scaleY, scaleZ,
                                    r, g, b, a,
                                    bobUpAndDown, faceCamera,
                                    p19, rotate, textureDict, admin.logo, p22
                                )
                            end
                        end
                    end
                    Wait(0)
                end
                
                renderActive = false
            end)
        end
        Wait(1000)
    end
end)

RegisterNetEvent('villamos_aduty:sendData', function(data)
    admins = data
end)

local function HexToBlipColor(hex)
    hex = hex:gsub("#", "")
    if #hex == 6 then
        hex = hex .. "FF"
    end
    return tonumber("0x" .. hex)
end

local function HexToRGB(hex)
    hex = hex:gsub("#", "")
    return {
        r = tonumber("0x" .. hex:sub(1, 2)),
        g = tonumber("0x" .. hex:sub(3, 4)),
        b = tonumber("0x" .. hex:sub(5, 6)),
        a = tonumber("0x" .. hex:sub(7, 8)) or 151
    }
end

local AdminZones, currentZoneColors = {}, {}

RegisterNetEvent("villamos_aduty:CreateAdminzone", function(state, coords, color, zoneId)
    zoneId = zoneId or 1

    if AdminZones[zoneId] then
        local zone = AdminZones[zoneId]
        if zone.radiusBlip then RemoveBlip(zone.radiusBlip) end
        if zone.centerBlip then RemoveBlip(zone.centerBlip) end
        if zone.marker and zone.marker.destroy then zone.marker:destroy() end
        if zone.zone then zone.zone:remove() end
        AdminZones[zoneId] = nil
        currentZoneColors[zoneId] = nil
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        SetEveryoneIgnorePlayer(playerPed, false)
        SetPoliceIgnorePlayer(playerPed, false)
        SetLocalPlayerAsGhost(false)
        NetworkSetPlayerIsPassive(false)
        NetworkSetFriendlyFireOption(true)
        SetEntityCanBeDamaged(playerPed, false)
        SetPlayerCanDoDriveBy(PlayerId(), true)
        SetPlayerInvincible(PlayerId(), false)
        SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)
        SetEntityVisible(playerPed, true)
        SetEntityAlpha(playerPed, 255, false)
        SetPlayerInvincible(PlayerId(), false)
        SetEntityCollision(playerPed, true, true)
        SetEntityCanBeDamaged(vehicle, true)
        SetEntityCollision(playerPed, true, true)
        if DoesEntityExist(vehicle) then
            SetEntityCollision(vehicle, true, true)
        end
    end

    if state then
        local rgb = HexToRGB(color)
        currentZoneColors[zoneId] = color

        AdminZones[zoneId] = {
            radiusBlip = AddBlipForRadius(coords, Config.AdminZone.radius),
            centerBlip = AddBlipForCoord(coords),
            marker = lib.marker.new({
                type = 28,
                coords = coords,
                color = { r = rgb.r, g = rgb.g, b = rgb.b, a = 150 },
                width = Config.AdminZone.radius,
                height = Config.AdminZone.radius
            }),
            coords = coords
        }

        local blipColor = HexToBlipColor(color)
        SetBlipAlpha(AdminZones[zoneId].radiusBlip, 128)
        SetBlipColour(AdminZones[zoneId].radiusBlip, blipColor)
        SetBlipSprite(AdminZones[zoneId].centerBlip, Config.AdminZone.blipSprite)
        SetBlipColour(AdminZones[zoneId].centerBlip, blipColor)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U("AdminZone_title") .. " #" .. zoneId)
        EndTextCommandSetBlipName(AdminZones[zoneId].centerBlip)

        AdminZones[zoneId].zone = lib.points.new({
            coords = coords,
            distance = Config.AdminZone.radius,
            nearby = function()
                DisablePlayerFiring(PlayerId(), true)
                local controls = {106, 24, 69, 70, 92, 114,257, 331,68,257,263,264}
                for _, control in ipairs(controls) do
                    DisableControlAction(0, control, true)
                end
            end,
            onEnter = function()
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                NetworkSetFriendlyFireOption(false)
				SetEntityCanBeDamaged(vehicle, false)
				SetEntityCanBeDamaged(playerPed, false)
				ClearPlayerWantedLevel(PlayerId())
				SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)
                SetEveryoneIgnorePlayer(playerPed, true)
                SetPoliceIgnorePlayer(playerPed, true)
                SetLocalPlayerAsGhost(true)
                NetworkSetPlayerIsPassive(true)
                lib.notify({
                    title = _U("AdminZone_title") .. " #" .. zoneId,
                    description = _U("inAdminzone"),
                    type = "success"
                })
            end,
            onExit = function()
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                SetEveryoneIgnorePlayer(playerPed, false)
                SetPoliceIgnorePlayer(playerPed, false)
                SetLocalPlayerAsGhost(false)
                NetworkSetPlayerIsPassive(false)
                NetworkSetFriendlyFireOption(true)
				SetEntityCanBeDamaged(playerPed, false)
                SetPlayerCanDoDriveBy(PlayerId(), true)
                SetPlayerInvincible(PlayerId(), false)
                SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)
                SetEntityVisible(playerPed, true)
                SetEntityAlpha(playerPed, 255, false)
                SetPlayerInvincible(PlayerId(), false)
                SetEntityCollision(playerPed, true, true)
				SetEntityCanBeDamaged(vehicle, true)
                SetEntityCollision(playerPed, true, true)
                if DoesEntityExist(vehicle) then
                    SetEntityCollision(vehicle, true, true)
                end
                
                lib.notify({
                    title = _U("AdminZone_title") .. " #" .. zoneId,
                    description = _U("outAdminzone"),
                    type = "warning"
                })
            end
        })

        CreateThread(function()
            while AdminZones[zoneId] and AdminZones[zoneId].marker do
                AdminZones[zoneId].marker:draw()
                Wait(0)
            end
        end)
    end
end)

function RemoveAllAdminZones()
    for id in pairs(AdminZones) do
        TriggerEvent("villamos_aduty:CreateAdminzone", false, nil, nil, id)
    end
end