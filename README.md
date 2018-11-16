# shadowsocks-local

## default

```sh
SERVER      127.0.0.1
PORT        8388
METHOD      aes-256-gcm
PASSWORD    123456
TIMEOUT     300
```

## run

```sh
docker run --restart=always -itd -p 1080:1080 -e "SERVER=1.1.1.1" -e "PASSWORD=123456" modules/shadowsocks-local
```
