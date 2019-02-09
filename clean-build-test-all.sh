#!/bin/bash

tmp=""
branch="master"
keep="false"

while [ $# -gt 0 ]
do
    case "$1"
    in
	--tmp=*)    tmp={1#--tmp=};;
	--branch=*) branch={1#--branch=};;
	--keep=*)   keep={1#--keep=};;	
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

if ! git clone git clone --single-branch --branch "$branch" https://github.com/icpc/kattis-docker
then
    echo "clone errors"
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
