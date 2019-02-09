#!/bin/bash

#
# clean-build-test-all.sh [--branch="master"] [--tmp=$(mktemp -d)] [--keep=false]
#

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
	*) break;
    esac
    shift
done


if [ "$tmp" = "" ]
then
    TMP_DIR=$(mktemp -d)
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

if ! git clone --single-branch --branch "$branch" https://github.com/icpc/kattis-docker
then
    echo "clone errors."
    exit 1
fi

cd kattis-docker

ok=true

if ! bin/setup --build
then
    echo "setup errors."
    exit 1
fi

. context

if ! tests/all
then
    echo "test errors."
    exit 1
fi
