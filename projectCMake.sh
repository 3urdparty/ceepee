createProjectLevelCMakeLists() {
	echo "
###########
# Project #
###########

cmake_minimum_required(VERSION 3.26.0)

set (CMAKE_CXX_STANDARD 17)

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

project(\${MAIN_PROJECT_NAME})"

echo "


################
# Dependencies #
################

message(\"\")
message(\"Finding and downloading submodules for project \`\${PROJECT_NAME}\`\")
find_package(Git QUIET)
if(GIT_FOUND AND EXISTS \${PROJECT_SOURCE_DIR}/.git)
	# Update submodules as needed
	option(GIT_SUBMODULE \"Check submodules during build\" ON)
	if (GIT_SUBMODULE)
		message(STATUS \"Submodules updating\")
		execute_process(COMMAND \${GIT_EXECUTABLE} submodule update --recursive --remote
			WORKING_DIRECTORY \${CMAKE_CURRENT_SOURCE_DIR}
		    RESULT_VARIABLE GIT_SUBMOD_RESULT)
		if(NOT GIT_SUBMOD_RESULT EQUAL \"0\")
			message(FATAL_ERROR \"git submodule update --init failed with \${GIT_SUBMOD_RESULT}, please checkout submodules\")
		endif()
	endif()
endif()
  

foreach(LIBRARY \${MAIN_LIBRARIES})
if (NOT EXISTS \"\${PROJECT_SOURCE_DIR}/libs/\${LIBRARY}/CMakeLists.txt\")
	message(FATAL_ERROR \"The \${LIBRARY} submodule was not downloaded! GIT_SUBMODULE was turned off or failed. Please update submodules and try again.\")
else()
    message (STATUS \"Submodule \${LIBRARY} was downloaded and has been found.\")
endif()
endforeach(LIBRARY)
message(\"\")

"
	echo "
foreach(LIBRARY \${MAIN_LIBRARIES})
if (NOT EXISTS \"\${PROJECT_SOURCE_DIR}/libs/\${LIBRARY}/CMakeLists.txt\")
	message(FATAL_ERROR \"The \${LIBRARY} submodule was not downloaded! GIT_SUBMODULE was turned off or failed. Please update submodules and try again.\")
endif()
endforeach(LIBRARY)

"
	echo "
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
