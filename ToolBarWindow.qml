import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.1

ApplicationWindow {
    id: toolBarWindow
    flags: Qt.FramelessWindowHint |
           Qt.Window  |
           Qt.WindowStaysOnTopHint
    signal clearClicked();
    signal paintEnableChanged(bool value);
    signal paintColor(color changedColor);
    signal sizeChanged(int value);

    visible: true
    color: "transparent"
    height: 180

    header: Rectangle{
        id: toolBarTitle
        width: parent.width
        height: 30
        color: "#117bf3"
        border.color: "transparent"
        border.width: 15
        MouseArea {
            id: hotAreaMoveWindow
            anchors.fill: parent
            property real lastMouseX: 0
            property real lastMouseY: 0
            onPressed: {
                lastMouseX = mouseX
                lastMouseY = mouseY
            }
            onMouseXChanged: {toolBarWindow.x += (mouseX - lastMouseX); moveColorPicker();}
            onMouseYChanged: {toolBarWindow.y += (mouseY - lastMouseY); moveColorPicker();}
        }
        Row{
            anchors.margins: 5
            width: parent.width
            spacing: 2

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 8
                text: " Toolbar"
                color: "white"
            }
            ButtonSimple {
                anchors.verticalCenter: parent.verticalCenter
                onClicked: Qt.quit()
                innerColor: "#000000FF"
                pixelSize: 30
            }
        }
    }

    CustomToolBar
    {
        Keys.onEscapePressed: Qt.quit()
        id: toolBar
        onClearClicked:toolBarWindow.clearClicked()
        onPaintEnableChanged: {
            console.log("paintEnabled = " + value)
            toolBarWindow.paintEnableChanged(value);
        }
        onPickNewColor: {
            if(colorPicker.visible){
                colorPicker.hide()
            }else{
                colorPicker.show();
            }
            moveColorPicker();
        }
        onSizeChanged: toolBarWindow.sizeChanged(value);
    }
    Window{
        id: slider
        visible: false
        flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowStaysOnTopHint
        color: "#663d3d3d"
    }

    Window{
        id: colorPicker
        visible: false
        width: 400; height: 200
        property int align: Qt.AlignRight
        flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowStaysOnTopHint
        Colorpicker{
            onColorChanged: toolBarWindow.paintColor(changedColor)
        }
    }
    function moveColorPicker()
    {
        if(!colorPicker.visible)
            return

        var newX = toolBarWindow.x + toolBar.width
        if(colorPicker.align === Qt.AlignRight) {
            // Check right border
            newX = toolBarWindow.x + toolBar.width
            if(Screen.desktopAvailableWidth - (toolBarWindow.x + colorPicker.width) <= 0) {
                newX = toolBarWindow.x - colorPicker.width
                colorPicker.align = Qt.AlignLeft
            }
        } else {
            // Check left border
            newX = toolBarWindow.x - colorPicker.width
            if((toolBarWindow.x - colorPicker.width) <= 0) {
                newX = toolBarWindow.x + toolBar.width
                colorPicker.align = Qt.AlignRight
            }
        }

        colorPicker.x = newX
        colorPicker.y = toolBarWindow.y
    }
}
