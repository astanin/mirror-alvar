# include opencv library
include_directories(${OpenCV_INCLUDE_DIRS})

# include tinyxml library
include_directories(${TinyXML_INCLUDE_DIRS})
add_definitions(-DTIXML_USE_STL)

# ensure alvar api is exported when building library
add_definitions(-DALVAR_BUILD)

# initialize include directories and libraries variables for alvar
set(ALVAR_INCLUDE_DIRS)
set(ALVAR_LIBRARIES)

# include alvar library
include_directories(${ALVAR_INCLUDE_DIRS})

# define alvar info
if(WIN32)
    execute_process(COMMAND "cmd" " /C date /T" OUTPUT_VARIABLE ALVAR_DATE)
    string(REGEX REPLACE ".*([0-9][0-9])[/\\.]([0-9][0-9])[/\\.]([0-9][0-9][0-9][0-9]).*" "\\3-\\2-\\1" ALVAR_DATE ${ALVAR_DATE})
elseif(UNIX)
    execute_process(COMMAND "date" "+%d/%m/%Y" OUTPUT_VARIABLE ALVAR_DATE)
    string(REGEX REPLACE "(..)/(..)/(....).*" "\\3-\\2-\\1" ALVAR_DATE ${ALVAR_DATE})
else(WIN32)
    message(SEND_ERROR "Date not defined")
    SET(ALVAR_DATE "?")
endif(WIN32)
set(ALVAR_SYSTEM "${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION} ${CMAKE_SYSTEM_PROCESSOR}")

# configure alvar header file
set(ALVAR_GLOBAL_HEADER ${CMAKE_CURRENT_BINARY_DIR}/Alvar.h)
configure_file(Alvar.h.cmake ${ALVAR_GLOBAL_HEADER})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

# define alvar library source files to compile
set(ALVAR_HEADERS
    AlvarException.h
    Bitset.h
    Camera.h
    ConnectedComponents.h
    Container3d.h
    Draw.h
    EC.h
    FernImageDetector.h
    FernPoseEstimator.h
    FileFormat.h
    FileFormatUtils.h
    Filter.h
    IntegralImage.h
    Kalman.h
    Line.h
    Marker.h
    MarkerDetector.h
    MultiMarker.h
    MultiMarkerBundle.h
    MultiMarkerFiltered.h
    MultiMarkerInitializer.h
    Optimization.h
    Pose.h
    Ransac.h
    Rotation.h
    SfM.h
    Tracker.h
    TrackerFeatures.h
    TrackerOrientation.h
    TrackerPsa.h
    TrackerStat.h
    TrifocalTensor.h
    UnscentedKalman.h
    Util.h
)
set(ALVAR_SOURCES
    Alvar.cpp
    Bitset.cpp
    Camera.cpp
    ConnectedComponents.cpp
    Draw.cpp
    EC.cpp
    FernImageDetector.cpp
    FernPoseEstimator.cpp
    FileFormatUtils.cpp
    Filter.cpp
    IntegralImage.cpp
    Kalman.cpp
    Line.cpp
    Marker.cpp
    MarkerDetector.cpp
    MultiMarker.cpp
    MultiMarkerBundle.cpp
    MultiMarkerFiltered.cpp
    MultiMarkerInitializer.cpp
    Optimization.cpp
    Pose.cpp
    Ransac.cpp
    Rotation.cpp
    SfM.cpp
    TrackerFeatures.cpp
    TrackerOrientation.cpp
    TrackerPsa.cpp
    TrackerStat.cpp
    TrifocalTensor.cpp
    UnscentedKalman.cpp
    Util.cpp
)

# add source files to alvar library and set name and properties
add_library(ALVAR
    ${ALVAR_GLOBAL_HEADER}
    ${ALVAR_HEADERS}
    ${ALVAR_SOURCES}
)
set_target_properties(ALVAR PROPERTIES OUTPUT_NAME alvar${ALVAR_VERSION_NODOTS})
set_target_properties(ALVAR PROPERTIES DEBUG_POSTFIX d)

# link alvar library target to required libraries
target_link_libraries(ALVAR
    ${OpenCV_LIBRARIES}
    TinyXML
)

# install headers
if(ALVAR_PACKAGE MATCHES sdk)
    install(FILES ${ALVAR_HEADERS} ${ALVAR_GLOBAL_HEADER} DESTINATION include)
endif(ALVAR_PACKAGE MATCHES sdk)

# install target
install(TARGETS ALVAR DESTINATION bin)

# set include directories and libraries variables for alvar
list(APPEND ALVAR_INCLUDE_DIRS
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
)
list(APPEND ALVAR_LIBRARIES
    ALVAR
)
set(_prefix "general")
foreach(_item ${ALVAR_LIB_DEPENDS})
    if(_item MATCHES "^general$|^optimized$|^debug$")
        set(_prefix ${_item})
    else(_item MATCHES "^general$|^optimized$|^debug$")
        set(_found FALSE)
        list(FIND ALVAR_LIBRARIES ${_item} _found)
        if(_found EQUAL -1)
            list(APPEND ALVAR_LIBRARIES ${_prefix} ${_item})
        endif(_found EQUAL -1)
        set(_prefix "general")
    endif(_item MATCHES "^general$|^optimized$|^debug$")
endforeach(_item ${ALVAR_LIB_DEPENDS})

# hack to setup environment runtime path
if(NOT ${MSVC_IDE})
    list(APPEND ALVAR_RUNTIME
        ${CMAKE_CURRENT_BINARY_DIR}\;
    )
else(NOT ${MSVC_IDE})
    list(APPEND ALVAR_RUNTIME
        ${CMAKE_CURRENT_BINARY_DIR}/Debug\;
        ${CMAKE_CURRENT_BINARY_DIR}/Release\;
    )
endif(NOT ${MSVC_IDE})

# process sub directories
add_subdirectory(platform)

# add include directories and libraries variables to the cache
list(REMOVE_DUPLICATES ALVAR_INCLUDE_DIRS)
mark_as_advanced(ALVAR_INCLUDE_DIRS)
mark_as_advanced(ALVAR_LIBRARIES)
set(ALVAR_INCLUDE_DIRS ${ALVAR_INCLUDE_DIRS} CACHE STRING "ALVAR include directories")
set(ALVAR_LIBRARIES ${ALVAR_LIBRARIES} CACHE STRING "ALVAR libraries")

# hack to setup environment runtime path
set(ALVAR_RUNTIME ${ALVAR_RUNTIME} PARENT_SCOPE)
