#!/bin/sh

set -e

die() {
    echo "$@" > /dev/stderr
    exit 1
}

for os in alpine:3.13 ubuntu:20.04 ; do
    prefix="`echo "$os" | sed -e 's/://'`"
    short_prefix="`echo "$os" | sed -e 's/:.*//'`"

    zeronet="zeronet-Dockerfile"

    dockerfile="Dockerfile.$prefix"
    dockerfile_short="Dockerfile.$short_prefix"

    echo "GEN  $dockerfile"

    if ! test -f "$zeronet" ; then
        die "No such file: $zeronet"
    fi

    echo "\
# THIS FILE IS AUTOGENERATED BY gen-dockerfiles.sh.
# SEE $zeronet FOR THE SOURCE FILE.

FROM $os

`cat "$zeronet"`
" > "$dockerfile.tmp" && mv "$dockerfile.tmp" "$dockerfile" && ln -s -f "$dockerfile" "$dockerfile_short"
done

