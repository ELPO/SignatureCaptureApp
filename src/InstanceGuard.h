#ifndef INSTANCEGUARD_H
#define INSTANCEGUARD_H

#include <QObject>
#include <QSharedMemory>
#include <QSystemSemaphore>

class InstanceGuard
{
public:
    explicit InstanceGuard(const QString& key);
    ~InstanceGuard();

    bool tryRun();
    void release();
    bool isAnotherRunning();

private:
    const QString m_key;
    const QString m_lockKey;
    const QString m_memKey;

    QSharedMemory m_sharedMem;
    QSystemSemaphore m_lock;

    Q_DISABLE_COPY(InstanceGuard)
};

#endif // INSTANCEGUARD_H
