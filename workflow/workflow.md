# Detailed Lab Workflow

## Phase 1 — Check Suricata installation

**Run as:** normal user; use `sudo` only if your environment requires it.

1. Check build details:
   ```bash
   suricata --build-info
   ```
   Alternatively:
   ```bash
   suricata -V
   ```
2. If the command is not found, install Suricata:
   ```bash
   sudo apt update
   sudo apt install suricata -y
   ```
3. Verify again:
   ```bash
   suricata -V
   ```

**Expected result:** a Suricata version is displayed.  
**Evidence:** capture the version output.  
**Note:** package installation changes the system and requires administrator permission.

## Phase 2 — Identify the interface and network

**Run as:** normal user.

```bash
ip addr
ip route
```

Find the interface associated with the relevant IP/default route. The guide gives examples such as `eth0`, `wlan0`, and `enp0s3`; these are examples only.

Record:
- Interface name: `[RECORD YOUR INTERFACE]`
- Local IP/prefix: `[RECORD YOUR IP/PREFIX]`
- Relevant local network/CIDR: `[RECORD YOUR NETWORK]`

**Expected result:** you can identify the actual interface and network to monitor.  
**Verification:** compare `ip addr` with the device named after `dev` in the default route, where applicable.  
**Evidence:** screenshot showing `ip addr` and `ip route`.  
**Important:** do not blindly use `eth0` or copy the sample network `192.168.1.0/24`.

## Phase 3 — Back up the configuration

**Run as:** user with `sudo` privileges.

```bash
sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.backup
ls -l /etc/suricata/
```

**Purpose:** preserve the original configuration before editing.  
**Expected result:** both `suricata.yaml` and `suricata.yaml.backup` appear.  
**Evidence:** capture the listing.  
**Recovery note:** if needed, restore the backup with `sudo cp /etc/suricata/suricata.yaml.backup /etc/suricata/suricata.yaml` (this overwrites the current YAML file, so do this only when you intend to discard its current changes).

## Phase 4 — Review and configure `suricata.yaml`

**Run as:** user with `sudo` privileges.

```bash
sudo nano /etc/suricata/suricata.yaml
```

In nano, use `Ctrl+W` to search for each setting.

### 4A. `HOME_NET`

Set or review `HOME_NET` so it reflects the actual monitored lab network. The source guide gives this as an example for a single network:

```yaml
HOME_NET: "[192.168.1.0/24]"
```

Do not copy this example unless it matches your actual network. Preserve additional relevant networks when your lab uses more than one.

### 4B. `af-packet`

Find the `af-packet` section and make its `interface` match the real interface found in Phase 2. For example only:

```yaml
af-packet:
  - interface: eth0
```

Do not replace other options in the section without a reason.

### 4C. Rule path

Review that the configuration uses the intended rule path and rule file, as described by the guide:

```yaml
default-rule-path: /var/lib/suricata/rules

rule-files:
  - suricata.rules
```

Save and exit for now with `Ctrl+O`, `Enter`, then `Ctrl+X`.

**Expected result:** the YAML reflects the actual interface/network and has the expected rule path.  
**Verification:** later run the configuration test in Phase 8.  
**Evidence:** capture a screenshot of the relevant configuration sections if permitted, avoiding unrelated sensitive configuration.  
**Note:** YAML indentation matters.

## Phase 5 — Update the default ruleset

**Run as:** user with `sudo` privileges.

```bash
sudo suricata-update
ls -lh /var/lib/suricata/rules/
```

**Purpose:** download/manage the default ruleset described in the guide.  
**Expected result:** `suricata.rules` is present in the rules directory.  
**Evidence:** capture the update completion and directory listing.  
**Note:** network access may be required.

## Phase 6 — Create the custom local rule

Create the rules directory if it does not already exist, then open the file:

```bash
sudo mkdir -p /etc/suricata/rules
sudo nano /etc/suricata/rules/local.rules
```

Add this exact rule on one line:

```text
alert icmp any any -> any any (msg:"SURICATA ICMP TEST ALERT"; sid:1000001; rev:1;)
```

Save with `Ctrl+O`, press `Enter`, and exit with `Ctrl+X`.

**Purpose:** generate an alert when matching ICMP traffic is observed.  
**Expected result:** the file contains the rule exactly once.  
**Verification:**
```bash
sudo grep -n "SURICATA ICMP TEST ALERT" /etc/suricata/rules/local.rules
```
**Evidence:** capture the rule file verification output.  
**Safety:** this is a broad ICMP test signature. Use it only in your authorized lab environment.

## Phase 7 — Add `local.rules` to the configuration

**Run as:** user with `sudo` privileges.

```bash
sudo nano /etc/suricata/suricata.yaml
```

Find `rule-files`. Ensure the relevant entries include both the default rules file and the custom file:

```yaml
rule-files:
  - suricata.rules
  - /etc/suricata/rules/local.rules
```

Avoid creating duplicate `rule-files` keys. Preserve other rule entries already present if your configuration requires them. Save and exit.

**Expected result:** Suricata is configured to load the default rules and the custom local rule.  
**Verification:** Phase 8 tests the complete configuration; Phase 9 searches for the custom SID/message.  
**Evidence:** capture the relevant `rule-files` section if appropriate.

## Phase 8 — Test configuration before starting/restarting

**Run as:** user with `sudo` privileges.

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
```

**Purpose:** test configuration loading.  
**Expected result:** output indicates that the configuration was successfully loaded.  
**If an error appears:** do not restart/start the service yet. Read the error and check YAML indentation, interface name, file paths, and rule syntax; fix the issue and rerun the test.  
**Evidence:** capture the complete result, including any errors if troubleshooting is needed.

## Phase 9 — Verify that the custom rule is present and loaded

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml 2>&1 | grep 1000001
sudo suricata -T -c /etc/suricata/suricata.yaml 2>&1 | grep "SURICATA ICMP TEST ALERT"
sudo grep -n "SURICATA ICMP TEST ALERT" /etc/suricata/rules/local.rules
```

**Run as:** user with `sudo` privileges for the commands above.  
**Expected result:** the file check prints the custom rule; the test-output searches may print a matching line if Suricata's version/output includes the SID or message. A blank grep result alone is not conclusive; review the full test output as well.  
**Evidence:** save the rule verification and relevant test output.

## Phase 10 — Start/restart and inspect the service

Only proceed after the configuration test passes.

```bash
sudo systemctl restart suricata
sudo systemctl status suricata
```

**Expected result:** service status shows `active (running)` in the service-based setup.  
**Evidence:** capture the service status.  
**Troubleshooting:** if the service fails, inspect:
```bash
sudo tail -n 80 /var/log/suricata/suricata.log
```

To watch the log live:
```bash
sudo tail -f /var/log/suricata/suricata.log
```
Press `Ctrl+C` to stop following the log.

## Phase 11 — Generate authorized ICMP traffic

Open another terminal. Find your IP again if needed:

```bash
ip addr
```

Ping a reachable machine you own or are authorized to test. Replace the placeholder with its real IP:

```bash
ping -c 4 <AUTHORIZED-LAB-HOST-IP>
```

The source guide gives `192.168.1.1` and `<UBUNTU-IP>` as examples/placeholders; do not assume either is correct for your setup.

**Expected result:** ping replies may appear if the host is reachable and allows ICMP. Lack of replies does not by itself prove Suricata is broken.  
**Evidence:** capture the command and actual output.  
**Safety:** do not scan or generate test traffic against systems without permission.

## Phase 12 — Check alert logs

In another terminal:

```bash
sudo tail -f /var/log/suricata/fast.log
```

Look for an alert containing:

```text
SURICATA ICMP TEST ALERT
```

and SID `1000001`. Press `Ctrl+C` when finished.

Optionally inspect structured events:

```bash
sudo tail -f /var/log/suricata/eve.json
```

If `jq` is installed:
```bash
sudo tail -f /var/log/suricata/eve.json | jq
```

If needed, install it:
```bash
sudo apt install jq -y
```

Look for `"event_type": "alert"` and `"SURICATA ICMP TEST ALERT"`.

**Expected result:** if matching ICMP traffic reaches the monitored interface and the rule is loaded, the alert should be recorded.  
**If no alert appears:** confirm the correct interface is monitored, the test traffic traverses it, the rule is listed in `rule-files`, and the service/configuration is healthy.  
**Evidence:** capture the actual alert from `fast.log` and/or `eve.json`. Never fabricate an alert line.

## Phase 13 — Final review and submission

1. Complete the checklist in the main README.
2. Save real screenshots under `evidence/screenshots/`.
3. Save useful terminal output under `evidence/terminal-output/`.
4. Record actual commands in `submission/command-history.txt`.
5. Record observed results and any issues in `submission/final-output.txt`.
6. Review `submission/README.md` before submitting.

The uploaded guide does not define a separate formal submission portal or file format; follow any additional instructions given by your tutor.
