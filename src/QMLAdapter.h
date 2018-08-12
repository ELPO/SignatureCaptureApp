#ifndef QMLADAPTER_H
#define QMLADAPTER_H

#include <QObject>

class QMLAdapter : public QObject
{
    Q_OBJECT

    // QML-C++ properties
    Q_PROPERTY(QString infoText READ infoText WRITE setInfoText NOTIFY infoTextChanged) //text of the header of the app
    Q_PROPERTY(QString postUrl READ postUrl WRITE setPostUrl NOTIFY postUrlChanged) // output method in settings menu
    Q_PROPERTY(bool outputLocal READ outputLocal WRITE setOutputLocal NOTIFY outputLocalChanged) // post url in settings menu
    Q_PROPERTY(int lineWidth READ lineWidth WRITE setLineWidth NOTIFY lineWidthChanged) // signature width in settings menu

public:
    QMLAdapter(QObject *parent = Q_NULLPTR);

    QString infoText() const;
    void setInfoText(const QString &newText);

    QString postUrl() const;
    void setPostUrl(const QString &postUrl);

    bool outputLocal() const;
    void setOutputLocal(bool isOutPutLocal);

    int lineWidth() const;
    void setLineWidth(int lineWidth);

    Q_INVOKABLE void pay(const QList<int> &gesture, int attempts, int duration);

    QString toJson(const QList<int> &gesture, int attempts, int duration) const;

signals:
    void infoTextChanged(const QString &newText);
    void postUrlChanged(const QString &postUrl);
    void outputLocalChanged(bool isOutputLocal);
    void lineWidthChanged(int lineWidth);

    void dataReadyToExport(const QString &data);

    void requestCompleted();

private:
    QString m_infoText;
    QString m_postUrl;

    bool m_outputLocal;

    int m_lineWidth;

    Q_DISABLE_COPY(QMLAdapter)
};

#endif // QMLADAPTER_H
