#include "SignatureCaptureApplication.h"
#include "InstanceGuard.h"

#include <QGuiApplication>
#include <QDebug>

namespace
{
    const QString APPLICATION_NAME = "SignatureCaptureApp";
    const QString APPLICATION_VERSION = "1.0.0";
}

int main(int argc, char *argv[])
{   
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("SumUp");
    QCoreApplication::setOrganizationDomain("sumup.com");
    QCoreApplication::setApplicationName(APPLICATION_NAME);
    QCoreApplication::setApplicationVersion(APPLICATION_VERSION);

    InstanceGuard guard(APPLICATION_NAME);

    if (!guard.tryRun()) {
        qDebug() << "Cannot initialize " + APPLICATION_NAME + ": Another instance is running.";
    }
    else {
        SignatureCaptureApplication app(argc, argv);

        if (!app.initialize()) {
            qDebug() << "Cannot initialize " + APPLICATION_NAME + ": Initialization failed.";
        }
        else {
            app.exec();
        }
    }

    return 0;
}
