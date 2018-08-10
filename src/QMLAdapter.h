#ifndef QMLADAPTER_H
#define QMLADAPTER_H

#include <QObject>

class QMLAdapter : public QObject
{
    Q_OBJECT

public:
    QMLAdapter(QObject *parent = Q_NULLPTR);

    Q_INVOKABLE void pay(const QList<int> &gesture, int attempts, int duration);

    QString toJson(const QList<int> &gesture, int attempts, int duration) const;

signals:
    void dataReadyToExport(const QString &data);

private:
    Q_DISABLE_COPY(QMLAdapter)
};

#endif // QMLADAPTER_H
