#!/usr/bin/env bash
TARGET=$1
OUT=reports/${TARGET}_nmap.txt
mkdir -p reports
echo "[*] Running nmap against $TARGET -> $OUT"
nmap -sV -O --script=vulners --script-args mincvss=4.0 -oN "$OUT" "$TARGET"
echo "[*] Done. See $OUT"
