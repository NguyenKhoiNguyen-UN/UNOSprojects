#include "appmanager.h"
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QCoreApplication>
#include <QProcess>
#include <QFileDialog>
#include <QApplication>

AppManager::AppManager(QObject *parent) : QObject(parent) {
    loadAppData();
}

QVariantList AppManager::parseFile(const QString &filePath) {
    QVariantList list;
    QFile file(filePath);

    if (!file.exists()) {
        qWarning() << "LỖI: Không tìm thấy file trong Resource tại:" << filePath;
        return list;
    }

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        in.setEncoding(QStringConverter::Utf8);

        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();
            if (line.isEmpty()) continue;

            QStringList parts = line.split("|");
            if (parts.size() >= 3) {
                QVariantMap app;
                app["name"] = parts[0].trimmed();
                app["icon"] = parts[1].trimmed();
                app["exec"] = parts[2].trimmed();
                list.append(app);
            }
        }
        file.close();
        qDebug() << "Thành công: Đã đọc" << list.size() << "apps từ" << filePath;
    } else {
        qWarning() << "LỖI: Không thể mở file:" << filePath;
    }
    return list;
}

void AppManager::loadAppData() {
    m_panelApps = parseFile(":/panel_apps.txt");
    m_menuApps = parseFile(":/all_apps.txt");

    emit appsChanged();

    //emit panelAppsChanged();
    //emit menuAppsChanged();
}

void AppManager::launchApp(const QString &name, const QString &exec) {
    if (exec.isEmpty()) {
        emit launchFailed("(không rõ)", "");
        return;
    }
    bool ok = QProcess::startDetached(exec, QStringList());
    if (!ok) {
        emit launchFailed(name, exec);
    }
}

void AppManager::pickWallpaper() {
    QString path = QFileDialog::getOpenFileName(
        nullptr,
        "Chọn hình nền",
        QDir::homePath(),
        "Ảnh (*.png *.jpg *.jpeg *.bmp *.webp)"
        );
    if (!path.isEmpty()) {
        m_wallpaperPath = path;
        QSettings settings("Unde", "DEService");
        settings.setValue("wallpaper", path);
        emit wallpaperChanged("file:///" + path);
    }
}

QString AppManager::savedWallpaper() {
    QSettings settings("Unde", "DEService");
    QString path = settings.value("wallpaper", "").toString();
    if (!path.isEmpty()) {
        return "file:///" + path;
    }
    return "qrc:/wallpaper1.png";
}

void AppManager::setWallpaper(const QString &path) {
    QSettings settings("Unde", "DEService");
    // bỏ "file:///" để lưu path thuần
    QString cleanPath = path;
    cleanPath.remove("file:///");
    settings.setValue("wallpaper", cleanPath);
    emit wallpaperChanged(path);
}

QVariantList AppManager::searchApps(const QString &query) {
    QVariantList results;
    if (query.trimmed().isEmpty()) return results;
    QString q = query.toLower();
    for (const QVariant &item : m_menuApps) {
        QVariantMap app = item.toMap();
        if (app["name"].toString().toLower().contains(q)) {
            results.append(app);
        }
    }
    return results;
}