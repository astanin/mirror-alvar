# generate doxygen api documentation
find_package(Doxygen)
if(DOXYGEN_FOUND)
    # configure doxygen configuration file with paths
    set(ALVAR_DOXYGEN_LOGO ${CMAKE_SOURCE_DIR}/doc/logo.png)
    set(ALVAR_DOXYGEN_INPUT ${CMAKE_INSTALL_PREFIX}/include)
    set(ALVAR_DOXYGEN_EXCLUDE)
    set(ALVAR_DOXYGEN_SAMPLE ${CMAKE_SOURCE_DIR}/sample)
    if(WIN32)
        set(ALVAR_DOXYGEN_PREDEFINED WIN32)
    endif(WIN32)
    configure_file(doxygen.config.cmake ${CMAKE_CURRENT_BINARY_DIR}/doxygen.config)
    
    # add custom target to generate api documentation
    add_custom_target(Documentation
        ${DOXYGEN_EXECUTABLE} doxygen.config
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    
    # install api documentation
    if(ALVAR_PACKAGE MATCHES sdk)
        file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html)
        install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html DESTINATION doc)
    endif(ALVAR_PACKAGE MATCHES sdk)
endif(DOXYGEN_FOUND)

# install additional documentation files
install(FILES ALVAR.pdf DESTINATION doc)
if(ALVAR_PACKAGE MATCHES sdk)
    install(FILES ReleaseNotes.txt DESTINATION doc)
    install(FILES Compiling.txt DESTINATION doc)
endif(ALVAR_PACKAGE MATCHES sdk)
