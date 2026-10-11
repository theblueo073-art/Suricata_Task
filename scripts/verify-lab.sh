#!/usr/bin/env bash
# Read-only verification helper for the Suricata ICMP rule lab.
# Does not modify configuration, restart services, or generate network traffic.
set -u

CONFIG="/etc/suricata/suricata.yaml"
RULE="/etc/suricata/rules/local.rules"
FAST_LOG="/var/log/suricata/fast.log"
EVE_LOG="/var/log/suricata/eve.json"

printf '%s\n' "== Suricata version =="
if command -v suricata >/dev/null 2>&1; then
  suricata -V
else
  echo "NOT FOUND: suricata command is unavailable."
fi

printf '\n%s\n' "== Configuration and custom rule =="
if [ -r "$CONFIG" ]; then
  echo "FOUND: $CONFIG"
  echo "Running configuration test (may request sudo password)..."
  if sudo suricata -T -c "$CONFIG"; then
    echo "PASS: Suricata configuration test returned success."
  else
    echo "FAIL: configuration test failed; review the error before restarting the service."
  fi
else
  echo "MISSING/UNREADABLE: $CONFIG"
fi

if [ -r "$RULE" ]; then
  echo "FOUND: $RULE"
  if sudo grep -nF 'SURICATA ICMP TEST ALERT' "$RULE"; then
    echo "PASS: custom alert message is present in local.rules."
  else
    echo "CHECK: expected alert message was not found in local.rules."
  fi
else
  echo "MISSING/UNREADABLE: $RULE"
fi

printf '\n%s\n' "== Service status =="
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl --no-pager --full status suricata || \
    echo "CHECK: service is not reporting a healthy running state."
else
  echo "systemctl is unavailable; service status check skipped."
fi

printf '\n%s\n' "== Log-file presence =="
for logfile in "$FAST_LOG" "$EVE_LOG" /var/log/suricata/suricata.log; do
  if [ -e "$logfile" ]; then
    ls -lh "$logfile"
  else
    echo "NOT PRESENT: $logfile"
  fi
done

printf '\n%s\n' "Verification checks complete. Review findings; no changes were made."
