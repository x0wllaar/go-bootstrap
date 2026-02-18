#!/bin/bash
set -euo pipefail

STEP_FORMAT=$(cat << EOF
trees/__VERSION__/bin/go: trees/__PREVIOUS__/bin/go
	rm -rf trees/__VERSION__
	cd gorepo && git worktree prune
	mkdir -p trees/__VERSION__
	cd gorepo && git worktree add ../trees/__VERSION__/ release-branch.__VERSION__
	cd trees/__VERSION__ && git pull
	cd trees/__VERSION__/src && /usr/bin/env PATH="\$(shell realpath ./trees/__PREVIOUS__)/bin:\$(PATH)" ./make.bash
__VERSION__: trees/__VERSION__/bin/go
EOF
)

function go_ver_to_int {
    if ! (echo $1 | grep -P '^go1\.' > /dev/null); then
       die Invalid version $1
    fi
    echo "$1" | cut -d '.' -f 2
}

function get_required_ver {
    int_ver="$(go_ver_to_int $1)"
    if test "$int_ver" -le 19; then
        echo "go1.4"
        return 0
    fi
    if test "$int_ver" -ge 20 && test "$int_ver" -le 21; then
        echo "go1.17"
        return 0
    fi
    if test "$int_ver" -ge 22 && test "$int_ver" -le 23; then
        echo "go1.20"
        return 0
    fi
    req_ver=$((int_ver - 2))
    if test $((req_ver % 2)) -eq 1; then
        req_ver=$((req_ver-1))
    fi
    echo "go1.$req_ver"
}

function generate_path {
    if test "$1" = "go1.4"; then
        return 0
    fi
    req_ver="$(get_required_ver "$1")"
    echo "$STEP_FORMAT" | sed "s/__VERSION__/$1/g" | sed "s/__PREVIOUS__/$req_ver/g"
    echo ""
    generate_path $req_ver
}

generate_path $1
