QT += quick core dbus

CONFIG += c++11

DBUS_INTERFACES += org.bluez.Device1.xml \
                   org.bluez.MediaPlayer1.xml \
                   org.bluez.MediaTransport1.xml \
                   org.freedesktop.DBus.Properties.xml

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        MQueueThread.cpp \
        MediaPlayerProxy.cpp \
        MediaPlayerWrapper.cpp \
        MediaTrackInfo.cpp \
        main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
    else: unix:!android: target.path = /opt/gopoint-apps/scripts/multimedia/imx-voiceplayer

# Scritps deployment rule
scripts.files = ../scripts/init.sh \
                ../scripts/bt-init.sh \
                ../scripts/connect.sh \
                ../scripts/asound.conf \
                ../scripts/Config.ini \
                ../scripts/Enable_VoiceSeeker.sh \
                ../scripts/Restore_VoiceSeeker.sh \
                ../msgq/build/MsgQ \


scripts.path = /opt/gopoint-apps/scripts/multimedia/imx-voiceplayer

!isEmpty(target.path): INSTALLS += target
!isEmpty(scripts.path): INSTALLS += scripts

HEADERS += \
    MQueueThread.h \
    MediaPlayerProxy.h \
    MediaPlayerWrapper.h \
    MediaTrackInfo.h

DISTFILES += \
    content/MetadataInfo.qml \
    content/PlaybackControl.qml \
    content/PlaybackRateControl.qml \
    content/PlaybackSeekControl.qml \
    content/PlayerMenuBar.qml \
    content/TracksInfo.qml \
