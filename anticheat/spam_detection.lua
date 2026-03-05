-- ============================================
-- ADVANCED SPAM DETECTION SYSTEM
-- Detects: Vehicle Spam, Prop Spam, Ped Spam
-- Smart detection - not just counting nearby entities
-- All settings from main Config
-- ============================================

local spamData = {}

-- Get config helper
local function GetSpamConfig(entityType, key, default)
    if Config and Config.Anticheat and Config.Anticheat.spamDetection then
        local entityConfig = Config.Anticheat.spamDetection[entityType]
        if entityConfig then
            return entityConfig[key] or default
        end
    end
    return default
end

-- Initialize tracking for player
local function InitSpamTracking(src)
    if not spamData[src] then
        spamData[src] = {
            vehicles = {},
            props = {},
            peds = {},
            warnings = 0,
            lastWarningTime = 0,
        }
    end
    return spamData[src]
end

-- Clean old entries
local function CleanOldEntries(entries, maxAge)
    local currentTime = os.time() * 1000
    local cleaned = {}
    for _, entry in ipairs(entries) do
        if (currentTime - entry.time) < maxAge then
            table.insert(cleaned, entry)
        end
    end
    return cleaned
end

-- Count entities by model
local function CountByModel(entries)
    local models = {}
    for _, entry in ipairs(entries) do
        models[entry.model] = (models[entry.model] or 0) + 1
    end
    return models
end

-- Check if entities are clustered (not just nearby)
local function AreEntitiesClustered(entities, radius)
    if #entities < 3 then return false end
    
    local positions = {}
    for _, entity in ipairs(entities) do
        if DoesEntityExist(entity.handle) then
            table.insert(positions, GetEntityCoords(entity.handle))
        end
    end
    
    if #positions < 3 then return false end
    
    -- Calculate average distance between entities
    local totalDistance = 0
    local comparisons = 0
    
    for i = 1, #positions do
        for j = i + 1, #positions do
            local dist = #(positions[i] - positions[j])
            totalDistance = totalDistance + dist
            comparisons = comparisons + 1
        end
    end
    
    local avgDistance = totalDistance / comparisons
    return avgDistance < radius
end

-- Check vehicle spam
local function CheckVehicleSpam(src)
    local data = InitSpamTracking(src)
    local currentTime = os.time() * 1000
    
    -- Get config values
    local shortWindow = 5000
    local mediumWindow = 15000
    local longWindow = 30000
    local shortThreshold = GetSpamConfig('vehicles', 'shortWindow', 3)
    local mediumThreshold = GetSpamConfig('vehicles', 'mediumWindow', 6)
    local longThreshold = GetSpamConfig('vehicles', 'longWindow', 10)
    local sameModelThreshold = GetSpamConfig('vehicles', 'sameModel', 4)
    local nearbyRadius = GetSpamConfig('vehicles', 'nearbyRadius', 50.0)
    
    -- Clean old entries
    data.vehicles = CleanOldEntries(data.vehicles, longWindow)
    
    local shortCount = 0
    local mediumCount = 0
    local longCount = #data.vehicles
    
    for _, entry in ipairs(data.vehicles) do
        local age = currentTime - entry.time
        if age < shortWindow then
            shortCount = shortCount + 1
        end
        if age < mediumWindow then
            mediumCount = mediumCount + 1
        end
    end
    
    -- Check for same model spam
    local models = CountByModel(data.vehicles)
    local maxSameModel = 0
    local spammedModel = nil
    for model, count in pairs(models) do
        if count > maxSameModel then
            maxSameModel = count
            spammedModel = model
        end
    end
    
    -- Check if vehicles are actually clustered
    local recentVehicles = {}
    for _, entry in ipairs(data.vehicles) do
        if (currentTime - entry.time) < mediumWindow then
            table.insert(recentVehicles, entry)
        end
    end
    local isClustered = AreEntitiesClustered(recentVehicles, nearbyRadius)
    
    -- Determine severity
    local severity = 0
    local reason = ""
    
    if shortCount >= shortThreshold then
        severity = severity + 2
        reason = reason .. shortCount .. " vehicles in 5s, "
    end
    
    if mediumCount >= mediumThreshold then
        severity = severity + 3
        reason = reason .. mediumCount .. " vehicles in 15s, "
    end
    
    if longCount >= longThreshold then
        severity = severity + 5
        reason = reason .. longCount .. " vehicles in 30s, "
    end
    
    if maxSameModel >= sameModelThreshold then
        severity = severity + 3
        reason = reason .. maxSameModel .. "x same model (" .. spammedModel .. "), "
    end
    
    if isClustered and mediumCount >= 4 then
        severity = severity + 2
        reason = reason .. "clustered spawns, "
    end
    
    return severity, reason, {
        short = shortCount,
        medium = mediumCount,
        long = longCount,
        sameModel = maxSameModel,
        model = spammedModel,
        clustered = isClustered
    }
end

-- Check prop spam
local function CheckPropSpam(src)
    local data = InitSpamTracking(src)
    local currentTime = os.time() * 1000
    
    local shortWindow = 5000
    local mediumWindow = 15000
    local longWindow = 30000
    local shortThreshold = GetSpamConfig('props', 'shortWindow', 5)
    local mediumThreshold = GetSpamConfig('props', 'mediumWindow', 10)
    local longThreshold = GetSpamConfig('props', 'longWindow', 20)
    local sameModelThreshold = GetSpamConfig('props', 'sameModel', 6)
    local nearbyRadius = GetSpamConfig('props', 'nearbyRadius', 30.0)
    
    data.props = CleanOldEntries(data.props, longWindow)
    
    local shortCount = 0
    local mediumCount = 0
    local longCount = #data.props
    
    for _, entry in ipairs(data.props) do
        local age = currentTime - entry.time
        if age < shortWindow then
            shortCount = shortCount + 1
        end
        if age < mediumWindow then
            mediumCount = mediumCount + 1
        end
    end
    
    local models = CountByModel(data.props)
    local maxSameModel = 0
    local spammedModel = nil
    for model, count in pairs(models) do
        if count > maxSameModel then
            maxSameModel = count
            spammedModel = model
        end
    end
    
    local recentProps = {}
    for _, entry in ipairs(data.props) do
        if (currentTime - entry.time) < mediumWindow then
            table.insert(recentProps, entry)
        end
    end
    local isClustered = AreEntitiesClustered(recentProps, nearbyRadius)
    
    local severity = 0
    local reason = ""
    
    if shortCount >= shortThreshold then
        severity = severity + 2
        reason = reason .. shortCount .. " props in 5s, "
    end
    
    if mediumCount >= mediumThreshold then
        severity = severity + 3
        reason = reason .. mediumCount .. " props in 15s, "
    end
    
    if longCount >= longThreshold then
        severity = severity + 5
        reason = reason .. longCount .. " props in 30s, "
    end
    
    if maxSameModel >= sameModelThreshold then
        severity = severity + 3
        reason = reason .. maxSameModel .. "x same model, "
    end
    
    if isClustered and mediumCount >= 6 then
        severity = severity + 2
        reason = reason .. "clustered spawns, "
    end
    
    return severity, reason, {
        short = shortCount,
        medium = mediumCount,
        long = longCount,
        sameModel = maxSameModel,
        model = spammedModel,
        clustered = isClustered
    }
end

-- Check ped spam
local function CheckPedSpam(src)
    local data = InitSpamTracking(src)
    local currentTime = os.time() * 1000
    
    local shortWindow = 5000
    local mediumWindow = 15000
    local longWindow = 30000
    local shortThreshold = GetSpamConfig('peds', 'shortWindow', 3)
    local mediumThreshold = GetSpamConfig('peds', 'mediumWindow', 5)
    local longThreshold = GetSpamConfig('peds', 'longWindow', 8)
    local sameModelThreshold = GetSpamConfig('peds', 'sameModel', 4)
    local nearbyRadius = GetSpamConfig('peds', 'nearbyRadius', 40.0)
    
    data.peds = CleanOldEntries(data.peds, longWindow)
    
    local shortCount = 0
    local mediumCount = 0
    local longCount = #data.peds
    
    for _, entry in ipairs(data.peds) do
        local age = currentTime - entry.time
        if age < shortWindow then
            shortCount = shortCount + 1
        end
        if age < mediumWindow then
            mediumCount = mediumCount + 1
        end
    end
    
    local models = CountByModel(data.peds)
    local maxSameModel = 0
    local spammedModel = nil
    for model, count in pairs(models) do
        if count > maxSameModel then
            maxSameModel = count
            spammedModel = model
        end
    end
    
    local recentPeds = {}
    for _, entry in ipairs(data.peds) do
        if (currentTime - entry.time) < mediumWindow then
            table.insert(recentPeds, entry)
        end
    end
    local isClustered = AreEntitiesClustered(recentPeds, nearbyRadius)
    
    local severity = 0
    local reason = ""
    
    if shortCount >= shortThreshold then
        severity = severity + 2
        reason = reason .. shortCount .. " peds in 5s, "
    end
    
    if mediumCount >= mediumThreshold then
        severity = severity + 3
        reason = reason .. mediumCount .. " peds in 15s, "
    end
    
    if longCount >= longThreshold then
        severity = severity + 5
        reason = reason .. longCount .. " peds in 30s, "
    end
    
    if maxSameModel >= sameModelThreshold then
        severity = severity + 3
        reason = reason .. maxSameModel .. "x same model, "
    end
    
    if isClustered and mediumCount >= 4 then
        severity = severity + 2
        reason = reason .. "clustered spawns, "
    end
    
    return severity, reason, {
        short = shortCount,
        medium = mediumCount,
        long = longCount,
        sameModel = maxSameModel,
        model = spammedModel,
        clustered = isClustered
    }
end

-- Track entity spawn
function TrackEntitySpawn(src, entityType, entity, model)
    local data = InitSpamTracking(src)
    local currentTime = os.time() * 1000
    
    local entry = {
        handle = entity,
        model = model,
        time = currentTime,
        coords = DoesEntityExist(entity) and GetEntityCoords(entity) or vector3(0, 0, 0)
    }
    
    if entityType == 'vehicle' then
        table.insert(data.vehicles, entry)
    elseif entityType == 'prop' then
        table.insert(data.props, entry)
    elseif entityType == 'ped' then
        table.insert(data.peds, entry)
    end
end

-- Clean up spammed entities from the map
function CleanupSpammedEntities(src, entityType)
    if not spamData[src] then return end
    
    local count = 0
    local lists = {}
    
    if entityType == 'all' then
        lists = { spamData[src].vehicles, spamData[src].props, spamData[src].peds }
    elseif entityType == 'vehicle' then
        lists = { spamData[src].vehicles }
    elseif entityType == 'prop' then
        lists = { spamData[src].props }
    elseif entityType == 'ped' then
        lists = { spamData[src].peds }
    end
    
    for _, list in ipairs(lists) do
        for _, entry in ipairs(list) do
            if DoesEntityExist(entry.handle) then
                DeleteEntity(entry.handle)
                count = count + 1
            end
        end
    end
    
    if count > 0 then
        print('^3[ANTICHEAT] Cleaned up ' .. count .. ' spammed ' .. (entityType == 'all' and 'entities' or entityType .. 's') .. ' for player ' .. src .. '^0')
    end
end

-- Main check function
function CheckEntitySpam(src, entityType)
    local severity, reason, stats
    
    if entityType == 'vehicle' then
        severity, reason, stats = CheckVehicleSpam(src)
    elseif entityType == 'prop' then
        severity, reason, stats = CheckPropSpam(src)
    elseif entityType == 'ped' then
        severity, reason, stats = CheckPedSpam(src)
    else
        return 0, "", {}
    end
    
    return severity, reason, stats
end

-- Clean up on player drop
AddEventHandler('playerDropped', function()
    local src = source
    if spamData[src] then
        spamData[src] = nil
    end
end)
