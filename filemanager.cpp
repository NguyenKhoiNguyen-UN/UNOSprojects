#include "filemanager.h"
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QStorageInfo>
#include <QDebug>

FileManager::FileManager(QObject *parent) : QObject(parent) {
#ifdef Q_OS_WIN
    m_currentPath = QDir::homePath();
#else
    m_currentPath = QDir::homePath();
#endif
    loadFiles();
}

void FileManager::loadFiles() {
    m_files.clear();
    QDir dir(m_currentPath);
    dir.setFilter(QDir::AllEntries | QDir::NoDotAndDotDot | QDir::Hidden);
    dir.setSorting(QDir::DirsFirst | QDir::Name | QDir::IgnoreCase);

    for (const QFileInfo &info : dir.entryInfoList()) {
        QVariantMap file;
        file["name"] = info.fileName();
        file["path"] = info.absoluteFilePath();
        file["isDir"] = info.isDir();
        file["size"] = info.isDir() ? "" : formatSize(info.size());
        file["modified"] = info.lastModified().toString("dd/MM/yyyy hh:mm");
        file["suffix"] = info.suffix().toLower();

        // icon type
        if (info.isDir()) {
            file["type"] = "folder";
        } else {
            QString suffix = info.suffix().toLower();
            if (QStringList{"png","jpg","jpeg","bmp","webp","gif"}.contains(suffix))
                file["type"] = "image";
            else if (QStringList{"mp4","avi","mkv","mov"}.contains(suffix))
                file["type"] = "video";
            else if (QStringList{"mp3","wav","flac","ogg"}.contains(suffix))
                file["type"] = "audio";
            else if (suffix == "txt")
                file["type"] = "text";
            else if (QStringList{"exe","appimage","sh"}.contains(suffix))
                file["type"] = "app";
            else
                file["type"] = "file";
        }

        m_files.append(file);
    }
    emit filesChanged();
}

void FileManager::navigateTo(const QString &path) {
    QDir dir(path);
    if (dir.exists()) {
        m_currentPath = dir.absolutePath();
        emit pathChanged();
        loadFiles();
    } else {
        emit errorOccurred("Không thể mở: " + path);
    }
}

void FileManager::navigateUp() {
    QDir dir(m_currentPath);
    if (dir.cdUp()) {
        m_currentPath = dir.absolutePath();
        emit pathChanged();
        loadFiles();
    }
}

void FileManager::refresh() {
    loadFiles();
}

void FileManager::copyToClipboard(const QString &path) {
    m_clipboardPath = path;
    m_isCut = false;
}

void FileManager::cutToClipboard(const QString &path) {
    m_clipboardPath = path;
    m_isCut = true;
}

void FileManager::pasteFromClipboard(const QString &destPath) {
    if (m_clipboardPath.isEmpty()) return;

    QFileInfo src(m_clipboardPath);
    QString dest = destPath + "/" + src.fileName();

    if (m_isCut) {
        QFile::rename(m_clipboardPath, dest);
        m_clipboardPath = "";
        emit operationSuccess("Đã di chuyển: " + src.fileName());
    } else {
        QFile::copy(m_clipboardPath, dest);
        emit operationSuccess("Đã sao chép: " + src.fileName());
    }
    loadFiles();
}

void FileManager::deleteFile(const QString &path) {
    QFileInfo info(path);
    bool ok = false;
    if (info.isDir()) {
        QDir dir(path);
        ok = dir.removeRecursively();
    } else {
        ok = QFile::remove(path);
    }
    if (ok) {
        emit operationSuccess("Đã xóa: " + info.fileName());
        loadFiles();
    } else {
        emit errorOccurred("Không thể xóa: " + info.fileName());
    }
}

void FileManager::renameFile(const QString &path, const QString &newName) {
    QFileInfo info(path);
    QString newPath = info.absoluteDir().absolutePath() + "/" + newName;
    if (QFile::rename(path, newPath)) {
        emit operationSuccess("Đã đổi tên thành: " + newName);
        loadFiles();
    } else {
        emit errorOccurred("Không thể đổi tên!");
    }
}

void FileManager::createFolder(const QString &path, const QString &name) {
    QDir dir(path);
    if (dir.mkdir(name)) {
        emit operationSuccess("Đã tạo thư mục: " + name);
        loadFiles();
    } else {
        emit errorOccurred("Không thể tạo thư mục!");
    }
}

void FileManager::createTextFile(const QString &path, const QString &name) {
    QString fullName = name.endsWith(".txt") ? name : name + ".txt";
    QFile file(path + "/" + fullName);
    if (file.open(QIODevice::WriteOnly)) {
        file.close();
        emit operationSuccess("Đã tạo tệp: " + fullName);
        loadFiles();
    } else {
        emit errorOccurred("Không thể tạo tệp!");
    }
}

QVariantList FileManager::getDrives() {
    QVariantList drives;
    for (const QStorageInfo &storage : QStorageInfo::mountedVolumes()) {
        if (storage.isValid() && storage.isReady()) {
            QVariantMap drive;
            drive["name"] = storage.displayName().isEmpty()
                                ? storage.rootPath() : storage.displayName();
            drive["path"] = storage.rootPath();
            drive["total"] = formatSize(storage.bytesTotal());
            drive["free"] = formatSize(storage.bytesFree());
            drives.append(drive);
        }
    }
    return drives;
}

QString FileManager::formatSize(qint64 bytes) {
    if (bytes < 1024) return QString::number(bytes) + " B";
    if (bytes < 1024*1024) return QString::number(bytes/1024) + " KB";
    if (bytes < 1024*1024*1024) return QString::number(bytes/1024/1024) + " MB";
    return QString::number(bytes/1024/1024/1024) + " GB";
}

void FileManager::copyFile(const QString &src, const QString &dest) {
    QFile::copy(src, dest);
    loadFiles();
}

void FileManager::cutFile(const QString &src, const QString &dest) {
    QFile::rename(src, dest);
    loadFiles();
}