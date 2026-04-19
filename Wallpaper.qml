import QtQuick
import QtQuick.Window

Window {
    id: wallpaperWindow
    visible: true
    width: Screen.width > 0 ? Screen.width : 800
    height: Screen.height > 0 ? Screen.height : 600
    visibility: Window.FullScreen
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnBottomHint
    color: "black"

    Image {
        id: wallpaper
        anchors.fill: parent
        source: AppManager.savedWallpaper()
        fillMode: Image.PreserveAspectCrop
    }

    Connections {
        target: AppManager
        function onWallpaperChanged(path) {
            wallpaper.source = path
        }
    }
}