cmake_minimum_required(VERSION 3.16)
project(btplayer VERSION 1.0 LANGUAGES CXX)

# for Cross Compiling
set(CMAKE_SYSROOT "/opt/fsl-imx-wayland/5.10-hardknott/sysroots/cortexa53-crypto-poky-linux")
include_directories(/opt/fsl-imx-wayland/5.10-hardknott/sysroots/cortexa53-crypto-poky-linux/usr/include)


#include_directories(include)

file(GLOB SOURCES "src/*.cpp")

find_package(Qt5  COMPONENTS Quick Gui REQUIRED)

qt5_add_resources(QT_RESOURCES src/qml.qrc)

add_executable(btplayer ${SOURCES} ${QT_RESOURCES})
target_link_libraries(btplayer PRIVATE Qt5::Gui Qt5::Quick)

set(INSTALL_NAME_DIR "/opt")
install(TARGETS btplayer
    RUNTIME DESTINATION "${INSTALL_NAME_DIR}"
    BUNDLE DESTINATION "${INSTALL_NAME_DIR}"
    LIBRARY DESTINATION "${INSTALL_NAME_DIR}")
