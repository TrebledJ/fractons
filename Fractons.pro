#DEFINES += PUBLISH  # uncomment for publishing

# allows to add DEPLOYMENTFOLDERS and links to the V-Play library and QtCreator auto-completion
CONFIG += felgo

# uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
# for the remaining steps to build a custom Live Code Reload app see here: https://v-play.net/custom-code-reload-app/
!contains(DEFINES, PUBLISH): CONFIG += felgo-live	# comment for publishing

# configure the bundle identifier for iOS
PRODUCT_IDENTIFIER = com.trebledj.wizardEVP.Fractons

# comment for publishing
!contains(DEFINES, PUBLISH): qmlFolder.source = qml
!contains(DEFINES, PUBLISH): DEPLOYMENTFOLDERS += qmlFolder

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

#soundsFolder.source = assets/sounds
#DEPLOYMENTFOLDERS += soundsFolder

# Add more folders to ship with the application here

RESOURCES += \
	images.qrc \
	sounds.qrc \
#	resources.qrc # uncomment for publishing


# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the DEPLOYMENTFOLDERS += qmlFolder line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. uncomment the resources.qrc file inclusion and add any qml subfolders to the .qrc file; this compiles your qml files and js files to the app binary and protects your source code
# 3. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the qml files from the resources
# for more details see the "Deployment Guides" in the V-Play Documentation

# during development, use the qmlFolder deployment because you then get shorter compilation times (the qml files do not need to be compiled to the binary but are just copied)
# also, for quickest deployment on Desktop disable the "Shadow Build" option in Projects/Builds - you can then select "Run Without Deployment" from the Build menu in Qt Creator if you only changed QML files; this speeds up application start, because your app is not copied & re-compiled but just re-interpreted

INCLUDEPATH += cpp

SOURCES += main.cpp \
    cpp/achievement.cpp \
    cpp/achievementsmanager.cpp \
    cpp/desktopnotifications.cpp

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    OTHER_FILES += android/AndroidManifest.xml       android/build.gradle
}

ios {
    QMAKE_INFO_PLIST = ios/Project-Info.plist
    OTHER_FILES += $$QMAKE_INFO_PLIST
    
}

# set application icons for win and macx
win32 {
    RC_FILE += win/app_icon.rc
}
macx {
    ICON = macx/app_icon.icns
}

HEADERS += \
    cpp/achievement.h \
    cpp/achievementsmanager.h \
    cpp/desktopnotifications.h
