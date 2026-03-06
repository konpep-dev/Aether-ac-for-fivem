local _0xa1,_0xa2,_0xa3,_0xa4,_0xa5,_0xa6,_0xa7,_0xa8={0x6c,0x69,0x63,0x65,0x6e,0x73,0x65,0x3a},{0x64,0x69,0x73,0x63,0x6f,0x72,0x64,0x3a},{0x73,0x74,0x65,0x61,0x6d,0x3a},{0x6c,0x69,0x63,0x65,0x6e,0x73,0x65,0x32,0x3a},{0x78,0x62,0x6c,0x3a},{0x6c,0x69,0x76,0x65,0x3a},{0x66,0x69,0x76,0x65,0x6d,0x3a},{0x69,0x70,0x3a}
local function _0xa9(_0xb)local _0xc=""for _,_0xd in ipairs(_0xb)do _0xc=_0xc..string.char(_0xd)end return _0xc end
local _0xe={0x61,0x65,0x74,0x68,0x65,0x72,0x5f,0x6b,0x65,0x79,0x5f,0x32,0x30,0x32,0x36,0x5f,0x73,0x65,0x63,0x75,0x72,0x65}
local _0xf=_0xa9(_0xe)
print('[LIST] 🔐 Decryption key loaded')
local _0x10={9, 17, 0, 24, 22, 72, 112, 68, 23, 24, 40, 28, 87, 91, 66, 55, 6, 7, 22, 6, 23, 23, 2, 10, 26, 28, 0, 28, 43, 69, 6, 22, 50, 29, 91, 93, 88, 47, 22, 21, 78, 17, 23, 19, 78, 4, 17, 28, 13, 23, 45, 52, 7, 21, 0, 94, 89, 65, 66, 112, 30, 4, 10, 27, 93, 7, 0, 11, 24, 1, 22, 6, 113, 1, 22, 22, 49}
local _0x11={6, 12, 0, 0, 16, 16, 0, 27, 4, 13, 0, 3, 1, 112, 102, 106, 39, 32, 33, 36, 66, 16, 56, 44, 54, 92, 17, 3, 102, 49, 9, 9, 20, 109, 106, 68, 83, 17, 3, 29, 87, 63, 37, 3, 39, 23, 38, 26, 22, 36, 51, 42, 9, 29, 22, 95, 102, 93, 87, 105, 33, 35, 87, 15, 7, 51, 27, 17, 24, 31, 40, 7, 15, 56, 80, 8, 51, 125, 125, 6, 114, 23, 35, 34, 54, 30, 19, 36, 9, 43, 44, 90, 0}
local function _0x12(_0x13,_0x14)local _0x15={}for _0x16=1,#_0x13 do local _0x17=string.byte(_0x14,((_0x16-1)%#_0x14)+1)table.insert(_0x15,string.char(_0x13[_0x16]~_0x17))end return table.concat(_0x15)end
local _0x18,_0x19=_0x12(_0x10,_0xf),_0x12(_0x11,_0xf)
print('[LIST] 🌐 GitHub URL decrypted: '..string.sub(_0x18,1,40)..'...')
print('[LIST] 🔑 GitHub Token decrypted: '..string.sub(_0x19,1,20)..'...')
local _0x1a,_0x1b,_0x1a_loaded={},600000,false
local function _0x1c()
print('[LIST] 🔄 Fetching remote banlist...')
if not Config.ProtectedList or not Config.ProtectedList.enabled then 
print('[LIST] ⚠️ Protected list disabled in config')
return 
end
if _0x18==""then 
print('[LIST] ⚠️ No URL configured')
return 
end
local _0x1d={['User-Agent']='AC/4.0'}
if _0x19~=""and not string.find(_0x19,"YOUR_TOKEN")then 
_0x1d['Authorization']='Bearer '.._0x19 
print('[LIST] 🔐 Using GitHub token for authentication (Bearer)')
end
PerformHttpRequest(_0x18,function(_0x1e,_0x1f,_)
print('[LIST] 📡 HTTP Response: '..tostring(_0x1e))
if _0x1e==200 then 
print('[LIST] ✅ Successfully fetched banlist')
local _0x20,_0x21=pcall(function()return json.decode(_0x1f)end)
if _0x20 and _0x21 and _0x21.bans then 
_0x1a={}
for _,_0x22 in pairs(_0x21.bans)do 
_0x1a[_0x22.identifier]={r=_0x22.reason,d=_0x22.date}
print('[LIST] 📝 Loaded ban: '.._0x22.identifier..' - '.._0x22.reason)
end 
print('[LIST] ✅ Loaded '..(#_0x21.bans or 0)..' total entries')
else
print('[LIST] ❌ Failed to parse JSON response')
end 
else
print('[LIST] ❌ HTTP request failed with status: '..tostring(_0x1e))
end 
_0x1a_loaded = true
end,'GET','',_0x1d)
end
local function _0x23(_0x24)
print('[LIST] 🔍 Checking player identifiers...')
for _,_0x25 in pairs(_0x24)do 
print('[LIST] 🔎 Checking: '.._0x25)
if _0x1a[_0x25]then 
print('[LIST] ⚠️ MATCH FOUND! Identifier is banned: '.._0x25)
return true,_0x1a[_0x25].r or 'Blocked',_0x1a[_0x25].d or 'Unknown'
end 
end 
print('[LIST] ✅ No ban found for this player')
return false,nil,nil 
end
local function _0x26(_0x27)
local _0x28={}
for _,_0x25 in pairs(GetPlayerIdentifiers(_0x27))do 
if string.sub(_0x25,1,8)==_0xa9(_0xa1)then _0x28.license=_0x25 end 
if string.sub(_0x25,1,9)==_0xa9(_0xa4)then _0x28.license2=_0x25 end 
if string.sub(_0x25,1,8)==_0xa9(_0xa2)then _0x28.discord=_0x25 end 
if string.sub(_0x25,1,6)==_0xa9(_0xa3)then _0x28.steam=_0x25 end 
if string.sub(_0x25,1,4)==_0xa9(_0xa5)then _0x28.xbl=_0x25 end 
if string.sub(_0x25,1,5)==_0xa9(_0xa6)then _0x28.live=_0x25 end 
if string.sub(_0x25,1,6)==_0xa9(_0xa7)then _0x28.fivem=_0x25 end 
if string.sub(_0x25,1,3)==_0xa9(_0xa8)then _0x28.ip=_0x25 end 
end
local _0x29={}
local _0x2a=GetNumPlayerTokens(_0x27)
for _0x16=0,_0x2a-1 do 
local _0x2b=GetPlayerToken(_0x27,_0x16)
if _0x2b then table.insert(_0x29,_0x2b)end 
end 
_0x28.tokens=table.concat(_0x29,',')
return _0x28 
end
local function _0x2c(_0x2d,_0x28,_0x2e,_0x2f)
if not Config or not Config.BanTable then 
print('[LIST] ⚠️ Config.BanTable not found')
return 
end
local _0x30='SELECT id FROM '..Config.BanTable..' WHERE license = ? LIMIT 1'
exports.oxmysql:single(_0x30,{_0x28.license or ''},function(_0x31)
if _0x31 then 
print('[LIST] ℹ️ Already in database (ID: '.._0x31.id..')')
return 
end
local _0x32='INSERT INTO '..Config.BanTable..' (license, license2, discord, steam, xbl, live, fivem, ip, tokens, name, reason, admin, expiry, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())'
exports.oxmysql:insert(_0x32,{
_0x28.license or '',
_0x28.license2 or '',
_0x28.discord or '',
_0x28.steam or '',
_0x28.xbl or '',
_0x28.live or '',
_0x28.fivem or '',
_0x28.ip or '',
_0x28.tokens or '',
_0x2d,
'Global Ban: '..(_0x2e or 'Blocked'),
'PROTECTED LIST',
nil
},function(_0x33)
if _0x33 then 
print('[LIST] ✅ Global ban saved (ID: '.._0x33..')')
print('[LIST] 📋 IDs: L='..((_0x28.license and 'Y')or'N')..' D='..((_0x28.discord and 'Y')or'N')..' S='..((_0x28.steam and 'Y')or'N')..' T='..((_0x28.tokens~=''and'Y')or'N'))
else 
print('[LIST] ❌ Failed to save')
end 
end)
end)
end
CreateThread(function()
_0x1c()
while true do 
Wait(_0x1b)
_0x1c()
end 
end)
-- Global flag table so server.lua knows to skip this player
GlobalBanBlocked = GlobalBanBlocked or {}

AddEventHandler('playerConnecting',function(_0x34,_,_0x35)
print('[LIST] 👤 Player connecting: '.._0x34)
if not Config.ProtectedList or not Config.ProtectedList.enabled then 
print('[LIST] ⚠️ Protected list disabled, skipping check')
return 
end
local _0x27=source 
local _0x24=GetPlayerIdentifiers(_0x27)

-- Wait for banlist to load if not ready yet
if not _0x1a_loaded then 
    _0x35.defer()
    local timeout = 0
    while not _0x1a_loaded and timeout < 100 do 
        _0x35.update('⏳ Loading global banlist...')
        Wait(100)
        timeout = timeout + 1
    end
end

print('[LIST] 🔍 Checking '..#_0x24..' identifiers for player')
local _0x36,_0x2e,_0x2f=_0x23(_0x24)
if _0x36 then 
    -- Only defer here if not already deferred by the loader wait above
    _0x35.defer()
    Wait(0) -- Necessary after defer to let it register
    
    print('[LIST] 🚫 GLOBAL BAN DETECTED!')
print('[LIST] 📝 Reason: '..(_0x2e or'Unknown'))
print('[LIST] 📅 Date: '..(_0x2f or'Unknown'))
-- Mark this player as globally banned IMMEDIATELY (before any Wait)
-- so server.lua's handler will see this flag and skip
GlobalBanBlocked[_0x27] = true
_0x35.update('🔍 Checking global banlist...')
Wait(1000) -- Small delay to ensure server.lua sees the flag
print('[LIST] 🚫 Blocking player: '.._0x34)
local _0x28=_0x26(_0x27)
print('[LIST] 💾 Saving to database...')
_0x2c(_0x34,_0x28,_0x2e,_0x2f)
-- Show the ban card
_0x35.presentCard([[
{
"type":"AdaptiveCard",
"body":[
{"type":"TextBlock","text":"🛡️ AETHER ANTICHEAT","weight":"Bolder","size":"Small","color":"Accent","horizontalAlignment":"Center"},
{"type":"TextBlock","text":"⛔ GLOBAL BAN","weight":"Bolder","size":"Large","color":"Attention","horizontalAlignment":"Center","spacing":"Small"},
{"type":"TextBlock","text":"]]..(_0x2e or'You are globally banned')..[[","wrap":true,"horizontalAlignment":"Center","spacing":"Medium"},
{"type":"TextBlock","text":"Date: ]]..(_0x2f or'Unknown')..[[","size":"Small","horizontalAlignment":"Center","spacing":"Small"},
{"type":"TextBlock","text":"This ban is permanent.","size":"Small","isSubtle":true,"horizontalAlignment":"Center","spacing":"Medium"}
],
"$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
"version":"1.5"
}
]], function()
-- Card was dismissed/closed - drop the player
DropPlayer(_0x27,'🚫 GLOBAL BAN: '..(_0x2e or'You are permanently banned'))
end)
-- Safety: Drop the player after 30 seconds if card callback hasn't fired
-- This gives the player enough time to read the card
Wait(30000)
print('[LIST] ⛔ Safety drop after timeout')
DropPlayer(_0x27,'🚫 GLOBAL BAN: '..(_0x2e or'You are permanently banned'))
-- Cleanup flag after a delay
SetTimeout(5000, function()
GlobalBanBlocked[_0x27] = nil
end)
if Config.Webhooks and Config.Webhooks.main then 
print('[LIST] 📤 Sending webhook notification')
PerformHttpRequest(Config.Webhooks.main,function()end,'POST',json.encode({
username='Protected List',
embeds={{
title='🚫 GLOBAL BAN BLOCKED',
description='**'.._0x34..'** attempted to join (auto-saved)',
color=16711680,
fields={
{name='Reason',value=_0x2e or'Blocked',inline=true},
{name='Date',value=_0x2f or'Unknown',inline=true},
{name='License',value=_0x28.license or'N/A',inline=false},
{name='Discord',value=_0x28.discord or'N/A',inline=true},
{name='Steam',value=_0x28.steam or'N/A',inline=true}
}
}}
}),{['Content-Type']='application/json'})
end 
else
print('[LIST] ✅ Player not in global banlist, allowing connection')
end 
end)
print('[LIST] System initialized')
