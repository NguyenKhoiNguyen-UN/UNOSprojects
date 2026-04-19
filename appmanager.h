#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QFile>
#include <QTextStream>
#include <QSettings>

class AppManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList menuApps READ menuApps NOTIFY appsChanged)
    Q_PROPERTY(QVariantList panelApps READ panelApps NOTIFY appsChanged)

public:
    explicit AppManager(QObject *parent = nullptr);
    QVariantList menuApps() const { return m_menuApps; }
    QVariantList panelApps() const { return m_panelApps; }
    Q_INVOKABLE void loadAppData();
    Q_INVOKABLE void launchApp(const QString &name, const QString &exec);
    Q_INVOKABLE QVariantList searchApps(const QString &query);
    Q_INVOKABLE void pickWallpaper();
    Q_INVOKABLE QString savedWallpaper();
    Q_INVOKABLE void setWallpaper(const QString &path);

signals:
    void appsChanged();
    void launchFailed(const QString &name, const QString &exec);  // ← chỉ 1 cái
    void wallpaperChanged(const QString &path);

private:
    QVariantList m_menuApps;
    QVariantList m_panelApps;
    QVariantList parseFile(const QString &filePath);
    QString m_wallpaperPath;
};

#endif