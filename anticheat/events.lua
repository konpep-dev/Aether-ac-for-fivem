-- ============================================
-- AETHER ANTICHEAT - EVENT WHITELIST
-- Auto-generated whitelist for server scripts
-- Prevents false bans from legitimate script events
-- ============================================

-- This file contains whitelisted events from your server scripts
-- Events in this list will NOT trigger anticheat bans
-- AND will temporarily disable related anticheat checks

local whitelistedEvents = {
    -- ============================================
    -- FRAMEWORK & CORE
    -- ============================================
    -- ESX
    ['esx:playerLoaded'] = true,
    ['esx:onPlayerSpawn'] = true,
    ['esx:onPlayerDeath'] = true,
    ['esx:setJob'] = true,
    ['esx:removeInventoryItem'] = true,
    ['esx:addInventoryItem'] = true,
    ['esx:useItem'] = true,
    
    -- QBCore / QBox
    ['QBCore:Server:OnPlayerLoaded'] = true,
    ['QBCore:Server:OnPlayerUnload'] = true,
    ['QBCore:Server:SetMetaData'] = true,
    ['QBCore:Server:UpdatePlayerData'] = true,
    ['QBCore:Player:SetPlayerData'] = true,
    ['QBCore:Server:OnJobUpdate'] = true,
    ['QBCore:Server:OnGangUpdate'] = true,
    ['QBCore:Server:OnMoneyChange'] = true,
    ['QBCore:Server:SetDuty'] = true,
    
    -- QBox specific
    ['qbx_core:server:playerLoaded'] = true,
    ['qbx_core:server:onPlayerUnload'] = true,
    ['qbx_core:server:setPlayerData'] = true,
    ['qbx_core:server:updatePlayer'] = true,
    
    -- Player spawning/death
    ['QBCore:Client:OnPlayerLoaded'] = true,
    ['QBCore:Client:OnPlayerUnload'] = true,
    ['QBCore:Client:SetDuty'] = true,
    ['hospital:client:Revive'] = true,
    ['hospital:server:SetDeathStatus'] = true,
    ['hospital:server:ambulanceAlert'] = true,
    ['hospital:server:RevivePlayer'] = true,
    ['qb-ambulancejob:server:RevivePlayer'] = true,
    ['qb-ambulancejob:server:SetDeathStatus'] = true,
    ['qbx_medical:server:revivePlayer'] = true,
    ['qbx_medical:server:setDeathStatus'] = true,
    
    -- Inventory
    ['QBCore:Server:UseItem'] = true,
    ['QBCore:Server:RemoveItem'] = true,
    ['QBCore:Server:AddItem'] = true,
    ['inventory:server:OpenInventory'] = true,
    ['inventory:server:SaveInventory'] = true,
    ['qb-inventory:server:UseItem'] = true,
    ['qb-inventory:server:RemoveItem'] = true,
    ['qb-inventory:server:AddItem'] = true,
    
    -- Money/Banking
    ['QBCore:Server:AddMoney'] = true,
    ['QBCore:Server:RemoveMoney'] = true,
    ['qb-banking:server:Deposit'] = true,
    ['qb-banking:server:Withdraw'] = true,
    ['qb-banking:server:Transfer'] = true,
    
    -- Notifications
    ['QBCore:Notify'] = true,
    ['QBCore:Client:Notify'] = true,
    ['qbx_core:client:notify'] = true,
    
    -- Vehicle keys
    ['qb-vehiclekeys:server:GiveVehicleKeys'] = true,
    ['qb-vehiclekeys:server:RemoveVehicleKeys'] = true,
    ['qbx_vehiclekeys:server:giveKeys'] = true,
    
    -- Police
    ['police:server:policeAlert'] = true,
    ['qb-policejob:server:UpdateBlips'] = true,
    ['qb-policejob:server:SendAlert'] = true,
    
    -- Apartments/Housing
    ['qb-apartments:server:SetInsideMeta'] = true,
    ['qb-houses:server:SetInsideMeta'] = true,
    
    -- Garages
    ['qb-garage:server:checkOwnership'] = true,
    ['qb-garage:server:updateVehicle'] = true,
    
    -- OX Inventory
    ['ox_inventory:openInventory'] = true,
    ['ox_inventory:closeInventory'] = true,
    ['ox_inventory:updateInventory'] = true,
    ['ox_inventory:swapItems'] = true,
    ['ox_inventory:useItem'] = true,
    
    -- OX Lib
    ['ox_lib:notify'] = true,
    ['ox_lib:showTextUI'] = true,
    ['ox_lib:hideTextUI'] = true,
    
    -- ============================================
    -- POLICE & EMERGENCY
    -- ============================================
    -- ARS Police Job
    ['ars_policejob:handcuff'] = true,
    ['ars_policejob:drag'] = true,
    ['ars_policejob:putInVehicle'] = true,
    ['ars_policejob:OutVehicle'] = true,
    ['ars_policejob:fine'] = true,
    ['ars_policejob:confiscatePlayerItem'] = true,
    
    -- Evidences
    ['evidences:server:CreateFingerDrop'] = true,
    ['evidences:server:CreateCasing'] = true,
    ['evidences:server:UpdateStatus'] = true,
    
    -- SDC MedCalls
    ['SDC_MedCalls:server:sendCall'] = true,
    ['SDC_MedCalls:server:acceptCall'] = true,
    
    -- ============================================
    -- JOBS & ACTIVITIES
    -- ============================================
    -- Jim Mining
    ['jim-mining:MineOre'] = true,
    ['jim-mining:Reward'] = true,
    ['jim-mining:SellOre'] = true,
    
    -- Jim Recycle
    ['jim-recycle:server:toggleItem'] = true,
    ['jim-recycle:server:sellItems'] = true,
    
    -- Jim Shops
    ['jim-shops:server:sellItems'] = true,
    ['jim-shops:server:buyItem'] = true,
    
    -- Jim DJ Booth
    ['jim-djbooth:server:changeVolume'] = true,
    ['jim-djbooth:server:playMusic'] = true,
    
    -- Angelicxs Civilian Jobs
    ['angelicxs-CivilianJobs:server:pay'] = true,
    ['angelicxs-CivilianJobs:server:reward'] = true,
    
    -- NN Restaurants
    ['nn_restaurants:server:buyItem'] = true,
    ['nn_restaurants:server:cookItem'] = true,
    
    -- ============================================
    -- VEHICLES & GARAGES
    -- ============================================
    -- JG Advanced Garages
    ['jg-advancedgarages:server:takeOutVehicle'] = true,
    ['jg-advancedgarages:server:storeVehicle'] = true,
    ['jg-advancedgarages:server:updateVehicle'] = true,
    
    -- Dusa Mechanic
    ['dusa_mechanic:server:repairVehicle'] = true,
    ['dusa_mechanic:server:cleanVehicle'] = true,
    ['dusa_mechanic:server:modifyVehicle'] = true,
    
    -- Dusa Carkit
    ['dusa_carkit:server:installPart'] = true,
    ['dusa_carkit:server:removePart'] = true,
    
    -- LC Fuel
    ['lc_fuel:server:PayForFuel'] = true,
    ['lc_fuel:server:UpdateFuel'] = true,
    
    -- GS Vehicle Push
    ['gs_vehiclepush:server:push'] = true,
    
    -- LVC (Emergency Lights)
    ['lvc:TogUi_s'] = true,
    ['lvc:SetLxSirenState_s'] = true,
    
    -- ============================================
    -- HEISTS & ROBBERIES
    -- ============================================
    -- Lation 247 Robbery
    ['lation_247robbery:server:startRobbery'] = true,
    ['lation_247robbery:server:rewardPlayer'] = true,
    
    -- DGL Jewelry
    ['dgl_jewelry:server:startHeist'] = true,
    ['dgl_jewelry:server:rewardPlayer'] = true,
    
    -- ============================================
    -- PHONE & COMMUNICATION
    -- ============================================
    -- LB Phone
    ['lb-phone:server:sendMessage'] = true,
    ['lb-phone:server:callPlayer'] = true,
    ['lb-phone:server:sendEmail'] = true,
    ['lb-phone:server:uploadPhoto'] = true,
    
    -- MM Radio
    ['mm_radio:server:connectToRadio'] = true,
    ['mm_radio:server:disconnectFromRadio'] = true,
    
    -- ============================================
    -- BANKING & ECONOMY
    -- ============================================
    -- Kartik Banking
    ['kartik-banking:server:deposit'] = true,
    ['kartik-banking:server:withdraw'] = true,
    ['kartik-banking:server:transfer'] = true,
    
    -- Blast Taxes
    ['blast_taxes:server:payTax'] = true,
    
    -- ============================================
    -- ITEMS & INVENTORY
    -- ============================================
    -- K5 Documents
    ['k5_documents:server:createDocument'] = true,
    ['k5_documents:server:signDocument'] = true,
    
    -- M-Prop
    ['M-PropV2:server:placeProp'] = true,
    ['M-PropV2:server:removeProp'] = true,
    
    -- ============================================
    -- DRUGS & ILLEGAL
    -- ============================================
    -- K4MB1 Quasar Drugs
    ['K4MB1-QuasarDrugs:server:processDrug'] = true,
    ['K4MB1-QuasarDrugs:server:sellDrug'] = true,
    
    -- Anox Blackmarket
    ['anox-blackmarket:server:buyItem'] = true,
    
    -- ============================================
    -- UTILITIES & MISC
    -- ============================================
    -- Anox Auto Taxi
    ['anox-autotaxi:server:startRoute'] = true,
    ['anox-autotaxi:server:completeRoute'] = true,
    
    -- DevHub Laptop
    ['devhub_laptop:server:openApp'] = true,
    
    -- JG HUD
    ['jg-hud:server:updateStatus'] = true,
    
    -- JG TextUI
    ['jg-textui:server:show'] = true,
    ['jg-textui:server:hide'] = true,
    
    -- Nass Carplay
    ['nass_carplay:server:playMusic'] = true,
    
    -- AC Scoreboard
    ['ac_scoreboard:server:updatePlayer'] = true,
    
    -- Monitor
    ['monitor:server:log'] = true,
    
    -- MugShot Base64
    ['MugShotBase64:server:takeMugshot'] = true,
    
    -- ============================================
    -- ADMIN & MODERATION
    -- ============================================
    -- Luxu Admin
    ['luxu_admin:server:kick'] = true,
    ['luxu_admin:server:ban'] = true,
    ['luxu_admin:server:teleport'] = true,
    
    -- Aether Admin (our script)
    ['aether_admin:checkPermission'] = true,
    ['aether_admin:getPlayers'] = true,
    ['aether_admin:takeScreenshot'] = true,
    ['aether_admin:kickPlayer'] = true,
    ['aether_admin:banPlayer'] = true,
    ['aether_admin:teleportToPlayer'] = true,
    ['aether_admin:bringPlayer'] = true,
    ['aether_admin:freezePlayer'] = true,
    ['aether_admin:revivePlayer'] = true,
    ['aether_admin:setWeather'] = true,
    ['aether_admin:setTime'] = true,
    ['aether_admin:giveItem'] = true,
    ['aether_admin:spectatePlayer'] = true,
    ['aether_admin:announce'] = true,
    
    -- ============================================
    -- BRIDGE SYSTEMS
    -- ============================================
    -- BL Bridge
    ['bl_bridge:server:notify'] = true,
    
    -- Jim Bridge
    ['jim_bridge:server:notify'] = true,
    
    -- NN Bridge
    ['nn_bridge:server:notify'] = true,
    
    -- ============================================
    -- CHAT & COMMUNICATION
    -- ============================================
    ['chat:addMessage'] = true,
    ['chat:addSuggestion'] = true,
    ['DoItDigital_chat:server:sendMessage'] = true,
}

-- ============================================
-- EVENT PROTECTION MAPPING
-- Maps events to anticheat protections they should trigger
-- Format: [eventName] = { protections = {types}, duration_ms }
-- ============================================
local eventProtections = {
    -- QBX Core Spawn/Load events
    ['QBCore:Client:OnPlayerLoaded'] = { protections = {'teleport', 'godmode', 'invisible'}, duration = 5000 },
    ['QBCore:Player:SetPlayerData'] = { protections = {'teleport', 'godmode'}, duration = 3000 },
    ['qbx_core:client:spawnNoApartments'] = { protections = {'teleport', 'godmode', 'invisible'}, duration = 5000 },
    ['qbx_core:client:playerLoggedOut'] = { protections = {'teleport'}, duration = 2000 },
    ['qbx_core:server:playerLoaded'] = { protections = {'teleport', 'godmode', 'invisible'}, duration = 5000 },
    ['playerSpawned'] = { protections = {'teleport', 'godmode', 'invisible'}, duration = 5000 },
    
    -- Apartment/Housing spawn
    ['apartments:client:setupSpawnUI'] = { protections = {'teleport', 'invisible'}, duration = 3000 },
    ['qb-spawn:client:openUI'] = { protections = {'teleport', 'invisible'}, duration = 3000 },
    ['qb-spawn:client:setupSpawns'] = { protections = {'teleport', 'invisible'}, duration = 3000 },
    
    -- Medical/Revive events
    ['hospital:client:Revive'] = { protections = {'godmode', 'heal', 'teleport', 'invisible'}, duration = 5000 },
    ['hospital:server:RevivePlayer'] = { protections = {'godmode', 'heal', 'teleport', 'invisible'}, duration = 5000 },
    ['qb-ambulancejob:server:RevivePlayer'] = { protections = {'godmode', 'heal', 'teleport', 'invisible'}, duration = 5000 },
    ['qbx_medical:server:revivePlayer'] = { protections = {'godmode', 'heal', 'teleport', 'invisible'}, duration = 5000 },
    
    -- SDC Medical Calls (custom medical system)
    ['SDMC:Client:UpdateCalls'] = { protections = {'teleport'}, duration = 2000 },
    ['SDMC:Server:PreformedCheckup'] = { protections = {'heal'}, duration = 3000 },
    ['SDMC:Server:PickedUpInjury'] = { protections = {'teleport', 'heal'}, duration = 3000 },
    ['SDMC:Server:DropoffDone'] = { protections = {'teleport', 'heal'}, duration = 3000 },
    ['SDMC:Client:StretcherLoop'] = { protections = {'teleport'}, duration = 2000 },
    
    -- Death events
    ['hospital:server:SetDeathStatus'] = { protections = {'godmode'}, duration = 3000 },
    ['qb-ambulancejob:server:SetDeathStatus'] = { protections = {'godmode'}, duration = 3000 },
    ['qbx_medical:server:setDeathStatus'] = { protections = {'godmode'}, duration = 3000 },
    
    -- Heal events
    ['hospital:server:HealPlayer'] = { protections = {'heal'}, duration = 3000 },
    ['qb-ambulancejob:server:HealPlayer'] = { protections = {'heal'}, duration = 3000 },
    
    -- Teleport events (apartments, garages, elevators)
    ['qb-apartments:server:SetInsideMeta'] = { protections = {'teleport'}, duration = 2000 },
    ['qb-houses:server:SetInsideMeta'] = { protections = {'teleport'}, duration = 2000 },
    ['QBCore:Command:TeleportToPlayer'] = { protections = {'teleport'}, duration = 2000 },
    
    -- Vehicle spawn
    ['jg-advancedgarages:server:takeOutVehicle'] = { protections = {'teleport'}, duration = 2000 },
    ['qb-garage:server:spawnVehicle'] = { protections = {'teleport'}, duration = 2000 },
    ['qbx_core:server:spawnVehicle'] = { protections = {'teleport'}, duration = 2000 },
    
    -- Admin actions
    ['aether_admin:revivePlayer'] = { protections = {'godmode', 'heal', 'revive'}, duration = 5000 },
    ['aether_admin:teleportToPlayer'] = { protections = {'teleport'}, duration = 2000 },
    ['aether_admin:bringPlayer'] = { protections = {'teleport'}, duration = 2000 },
}

-- Function to check if event is whitelisted
function IsEventWhitelisted(eventName)
    return whitelistedEvents[eventName] == true
end

-- Function to get protection info for an event
function GetEventProtection(eventName)
    return eventProtections[eventName]
end

-- Export for use in other files
exports('IsEventWhitelisted', IsEventWhitelisted)
exports('GetEventProtection', GetEventProtection)

return {
    events = whitelistedEvents,
    protections = eventProtections
}
