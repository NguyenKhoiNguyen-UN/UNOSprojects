cmake_minimum_required(VERSION 3.16)

project(Unde VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Widgets)

qt_standard_project_setup(REQUIRES 6.10)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTORCC ON)

qt_add_executable(appUnde
    main.cpp
)

qt_add_qml_module(appUnde
    URI Unde
    QML_FILES
        Main.qml
        FileManager.qml
        Wallpaper.qml
        RESOURCES Images.qrc
        SOURCES
            appmanager.h
            appmanager.cpp
            filemanager.h
            filemanager.cpp
            windowmanager.h
            windowmanager.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appUnde PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appUnde
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appUnde
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Widgets
)

install(TARGETS appUnde
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
