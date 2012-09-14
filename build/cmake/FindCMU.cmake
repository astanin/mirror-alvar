# Find CMU Library
#
# Input variables:
# - CMU_ROOT_DIR:          (optional) Force a certain version of the CMU library.
#                          When not specified, a best guess will be made.
#
# Output variables:
# - CMU_FOUND:             True if CMU library was found properly and is ready to be used.
# - CMU_INCLUDE_DIRS:      Include directories for CMU library.
# - CMU_LIBRARIES_RELEASE: Release version of CMU libraries.
# - CMU_LIBRARIES_DEBUG:   Debug version of CMU libraries.
# - CMU_LIBRARIES:         Release and debug version of CMU libraries.

# create possible root directory list
set(CMU_POSSIBLE_ROOT_DIRS
    ${CMU_POSSIBLE_ROOT_DIRS}
    $ENV{CMU}
    $ENV{CMU_ROOT}
    "$ENV{ProgramFiles}/CMU/1394Camera"
)

# find root directory if necessary
if(NOT CMU_ROOT_DIR)
    find_path(CMU_ROOT_DIR
        NAMES include/1394Camera.h
        PATHS ${CMU_POSSIBLE_ROOT_DIRS}
    )
endif(NOT CMU_ROOT_DIR)

# set include directory
set(CMU_INCLUDE_DIRS
    ${CMU_ROOT_DIR}/include
    ${OpenCV_ROOT_DIR}/include/opencv
)

# find release and debug library
find_library(CMU_LIBRARIES_RELEASE
    NAMES 1394camera.lib
    PATHS ${CMU_ROOT_DIR}
    PATH_SUFFIXES lib
)
find_library(CMU_LIBRARIES_DEBUG
    NAMES 1394camerad.lib
    PATHS ${CMU_ROOT_DIR}
    PATH_SUFFIXES lib
)

# create cmake compatible library list
set(CMU_LIBRARIES)
foreach(_library ${CMU_LIBRARIES_RELEASE})
    list(APPEND CMU_LIBRARIES optimized ${_library})
endforeach(_library ${CMU_LIBRARIES_RELEASE})
foreach(_library ${CMU_LIBRARIES_DEBUG})
    list(APPEND CMU_LIBRARIES debug ${_library})
endforeach(_library ${CMU_LIBRARIES_DEBUG})

# handle required and quiet parameters
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CMU DEFAULT_MSG
    CMU_ROOT_DIR
    CMU_INCLUDE_DIRS
    CMU_LIBRARIES_RELEASE
    CMU_LIBRARIES_DEBUG
    CMU_LIBRARIES
)
