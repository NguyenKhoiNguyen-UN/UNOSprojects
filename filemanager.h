#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QDir>
#include <QFileInfo>
#include <QDateTime>

class FileManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentPath READ currentPath NOTIFY pathChanged)
    Q_PROPERTY(QVariantList files READ files NOTIFY filesChanged)

public:
    explicit FileManager(QObject *parent = nullptr);

    QString currentPath() const { return m_currentPath; }
    QVariantList files() const { return m_files; }

    Q_INVOKABLE void navigateTo(const QString &path);
    Q_INVOKABLE void navigateUp();
    Q_INVOKABLE void refresh();

    Q_INVOKABLE void copyFile(const QString &src, const QString &dest);
    Q_INVOKABLE void cutFile(const QString &src, const QString &dest);
    Q_INVOKABLE void deleteFile(const QString &path);
    Q_INVOKABLE void renameFile(const QString &path, const QString &newName);
    Q_INVOKABLE void createFolder(const QString &path, const QString &name);
    Q_INVOKABLE void createTextFile(const QString &path, const QString &name);

    Q_INVOKABLE QVariantList getDrives();  // lấy danh sách ổ đĩa

    // clipboard
    Q_INVOKABLE void copyToClipboard(const QString &path);
    Q_INVOKABLE void cutToClipboard(const QString &path);
    Q_INVOKABLE void pasteFromClipboard(const QString &destPath);
    Q_INVOKABLE bool hasClipboard() const { return !m_clipboardPath.isEmpty(); }

signals:
    void pathChanged();
    void filesChanged();
    void errorOccurred(const QString &message);
    void operationSuccess(const QString &message);

private:
    QString m_currentPath;
    QVariantList m_files;
    QString m_clipboardPath;
    bool m_isCut = false;

    void loadFiles();
    QString formatSize(qint64 bytes);
};

#endif