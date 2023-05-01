createLibraryCmake() {
    echo "
###########
# Library #
###########

cmake_minimum_required(VERSION 3.26.0)
set (CMAKE_CXX_STANDARD 17)

# Setting library name
set(LIBRARY_NAME
    $1
)

# Setting main environment variables
set(MAIN_LIBRARIES_DIR
    libs
)

set(MAIN_LIBRARIES 

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



# Created project
project(\${LIBRARY_NAME})




add_library(\${LIBRARY_NAME} STATIC
    \${LIBRARY_HEADERS}
    \${LIBRARY_SOURCE}
)
"
    if [ $4 == 'true' ]; then
        echo "
#########
# Tests #
#########

#Setting target name for tets
set(TESTS_NAME 
    $1_tests
)

#Setting directory for test files
set(TESTS_DIR 
    tests
)

#Add test files here
set(TESTS_SOURCES
    \${TESTS_DIR}/test.cpp
)



# Setting up GTest
include(FetchContent)

FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
)

FetchContent_MakeAvailable(googletest)

enable_testing()


# Adding test files to target
add_executable(
    \${TESTS_NAME}
    \${TESTS_SOURCES}
)

# Linking target with GTest
target_link_libraries(
    \${TESTS_NAME}
    GTest::gtest_main
    \${LIBRARY_NAME}
)

# Final steps
include(GoogleTest)
gtest_discover_tests(\${TESTS_NAME})



"
    fi
    echo "
################
# Dependencies #
################

# Addinng all libraries in libs/
foreach(LIBRARY \${MAIN_LIBRARIES})
    add_subdirectory(\${MAIN_LIBRARIES_DIR}/\${LIBRARY})
endforeach(LIBRARY)

# Linking libraries/dependencies
target_link_libraries(\${LIBRARY_NAME} \${MAIN_LIBRARIES})


# adding include/ directories
target_include_directories(\${LIBRARY_NAME} PRIVATE
    $<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include/\${LIBRARY_NAME}>
    $<INSTALL_INTERFACE:include/\${LIBRARY_NAME}>
)

# adding more include/ directories
target_include_directories(\${LIBRARY_NAME} PUBLIC
    $<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

# Sets public header files for target
set_target_properties(\${LIBRARY_NAME} PROPERTIES PUBLIC_HEADER \${LIBRARY_HEADERS})

"
    if [ $2 == 'true' ]; then
        echo "# Installation properties
install(TARGETS \${LIBRARY_NAME} DESTINATION lib/\${LIBRARY_NAME}
PUBLIC_HEADER DESTINATION include/\${LIBRARY_NAME} )
"
    fi
}
