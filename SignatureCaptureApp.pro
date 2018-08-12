QT += quick quickcontrols2 network

include(deployment.pri)

# C++ Compiler
CONFIG += c++11
QMAKE_CXXFLAGS *= /std:c++17

DEFINES += QT_DEPRECATED_WARNINGS

# AppIcon
RC_ICONS = appIcon.ico

# Outputs
BUILDPATH = $$PWD/builds

win32:CONFIG(debug, debug|release) {
    DESTPATH = $${BUILDPATH}/SignatureCaptureApp/debug
    DESTDIR = $${DESTPATH}/bin
    OBJECTS_DIR = $${DESTPATH}/.obj
    MOC_DIR = $${DESTPATH}/.moc
    RCC_DIR = $${DESTPATH}/.rcc
    UI_DIR = $${DESTPATH}/.ui
}

win32:CONFIG(release, debug|release) {
    DESTPATH = $${BUILDPATH}/SignatureCaptureApp/release
    DESTDIR = $${DESTPATH}/bin
    OBJECTS_DIR = $${DESTPATH}/.obj
    MOC_DIR = $${DESTPATH}/.moc
    RCC_DIR = $${DESTPATH}/.rcc
    UI_DIR = $${DESTPATH}/.ui
}

# Qt version check
SC_QT_VERSION = "5.10.0"
if (!contains(QT_VERSION, $$SC_QT_VERSION)) {
    message("Cannot build signature Capture App with Qt version $${QT_VERSION}.")
    error("Use Qt " $$SC_QT_VERSION)
}

# Win Qt deployment variables
win32 {
    if (isEmpty($$TARGET_EXT)) {
        TARGET_EXT = ".exe"
    }

    DEPLOY_COMMAND = windeployqt
    DEPLOY_TARGET = $$shell_quote($$shell_path($${DESTDIR}/$${TARGET}$${TARGET_EXT}))
    DEPLOY_QML_DIR = $$shell_path($$PWD/src/qml)
    OPENSSL_LIBEAY = $$PWD/libs/openssl/bin/libeay32.dll
    OPENSSL_SSLEAY = $$PWD/libs/openssl/bin/ssleay32.dll
}

# Deploy Dependencies
win32 {
    deployQtDependencies($${DEPLOY_QML_DIR}, $${DEPLOY_TARGET})
    copyToBuildDir($$OPENSSL_LIBEAY)
    copyToBuildDir($$OPENSSL_SSLEAY)
}

SOURCES += \
    src/main.cpp \
    src/InstanceGuard.cpp \
    src/SignatureCaptureApplication.cpp \
    src/QMLAdapter.cpp

RESOURCES += qml.qrc

HEADERS += \
    src/InstanceGuard.h \
    src/SignatureCaptureApplication.h \
    src/QMLAdapter.h
