#!/bin/sh
set -e

nohup ss-local -s $SERVER -p $PORT -m $METHOD -k $PASSWORD -t $TIMEOUT -b 0.0.0.0 -l 1081 -u --fast-open &
nohup polipo proxyAddress=0.0.0.0 proxyPort=1080 socksProxyType=socks5 socksParentProxy=127.0.0.1:1081 &

exec tail -f /dev/null