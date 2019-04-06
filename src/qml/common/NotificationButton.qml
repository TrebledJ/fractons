import QtQuick 2.0
//import Felgo 3.0

BubbleButton {
	id: bubbleButton
	
	property alias nCircleText: notificationText.text
	property bool nCircleVisible: false
	
	Rectangle {
		id: circle
		
		x: bubbleButton.background.width - 3 - radius
		y: -radius + 5
		
		width: nCircleVisible ? notificationText.contentWidth + 10 : 0
		height: nCircleVisible ? 15 : 0
		radius: height*0.5
		
		color: "red"
		
		opacity: nCircleVisible ? 1 : 0.9
		
		
		Behavior on width {
			PropertyAnimation { easing.type: Easing.InOutBack; duration: 500 }
		}
		Behavior on height {
			PropertyAnimation { easing.type: Easing.InOutBack; duration: 500 }
		}
		Behavior on opacity {
			PropertyAnimation { duration: 400 }
		}
		
		TextBase {
			id: notificationText
			anchors.centerIn: parent
			text: '100'
			font.pointSize: 10
			color: "white"
			
			visible: circle.opacity >= 0.98
		}
		
	}
	
}
