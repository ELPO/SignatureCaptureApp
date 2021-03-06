/**
 *  @brief Class that acts as a bridge between the QML UI and the C++
 *  backend.
 */

#include "QMLAdapter.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QTimer>

constexpr char POST_URL[] = "https://httpbin.org/post";

QMLAdapter::QMLAdapter(QObject *parent)
    : QObject(parent)
    , m_infoText("Please sign here")
    , m_postUrl(POST_URL)
    , m_outputLocal(false)
    , m_lineWidth(4)
{   

}

QString QMLAdapter::infoText() const
{
    return m_infoText;
}

void QMLAdapter::setInfoText(const QString &newText)
{
    m_infoText = newText;
    emit infoTextChanged(m_infoText);
}

QString QMLAdapter::postUrl() const
{
    return m_postUrl;
}

void QMLAdapter::setPostUrl(const QString &postUrl)
{
    m_postUrl = postUrl;
    emit postUrlChanged(m_postUrl);
}

bool QMLAdapter::outputLocal() const
{
    return m_outputLocal;
}

void QMLAdapter::setOutputLocal(bool isOutPutLocal)
{
    m_outputLocal = isOutPutLocal;
    emit outputLocalChanged(isOutPutLocal);
}

int QMLAdapter::lineWidth() const
{
    return m_lineWidth;
}

void QMLAdapter::setLineWidth(int lineWidth)
{
    m_lineWidth = lineWidth;
    emit lineWidthChanged(lineWidth);
}

// Function that simulates the payment.
void QMLAdapter::pay(const QList<int> &gesture, int attempts, int duration)
{
    QString data = toJson(gesture, attempts, duration);

    if (m_outputLocal) {
        setInfoText("Sending signature data to stdout...");

        QTextStream out(stdout);
        out << data << endl;

        setInfoText("Success!");
        emit requestCompleted();

        QTimer::singleShot(2000, [&](){
            setInfoText("Please sign here");
        });
    } else {
        setInfoText("Sending signature data via POST...");

        QNetworkAccessManager *nam = new QNetworkAccessManager(this);
        connect(nam, &QNetworkAccessManager::finished, nam, &QNetworkAccessManager::deleteLater);
        connect(nam, &QNetworkAccessManager::finished, nam, [&](QNetworkReply *reply) // lambda that gets executed when the request finish
        {
            if (reply->error() != 0) { // error
                qDebug() << "Request error: " << reply->errorString();
                setInfoText("Error: " + reply->errorString());
            }
            else {
                QByteArray bts = reply->readAll();
                QString str(bts);
                qDebug() << str; // logging the request reply
                setInfoText("Success!");
            }

            emit requestCompleted();

            QTimer::singleShot(2000, [&](){
                setInfoText("Please sign here");
            });
        });

        QNetworkRequest request;
        request.setUrl(QUrl(m_postUrl));
        request.setHeader(QNetworkRequest::ContentTypeHeader,
                          QStringLiteral("text/html; charset=utf-8"));

        nam->post(request, data.toUtf8());
    }
}

// We transform the signature into JSON data
QString QMLAdapter::toJson(const QList<int> &gesture, int attempts, int duration) const
{
    QJsonObject jsonSignature, jsonObj;
    QJsonArray coords;
    foreach (int coor, gesture) {
        coords.append(coor);
    }

    jsonSignature["gesture"] = coords;
    jsonSignature["stroke_width"] = m_lineWidth;
    jsonSignature["time"] = duration;
    jsonSignature["tries"] = attempts;
    jsonSignature["version"] = 2; // hardcoded

    jsonObj["signature"] = jsonSignature;

    QJsonDocument jsonDoc(jsonObj);
    return jsonDoc.toJson(QJsonDocument::Compact); // Maybe QJsonDocument::Indented is better?
}
