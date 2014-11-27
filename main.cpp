#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("appColor","#FF4444");
    viewer.setMainQmlFile(QStringLiteral("qml/proLIFErate/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
