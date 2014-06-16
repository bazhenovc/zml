
cmake_minimum_required(VERSION 2.6)
project(zml)

if(UNIX)
	set(CMAKE_C_FLAGS                "-Wall -std=c99")
	set(CMAKE_C_FLAGS_DEBUG          "-g -ggdb")
	set(CMAKE_C_FLAGS_MINSIZEREL     "-Os -DNDEBUG")
	set(CMAKE_C_FLAGS_RELEASE        "-O4 -DNDEBUG")
	set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g")

	set(CMAKE_CXX_FLAGS                "-Wall -std=gnu++0x")
	set(CMAKE_CXX_FLAGS_DEBUG          "-g -ggdb")
	set(CMAKE_CXX_FLAGS_MINSIZEREL     "-Os -DNDEBUG")
	set(CMAKE_CXX_FLAGS_RELEASE        "-O4 -DNDEBUG")
	set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g")
endif()


include_directories(include)
add_library(zml STATIC
	source/zml_lexer.cc
	source/zml_lexer.hh
	source/zml_parser.cc
	source/zml_parser.hh
)

add_executable(zml_print tools/zml_print.cc)
target_link_libraries(zml_print zml)
