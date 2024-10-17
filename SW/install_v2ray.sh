#!/bin/sh

WORKSPACE=/tmp/v2ray
RELEASE_FILE=v2ray-linux-64.zip
SRC_DIR=v2ray-linux-64
CONFIG_FILE=$(dirname $(realpath $0))/config.json

echo $CONFIG_FILE
if [ ! -d $WORKSPACE ]; then
	mkdir $WORKSPACE
fi

echo "[INFO] Changed to workspace, $WORKSPACE"
cd $WORKSPACE

if [ -d $SRC_DIR ]; then
	rm -rf $SRC_DIR
fi

if [ ! -f $RELEASE_FILE ]; then
	echo "[INFO] Download v2ray"
	wget https://github.com/v2fly/v2ray-core/releases/download/v4.31.0/${RELEASE_FILE}
fi

unzip v2ray-linux-64.zip -d $SRC_DIR

if [ ! -f $CONFIG_FILE ]; then
	echo "[WARN] Use default config file!"
else
	echo "[INFO] Replace config file."
	cp -v $CONFIG_FILE ${SRC_DIR}/config.json
fi

cd $SRC_DIR
sudo -v
sudo mv -v v2ray /usr/local/bin/v2ray
sudo mv -v v2ctl /usr/local/bin/v2ctl
sudo mkdir -p /usr/local/share/v2ray
sudo mv -v geoip.dat /usr/local/share/v2ray/geoip.dat
sudo mv -v geosite.dat /usr/local/share/v2ray/geosite.dat
sudo mkdir -p /usr/local/etc/v2ray
sudo mv -v config.json /usr/local/etc/v2ray/config.json
sudo mv -v access.log /var/log/v2ray/access.log
sudo mv -v error.log /var/log/v2ray/error.log
sudo mv -v systemd/system/v2ray.service /etc/systemd/system/v2ray.service
sudo mv -v systemd/system/v2ray@.service /etc/systemd/system/v2ray@.service
cd -

export http_proxy=http://127.0.0.1:6790
export https_proxy=http://127.0.0.1:6790
export all_proxy=socks5://127.0.0.1:6789
export HTTP_PROXY=http://127.0.0.1:6790
export HTTPS_PROXY=http://127.0.0.1:6790
export ALL_PROXY=socks5://127.0.0.1:6789

# 启动V2ray
sudo systemctl start v2ray.service
echo "[INFO] Wait v2ray.service starting, sleep 5s"
sleep 5

# 检查V2ray状态
sudo systemctl --no-pager status v2ray.service

# 设置V2ray开机自启动
#sudo systemctl enable v2ray

echo "[INFO] Proxy test"
curl -I https://www.google.com
if [ "$?" = "0" ]; then
	echo "\n[INFO] Install v2ray, ok"
else
	echo "\n[ERR] Install v2ray, error!"
fi

sudo systemctl stop v2ray.service
