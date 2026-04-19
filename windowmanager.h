#ifndef WINDOWMANAGER_H
#define WINDOWMANAGER_H

#include <QObject>
#include <QMap>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickWindow>
#include <QVariantList>

class WindowManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList openWindows READ openWindows NOTIFY windowsChanged)

public:
    explicit WindowManager(QObject *parent = nullptr);
    void setEngine(QQmlEngine *engine);

    QVariantList openWindows() const { return m_openWindows; }

    Q_INVOKABLE void openApp(const QString &exec);
    Q_INVOKABLE void toggleApp(const QString &exec);
    Q_INVOKABLE void closeApp(const QString &exec);
    Q_INVOKABLE bool isOpen(const QString &exec) const;
    Q_INVOKABLE bool isVisible(const QString &exec) const;

signals:
    void windowsChanged();

private:
    QQmlEngine *m_engine = nullptr;
    QMap<QString, QQuickWindow*> m_windows;
    QVariantList m_openWindows;

    const QMap<QString, QString> m_appQmlMap = {
                                                {"__filemanager__", "qrc:/qt/qml/Unde/FileManager.qml"},
                                                };

    void updateOpenWindows();
};

#endif