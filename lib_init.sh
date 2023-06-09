source ~/bin/ceepee/git_init.sh
source ~/bin/ceepee/create_header_file.sh
source ~/bin/ceepee/terminalformat.sh
source ~/bin/ceepee/createLibraryCMake.sh
source ~/bin/ceepee/createBasicTest.sh

initializeLibrary() {
    echo "- Creating directories"
    mkdir -p include/$1 libs src out/build

    if [ "$3" == 'true' ]; then
        mkdir docs
    fi
    if [ "$4" == 'true' ]; then
        mkdir -p tests
        if [ ! -f tests/test.cpp ]; then
            createBasicTest >tests/test.cpp
        fi
    fi

    echo "- Adding .gitIgnore"
    createGitIgnore >.gitignore

    echo "- Creating header file ${BOLD}${BLUE}$1.hpp${NORMAL}${NC}"
    if [ ! -f include/$1/$1.hpp ]; then
        createHeaderFile $1 >include/$1/$1.hpp
    fi

    echo "- Creating source file ${BOLD}${BLUE}$1.cpp${NORMAL}${NC}"
    if [ ! -f src/$1.cpp ]; then
        echo "#include \"$1.hpp\"" >src/$1.cpp
    fi

    echo "- Creating CMakeLists.txt"
    if [ ! -f CMakeLists.txt ]; then

        createLibraryCmake $1 $2 $3 $4 >CMakeLists.txt
    fi

    echo "- Adding project scripts"
    echo "#! /bin/sh\ncmake -S . -B out/build \$@" >configure.sh
    echo "#! /bin/sh\ncd out/build; make; \$@" >build.sh
    echo "#! /bin/sh\ncd out/build; sudo make install \$@" >install.sh
    echo "#! /bin/sh\ncd out/build; ctest \$@" >test.sh
    echo "#! /bin/sh\ngit submodule update --init --recursive --remote;" >submodule_init.sh
    echo "#! /bin/sh\ngit submodule update --recursive --remote;" >submodule_update.sh
    echo "#! /bin/sh\nrm -rf libs/*;" >clear_libs.sh
    echo "#! /bin/sh
cmake -S . -B out/build;
cd out/build; make; 
echo \"

Build Sucessfully!
Running tests:
\"
ctest;" >build_and_test.sh

    chmod +x configure.sh build.sh install.sh test.sh build_and_test.sh submodule_init.sh submodule_update.sh clear_libs.sh

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
