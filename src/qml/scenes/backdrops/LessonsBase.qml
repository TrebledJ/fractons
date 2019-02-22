import Felgo 3.0
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
	
	
	useDefaultBackButton: false
	
	
	onLessonItemsChanged: {
		if (lessonItems[1] !== undefined)
			lessonItems[1].parent = flickable.contentItem;
	}
	
	Flickable  {
		id: flickable
		anchors {
			fill: parent
			margins: 10
			topMargin: 50
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
			
			BubbleButton {
				width: 60; height: 30
				anchors {
					verticalCenter: parent.verticalCenter
					left: parent.left
				}
				color: "yellow"
				text: "Previous"
				
				onClicked: previousLessonButtonClicked()
			}
			
			BubbleButton {
				width: 60; height: 30
				anchors {
					verticalCenter: parent.verticalCenter
					right: parent.right
				}
				color: "yellow"
				
				text: "Next"
				
				onClicked: nextLessonButtonClicked()
			}
			
		}	//	Rectangle
		
	}	//	Flickable: flickable
	
	
	//	header bar
	Rectangle {
		width: parent.width; height: 40
		anchors.top: parent.top
		
		color: "navy"
		
		BubbleButton {
			width: 60; height: 30
			anchors {
				top: parent.top
				left: parent.left
				margins: 5
			}
			color: "yellow"
			
			text: "Back"
			
			onClicked: backButtonClicked()
		}
		
		
		TextBase {
			id: titleText
			anchors.centerIn: parent
			color: "yellow"
			
			text: lessonName
			font.pointSize: lessonName.length < 30 ? 18 : lessonName.length < 50 ? 14 : 12
			font.bold: true
		}
		
		BubbleButton {
			width: textBase.contentWidth + 20; height: 30
			anchors {
				top: parent.top
				right: parent.right
				margins: 5
			}
			
			visible: useDefaultPracticeButton
			color: "yellow"
			
			text: "Practice"
			animateText: false
			
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
