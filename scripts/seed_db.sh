#!/usr/bin/env bash
set -e
mkdir -p services/thermostat/db
DB=services/thermostat/db/users.sqlite
if [ -f "$DB" ]; then
  echo "DB already exists: $DB"
  exit 0
fi
echo "[*] Creating SQLite DB with weak credentials..."
python3 - <<'PY'
import sqlite3,hashlib,os
os.makedirs("services/thermostat/db", exist_ok=True)
db="services/thermostat/db/users.sqlite"
conn=sqlite3.connect(db)
c=conn.cursor()
c.execute("CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)")
# Insert admin with password 'password' (MD5) - for cracking practice
pwd=hashlib.md5(b'password').hexdigest()
c.execute("INSERT INTO users(username,password) VALUES (?,?)", ("admin", pwd))
conn.commit()
conn.close()
print("Created", db)
PY
