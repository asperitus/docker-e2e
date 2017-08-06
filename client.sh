#!/usr/bin/env bash

set -x
#args:
# URL
# FILE

#
usage() {
   cat << EOF

usage: $(basename $0) URL FILE

EOF

exit 1
}

[[ $# -lt 2 ]] && usage

url=$1
file=$2
shift
shift
args=$@

##
curl -v -F "args=${args[@]}" -F "file=@$file" $url  2>&1 | tee status.txt; if [ $? -ne 0 ]; then
    exit 1
fi

status=$(tail -n 1 status.txt)

echo "test $file completed on $url status: $status"

exit $status