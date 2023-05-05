#!/bin/bash
extractLibrariesFromCMakeLists() {
    re='set\(MAIN_LIBRARIES(.|\n)*\)'
    if [[ "$1" =~ $re ]]; then
        matched=${BASH_REMATCH[0]}
        echo "$matched" | tail -n +2 | sed \$d
    fi
}
