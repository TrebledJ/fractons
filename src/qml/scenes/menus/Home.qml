import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls 2.4

import "../backdrops"
import "../../common"
import "../../game"
import "../../game/singles"

import Fractons 1.0

SceneBase {
	id: scene
	
	signal exercisesButtonClicked
	signal studyButtonClicked
	signal achievementsButtonClicked
	signal statisticsButtonClicked
	signal settingsButtonClicked
	
	useDefaultBackButton: false
	
	Row {
		anchors.centerIn: parent
		spacing: 20
		
		BubbleButton {
			id: studyNotesButton
			width: height; height: 80
			color: "yellow"
			
			text: "Study"
			textObj.verticalAlignment: Text.AlignBottom
			
			image.source: "qrc:/assets/icons/OpenBook"
			image.anchors.bottomMargin: 20
			
			onClicked: studyButtonClicked()
		}
		
		BubbleButton {
			id: exercisesButton
			width: height; height: 80
			color: "yellow"
			
			text: "Exercises"
			textObj.verticalAlignment: Text.AlignBottom
			
			image.source: "qrc:/assets/icons/Star"
			image.anchors.bottomMargin: 20
			
			onClicked: exercisesButtonClicked()
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
			color: "yellow"
			
			image.source: "qrc:/assets/icons/Trophy"
			
			onClicked: achievementsButtonClicked();
		}
		
		BubbleButton {
			id: statisticsButton
			width: height; height: 40
			color: "yellow"
			
			image.source: "qrc:/assets/icons/LineChart"
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
		color: "yellow"
		
		image.source: "qrc:/assets/icons/Gear"
		onClicked: settingsButtonClicked();
	}
	
	
	
	//	useful for pinpointing coordinates
//	MouseArea {
//		anchors.fill: parent
//		onClicked: console.debug("Clicked:", mouseX, mouseY)
//	}
	
}
