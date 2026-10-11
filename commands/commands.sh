#!/usr/bin/env bash
# Suricata setup/custom ICMP rule lab command reference.
# MANUAL RUNBOOK: do not run this entire file as a batch.
# Review each command and follow workflow/workflow.md.
# Replace placeholders with values discovered in YOUR lab.

# 1) Check Suricata installation/version (normal user)
suricata --build-info
suricata -V

# Only if Suricata is not installed:
sudo apt update
sudo apt install suricata -y
suricata -V

# 2) Identify your real network interface and network (normal user)
ip addr
ip route

# 3) Back up the configuration (sudo)
sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.backup
ls -l /etc/suricata/

# 4) Manually edit configuration (sudo; interactive)
sudo nano /etc/suricata/suricata.yaml
# Review HOME_NET, af-packet interface, default-rule-path, and rule-files.
# Save/exit in nano: Ctrl+O, Enter, Ctrl+X.

# 5) Update default rules (sudo)
sudo suricata-update
ls -lh /var/lib/suricata/rules/

# 6) Create custom rules file (sudo; interactive)
sudo mkdir -p /etc/suricata/rules
sudo nano /etc/suricata/rules/local.rules
# Add this exact one-line rule:
# alert icmp any any -> any any (msg:"SURICATA ICMP TEST ALERT"; sid:1000001; rev:1;)

# 7) Add /etc/suricata/rules/local.rules under rule-files in suricata.yaml.
# Preserve other needed entries and avoid duplicate rule-files keys.
sudo nano /etc/suricata/suricata.yaml

# 8) Test configuration BEFORE starting/restarting (sudo)
sudo suricata -T -c /etc/suricata/suricata.yaml
# If this fails, stop here, investigate, fix, and rerun the test.

# 9) Check custom rule (sudo)
sudo suricata -T -c /etc/suricata/suricata.yaml 2>&1 | grep 1000001
sudo suricata -T -c /etc/suricata/suricata.yaml 2>&1 | grep "SURICATA ICMP TEST ALERT"
sudo grep -n "SURICATA ICMP TEST ALERT" /etc/suricata/rules/local.rules

# 10) Only after the test passes, restart and inspect service (sudo)
sudo systemctl restart suricata
sudo systemctl status suricata
sudo tail -n 80 /var/log/suricata/suricata.log

# Optional live service log; stop with Ctrl+C
sudo tail -f /var/log/suricata/suricata.log

# 11) Generate ICMP traffic to an authorized lab host.
# Replace <AUTHORIZED-LAB-HOST-IP> with the real target IP; do not include angle brackets.
ping -c 4 <AUTHORIZED-LAB-HOST-IP>

# 12) Inspect alerts; stop tail with Ctrl+C
sudo tail -f /var/log/suricata/fast.log
sudo tail -f /var/log/suricata/eve.json

# Optional pretty JSON output; install jq only if needed.
sudo apt install jq -y
sudo tail -f /var/log/suricata/eve.json | jq
