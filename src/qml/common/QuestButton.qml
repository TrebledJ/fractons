import QtQuick 2.0

BubbleButton {
	id: questButton
	width: height; height: 30
	
	property bool completed: quest.progress >= quest.maxProgress
	property var quest: ({})
//	property int progress: 4
//	property int maxProgress: 10
	
	property bool isEntered: false
	property bool isPressed: false
	
	image.anchors.margins: 0
	image.source: completed ? "qrc:/assets/icons/cowboy-hat-tick.png" : "qrc:/assets/icons/cowboy-hat.png"
	
	onEntered: isEntered = true
	onExited: isEntered = false
	
	
	onPressed: {
		isPressed = true;
		
//		rect.width = questText.contentWidth + 15;
	}
	
	onReleased: {
		isPressed = false;
		
//		rect.width = 0;
	}
	
//	Column {
//		anchors {
//			top: rect.bottom
//			left: rect.left; leftMargin: 10
//			right: rect.right
//		}

//		spacing: 1
		
//		Rectangle {
//			width: parent.width; height: 8
//			radius: 4
//			color: "lightgoldenrodyellow"
			
//			Rectangle {
//				width: (parent.width - 4) * quest.progress / quest.maxProgress; height: 4
//				radius: 2
				
//				anchors.left: parent.left
//				anchors.top: parent.top
//				anchors.margins: 2
				
				
//				color: "navy"
//			}
//		}
		
//		TextBase {
//			id: progressText
//			font.pointSize: 6
//			text: quest.progress + '/' + quest.maxProgress
			
//			visible: isPressed
//		}
//	}
	
}
