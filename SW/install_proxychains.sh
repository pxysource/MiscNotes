#!/bin/sh

WORKSPACE=/tmp/proxychains
BUILD_DIR=proxychains-4.4.0
RELEASE_FILE=proxychains-4.4.0.tar.gz
# Proxy port
PORT=6789

export http_proxy=http://127.0.0.1:6790
export https_proxy=http://127.0.0.1:6790
export all_proxy=socks5://127.0.0.1:6789
export HTTP_PROXY=http://127.0.0.1:6790
export HTTPS_PROXY=http://127.0.0.1:6790
export ALL_PROXY=socks5://127.0.0.1:6789

if [ ! -d $WORKSPACE ]; then
	mkdir $WORKSPACE
fi

echo "[INFO] Change to workspce, \"${WORKSPACE}\""
cd $WORKSPACE

if [ -d $BUILD_DIR ]; then
	rm -rf $BUILD_DIR
fi

if [ ! -f $RELEASE_FILE ]; then
	echo "[INFO] Download proxychain"
	wget https://github.com/haad/proxychains/archive/refs/tags/${RELEASE_FILE}
fi

mkdir $BUILD_DIR
tar --strip-components 1 -xvf ${RELEASE_FILE} -C $BUILD_DIR

cd $BUILD_DIR
echo "[INFO] Modify proxychains.conf"
echo "[INFO] Port=${PORT}"
sed -i ':a;N;$!ba;s/\n[[:space:]]*\n/\n/; ta' src/proxychains.conf
sed -i '$ { /^$/d; }' src/proxychains.conf
sed -i '$s/.*/\# Use socks5. My port is '"${PORT}"'./' src/proxychains.conf
echo "socks5\t127.0.0.1\t${PORT}" >> src/proxychains.conf

./configure

echo "[INFO] make"
make || exit 1

echo "[INFO] make install"
sudo make install
sudo make install-config
