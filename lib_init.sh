source ~/bin/ceepee/git_init.sh

createGlobalLibraryCMake() {
    echo "cmake_minimum_required(VERSION 3.0.0)

set(PROJECT_NAME
    $1
)
set(LIBRARY_NAME
    $1
)
set(LIBRARY_HEADERS_DIR
    include/\${LIBRARY_NAME}
)
set(LIBRARY_HEADERS
    \${LIBRARY_HEADERS_DIR}/$1.hpp
)
set(LIBRARY_SOURCE_DIR
    src
)
set(LIBRARY_SOURCE
    \${LIBRARY_SOURCE_DIR}/$1.cpp
)

project(\${PROJECT_NAME})

add_library(\${LIBRARY_NAME} STATIC
    \${LIBRARY_HEADERS}
    \${LIBRARY_SOURCE}
)

target_include_directories(\${LIBRARY_NAME} PRIVATE
    $<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include/\${LIBRARY_NAME}>
    $<INSTALL_INTERFACE:include/\${LIBRARY_NAME}>
)

target_include_directories(\${LIBRARY_NAME} PUBLIC
    $<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)



# target_link_libraries(\${MAIN_LIBRARY_NAME} \${MAIN_LIBRARIES})
set_target_properties(\${LIBRARY_NAME} PROPERTIES PUBLIC_HEADER \${LIBRARY_HEADERS})
install(TARGETS \${LIBRARY_NAME} DESTINATION lib/\${LIBRARY_NAME}
PUBLIC_HEADER DESTINATION include/\${LIBRARY_NAME} )
"
}

addLocalSublibrary() {
    if [ -e libs/ ] && [ -e ./CMakeLists.txt ]; then
        if [ -e libs/$1 ]; then
            echo "Library $1 already exists. Please delete it and remove its entry from the main CMakeLists.txt file"
        else

            mkdir -p libs/$1/include/$1 libs/$1/src
            touch libs/$1/include/$1/$1.hpp
            echo "#include\"$1.hpp\"" >libs/$1/src/$1.cpp
            echo "cmake_minimum_required(VERSION 3.0.0)

set(PROJECT_NAME
    $1Library
)
set(LIBRARY_NAME
    $1
)
set(LIBRARY_HEADERS_DIR
    include/\${LIBRARY_NAME}
)
set(LIBRARY_HEADERS
    \${LIBRARY_HEADERS_DIR}/$1.hpp
)
set(LIBRARY_SOURCE_DIR
    src
)
set(LIBRARY_SOURCE
    \${LIBRARY_SOURCE_DIR}/$1.cpp
)

project(\${PROJECT_NAME})

add_library(\${LIBRARY_NAME} STATIC
   \${LIBRARY_HEADERS}
    \${LIBRARY_SOURCE}
)

target_include_directories(\${LIBRARY_NAME} PRIVATE
    $<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include/\${LIBRARY_NAME}>
    $<INSTALL_INTERFACE:include/\${LIBRARY_NAME}>
)

target_include_directories(\${LIBRARY_NAME} PUBLIC
    $<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)" >libs/$1/CMakeLists.txt

            if grep -Fxq "$1" CMakeLists.txt; then
                echo "$1 lib already is registered in the CMakeLists.txt"
            else
                sed "s/set(MAIN_LIBRARIES /set(MAIN_LIBRARIES \n$1/g" CMakeLists.txt >newcmake.txt
                rm CMakeLists.txt
                mv newcmake.txt CMakeLists.txt

            fi
        fi
    else
        echo "Currently not in a CMake lib project"
    fi
}

initializeLibrary() {
    mkdir -p include/$1 libs src test out/build
    createGitIgnore >.gitignore
    createHeaderFile $1 >include/$1/$1.hpp
    touch src/$1.cpp
    createGlobalLibraryCMake $1 >CMakeLists.txt
    echo "#! /bin/sh\ncmake -S . -B out/build;" >configure.sh
    echo "#! /bin/sh\ncd out/build; make;" >build.sh
    echo "#! /bin/sh\ncd out/build; sudo make install;" >install.sh
    chmod +x configure.sh build.sh install.sh
}

createHeaderFile() {
    local upper=$(tr '[a-z]' '[A-Z]' <<<$1)
    echo "#ifndef ${upper}_H
#define ${upper}_H

#endif"
}
initializeLocalLibrary() {
    mkdir -p include/$1 libs src test out/build
    createGitIgnore >.gitignore
    createBasicMainFile >src/main.cpp
    createMainCmake $1
    echo "#! /bin/sh\ncmake -S . -B out/build;" >configure.sh
    echo "#! /bin/sh\ncd out/build; make;" >build.sh
    echo "#! /bin/sh\ncd out/build; ./$1" >run.sh
    echo "#! /bin/sh\ncd out/build; sudo make install;" >install.sh
    chmod +x configure.sh build.sh run.sh install.sh
}
