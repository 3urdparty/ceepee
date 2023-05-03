source ~/bin/ceepee/git_init.sh
source ~/bin/ceepee/create_header_file.sh
source ~/bin/ceepee/terminalformat.sh
source ~/bin/ceepee/createLibraryCMake.sh
source ~/bin/ceepee/projectCMake.sh

initializeProject() {
    echo "- Creating directories"
    mkdir -p libs src test out/build

    if [ "$3" == 'true' ]; then
        mkdir docs
    fi

    echo "- Adding .gitIgnore"
    createGitIgnore >.gitignore

    echo "- Creating project level cmake"
    createProjectLevelCMakeLists $1 >CMakeLists.txt

    echo "- Creating source file ${BOLD}${BLUE}$1.cpp${NORMAL}${NC}"
    createMainFile $1 >src/main.cpp

    echo "- Adding project scripts"
    echo "#! /bin/sh\ncmake -S . -B out/build;" >configure.sh
    echo "#! /bin/sh\ncd out/build; make;" >build.sh
    echo "#! /bin/sh\ncd out/build; ./$1" >run.sh
    echo "#! /bin/sh\ncd out/build; sudo make install;" >install.sh
    echo "#! /bin/sh\ngit submodule update --init --recursive ;" >submodule_init.sh
    echo "#! /bin/sh\ngit submodule update --recursive --remote;" >submodule_update.sh

    chmod +x configure.sh build.sh run.sh install.sh submodule_init.sh submodule_update.sh

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
