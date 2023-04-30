createLibraryCmake() {
    echo "cmake_minimum_required(VERSION 3.13.4)
set (CMAKE_CXX_STANDARD 17)

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
# To link other libraries in \$PATH add libraries to target_link_libraries
target_link_libraries(\${MAIN_LIBRARY_NAME} \${MAIN_LIBRARIES})"
    if [ $2 == 'true' ]; then
        echo "set_target_properties(\${LIBRARY_NAME} PROPERTIES PUBLIC_HEADER \${LIBRARY_HEADERS})
install(TARGETS \${LIBRARY_NAME} DESTINATION lib/\${LIBRARY_NAME}
PUBLIC_HEADER DESTINATION include/\${LIBRARY_NAME} )"
    fi
}
