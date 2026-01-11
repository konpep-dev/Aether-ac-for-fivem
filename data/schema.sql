-- Wasteland Admesxlegacy_5bcb97in Panel Database Schema
-- Run this SQL to create all required tables

-- =============================================
-- Admin Permissions Table
-- =============================================
CREATE TABLE IF NOT EXISTS `admin_permissions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(100) NOT NULL UNIQUE,
    `admin_group` VARCHAR(50) NOT NULL,
    `added_by` VARCHAR(100),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Bans Table
-- =============================================
CREATE TABLE IF NOT EXISTS `admin_bans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `license` VARCHAR(100),
    `license2` VARCHAR(100),
    `discord` VARCHAR(100),
    `steam` VARCHAR(100),
    `xbl` VARCHAR(100),
    `live` VARCHAR(100),
    `fivem` VARCHAR(100),
    `ip` VARCHAR(50),
    `tokens` TEXT,
    `name` VARCHAR(100),
    `reason` TEXT,
    `admin` VARCHAR(100),
    `expiry` BIGINT,
    `screenshot_url` VARCHAR(500),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_license` (`license`),
    INDEX `idx_license2` (`license2`),
    INDEX `idx_discord` (`discord`),
    INDEX `idx_steam` (`steam`),
    INDEX `idx_fivem` (`fivem`),
    INDEX `idx_ip` (`ip`),
    INDEX `idx_expiry` (`expiry`),
    FULLTEXT `idx_tokens` (`tokens`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Logs Table
-- =============================================
CREATE TABLE IF NOT EXISTS `admin_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `log_type` VARCHAR(50) NOT NULL,
    `player_name` VARCHAR(100),
    `player_license` VARCHAR(100),
    `player_discord` VARCHAR(100),
    `target_name` VARCHAR(100),
    `target_license` VARCHAR(100),
    `details` TEXT,
    `coords` VARCHAR(100),
    `screenshot` LONGTEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_log_type` (`log_type`),
    INDEX `idx_player_license` (`player_license`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Anticheat TOS Table
-- =============================================
CREATE TABLE IF NOT EXISTS `anticheat_tos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `license` VARCHAR(100) NOT NULL UNIQUE,
    `discord` VARCHAR(100),
    `steam` VARCHAR(100),
    `name` VARCHAR(100),
    `accepted` TINYINT(1) DEFAULT 0,
    `accepted_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Anticheat Identifiers Table
-- =============================================
CREATE TABLE IF NOT EXISTS `anticheat_identifiers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100),
    `license` VARCHAR(100),
    `license2` VARCHAR(100),
    `discord` VARCHAR(100),
    `steam` VARCHAR(100),
    `xbl` VARCHAR(100),
    `live` VARCHAR(100),
    `fivem` VARCHAR(100),
    `ip` VARCHAR(50),
    `tokens` TEXT,
    `first_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `last_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `times_connected` INT DEFAULT 1,
    INDEX `idx_license` (`license`),
    INDEX `idx_discord` (`discord`),
    INDEX `idx_steam` (`steam`),
    INDEX `idx_fivem` (`fivem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Anticheat ID Changes Table
-- =============================================
CREATE TABLE IF NOT EXISTS `anticheat_id_changes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100),
    `identifier_type` VARCHAR(50),
    `old_value` VARCHAR(255),
    `new_value` VARCHAR(255),
    `matched_by` VARCHAR(50),
    `matched_value` VARCHAR(255),
    `is_suspicious` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_name` (`name`),
    INDEX `idx_suspicious` (`is_suspicious`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
