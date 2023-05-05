source ~/bin/ceepee/git_init.sh
source ~/bin/ceepee/create_header_file.sh
source ~/bin/ceepee/terminalformat.sh
source ~/bin/ceepee/createLibraryCMake.sh
source ~/bin/ceepee/projectCMake.sh

initializeProject() {
    echo "- Creating directories"
    mkdir -p libs src tests out/build

    if [ "$3" == 'true' ]; then
        mkdir docs
    fi

    echo "- Adding .gitIgnore"
    createGitIgnore >.gitignore

    echo "- Creating project level cmake"
    if [! -f CMakeLists.txt ]; then
        createProjectLevelCMakeLists $1 >CMakeLists.txt
    fi
    echo "- Creating source file ${BOLD}${BLUE}$1.cpp${NORMAL}${NC}"

    if [! -f src/main.cpp ]; then
        createMainFile $1 >src/main.cpp
    fi

    echo "- Adding project scripts"
    echo "#! /bin/sh\ncmake -S . -B out/build;" >configure.sh
    echo "#! /bin/sh\ncd out/build; make;" >build.sh
    echo "#! /bin/sh\ncd out/build; ./$1" >run.sh
    echo "#! /bin/sh\ncd out/build; sudo make install;" >install.sh
    echo "#! /bin/sh\ngit submodule update --init --recursive ;" >submodule_init.sh
    echo "#! /bin/sh\ngit submodule update --recursive --remote;" >submodule_update.sh
    echo "#! /bin/sh\nrm -rf libs/*;" >clear_libs.sh

    chmod +x configure.sh build.sh run.sh install.sh submodule_init.sh submodule_update.sh chmod +x configure.sh build.sh install.sh test.sh build_and_test.sh submodule_init.sh submodule_update.sh clear_libs.sh

    echo ""
    echo ""
    echo "== Project ${BOLD}${BLUE}$1${NC}${NORMAL} setup completed =="

}

createMainFile() {
    echo "#include<iostream>
using namespace std;
int main(){
    cout << \"Hello world\" << endl;
    return 0;
};"
}
