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
target_link_libraries(\${MAIN_PROJECT_NAME} \${MAIN_LIBRARIES})"
echo "

# Installation
install(TARGETS \${PROJECT_NAME} DESTINATION bin/\${PROJECT_NAME})"
}