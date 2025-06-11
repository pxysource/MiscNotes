#!/bin/sh

PROGRAM=$(basename $0)

usage() {
cat << EOF
Usage: $PROGRAM <OPTION>

OPTION
    -h          Show help information.
    -d <days>   Delete days.
    -D          Delete original.
    -f <dir>    Directory from.
    -m <dir>    Mail directory.
    -t <dir>    Directory to.
EOF
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

# 静默模式
while getopts ":hd:Dm:f:t:" opt; do
# 默认模式
# while getopts "d:Dm:f:t:" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        d)
            del_days="$OPTARG"
            ;;
        D)
            del_original='yes'
            ;;
        f)
            dir_from="$OPTARG"
            ;;
        m)
            maildir_name="$OPTARG"
            ;;
        t)
            dir_to="$OPTARG"
            ;;
        :)
            echo "[ERR] Option -${OPTARG} requires an argument!" >&2
            exit 1
            ;;
        ?)
            echo "[ERR] Invalid option -${OPTARG}!" >&2
            exit 1
            ;;
    esac
done

shift $(($OPTIND - 1))
echo "del_days=${del_days}"
echo "del_original=${del_original}"
echo "dir_from=${dir_from}"
echo "maildir_name=${maildir_name}"
echo "dir_to=${dir_to}"
echo "OPTIND=${OPTIND}"

echo "Other arguments: $@"
