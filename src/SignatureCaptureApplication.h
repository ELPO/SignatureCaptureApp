#ifndef SIGNATURECAPTUREAPPLICATION_H
#define SIGNATURECAPTUREAPPLICATION_H

#include "QMLAdapter.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QNetworkAccessManager>

class SignatureCaptureApplication : public QGuiApplication
{
    Q_OBJECT

public:
    explicit SignatureCaptureApplication(int &argc, char **argv);

    bool initialize();

private:
    QQmlApplicationEngine m_engine;
    QScopedPointer<QMLAdapter> m_adapter;
    QNetworkAccessManager *m_networkManager;

    Q_DISABLE_COPY(SignatureCaptureApplication)
};

#endif // SIGNATURECAPTUREAPPLICATION_H
