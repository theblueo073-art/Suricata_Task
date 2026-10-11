# Task Overview: Suricata Setup and Custom ICMP Rule

## Objective

Configure Suricata on Kali Linux, ensure the appropriate rules are loaded, add a custom ICMP alert rule, and verify alert generation through Suricata logs.

## Required workflow

1. Check Suricata installation/version.
2. Identify the interface to monitor.
3. Back up `/etc/suricata/suricata.yaml`.
4. Open and review the Suricata YAML configuration.
5. Set `HOME_NET` to the actual lab network as appropriate.
6. Set the `af-packet` interface to the interface discovered on the system.
7. Confirm `default-rule-path` and `rule-files`.
8. Run `sudo suricata-update`.
9. Create `/etc/suricata/rules/local.rules` containing:
   ```text
   alert icmp any any -> any any (msg:"SURICATA ICMP TEST ALERT"; sid:1000001; rev:1;)
   ```
10. Add `/etc/suricata/rules/local.rules` to `rule-files`.
11. Save the configuration.
12. Test configuration with `sudo suricata -T -c /etc/suricata/suricata.yaml`.
13. Search test output for SID `1000001` or the custom alert message.
14. Confirm the rule exists in `local.rules`.
15. Restart and check the Suricata service.
16. Inspect `/var/log/suricata/suricata.log`.
17. Generate ICMP traffic to an authorized lab host.
18. Inspect `/var/log/suricata/fast.log`.
19. Optionally inspect `/var/log/suricata/eve.json`, using `jq` if installed.

## Important configuration items

- `HOME_NET`: local/internal network range(s) relevant to the monitored environment.
- `af-packet`: interface Suricata should monitor; it must match the actual interface.
- `default-rule-path`: in the guide, `/var/lib/suricata/rules`.
- `rule-files`: the guide uses `suricata.rules` and adds the full path `/etc/suricata/rules/local.rules`.

## Expected final artifacts on the lab system

- `/etc/suricata/suricata.yaml`
- `/etc/suricata/suricata.yaml.backup`
- `/etc/suricata/rules/local.rules`
- `/var/lib/suricata/rules/suricata.rules`
- `/var/log/suricata/suricata.log`
- `/var/log/suricata/fast.log`
- `/var/log/suricata/eve.json` (normally available in the described setup)

These are paths described by the source guide; actual availability can vary with installation and configuration.

## Submission scope

The supplied guide does not specify a formal external submission portal or required file format. This project therefore provides evidence guidance and placeholders for recording your actual command history and final observations without inventing results.
