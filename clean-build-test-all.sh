#!/bin/bash

#
# clean-build-test-all.sh [--branch="master"] [--tmp=$(mktemp -d)] [--keep=false] [--help]
#

pushd $(dirname "${BASH_SOURCE[0]}") >/dev/null
proj_dir="$PWD"
popd >/dev/null

tmp=""
branch="master"
keep="false"

while [ $# -gt 0 ]
do
    arg="$1"
    case "$arg"
    in
	--tmp=*)    tmp=${arg#--tmp=};;
	--branch=*) branch=${arg#--branch=};;
	--keep=*)   keep=${arg#--keep=};;
	*)
	    echo "usage $0 [--branch=master] [--tmp=$(mktemp -d)] [--keep=false] [--help]"
	    exit 1
    esac
    shift
done


if [ "$tmp" = "" ]
then
    TAG=$(dd bs=1024 count=1 if=/dev/urandom of=/dev/stdout 2>/dev/null | openssl sha256 | tail -1 | sed -e 's/(stdin)= //')
    TMP_DIR="./tmp.$TAG"
    mkdir -p "$TMP_DIR"
else
    TMP_DIR="$tmp"
    mkdir -p "$TMP_DIR"
fi

function cleanup {
    /bin/rm -rf "$TMP_DIR"
}

if [ "$keep" != "true" ]
then
    trap cleanup EXIT
fi

cd  "$TMP_DIR"

echo git clone --single-branch --branch "$branch" https://github.com/icpc/kattis-docker . 2>&1 | tee -a clean-build-test-all.log

if ! git clone --single-branch --branch "$branch" https://github.com/icpc/kattis-docker . 2>&1 | tee -a clean-build-test-all.log
then
    echo "clone errors."
    exit 1
fi

echo bin/setup --build 2>&1 | tee -a clean-build-test-all.log

if ! bin/setup --build 2>&1 | tee -a clean-build-test-all.log
then
    echo "setup errors." 2>&1 | tee -a clean-build-test-all.log
    exit 1
fi

echo . context >>clean-build-test-all.log 2>&1 2>&1 | tee -a clean-build-test-all.log

. context

if ! tests/all >>clean-build-test-all.log 2>&1 | tee -a clean-build-test-all.log
then
    echo "test errors." 2>&1 | tee -a clean-build-test-all.log
    exit 1
fi

echo "clean-build-test-all.sh complete." 2>&1 | tee -a clean-build-test-all.log
