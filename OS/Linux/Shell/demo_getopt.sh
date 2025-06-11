#!/bin/sh

PROGRAM=$(basename $0)

usage() {
cat << EOF
Usage: $PROGRAM <OPTION>

OPTION
    -h, --help      Show help information.
    -p, --patch     Patching the kernel.
    -b, --build     Build.
    -c, --clean     Clean cache files and dirs.
    -r, --rebuild   Clean, config and build.
    -i, --install   Install path.
    -v, --version   Show version.
EOF
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

ARGS=`getopt -o "hpbcri:v" -l "help,patch,build,clean,rebuild,install:,version" -n ${PROGRAM} -- "$@"`
if [ $? != 0 ]; then
    echo "[ERR] getopt error!"
    exit 1
fi

eval set -- "$ARGS"

while true; do
    case "$1" in
        --help | -h)
            shift
            usage
            exit 0
            ;;
        --pacth | -p)
            shift
            echo "patch"
            ;;
        --build | -b)
            shift
            echo "build"
            ;;
        --clean | -c)
            shift
            echo "clean"
            ;;
        --rebuild | -r)
            shift
            echo "rebuild"
            ;;
        --install | -i)
            shift
            if [[ -n "$1" ]]; then
                INSTALL_PATH="$1"
            else
                echo "[WARN] Install path is empty, use default!"
            fi
            shift
            echo "install path: ${INSTALL_PATH}"
            ;;
        --version | -v)
            shift
            echo "version"
            ;;
        --)
            shift
            REST_ARGS=("$@")
            break
            ;;
    esac
done

echo "Remaining arguments:"
for arg in "${REST_ARGS[@]}"; do
    echo "    arg -> ${arg}"
done
