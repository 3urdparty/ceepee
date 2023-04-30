source ~/bin/ceepee/git_init.sh
source ~/bin/ceepee/create_header_file.sh
source ~/bin/ceepee/terminalformat.sh
source ~/bin/ceepee/createLibraryCMake.sh

initializeLibrary() {
    echo "- Creating directories"
    mkdir -p include/$1 libs src test out/build

    if [ "$3" == 'true' ]; then
        mkdir docs
    fi
    # mkdir -p docs

    echo "- Adding .gitIgnore"
    createGitIgnore >.gitignore

    echo "- Creating header file ${BOLD}${BLUE}$1.hpp${NORMAL}${NC}"
    createHeaderFile $1 >include/$1/$1.hpp

    echo "- Creating source file ${BOLD}${BLUE}$1.cpp${NORMAL}${NC}"
    touch src/$1.cpp

    echo "- Creating CMakeLists.txt"
    createLibraryCmake $1 $2 >CMakeLists.txt

    echo "- Adding project scripts"
    echo "#! /bin/sh\ncmake -S . -B out/build;" >configure.sh
    echo "#! /bin/sh\ncd out/build; make;" >build.sh
    echo "#! /bin/sh\ncd out/build; sudo make install;" >install.sh
    chmod +x configure.sh build.sh install.sh

    echo ""
    echo ""
    echo "== Library ${BOLD}${BLUE}$1${NC}${NORMAL} setup completed =="
}

# initializeLocalLibrary() {
#     mkdir -p include/$1 libs src test out/build
#     createGitIgnore >.gitignore
#     createBasicMainFile >src/main.cpp
#     createMainCmake $1
#     echo "#! /bin/sh\ncmake -S . -B out/build;" >configure.sh
#     echo "#! /bin/sh\ncd out/build; make;" >build.sh
#     echo "#! /bin/sh\ncd out/build; ./$1" >run.sh
#     echo "#! /bin/sh\ncd out/build; sudo make install;" >install.sh
#     chmod +x configure.sh build.sh run.sh install.sh
# }
