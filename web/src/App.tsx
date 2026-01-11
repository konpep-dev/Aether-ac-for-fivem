import { useState, useEffect, useRef } from 'react'
import { Player, Location, VehicleCategories, NuiMessage, AdminPerms, Report, AdminUser, LogEntry, InventoryData, BanEntry } from './types'
import { fetchNui, isEnvBrowser } from './utils/nui'

type Tab = 'players' | 'self' | 'world' | 'vehicles' | 'server' | 'reports' | 'items' | 'permissions' | 'logs' | 'bans' | 'anticheat'

function App() {
  const [visible, setVisible] = useState(false)
  const [activeTab, setActiveTab] = useState<Tab>('players')
  const [players, setPlayers] = useState<Player[]>([])
  const [reports, setReports] = useState<Report[]>([])
  const [items, setItems] = useState<any[]>([])
  const [admins, setAdmins] = useState<AdminUser[]>([])
  const [weather, setWeather] = useState<string[]>([])
  const [locations, setLocations] = useState<Location[]>([])
  const [vehicles, setVehicles] = useState<VehicleCategories>({})
  const [adminGroup, setAdminGroup] = useState<string>('')
  const [adminPerms, setAdminPerms] = useState<AdminPerms | null>(null)
  
  // Self toggles
  const [godMode, setGodMode] = useState(false)
  const [invisible, setInvisible] = useState(false)
  const [noclip, setNoclip] = useState(false)
  
  // World controls
  const [selectedWeather, setSelectedWeather] = useState('')
  const [hour, setHour] = useState(12)
  const [minute, setMinute] = useState(0)
  
  // Server controls
  const [announcement, setAnnouncement] = useState('')
  const [kickReason, setKickReason] = useState('')
  const [banReason, setBanReason] = useState('')
  const [banDuration, setBanDuration] = useState(0)
  const [selectedPlayer, setSelectedPlayer] = useState<number | null>(null)
  
  // ESP
  const [espEnabled, setEspEnabled] = useState(false)
  
  // Logs
  const [logs, setLogs] = useState<LogEntry[]>([])
  
  // Bans
  const [bans, setBans] = useState<BanEntry[]>([])
  
  // Anticheat Debug Mode
  const [anticheatDebug, setAnticheatDebug] = useState(false)
  
  // Screenshot
  const [screenshot, setScreenshot] = useState<{image: string, name: string} | null>(null)
  
  // Inventory viewer
  const [viewingInventory, setViewingInventory] = useState<InventoryData | null>(null)
  
  // Dragging
  const panelRef = useRef<HTMLDivElement>(null)
  const [position, setPosition] = useState({ x: 0, y: 0 })
  const [dragging, setDragging] = useState(false)
  const dragOffset = useRef({ x: 0, y: 0 })

  useEffect(() => {
    const handleMessage = (event: MessageEvent<NuiMessage>) => {
      const { action } = event.data
      
      if (action === 'open') {
        setVisible(true)
        setAdminGroup(event.data.group || '')
        setAdminPerms(event.data.perms || null)
        setWeather(event.data.weather || [])
        setLocations(event.data.locations || [])
        setVehicles(event.data.vehicles || {})
        fetchNui('refreshPlayers')
        fetchNui('getReports')
      } else if (action === 'close') {
        setVisible(false)
      } else if (action === 'updatePlayers') {
        setPlayers(event.data.players || [])
      } else if (action === 'updateItems') {
        setItems(event.data.items || [])
      } else if (action === 'updateReports') {
        setReports(event.data.reports || [])
      } else if (action === 'newReport') {
        if (event.data.report) setReports(prev => [...prev, event.data.report!])
      } else if (action === 'updateReport') {
        if (event.data.report) setReports(prev => prev.map(r => r.id === event.data.report!.id ? event.data.report! : r))
      } else if (action === 'closeReport') {
        setReports(prev => prev.filter(r => r.id !== event.data.id))
      } else if (action === 'updateAdmins') {
        setAdmins(event.data.admins || [])
      } else if (action === 'updateLogs') {
        setLogs(event.data.logs || [])
      } else if (action === 'showScreenshot') {
        setScreenshot({ image: event.data.image || '', name: event.data.targetName || 'Unknown' })
      } else if (action === 'showInventory' || action === 'updateInventory') {
        setViewingInventory(event.data.inventory || null)
      } else if (action === 'updateBans') {
        setBans(event.data.bans || [])
      } else if (action === 'updateDebugMode') {
        setAnticheatDebug(event.data.enabled || false)
      }
    }

    window.addEventListener('message', handleMessage)
    return () => window.removeEventListener('message', handleMessage)
  }, [])

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && visible) handleClose()
    }
    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [visible])

  const handleMouseDown = (e: React.MouseEvent) => {
    if ((e.target as HTMLElement).closest('.header')) {
      setDragging(true)
      dragOffset.current = { x: e.clientX - position.x, y: e.clientY - position.y }
    }
  }

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      if (dragging) setPosition({ x: e.clientX - dragOffset.current.x, y: e.clientY - dragOffset.current.y })
    }
    const handleMouseUp = () => setDragging(false)
    window.addEventListener('mousemove', handleMouseMove)
    window.addEventListener('mouseup', handleMouseUp)
    return () => { window.removeEventListener('mousemove', handleMouseMove); window.removeEventListener('mouseup', handleMouseUp) }
  }, [dragging])

  const handleClose = () => { setVisible(false); fetchNui('close') }

  if (!visible && !isEnvBrowser()) return null

  const availableTabs: Tab[] = ['players', 'self', 'world', 'vehicles', 'server', 'reports']
  if (adminPerms?.giveItem) availableTabs.push('items')
  if (adminPerms?.managePerms) availableTabs.push('permissions')
  if (adminPerms?.ban) availableTabs.push('bans')
  if (adminGroup === 'superadmin') availableTabs.push('anticheat')
  availableTabs.push('logs') // All admins can view logs

  return (
    <div id="container">
      <div className="panel" ref={panelRef} style={{ transform: `translate(${position.x}px, ${position.y}px)` }} onMouseDown={handleMouseDown}>
        <div className="corner-bl" /><div className="corner-br" />
        <div className="header">
          <h2>AETHER AC ({adminGroup?.toUpperCase() || 'ADMIN'})</h2>
          <button className="close-btn" onClick={handleClose}>✕</button>
        </div>
        <div className="tabs">
          {availableTabs.map(tab => (
            <button key={tab} className={`tab ${activeTab === tab ? 'active' : ''}`} onClick={() => setActiveTab(tab)}>{tab.toUpperCase()}</button>
          ))}
        </div>
        <div className="content">
          {activeTab === 'players' && <PlayersTab players={players} kickReason={kickReason} setKickReason={setKickReason} banReason={banReason} setBanReason={setBanReason} banDuration={banDuration} setBanDuration={setBanDuration} selectedPlayer={selectedPlayer} setSelectedPlayer={setSelectedPlayer} adminPerms={adminPerms} espEnabled={espEnabled} setEspEnabled={setEspEnabled} />}
          {activeTab === 'self' && <SelfTab godMode={godMode} setGodMode={setGodMode} invisible={invisible} setInvisible={setInvisible} noclip={noclip} setNoclip={setNoclip} locations={locations} adminPerms={adminPerms} adminGroup={adminGroup} />}
          {activeTab === 'world' && <WorldTab weather={weather} selectedWeather={selectedWeather} setSelectedWeather={setSelectedWeather} hour={hour} setHour={setHour} minute={minute} setMinute={setMinute} adminPerms={adminPerms} />}
          {activeTab === 'vehicles' && <VehiclesTab vehicles={vehicles} adminPerms={adminPerms} adminGroup={adminGroup} />}
          {activeTab === 'server' && <ServerTab announcement={announcement} setAnnouncement={setAnnouncement} adminPerms={adminPerms} />}
          {activeTab === 'reports' && <ReportsTab reports={reports} />}
          {activeTab === 'items' && <ItemsTab items={items} players={players} adminGroup={adminGroup} />}
          {activeTab === 'permissions' && <PermissionsTab admins={admins} players={players} />}
          {activeTab === 'bans' && <BanListTab bans={bans} />}
          {activeTab === 'anticheat' && <AnticheatTab players={players} debugMode={anticheatDebug} setDebugMode={setAnticheatDebug} />}
          {activeTab === 'logs' && <LogsTab logs={logs} />}
        </div>
        <div className="footer"><p>INS: Open • DEL: Noclip • ESC: Close • Reports: {reports.length}</p></div>
      </div>
      
      {/* Screenshot Modal */}
      {screenshot && (
        <div className="modal-overlay" onClick={() => setScreenshot(null)}>
          <div className="modal" onClick={e => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Screenshot: {screenshot.name}</h3>
              <button className="close-btn" onClick={() => setScreenshot(null)}>✕</button>
            </div>
            <div className="modal-content">
              <img src={screenshot.image} alt="Screenshot" style={{ maxWidth: '100%', maxHeight: '70vh' }} />
            </div>
          </div>
        </div>
      )}
      
      {/* Inventory Viewer - Bottom Right Corner Panel */}
      {viewingInventory && (
        <div className="inventory-panel">
          <div className="inventory-panel-header">
            <div className="inventory-panel-title">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 18, height: 18, marginRight: 8}}>
                <rect x="3" y="7" width="18" height="14" rx="2"/>
                <path d="M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2"/>
              </svg>
              {viewingInventory.targetName}'s Inventory
              {viewingInventory.system && (
                <span className={`inventory-system-badge ${viewingInventory.system.toLowerCase()}`}>
                  {viewingInventory.system}
                </span>
              )}
            </div>
            <button className="inventory-panel-close" onClick={() => setViewingInventory(null)}>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 16, height: 16}}>
                <path d="M18 6L6 18M6 6l12 12"/>
              </svg>
            </button>
          </div>
          <div className="inventory-panel-weight">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 14, height: 14, marginRight: 6}}>
              <path d="M12 3v18M5.5 8.5l13 7M18.5 8.5l-13 7"/>
            </svg>
            <span>{viewingInventory.weight.toFixed(1)}</span>
            <span style={{color: '#6b7280', margin: '0 4px'}}>/</span>
            <span style={{color: '#6b7280'}}>{viewingInventory.maxWeight}</span>
            <span style={{color: '#4b5563', marginLeft: 4, fontSize: '10px'}}>kg</span>
          </div>
          <div className="inventory-panel-items">
            {viewingInventory.items.filter(i => i).length === 0 ? (
              <div className="inventory-panel-empty">
                <svg viewBox="0 0 24 24" fill="none" stroke="#4b5563" strokeWidth="1.5" style={{width: 32, height: 32, marginBottom: 8}}>
                  <rect x="3" y="7" width="18" height="14" rx="2"/>
                  <path d="M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2"/>
                  <path d="M12 11v6M9 14h6"/>
                </svg>
                Empty Inventory
              </div>
            ) : (
              viewingInventory.items.filter(i => i).map((item, idx) => (
                <div key={idx} className="inventory-panel-item">
                  <div className="inventory-panel-item-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 16, height: 16}}>
                      <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z"/>
                    </svg>
                  </div>
                  <div className="inventory-panel-item-info">
                    <span className="inventory-panel-item-name">
                      {item.label || item.name}
                      {item.system && (
                        <span className={`item-system-tag ${item.system.toLowerCase()}`}>{item.system}</span>
                      )}
                    </span>
                    <span className="inventory-panel-item-id">{item.name}</span>
                  </div>
                  <div className="inventory-panel-item-count">x{item.count}</div>
                </div>
              ))
            )}
          </div>
          <div className="inventory-panel-footer">
            {viewingInventory.items.filter(i => i).length} items
            {viewingInventory.system && <span style={{marginLeft: 8, opacity: 0.7}}>• {viewingInventory.system}</span>}
          </div>
        </div>
      )}
    </div>
  )
}

export default App


// Players Tab
interface PlayersTabProps {
  players: Player[]; kickReason: string; setKickReason: (v: string) => void
  banReason: string; setBanReason: (v: string) => void; banDuration: number; setBanDuration: (v: number) => void
  selectedPlayer: number | null; setSelectedPlayer: (v: number | null) => void; adminPerms: AdminPerms | null
  espEnabled: boolean; setEspEnabled: (v: boolean) => void
}

function PlayersTab({ players, kickReason, setKickReason, banReason, setBanReason, banDuration, setBanDuration, selectedPlayer, setSelectedPlayer, adminPerms, espEnabled, setEspEnabled }: PlayersTabProps) {
  const [actionType, setActionType] = useState<'kick' | 'ban'>('kick')
  const [search, setSearch] = useState('')
  
  const filtered = players.filter(p => p.name.toLowerCase().includes(search.toLowerCase()) || p.id.toString().includes(search))
  
  const handleKick = (id: number) => { fetchNui('kickPlayer', { id, reason: kickReason || 'Kicked by admin' }); setKickReason(''); setSelectedPlayer(null) }
  const handleBan = (id: number) => { fetchNui('banPlayer', { id, reason: banReason || 'Banned by admin', duration: banDuration }); setBanReason(''); setBanDuration(0); setSelectedPlayer(null) }
  const toggleEsp = () => { const newVal = !espEnabled; setEspEnabled(newVal); fetchNui('toggleEsp', { enabled: newVal }) }

  return (
    <>
      <div className="section">
        <div className="section-title">Online Players ({players.length})</div>
        <div className="input-row">
          <input type="text" placeholder="Search player..." value={search} onChange={e => setSearch(e.target.value)} />
          <button className="btn primary" onClick={() => fetchNui('refreshPlayers')}>Refresh</button>
        </div>
        <div className="toggle-row">
          <span className="toggle-label">ESP (Name/ID/Weapon)</span>
          <div className={`toggle ${espEnabled ? 'active' : ''}`} onClick={toggleEsp} />
        </div>
      </div>
      
      {selectedPlayer !== null && (
        <div className="section">
          <div className="section-title">{actionType === 'kick' ? 'Kick' : 'Ban'} Player #{selectedPlayer}</div>
          <div className="input-row">
            <button className={`btn ${actionType === 'kick' ? 'active' : ''}`} onClick={() => setActionType('kick')}>Kick</button>
            {adminPerms?.ban && <button className={`btn ${actionType === 'ban' ? 'active' : ''}`} onClick={() => setActionType('ban')}>Ban</button>}
          </div>
          {actionType === 'kick' ? (
            <>
              <div className="input-row"><input type="text" placeholder="Kick reason..." value={kickReason} onChange={e => setKickReason(e.target.value)} /></div>
              <div className="btn-grid">
                <button className="btn danger" onClick={() => handleKick(selectedPlayer)}>Kick</button>
                <button className="btn" onClick={() => setSelectedPlayer(null)}>Cancel</button>
              </div>
            </>
          ) : (
            <>
              <div className="input-row"><input type="text" placeholder="Ban reason..." value={banReason} onChange={e => setBanReason(e.target.value)} /></div>
              <div className="input-row"><input type="number" placeholder="Duration (min, 0=perm)" value={banDuration} onChange={e => setBanDuration(parseInt(e.target.value) || 0)} /></div>
              <div className="btn-grid">
                <button className="btn danger" onClick={() => handleBan(selectedPlayer)}>Ban</button>
                <button className="btn" onClick={() => setSelectedPlayer(null)}>Cancel</button>
              </div>
            </>
          )}
        </div>
      )}

      <div className="player-list">
        {filtered.length === 0 ? <div className="no-players">No players found</div> : filtered.map(player => (
          <div key={player.id} className="player-item">
            <div className="player-info">
              <span className="player-name">{player.name}</span>
              <span className="player-id">ID: {player.id} • Ping: {player.ping}ms • HP: {player.health}</span>
            </div>
            <div className="player-actions">
              <button className="player-btn" onClick={() => fetchNui('openPlayerInventory', { id: player.id })} title="View Inventory">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="7" width="18" height="14" rx="2"/><path d="M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2"/></svg>
              </button>
              {adminPerms?.teleport && <button className="player-btn" onClick={() => fetchNui('teleportToPlayer', { id: player.id })} title="Goto">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
              </button>}
              {adminPerms?.bring && <button className="player-btn" onClick={() => fetchNui('bringPlayer', { id: player.id })} title="Bring">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M16 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
              </button>}
              {adminPerms?.freeze && <button className="player-btn" onClick={() => fetchNui('freezePlayer', { id: player.id })} title="Freeze">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M12 2v20M2 12h20M4.93 4.93l14.14 14.14M19.07 4.93L4.93 19.07"/></svg>
              </button>}
              {adminPerms?.revive && <button className="player-btn" onClick={() => fetchNui('revivePlayer', { id: player.id })} title="Revive">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
              </button>}
              {adminPerms?.spectate && <button className="player-btn" onClick={() => fetchNui('spectatePlayer', { id: player.id })} title="Spectate">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
              </button>}
              <button className="player-btn" onClick={() => fetchNui('takeScreenshot', { id: player.id })} title="Screenshot">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
              </button>
              {(adminPerms?.kick || adminPerms?.ban) && <button className="player-btn danger" onClick={() => setSelectedPlayer(player.id)} title="Kick/Ban">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M18 6L6 18M6 6l12 12"/></svg>
              </button>}
            </div>
          </div>
        ))}
      </div>
    </>
  )
}


// Self Tab
interface SelfTabProps {
  godMode: boolean; setGodMode: (v: boolean) => void; invisible: boolean; setInvisible: (v: boolean) => void
  noclip: boolean; setNoclip: (v: boolean) => void; locations: Location[]; adminPerms: AdminPerms | null; adminGroup: string
}

function SelfTab({ godMode, setGodMode, invisible, setInvisible, noclip, setNoclip, locations, adminPerms, adminGroup }: SelfTabProps) {
  const [weaponSearch, setWeaponSearch] = useState('')
  
  const allWeapons = ['WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_PISTOL50', 'WEAPON_HEAVYPISTOL', 'WEAPON_REVOLVER', 'WEAPON_SMG', 'WEAPON_ASSAULTSMG', 'WEAPON_COMBATPDW', 'WEAPON_MICROSMG', 'WEAPON_CARBINERIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_MARKSMANRIFLE', 'WEAPON_PUMPSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_BULLPUPSHOTGUN', 'WEAPON_MG', 'WEAPON_COMBATMG', 'WEAPON_GUSENBERG', 'WEAPON_RPG', 'WEAPON_GRENADELAUNCHER', 'WEAPON_MINIGUN', 'WEAPON_RAILGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_KNIFE', 'WEAPON_BAT', 'WEAPON_CROWBAR', 'WEAPON_HAMMER', 'WEAPON_MACHETE', 'WEAPON_GRENADE', 'WEAPON_MOLOTOV', 'WEAPON_STICKYBOMB', 'WEAPON_PROXMINE', 'WEAPON_SMOKEGRENADE', 'WEAPON_FLARE']
  
  const filteredWeapons = weaponSearch ? allWeapons.filter(w => w.toLowerCase().includes(weaponSearch.toLowerCase())) : allWeapons.slice(0, 12)
  
  const toggleGodMode = () => { setGodMode(!godMode); fetchNui('godMode', { enabled: !godMode }) }
  const toggleInvisible = () => { setInvisible(!invisible); fetchNui('invisible', { enabled: !invisible }) }
  const toggleNoclip = () => { setNoclip(!noclip); fetchNui('noclip', { enabled: !noclip }) }

  return (
    <>
      {(adminPerms?.godmode || adminPerms?.invisible || adminPerms?.noclip) && (
        <div className="section">
          <div className="section-title">Toggles</div>
          {adminPerms?.godmode && <div className="toggle-row"><span className="toggle-label">God Mode</span><div className={`toggle ${godMode ? 'active' : ''}`} onClick={toggleGodMode} /></div>}
          {adminPerms?.invisible && <div className="toggle-row"><span className="toggle-label">Invisible</span><div className={`toggle ${invisible ? 'active' : ''}`} onClick={toggleInvisible} /></div>}
          {adminPerms?.noclip && <div className="toggle-row"><span className="toggle-label">Noclip (DEL)</span><div className={`toggle ${noclip ? 'active' : ''}`} onClick={toggleNoclip} /></div>}
        </div>
      )}

      <div className="section">
        <div className="section-title">Quick Actions</div>
        <div className="btn-grid">
          <button className="btn primary" onClick={() => fetchNui('heal')}>Heal</button>
          <button className="btn primary" onClick={() => fetchNui('armor')}>Armor</button>
        </div>
      </div>

      {adminPerms?.teleport && (
        <div className="section">
          <div className="section-title">Teleport Locations</div>
          <div className="btn-grid">
            {locations.map((loc, i) => <button key={i} className="btn" onClick={() => fetchNui('teleport', { coords: loc.coords })}>{loc.name}</button>)}
          </div>
        </div>
      )}

      {adminPerms?.giveWeapon && (
        <div className="section">
          <div className="section-title">Weapons {adminGroup === 'superadmin' && '(All)'}</div>
          {adminGroup === 'superadmin' && (
            <div className="input-row"><input type="text" placeholder="Search weapon..." value={weaponSearch} onChange={e => setWeaponSearch(e.target.value)} /></div>
          )}
          <div className="vehicle-grid">
            {filteredWeapons.map(w => <button key={w} className="vehicle-btn" onClick={() => fetchNui('giveWeapon', { weapon: w })}>{w.replace('WEAPON_', '')}</button>)}
          </div>
        </div>
      )}
    </>
  )
}

// World Tab
interface WorldTabProps {
  weather: string[]; selectedWeather: string; setSelectedWeather: (v: string) => void
  hour: number; setHour: (v: number) => void; minute: number; setMinute: (v: number) => void; adminPerms: AdminPerms | null
}

function WorldTab({ weather, selectedWeather, setSelectedWeather, hour, setHour, minute, setMinute, adminPerms }: WorldTabProps) {
  return (
    <>
      {adminPerms?.setWeather && (
        <div className="section">
          <div className="section-title">Weather</div>
          <div className="input-row">
            <select value={selectedWeather} onChange={e => setSelectedWeather(e.target.value)}>
              <option value="">Select Weather...</option>
              {weather.map(w => <option key={w} value={w}>{w}</option>)}
            </select>
            <button className="btn primary" onClick={() => selectedWeather && fetchNui('setWeather', { weather: selectedWeather })}>Set</button>
          </div>
          <div className="btn-grid">
            {weather.slice(0, 6).map(w => <button key={w} className="btn" onClick={() => fetchNui('setWeather', { weather: w })}>{w}</button>)}
          </div>
        </div>
      )}

      {adminPerms?.setTime && (
        <div className="section">
          <div className="section-title">Time</div>
          <div className="input-row">
            <input type="number" className="time-input" min="0" max="23" value={hour} onChange={e => setHour(parseInt(e.target.value) || 0)} />
            <span style={{ color: '#d4a574' }}>:</span>
            <input type="number" className="time-input" min="0" max="59" value={minute} onChange={e => setMinute(parseInt(e.target.value) || 0)} />
            <button className="btn primary" onClick={() => fetchNui('setTime', { hour, minute })}>Set</button>
          </div>
          <div className="btn-grid">
            <button className="btn" onClick={() => fetchNui('setTime', { hour: 6, minute: 0 })}>Morning</button>
            <button className="btn" onClick={() => fetchNui('setTime', { hour: 12, minute: 0 })}>Noon</button>
            <button className="btn" onClick={() => fetchNui('setTime', { hour: 18, minute: 0 })}>Evening</button>
            <button className="btn" onClick={() => fetchNui('setTime', { hour: 0, minute: 0 })}>Night</button>
          </div>
        </div>
      )}
    </>
  )
}


// Vehicles Tab with Search
interface VehiclesTabProps { vehicles: VehicleCategories; adminPerms: AdminPerms | null; adminGroup: string }

function VehiclesTab({ vehicles, adminPerms, adminGroup }: VehiclesTabProps) {
  const [search, setSearch] = useState('')
  const [customVehicle, setCustomVehicle] = useState('')
  
  // All vehicles for superadmin search
  const allVehicles = Object.values(vehicles).flat()
  const suggestions = search ? allVehicles.filter(v => v.toLowerCase().includes(search.toLowerCase())).slice(0, 10) : []

  return (
    <>
      {(adminPerms?.deleteVehicle || adminPerms?.repairVehicle) && (
        <div className="section">
          <div className="section-title">Vehicle Actions</div>
          <div className="btn-grid">
            {adminPerms?.deleteVehicle && <button className="btn danger" onClick={() => fetchNui('deleteVehicle')}>Delete Vehicle</button>}
            {adminPerms?.repairVehicle && <button className="btn primary" onClick={() => fetchNui('repairVehicle')}>Repair Vehicle</button>}
          </div>
        </div>
      )}

      {adminPerms?.spawnVehicle && (
        <>
          <div className="section">
            <div className="section-title">Search & Spawn {adminGroup === 'superadmin' && '(Any Vehicle)'}</div>
            <div className="input-row">
              <input type="text" placeholder="Search vehicle or type model name..." value={search || customVehicle} onChange={e => { setSearch(e.target.value); setCustomVehicle(e.target.value) }} />
              <button className="btn primary" onClick={() => customVehicle && fetchNui('spawnVehicle', { vehicle: customVehicle })}>Spawn</button>
            </div>
            {suggestions.length > 0 && (
              <div className="vehicle-grid">
                {suggestions.map(v => <button key={v} className="vehicle-btn" onClick={() => { fetchNui('spawnVehicle', { vehicle: v }); setSearch(''); setCustomVehicle('') }}>{v}</button>)}
              </div>
            )}
          </div>

          {Object.entries(vehicles).map(([category, vehicleList]) => (
            <div key={category} className="section">
              <div className="section-title">{category}</div>
              <div className="vehicle-grid">
                {vehicleList.map(v => <button key={v} className="vehicle-btn" onClick={() => fetchNui('spawnVehicle', { vehicle: v })}>{v}</button>)}
              </div>
            </div>
          ))}
        </>
      )}
    </>
  )
}

// Server Tab
interface ServerTabProps { announcement: string; setAnnouncement: (v: string) => void; adminPerms: AdminPerms | null }

function ServerTab({ announcement, setAnnouncement, adminPerms }: ServerTabProps) {
  const handleAnnounce = () => { if (announcement.trim()) { fetchNui('announce', { message: announcement }); setAnnouncement('') } }

  return (
    <>
      {adminPerms?.announce && (
        <div className="section">
          <div className="section-title">Server Announcement</div>
          <div className="input-row">
            <input type="text" placeholder="Type announcement..." value={announcement} onChange={e => setAnnouncement(e.target.value)} onKeyDown={e => e.key === 'Enter' && handleAnnounce()} />
          </div>
          <button className="btn warning" onClick={handleAnnounce} style={{ width: '100%' }}>Send Announcement</button>
        </div>
      )}
      <div className="section">
        <div className="section-title">Quick Commands</div>
        <div className="btn-grid">
          <button className="btn" onClick={() => fetchNui('refreshPlayers')}>Refresh Players</button>
        </div>
      </div>
    </>
  )
}

// Reports Tab
function ReportsTab({ reports }: { reports: Report[] }) {
  useEffect(() => { fetchNui('getReports') }, [])

  return (
    <>
      <div className="section">
        <div className="section-title">Active Reports ({reports.length})</div>
        <button className="btn primary" onClick={() => fetchNui('getReports')}>Refresh</button>
      </div>
      <div className="player-list">
        {reports.length === 0 ? <div className="no-players">No active reports</div> : reports.map(report => (
          <div key={report.id} className="player-item">
            <div className="player-info">
              <span className="player-name">[{report.category}] {report.reporter.name}{report.target && ` → ${report.target.name}`}</span>
              <span className="player-id">{report.reason} • {report.time}{report.claimedBy && ` • Claimed: ${report.claimedBy.name}`}</span>
            </div>
            <div className="player-actions">
              <button className="player-btn" onClick={() => fetchNui('gotoReport', { id: report.id })} title="Goto">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
              </button>
              {!report.claimedBy && <button className="player-btn" onClick={() => fetchNui('claimReport', { id: report.id })} title="Claim">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M14 9V5a3 3 0 00-3-3l-4 9v11h11.28a2 2 0 002-1.7l1.38-9a2 2 0 00-2-2.3zM7 22H4a2 2 0 01-2-2v-7a2 2 0 012-2h3"/></svg>
              </button>}
              <button className="player-btn danger" onClick={() => fetchNui('closeReport', { id: report.id })} title="Close">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M18 6L6 18M6 6l12 12"/></svg>
              </button>
            </div>
          </div>
        ))}
      </div>
    </>
  )
}


// Items Tab with Search (SuperAdmin can give any item) - Shows ESX/OX system
function ItemsTab({ items, players, adminGroup }: { items: any[]; players: Player[]; adminGroup: string }) {
  const [search, setSearch] = useState('')
  const [selectedItem, setSelectedItem] = useState('')
  const [itemCount, setItemCount] = useState(1)
  const [targetPlayer, setTargetPlayer] = useState<number | null>(null)
  const [customItem, setCustomItem] = useState('')

  const filtered = search ? items.filter(i => i.label?.toLowerCase().includes(search.toLowerCase()) || i.name?.toLowerCase().includes(search.toLowerCase())).slice(0, 20) : items.slice(0, 20)

  // Get the system type from items (ESX or OX)
  const systemType = items.length > 0 && items[0].system ? items[0].system : null

  const handleGive = () => {
    const itemToGive = customItem || selectedItem
    if (itemToGive && targetPlayer) {
      fetchNui('giveItem', { targetId: targetPlayer, item: itemToGive, count: itemCount })
      setSelectedItem('')
      setCustomItem('')
      setItemCount(1)
    }
  }

  return (
    <>
      <div className="section">
        <div className="section-title">
          Give Items {adminGroup === 'superadmin' && '(Any Item)'}
          {systemType && (
            <span className={`inventory-system-badge ${systemType.toLowerCase()}`} style={{marginLeft: 8}}>
              {systemType}
            </span>
          )}
        </div>
        <div className="input-row">
          <select value={targetPlayer || ''} onChange={e => setTargetPlayer(parseInt(e.target.value) || null)}>
            <option value="">Select Player...</option>
            {players.map(p => <option key={p.id} value={p.id}>{p.name} (#{p.id})</option>)}
          </select>
        </div>
        <div className="input-row">
          <input type="text" placeholder="Search item or type item name..." value={search || customItem} onChange={e => { setSearch(e.target.value); setCustomItem(e.target.value) }} />
        </div>
        <div className="input-row">
          <input type="number" min="1" value={itemCount} onChange={e => setItemCount(parseInt(e.target.value) || 1)} style={{ width: '80px' }} />
          <button className="btn primary" onClick={handleGive}>Give Item</button>
        </div>
      </div>

      {filtered.length > 0 && (
        <div className="section">
          <div className="section-title">Items ({items.length} total)</div>
          <div className="vehicle-grid">
            {filtered.map(item => (
              <button 
                key={item.name} 
                className={`vehicle-btn ${selectedItem === item.name ? 'active' : ''}`} 
                onClick={() => { setSelectedItem(item.name); setCustomItem(item.name) }} 
                title={`${item.name}${item.system ? ` [${item.system}]` : ''}`}
              >
                {item.label || item.name}
                {item.system && <span className={`item-system-tag ${item.system.toLowerCase()}`} style={{marginLeft: 4, fontSize: '7px'}}>{item.system}</span>}
              </button>
            ))}
          </div>
        </div>
      )}
    </>
  )
}

// Permissions Tab (SuperAdmin only)
function PermissionsTab({ admins, players }: { admins: AdminUser[]; players: Player[] }) {
  const [identifier, setIdentifier] = useState('')
  const [group, setGroup] = useState('mod')
  const [useServerId, setUseServerId] = useState(true)

  useEffect(() => { fetchNui('getAdmins') }, [])

  const handleAdd = () => {
    if (identifier.trim()) {
      fetchNui('setAdmin', { license: identifier.trim(), group })
      setIdentifier('')
    }
  }

  return (
    <>
      <div className="section">
        <div className="section-title">Add New Admin</div>
        <div className="toggle-row">
          <span className="toggle-label">Use Server ID (instant, no relog)</span>
          <div className={`toggle ${useServerId ? 'active' : ''}`} onClick={() => setUseServerId(!useServerId)} />
        </div>
        {useServerId ? (
          <div className="input-row">
            <select value={identifier} onChange={e => setIdentifier(e.target.value)}>
              <option value="">Select Player...</option>
              {players.map(p => <option key={p.id} value={p.id}>{p.name} (#{p.id})</option>)}
            </select>
          </div>
        ) : (
          <div className="input-row">
            <input type="text" placeholder="License (license:xxxxxxx)" value={identifier} onChange={e => setIdentifier(e.target.value)} />
          </div>
        )}
        <div className="input-row">
          <select value={group} onChange={e => setGroup(e.target.value)}>
            <option value="mod">Moderator</option>
            <option value="admin">Admin</option>
            <option value="superadmin">Super Admin</option>
          </select>
          <button className="btn primary" onClick={handleAdd}>Add Admin</button>
        </div>
      </div>

      <div className="section">
        <div className="section-title">Current Admins ({admins.length})</div>
        <div className="player-list">
          {admins.length === 0 ? <div className="no-players">No admins configured</div> : admins.map((admin, i) => (
            <div key={i} className="player-item">
              <div className="player-info">
                <span className="player-name">{admin.group.toUpperCase()}</span>
                <span className="player-id">{admin.license}</span>
              </div>
              <div className="player-actions">
                <button className="player-btn danger" onClick={() => fetchNui('removeAdmin', { license: admin.license })} title="Remove">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M18 6L6 18M6 6l12 12"/></svg>
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </>
  )
}


// Logs Tab - Complete with SVG Icons and proper log types
function LogsTab({ logs }: { logs: LogEntry[] }) {
  const [logType, setLogType] = useState('all')
  const [limit, setLimit] = useState(50)
  const [search, setSearch] = useState('')
  const [viewingScreenshot, setViewingScreenshot] = useState<{image: string, player: string, details: string} | null>(null)

  useEffect(() => {
    fetchNui('getLogs', { logType, limit })
  }, [logType, limit])

  // All log type colors
  const getLogColor = (type: string) => {
    const colors: Record<string, string> = {
      // Player Actions
      'kill': '#ff6b6b',
      'connect': '#51cf66',
      'disconnect': '#ff922b',
      'death': '#ff4757',
      // Admin Actions
      'ban': '#ff0000',
      'kick': '#ffa500',
      'unban': '#2ed573',
      'give_item': '#ffd43b',
      'spawn_vehicle': '#4caf50',
      'spawn': '#4caf50',
      'teleport_action': '#2196f3',
      'screenshot': '#74c0fc',
      'view_inventory': '#9c88ff',
      'revive': '#2ed573',
      'freeze': '#00d2d3',
      'announce': '#feca57',
      'set_weather': '#54a0ff',
      'set_time': '#5f27cd',
      'give_weapon': '#ff9f43',
      // Anticheat
      'anticheat_ban': '#ff0000',
      'anticheat_warn': '#ffa500',
      'aimbot': '#e040fb',
      'silent_aim': '#d63031',
      'wallhack': '#ff5722',
      'esp': '#e17055',
      'godmode': '#f44336',
      'teleport': '#9c27b0',
      'teleport_hack': '#9c27b0',
      'noclip': '#673ab7',
      'freecam': '#3f51b5',
      'invisible': '#00bcd4',
      'weapon_mod': '#ff9800',
      'lua_executor': '#f44336',
      'cheat_menu': '#c0392b',
      'illegal_vehicle': '#e74c3c',
      'illegal_weapon': '#d35400',
      'illegal_ped': '#e67e22',
      'spoofed_weapon': '#c0392b',
      'spoofed_vehicle': '#e74c3c',
      'self_revive': '#9b59b6',
      'self_heal': '#8e44ad',
      'resource_stop': '#2c3e50',
      'heartbeat_fail': '#34495e',
    }
    return colors[type] || '#adb5bd'
  }

  // SVG Icons for all log types
  const LogIcon = ({ type }: { type: string }) => {
    const s = { width: 14, height: 14, display: 'inline' as const, verticalAlign: 'middle' as const, marginRight: 4 }
    const c = getLogColor(type)
    
    switch (type) {
      // Player Actions
      case 'kill':
      case 'death':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><circle cx="9" cy="7" r="4"/><path d="M3 21v-2a4 4 0 014-4h4"/><line x1="15" y1="11" x2="21" y2="17"/><line x1="21" y1="11" x2="15" y2="17"/></svg>
      case 'connect':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M15 3h4a2 2 0 012 2v14a2 2 0 01-2 2h-4"/><path d="M10 17l5-5-5-5"/><path d="M15 12H3"/></svg>
      case 'disconnect':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><path d="M16 17l5-5-5-5"/><path d="M21 12H9"/></svg>
      
      // Admin Actions
      case 'ban':
      case 'anticheat_ban':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>
      case 'unban':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
      case 'kick':
      case 'anticheat_warn':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M16 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="18" y1="8" x2="23" y2="13"/><line x1="23" y1="8" x2="18" y2="13"/></svg>
      case 'give_item':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z"/></svg>
      case 'spawn_vehicle':
      case 'spawn':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
      case 'teleport_action':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
      case 'screenshot':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
      case 'view_inventory':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><rect x="3" y="7" width="18" height="14" rx="2"/><path d="M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2"/></svg>
      case 'revive':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
      case 'freeze':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M12 2v20M2 12h20M4.93 4.93l14.14 14.14M19.07 4.93L4.93 19.07"/></svg>
      case 'announce':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
      case 'set_weather':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M18 10h-1.26A8 8 0 109 20h9a5 5 0 000-10z"/></svg>
      case 'set_time':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
      case 'give_weapon':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M22 12L2 12M22 12L18 8M22 12L18 16M2 12L6 8M2 12L6 16"/></svg>
      
      // Anticheat - Aimbot/Accuracy
      case 'aimbot':
      case 'silent_aim':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/><line x1="12" y1="2" x2="12" y2="6"/><line x1="12" y1="18" x2="12" y2="22"/><line x1="2" y1="12" x2="6" y2="12"/><line x1="18" y1="12" x2="22" y2="12"/></svg>
      
      // Anticheat - Vision
      case 'wallhack':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18"/><path d="M9 21V9"/></svg>
      case 'esp':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/><path d="M12 5v2M12 17v2M5 12H3M21 12h-2"/></svg>
      
      // Anticheat - Protection
      case 'godmode':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      case 'self_revive':
      case 'self_heal':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
      
      // Anticheat - Movement
      case 'teleport':
      case 'teleport_hack':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><circle cx="12" cy="12" r="10"/><path d="M12 8v8M8 12h8"/><path d="M12 2v2M12 20v2M2 12h2M20 12h2"/></svg>
      case 'noclip':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M5 12h14"/><path d="M12 5l7 7-7 7"/></svg>
      case 'freecam':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M23 19a2 2 0 01-2 2H3a2 2 0 01-2-2V8a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2z"/><circle cx="12" cy="13" r="4"/></svg>
      case 'invisible':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
      
      // Anticheat - Weapons/Items
      case 'weapon_mod':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.76z"/></svg>
      case 'illegal_weapon':
      case 'spoofed_weapon':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M22 12L2 12"/><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>
      
      // Anticheat - Vehicles/Peds
      case 'illegal_vehicle':
      case 'spoofed_vehicle':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
      case 'illegal_ped':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
      
      // Anticheat - Executors
      case 'lua_executor':
      case 'cheat_menu':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
      
      // Anticheat - System
      case 'resource_stop':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><rect x="3" y="3" width="18" height="18" rx="2"/><rect x="9" y="9" width="6" height="6"/></svg>
      case 'heartbeat_fail':
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M22 12h-4l-3 9L9 3l-3 9H2"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
      
      // Default
      default:
        return <svg viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" style={s}><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><path d="M14 2v6h6"/><path d="M16 13H8"/><path d="M16 17H8"/><path d="M10 9H8"/></svg>
    }
  }

  // Log labels with proper names
  const getLogLabel = (type: string) => {
    const labels: Record<string, string> = {
      // Player Actions
      'kill': 'KILL',
      'death': 'DEATH',
      'connect': 'JOIN',
      'disconnect': 'LEAVE',
      // Admin Actions
      'ban': 'BAN',
      'unban': 'UNBAN',
      'kick': 'KICK',
      'give_item': 'GIVE ITEM',
      'spawn_vehicle': 'SPAWN VEH',
      'spawn': 'SPAWN',
      'teleport_action': 'TELEPORT',
      'screenshot': 'SCREENSHOT',
      'view_inventory': 'VIEW INV',
      'revive': 'REVIVE',
      'freeze': 'FREEZE',
      'announce': 'ANNOUNCE',
      'set_weather': 'WEATHER',
      'set_time': 'TIME',
      'give_weapon': 'GIVE WEAPON',
      // Anticheat
      'anticheat_ban': 'AC BAN',
      'anticheat_warn': 'AC WARN',
      'aimbot': 'AIMBOT',
      'silent_aim': 'SILENT AIM',
      'wallhack': 'WALLHACK',
      'esp': 'ESP',
      'godmode': 'GODMODE',
      'teleport': 'TP HACK',
      'teleport_hack': 'TP HACK',
      'noclip': 'NOCLIP',
      'freecam': 'FREECAM',
      'invisible': 'INVISIBLE',
      'weapon_mod': 'WEAPON MOD',
      'illegal_weapon': 'ILLEGAL WPN',
      'spoofed_weapon': 'SPOOF WPN',
      'illegal_vehicle': 'ILLEGAL VEH',
      'spoofed_vehicle': 'SPOOF VEH',
      'illegal_ped': 'ILLEGAL PED',
      'lua_executor': 'LUA EXEC',
      'cheat_menu': 'CHEAT MENU',
      'self_revive': 'SELF REVIVE',
      'self_heal': 'SELF HEAL',
      'resource_stop': 'RES STOP',
      'heartbeat_fail': 'HEARTBEAT',
    }
    return labels[type] || type.toUpperCase().replace(/_/g, ' ')
  }

  // Filter logs by search
  const filteredLogs = logs.filter(log => {
    if (!search) return true
    const searchLower = search.toLowerCase()
    return (
      (log.player_name?.toLowerCase().includes(searchLower)) ||
      (log.target_name?.toLowerCase().includes(searchLower)) ||
      (log.details?.toLowerCase().includes(searchLower)) ||
      (log.log_type?.toLowerCase().includes(searchLower))
    )
  })

  return (
    <>
      <div className="section">
        <div className="section-title">📋 Server Logs</div>
        <div className="input-row">
          <input 
            type="text" 
            placeholder="Search logs..." 
            value={search} 
            onChange={e => setSearch(e.target.value)} 
          />
          <button className="btn primary" onClick={() => fetchNui('getLogs', { logType, limit })}>Refresh</button>
        </div>
        <div className="input-row">
          <select value={logType} onChange={e => setLogType(e.target.value)}>
            <option value="all">All Logs</option>
            <optgroup label="─── Player Actions ───">
              <option value="kill">Kills</option>
              <option value="death">Deaths</option>
              <option value="connect">Connects</option>
              <option value="disconnect">Disconnects</option>
            </optgroup>
            <optgroup label="─── Admin Actions ───">
              <option value="ban">Bans</option>
              <option value="unban">Unbans</option>
              <option value="kick">Kicks</option>
              <option value="give_item">Items Given</option>
              <option value="give_weapon">Weapons Given</option>
              <option value="spawn">Vehicle Spawns</option>
              <option value="teleport_action">Teleports</option>
              <option value="screenshot">Screenshots</option>
              <option value="view_inventory">Inventory Views</option>
              <option value="revive">Revives</option>
              <option value="freeze">Freezes</option>
              <option value="announce">Announcements</option>
              <option value="set_weather">Weather Changes</option>
              <option value="set_time">Time Changes</option>
            </optgroup>
            <optgroup label="─── Anticheat Bans ───">
              <option value="anticheat_ban">AC Bans</option>
              <option value="anticheat_warn">AC Warnings</option>
            </optgroup>
            <optgroup label="─── Aim Cheats ───">
              <option value="aimbot">Aimbot</option>
              <option value="silent_aim">Silent Aim</option>
            </optgroup>
            <optgroup label="─── Vision Cheats ───">
              <option value="wallhack">Wallhack</option>
              <option value="esp">ESP</option>
            </optgroup>
            <optgroup label="─── Protection Cheats ───">
              <option value="godmode">Godmode</option>
              <option value="self_revive">Self Revive</option>
              <option value="self_heal">Self Heal</option>
            </optgroup>
            <optgroup label="─── Movement Cheats ───">
              <option value="teleport">Teleport Hack</option>
              <option value="noclip">Noclip</option>
              <option value="freecam">Freecam</option>
              <option value="invisible">Invisible</option>
            </optgroup>
            <optgroup label="─── Spawn Cheats ───">
              <option value="weapon_mod">Weapon Mods</option>
              <option value="illegal_weapon">Illegal Weapons</option>
              <option value="spoofed_weapon">Spoofed Weapons</option>
              <option value="illegal_vehicle">Illegal Vehicles</option>
              <option value="spoofed_vehicle">Spoofed Vehicles</option>
              <option value="illegal_ped">Illegal Peds</option>
            </optgroup>
            <optgroup label="─── Executor Cheats ───">
              <option value="lua_executor">Lua Executor</option>
              <option value="cheat_menu">Cheat Menu</option>
              <option value="resource_stop">Resource Stop</option>
              <option value="heartbeat_fail">Heartbeat Fail</option>
            </optgroup>
          </select>
          <select value={limit} onChange={e => setLimit(parseInt(e.target.value))}>
            <option value="25">25</option>
            <option value="50">50</option>
            <option value="100">100</option>
            <option value="200">200</option>
          </select>
        </div>
      </div>

      <div className="section">
        <div className="section-title" style={{ fontSize: '10px' }}>
          Showing {filteredLogs.length} logs {search && `(filtered from ${logs.length})`}
        </div>
      </div>

      <div className="player-list" style={{ maxHeight: '350px' }}>
        {filteredLogs.length === 0 ? (
          <div className="no-players">No logs found</div>
        ) : (
          filteredLogs.map(log => (
            <div key={log.id} className="player-item" style={{ borderLeft: `3px solid ${getLogColor(log.log_type)}` }}>
              <div className="player-info" style={{ width: '100%' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <span className="player-name" style={{ color: getLogColor(log.log_type), fontSize: '11px', display: 'flex', alignItems: 'center' }}>
                    <LogIcon type={log.log_type} /> {getLogLabel(log.log_type)}
                  </span>
                  <span style={{ color: '#4b6a8a', fontSize: '9px' }}>
                    {new Date(log.created_at).toLocaleTimeString()}
                  </span>
                </div>
                <span className="player-id" style={{ marginTop: '4px' }}>
                  <strong style={{ color: '#60a5fa' }}>{log.player_name || 'System'}</strong>
                  {log.target_name && <> → <strong style={{ color: '#ef4444' }}>{log.target_name}</strong></>}
                </span>
                {log.details && (
                  <span className="player-id" style={{ fontSize: '10px', marginTop: '2px', color: '#6b7280' }}>
                    {log.details}
                  </span>
                )}
                {log.coords && (
                  <span className="player-id" style={{ fontSize: '9px', marginTop: '2px', color: '#4b5563' }}>
                    <svg viewBox="0 0 24 24" fill="none" stroke="#4b5563" strokeWidth="2" style={{width: 10, height: 10, display: 'inline', verticalAlign: 'middle', marginRight: 2}}><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    {log.coords}
                  </span>
                )}
              </div>
              {log.screenshot && (
                <button 
                  className="player-btn" 
                  onClick={() => setViewingScreenshot({
                    image: log.screenshot!,
                    player: log.player_name || 'Unknown',
                    details: log.details || ''
                  })}
                  title="View Screenshot"
                  style={{ background: '#3b82f6', marginLeft: '8px' }}
                >
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 14, height: 14}}>
                    <rect x="3" y="3" width="18" height="18" rx="2"/>
                    <circle cx="8.5" cy="8.5" r="1.5"/>
                    <path d="M21 15l-5-5L5 21"/>
                  </svg>
                </button>
              )}
            </div>
          ))
        )}
      </div>

      {/* Screenshot Modal */}
      {viewingScreenshot && (
        <div className="modal-overlay" onClick={() => setViewingScreenshot(null)} style={{
          position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
          background: 'rgba(0,0,0,0.8)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 9999
        }}>
          <div className="modal" onClick={e => e.stopPropagation()} style={{
            background: '#1a1a2e', borderRadius: '12px', padding: '20px', maxWidth: '90vw', maxHeight: '90vh'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '15px' }}>
              <h3 style={{ color: '#fff', margin: 0 }}>📸 Screenshot: {viewingScreenshot.player}</h3>
              <button onClick={() => setViewingScreenshot(null)} style={{
                background: '#ff6b6b', border: 'none', borderRadius: '50%', width: '30px', height: '30px',
                color: '#fff', cursor: 'pointer', fontSize: '16px'
              }}>✕</button>
            </div>
            <p style={{ color: '#888', fontSize: '12px', marginBottom: '10px' }}>{viewingScreenshot.details}</p>
            <img 
              src={viewingScreenshot.image} 
              alt="Screenshot" 
              style={{ maxWidth: '100%', maxHeight: '70vh', borderRadius: '8px' }} 
            />
          </div>
        </div>
      )}
    </>
  )
}


// Ban List Tab
function BanListTab({ bans }: { bans: BanEntry[] }) {
  const [search, setSearch] = useState('')

  useEffect(() => {
    fetchNui('getBans')
  }, [])

  const filtered = bans.filter(b => 
    b.name?.toLowerCase().includes(search.toLowerCase()) || 
    b.license?.toLowerCase().includes(search.toLowerCase()) ||
    b.reason?.toLowerCase().includes(search.toLowerCase())
  )

  const formatExpiry = (expiry?: number) => {
    if (!expiry) return 'Permanent'
    const date = new Date(expiry * 1000)
    if (date < new Date()) return 'Expired'
    return date.toLocaleString()
  }

  const isExpired = (expiry?: number) => {
    if (!expiry) return false
    return new Date(expiry * 1000) < new Date()
  }

  const handleUnban = (id: number) => {
    fetchNui('unbanPlayer', { id })
  }

  return (
    <>
      <div className="section">
        <div className="section-title">Ban List ({bans.length})</div>
        <div className="input-row">
          <input type="text" placeholder="Search by name, license, or reason..." value={search} onChange={e => setSearch(e.target.value)} />
          <button className="btn primary" onClick={() => fetchNui('getBans')}>Refresh</button>
        </div>
      </div>

      <div className="player-list" style={{ maxHeight: '400px' }}>
        {filtered.length === 0 ? <div className="no-players">No bans found</div> : filtered.map(ban => (
          <div key={ban.id} className="player-item" style={{ opacity: isExpired(ban.expiry) ? 0.5 : 1 }}>
            <div className="player-info">
              <span className="player-name" style={{ color: isExpired(ban.expiry) ? '#888' : '#ff6b6b' }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 14, height: 14, display: 'inline', verticalAlign: 'middle', marginRight: 4}}>
                  <circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>
                </svg>
                {ban.name || 'Unknown'}
              </span>
              <span className="player-id">Reason: {ban.reason || 'No reason'}</span>
              <span className="player-id">License: {ban.license}</span>
              {ban.discord && <span className="player-id">Discord: {ban.discord}</span>}
              <span className="player-id">Banned by: {ban.admin || 'Unknown'}</span>
              <span className="player-id" style={{ color: isExpired(ban.expiry) ? '#888' : (ban.expiry ? '#ffa500' : '#ff0000') }}>
                Expires: {formatExpiry(ban.expiry)}
              </span>
              <span className="player-id" style={{ fontSize: '10px', opacity: 0.7 }}>
                Created: {new Date(ban.created_at).toLocaleString()}
              </span>
            </div>
            <div className="player-actions">
              <button className="player-btn" onClick={() => handleUnban(ban.id)} title="Unban">
                <svg viewBox="0 0 24 24" fill="none" stroke="#51cf66" strokeWidth="2">
                  <path d="M22 11.08V12a10 10 0 11-5.93-9.14"/>
                  <polyline points="22 4 12 14.01 9 11.01"/>
                </svg>
              </button>
            </div>
          </div>
        ))}
      </div>
    </>
  )
}


// Anticheat Tab (SuperAdmin only)
function AnticheatTab({ players, debugMode, setDebugMode }: { players: Player[], debugMode: boolean, setDebugMode: (v: boolean) => void }) {
  const [clearRadius, setClearRadius] = useState(50)
  const [search, setSearch] = useState('')

  const filtered = players.filter(p => p.name.toLowerCase().includes(search.toLowerCase()) || p.id.toString().includes(search))

  const handleClear = (type: string) => {
    fetchNui('clearEntities', { type, radius: clearRadius })
  }

  const handleWarn = (playerId: number) => {
    fetchNui('warnPlayer', { id: playerId })
  }

  const toggleDebugMode = () => {
    const newValue = !debugMode
    setDebugMode(newValue)
    fetchNui('toggleAnticheatDebug', { enabled: newValue })
  }

  return (
    <>
      <div className="section">
        <div className="section-title" style={{ color: '#ff6b6b' }}>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 18, height: 18, display: 'inline', verticalAlign: 'middle', marginRight: 6}}>
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
          </svg>
          ANTICHEAT CONTROLS
        </div>
        <p style={{ fontSize: '12px', color: '#888', marginBottom: '10px' }}>SuperAdmin only - Use with caution!</p>
      </div>

      <div className="section">
        <div className="section-title" style={{ color: debugMode ? '#ff6b6b' : '#888' }}>
          🔧 Debug Mode {debugMode ? '(ACTIVE - You CAN be banned!)' : '(OFF - You are protected)'}
        </div>
        <p style={{ fontSize: '11px', color: '#888', marginBottom: '8px' }}>
          Enable to test anticheat on yourself. Anticheat will check YOU like a normal player!
        </p>
        <div className="toggle-row">
          <span className="toggle-label" style={{ color: debugMode ? '#ff6b6b' : '#aaa' }}>
            {debugMode ? '⚠️ ANTICHEAT ACTIVE ON YOU - BE CAREFUL!' : 'Enable Debug Mode (Test Anticheat)'}
          </span>
          <div className={`toggle ${debugMode ? 'active' : ''}`} onClick={toggleDebugMode} style={{ background: debugMode ? '#ff6b6b' : undefined }} />
        </div>
      </div>

      <div className="section">
        <div className="section-title">Clear Entities</div>
        <div className="input-row">
          <span style={{ color: '#d4a574', fontSize: '14px' }}>Radius: {clearRadius}m</span>
        </div>
        <input 
          type="range" 
          min="10" 
          max="500" 
          value={clearRadius} 
          onChange={e => setClearRadius(parseInt(e.target.value))}
          style={{ width: '100%', marginBottom: '10px' }}
        />
        <div className="btn-grid">
          <button className="btn danger" onClick={() => handleClear('peds')}>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 14, height: 14, display: 'inline', verticalAlign: 'middle', marginRight: 4}}>
              <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/>
            </svg>
            Clear Peds
          </button>
          <button className="btn danger" onClick={() => handleClear('vehicles')}>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 14, height: 14, display: 'inline', verticalAlign: 'middle', marginRight: 4}}>
              <rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>
            </svg>
            Clear Vehicles
          </button>
          <button className="btn danger" onClick={() => handleClear('props')}>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 14, height: 14, display: 'inline', verticalAlign: 'middle', marginRight: 4}}>
              <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z"/>
            </svg>
            Clear Props
          </button>
          <button className="btn danger" onClick={() => handleClear('all')}>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 14, height: 14, display: 'inline', verticalAlign: 'middle', marginRight: 4}}>
              <polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/>
            </svg>
            Clear ALL
          </button>
        </div>
      </div>

      <div className="section">
        <div className="section-title" style={{ color: '#ffa500' }}>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width: 16, height: 16, display: 'inline', verticalAlign: 'middle', marginRight: 6}}>
            <path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
          </svg>
          Warn Player (Fullscreen Warning)
        </div>
        <p style={{ fontSize: '11px', color: '#ff6b6b', marginBottom: '10px' }}>⚠️ If player quits during warning = 24 HOUR BAN!</p>
        <div className="input-row">
          <input type="text" placeholder="Search player..." value={search} onChange={e => setSearch(e.target.value)} />
        </div>
      </div>

      <div className="player-list" style={{ maxHeight: '250px' }}>
        {filtered.length === 0 ? <div className="no-players">No players found</div> : filtered.map(player => (
          <div key={player.id} className="player-item">
            <div className="player-info">
              <span className="player-name">{player.name}</span>
              <span className="player-id">ID: {player.id} • Ping: {player.ping}ms</span>
            </div>
            <div className="player-actions">
              <button 
                className="player-btn" 
                onClick={() => fetchNui('takeScreenshot', { id: player.id })} 
                title="Take Screenshot"
                style={{ background: '#3b82f6' }}
              >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <rect x="3" y="3" width="18" height="18" rx="2"/>
                  <circle cx="8.5" cy="8.5" r="1.5"/>
                  <path d="M21 15l-5-5L5 21"/>
                </svg>
              </button>
              <button 
                className="player-btn" 
                onClick={() => handleWarn(player.id)} 
                title="Send Anticheat Warning"
                style={{ background: '#ff6b6b' }}
              >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>
                  <line x1="12" y1="9" x2="12" y2="13"/>
                  <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
              </button>
            </div>
          </div>
        ))}
      </div>
    </>
  )
}
