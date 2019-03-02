import QtQuick 2.11
import QtQuick.Controls 2.2

import "../../common"

SceneBase {
	id: sceneBase
	
	signal previousLessonButtonClicked
	signal nextLessonButtonClicked
	signal practiceButtonClicked(string mode, string difficulty)
	default property alias lessonItems: flickable.children
	
	property string lessonName
	property string gotoMode
	property string gotoDifficulty
	
	property alias flickable: flickable
	
	property bool useDefaultPracticeButton: true
	
	
//	useDefaultBackButton: false
	
	
	onLessonItemsChanged: {
		if (lessonItems[1] !== undefined)
			lessonItems[1].parent = flickable.contentItem;
	}
	
	Flickable  {
		id: flickable
		anchors {
			fill: parent
			margins: 10
			topMargin: header.height + 10
		}
		contentWidth: width
		contentHeight: lessonContents.height	//	contents is aliased to inherited lesson
		
		//	leave room for the previous/next buttons
		bottomMargin: 50
		
		//	rectangular container for previous/next buttons
		Rectangle {
			width: parent.width; height: 40
			anchors.top: flickable.contentItem.bottom
			color: "transparent"
			
			visible: false	//	TODO make this workable
			
			BubbleButton {
				width: 60; height: 30
				anchors {
					verticalCenter: parent.verticalCenter
					left: parent.left
				}
				text: "Previous"
				
				onClicked: previousLessonButtonClicked()
			}
			
			BubbleButton {
				width: 60; height: 30
				anchors {
					verticalCenter: parent.verticalCenter
					right: parent.right
				}
				text: "Next"
				
				onClicked: nextLessonButtonClicked()
			}
			
		}	//	Rectangle
	}	//	Flickable: flickable
	
	
	//	header bar
	Rectangle {
		id: header
		width: parent.width; height: 50
		anchors.top: parent.top
		
		color: "navy"
		
		TextBase {
			id: titleText
			anchors.centerIn: parent
			color: "yellow"
			
			text: lessonName
			font.pointSize: lessonName.length < 30 ? 18 : lessonName.length < 50 ? 14 : 12
			font.bold: true
		}
		
		BubbleButton {
			width: height; height: parent.height - 2*anchors.margins
			anchors {
				top: parent.top
//				bottom: parent.bottom
				right: parent.right
				margins: 5
			}
			
			visible: useDefaultPracticeButton
			
//			text: "Practice"
//			textObj.animate: false
			image.source: "qrc:/assets/icons/star"
//			image.anchors.margins: 3
			
			onClicked: {
				if (gotoMode === "")
				{
					console.error("GoToMode expected.");
					return;
				}

				practiceButtonClicked(gotoMode, gotoDifficulty)
			}
		}	//	BubbleButton
	}	//	Rectangle
	
}
