import QtQuick 2.0

BubbleButton {
	id: questButton
	width: height; height: 30
	
	property bool completed: quest.progress >= quest.maxProgress
	property var quest: ({})
	
	property bool isEntered: false
	property bool isPressed: false
	
	image.anchors.margins: 0
	image.source: completed ? "qrc:/assets/icons/cowboy-hat-tick.png" : "qrc:/assets/icons/cowboy-hat.png"
	
	onEntered: isEntered = true
	onExited: isEntered = false
	
	onPressed: isPressed = true;
	onReleased: isPressed = false;
	
}
