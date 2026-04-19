import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import QtQuick.Effects

Window {
    id: root
    visible: true
    width: Screen.width > 0 ? Screen.width : 800
    height: Screen.height > 0 ? Screen.height : 600
    title: "DEService"
    color: "transparent"
    visibility: Window.FullScreen
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.WA_TranslucentBackground

    property bool enableEffects: GraphicsInfo.api !== GraphicsInfo.Software
    property bool iconsHidden: false

    ListModel {
        id: globalAppDataModel
    }

    Item {
        id: screen
        anchors.fill: parent

        function closeAllMenus() {
            desktopContextMenu.opacity = 0
            appContextMenu.opacity = 0
            panelContextMenu.opacity = 0
            createSubmenu.visible = false
            panelAppContextMenu.opacity = 0
        }

        function appExists(exec) {
            for (var i = 0; i < WinMgr.openWindows.length; i++) {
                if (WinMgr.openWindows[i].exec === exec) return true
            }
            return false
        }

        function appVisible(exec) {
            for (var i = 0; i < WinMgr.openWindows.length; i++) {
                if (WinMgr.openWindows[i].exec === exec)
                    return WinMgr.openWindows[i].visible
            }
            return false
        }

        Image {
            id: wallpaper
            z: 498
            source: AppManager.savedWallpaper()
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        Connections {
            target: AppManager
            function onWallpaperChanged(path) {
                wallpaper.source = path
            }
        }

        FileManager {
            id: fileManagerWin
            visible: false
        }

        Rectangle {
            id: panelAppContextMenu
            width: 200
            height: panelAppCol.height + 8
            color: "#1A1A1A"
            border.color: "#33FFFFFF"
            z: 1023
            visible: opacity > 0
            opacity: 0
            radius: 0

            property string currentAppName: ""
            property string currentAppExec: ""

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0; verticalOffset: 4
                radius: 12; samples: 25; color: "#80000000"
            }

            Behavior on opacity { NumberAnimation { duration: 80 } }
            Behavior on scale { NumberAnimation { duration: 80 } }
            scale: opacity > 0 ? 1.0 : 0.95

            Column {
                id: panelAppCol
                anchors.top: parent.top
                anchors.topMargin: 4
                width: parent.width

                Rectangle {
                    width: parent.width - 4; height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: pPathMA.containsMouse ? "#22FFFFFF" : "transparent"
                    Behavior on color { ColorAnimation { duration: 80 } }
                    scale: pPathMA.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 60 } }
                    Row {
                        anchors.fill: parent; anchors.leftMargin: 14; spacing: 10
                        Text { text: "📂"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Đường dẫn"; color: "white"; font.family: "Inter"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    }
                    MouseArea { id: pPathMA; anchors.fill: parent; hoverEnabled: true
                        onClicked: { console.log("Đường dẫn: " + panelAppContextMenu.currentAppExec); panelAppContextMenu.opacity = 0 }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

                Rectangle {
                    width: parent.width - 4; height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: pUninstallMA.containsMouse ? "#22FF4444" : "transparent"
                    Behavior on color { ColorAnimation { duration: 80 } }
                    scale: pUninstallMA.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 60 } }
                    Row {
                        anchors.fill: parent; anchors.leftMargin: 14; spacing: 10
                        Text { text: "🗑️"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Gỡ cài đặt"; color: pUninstallMA.containsMouse ? "#FF6B6B" : "white"
                            font.family: "Inter"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter
                            Behavior on color { ColorAnimation { duration: 80 } }
                        }
                    }
                    MouseArea { id: pUninstallMA; anchors.fill: parent; hoverEnabled: true
                        onClicked: { console.log("Gỡ cài đặt: " + panelAppContextMenu.currentAppName); panelAppContextMenu.opacity = 0 }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

                Rectangle {
                    width: parent.width - 4; height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: pIconMA.containsMouse ? "#22FFFFFF" : "transparent"
                    Behavior on color { ColorAnimation { duration: 80 } }
                    scale: pIconMA.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 60 } }
                    Row {
                        anchors.fill: parent; anchors.leftMargin: 14; spacing: 10
                        Text { text: "🖼️"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Đổi biểu tượng"; color: "white"; font.family: "Inter"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    }
                    MouseArea { id: pIconMA; anchors.fill: parent; hoverEnabled: true
                        onClicked: { console.log("Đổi icon: " + panelAppContextMenu.currentAppName); panelAppContextMenu.opacity = 0 }
                    }
                }

                Rectangle {
                    width: parent.width - 4; height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: pRenameMA.containsMouse ? "#22FFFFFF" : "transparent"
                    Behavior on color { ColorAnimation { duration: 80 } }
                    scale: pRenameMA.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 60 } }
                    Row {
                        anchors.fill: parent; anchors.leftMargin: 14; spacing: 10
                        Text { text: "✏️"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Đổi tên"; color: "white"; font.family: "Inter"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    }
                    MouseArea { id: pRenameMA; anchors.fill: parent; hoverEnabled: true
                        onClicked: { console.log("Đổi tên: " + panelAppContextMenu.currentAppName); panelAppContextMenu.opacity = 0 }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

                Rectangle {
                    width: parent.width - 4; height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: pUnpinMA.containsMouse ? "#22FFFFFF" : "transparent"
                    Behavior on color { ColorAnimation { duration: 80 } }
                    scale: pUnpinMA.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 60 } }
                    Row {
                        anchors.fill: parent; anchors.leftMargin: 14; spacing: 10
                        Text { text: "📌"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Bỏ ghim khỏi bảng điều khiển"; color: "white"; font.family: "Inter"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    }
                    MouseArea { id: pUnpinMA; anchors.fill: parent; hoverEnabled: true
                        onClicked: {
                            console.log("Bỏ ghim: " + panelAppContextMenu.currentAppName)
                            panelAppContextMenu.opacity = 0
                        }
                    }
                }
            }
        }

        Rectangle {
            id: panelContextMenu
            width: 220
            height: 46
            color: "#1A1A1A"
            border.color: "#33FFFFFF"
            z: 999
            visible: opacity > 0
            opacity: 0
            radius: 0

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 4
                radius: 12
                samples: 25
                color: "#80000000"
            }

            scale: opacity > 0 ? 1.0 : 0.95
            //opacity: visible ? 1 : 0
            Behavior on scale { NumberAnimation { duration: 80 } }
            Behavior on opacity { NumberAnimation { duration: 80 } }

            Rectangle {
                width: parent.width - 4
                height: 38
                anchors.centerIn: parent
                color: panelOptMA.pressed ? "#44000000" : (panelOptMA.containsMouse ? "#22FFFFFF" : "transparent")
                Behavior on color { ColorAnimation { duration: 80 } }
                scale: panelOptMA.pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 60 } }

                Text {
                    text: "Tùy chọn bảng điều khiển"
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 14
                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    id: panelOptMA
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        console.log("Tùy chọn panel")
                        panelContextMenu.opacity = 0
                    }
                }
            }
        }

        Rectangle {
            id: desktopContextMenu
            width: 200
            height: contentCol.height + 8
            color: "#1A1A1A"
            border.color: "#33FFFFFF"
            z: 999
            visible: opacity > 0
            opacity: 0
            radius: 0

            Behavior on opacity { NumberAnimation { duration: 80 } }
            Behavior on scale { NumberAnimation { duration: 80 } }
            scale: opacity > 0 ? 1.0 : 0.95
            //opacity: visible ? 1 : 0

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 4
                radius: 12
                samples: 25
                color: "#80000000"
            }

            // Sub menu tạo mới
            Rectangle {
                id: createSubmenu
                width: 200
                height: createCol.height + 8
                color: "#1A1A1A"
                border.color: "#33FFFFFF"
                z: 1000
                visible: false
                // Hiện bên phải
                x: parent.width - 1
                y: createBtn.y

                Column {
                    id: createCol
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    width: parent.width

                    // Thư mục
                    Rectangle {
                        width: parent.width - 4
                        height: 38
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: folderMA.pressed ? "#44000000" : (folderMA.containsMouse ? "#22FFFFFF" : "transparent")
                        Behavior on color { ColorAnimation { duration: 80 } }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            spacing: 10

                            Text {
                                text: "📁"
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: "Thư mục"
                                color: "white"
                                font.family: "Inter"
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: folderMA
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("Tạo thư mục mới")
                                createSubmenu.visible = false
                                desktopContextMenu.opacity = 0
                            }
                        }
                    }

                    // Tệp txt
                    Rectangle {
                        width: parent.width - 4
                        height: 38
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: txtMA.pressed ? "#44000000" : (txtMA.containsMouse ? "#22FFFFFF" : "transparent")
                        Behavior on color { ColorAnimation { duration: 80 } }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            spacing: 10

                            Text {
                                text: "📄"
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: "Tệp văn bản (.txt)"
                                color: "white"
                                font.family: "Inter"
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: txtMA
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("Tạo tệp txt mới")
                                createSubmenu.visible = false
                                desktopContextMenu.opacity = 0
                            }
                        }
                    }
                }
            }

            Column {
                id: contentCol
                anchors.top: parent.top
                anchors.topMargin: 4
                width: parent.width

                // --- Làm mới ---
                Rectangle {
                    width: parent.width - 4
                    height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: refreshMA.pressed ? "#44000000" : (refreshMA.containsMouse ? "#22FFFFFF" : "transparent")
                    Behavior on color { ColorAnimation { duration: 80 } }

                    Text {
                        text: "Làm mới"
                        color: "white"
                        font.family: "Inter"
                        font.pixelSize: 14
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        id: refreshMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            AppManager.loadAppData()
                            desktopContextMenu.opacity = 0
                        }
                    }
                }

                // --- Divider ---
                Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

                // --- Thêm mới (có submenu) ---
                Rectangle {
                    id: createBtn
                    width: parent.width - 4
                    height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: createMA.pressed ? "#44000000" : (createMA.containsMouse ? "#22FFFFFF" : "transparent")
                    Behavior on color { ColorAnimation { duration: 80 } }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 14

                        Text {
                            text: "Thêm mới"
                            color: "white"
                            font.family: "Inter"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                            width: createBtn.width - 40
                        }

                        Text {
                            text: "›"
                            color: "#80FFFFFF"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: createMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onContainsMouseChanged: {
                            createSubmenu.visible = containsMouse
                        }
                    }
                }

                // --- Divider ---
                Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

                // --- Cài đặt màn hình ---
                Rectangle {
                    width: parent.width - 4
                    height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: displayMA.pressed ? "#44000000" : (displayMA.containsMouse ? "#22FFFFFF" : "transparent")
                    Behavior on color { ColorAnimation { duration: 80 } }

                    Text {
                        text: "Cài đặt màn hình"
                        color: "white"
                        font.family: "Inter"
                        font.pixelSize: 14
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        id: displayMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            AppManager.launchApp("Cài đặt màn hình", "gnome-control-center display")
                            desktopContextMenu.opacity = 0
                        }
                    }
                }

                // --- Cá nhân hóa ---
                Rectangle {
                    width: parent.width - 4
                    height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: personalMA.pressed ? "#44000000" : (personalMA.containsMouse ? "#22FFFFFF" : "transparent")
                    Behavior on color { ColorAnimation { duration: 80 } }

                    Text {
                        text: "Cá nhân hóa"
                        color: "white"
                        font.family: "Inter"
                        font.pixelSize: 14
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        id: personalMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            desktopContextMenu.opacity = 0
                            fileManagerWin.isWallpaperMode = true
                            fileManagerWin.show()
                        }
                    }
                }

                // --- Divider ---
                Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

                // --- Ẩn biểu tượng ---
                Rectangle {
                    width: parent.width - 4
                    height: 38
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: hideMA.pressed ? "#44000000" : (hideMA.containsMouse ? "#22FFFFFF" : "transparent")
                    Behavior on color { ColorAnimation { duration: 80 } }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        spacing: 10

                        Text {
                            text: "Ẩn biểu tượng"
                            color: "white"
                            font.family: "Inter"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 60
                        }

                        Rectangle {
                            width: 28; height: 16
                            radius: 8
                            color: root.iconsHidden ? "#4CAF50" : "#555"
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on color { ColorAnimation { duration: 150 } }

                            Rectangle {
                                width: 12; height: 12
                                radius: 6
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                                x: root.iconsHidden ? 14 : 2
                                Behavior on x { NumberAnimation { duration: 150 } }
                            }
                        }
                    }

                    MouseArea {
                        id: hideMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.iconsHidden = !root.iconsHidden
                            desktopContextMenu.opacity = 0
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            z: 499
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {
                if (mouse.button === Qt.RightButton) {
                    screen.closeAllMenus()
                    var menuX = mouse.x + desktopContextMenu.width > screen.width
                                ? mouse.x - desktopContextMenu.width : mouse.x
                    var menuY = mouse.y + desktopContextMenu.height > screen.height
                                ? mouse.y - desktopContextMenu.height : mouse.y
                    desktopContextMenu.x = menuX
                    desktopContextMenu.y = menuY
                    desktopContextMenu.opacity = 1
                } else {
                    screen.closeAllMenus()
                    searchbar.resetSearch()
                    errorDialog.visible = false
                }
            }
        }

        Rectangle {
            id: errorDialog
            visible: false
            width: 350; height: 150
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            color: "#222222"
            border.color: "#444"
            radius: 0
            z: 1000

            onVisibleChanged: {
                if (visible) {
                    x = (parent.width - width) / 2
                    y = (parent.height - height) / 2
                }
            }

            Rectangle {
                id: titleBar
                width: parent.width; height: 35; color: "#333"
                radius: 0

                Text {
                    text: "Lỗi"; color: "white"; font.family: "Inter"
                    anchors.left: parent.left; anchors.leftMargin: 15; anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: 35; height: 35; anchors.right: parent.right; color: "transparent"
                    Text { text: "✕"; color: "white"; anchors.centerIn: parent; scale: xMA.pressed ? 0.9 : 1.0 }
                    Rectangle { anchors.fill: parent; color: "white"; opacity: xMA.pressed ? 0.1 : (xMA.containsMouse ? 0.2 : 0) }
                    MouseArea { id: xMA; anchors.fill: parent; hoverEnabled: true; onClicked: errorDialog.visible = false }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.rightMargin: 35
                    property point clickPos: "0,0"
                    onPressed: (mouse) => clickPos = Qt.point(mouse.x, mouse.y)
                    onPositionChanged: (mouse) => {
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        errorDialog.x += delta.x
                        errorDialog.y += delta.y
                    }
                }
            }

            Connections {
                target: AppManager
                function onLaunchFailed(name, exec) {
                    insidemenu.errorMessage = "Không tìm thấy mục: " + name
                    errorDialog.visible = true
                }
            }

            Column {
                anchors.centerIn: parent
                spacing: 25
                Text { text: insidemenu.errorMessage; color: "white"; font.family: "Inter" }

                Rectangle {
                    width: 80; height: 30; color: "#444"
                    radius: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text { text: "OK"; color: "white"; anchors.centerIn: parent; scale: okMA.pressed ? 0.9 : 1.0 }
                    Rectangle { anchors.fill: parent; color: "white"; opacity: okMA.pressed ? 0.1 : (okMA.containsMouse ? 0.2 : 0) }
                    MouseArea { id: okMA; anchors.fill: parent; hoverEnabled: true; onClicked: errorDialog.visible = false }
                }
            }
        }

        Rectangle {
            id: panel1
            z: 500
            width: 50
            height: parent.height
            color: "#7F000000"
            clip: true

            FastBlur {
                width: root.width
                height: root.height
                source: wallpaper
                radius: 50
                opacity: 0.6
                x: -panel1.x
                y: -panel1.y
                visible: true

                Rectangle { color: "black"; anchors.fill: parent }
                Rectangle { color: "black"; anchors.fill: parent; opacity: 0.3 }
            }

            Column {
                anchors.top: parent.top
                anchors.topMargin: 13
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 13
                z: 1

                Repeater {
                    model: AppManager.panelApps
                    delegate: Rectangle {
                        width: 50; height: 50
                        color: "transparent"
                        radius: 5

                        // Hàm kiểm tra
                        function appExists(exec) {
                            for (var i = 0; i < WinMgr.openWindows.length; i++) {
                                if (WinMgr.openWindows[i].exec === exec) return true
                            }
                            return false
                        }

                        function appVisible(exec) {
                            for (var i = 0; i < WinMgr.openWindows.length; i++) {
                                if (WinMgr.openWindows[i].exec === exec)
                                    return WinMgr.openWindows[i].visible
                            }
                            return false
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "black"
                            opacity: mouseArea.pressed ? 0.4 : (mouseArea.containsMouse ? 0.2 : 0)
                            radius: 5
                            Behavior on opacity { NumberAnimation { duration: 100 } }
                        }

                        Rectangle {
                            id: chamxanh
                            width: 4; height: 4
                            radius: 2
                            color: "#4CAF50"
                            anchors.left: parent.left
                            anchors.leftMargin: 1
                            anchors.verticalCenter: parent.verticalCenter
                            visible: screen.appExists(modelData.exec)
                            z: 2
                        }

                        Rectangle {
                            id: trangthai
                            anchors.fill: parent
                            color: "white"
                            opacity: screen.appVisible(modelData.exec) ? 0.2 : 0
                            radius: 5
                            z: 1
                            Behavior on opacity { NumberAnimation { duration: 50 } }
                        }

                        Image {
                            source: modelData.icon
                            anchors.centerIn: parent
                            width: 50; height: 50
                            scale: mouseArea.pressed ? 0.88 : 1.0
                            opacity: mouseArea.pressed ? 0.6 : 1.0
                            fillMode: Image.PreserveAspectFit
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "black"
                            radius: 5
                            opacity: mouseArea.pressed ? 0.15 : 0
                            Behavior on opacity { NumberAnimation { duration: 100 } }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: (mouse) => {
                                if (mouse.button === Qt.RightButton) {
                                    screen.closeAllMenus()
                                    panelAppContextMenu.currentAppName = modelData.name
                                    panelAppContextMenu.currentAppExec = modelData.exec
                                    var pos = mapToItem(screen, mouse.x, mouse.y)  // ← đổi insidemenu → screen
                                    var menuX = pos.x + panelAppContextMenu.width > screen.width
                                                ? pos.x - panelAppContextMenu.width : pos.x
                                    var menuY = pos.y + panelAppContextMenu.height > screen.height
                                                ? pos.y - panelAppContextMenu.height : pos.y
                                    panelAppContextMenu.x = menuX
                                    panelAppContextMenu.y = menuY
                                    panelAppContextMenu.opacity = 1
                                } else {
                                               if (WinMgr.isOpen(modelData.exec)) {
                                                   WinMgr.toggleApp(modelData.exec)  // ← ẩn/hiện
                                               } else if (modelData.exec.startsWith("__")) {
                                                   WinMgr.openApp(modelData.exec)     // ← mở qua WinMgr
                                               } else {
                                                   AppManager.launchApp(modelData.name, modelData.exec)  // ← app ngoài
                                               }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: menu
                width: 45
                height: 45
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 9
                color: "transparent"
                radius: 5
                clip: true

                Rectangle {
                    id: hoverBg
                    anchors.fill: parent
                    color: "black"
                    opacity: mouseAreamenu.pressed ? 0.4 : (mouseAreamenu.containsMouse ? 0.2 : 0)
                    radius: 5
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }

                Image {
                    id: menuIcon
                    source: "qrc:/menu_light.png"
                    anchors.centerIn: parent
                    width: 40; height: 40
                    fillMode: Image.PreserveAspectFit
                    scale: mouseAreamenu.pressed ? 0.88 : 1.0
                    opacity: mouseAreamenu.pressed ? 0.6 : 1.0

                    Behavior on scale { NumberAnimation { duration: 100 } }
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "black"
                    radius: 5
                    opacity: mouseAreamenu.pressed ? 0.2 : 0
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }

                MouseArea {
                    id: mouseAreamenu
                    anchors.fill: parent
                    hoverEnabled: true
                    //onClicked: console.log("Menu clicked!")
                    onClicked: {
                            if (insidemenu.opacity === 0) {
                                searchbar.resetSearch()
                                screen.closeAllMenus()
                                insidemenu.opacity = 1
                                console.log("Menu clicked!")
                                //insidemenu.y = parent.height - insidemenu.height - panel2.height - 10
                            } else {
                                insidemenu.opacity = 0
                                //insidemenu.y = parent.height - panel2.height
                            }
                        }
                }
            }

            Rectangle {
                id: borderPanel1
                width: 1; height: parent.height
                color: "#80979797"; anchors.right: parent.right
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                z: 2
                onClicked: (mouse) => {
                    screen.closeAllMenus()
                    var pos = mapToItem(screen, mouse.x, mouse.y)
                    var menuX = pos.x + panelContextMenu.width > screen.width
                                ? pos.x - panelContextMenu.width : pos.x
                    var menuY = pos.y + panelContextMenu.height > screen.height
                                ? pos.y - panelContextMenu.height : pos.y
                    panelContextMenu.x = menuX
                    panelContextMenu.y = menuY
                    panelContextMenu.opacity = 1
                }
            }
        }

        Rectangle {
            z: 600
            id: insidemenu
            anchors.left: panel1.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: panel2.top
            color: "#7F000000"  //Qt.rgba(dominantColor.r, dominantColor.g, dominantColor.b, 0.8)
            clip: true
            visible: opacity > 0
            opacity: 0

            scale: opacity === 1 ? 1.0 : 0.9

            property bool isPowerMenuOpen: false
            property string currentTab: "apps"
            property string errorMessage: ""

            Behavior on opacity { NumberAnimation { duration: 50 } }
            Behavior on y { NumberAnimation { duration: 50; easing.type: Easing.OutCubic } }

            onOpacityChanged: {
                if (opacity === 1) {
                    currentTab = "apps"
                }
                if (opacity === 0) {
                    isPowerMenuOpen = false
                }
            }

            Rectangle {
                id: appContextOverlay
                anchors.fill: parent
                color: "transparent"
                z: 1000
                visible: appContextMenu.opacity > 0

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        appContextMenu.opacity = 0
                    }
                }
            }

            Rectangle {
                id: appContextMenu
                width: 200
                height: appContextCol.height + 8
                color: "#1A1A1A"
                border.color: "#33FFFFFF"
                z: 1001
                visible: opacity > 0
                opacity: 0
                scale: opacity > 0 ? 1.0 : 0.95
                radius: 0

                property string currentAppName: ""
                property string currentAppExec: ""
                property string currentAppIcon: ""

                Behavior on scale { NumberAnimation { duration: 80 } }
                Behavior on opacity { NumberAnimation { duration: 80 } }

                Column {
                    id: appContextCol
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    width: parent.width

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 4
                        radius: 12
                        samples: 25
                        color: "#80000000"
                    }

                    // --- Đường dẫn ---
                    Rectangle {
                        width: parent.width - 4
                        height: 38
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: pathMA.containsMouse ? "#22FFFFFF" : "transparent"
                        Behavior on color { ColorAnimation { duration: 80 } }
                        scale: pathMA.pressed ? 0.95 : 1.0
                        Behavior on scale { NumberAnimation { duration: 60 } }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            spacing: 10
                            Text { text: "📂"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                            Text {
                                text: "Đường dẫn"
                                color: "white"; font.family: "Inter"; font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: pathMA
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("Đường dẫn: " + appContextMenu.currentAppExec)
                                appContextMenu.opacity = 0
                            }
                        }
                    }

                    // --- Divider ---
                    Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

                    // --- Gỡ cài đặt ---
                    Rectangle {
                        width: parent.width - 4
                        height: 38
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: uninstallMA.containsMouse ? "#22FF4444" : "transparent"
                        Behavior on color { ColorAnimation { duration: 80 } }
                        scale: uninstallMA.pressed ? 0.95 : 1.0
                        Behavior on scale { NumberAnimation { duration: 60 } }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            spacing: 10
                            Text { text: "🗑️"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                            Text {
                                text: "Gỡ cài đặt"
                                color: uninstallMA.containsMouse ? "#FF6B6B" : "white"
                                font.family: "Inter"; font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on color { ColorAnimation { duration: 80 } }
                            }
                        }

                        MouseArea {
                            id: uninstallMA
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("Gỡ cài đặt: " + appContextMenu.currentAppName)
                                appContextMenu.opacity = 0
                            }
                        }
                    }

                    Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

                    Rectangle {
                        width: parent.width - 4
                        height: 38
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: iconMA2.containsMouse ? "#22FFFFFF" : "transparent"
                        Behavior on color { ColorAnimation { duration: 80 } }
                        scale: iconMA2.pressed ? 0.95 : 1.0
                        Behavior on scale { NumberAnimation { duration: 60 } }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            spacing: 10
                            Text { text: "🖼️"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                            Text {
                                text: "Đổi biểu tượng"
                                color: "white"; font.family: "Inter"; font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: iconMA2
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("Đổi icon: " + appContextMenu.currentAppName)
                                appContextMenu.opacity = 0
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width - 4
                        height: 38
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: renameMA.containsMouse ? "#22FFFFFF" : "transparent"
                        Behavior on color { ColorAnimation { duration: 80 } }
                        scale: renameMA.pressed ? 0.95 : 1.0
                        Behavior on scale { NumberAnimation { duration: 60 } }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            spacing: 10
                            Text { text: "✏️"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                            Text {
                                text: "Đổi tên"
                                color: "white"; font.family: "Inter"; font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: renameMA
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("Đổi tên: " + appContextMenu.currentAppName)
                                appContextMenu.opacity = 0
                            }
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    screen.closeAllMenus()
                    if (mouse.button === Qt.LeftButton) {
                        insidemenu.opacity = 0
                        searchbar.resetSearch()
                    }
                }
            }

            FastBlur {
                id: blurEffect
                width: screen.width
                height: screen.height
                source: wallpaper
                radius: 50
                x: -insidemenu.x
                y: -insidemenu.y
                visible: true

                //hôm qua làm tới đây nhớ tới hiệu ứng xuất hiện bay tới

                Rectangle {
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.75
                }
            }

            Component {
                id: appDelegate

                Item {
                    width: 109
                    height: 117

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: mouseAreaInternal.containsMouse ? 0.1 : 0
                        radius: 0
                        Behavior on opacity { NumberAnimation { duration: 100 } }
                    }

                    Text {
                        id: appLabel
                        text: modelData.name
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 9
                        anchors.horizontalCenter: parent.horizontalCenter

                        color: "white"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }

                    Image {
                        id: appIcon
                        source: modelData.icon
                        width: 88
                        height: 88
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: appLabel.top

                        fillMode: Image.PreserveAspectFit
                        scale: mouseAreaInternal.pressed ? 0.9 : 1.0
                        opacity: mouseAreaInternal.pressed ? 0.7 : 1.0

                        Behavior on scale { NumberAnimation { duration: 50 } }
                    }

                    MouseArea {
                        id: mouseAreaInternal
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                                       if (mouse.button === Qt.RightButton) {
                                           screen.closeAllMenus()
                                           appContextMenu.currentAppName = modelData.name
                                           appContextMenu.currentAppExec = modelData.exec
                                           appContextMenu.currentAppIcon = modelData.icon
                                           var pos = mapToItem(insidemenu, mouse.x, mouse.y)
                                           appContextMenu.x = pos.x
                                           appContextMenu.y = pos.y
                                           appContextMenu.opacity = 1
                            } else {
                                AppManager.launchApp(modelData.name, modelData.exec)
                                insidemenu.opacity = 0
                            }
                        }
                    }
                }
            }

            GridView {
                id: appGrid
                anchors.top: parent.top
                anchors.topMargin: 136
                anchors.bottom: parent.bottom
                x: insidemenu.currentTab === "apps" ? 49 : -parent.width
                width: parent.width - 98
                cellWidth: 120
                cellHeight: 130
                model: AppManager.menuApps
                delegate: appDelegate
                clip: true

                Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            }

            Item {
                id: widgetGrid
                anchors.top: parent.top
                anchors.topMargin: 136
                anchors.bottom: parent.bottom
                width: parent.width - 98
                opacity: insidemenu.currentTab === "widgets" ? 1 : 0
                x: insidemenu.currentTab === "widgets" ? 49 : parent.width
                Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "Widget coming soon..."
                    color: "#80FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 20
                }
            }

            Text {
                anchors.top: parent.top
                anchors.topMargin: 28
                anchors.left: parent.left
                anchors.leftMargin: 38
                text: "Apps"
                color: "white"
                font.family: "Inter"
                font.weight: Font.Capitalize
                font.pixelSize: 40
            }

            Rectangle {
                id: searchbar
                z: 700
                height: 37
                width: 717
                anchors.top: parent.top
                anchors.topMargin: 38
                anchors.horizontalCenter: parent.horizontalCenter
                color: searchInput.activeFocus ? "#85000000" : "#73000000"
                border.color: searchInput.activeFocus ? "#88FFFFFF" : "#33FFFFFF"
                border.width: 1
                radius: 0

                property bool hasResults: resultList.count > 0
                property int highlightedIndex: 0

                function processSearch() {
                    if (searchInput.text === "") {
                        insidemenu.errorMessage = "Vui lòng nhập từ khóa tìm kiếm"
                        errorDialog.visible = true
                    } else if (!hasResults) {
                        insidemenu.errorMessage = "Không tìm thấy mục: " + searchInput.text
                        errorDialog.visible = true
                    } else {
                        var first = AppManager.searchApps(searchInput.text)[0]
                        AppManager.launchApp(first.name, first.exec)
                        searchbar.resetSearch()
                        insidemenu.opacity = 0
                    }
                }

                function resetSearch() {
                    searchInput.text = ""
                    searchInput.focus = false
                }

                states: [
                    State {
                        name: "active"
                        when: searchInput.activeFocus || searchInput.text !== ""
                        PropertyChanges { target: searchIconItem; x: searchbar.width - searchIconItem.width - 14 }
                        PropertyChanges { target: searchInput; anchors.leftMargin: 14 }
                    },
                    State {
                        name: "inactive"
                        when: !searchInput.activeFocus && searchInput.text === ""
                        PropertyChanges { target: searchIconItem; x: 14 }
                        PropertyChanges { target: searchInput; anchors.leftMargin: 43 }
                    }
                ]

                transitions: Transition {
                    NumberAnimation { properties: "x,anchors.leftMargin"; duration: 100; easing.type: Easing.InOutQuad }
                }

                Item {
                    id: searchIconItem
                    width: 19; height: 19
                    anchors.verticalCenter: parent.verticalCenter
                    z: 10

                    Image {
                        id: searchIcon
                        source: "qrc:/search_light.png"
                        anchors.fill: parent
                        scale: iconMA.pressed ? 0.9 : 1.0
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: iconMA.pressed ? 0.1 : (iconMA.containsMouse ? 0.2 : 0)
                        visible: searchInput.activeFocus || searchInput.text !== ""
                    }

                    MouseArea {
                        id: iconMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: searchbar.processSearch()
                    }
                }

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.rightMargin: 43
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 16
                    clip: true

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) searchbar.processSearch()
                        if (event.key === Qt.Key_Escape) searchbar.resetSearch()
                    }

                    Text {
                        text: "Search"
                        visible: !searchInput.text && !searchInput.activeFocus
                        color: "#99FFFFFF"
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 16
                        font.family: "Inter"
                    }
                }

                Rectangle {
                    z: 1000
                    id: resultPanel
                    anchors.top: parent.bottom
                    anchors.topMargin: 0
                    width: parent.width
                    height: (searchInput.text !== "") ? (searchbar.hasResults ? Math.min(resultList.contentHeight, 300) : 60) : 0
                    color: "#1A1A1A"
                    radius: 0
                    clip: true
                    visible: height > 0

                    ListView {
                        id: resultList
                        anchors.fill: parent
                        model: searchInput.text !== "" ? AppManager.searchApps(searchInput.text) : null
                        delegate: Item {
                            width: parent.width; height: 45
                            Rectangle {
                                anchors.fill: parent
                                color: "white"
                                opacity: delegateMA.pressed ? 0.15
                                               : (index === 0 ? 0.15
                                               : (delegateMA.containsMouse ? 0.1 : 0))
                                Behavior on opacity { NumberAnimation { duration: 80 } }
                            }
                            Row {
                                anchors.fill: parent; anchors.leftMargin: 10; spacing: 15
                                Image { source: modelData.icon; width: 24; height: 24; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: modelData.name; color: "white"; anchors.verticalCenter: parent.verticalCenter; font.family: "Inter" }
                            }
                            MouseArea {
                                id: delegateMA
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    AppManager.launchApp(modelData.name, modelData.exec)
                                    searchbar.resetSearch()
                                    insidemenu.opacity = 0
                                }
                            }
                        }
                    }

                    Text {
                        visible: !searchbar.hasResults && searchInput.text !== ""
                        text: "Không tìm thấy tệp phù hợp"
                        color: "#CCFFFFFF"
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                        font.family: "Inter"
                    }
                }
            }

            Item {
                id: powerBtn
                width: 36; height: 36
                anchors.right: parent.right
                anchors.rightMargin: 43
                anchors.top: parent.top
                anchors.topMargin: 38

                Rectangle {
                    id: powerHoverBg
                    anchors.fill: parent
                    color: "white"
                    opacity: powerMouse.containsMouse ? 0.12 : 0
                    radius: width / 2
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }

                Image {
                    source: "qrc:/power_light.png"
                    width: 20; height: 20
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: powerMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: insidemenu.isPowerMenuOpen = !insidemenu.isPowerMenuOpen
                }
            }

            Item {
                id: editBtn
                width: 36; height: 36
                anchors.right: parent.right
                anchors.rightMargin: 91
                anchors.top: parent.top
                anchors.topMargin: 38

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: editMouse.containsMouse ? 0.12 : 0
                    radius: width / 2
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }

                Image {
                    source: "qrc:/edit_light.png"
                    width: 20; height: 20
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: editMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("Edit clicked")
                }
            }

            Item {
                id: settingBtn
                width: 36; height: 36
                anchors.right: parent.right
                anchors.rightMargin: 139
                anchors.top: parent.top
                anchors.topMargin: 38

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: settingMouse.containsMouse ? 0.12 : 0
                    radius: width / 2
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                }

                Image {
                    source: "qrc:/settings_light.png"
                    width: 20; height: 20
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: settingMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: console.log("Settings clicked")
                }
            }

            Rectangle {
                z: 666
                id: switchappswidgets
                width: 163
                height: 35
                anchors.top: parent.top
                anchors.topMargin: 92
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"

                Rectangle {
                    id: apps
                    width: 71
                    height: 35
                    anchors.left: parent.left
                    color: insidemenu.currentTab === "apps" ? "#21FFFFFF" : "transparent"
                    Behavior on color { ColorAnimation { duration: 50 } }
                    scale: appsMA.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 60 } }

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: appsMA.containsMouse && insidemenu.currentTab !== "apps" ? 0.1 : 0
                        Behavior on opacity { NumberAnimation { duration: 50 } }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: appsMA.pressed ? 0.1 : 0
                        Behavior on opacity { NumberAnimation { duration: 60 } }
                    }

                    Text {
                        text: "Apps"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        font.family: "Inter"
                        color: insidemenu.currentTab === "apps" ? "#CCFFFFFF" : "#80FFFFFF"
                        anchors.centerIn: parent
                        Behavior on color { ColorAnimation { duration: 50 } }
                    }

                    MouseArea {
                        id: appsMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: insidemenu.currentTab = "apps"
                    }
                }

                Rectangle {
                    id: widgets
                    width: 95
                    height: 35
                    anchors.right: parent.right
                    color: insidemenu.currentTab === "widgets" ? "#21FFFFFF" : "transparent"
                    Behavior on color { ColorAnimation { duration: 50 } }
                    scale: widgetsMA.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 60 } }

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: widgetsMA.containsMouse && insidemenu.currentTab !== "widgets" ? 0.1 : 0
                        Behavior on opacity { NumberAnimation { duration: 50 } }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: widgetsMA.pressed ? 0.1 : 0
                        Behavior on opacity { NumberAnimation { duration: 60 } }
                    }

                    Text {
                        text: "Widgets"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        font.family: "Inter"
                        color: insidemenu.currentTab === "widgets" ? "#CCFFFFFF" : "#80FFFFFF"
                        anchors.centerIn: parent
                        Behavior on color { ColorAnimation { duration: 50 } }
                    }

                    MouseArea {
                        id: widgetsMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: insidemenu.currentTab = "widgets"
                    }
                }
            }

            Rectangle {
                z: 600
                id: optionpower
                width: 158
                height: 132
                color: "black"
                border.color: "#33FFFFFF"
                anchors.right: parent.right
                anchors.rightMargin: 9

                opacity: insidemenu.isPowerMenuOpen ? 1 : 0
                y: insidemenu.isPowerMenuOpen ? 75 : 65
                visible: opacity > 0

                Behavior on opacity { NumberAnimation { duration: 50 } }
                Behavior on y {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }

                //nút shutdown
                Rectangle {
                    id: shutdown
                    width: parent.width - 4
                    height: 44
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: shutdownMouse.pressed ? "#44000000" : (shutdownMouse.containsMouse ? "#22FFFFFF" : "transparent")
                    scale: shutdownMouse.pressed ? 0.9 : 1.0
                    clip: true

                    Behavior on scale {
                        NumberAnimation { duration: 60; easing.type: Easing.OutQuad }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: shutdownMouse.pressed ? 0.2 : 0
                        radius: 6
                        visible: opacity > 0
                    }

                    Image {
                        id: shutdownIcon
                        source: "qrc:/power_off_light.png"
                        width: 20; height: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Shutdown"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: "white"
                        anchors.left: shutdownIcon.right
                        anchors.leftMargin: 9
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        id: shutdownMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            console.log("System Shutdown...")
                            Qt.quit()
                        }
                    }
                }

                //nút sleep
                Rectangle {
                    id: sleep
                    width: parent.width - 4
                    height: 44
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: sleepMouse.pressed ? "#44000000" : (sleepMouse.containsMouse ? "#22FFFFFF" : "transparent")
                    scale: sleepMouse.pressed ? 0.9 : 1.0
                    clip: true

                    Behavior on scale {
                        NumberAnimation { duration: 60; easing.type: Easing.OutQuad }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: sleepMouse.pressed ? 0.2 : 0
                        radius: 6
                        visible: opacity > 0
                    }

                    Image {
                        id: sleepIcon
                        source: "qrc:/sleep_light.png"
                        width: 20; height: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Sleep"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: "white"
                        anchors.left: sleepIcon.right
                        anchors.leftMargin: 9
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        id: sleepMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: console.log("System Sleep...")
                    }
                }

                //mút restart
                Rectangle {
                    id: restart
                    width: parent.width - 4
                    height: 44
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: restartMouse.pressed ? "#44000000" : (restartMouse.containsMouse ? "#22FFFFFF" : "transparent")
                    scale: restartMouse.pressed ? 0.9 : 1.0
                    clip: true

                    Behavior on scale {
                        NumberAnimation { duration: 60; easing.type: Easing.OutQuad }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: restartMouse.pressed ? 0.2 : 0
                        radius: 6
                        visible: opacity > 0
                    }

                    Image {
                        id: restartIcon
                        source: "qrc:/restart_light.png"
                        width: 20; height: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Restart"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: "white"
                        anchors.left: restartIcon.right
                        anchors.leftMargin: 9
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        id: restartMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: console.log("System Restarting...")
                    }
                }
            }
        }

        Rectangle {
            id: panel2
            z: 499
            height: 27
            color: "transparent"
            anchors.bottom: parent.bottom
            anchors.left: panel1.right
            anchors.right: parent.right
            clip: true

            FastBlur {
                id: blurBottom
                width: root.width
                height: root.height
                source: wallpaper
                radius: 70
                opacity: 1.0
                x: -panel2.x
                y: -panel2.y
                visible: true
            }

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.8
            }

            Rectangle {
                id: boxdaytime
                height: parent.height
                width: timeDisplay.width + 20
                color: "transparent"
                anchors.right: parent.right
                anchors.rightMargin: 10

                Text {
                    id: timeDisplay
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 12
                    font.family: "Inter"
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: timeDisplay.text = Qt.formatDateTime(new Date(), "dd/MM/yyyy | hh:mm")
                }

                Component.onCompleted: timeDisplay.text = Qt.formatDateTime(new Date(), "dd/MM/yyyy | hh:mm")
            }

            Rectangle {
                id: inwindow
                width: 11
                height: parent.height
                color: "#80000000"
                anchors.right: parent.right

                Rectangle {
                    width: 1
                    height: parent.height
                    color: "#80979797"
                    anchors.left: parent.left }
            }

            Rectangle {
                id: borderPanel2
                width: parent.width
                height: 1
                color: "#80979797"
                anchors.top: parent.top
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                z: 2
                onClicked: (mouse) => {
                    screen.closeAllMenus()
                    var pos = mapToItem(screen, mouse.x, mouse.y)
                    var menuX = pos.x + panelContextMenu.width > screen.width
                                ? pos.x - panelContextMenu.width : pos.x
                    var menuY = pos.y + panelContextMenu.height > screen.height
                                ? pos.y - panelContextMenu.height : pos.y
                    panelContextMenu.x = menuX
                    panelContextMenu.y = menuY
                    panelContextMenu.opacity = 1
                }
            }
        }
    }
}