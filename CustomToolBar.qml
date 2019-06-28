import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Extras 1.4
import QtQuick.Window 2.3

Item {
    id: floatingToolBar
    signal clearClicked();
    signal paintEnableChanged(bool value);
    signal sizeChanged(int value);
    signal pickNewColor();
    property bool pencilEnabled : true

    anchors.margins: 5
    width: parent.width
    Grid{
        id: buttons
        anchors.fill: parent
        columnSpacing: 4
        rowSpacing: 4
        columns: 2
        Button{
            id: pencilBtn
            checkable: true

            icon { source:"qrc:/res/pencil.svg"} width:parent.width/2;
            onClicked: {
                paintEnableChanged(pencilBtn.checked);
            }
        }
        Button{
            id: eraserBtn

            icon { source:"qrc:/res/eraser.svg"} width:parent.width/2;
            onClicked: function(){
                //console.log("About to rise1");
                floatingToolBar.clearClicked();
            }
        }
        Button{
            id: sliderBtn
            icon { source:"qrc:/res/ruler.svg"} width:parent.width/2;
            onClicked: {slider.visible = true; sliderBtn.visible = false;}
        }
        Slider {
            Timer {
                id: sliderDog
                interval: 1000; running: false; repeat: false
                onTriggered: {sliderBtn.visible = true; slider.visible = false;}
            }
            id: slider
            width: sliderBtn.width
            height: sliderBtn.height
            visible: false
            from: 1
            value: 2
            to: 30
            onMoved: {sliderDog.stop(); sliderDog.start();floatingToolBar.sizeChanged(slider.value);}
        }
        Button{
            icon { source:"qrc:/res/paintbrush.svg"} width:parent.width/2;
            onClicked: pickNewColor();
        }
        Button{
            icon { source:"qrc:/res/save.svg"} width:parent.width/2; }
        Button{icon { source:"qrc:/res/close.svg"} width:parent.width/2;
            onClicked: Qt.quit()}

    }
    Component.onCompleted:
    {
        pencilBtn.checked = true
        floatingToolBar.pencilEnabled = Qt.binding(function(){return pencilBtn.checked})
    }
}
