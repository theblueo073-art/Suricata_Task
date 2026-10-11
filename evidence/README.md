# Evidence Collection Guide

Save only genuine output from your own lab. This repository intentionally contains no fabricated screenshots or successful command output.

## Suggested screenshots

1. `01-suricata-version.png` — terminal showing `suricata -V` or `suricata --build-info`; proves the installed version.
2. `02-interface-and-route.png` — `ip addr` and `ip route`; proves which interface/network you identified.
3. `03-configuration-backup.png` — `ls -l /etc/suricata/`; proves the backup file exists.
4. `04-home-net-and-interface.png` — relevant `HOME_NET` and `af-packet` configuration; proves the chosen network/interface settings.
5. `05-rules-updated.png` — `suricata-update` result and/or listing of `/var/lib/suricata/rules/`.
6. `06-custom-local-rule.png` — output of `sudo grep -n "SURICATA ICMP TEST ALERT" /etc/suricata/rules/local.rules`; proves the rule exists.
7. `07-rule-files-configured.png` — relevant `rule-files` YAML section; proves the custom rule file is referenced.
8. `08-configuration-test.png` — output of `sudo suricata -T -c /etc/suricata/suricata.yaml`; proves the test result.
9. `09-service-status.png` — `sudo systemctl status suricata`; proves the observed service state.
10. `10-icmp-test-traffic.png` — `ping -c 4 <AUTHORIZED-LAB-HOST-IP>` with your actual target and output.
11. `11-fast-log-alert.png` — real `fast.log` alert showing `SURICATA ICMP TEST ALERT` and SID `1000001`, if generated.
12. `12-eve-json-alert.png` — optional real alert event from `eve.json`.

## Terminal output

Save text output in `evidence/terminal-output/` when useful. Suggested names:
- `suricata-version.txt`
- `interface-and-route.txt`
- `configuration-test.txt`
- `rule-verification.txt`
- `service-status.txt`
- `icmp-test.txt`
- `alert-log-extract.txt`

Capture evidence immediately after the corresponding step. Keep enough context visible to show which command produced the output. Do not alter output to make it appear successful. If a step fails, you may save the failure as troubleshooting evidence.

Avoid exposing passwords, tokens, unrelated personal information, or other sensitive system details in screenshots.
