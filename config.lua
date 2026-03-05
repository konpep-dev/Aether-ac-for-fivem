Config = {}

-- ============================================
-- DEBUG CONFIGURATION
-- ============================================
-- Enable debug messages in console (useful for troubleshooting)
Config.Debug = true  -- Set to true to see detailed debug messages

-- ============================================
-- FRAMEWORK CONFIGURATION
-- ============================================
-- Supported: 'auto', 'qb', 'qbx', 'esx', 'standalone'
-- 'auto' = Auto-detect framework
Config.Framework = 'auto'

-- Admin Groups with permissions
Config.AdminGroups = {
    ['superadmin'] = {
        kick = true, ban = true, freeze = true, teleport = true, bring = true,
        spectate = true, revive = true, godmode = true, noclip = true, invisible = true,
        spawnVehicle = true, deleteVehicle = true, repairVehicle = true,
        giveWeapon = true, giveItem = true, setWeather = true, setTime = true,
        announce = true, managePerms = true,
    },
    ['admin'] = {
        kick = true, ban = true, freeze = true, teleport = true, bring = true,
        spectate = true, revive = true, godmode = true, noclip = true, invisible = true,
        spawnVehicle = true, deleteVehicle = true, repairVehicle = true,
        giveWeapon = true, giveItem = true, setWeather = true, setTime = true,
        announce = true, managePerms = false,
    },
    ['mod'] = {
        kick = true, ban = false, freeze = true, teleport = true, bring = true,
        spectate = true, revive = true, godmode = false, noclip = false, invisible = false,
        spawnVehicle = false, deleteVehicle = false, repairVehicle = false,
        giveWeapon = false, giveItem = false, setWeather = false, setTime = false,
        announce = true, managePerms = false,
    },
}

-- Default admins (loaded from database, this is fallback)
Config.Admins = {
    ['license:824c1f3c195f6d7e9e4f7409ac795e4d53d6f949'] = 'superadmin',
    ['discord:926572380409712660'] = 'superadmin',
}

-- Command and Hotkeys
Config.OpenCommand = 'admin'
Config.OpenKey = 'INSERT'      -- INSERT key to open admin panel
Config.NoclipKey = 'DELETE'    -- DELETE key for noclip

-- Database tables
Config.AdminTable = 'admin_permissions'
Config.BanTable = 'admin_bans'

-- Logging
Config.LogActions = true

-- Discord Webhooks (leave empty to disable)
Config.Webhooks = {
    -- Main log channel (all logs go here)
    main = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    -- Specific action webhooks (optional, falls back to main)
    bans = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    kicks = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    reports = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    permissions = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    -- New webhooks
    kills = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    connects = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    screenshots = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    spawn = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    teleport = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
    anticheat = 'https://discord.com/api/webhooks/1444109485663719565/XfkC8tOBO095Y5Oyct8ehs4DEuGn4WaBRkN297YaPmlP8tdZsuLIo-fGmVBIJvs0qosJ',
}

-- Webhook colors (decimal)
Config.WebhookColors = {
    ban = 15158332,      -- Red
    kick = 15105570,     -- Orange
    report = 3447003,    -- Blue
    permission = 10181046, -- Purple
    teleport = 3066993,  -- Green
    spawn = 15844367,    -- Gold
    default = 9807270,   -- Gray
}

-- Server name for logs
Config.ServerName = 'Aether Server'

-- Fivemanage API Token (για screenshots στο Discord)
-- Πάρε δωρεάν token από: https://fivemanage.com
Config.FivemanageToken = 'xSDwaADlGHGeHSCNGwFmTHof8JRAbI94'

-- Discord invite link for ban appeals
Config.DiscordInvite = 'https://discord.gg/your-server'

-- ============================================
-- ANTI-VPN CONFIGURATION
-- ============================================
Config.AntiVPN = {
    enabled = true,  -- Enable/Disable VPN detection
    apiKey = '22afb8dfa3ea99ba64f304b247e1392d5642ec26022e0351a1b37a62f99462eb',  -- proxycheck.io API key
    cacheDuration = 7 * 24 * 60 * 60,  -- Cache IPs for 7 days (in seconds)
    whitelist = {
        -- Add IPs that should bypass VPN check
        -- ['127.0.0.1'] = true,
    },
    -- Country Blacklist (FULL country names as returned by proxycheck.io API)
    -- Players from these countries will be blocked
    blacklistedCountries = {
        -- ['Greece'] = true,
        -- ['China'] = true,
        -- ['Russia'] = true,
        -- ['Turkey'] = true,
        -- Add more countries as needed (use exact names from API logs)
    },
    countryBlacklistEnabled = true,  -- Enable/Disable country blacklist
}

-- TOS (Terms of Service) Settings
Config.TOS = {
    enabled = true,  -- Enable/Disable TOS check on connect
    -- Custom TOS rules (shown in the card)
    rules = {
        "Not use any cheats, hacks, or exploits",
        "Not use any mod menus or injectors",
        "Not exploit bugs or glitches",
        "Respect other players and staff",
        "Follow all server rules"
    }
}

-- Weather types
Config.WeatherTypes = {
    'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN',
    'THUNDER', 'CLEARING', 'NEUTRAL', 'SMOG', 'FOGGY',
    'XMAS', 'SNOWLIGHT', 'BLIZZARD'
}

-- Teleport locations
Config.TeleportLocations = {
    { name = 'Legion Square', coords = vector3(195.17, -933.77, 30.69) },
    { name = 'Airport', coords = vector3(-1037.35, -2737.81, 20.17) },
    { name = 'Sandy Shores', coords = vector3(1848.73, 3694.04, 34.27) },
    { name = 'Paleto Bay', coords = vector3(-379.53, 6118.32, 31.85) },
    { name = 'Mount Chiliad', coords = vector3(450.72, 5566.61, 806.18) },
    { name = 'Maze Bank Tower', coords = vector3(-75.01, -818.23, 326.18) },
}

-- Vehicle categories (Admin/Mod)
Config.VehicleCategories = {
    ['Server Cars'] = { 'issi4', 'issi5', 'towtruck2', 'tractor', 'scrap', 'peyote2', 'ratloader2', 'slamvan2', 'ratloader', 'slamvan4', 'impaler2', 'dominator4', 'yosemite2', 'voodoo2', 'journey', 'surfer2' },
    ['Apocalypse'] = { 'cerberus', 'cerberus3', 'emperor2', 'rebel', 'dloader', 'technical2', 'blazer', 'dune', 'bodhi2', 'bruiser', 'bfinjection', 'zhaba', 'wastelander', 'pbus2' },
    ['Motorcycles'] = { 'sanctus', 'enduro', 'ratbike', 'zombie', 'gargoyle', 'tornado4', 'tornado6' },
}

-- SuperAdmin extra vehicles
Config.SuperAdminVehicles = {
    ['Sports'] = { 'adder', 'zentorno', 't20', 'turismor', 'osiris' },
    ['Muscle'] = { 'dominator', 'gauntlet', 'sabregt', 'vigero', 'phoenix' },
    ['SUV'] = { 'baller', 'cavalcade', 'granger', 'dubsta', 'huntley' },
    ['Helicopters'] = { 'buzzard', 'maverick', 'frogger', 'polmav', 'savage' },
    ['Planes'] = { 'lazer', 'hydra', 'besra', 'cuban800', 'duster' },
    ['Boats'] = { 'dinghy', 'jetmax', 'marquis', 'speeder', 'tug' },
    ['Military'] = { 'rhino', 'insurgent', 'barrage', 'apc', 'khanjali' },
}

-- ============================================
-- ============================================
-- ANTICHEAT CONFIGURATION
-- ============================================
-- Complete anticheat settings - ALL detections configurable
-- Set violations to 1 for INSTANT BAN, or higher for more tolerance
-- ============================================
Config.Anticheat = {
    -- Master switch - Enable/Disable entire anticheat
    enabled = true,
    
    -- ════════════════════════════════════════
    -- SPAM DETECTION
    -- ════════════════════════════════════════
    spamDetection = {
        enabled = true,
        action = 'ban',  -- 'ban' or 'kick' - what to do when spam detected
        
        vehicles = {
            enabled = true,
            shortWindow = 3,     -- 3 vehicles in 5 seconds
            mediumWindow = 6,    -- 6 vehicles in 15 seconds
            longWindow = 10,     -- 10 vehicles in 30 seconds
            sameModel = 4,       -- 4 same model = suspicious
            nearbyRadius = 50.0, -- Check within 50m
            actionSeverity = 8,  -- Severity 8+ = ban/kick
            warnSeverity = 6,    -- Severity 6+ = warning
        },
        
        props = {
            enabled = true,
            shortWindow = 5,
            mediumWindow = 10,
            longWindow = 20,
            sameModel = 6,
            nearbyRadius = 30.0,
            actionSeverity = 8,
            warnSeverity = 6,
        },
        
        peds = {
            enabled = true,
            shortWindow = 3,
            mediumWindow = 5,
            longWindow = 8,
            sameModel = 4,
            nearbyRadius = 40.0,
            actionSeverity = 8,
            warnSeverity = 6,
        },
    },
    
    -- ════════════════════════════════════════
    -- VIOLATIONS NEEDED BEFORE BAN
    -- 1 = instant ban, 2+ = needs multiple detections
    -- ════════════════════════════════════════
    violations = {
        -- Godmode Detection
        invincibleFlag = 1,      -- SetPlayerInvincible flag (1 = instant)
        superHealth = 1,         -- Health > maxHealth (1 = instant)
        superArmor = 1,          -- Armor > maxArmor (1 = instant)
        fallDamage = 1,          -- Fall damage immunity (1 = instant)
        bulletImmune = 1,        -- Bullet immunity (1 = instant)
        explosionImmune = 1,     -- Explosion immunity (1 = instant)
        fireImmune = 1,          -- Fire immunity (1 = instant)
        drownImmune = 1,         -- Drowning immunity (1 = instant)
        
        -- Movement Cheats
        noclip = 1,              -- Noclip/fly hack (1 = instant ban after detection)
        teleport = 2,            -- Teleport hack (2 = needs 2 violations)
        freecam = 1,             -- Freecam/spectate hack (1 = instant)
        speedhack = 1,           -- Speed hack (1 = instant)
        
        -- Combat Cheats
        aimbot = 3,              -- Increased from 1 (need more proof)
        silentAim = 5,           -- Increased from 1 (need more proof)
        triggerbot = 3,          -- Increased from 1
        
        -- Vision Cheats
        wallhack = 1,            -- Wallhack/shooting through walls (1 = instant)
        esp = 1,                 -- ESP detection (1 = instant)
        
        -- Spawn Cheats
        illegalVehicle = 1,      -- Spawned blacklisted vehicle (1 = instant)
        illegalWeapon = 1,       -- Spawned blacklisted weapon (1 = instant)
        illegalPed = 1,          -- Changed to blacklisted ped (1 = instant)
        weaponModifier = 1,      -- Infinite ammo/no reload (1 = instant)
        
        -- System Cheats
        resourceStop = 1,        -- Stopped server resource (1 = instant)
        heartbeatFail = 3,       -- Anticheat disabled (3 = needs 3 missed beats)
        selfHeal = 1,            -- Self heal without medic (1 = instant)
        selfRevive = 1,          -- Self revive without medic (1 = instant)
    },
    
    -- ════════════════════════════════════════
    -- DETECTION THRESHOLDS
    -- Fine-tune detection sensitivity
    -- ════════════════════════════════════════
    thresholds = {
        -- Health/Armor
        maxHealth = 250,         -- Max allowed health (default 200 + buffer)
        maxArmor = 100,          -- Max allowed armor
        maxMaxHealth = 300,      -- Max allowed max health value
        
        -- Fall Damage
        fallHeight = 15.0,       -- Minimum fall height (meters) to check
        fallMinDamage = 10,      -- Minimum damage expected from fall
        
        -- Bullet Immunity
        bulletMinShots = 5,      -- Minimum shots received to check
        bulletMinDamage = 20,    -- Minimum damage expected from bullets
        bulletCheckTime = 5000,  -- Time window to check (ms)
        
        -- Explosion Immunity
        explosionMinDamage = 15, -- Minimum damage expected from explosion
        explosionRadius = 10.0,  -- Radius to check for explosions
        
        -- Fire Immunity
        fireMinDamage = 20,      -- Minimum damage expected from fire
        fireDuration = 3000,     -- How long on fire before checking (ms)
        
        -- Drowning Immunity
        drownMinDamage = 50,     -- Minimum damage expected from drowning
        drownDuration = 30000,   -- How long underwater before checking (ms)
        
        -- Teleport Detection
        maxTeleportDistance = 150.0, -- Max distance per second (vehicles can go fast)
        teleportCheckInterval = 1000, -- Check interval (ms)
        
        -- ════════════════════════════════════════
        -- NOCLIP DETECTION v3.0 (Client-Side)
        -- ════════════════════════════════════════
        -- Wall Pass Detection
        wallPassRaysNeeded = 2,      -- Rays that must hit to confirm wall pass
        wallPassConsecutive = 2,     -- Consecutive wall passes before violation
        wallPassTotal = 6,           -- Total wall hits before violation
        
        -- Acceleration Detection
        maxNormalAcceleration = 25.0, -- Max acceleration on foot (m/s²)
        accelerationHistorySize = 10, -- Number of samples to analyze
        highAccelCount = 3,          -- High accel samples needed for violation
        
        -- Floating/Flying Detection
        floatingTimeThreshold = 10,  -- Ticks stationary in air (2 sec at 200ms)
        flyingTimeThreshold = 15,    -- Ticks flying without vehicle (3 sec)
        minFloatingHeight = 3.0,     -- Min height to check floating (meters)
        minFlyingHeight = 10.0,      -- Min height to check flying (meters)
        upwardNoclipSpeed = 5.0,     -- Vertical speed for upward noclip
        
        -- Phase/Swimming Detection
        phaseCountThreshold = 5,     -- Phase through object detections
        swimAirCountThreshold = 5,   -- Swimming in air detections
        animMismatchThreshold = 8,   -- Velocity/animation mismatch detections
        
        -- General Noclip
        noclipCheckInterval = 200,   -- Check interval (ms) - faster for v3.0
        maxVerticalSpeed = 50.0,     -- Max vertical speed (for jets etc)
        undergroundZ = -50.0,        -- Z level considered underground
        
        -- ════════════════════════════════════════
        -- NOCLIP DETECTION v3.0 (Server-Side)
        -- ════════════════════════════════════════
        serverNoclipCheckInterval = 500, -- Server check interval (ms)
        serverMaxFootSpeed = 15.0,   -- Max foot speed (m/s)
        serverMaxVehicleSpeed = 120.0, -- Max vehicle speed (m/s) ~430 km/h
        serverMaxAircraftSpeed = 200.0, -- Max aircraft speed (m/s)
        serverTeleportDistance = 150.0, -- Distance to consider teleport (meters)
        serverUndergroundZ = -50.0,  -- Z level considered underground
        serverVerticalNoclipSpeed = 10.0, -- Vertical speed for noclip detection
        serverSpeedViolations = 3,   -- Speed violations before detection
        serverTeleportViolations = 2, -- Teleport violations before detection
        serverFloatingTime = 6,      -- Ticks flying up before detection
        
        -- ════════════════════════════════════════
        -- AIMBOT DETECTION v3.0 (IMPROVED)
        -- ════════════════════════════════════════
        -- General Settings
        countNPCsForAimbot = true,  -- Set to true to count NPC hits for aimbot detection
                                      -- false = Only players count (RECOMMENDED for production)
                                      -- true = NPCs + Players count (for testing/debugging)
        
        -- Silent Aim
        silentAimMaxAngle = 12.0,    -- Increased from 10° (more tolerance)
        silentAimAngle30m = 8.0,     -- Increased from 6°
        silentAimAngle50m = 5.0,     -- Increased from 4°
        silentAimAngle100m = 3.0,    -- Increased from 2.5°
        silentAimViolations = 5,     -- Increased from 3 (need more proof)
        
        -- Headshot Analysis
        headshotRateThreshold = 75,  -- Increased from 70% (stricter)
        consecutiveHeadshotsThreshold = 7, -- Increased from 5 (more tolerance)
        longRangeHeadshotDistance = 50.0,
        longRangeHeadshotRate = 75,  -- Increased from 70%
        
        -- Bone Lock
        boneLockThreshold = 10,      -- Increased from 9 (out of 12 now)
        boneLockViolations = 3,      -- Increased from 2
        
        -- Aim Snap
        aimSnapSpeed = 600,          -- Increased from 600 (same, but with more checks)
        aimSnapStopSpeed = 80,       -- Same
        aimSnapViolations = 4,       -- Same (but needs 30 sec window)
        
        -- Smooth Aimbot
        smoothAimbotStdDev = 3,      -- Decreased from 5 (stricter - more robotic)
        smoothAimbotMinSpeed = 30,
        smoothAimbotMaxSpeed = 200,
        smoothAimbotViolations = 10,
        
        -- Triggerbot
        triggerbotReactionTime = 80,
        triggerbotSamples = 5,
        triggerbotViolations = 3,
        
        -- No Recoil
        noRecoilThreshold = 0.1,
        noRecoilCount = 8,
        noRecoilViolations = 3,
        
        -- Target Switch
        targetSwitchTime = 150,
        targetSwitchSamples = 5,
        
        -- Kill Rate
        maxKillsPerMinute = 30,
        
        -- Server-Side Combat Analysis
        serverHeadshotRate = 70,     -- Increased from 60%
        serverConsecutiveHeadshots = 8, -- Increased from 7
        serverHitRate = 80,          -- Increased from 75%
        serverKillsPerMinute = 15,   -- Increased from 12
        
        -- Self Heal Detection
        maxHealthGain = 50,          -- Max health gain per second without medic
        healCheckInterval = 1000,    -- Check interval (ms)
    },
    
    -- ════════════════════════════════════════
    -- BAN DURATIONS (in minutes)
    -- nil = permanent ban
    -- ════════════════════════════════════════
    banDurations = {
        -- Godmode (usually permanent)
        invincibleFlag = nil,    -- Permanent
        superHealth = nil,       -- Permanent
        superArmor = nil,        -- Permanent
        fallDamage = nil,        -- Permanent
        bulletImmune = nil,      -- Permanent
        explosionImmune = nil,   -- Permanent
        fireImmune = nil,        -- Permanent
        drownImmune = nil,       -- Permanent
        
        -- Movement Cheats
        noclip = nil,            -- Permanent
        teleport = nil,          -- Permanent
        freecam = nil,           -- Permanent
        speedhack = nil,         -- Permanent
        
        -- Combat Cheats
        aimbot = nil,            -- Permanent
        silentAim = nil,         -- Permanent
        triggerbot = nil,        -- Permanent
        
        -- Vision Cheats
        wallhack = nil,          -- Permanent
        esp = nil,               -- Permanent
        
        -- Spawn Cheats
        illegalVehicle = nil,    -- Permanent
        illegalWeapon = nil,     -- Permanent
        illegalPed = 1440,       -- 24 hours (might be accident)
        weaponModifier = nil,    -- Permanent
        
        -- System Cheats
        resourceStop = nil,      -- Permanent
        heartbeatFail = nil,     -- Permanent
        selfHeal = 1440,         -- 24 hours
        selfRevive = 1440,       -- 24 hours
        
        -- Default fallback
        default = 1440,          -- 24 hours
    },
    
    -- ════════════════════════════════════════
    -- ENABLE/DISABLE SPECIFIC DETECTIONS
    -- Set to false to disable a detection
    -- ════════════════════════════════════════
    detections = {
        -- Godmode
        invincibleFlag = true,
        superHealth = true,
        superArmor = true,
        fallDamage = true,
        bulletImmune = true,
        explosionImmune = true,
        fireImmune = true,
        drownImmune = true,
        
        -- Movement
        noclip = true,
        teleport = true,
        freecam = true,
        speedhack = true,
        
        -- Combat
        aimbot = true,
        silentAim = true,
        wallhack = true,
        esp = true,
        
        -- Spawn
        illegalVehicle = true,
        illegalWeapon = true,
        illegalPed = true,
        weaponModifier = true,
        
        -- System
        resourceStop = true,
        heartbeat = true,
        selfHeal = true,
        selfRevive = true,
    },
}

-- BLACKLISTED VEHICLES (These are NOT allowed - instant BAN)
-- All other vehicles are ALLOWED
Config.BlacklistedVehicles = {
    -- Military (OP)
    'rhino',            -- Tank
    'khanjali',         -- Tank
    'apc',              -- APC
    'insurgent',        -- Insurgent
    'insurgent2',       -- Insurgent Pick-Up
    'insurgent3',       -- Insurgent Pick-Up Custom
    'barrage',          -- Barrage
    'halftrack',        -- Half-track
    'trailersmall2',    -- Anti-Aircraft Trailer
    'chernobog',        -- Chernobog
    'thruster',         -- Jetpack
    'scarab',           -- Scarab
    'scarab2',          -- Scarab (Apocalypse)
    'scarab3',          -- Scarab (Future Shock)
    
    -- Weaponized Aircraft
    'lazer',            -- P-996 LAZER (Fighter Jet)
    'hydra',            -- Hydra (VTOL Jet)
    'strikeforce',      -- B-11 Strikeforce
    'starling',         -- LF-22 Starling
    'rogue',            -- Rogue
    'pyro',             -- Pyro
    'molotok',          -- V-65 Molotok
    'nokota',           -- P-45 Nokota
    'seabreeze',        -- Seabreeze
    'tula',             -- Tula
    'bombushka',        -- RM-10 Bombushka
    'mogul',            -- Mogul
    'hunter',           -- FH-1 Hunter
    'savage',           -- Savage
    'valkyrie',         -- Valkyrie
    'valkyrie2',        -- Valkyrie MOD.0
    'akula',            -- Akula
    'annihilator2',     -- Annihilator Stealth
    
    -- Weaponized Vehicles
    'oppressor',        -- Oppressor
    'oppressor2',       -- Oppressor Mk II
    'deluxo',           -- Deluxo (Flying Car)
    'vigilante',        -- Vigilante (Batmobile)
    'scramjet',         -- Scramjet
    'ruiner2',          -- Ruiner 2000
    'stromberg',        -- Stromberg
    'toreador',         -- Toreador
    'tampa3',           -- Weaponized Tampa
    'technical',        -- Technical
    'technical3',       -- Technical Custom
    'dune3',            -- Weaponized Dune FAV
    'menacer',          -- Menacer
    'pounder2',         -- Pounder Custom
    'speedo4',          -- Speedo Custom
    'mule4',            -- Mule Custom
    
    -- Orbital/Special
    'avenger',          -- Avenger
    'avenger2',         -- Avenger (Interior)
    'volatol',          -- Volatol
    'alkonost',         -- Alkonost
    'kosatka',          -- Kosatka (Submarine)
    
    -- Arena War (OP versions)
    'brutus',           -- Brutus
    'brutus2',          -- Brutus (Apocalypse)
    'brutus3',          -- Brutus (Future Shock)
    'cerberus2',        -- Cerberus (Future Shock)
    'deathbike',        -- Deathbike
    'deathbike2',       -- Deathbike (Apocalypse)
    'deathbike3',       -- Deathbike (Future Shock)
    'dominator5',       -- Dominator (Arena)
    'dominator6',       -- Dominator (Apocalypse)
    'impaler3',         -- Impaler (Future Shock)
    'impaler4',         -- Impaler (Arena)
    'imperator',        -- Imperator
    'imperator2',       -- Imperator (Apocalypse)
    'imperator3',       -- Imperator (Future Shock)
    'issi6',            -- Issi (Arena)
    'issi7',            -- Issi (Future Shock)
    'monster3',         -- Monster (Arena)
    'monster4',         -- Monster (Apocalypse)
    'monster5',         -- Monster (Future Shock)
    'sasquatch',        -- Sasquatch
    'sasquatch2',       -- Sasquatch (Apocalypse)
    'sasquatch3',       -- Sasquatch (Future Shock)
    'slamvan4',         -- Slamvan (Arena)
    'slamvan5',         -- Slamvan (Apocalypse)
    'slamvan6',         -- Slamvan (Future Shock)
    'zr380',            -- ZR380
    'zr3802',           -- ZR380 (Apocalypse)
    'zr3803',           -- ZR380 (Future Shock)
}

-- BLACKLISTED PEDS (Cannot transform into these = KICK)
Config.BlacklistedPeds = {
    -- Animals (cheaters often use these to fly/clip through walls)
    'a_c_boar', 'a_c_cat_01', 'a_c_chickenhawk', 'a_c_chimp', 'a_c_chop',
    'a_c_cormorant', 'a_c_cow', 'a_c_coyote', 'a_c_crow', 'a_c_deer',
    'a_c_dolphin', 'a_c_fish', 'a_c_hen', 'a_c_humpback', 'a_c_husky',
    'a_c_killerwhale', 'a_c_mtlion', 'a_c_pig', 'a_c_pigeon', 'a_c_poodle',
    'a_c_pug', 'a_c_rabbit_01', 'a_c_rat', 'a_c_retriever', 'a_c_rhesus',
    'a_c_rottweiler', 'a_c_seagull', 'a_c_sharkhammer', 'a_c_sharktiger',
    'a_c_shepherd', 'a_c_stingray', 'a_c_westy',
    -- Special/Alien peds that shouldn't be used
    's_m_m_movprem_01', 'u_m_y_militarybum', 'u_m_y_zombie_01',
    -- NOTE: mp_m_freemode_01 and mp_f_freemode_01 are NORMAL player peds - DO NOT BLACKLIST!
}

-- WHITELISTED WEAPONS (All others = BAN)
-- RPG, Minigun allowed - Railgun, etc NOT allowed
Config.AllowedWeapons = {
    -- Melee
    'WEAPON_UNARMED', 'WEAPON_KNIFE', 'WEAPON_NIGHTSTICK', 'WEAPON_HAMMER',
    'WEAPON_BAT', 'WEAPON_CROWBAR', 'WEAPON_GOLFCLUB', 'WEAPON_BOTTLE',
    'WEAPON_DAGGER', 'WEAPON_HATCHET', 'WEAPON_MACHETE', 'WEAPON_FLASHLIGHT',
    'WEAPON_SWITCHBLADE', 'WEAPON_KNUCKLE', 'WEAPON_STONE_HATCHET',
    'WEAPON_POOLCUE', 'WEAPON_WRENCH', 'WEAPON_BATTLEAXE',
    -- Pistols
    'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL',
    'WEAPON_PISTOL50', 'WEAPON_SNSPISTOL', 'WEAPON_SNSPISTOL_MK2', 'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL', 'WEAPON_MARKSMANPISTOL', 'WEAPON_REVOLVER', 
    'WEAPON_REVOLVER_MK2', 'WEAPON_DOUBLEACTION', 'WEAPON_CERAMICPISTOL',
    'WEAPON_NAVYREVOLVER', 'WEAPON_GADGETPISTOL', 'WEAPON_STUNGUN', 'WEAPON_FLAREGUN',
    -- SMGs
    'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_SMG_MK2', 'WEAPON_ASSAULTSMG',
    'WEAPON_COMBATPDW', 'WEAPON_MACHINEPISTOL', 'WEAPON_MINISMG',
    -- Shotguns
    'WEAPON_PUMPSHOTGUN', 'WEAPON_PUMPSHOTGUN_MK2', 'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_ASSAULTSHOTGUN', 'WEAPON_BULLPUPSHOTGUN', 'WEAPON_HEAVYSHOTGUN',
    'WEAPON_DBSHOTGUN', 'WEAPON_AUTOSHOTGUN', 'WEAPON_COMBATSHOTGUN', 'WEAPON_MUSKET',
    -- Assault Rifles
    'WEAPON_ASSAULTRIFLE', 'WEAPON_ASSAULTRIFLE_MK2', 'WEAPON_CARBINERIFLE',
    'WEAPON_CARBINERIFLE_MK2', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE',
    'WEAPON_SPECIALCARBINE_MK2', 'WEAPON_BULLPUPRIFLE', 'WEAPON_BULLPUPRIFLE_MK2',
    'WEAPON_COMPACTRIFLE', 'WEAPON_MILITARYRIFLE', 'WEAPON_HEAVYRIFLE', 'WEAPON_TACTICALRIFLE',
    -- Machine Guns
    'WEAPON_MG', 'WEAPON_COMBATMG', 'WEAPON_COMBATMG_MK2', 'WEAPON_GUSENBERG',
    -- Sniper Rifles
    'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_HEAVYSNIPER_MK2',
    'WEAPON_MARKSMANRIFLE', 'WEAPON_MARKSMANRIFLE_MK2', 'WEAPON_PRECISIONRIFLE',
    -- Heavy Weapons (RPG, Minigun ALLOWED)
    'WEAPON_RPG', 'WEAPON_MINIGUN', 'WEAPON_GRENADELAUNCHER', 'WEAPON_GRENADELAUNCHER_SMOKE',
    'WEAPON_FIREWORK', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_COMPACTLAUNCHER',
    -- Throwables
    'WEAPON_GRENADE', 'WEAPON_BZGAS', 'WEAPON_MOLOTOV', 'WEAPON_STICKYBOMB',
    'WEAPON_PROXMINE', 'WEAPON_SNOWBALL', 'WEAPON_PIPEBOMB', 'WEAPON_BALL',
    'WEAPON_SMOKEGRENADE', 'WEAPON_FLARE',
    -- Misc
    'WEAPON_PETROLCAN', 'WEAPON_FIREEXTINGUISHER', 'WEAPON_HAZARDCAN', 'WEAPON_FERTILIZERCAN',
    'WEAPON_PARACHUTE',
}

-- BLACKLISTED WEAPONS (These are NOT allowed - instant BAN)
Config.BlacklistedWeapons = {
    'WEAPON_RAILGUN',           -- Railgun
    'WEAPON_RAYPISTOL',         -- Up-n-Atomizer
    'WEAPON_RAYCARBINE',        -- Unholy Hellbringer
    'WEAPON_RAYMINIGUN',        -- Widowmaker
    'WEAPON_EMPLAUNCHER',       -- EMP Launcher
}

-- ============================================
-- BLACKLISTED VEHICLE PLATES
-- Detects cheaters who change vehicle plates
-- ============================================
Config.BlacklistedPlates = {
    -- Common cheat menu signatures
    'EULEN',
    'eulen',
    'MODEST',
    'modest',
    'LYNX',
    'lynx',
    'KIDDION',
    'kiddion',
    'PHANTOM',
    'phantom',
    'CHERAX',
    'cherax',
    'STAND',
    'stand',
    '2TAKE1',
    '2take1',
    'IMPULSE',
    'impulse',
    'PARAGON',
    'paragon',
    'OZARK',
    'ozark',
    'DISTURBED',
    'disturbed',
    'LUNA',
    'luna',
    'TERROR',
    'terror',
    'XCHEATS',
    'xcheats',
    'REDENGINE',
    'redengine',
    
    -- Common troll plates
    'HACKER',
    'hacker',
    'CHEATER',
    'cheater',
    'MODDER',
    'modder',
    'ADMIN',  -- Fake admin plates
    'GOD',
    'IDDQD',  -- Classic god mode cheat
    
    -- Add more as needed
}

Config.PlateCheckInterval = 5000 -- Check every 5 seconds

-- ============================================
-- MECHANIC SHOP ZONES (Safe zones for vehicle modifications)
-- Players can only modify vehicles inside these zones
-- ============================================
Config.MechanicShops = {
    -- Los Santos Customs
    { coords = vector3(-337.0, -136.0, 39.0), radius = 30.0, name = "LS Customs (Burton)" },
    { coords = vector3(-1155.0, -2007.0, 13.0), radius = 30.0, name = "LS Customs (Airport)" },
    { coords = vector3(731.0, -1089.0, 22.0), radius = 30.0, name = "LS Customs (La Mesa)" },
    { coords = vector3(1175.0, 2640.0, 37.0), radius = 30.0, name = "LS Customs (Harmony)" },
    { coords = vector3(110.0, 6626.0, 31.0), radius = 30.0, name = "LS Customs (Paleto Bay)" },
    
    -- Benny's
    { coords = vector3(-205.0, -1308.0, 31.0), radius = 35.0, name = "Benny's Original Motor Works" },
    
    -- Beeker's Garage
    { coords = vector3(105.0, 6613.0, 32.0), radius = 30.0, name = "Beeker's Garage" },
    
    -- Add your custom mechanic shops here
    -- { coords = vector3(x, y, z), radius = 30.0, name = "Custom Mechanic" },
}

Config.VehicleModCheckInterval = 2000 -- Check every 2 seconds

-- WHITELISTED PROPS (Only these are allowed to be spawned by non-admins)
-- Commonjob props like barriers, cones, and spikes
Config.WhitelistedProps = {
    -- Police/Job Barriers
    'prop_barrier_work01a',
    'prop_barrier_work02a',
    'prop_barrier_work05',
    'prop_barrier_work06a',
    'prop_mp_barrier_02b',
    'prop_mp_barrier_02',
    
    -- Traffic Cones
    'prop_roadcone01a',
    'prop_roadcone02a',
    'prop_roadcone02b',
    'prop_roadcone02c',
    
    -- Spikes (Stinger)
    'p_ld_stinger_s',
    'p_spike_s',
    
    -- Work Equipment
    'prop_worklight_03a',
    'prop_worklight_04a',
    'prop_toolchest_01',
    'prop_generator_01a',
    
    -- Medical
    'prop_ld_health_pack',
    'p_med_bag_01',
    'p_med_bag_01_s',
}
