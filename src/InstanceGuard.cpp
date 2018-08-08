#include "InstanceGuard.h"

#include <QCryptographicHash>

namespace
{
QString generateKeyHash(const QString& key, const QString& salt)
{
    QByteArray data;

    data.append(key.toUtf8());
    data.append(salt.toUtf8());
    data = QCryptographicHash::hash(data, QCryptographicHash::Sha1).toHex();

    return data;
}

} // anonymous namespace


InstanceGuard::InstanceGuard(const QString &key)
    : m_key(key)
    , m_lockKey(generateKeyHash(key, "_lockKey"))
    , m_memKey(generateKeyHash(key, "_memKey"))
    , m_sharedMem(m_memKey)
    , m_lock(m_lockKey, 1)
{
#ifndef Q_OS_WIN

    m_lock.acquire();
    {
        QSharedMemory shmem(m_memKey);
        shmem.attach();
    }
    m_lock.release();

#endif
}

InstanceGuard::~InstanceGuard()
{
    release();
}

bool InstanceGuard::tryRun()
{
    if (isAnotherRunning())
    {
        return false;
    }

    m_lock.acquire();

    auto result = m_sharedMem.create(sizeof(quint64));

    m_lock.release();

    if (!result)
    {
        release();
        return false;
    }

    return true;
}

void InstanceGuard::release()
{
    m_lock.acquire();

    if (m_sharedMem.isAttached())
    {
        m_sharedMem.detach();
    }

    m_lock.release();
}

bool InstanceGuard::isAnotherRunning()
{
    if (m_sharedMem.isAttached())
    {
        return false;
    }

    m_lock.acquire();

    auto isRunning = m_sharedMem.attach();

    if (isRunning)
    {
        m_sharedMem.detach();
    }

    m_lock.release();

    return isRunning;
}
