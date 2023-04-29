source ~/bin/ceepee/git_init.sh

initializeProject() {
    mkdir -p libs src test out/build
    createGitIgnore >.gitignore
    createProjectLevelCMakeLists $1
    createMainFile $1 > src/main.cpp
    echo "#! /bin/sh\ncmake -S . -B out/build;" >configure.sh
    echo "#! /bin/sh\ncd out/build; make;" >build.sh
    echo "#! /bin/sh\ncd out/build; ./$1" >run.sh
    echo "#! /bin/sh\ncd out/build; sudo make install;" >install.sh
    chmod +x configure.sh build.sh run.sh install.sh
}

createMainFile() {
    echo "#include<iostream>
using namespace std;
int main(){
    cout << \"Hello world\" << endl;
    return 0;
};"
}
createProjectLevelCMakeLists() {
    echo "
cmake_minimum_required(VERSION 3.0.0)

set(MAIN_PROJECT_NAME
    $1
)
set(MAIN_SOURCE_DIR
    src
)
set(MAIN_SOURCE
    \${MAIN_SOURCE_DIR}/main.cpp
)
set(MAIN_LIBRARIES_DIR
    libs
)
set(MAIN_LIBRARIES 
)

project(\${MAIN_PROJECT_NAME})


###########
# Project #
###########
add_executable(\${MAIN_PROJECT_NAME} \${MAIN_SOURCE})

foreach(LIBRARY \${MAIN_LIBRARIES})
    add_subdirectory("\${MAIN_LIBRARIES_DIR}/\${LIBRARY}")
endforeach(LIBRARY)
target_link_libraries(\${MAIN_PROJECT_NAME} \${MAIN_LIBRARIES})


# set_target_properties(\${LIBRARY_NAME} PROPERTIES PUBLIC_HEADER \${LIBRARY_HEADERS})
# install(TARGETS \${LIBRARY_NAME} DESTINATION lib/\${LIBRARY_NAME})" >CMakeLists.txt
}