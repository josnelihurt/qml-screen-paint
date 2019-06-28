import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
Rectangle {
    width: 600
    height: 400
    Rectangle {
    id: fakeMenuBar
    height: 21
    width: parent.width
    gradient: Gradient{
    GradientStop{color: "#fff" ; position:0}
    GradientStop{color: "#eee" ; position:1}
    }
    Rectangle {
    color: "#777"
    height: 1 ; width: parent.width
    anchors.bottom: parent.bottom
    }
    Row {
        id: menuBar
        Button {
            text: "Menu "
            height: 20
            width: 100
            style: ButtonStyle {
            background: Rectangle { color: control.pressed ? "#ccc" : "transparent" }
            }
            menu: Menu {
            MenuItem { text: "item 1" }
                MenuItem { text: "item 2" }
                MenuItem { text: "item 3" }
                }
            }
        }
    }
}
