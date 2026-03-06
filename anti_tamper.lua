-- ============================================
-- AETHER ANTICHEAT v1.5 - ANTI-TAMPER
-- Simple & Effective Protection
-- Coded by konpep
-- ============================================

-- Obfuscated strings
local _0x4a2f = {0x6b,0x6f,0x6e,0x70,0x65,0x70}  -- konpep
local _0x7b3e = {0x41,0x65,0x74,0x68,0x65,0x72}  -- Aether
local _0x9c1d = function(t) local s="" for _,v in ipairs(t) do s=s..string.char(v) end return s end
local _a = _0x9c1d(_0x4a2f)
local _s = _0x9c1d(_0x7b3e)
local _0x2e5f = false  -- tampered
local _0x8d4c = false  -- protected

-- Obfuscated function names
local _0xf1a3 = function()  -- FileExists
    local _0xb7c2 = GetResourcePath(GetCurrentResourceName()) .. '/anti_tamper.lua'
    local _0x3d8e = io.open(_0xb7c2, 'r')
    if not _0x3d8e then return false end
    local _0x6f1a = _0x3d8e:read('*all')
    _0x3d8e:close()
    return #_0x6f1a > 50 and string.find(_0x6f1a, _a)
end

local _0xe4b9 = function()  -- CheckManifest
    local _0xc5d1 = GetResourcePath(GetCurrentResourceName()) .. '/fxmanifest.lua'
    local _0xa2f7 = io.open(_0xc5d1, 'r')
    if not _0xa2f7 then return false end
    local _0x9b3c = _0xa2f7:read('*all')
    _0xa2f7:close()
    
    local _0x1e6d = string.find(_0x9b3c, "author '%s*" .. _a) or 
                    string.find(_0x9b3c, 'author "' .. _a .. '"') or
                    string.find(_0x9b3c, "author '" .. _a .. "'")
    
    local _0x4f8a = string.find(_0x9b3c, _s) or string.find(_0x9b3c, string.lower(_s))
    local _0x7c2b = string.find(_0x9b3c, "anti_tamper")
    
    return _0x1e6d and _0x4f8a and _0x7c2b
end

-- Initialize
CreateThread(function()
    Wait(500)
    
    local _0x5d9e = _0xf1a3()
    local _0x3a7f = _0xe4b9()
    
    if _0x5d9e and _0x3a7f then
        _0x8d4c = true
        print('[PROTECTION] ✅ Verified - Coded by ' .. _a)
    else
        _0x2e5f = true
        print('========================================')
        print('PROTECTION ACTIVE - Script Tampered')
        print('All connections blocked')
        print('========================================')
    end
end)

-- Block connections
AddEventHandler('playerConnecting', function(name, skip, def)
    if (GlobalBanBlocked and GlobalBanBlocked[source]) or (LocalBanBlocked and LocalBanBlocked[source]) then return end
    if _0x2e5f or not _0x8d4c then
        def.defer()
        Wait(50)
        def.update('Checking security...')
        Wait(500)
        
        def.done([[


    ⚠️  PROTECTION ACTIVE  ⚠️

    Script integrity violation detected.
    All connections are blocked.

    Server Owner:
    - Download original from GitHub
    - Do not remove author credits
    - Respect the developer

    This protection cannot be bypassed.


        ]])
    end
end)

-- Periodic check
CreateThread(function()
    while true do
        Wait(180000)
        if _0x8d4c and not _0x2e5f then
            if not _0xf1a3() or not _0xe4b9() then
                _0x2e5f = true
                _0x8d4c = false
                for _, _0x6e2a in ipairs(GetPlayers()) do
                    DropPlayer(_0x6e2a, 'Protection activated')
                end
            end
        end
    end
end)

-- Exports
exports('IsProtected', function() return _0x8d4c and not _0x2e5f end)
exports('IsTampered', function() return _0x2e5f end)
