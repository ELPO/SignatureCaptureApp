#include "SignatureCaptureApplication.h"

#include <QQmlContext>
#include <QQuickStyle>
#include <QDebug>

SignatureCaptureApplication::SignatureCaptureApplication(int &argc, char **argv)
    : QGuiApplication (argc, argv)
{

}

bool SignatureCaptureApplication::initialize()
{
    QQuickStyle::setStyle("Material");

//    m_engine.addImageProvider(QLatin1String("vfimage"), m_vfAdapter->getImageProvider());
//    m_engine.rootContext()->setContextProperty("adapter", m_vfAdapter);
//    m_engine.rootContext()->setContextProperty("metadata", m_scanMetadata.data());
    m_engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));

    if (m_engine.rootObjects().isEmpty()) {
        qDebug() << "Failed to initialize SignatureCapture UI";
        return false;
    }

    return true;
}
