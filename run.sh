#!/usr/bin/env bash

set -x

[[ $# -lt 2 ]] && exit 1

pwd

#
dir=$1
file=$2
shift
shift
args=$@

##
cd $dir; if [ $? -ne 0 ]; then
    exit 1
fi

test_dir=${file}_test

unzip -q $file -d $test_dir; if [ $? -ne 0 ]; then
    exit 1
fi

#run test.sh
pushd .

cd $test_dir
npm install --quiet
bash test.sh $args; status=$?

popd

rm -rf  $file $test_dir

echo "Test completed status: $status"

exit $status