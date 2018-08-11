#ifndef QMLADAPTER_H
#define QMLADAPTER_H

#include <QObject>

class QMLAdapter : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString infoText READ infoText WRITE setInfoText NOTIFY infoTextChanged)
    Q_PROPERTY(QString postUrl READ postUrl WRITE setPostUrl NOTIFY postUrlChanged)
    Q_PROPERTY(bool outputLocal READ outputLocal WRITE setOutputLocal NOTIFY outputLocalChanged)
    Q_PROPERTY(bool antialising READ antialising WRITE setAntialising NOTIFY antialisingChanged)
    Q_PROPERTY(int lineWidth READ lineWidth WRITE setLineWidth NOTIFY lineWidthChanged)

public:
    QMLAdapter(QObject *parent = Q_NULLPTR);

    QString infoText() const;
    void setInfoText(const QString &newText);

    QString postUrl() const;
    void setPostUrl(const QString &postUrl);

    bool outputLocal() const;
    void setOutputLocal(bool isOutPutLocal);

    bool antialising() const;
    void setAntialising(bool antialising);

    int lineWidth() const;
    void setLineWidth(int lineWidth);

    Q_INVOKABLE void pay(const QList<int> &gesture, int attempts, int duration);

    QString toJson(const QList<int> &gesture, int attempts, int duration) const;

signals:
    void infoTextChanged(const QString &newText);
    void postUrlChanged(const QString &postUrl);
    void outputLocalChanged(bool isOutputLocal);
    void antialisingChanged(bool antialising);
    void lineWidthChanged(int lineWidth);

    void dataReadyToExport(const QString &data);

    void requestCompleted();

private:
    QString m_infoText;
    QString m_postUrl;

    bool m_outputLocal;
    bool m_antialising;

    int m_lineWidth;

    Q_DISABLE_COPY(QMLAdapter)
};

#endif // QMLADAPTER_H
