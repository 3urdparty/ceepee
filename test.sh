#!/bin/bash

extractLibrariesFromCMakeLists() {
    re='set\(MAIN_LIBRARIES([^'$'\n'']*[a-z]*)'
    if [[ "$1" =~ $re ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "set(MAIN_LIBRARIES
        not found
)"
    fi
}

extractLibrariesFromCMakeLists 'set(MAIN_LIBRARIES main
main
main
)'
