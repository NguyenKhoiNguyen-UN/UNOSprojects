import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects

Window {
    id: fileMgrWindow
    width: 900
    height: 600
    title: "File Manager — Unde"
    color: "#111111"
    flags: Qt.Window | Qt.FramelessWindowHint

    signal wallpaperSelected(string path)  // ← thêm
    signal appLaunchRequested(string name, string exec)  // ← thêm

    property bool isGridView: false
    property bool isWallpaperMode: false

    opacity: 0
    onVisibleChanged: {
        if (visible) {
            appearAnim.start()
        }
    }

    NumberAnimation {
        id: appearAnim
        target: fileMgrWindow
        property: "opacity"
        from: 0; to: 1
        duration: 150
        easing.type: Easing.OutCubic
    }

    // --- Kéo cửa sổ ---
    MouseArea {
        id: dragArea
        anchors.fill: titleBarFM
        property point clickPos: "0,0"
        onPressed: (mouse) => clickPos = Qt.point(mouse.x, mouse.y)
        onPositionChanged: (mouse) => {
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            fileMgrWindow.x += delta.x
            fileMgrWindow.y += delta.y
        }
    }

    // --- Thanh tiêu đề ---
    Rectangle {
        id: titleBarFM
        width: parent.width
        height: 38
        color: "#1A1A1A"
        z: 10

        Text {
            text: "📁  " + FileMgr.currentPath
            color: "white"
            font.family: "Inter"
            font.pixelSize: 13
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideMiddle
            width: parent.width - 120
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            // Switch view
            Rectangle {
                width: 38; height: 38
                color: viewMA.containsMouse ? "#33FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Text {
                    text: fileMgrWindow.isGridView ? "☰" : "⊞"
                    color: "white"; font.pixelSize: 16
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: viewMA
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: fileMgrWindow.isGridView = !fileMgrWindow.isGridView
                }
            }

            // Đóng
            Rectangle {
                width: 38; height: 38
                color: closeMA.containsMouse ? "#CC3333" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Text { text: "✕"; color: "white"; font.pixelSize: 14; anchors.centerIn: parent }
                MouseArea {
                    id: closeMA
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: fileMgrWindow.close()
                }
            }
        }

        Rectangle {
            width: parent.width; height: 1
            color: "#33FFFFFF"
            anchors.bottom: parent.bottom
        }
    }

    // --- Sidebar ổ đĩa ---
    Rectangle {
        id: sidebar
        width: 180
        anchors.top: titleBarFM.bottom
        anchors.bottom: statusBar.top
        anchors.left: parent.left
        color: "#161616"

        Rectangle {
            width: parent.width; height: 1
            color: "#33FFFFFF"
            anchors.right: parent.right
        }

        Column {
            anchors.top: parent.top
            anchors.topMargin: 8
            width: parent.width

            // Home
            Rectangle {
                width: parent.width - 8; height: 34
                anchors.horizontalCenter: parent.horizontalCenter
                color: homeMA.containsMouse ? "#22FFFFFF" : "transparent"
                radius: 4
                Behavior on color { ColorAnimation { duration: 80 } }
                Row {
                    anchors.fill: parent; anchors.leftMargin: 12; spacing: 8
                    Text { text: "🏠"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Home"; color: "white"; font.family: "Inter"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                }
                MouseArea {
                    id: homeMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: FileMgr.navigateTo(Qt.platform.os === "windows"
                               ? "C:/Users/" : "/home")
                }
            }

            // Desktop
            Rectangle {
                width: parent.width - 8; height: 34
                anchors.horizontalCenter: parent.horizontalCenter
                color: desktopMA.containsMouse ? "#22FFFFFF" : "transparent"
                radius: 4
                Behavior on color { ColorAnimation { duration: 80 } }
                Row {
                    anchors.fill: parent; anchors.leftMargin: 12; spacing: 8
                    Text { text: "🖥️"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Desktop"; color: "white"; font.family: "Inter"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                }
                MouseArea {
                    id: desktopMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: FileMgr.navigateTo(Qt.platform.os === "windows"
                               ? "C:/Users/Public/Desktop" : "/home/user/Desktop")
                }
            }

            // Divider
            Rectangle { width: parent.width - 16; height: 1; color: "#33FFFFFF"; anchors.horizontalCenter: parent.horizontalCenter; anchors.topMargin: 4 }

            // Ổ đĩa
            Text {
                text: "Ổ đĩa"
                color: "#80FFFFFF"
                font.family: "Inter"
                font.pixelSize: 11
                anchors.left: parent.left
                anchors.leftMargin: 14
                topPadding: 8
                bottomPadding: 4
            }

            Repeater {
                model: FileMgr.getDrives()
                delegate: Rectangle {
                    width: parent.width - 8; height: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: driveMA.containsMouse ? "#22FFFFFF" : "transparent"
                    radius: 4
                    Behavior on color { ColorAnimation { duration: 80 } }

                    Column {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            text: "💾 " + modelData.name
                            color: "white"; font.family: "Inter"; font.pixelSize: 13
                        }
                        Text {
                            text: modelData.free + " còn trống"
                            color: "#80FFFFFF"; font.family: "Inter"; font.pixelSize: 10
                        }
                    }

                    MouseArea {
                        id: driveMA; anchors.fill: parent; hoverEnabled: true
                        onClicked: FileMgr.navigateTo(modelData.path)
                    }
                }
            }
        }
    }

    // --- Toolbar ---
    Rectangle {
        id: toolbar
        height: 40
        anchors.top: titleBarFM.bottom
        anchors.left: sidebar.right
        anchors.right: parent.right
        color: "#1A1A1A"

        Row {
            anchors.fill: parent
            anchors.leftMargin: 8
            spacing: 4

            // Back
            Rectangle {
                width: 32; height: 32; radius: 4
                anchors.verticalCenter: parent.verticalCenter
                color: backMA.containsMouse ? "#33FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Text { text: "←"; color: "white"; font.pixelSize: 16; anchors.centerIn: parent }
                MouseArea { id: backMA; anchors.fill: parent; hoverEnabled: true; onClicked: FileMgr.navigateUp() }
            }

            // Refresh
            Rectangle {
                width: 32; height: 32; radius: 4
                anchors.verticalCenter: parent.verticalCenter
                color: refreshMA2.containsMouse ? "#33FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Text { text: "↺"; color: "white"; font.pixelSize: 16; anchors.centerIn: parent }
                MouseArea { id: refreshMA2; anchors.fill: parent; hoverEnabled: true; onClicked: FileMgr.refresh() }
            }

            // Separator
            Rectangle { width: 1; height: 20; color: "#33FFFFFF"; anchors.verticalCenter: parent.verticalCenter }

            // Tạo thư mục
            Rectangle {
                width: 32; height: 32; radius: 4
                anchors.verticalCenter: parent.verticalCenter
                color: mkdirMA.containsMouse ? "#33FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Text { text: "📁"; font.pixelSize: 16; anchors.centerIn: parent }
                MouseArea {
                    id: mkdirMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: {
                        newFolderDialog.visible = true
                        newFolderInput.text = "Thư mục mới"
                        newFolderInput.selectAll()
                        newFolderInput.forceActiveFocus()
                    }
                }
            }

            // Tạo file txt
            Rectangle {
                width: 32; height: 32; radius: 4
                anchors.verticalCenter: parent.verticalCenter
                color: mkfileMA.containsMouse ? "#33FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Text { text: "📄"; font.pixelSize: 16; anchors.centerIn: parent }
                MouseArea {
                    id: mkfileMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: {
                        newFileDialog.visible = true
                        newFileInput.text = "Tệp mới.txt"
                        newFileInput.selectAll()
                        newFileInput.forceActiveFocus()
                    }
                }
            }

            // Separator
            Rectangle { width: 1; height: 20; color: "#33FFFFFF"; anchors.verticalCenter: parent.verticalCenter }

            // Paste
            Rectangle {
                width: 32; height: 32; radius: 4
                anchors.verticalCenter: parent.verticalCenter
                color: pasteMA.containsMouse ? "#33FFFFFF" : "transparent"
                opacity: FileMgr.hasClipboard() ? 1 : 0.3
                Behavior on color { ColorAnimation { duration: 80 } }
                Text { text: "📋"; font.pixelSize: 16; anchors.centerIn: parent }
                MouseArea {
                    id: pasteMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: FileMgr.pasteFromClipboard(FileMgr.currentPath)
                }
            }
        }

        Rectangle { width: parent.width; height: 1; color: "#33FFFFFF"; anchors.bottom: parent.bottom }
    }

    // --- File area ---
    Rectangle {
        id: fileArea
        anchors.top: toolbar.bottom
        anchors.left: sidebar.right
        anchors.right: parent.right
        anchors.bottom: statusBar.top
        color: "#111111"
        clip: true

        // Context menu cho file
        property string selectedPath: ""
        property string selectedName: ""
        property bool selectedIsDir: false

        // === LIST VIEW ===
        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 4
            model: FileMgr.files
            visible: !fileMgrWindow.isGridView
            clip: true

            delegate: Rectangle {
                width: listView.width
                height: 36
                color: listMA.pressed ? "#33FFFFFF" : (listMA.containsMouse ? "#1AFFFFFF" : "transparent")
                Behavior on color { ColorAnimation { duration: 80 } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    spacing: 10

                    Text {
                        text: modelData.isDir ? "📁"
                            : modelData.type === "image" ? "🖼️"
                            : modelData.type === "video" ? "🎬"
                            : modelData.type === "audio" ? "🎵"
                            : modelData.type === "text"  ? "📄"
                            : modelData.type === "app"   ? "⚙️"
                            : "📎"
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                        width: 24
                    }

                    Text {
                        text: modelData.name
                        color: "white"
                        font.family: "Inter"
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                        width: listView.width - 200
                        elide: Text.ElideRight
                    }

                    Text {
                        text: modelData.size
                        color: "#80FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 80
                    }

                    Text {
                        text: modelData.modified
                        color: "#80FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: listMA
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onDoubleClicked: {
                        if (modelData.isDir) {
                            FileMgr.navigateTo(modelData.path)
                        } else if (fileMgrWindow.isWallpaperMode && modelData.type === "image") {
                            AppManager.setWallpaper("file:///" + modelData.path)
                            fileMgrWindow.isWallpaperMode = false
                            fileMgrWindow.close()
                        }
                    }
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            fileArea.selectedPath = modelData.path
                            fileArea.selectedName = modelData.name
                            fileArea.selectedIsDir = modelData.isDir
                            var pos = mapToItem(fileMgrWindow.contentItem, mouse.x, mouse.y)
                            fileContextMenu.x = pos.x
                            fileContextMenu.y = pos.y
                            fileContextMenu.opacity = 1
                        }
                    }
                }
            }
        }

        // === GRID VIEW ===
        GridView {
            id: gridView
            anchors.fill: parent
            anchors.margins: 8
            model: FileMgr.files
            visible: fileMgrWindow.isGridView
            cellWidth: 100
            cellHeight: 110
            clip: true

            delegate: Item {
                width: 100; height: 110

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    color: gridMA.pressed ? "#33FFFFFF" : (gridMA.containsMouse ? "#1AFFFFFF" : "transparent")
                    radius: 4
                    Behavior on color { ColorAnimation { duration: 80 } }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: modelData.isDir ? "📁"
                            : modelData.type === "image" ? "🖼️"
                            : modelData.type === "video" ? "🎬"
                            : modelData.type === "audio" ? "🎵"
                            : modelData.type === "text"  ? "📄"
                            : modelData.type === "app"   ? "⚙️"
                            : "📎"
                        font.pixelSize: 36
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: modelData.name
                        color: "white"
                        font.family: "Inter"
                        font.pixelSize: 11
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 90
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 2
                    }
                }

                MouseArea {
                    id: gridMA
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onDoubleClicked: {
                        if (modelData.isDir) {
                            FileMgr.navigateTo(modelData.path)
                        } else if (fileMgrWindow.isWallpaperMode && modelData.type === "image") {
                            AppManager.setWallpaper("file:///" + modelData.path)
                            fileMgrWindow.isWallpaperMode = false
                            fileMgrWindow.close()
                        }
                    }
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            fileArea.selectedPath = modelData.path
                            fileArea.selectedName = modelData.name
                            fileArea.selectedIsDir = modelData.isDir
                            var pos = mapToItem(fileMgrWindow.contentItem, mouse.x, mouse.y)
                            fileContextMenu.x = pos.x
                            fileContextMenu.y = pos.y
                            fileContextMenu.opacity = 1
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: fileContextMenu
        width: 180
        height: fileContextCol.height + 8
        color: "#1A1A1A"
        border.color: "#33FFFFFF"
        z: 999
        visible: opacity > 0
        opacity: 0
        radius: 0

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0; verticalOffset: 4
            radius: 12; samples: 25; color: "#80000000"
        }

        Behavior on opacity { NumberAnimation { duration: 80 } }
        scale: opacity > 0 ? 1.0 : 0.95
        Behavior on scale { NumberAnimation { duration: 80 } }

        Column {
            id: fileContextCol
            anchors.top: parent.top
            anchors.topMargin: 4
            width: parent.width

            Rectangle {
                width: parent.width - 4; height: 36
                anchors.horizontalCenter: parent.horizontalCenter
                color: fcOpenMA.containsMouse ? "#22FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Row { anchors.fill: parent; anchors.leftMargin: 12; spacing: 8
                    Text { text: "▶️"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Mở"; color: "white"; font.family: "Inter"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                }
                MouseArea { id: fcOpenMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: {
                        if (fileArea.selectedIsDir)
                            FileMgr.navigateTo(fileArea.selectedPath)
                        else
                            AppManager.launchApp(fileArea.selectedName, fileArea.selectedPath)
                        fileContextMenu.opacity = 0
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

            Rectangle {
                width: parent.width - 4; height: 36
                anchors.horizontalCenter: parent.horizontalCenter
                color: fcCopyMA.containsMouse ? "#22FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Row { anchors.fill: parent; anchors.leftMargin: 12; spacing: 8
                    Text { text: "📋"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Sao chép"; color: "white"; font.family: "Inter"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                }
                MouseArea { id: fcCopyMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: { FileMgr.copyToClipboard(fileArea.selectedPath); fileContextMenu.opacity = 0 }
                }
            }

            Rectangle {
                width: parent.width - 4; height: 36
                anchors.horizontalCenter: parent.horizontalCenter
                color: fcCutMA.containsMouse ? "#22FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Row { anchors.fill: parent; anchors.leftMargin: 12; spacing: 8
                    Text { text: "✂️"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Cắt"; color: "white"; font.family: "Inter"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                }
                MouseArea { id: fcCutMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: { FileMgr.cutToClipboard(fileArea.selectedPath); fileContextMenu.opacity = 0 }
                }
            }

            Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

            Rectangle {
                width: parent.width - 4; height: 36
                anchors.horizontalCenter: parent.horizontalCenter
                color: fcRenameMA.containsMouse ? "#22FFFFFF" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Row { anchors.fill: parent; anchors.leftMargin: 12; spacing: 8
                    Text { text: "✏️"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Đổi tên"; color: "white"; font.family: "Inter"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                }
                MouseArea { id: fcRenameMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: {
                        renameDialog.visible = true
                        renameInput.text = fileArea.selectedName
                        renameInput.selectAll()
                        renameInput.forceActiveFocus()
                        fileContextMenu.opacity = 0
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: "#33FFFFFF" }

            Rectangle {
                width: parent.width - 4; height: 36
                anchors.horizontalCenter: parent.horizontalCenter
                color: fcDeleteMA.containsMouse ? "#22FF3333" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }
                Row { anchors.fill: parent; anchors.leftMargin: 12; spacing: 8
                    Text { text: "🗑️"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Xóa"; color: fcDeleteMA.containsMouse ? "#FF6B6B" : "white"
                        font.family: "Inter"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: 80 } }
                    }
                }
                MouseArea { id: fcDeleteMA; anchors.fill: parent; hoverEnabled: true
                    onClicked: {
                        FileMgr.deleteFile(fileArea.selectedPath)
                        fileContextMenu.opacity = 0
                    }
                }
            }
        }
    }

    Rectangle {
        id: renameDialog
        visible: false
        width: 300; height: 110
        anchors.centerIn: parent
        color: "#222222"
        border.color: "#444"
        z: 1000

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text { text: "Đổi tên"; color: "white"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold }

            Rectangle {
                width: parent.width; height: 32
                color: "#333"; border.color: "#555"
                TextInput {
                    id: renameInput
                    anchors.fill: parent
                    anchors.margins: 6
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 13
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Return) {
                            FileMgr.renameFile(fileArea.selectedPath, renameInput.text)
                            renameDialog.visible = false
                        }
                        if (event.key === Qt.Key_Escape) renameDialog.visible = false
                    }
                }
            }

            Row {
                spacing: 8; anchors.right: parent.right
                Rectangle {
                    width: 60; height: 28; color: "#444"; radius: 2
                    Text { text: "Hủy"; color: "white"; anchors.centerIn: parent; font.family: "Inter"; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent; onClicked: renameDialog.visible = false }
                }
                Rectangle {
                    width: 60; height: 28; color: "#2196F3"; radius: 2
                    Text { text: "OK"; color: "white"; anchors.centerIn: parent; font.family: "Inter"; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent
                        onClicked: {
                            FileMgr.renameFile(fileArea.selectedPath, renameInput.text)
                            renameDialog.visible = false
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: newFolderDialog
        visible: false
        width: 300; height: 110
        anchors.centerIn: parent
        color: "#222222"
        border.color: "#444"
        z: 1000

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text { text: "Tạo thư mục mới"; color: "white"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold }

            Rectangle {
                width: parent.width; height: 32
                color: "#333"; border.color: "#555"
                TextInput {
                    id: newFolderInput
                    anchors.fill: parent
                    anchors.margins: 6
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 13
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Return) {
                            FileMgr.createFolder(FileMgr.currentPath, newFolderInput.text)
                            newFolderDialog.visible = false
                        }
                        if (event.key === Qt.Key_Escape) newFolderDialog.visible = false
                    }
                }
            }

            Row {
                spacing: 8; anchors.right: parent.right
                Rectangle {
                    width: 60; height: 28; color: "#444"; radius: 2
                    Text { text: "Hủy"; color: "white"; anchors.centerIn: parent; font.family: "Inter"; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent; onClicked: newFolderDialog.visible = false }
                }
                Rectangle {
                    width: 60; height: 28; color: "#2196F3"; radius: 2
                    Text { text: "OK"; color: "white"; anchors.centerIn: parent; font.family: "Inter"; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent
                        onClicked: {
                            FileMgr.createFolder(FileMgr.currentPath, newFolderInput.text)
                            newFolderDialog.visible = false
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: newFileDialog
        visible: false
        width: 300; height: 110
        anchors.centerIn: parent
        color: "#222222"
        border.color: "#444"
        z: 1000

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text { text: "Tạo tệp mới"; color: "white"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold }

            Rectangle {
                width: parent.width; height: 32
                color: "#333"; border.color: "#555"
                TextInput {
                    id: newFileInput
                    anchors.fill: parent
                    anchors.margins: 6
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 13
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Return) {
                            FileMgr.createTextFile(FileMgr.currentPath, newFileInput.text)
                            newFileDialog.visible = false
                        }
                        if (event.key === Qt.Key_Escape) newFileDialog.visible = false
                    }
                }
            }

            Row {
                spacing: 8; anchors.right: parent.right
                Rectangle {
                    width: 60; height: 28; color: "#444"; radius: 2
                    Text { text: "Hủy"; color: "white"; anchors.centerIn: parent; font.family: "Inter"; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent; onClicked: newFileDialog.visible = false }
                }
                Rectangle {
                    width: 60; height: 28; color: "#2196F3"; radius: 2
                    Text { text: "OK"; color: "white"; anchors.centerIn: parent; font.family: "Inter"; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent
                        onClicked: {
                            FileMgr.createTextFile(FileMgr.currentPath, newFileInput.text)
                            newFileDialog.visible = false
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: statusBar
        height: 24
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#1A1A1A"

        Text {
            text: FileMgr.files.length + " mục"
            color: "#80FFFFFF"
            font.family: "Inter"
            font.pixelSize: 11
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle { width: parent.width; height: 1; color: "#33FFFFFF"; anchors.top: parent.top }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: fileContextMenu.opacity = 0
    }

    Connections {
        target: FileMgr
        function onErrorOccurred(message) {
            console.log("FM Error: " + message)
        }
        function onOperationSuccess(message) {
            console.log("FM OK: " + message)
        }
    }
}