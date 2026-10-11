# Suricata Setup and Custom ICMP Alert Rule Lab

A GitHub-ready, learning-focused workflow for configuring Suricata on Kali Linux, updating its rules, adding a custom ICMP detection rule, validating the configuration, generating authorized test traffic, and checking alert logs.

> **Status:** This repository is a practical workflow/template. It does not contain fabricated results or screenshots. Perform the lab on your own system and save your real evidence in `evidence/`.

## Objective

Set up and verify Suricata so it can monitor the selected network interface and alert on ICMP traffic using this custom rule:

```text
alert icmp any any -> any any (msg:"SURICATA ICMP TEST ALERT"; sid:1000001; rev:1;)
```

## Lab requirements from the supplied guide

- Check that Suricata is installed; install it if it is missing.
- Identify the active network interface and its IP/network.
- Back up `/etc/suricata/suricata.yaml`.
- Review/configure `HOME_NET`, `af-packet`, `default-rule-path`, and `rule-files`.
- Run `sudo suricata-update`.
- Create `/etc/suricata/rules/local.rules` with the custom ICMP test rule.
- Reference `local.rules` in `/etc/suricata/suricata.yaml`.
- Test the configuration and look for SID `1000001` or the alert message.
- Restart/check the Suricata service, inspect logs, generate ICMP traffic, and verify alerts in `fast.log` and optionally `eve.json`.

## Tools and environment

- Kali Linux (physical or virtual machine)
- Terminal and `sudo` access
- Suricata and `suricata-update`
- A second machine/VM or another authorized lab host to ping
- Optional: `jq` for readable JSON output

Commands in this repository are examples for the documented Kali/Linux environment. Interface names, IP ranges, package versions, and output differ by system.

## Prerequisites and safety

1. Use a Kali system where you have administrator permission.
2. Identify the real interface with `ip route` and `ip addr`; **do not assume it is `eth0`**.
3. Determine your actual local network before changing `HOME_NET`. Do not blindly replace existing network ranges if your environment uses multiple networks.
4. Generate traffic only to a host/network you own or are explicitly authorized to test.
5. Back up the configuration before editing it.
6. Do not start/restart the service until the configuration test passes.

## Quick start

Follow the full instructions in [`workflow/workflow.md`](workflow/workflow.md). The high-level order is:

1. Check Suricata: `suricata --build-info` or `suricata -V`
2. Identify interface/network: `ip addr` and `ip route`
3. Back up and edit `/etc/suricata/suricata.yaml`
4. Update rules: `sudo suricata-update`
5. Create `/etc/suricata/rules/local.rules` using the rule above
6. Add the local rule path under `rule-files`
7. Test: `sudo suricata -T -c /etc/suricata/suricata.yaml`
8. Check that the rule exists/loads
9. Restart/check Suricata
10. Ping an authorized lab host and inspect `/var/log/suricata/fast.log`
11. Optionally inspect `/var/log/suricata/eve.json`

See [`commands/commands.sh`](commands/commands.sh) for a commented command reference. It is a **manual runbook**, not a script to execute as one batch, because it includes interactive editing and system-specific values.

## Project structure

```text
suricata-custom-icmp-rule-lab/
├── README.md
├── .gitignore
├── docs/
│   ├── README.md
│   └── task-overview.md
├── workflow/
│   ├── README.md
│   └── workflow.md
├── commands/
│   ├── README.md
│   └── commands.sh
├── scripts/
│   ├── README.md
│   └── verify-lab.sh
├── evidence/
│   ├── README.md
│   ├── screenshots/.gitkeep
│   └── terminal-output/.gitkeep
└── submission/
    ├── README.md
    ├── command-history.txt
    └── final-output.txt
```

## Expected results

Your real system should, if configured correctly:

- Report the installed Suricata version.
- Show the selected interface in `ip route`/`ip addr`.
- Have a backup at `/etc/suricata/suricata.yaml.backup`.
- Have `suricata.rules` and `local.rules` configured for loading.
- Pass `sudo suricata -T -c /etc/suricata/suricata.yaml`.
- Show the Suricata service running when the system uses the service-based setup.
- Generate a `SURICATA ICMP TEST ALERT` entry with SID `1000001` after matching ICMP traffic reaches the monitored interface.

These are expected outcomes, not claims that the lab has already been completed. If traffic does not reach the monitored interface or the service uses a different run mode, an alert may not appear.

## Evidence

Capture real screenshots and/or terminal output at the checkpoints described in [`evidence/README.md`](evidence/README.md). Do not add screenshots that imply success unless your own output demonstrates it.

## Troubleshooting

- **`suricata: command not found`:** install with `sudo apt update` and `sudo apt install suricata -y`, then verify with `suricata -V`.
- **Configuration test fails:** do not restart Suricata yet. Read the error, check YAML indentation, interface name, rule paths, and rule syntax; correct the issue and rerun the test.
- **Custom SID/message not found:** confirm the rule exists in `/etc/suricata/rules/local.rules` and that the full path is listed under `rule-files`.
- **Service does not start:** inspect `sudo systemctl status suricata` and `sudo tail -n 80 /var/log/suricata/suricata.log`.
- **No ICMP alert:** verify the monitored interface is correct, the ping target is authorized and reachable, and the traffic actually traverses the monitored interface. Check `fast.log` and `eve.json`.
- **`jq` is missing:** install it with `sudo apt install jq -y`, or inspect `eve.json` without it.

## Final verification checklist

- [ ] Suricata version checked
- [ ] Correct interface and local network identified
- [ ] Original configuration backed up
- [ ] `HOME_NET` reviewed/configured for the actual lab network
- [ ] `af-packet` interface matches the actual monitored interface
- [ ] Rule path and rule files checked
- [ ] Rules updated
- [ ] `local.rules` created with SID `1000001`
- [ ] Local rule referenced in `suricata.yaml`
- [ ] Configuration test passes
- [ ] Rule presence/load checked
- [ ] Service status and Suricata log checked
- [ ] Authorized ICMP traffic generated
- [ ] Alert checked in `fast.log`; `eve.json` checked if available
- [ ] Screenshots/output saved
- [ ] Submission files completed with actual results

## Source

Prepared from the uploaded **“Siricata Setup” / Suricata Documentation** guide (16 pages). Where the guide leaves system-specific values open, this workflow uses placeholders and instructs you to discover the real values rather than inventing them.
