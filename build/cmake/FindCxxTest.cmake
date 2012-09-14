# Find CxxTest Framework
#
# Input variables:
# - CxxTest_ROOT_DIR:     (optional) Force a certain version of the CxxTest framework.
#                         When not specified, a best guess will be made.
#
# Output variables:
# - CxxTest_FOUND:        True if CxxTest framework was found properly and is ready to be used.
# - CxxTest_INCLUDE_DIRS: Include directories for CxxTest framework.

# define macro to add tests
macro(add_cxxtest _name)
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_name}Runner.cpp
        COMMAND ${PERL_EXECUTABLE} ${CxxTest_PERL_EXECUTABLE}
            --error-printer -o ${CMAKE_CURRENT_BINARY_DIR}/${_name}Runner.cpp ${ARGN}
        DEPENDS ${ARGN}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    include_directories(${CxxTest_INCLUDE_DIRS})
    include_directories(${CMAKE_CURRENT_SOURCE_DIR})
    add_executable(${_name} ${CMAKE_CURRENT_BINARY_DIR}/${_name}Runner.cpp ${ARGN})
    string(TOLOWER ${_name} _filename)
    set_target_properties(${_name} PROPERTIES OUTPUT_NAME ${_filename})
    set_target_properties(${_name} PROPERTIES DEBUG_POSTFIX d)
    if(${CMAKE_BUILD_TYPE} MATCHES "[Dd]ebug")
        set(_filename ${_filename}d)
    endif(${CMAKE_BUILD_TYPE} MATCHES "[Dd]ebug")
    add_test(${_name} ${CMAKE_CURRENT_BINARY_DIR}/${_filename})
endmacro(add_cxxtest)

# create possible root directory list
set(CxxTest_POSSIBLE_ROOT_DIRS
    ${CxxTest_POSSIBLE_ROOT_DIRS}
    $ENV{CXXTEST}
    $ENV{CXXTEST_ROOT}
    "$ENV{ProgramFiles}/cxxtest"
)

# find root directory if necessary
if(NOT CxxTest_ROOT_DIR)
    find_path(CxxTest_ROOT_DIR
        NAMES cxxtest/TestSuite.h
        PATHS ${CxxTest_POSSIBLE_ROOT_DIRS}
    )
endif(NOT CxxTest_ROOT_DIR)

# set include directory
set(CxxTest_INCLUDE_DIRS ${CxxTest_ROOT_DIR})

# find generation programs
find_program(CxxTest_PERL_EXECUTABLE
    NAMES cxxtestgen.pl
    PATHS ${CxxTest_ROOT_DIR}
)
find_program(CxxTest_PYTHON_EXECUTABLE
    NAMES cxxtestgen.py
    PATHS ${CxxTest_ROOT_DIR}
)
mark_as_advanced(CxxTest_PERL_EXECUTABLE)
mark_as_advanced(CxxTest_PYTHON_EXECUTABLE)

# handle required and quiet parameters
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CxxTest DEFAULT_MSG
    CxxTest_ROOT_DIR
    CxxTest_INCLUDE_DIRS
    CxxTest_PERL_EXECUTABLE
    CxxTest_PYTHON_EXECUTABLE
)
set(CxxTest_FOUND ${CXXTEST_FOUND})
