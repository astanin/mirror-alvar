# include opencv library
include_directories(${OpenCV_INCLUDE_DIRS})

# include opengl and glut library if found
if(GLUT_FOUND)
    include_directories(${OPENGL_INCLUDE_DIR})
    include_directories(${GLUT_INCLUDE_DIR})
endif(GLUT_FOUND)

# include tinyxml library
include_directories(${TinyXML_INCLUDE_DIRS})
add_definitions(-DTIXML_USE_STL)

# include alvar library
include_directories(${ALVAR_INCLUDE_DIRS})

# define test source directory
add_definitions(-DALVAR_TEST_DIR="${CMAKE_CURRENT_SOURCE_DIR}")

# add tests
if(CxxTest_FOUND AND PERL_FOUND)
    # basic tests
    add_cxxtest(TestFileFormats TestFileFormats.cpp)
    target_link_libraries(TestFileFormats ${ALVAR_LIBRARIES} TinyXML)

    # TODO: port TestMarkerDetector to linux
    if(WIN32)
        if(GLUT_FOUND)
            add_cxxtest(TestMarkerDetector TestMarkerDetector.cpp)
            target_link_libraries(TestMarkerDetector ${ALVAR_LIBRARIES} ${OPENGL_LIBRARIES} ${GLUT_glut_LIBRARY})
        endif(GLUT_FOUND)
    endif(WIN32)

    # pro tests
    add_cxxtest(TestRansac TestRansac.cpp)
    target_link_libraries(TestRansac ${ALVAR_LIBRARIES})

    add_cxxtest(TestTrifocalTensor TestTrifocalTensor.cpp)
    target_link_libraries(TestTrifocalTensor ${ALVAR_LIBRARIES})

    add_cxxtest(TestUnscentedKalman TestUnscentedKalman.cpp)
    target_link_libraries(TestUnscentedKalman ${ALVAR_LIBRARIES})

    add_cxxtest(TestContainer3d TestContainer3d.cpp)
    target_link_libraries(TestContainer3d ${ALVAR_LIBRARIES})

    add_cxxtest(TestTrack TestTrack.cpp)
    target_link_libraries(TestTrack ${ALVAR_LIBRARIES})
endif(CxxTest_FOUND AND PERL_FOUND)

# add benchmark executables
add_executable(BenchmarkOverall BenchmarkOverall.cpp)
target_link_libraries(BenchmarkOverall ${ALVAR_LIBRARIES})
