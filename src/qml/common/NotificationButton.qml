import QtQuick 2.0

BubbleButton {
	id: bubbleButton
	
	property alias nCircleText: notificationText.text
	property bool nCircleVisible: false
	
	Rectangle {
		id: circle
		x: bubbleButton.background.width - 3 - radius; y: -radius + 5
		width: nCircleVisible ? notificationText.contentWidth + 10 : 0
		height: nCircleVisible ? 15 : 0
		radius: height*0.5
		
		color: "red"
		opacity: nCircleVisible ? 1 : 0.9
		
		TextBase {
			id: notificationText
			anchors.centerIn: parent
			text: '100'
			font.pointSize: 10
			color: "white"; visible: circle.opacity >= 0.98
		}
		
		
		Behavior on width { PropertyAnimation { duration: 500; easing.type: Easing.InOutBack } }
		Behavior on height { PropertyAnimation { duration: 500; easing.type: Easing.InOutBack } }
		Behavior on opacity { PropertyAnimation { duration: 400 } }
	}
	
}
