import QtQuick 2.0

Item
{
    id: root
    signal clicked(); // onClicked: print('onClicked')
    property string text: 'txt'
    property color innerColor: "#00FFFFFF"
    property int pixelSize: 50
    width:  pixelSize
    height: pixelSize
    Rectangle { // size controlled by height
        anchors.fill: parent
        anchors.margins: 5
        width: parent.width;
        height: parent.height // default size
        border.width: 0.05 * parent.height
        border.color: "#7FFFFFFF"
        radius:       0.5  * parent.height
        opacity:      enabled? 0.9 : 0.3 // disabled state
        color: parent.innerColor

        MouseArea {
            anchors.fill: parent
            onPressed:  parent.opacity = 0.5 // down state
            onReleased: parent.opacity = 1
            onCanceled: parent.opacity = 1
            onClicked:  root.clicked() // emit
        }
    }
    Rectangle
    {
        anchors.fill: parent
        anchors.margins: 5
        width: parent.width * 0.5
        height: parent.height * 0.5
        radius:       0.5  * root.height
        color: "#7FAF0000"
    }
}
