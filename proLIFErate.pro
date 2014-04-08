# Add more folders to ship with the application, here
folder_01.source = qml/proLIFErate
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    android/AndroidManifest.xml \
    android/version.xml \
    android/res/values-zh-rTW/strings.xml \
    android/res/values-et/strings.xml \
    android/res/values-nl/strings.xml \
    android/res/values-pt-rBR/strings.xml \
    android/res/layout/splash.xml \
    android/res/values-it/strings.xml \
    android/res/values-el/strings.xml \
    android/res/values-pl/strings.xml \
    android/res/values-de/strings.xml \
    android/res/values-fr/strings.xml \
    android/res/values-es/strings.xml \
    android/res/values-ms/strings.xml \
    android/res/values-ru/strings.xml \
    android/res/values-ja/strings.xml \
    android/res/values/strings.xml \
    android/res/values-rs/strings.xml \
    android/res/values-zh-rCN/strings.xml \
    android/res/values-ro/strings.xml \
    android/res/values-id/strings.xml \
    android/res/values-nb/strings.xml \
    android/res/values-fa/strings.xml \
    android/src/org/kde/necessitas/ministro/IMinistro.aidl \
    android/src/org/kde/necessitas/ministro/IMinistroCallback.aidl \
    android/src/org/kde/necessitas/origo/QtApplication.java \
    android/src/org/kde/necessitas/origo/QtActivity.java

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
