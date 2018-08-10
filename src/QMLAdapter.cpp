#include "QMLAdapter.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

QMLAdapter::QMLAdapter(QObject *parent)
    : QObject(parent)
{

}

void QMLAdapter::pay(const QList<int> &gesture, int attempts, int duration)
{
    emit dataReadyToExport(toJson(gesture, attempts, duration));
}

QString QMLAdapter::toJson(const QList<int> &gesture, int attempts, int duration) const
{
    QJsonObject jsonSignature, jsonObj;
    QJsonArray coors;
    foreach (int coor, gesture) {
        coors.append(coor);
    }

    jsonSignature["gesture"] = coors;
    jsonSignature["stroke_width"] = 4;
    jsonSignature["time"] = duration;
    jsonSignature["tries"] = attempts;
    jsonSignature["version"] = 2; // hardcoded

    jsonObj["signature"] = jsonSignature;

    QJsonDocument jsonDoc(jsonObj);
    return jsonDoc.toJson(QJsonDocument::Compact); // Maybe QJsonDocument::Indented is better?
}
