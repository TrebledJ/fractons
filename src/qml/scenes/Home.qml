import QtQuick 2.0
import QtQuick.Controls 2.4

import "backdrops"
import "../common"
import "../game"
import "../game/singles"

//import Fractons 1.0

SceneBase {
	id: scene
	
	
	signal studyButtonClicked
	signal exercisesButtonClicked
	signal lotteryButtonClicked
	signal achievementsButtonClicked
	signal statisticsButtonClicked
	signal settingsButtonClicked
	
	useDefaultBackButton: false
	
	TextBase {
		anchors.bottom: mainButtonsRow.top
		anchors.bottomMargin: 30
		anchors.horizontalCenter: parent.horizontalCenter
//		color: "yellow"
		text: "ƒRACTONS"
		font.bold: true
		font.italic: true
		font.pointSize: 48
	}
	
	Row {
		id: mainButtonsRow
		anchors.centerIn: parent
		spacing: 20
		
		BubbleButton {
			id: studyNotesButton
			width: height; height: 80
			
			text: "Study"
			textObj.verticalAlignment: Text.AlignBottom
			
			image.source: "qrc:/assets/icons/book-open"
			image.anchors.bottomMargin: 20
			
			onClicked: studyButtonClicked()
		}
		
		BubbleButton {
			id: exercisesButton
			width: height; height: 80
			
			text: "Exercises"
			textObj.verticalAlignment: Text.AlignBottom
			
			image.source: "qrc:/assets/icons/star"
			image.anchors.bottomMargin: 20
			
			onClicked: exercisesButtonClicked()
		}
		
		BubbleButton {
			id: lotteryButton
			width: height; height: 80
			
			text: enabled ? "Lottery" : "???"
			textObj.verticalAlignment: Text.AlignBottom
			
			enabled: true
//			enabled: JFractons.currentLevel() >= 15		//	TODO uncomment this
			opacity: enabled ? 1 : 0.6
			
			image.source: enabled ? "qrc:/assets/icons/slot" : "qrc:/assets/icons/question-mark2"
			image.anchors.bottomMargin: 20
			
			onClicked: lotteryButtonClicked()
		}
	}
	
	//	level + frac display
	Rectangle {
		id: ribbonBackground
		width: parent.width; height: levelFracDisplay.height + 10
		anchors.bottom: parent.bottom
		color: "navy"
		
	}
	
	Row {
		id: levelFracDisplay
		width: 250; height: 10
		anchors {
			bottom: parent.bottom
			horizontalCenter: parent.horizontalCenter
			margins: 5
		}
		
		spacing: 10
		
		TextBase {
			id: fractonDisplay
			width: contentWidth + 10; height: parent.height
			color: "yellow"
			text: 'Level ' + JFractons.currentLevel() + '   ' + JFractons.fCurrent + '/' + JFractons.fNextThresh() + " ƒ"
			verticalAlignment: Text.AlignVCenter
		}
		
		//	displays the frac progress
		Rectangle {
			id: fractonOuterBar
			width: parent.width - parent.spacing - fractonDisplay.width; height: parent.height
			radius: 5
			
			color: "lightgoldenrodyellow"
			
			Rectangle {
				id: xpMeter
				width: (parent.width - 6) * JFractons.fProgress() + 2; height: parent.height - 4
				radius: 5
				anchors {
					left: parent.left
					top: parent.top
					bottom: parent.bottom
					margins: 2
				}
				
				color: "navy"
			}
		}	//	Rectangle: fractonOuterBar
		
		//	INFO
		//	I tried using a ProgressBar from QtQuick.Controls 2.4 but it showed incorrect results (bar was full even though progress should be halfway through).
		//	So I reverted to manual rectangles.

		
	}	//	Row

	
	Row {
		id: otherButtons
		spacing: 10
		
		anchors {
			top: parent.top
			left: parent.left; right: parent.right
			margins: 5
		}
		
		BubbleButton {
			id: achievementsButton
			width: height; height: 40
			
			image.source: "qrc:/assets/icons/trophy"
			
			onClicked: achievementsButtonClicked();
		}
		
		BubbleButton {
			id: statisticsButton
			width: height; height: 40
			
			image.source: "qrc:/assets/icons/line-chart"
			onClicked: statisticsButtonClicked();
		}
		
	}
	
	BubbleButton {
		id: settingsButton
		width: height; height: 40
		anchors {
			top: parent.top
			right: parent.right
			margins: 5
		}
		
		image.source: "qrc:/assets/icons/gear"
		onClicked: settingsButtonClicked();
	}
	
	
	
	//	useful for pinpointing coordinates
//	MouseArea {
//		anchors.fill: parent
//		onClicked: console.debug("Clicked:", mouseX, mouseY)
//	}
	
}
