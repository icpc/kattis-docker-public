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
ssh=true
https=false

while [ $# -gt 0 ]
do
    arg="$1"
    case "$arg"
    in
	--tmp=*)    tmp=${arg#--tmp=};;
	--branch=*) branch=${arg#--branch=};;
	--keep=*)   keep=${arg#--keep=};;
	--ssh)      ssh=true; https=false;;
	--https)    ssh=false; https=true;;	
	*)
	    echo "usage $0 [--branch=master] [--tmp=$(mktemp -d)] [--keep=false] [--help]"
	    exit 1
    esac
    shift
done


if [ "$tmp" = "" ]
then
    TAG=$(dd bs=1024 count=1 if=/dev/urandom of=/dev/stdout 2>/dev/null | openssl sha256 | tail -1 | sed -e 's/(stdin)= //')
    TMP_DIR="$proj_dir/tmp.$TAG"
    mkdir -p "$TMP_DIR"
else
    TMP_DIR="$tmp"
    mkdir -p "$TMP_DIR"
fi

function cleanup {
    if [ -f "$TMP_DIR/clean-build-test-all.log" -a -d "$TMP_DIR/kattis-docker/.git" ]
    then
	echo "saving log to test branch."
	cd "$TMP_DIR/kattis-docker"
	if ! git branch -a | egrep '^ *(remotes/origin/)?test$'
	then
	    git branch test
	fi
	git checkout test
	cp ../clean-build-test-all.log .
	git add -f clean-build-test-all.log
	git commit -m "test"
	git push --set-upstream origin test
    fi
    
    if [ "$keep" != "true" ]
    then
	/bin/rm -rf "$TMP_DIR"
    else
	echo "keeping $TMP_DIR"
    fi
}

trap cleanup EXIT

cd "$TMP_DIR"

uname -a | tee -a clean-build-test-all.log
echo "TMP_DIR=$TMP_DIR" 2>&1 | tee -a clean-build-test-all.log

if [ "$ssh" = "true" ]
then
    git_address=git@github.com:icpc/kattis-docker.git
else
    git_address=https://github.com/icpc/kattis-docker
fi

echo ./clean-build-test-all.sh --branch="$branch" --keep="$keep" --tmp="$tmp"  2>&1 | tee -a clean-build-test-all.log

echo git clone --single-branch --branch "$branch" $git_address 2>&1 | tee -a clean-build-test-all.log

if ! git clone --single-branch --branch "$branch" $git_address 2>&1 | tee -a clean-build-test-all.log
then
    echo "clone errors."
fi

echo kattis-docker/bin/setup --build 2>&1 | tee -a clean-build-test-all.log

if ! kattis-docker/bin/setup --build 2>&1 | tee -a clean-build-test-all.log
then
    echo "setup errors." 2>&1 | tee -a clean-build-test-all.log
    exit 1
fi

echo . kattis-docker/context 2>&1 | tee -a clean-build-test-all.log

. kattis-docker/context

echo kattis-docker/tests/all 2>&1 | tee -a clean-build-test-all.log

if ! kattis-docker/tests/all 2>&1 | tee -a clean-build-test-all.log
then
    echo "test errors." 2>&1 | tee -a clean-build-test-all.log
    exit 1
fi

echo "clean-build-test-all.sh complete." 2>&1 | tee -a clean-build-test-all.log
