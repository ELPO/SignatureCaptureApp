#include "SignatureCaptureApplication.h"

#include <QQmlContext>
#include <QQuickStyle>
#include <QNetworkReply>
#include <QDebug>

SignatureCaptureApplication::SignatureCaptureApplication(int &argc, char **argv)
    : QGuiApplication (argc, argv)
    , m_adapter(new QMLAdapter(this))
    , m_networkManager(new QNetworkAccessManager(this))
{

}

bool SignatureCaptureApplication::initialize()
{
    QQuickStyle::setStyle("Material");

    m_engine.rootContext()->setContextProperty("adapter", m_adapter.data());
    m_engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));

    if (m_engine.rootObjects().isEmpty()) {
        qDebug() << "Failed to initialize SignatureCapture UI";
        return false;
    }

    connect(m_adapter.data(), &QMLAdapter::dataReadyToExport, [&](const QString &data) {
        QTextStream out(stdout);
        out << data << endl;


        QNetworkAccessManager *mgr = new QNetworkAccessManager(this);
        connect(mgr, &QNetworkAccessManager::finished, mgr, &QNetworkAccessManager::deleteLater);
        connect(mgr, &QNetworkAccessManager::finished, mgr, [](QNetworkReply *reply) {
            QByteArray bts = reply->readAll();
                QString str(bts);

                qDebug() << str;
        });

        mgr->post(QNetworkRequest(QUrl("https://httpbin.org/post")), data.toUtf8());

    });

    return true;
}
