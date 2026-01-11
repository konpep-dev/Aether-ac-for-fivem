export interface Player {
  id: number
  name: string
  ping: number
  health: number
  armor?: number
  coords: { x: number; y: number; z: number }
  inVehicle?: boolean
  license?: string
  discord?: string
}

export interface Location {
  name: string
  coords: { x: number; y: number; z: number }
}

export interface VehicleCategories {
  [category: string]: string[]
}

export interface AdminPerms {
  kick: boolean
  ban: boolean
  freeze: boolean
  teleport: boolean
  bring: boolean
  spectate: boolean
  revive: boolean
  godmode: boolean
  noclip: boolean
  invisible: boolean
  spawnVehicle: boolean
  deleteVehicle: boolean
  repairVehicle: boolean
  giveWeapon: boolean
  giveItem: boolean
  setWeather: boolean
  setTime: boolean
  announce: boolean
  managePerms: boolean
  anticheat?: boolean
}

export interface Report {
  id: number
  reporter: { id: number; name: string }
  target?: { id: number; name: string }
  reason: string
  category: string
  time: string
  coords: { x: number; y: number; z: number }
  claimedBy?: { id: number; name: string }
}

export interface AdminUser {
  license: string
  group: string
}

export interface NuiMessage {
  action: string
  group?: string
  perms?: AdminPerms
  weather?: string[]
  locations?: Location[]
  vehicles?: VehicleCategories
  players?: Player[]
  items?: any[]
  reports?: Report[]
  report?: Report
  admins?: AdminUser[]
  id?: number
  logs?: LogEntry[]
  inventory?: InventoryData
  image?: string
  targetName?: string
  bans?: BanEntry[]
  enabled?: boolean
}

export interface LogEntry {
  id: number
  log_type: string
  player_name?: string
  player_license?: string
  player_discord?: string
  target_name?: string
  target_license?: string
  details?: string
  coords?: string
  screenshot?: string
  created_at: string
}

export interface InventoryData {
  targetId: number
  targetName: string
  items: InventoryItem[]
  weight: number
  maxWeight: number
  system?: 'ESX' | 'OX' | string
}

export interface InventoryItem {
  slot?: number
  name: string
  label?: string
  count: number
  weight?: number
  metadata?: any
  system?: 'ESX' | 'OX' | string
}

export interface BanEntry {
  id: number
  license: string
  discord?: string
  steam?: string
  name: string
  reason: string
  admin: string
  expiry?: number
  created_at: string
}
