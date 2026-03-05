"""
Discord Screenshot Sender v2.1
Διαβάζει screenshots από τη MySQL βάση και τα στέλνει στο Discord
Τρέξε: python discord_screenshots.py
"""

import mysql.connector
import requests
import base64
import time
import os
import re
import json

# ============================================
# SETTINGS - Άλλαξε αυτά!
# ============================================
MYSQL_HOST = '127.0.0.1'
MYSQL_USER = 'root'
MYSQL_PASSWORD = ''  # Βάλε το password σου αν έχεις
MYSQL_DATABASE = 'esxlegacy_5bcb97'  # Το database name σου

# Discord Webhook
DISCORD_WEBHOOK = None

# Check interval (seconds)
CHECK_INTERVAL = 3  # Faster checking (was 10)

# File to track sent screenshots
SENT_FILE = os.path.join(os.path.dirname(__file__), '.sent_ids.json')

# Track the last processed ID (more reliable than tracking all IDs)
LAST_ID_FILE = os.path.join(os.path.dirname(__file__), '.last_id.txt')

# ============================================

def load_last_id():
    """Load the last processed ID from file"""
    if os.path.exists(LAST_ID_FILE):
        try:
            with open(LAST_ID_FILE, 'r') as f:
                return int(f.read().strip())
        except:
            pass
    return 0


def save_last_id(log_id):
    """Save the last processed ID to file"""
    try:
        with open(LAST_ID_FILE, 'w') as f:
            f.write(str(log_id))
    except Exception as e:
        print(f"[WARN] Could not save last ID: {e}")


def load_sent_ids():
    """Load already sent IDs from file (backup method)"""
    if os.path.exists(SENT_FILE):
        try:
            with open(SENT_FILE, 'r') as f:
                data = json.load(f)
                # Convert all to integers for consistent comparison
                return set(int(x) for x in data)
        except Exception as e:
            print(f"[WARN] Could not load sent IDs: {e}")
    return set()


def save_sent_id(log_id):
    """Save sent ID to file"""
    try:
        sent_ids = load_sent_ids()
        sent_ids.add(int(log_id))
        
        # Keep only last 1000 IDs to prevent file from growing too large
        if len(sent_ids) > 1000:
            sent_ids = set(sorted(sent_ids)[-1000:])
        
        with open(SENT_FILE, 'w') as f:
            json.dump(list(sent_ids), f)
        
        # Also update last ID
        save_last_id(log_id)
    except Exception as e:
        print(f"[WARN] Could not save sent ID: {e}")


def load_webhook_from_config():
    """Load webhook from config.lua"""
    global DISCORD_WEBHOOK
    
    paths = ['../config.lua', 'config.lua', '../../config.lua']
    
    for path in paths:
        try:
            full_path = os.path.join(os.path.dirname(__file__), path)
            with open(full_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find screenshots or anticheat webhook
            for key in ['screenshots', 'anticheat', 'main']:
                match = re.search(rf"{key}\s*=\s*['\"]([^'\"]+)['\"]", content)
                if match and 'discord.com' in match.group(1):
                    DISCORD_WEBHOOK = match.group(1)
                    print(f"[OK] Loaded {key} webhook")
                    return True
        except:
            continue
    
    return False


def get_db_connection():
    """Connect to MySQL"""
    try:
        conn = mysql.connector.connect(
            host=MYSQL_HOST,
            user=MYSQL_USER,
            password=MYSQL_PASSWORD,
            database=MYSQL_DATABASE
        )
        return conn
    except Exception as e:
        print(f"[ERROR] MySQL connection failed: {e}")
        return None


def send_to_discord(log_id, log_type, player_name, target_name, details, screenshot_base64, timestamp, player_license=None):
    """Send screenshot to Discord with beautiful embed"""
    
    if not DISCORD_WEBHOOK:
        print("[ERROR] No webhook configured")
        return False
    
    try:
        # Decode base64 image
        if not screenshot_base64 or len(screenshot_base64) < 100:
            print(f"[SKIP] ID {log_id} - No valid screenshot data")
            return True  # Return True to mark as processed
        
        # Remove data URI prefix if exists
        if 'base64,' in screenshot_base64:
            img_data = screenshot_base64.split('base64,')[1]
        else:
            img_data = screenshot_base64
        
        img_bytes = base64.b64decode(img_data)
        
        # Detection types with icons and colors
        detection_config = {
            'screenshot': {'icon': '📸', 'title': 'SCREENSHOT', 'color': 3447003, 'is_ban': False},
            'noclip': {'icon': '🚀', 'title': 'NOCLIP DETECTED', 'color': 16711680, 'is_ban': True},
            'godmode': {'icon': '🛡️', 'title': 'GODMODE DETECTED', 'color': 16711680, 'is_ban': True},
            'aimbot': {'icon': '🎯', 'title': 'AIMBOT DETECTED', 'color': 16711680, 'is_ban': True},
            'freecam': {'icon': '📹', 'title': 'FREECAM DETECTED', 'color': 16711680, 'is_ban': True},
            'teleport': {'icon': '⚡', 'title': 'TELEPORT DETECTED', 'color': 16711680, 'is_ban': True},
            'silent_aim': {'icon': '🎯', 'title': 'SILENT AIM DETECTED', 'color': 16711680, 'is_ban': True},
            'resource_stop': {'icon': '📦', 'title': 'RESOURCE STOP', 'color': 16711680, 'is_ban': True},
            'heartbeat_fail': {'icon': '💓', 'title': 'ANTICHEAT DISABLED', 'color': 16711680, 'is_ban': True},
            'anticheat_ban': {'icon': '🚨', 'title': 'ANTICHEAT BAN', 'color': 16711680, 'is_ban': True},
            'vehicle': {'icon': '🚗', 'title': 'ILLEGAL VEHICLE', 'color': 16744192, 'is_ban': True},
            'weapon': {'icon': '🔫', 'title': 'ILLEGAL WEAPON', 'color': 16744192, 'is_ban': True},
        }
        
        config = detection_config.get(log_type, {'icon': '⚠️', 'title': log_type.upper(), 'color': 16776960, 'is_ban': False})
        
        # Format timestamp nicely
        try:
            if isinstance(timestamp, str):
                formatted_time = timestamp
            else:
                formatted_time = timestamp.strftime('%Y-%m-%d %H:%M:%S')
        except:
            formatted_time = str(timestamp)
        
        # Build beautiful embed
        embed = {
            "title": f"{config['icon']} {config['title']}",
            "description": f"{'🚫 **BANNED**' if config['is_ban'] else '📋 **Log Entry**'}",
            "color": config['color'],
            "thumbnail": {
                "url": "https://i.imgur.com/oBQXYQX.png"
            },
            "fields": [
                {
                    "name": "👤 Player",
                    "value": f"```{player_name or 'Unknown'}```",
                    "inline": True
                },
                {
                    "name": "🔍 Detection",
                    "value": f"```{log_type}```",
                    "inline": True
                },
                {
                    "name": "📝 Details",
                    "value": f"```{(details or 'N/A')[:200]}```",
                    "inline": False
                }
            ],
            "image": {"url": "attachment://screenshot.jpg"},
            "footer": {
                "text": f"🛡️ Aether Anticheat • Log ID: {log_id}",
                "icon_url": "https://i.imgur.com/AfFp7pu.png"
            },
            "timestamp": formatted_time if 'T' in str(formatted_time) else None
        }
        
        # Add license if available
        if player_license:
            embed["fields"].insert(2, {
                "name": "🔑 License",
                "value": f"```{player_license[:50]}```",
                "inline": True
            })
        
        if target_name:
            embed["fields"].insert(0, {"name": "🎯 Target", "value": f"```{target_name}```", "inline": True})
        
        # Send with image attachment
        files = {
            'file': ('screenshot.jpg', img_bytes, 'image/jpeg')
        }
        
        payload = {
            'payload_json': json.dumps({
                "username": "🛡️ Anticheat Screenshots",
                "embeds": [embed]
            })
        }
        
        resp = requests.post(DISCORD_WEBHOOK + "?wait=true", files=files, data=payload, timeout=30)
        
        if resp.status_code in [200]:
            print(f"[OK] Sent {log_type} screenshot (ID: {log_id}) - {player_name}")
            
            # Get the image URL from Discord response
            try:
                response_data = resp.json()
                image_url = None
                
                # Try to get URL from attachments first
                if 'attachments' in response_data and len(response_data['attachments']) > 0:
                    image_url = response_data['attachments'][0].get('url') or response_data['attachments'][0].get('proxy_url')
                    print(f"[DEBUG] Found URL in attachments")
                
                # If not in attachments, try embeds
                if not image_url and 'embeds' in response_data and len(response_data['embeds']) > 0:
                    embed = response_data['embeds'][0]
                    if 'image' in embed and embed['image']:
                        image_url = embed['image'].get('url') or embed['image'].get('proxy_url')
                        print(f"[DEBUG] Found URL in embed image")
                
                if image_url and player_license:
                    save_screenshot_url(player_license, image_url)
                    print(f"[OK] Saved screenshot URL: {image_url[:80]}...")
                elif image_url:
                    print(f"[WARN] Got URL but no license to save")
                else:
                    print(f"[WARN] No image URL found in response")
                    
            except Exception as e:
                print(f"[WARN] Could not parse Discord response: {e}")
            
            return True
        elif resp.status_code == 204:
            print(f"[OK] Sent {log_type} screenshot (ID: {log_id}) - {player_name} (no response body)")
            return True
        else:
            print(f"[ERROR] Discord error {resp.status_code}: {resp.text[:100]}")
            return False
        
    except Exception as e:
        print(f"[ERROR] Failed to send ID {log_id}: {e}")
        return False


def save_screenshot_url(player_license, image_url):
    """Save the Discord image URL to admin_bans table"""
    try:
        conn = get_db_connection()
        if not conn:
            print("[ERROR] Could not connect to DB to save URL")
            return
        
        cursor = conn.cursor()
        
        # FIXED: Find the most recent ban for this license (within last 5 minutes)
        # This ensures we update the correct ban even if screenshot_url already has a value
        cursor.execute("""
            SELECT id FROM admin_bans 
            WHERE license = %s 
            AND created_at >= DATE_SUB(NOW(), INTERVAL 5 MINUTE)
            ORDER BY id DESC LIMIT 1
        """, (player_license,))
        
        result = cursor.fetchone()
        if result:
            ban_id = result[0]
            cursor.execute("""
                UPDATE admin_bans 
                SET screenshot_url = %s 
                WHERE id = %s
            """, (image_url, ban_id))
            conn.commit()
            print(f"[OK] Updated ban ID {ban_id} with screenshot URL")
        else:
            print(f"[WARN] No recent ban found for license {player_license[:30]}...")
        
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"[ERROR] Failed to save screenshot URL: {e}")


def process_pending_screenshots():
    """Check for new screenshots and send them"""
    
    conn = get_db_connection()
    if not conn:
        return
    
    sent_ids = load_sent_ids()
    last_id = load_last_id()
    
    try:
        cursor = conn.cursor(dictionary=True)
        
        # FIXED: Only get logs with ID greater than last processed
        # This prevents re-sending old screenshots
        cursor.execute("""
            SELECT id, log_type, player_name, player_license, target_name, details, screenshot, created_at 
            FROM admin_logs 
            WHERE screenshot IS NOT NULL 
            AND LENGTH(screenshot) > 100
            AND id > %s
            ORDER BY id ASC
            LIMIT 20
        """, (last_id,))
        
        rows = cursor.fetchall()
        new_count = 0
        
        for row in rows:
            log_id = int(row['id'])
            
            # Double-check: Skip if already sent (backup check)
            if log_id in sent_ids:
                # Update last_id anyway to skip this in future
                save_last_id(log_id)
                continue
            
            new_count += 1
            print(f"[NEW] Processing ID {log_id} ({row['log_type']})...")
            
            # Send to Discord (now includes player_license)
            success = send_to_discord(
                log_id,
                row['log_type'],
                row['player_name'],
                row['target_name'],
                row['details'],
                row['screenshot'],
                row['created_at'],
                row['player_license']  # Pass license to save URL
            )
            
            if success:
                save_sent_id(log_id)
            else:
                # Even if failed, update last_id to prevent infinite retries
                save_last_id(log_id)
            
            # Rate limit - wait between sends
            time.sleep(1)
        
        if new_count == 0:
            pass  # No new screenshots, silent
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"[ERROR] Database error: {e}")


def main():
    print("=" * 50)
    print("  Discord Screenshot Sender v2.1")
    print("=" * 50)
    
    # Load webhook
    if not load_webhook_from_config():
        print("[ERROR] Could not load webhook from config.lua")
        print("Make sure config.lua exists with webhooks configured")
        return
    
    # Test database connection
    conn = get_db_connection()
    if not conn:
        print("[ERROR] Could not connect to MySQL")
        print(f"Check settings: {MYSQL_HOST}, {MYSQL_USER}, {MYSQL_DATABASE}")
        return
    
    # Get the max ID from database to initialize last_id if needed
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT MAX(id) FROM admin_logs WHERE screenshot IS NOT NULL")
        result = cursor.fetchone()
        max_db_id = result[0] if result[0] else 0
        cursor.close()
    except:
        max_db_id = 0
    
    conn.close()
    
    print(f"[OK] Connected to MySQL: {MYSQL_DATABASE}")
    print(f"[OK] Webhook loaded")
    print(f"[OK] Tracking file: {SENT_FILE}")
    
    # Show status
    sent_ids = load_sent_ids()
    last_id = load_last_id()
    
    # If first run (no last_id), set it to current max to avoid sending old screenshots
    if last_id == 0 and max_db_id > 0:
        print(f"[INFO] First run detected! Setting last ID to {max_db_id}")
        print(f"[INFO] Only NEW screenshots from now on will be sent")
        save_last_id(max_db_id)
        last_id = max_db_id
    
    print(f"[INFO] Already sent: {len(sent_ids)} screenshots")
    print(f"[INFO] Last processed ID: {last_id}")
    print(f"[INFO] Max DB ID: {max_db_id}")
    print(f"[INFO] Checking every {CHECK_INTERVAL} seconds...")
    print("=" * 50)
    print("Press Ctrl+C to stop")
    print("")
    
    # Main loop
    while True:
        try:
            process_pending_screenshots()
            time.sleep(CHECK_INTERVAL)
        except KeyboardInterrupt:
            print("\n[INFO] Stopped")
            break
        except Exception as e:
            print(f"[ERROR] {e}")
            time.sleep(CHECK_INTERVAL)


if __name__ == '__main__':
    main()
