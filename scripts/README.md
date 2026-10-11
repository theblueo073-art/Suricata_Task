# Scripts

## `verify-lab.sh`

Performs read-only checks for the local rule file, Suricata configuration test, service status, and log-file presence. It does not edit configuration, restart services, generate traffic, or claim that an alert was observed.

Run:
```bash
chmod +x scripts/verify-lab.sh
./scripts/verify-lab.sh
```

Some checks use `sudo` and may prompt for your password. Run only on the Kali system where you are configuring Suricata. A missing log file or stopped service is reported as a finding to investigate, not silently repaired.
