#!/usr/bin/env bash
# Usage: ./run_scans.sh <target-ip>
# Only run against machines you own or have permission to scan.
set -e
TARGET="${1:?Usage: $0 <target-ip>}"
OUT="scan_output"
mkdir -p "$OUT"

echo "[1/3] Basic scan..."
nmap "$TARGET" | tee "$OUT/01_basic.txt"

echo "[2/3] Service version scan..."
nmap -sV "$TARGET" | tee "$OUT/02_sV.txt"

echo "[3/3] OS detection scan (needs sudo)..."
sudo nmap -O "$TARGET" | tee "$OUT/03_O.txt"

echo "Done. Results saved in $OUT/. Take screenshots and copy output into nmap_scan_results.txt"
