-- ============================================
-- MIGRATION: Add All Identifiers to Ban Table
-- Run this ONCE to upgrade existing database
-- ============================================

-- Add new identifier columns
ALTER TABLE admin_bans 
ADD COLUMN IF NOT EXISTS license2 VARCHAR(100) AFTER license,
ADD COLUMN IF NOT EXISTS xbl VARCHAR(100) AFTER steam,
ADD COLUMN IF NOT EXISTS live VARCHAR(100) AFTER xbl,
ADD COLUMN IF NOT EXISTS fivem VARCHAR(100) AFTER live,
ADD COLUMN IF NOT EXISTS ip VARCHAR(50) AFTER fivem,
ADD COLUMN IF NOT EXISTS tokens TEXT AFTER ip,
ADD COLUMN IF NOT EXISTS screenshot_url TEXT AFTER expiry;

-- Add indexes for faster lookups
CREATE INDEX IF NOT EXISTS idx_license2 ON admin_bans(license2);
CREATE INDEX IF NOT EXISTS idx_xbl ON admin_bans(xbl);
CREATE INDEX IF NOT EXISTS idx_live ON admin_bans(live);
CREATE INDEX IF NOT EXISTS idx_fivem ON admin_bans(fivem);
CREATE INDEX IF NOT EXISTS idx_ip ON admin_bans(ip);

-- Show result
SELECT 'Migration completed successfully!' AS status;
SELECT COUNT(*) AS total_bans FROM admin_bans;
