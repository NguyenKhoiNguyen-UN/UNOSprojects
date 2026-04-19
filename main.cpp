#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include "appmanager.h"
#include "filemanager.h"
#include "windowmanager.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QQuickWindow::setDefaultAlphaBuffer(true);

    AppManager appManager;
    FileManager fileManager;
    WindowManager windowManager;

    QQmlApplicationEngine engine;
    windowManager.setEngine(&engine);

    engine.rootContext()->setContextProperty("AppManager", &appManager);
    engine.rootContext()->setContextProperty("FileMgr", &fileManager);
    engine.rootContext()->setContextProperty("WinMgr", &windowManager);

    engine.loadFromModule("Unde", "Main");

    return app.exec();
}