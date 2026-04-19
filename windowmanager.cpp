#include "windowmanager.h"
#include <QDebug>
#include <QGuiApplication>
#include <QScreen>

WindowManager::WindowManager(QObject *parent) : QObject(parent) {}

void WindowManager::setEngine(QQmlEngine *engine) {
    m_engine = engine;
}

void WindowManager::openApp(const QString &exec) {
    if (!m_appQmlMap.contains(exec)) {
        qWarning() << "Không có QML cho:" << exec;
        return;
    }

    // Nếu đã mở thì show lên
    if (m_windows.contains(exec)) {
        m_windows[exec]->show();
        m_windows[exec]->raise();
        updateOpenWindows();
        emit windowsChanged();
        return;
    }

    // Tạo window mới
    QQmlComponent component(m_engine, QUrl(m_appQmlMap[exec]));
    if (component.isError()) {
        qWarning() << "Lỗi load QML:" << component.errorString();
        return;
    }

    QObject *obj = component.create();
    QQuickWindow *window = qobject_cast<QQuickWindow*>(obj);
    if (!window) {
        qWarning() << "Không tạo được window cho:" << exec;
        delete obj;
        return;
    }

    // Giới hạn trong màn hình
    window->setMinimumSize(QSize(400, 300));
    window->setMaximumSize(QSize(
        QGuiApplication::primaryScreen()->size().width(),
        QGuiApplication::primaryScreen()->size().height()
        ));

    m_windows[exec] = window;
    window->show();
    window->raise();
    window->requestActivate();

    // Khi window ẩn
    connect(window, &QQuickWindow::visibilityChanged,
            this, [this, exec](QWindow::Visibility v) {
                if (v == QWindow::Hidden) {
                    updateOpenWindows();
                    emit windowsChanged();
                }
            });

    // Khi window bị destroy
    connect(window, &QObject::destroyed,
            this, [this, exec]() {
                m_windows.remove(exec);
                updateOpenWindows();
                emit windowsChanged();
            });

    updateOpenWindows();
    emit windowsChanged();
}

void WindowManager::toggleApp(const QString &exec) {
    if (m_windows.contains(exec)) {
        if (m_windows[exec]->isVisible()) {
            m_windows[exec]->hide();
        } else {
            m_windows[exec]->show();
            m_windows[exec]->raise();           // ← thêm
            m_windows[exec]->requestActivate(); // ← thêm
        }
    } else {
        openApp(exec);
    }
    updateOpenWindows();
    emit windowsChanged();
}

void WindowManager::closeApp(const QString &exec) {
    if (m_windows.contains(exec)) {
        m_windows[exec]->close();
        m_windows.remove(exec);
        updateOpenWindows();
        emit windowsChanged();
    }
}

bool WindowManager::isOpen(const QString &exec) const {
    return m_windows.contains(exec) && m_windows[exec]->isVisible();
}

bool WindowManager::isVisible(const QString &exec) const {
    return m_windows.contains(exec)
    && m_windows[exec] != nullptr
                             && m_windows[exec]->isVisible();
}

void WindowManager::updateOpenWindows() {
    m_openWindows.clear();
    for (auto it = m_windows.constBegin(); it != m_windows.constEnd(); ++it) {
        if (it.value()) {
            // Thêm vào list dù ẩn hay hiện — chỉ cần còn tồn tại
            QVariantMap info;
            info["exec"] = it.key();
            info["visible"] = it.value()->isVisible();
            m_openWindows.append(info);
        }
    }
}