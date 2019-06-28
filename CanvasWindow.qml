import QtQuick 2.12
import QtQuick.Window 2.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.1

Window  {
    id: mainWindow
    signal released();
    function requestClear(){
        var ctx = mainCanvas.getContext("2d")
        ctx.clearRect(0,0,mainCanvas.width,mainCanvas.height)
        mainCanvas.requestPaint()
    }
    function enablePaint(){
        console.log("Play on me !")
        enableCanvas=true
    }
    function disablePaint(){
        console.log("Wont touch me !")
        enableCanvas=false
    }
    function changeColor(color){
        console.log("new color !")
        currentColor=color
    }
    function changeSize(value){
        console.log("new size " + value + "!")
        brushSize=value
    }
    property bool enableCanvas: true
    property color currentColor: "red"
    property int brushSize: 2

    flags: Qt.FramelessWindowHint |
           Qt.WindowStaysOnTopHint
    visible: true
    title: "menu"
    color: "transparent"
    x: 0; y: 0
    width: Screen.width - 1
    height: Screen.height - 1

    Canvas
    {
        Keys.onEscapePressed: Qt.quit()
        z:9
        anchors.fill: parent
        id:mainCanvas
        property int lastX: 0
        property int lastY: 0
        onPaint: {
            if(enableCanvas)
            {
                var ctx = getContext("2d")
                ctx.lineWidth = brushSize
                ctx.strokeStyle = currentColor

                ctx.beginPath()
                ctx.moveTo(lastX,lastY)

                lastX = hotAreaCanvas.mouseX
                lastY = hotAreaCanvas.mouseY

                ctx.lineTo(lastX,lastY)
                ctx.stroke()
            }
        }
        MouseArea {
            id: hotAreaCanvas
            anchors.fill: parent
            onPressed: {
                mainCanvas.lastX = mouseX
                mainCanvas.lastY = mouseY
            }
            onReleased:
            {
                //Qt.quit()
                mainWindow.released()
            }
            onPositionChanged:
            {
                mainCanvas.requestPaint();
            }
        }
    }


}
