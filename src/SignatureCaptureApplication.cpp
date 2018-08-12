#include "SignatureCaptureApplication.h"

#include <QQmlContext>
#include <QQuickStyle>
#include <QDebug>

SignatureCaptureApplication::SignatureCaptureApplication(int &argc, char **argv)
    : QGuiApplication (argc, argv)
    , m_adapter(new QMLAdapter(this))
{

}

bool SignatureCaptureApplication::initialize()
{
    QQuickStyle::setStyle("Material");

    m_engine.rootContext()->setContextProperty("adapter", m_adapter.data()); // We expose the adapter class to the QML side
    m_engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));

    if (m_engine.rootObjects().isEmpty()) {
        qDebug() << "Failed to initialize SignatureCapture UI";
        return false;
    }

    return true;
}
