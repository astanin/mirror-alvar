# define debug and release projects
if(ALVAR_PACKAGE MATCHES sdk)
    string(REGEX REPLACE "^(.*)(debug|release)$" "\\1" _path "${CMAKE_BINARY_DIR}")
    set(CPACK_INSTALL_CMAKE_PROJECTS
        "${_path}debug;ALVAR;ALL;/"
        "${_path}release;ALVAR;ALL;/"
    )
endif(ALVAR_PACKAGE MATCHES sdk)

# define generator
if(WIN32)
    set(CPACK_GENERATOR NSIS)
    set(_target win)
else(WIN32)
    set(CPACK_GENERATOR TGZ)
    set(_target linux)
endif(WIN32)

# define bitness
if(WIN32)
    if(CMAKE_CL_64)
        set(_bits 64)
    else(CMAKE_CL_64)
        set(_bits 32)
    endif(CMAKE_CL_64)
else(WIN32)
    if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "64$")
        set(_bits 64)
    else(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "64$")
        set(_bits 32)
    endif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "64$")
endif(WIN32)

# define compiler
if(BUILDNAME MATCHES "nm2005")
    set(_compiler vs2005)
elseif(BUILDNAME MATCHES "nm2008")
    set(_compiler vs2008)
elseif(BUILDNAME MATCHES "nm2010")
    set(_compiler vs2010)
elseif(BUILDNAME MATCHES "gcc43")
    set(_compiler gcc43)
elseif(BUILDNAME MATCHES "gcc44")
    set(_compiler gcc44)
elseif(BUILDNAME MATCHES "gcc45")
    set(_compiler gcc45)
endif(BUILDNAME MATCHES "nm2005")

# define package name and licence
set(CPACK_PACKAGE_NAME "ALVAR ${ALVAR_VERSION} ${ALVAR_PACKAGE} ${_target}${_bits} ${_compiler}")
set(CPACK_PACKAGE_FILE_NAME alvar-${ALVAR_VERSION}-${ALVAR_PACKAGE}-${_target}${_bits}-${_compiler})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "ALVAR ${ALVAR_VERSION} ${ALVAR_PACKAGE} ${_target}${_bits} ${_compiler}")
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_SOURCE_DIR}/LICENSE)

# define package description and version
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ALVAR - A Library for Virtual and Augmented Reality")
set(CPACK_PACKAGE_VENDOR VTT)
set(CPACK_PACKAGE_VERSION_MAJOR ${ALVAR_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${ALVAR_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${ALVAR_VERSION_PATCH})
set(CPACK_PACKAGE_VERSION ${ALVAR_VERSION})

# define nsis shortcuts
if(WIN32)
    set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "ALVAR ${ALVAR_VERSION} ${ALVAR_PACKAGE} ${_target}${_bits} ${_compiler}")
    set(_splash ${CMAKE_SOURCE_DIR}/doc/splash.bmp)
    set(_header ${CMAKE_SOURCE_DIR}/doc/header.bmp)
    string(REPLACE "/" "\\\\" _splash ${_splash})
    string(REPLACE "/" "\\\\" _header ${_header})
    set(CPACK_NSIS_DEFINES "
        !define MUI_WELCOMEFINISHPAGE_BITMAP \\\"${_splash}\\\"
        !define MUI_HEADERIMAGE_BITMAP \\\"${_header}\\\"
    ")
    set(CPACK_NSIS_CREATE_ICONS "
        SetOutPath \\\"$INSTDIR\\\\bin\\\"
        CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\ALVAR.lnk\\\" \\\"$INSTDIR\\\\doc\\\\ALVAR.pdf\\\"
        CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\License.lnk\\\" \\\"$INSTDIR\\\\LICENSE\\\"
    ")
    set(CPACK_NSIS_DELETE_ICONS "
        Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\ALVAR.lnk\\\"
        Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\License.lnk\\\"
    ")
    if(ALVAR_PACKAGE MATCHES sdk)
        set(CPACK_NSIS_CREATE_ICONS "
            ${CPACK_NSIS_CREATE_ICONS}
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Documentation.lnk\\\" \\\"$INSTDIR\\\\doc\\\\html\\\\index.html\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Release Notes.lnk\\\" \\\"$INSTDIR\\\\doc\\\\ReleaseNotes.txt\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Compiling.lnk\\\" \\\"$INSTDIR\\\\doc\\\\Compiling.txt\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Install Directory.lnk\\\" \\\"$INSTDIR\\\\\\\"
        ")
        set(CPACK_NSIS_DELETE_ICONS "
            ${CPACK_NSIS_DELETE_ICONS}
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Documentation.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Release Notes.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Compiling.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Install Directory.lnk\\\"
        ")
    elseif(ALVAR_PACKAGE MATCHES bin)
        set(CPACK_NSIS_CREATE_ICONS "
            ${CPACK_NSIS_CREATE_ICONS}
            CreateDirectory \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleCamCalib.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplecamcalib.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleCvTestbed.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplecvtestbed.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleFilter.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplefilter.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleIntegralImage.lnk\\\" \\\"$INSTDIR\\\\bin\\\\sampleintegralimage.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleLabeling.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplelabeling.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleMarkerCreator.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplemarkercreator.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleMarkerDetector.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplemarkerdetector.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleMarkerHide.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplemarkerhide.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleMarkerlessCreator.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplemarkerlesscreator.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleMarkerlessDetector.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplemarkerlessdetector.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleMultiMarker.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplemultimarker.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleMultiMarkerBundle.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplemultimarkerbundle.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleOptimization.lnk\\\" \\\"$INSTDIR\\\\bin\\\\sampleoptimization.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SamplePointcloud.lnk\\\" \\\"$INSTDIR\\\\bin\\\\samplepointcloud.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Samples\\\\SampleTrack.lnk\\\" \\\"$INSTDIR\\\\bin\\\\sampletrack.exe\\\"
            CreateDirectory \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Demos\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Demos\\\\Demo3DMarkerField.lnk\\\" \\\"$INSTDIR\\\\bin\\\\demo3dmarkerfield.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Demos\\\\DemoFern.lnk\\\" \\\"$INSTDIR\\\\bin\\\\demofern.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Demos\\\\DemoMarkerField.lnk\\\" \\\"$INSTDIR\\\\bin\\\\demomarkerfield.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Demos\\\\DemoMarkerHide.lnk\\\" \\\"$INSTDIR\\\\bin\\\\demomarkerhide.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Demos\\\\DemoModel2Marker.lnk\\\" \\\"$INSTDIR\\\\bin\\\\demomodel2marker.exe\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Demos\\\\DemoSfm.lnk\\\" \\\"$INSTDIR\\\\bin\\\\demosfm.exe\\\"
        ")
        set(CPACK_NSIS_DELETE_ICONS "
            ${CPACK_NSIS_DELETE_ICONS}
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleCamCalib.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleCvTestbed.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleFilter.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleIntegralImage.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleLabeling.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleMarkerCreator.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleMarkerDetector.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleMarkerHide.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleMarkerlessCreator.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleMarkerlessDetector.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleMultiMarker.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleMultiMarkerBundle.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleOptimization.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SamplePointcloud.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\\SampleTrack.lnk\\\"
            RMDir \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Samples\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Demos\\\\Demo3DMarkerField.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Demos\\\\DemoFern.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Demos\\\\DemoMarkerField.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Demos\\\\DemoMarkerHide.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Demos\\\\DemoModel2Marker.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Demos\\\\DemoSfm.lnk\\\"
            RMDir \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Demos\\\"
        ")
    endif(ALVAR_PACKAGE MATCHES sdk)
endif(WIN32)
