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

    m_engine.rootContext()->setContextProperty("adapter", m_adapter.data());
    m_engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));

    if (m_engine.rootObjects().isEmpty()) {
        qDebug() << "Failed to initialize SignatureCapture UI";
        return false;
    }

//    connect(m_adapter.data(), &QMLAdapter::dataReadyToExport, [&](const QString &data) {
//        QTextStream out(stdout);
//        out << data << endl;


//        QNetworkAccessManager *mgr = new QNetworkAccessManager(this);
//        connect(mgr, &QNetworkAccessManager::finished, mgr, &QNetworkAccessManager::deleteLater);
//        connect(mgr, &QNetworkAccessManager::finished, mgr, [&](QNetworkReply *reply)
//        {
//            if (reply->error() != 0) {// no error
//                qDebug() << "Request error: " << reply->errorString();
//            }
//            else {
//                QByteArray bts = reply->readAll();
//                    QString str(bts);

//                    qDebug() << "answer!!! : " << str;
//                m_adapter->setInfoText("Success!");
//            }
//        });

//        QNetworkRequest request(QUrl(m_adapter->postUrl()));
//        request.setHeader(QNetworkRequest::ContentTypeHeader,
//                          QStringLiteral("text/html; charset=utf-8"));

//        mgr->post(request, data.toUtf8());

//    });

    return true;
}
