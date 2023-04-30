if [ $# == 0 ]; then
    echo "Please supply some paramaters"
fi

source ~/bin/ceepee/proj_init.sh
source ~/bin/ceepee/lib_init.sh

if [ "$1" == "init" ]; then
    if [ "$(ls -A $DIR)" ] && [ -e ./CMakeLists.txt ]; then
        echo "Directory seems to contain a previous CMake Project. Please empty to continue."
    else
        if [ $# -gt 1 ] && [ $2 == "lib" ]; then
            if [ $# -gt 2 ]; then
                echo "Initializing library  $(tput bold)$3"
                initializeLibrary $3
            else
                echo "Please input the name of the library"
            fi
        elif [ $# -gt 1 ] && [ $2 == "proj" ]; then
            if [ $# -gt 2 ]; then
                echo "Initializing project $(tput bold)$3"
                initializeProject $3

            else
                echo "Please input the name of the library"
            fi
        else
            echo "Please enter the project type"
        fi
    fi
fi

if [ "$1" == "add" ]; then
    if [ $# -gt 1 ] && [ $2 == "sublib" ]; then
        if [ $# -gt 2 ]; then
            echo "Initializing Sub-library $3"
            addLocalSublibrary $3
        else
            echo "Please input the name of the Sub-library"
        fi
    else
        echo "Command sequence not recognized"
    fi
fi
