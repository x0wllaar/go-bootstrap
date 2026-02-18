#!/bin/bash
set -euo pipefail

function die {
    echo Error: "$@" 1>&2
    exit 1
}

function go_branch_to_int {
    if ! (echo $1 | grep -P '\.go1\.' > /dev/null); then
       die Invalid version $1
    fi
    echo "$1" | cut -d '.' -f 3
}

function strip {
    echo "$1" | sed 's/^ +//' | sed 's/ +$//'
}

readarray -t all_branch_list <<< "$(git branch --all)"

declare -A go_versions
for b in "${all_branch_list[@]}"; do
    b="$(strip "$b")"
    if (echo "$b" | grep -P 'release-branch\.go' > /dev/null); then
        if ! (echo "$b" | grep -P 'go1$' > /dev/null); then
            ver=$(go_branch_to_int "$b")
            go_versions[$ver]=1
        fi
    fi
done

last_go_ver="$(printf "%s\n" "${!go_versions[@]}" | sort -n | tail -n1)"
echo "go1.$last_go_ver"
