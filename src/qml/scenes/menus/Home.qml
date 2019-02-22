import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls 2.4

import "../backdrops"
import "../../common"
import "../../game"
import "../../game/singles"

import Fractureuns 1.0

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
			
			//	TODO replace text with image
			text: "Study"
			
			onClicked: studyButtonClicked()
		}
		
		BubbleButton {
			id: exercisesButton
			width: height; height: 80
			color: "yellow"
			
			//	TODO replace text with image
			text: "Exercises"
			
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
			id: fractureunDisplay
			width: contentWidth + 10; height: parent.height
			color: "yellow"
			text: 'Level ' + JFractureuns.currentLevel() + '   ' + JFractureuns.fCurrent + '/' + JFractureuns.fNextThresh() + " ƒ"
			verticalAlignment: Text.AlignVCenter
		}
		
		//	displays the frac progress
		Rectangle {
			id: fractureunOuterBar
			width: parent.width - parent.spacing - fractureunDisplay.width; height: parent.height
			radius: 5
			
			color: "lightgoldenrodyellow"
			
			Rectangle {
				id: xpMeter
				width: (parent.width - 6) * JFractureuns.fProgress() + 2; height: parent.height - 4
				radius: 5
				anchors {
					left: parent.left
					top: parent.top
					bottom: parent.bottom
					margins: 2
				}
				
				color: "navy"
			}
		}	//	Rectangle: fractureunOuterBar
		
		//	INFO
		//	I tried using a ProgressBar from QtQuick.Controls 2.4 but it showed incorrect results (bar was full even though progress should be halfway through).
		//	So I reverted to manual rectangles.

		
	}	//	Row

	
	//	TODO find images for these buttons below
	
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
			
			text: 'Acvm'
			
			onClicked: achievementsButtonClicked();
		}
		
		BubbleButton {
			id: statisticsButton
			width: height; height: 40
			color: "yellow"
			
			text: 'Stt'
			
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
		
		text: 'Set'
		onClicked: settingsButtonClicked();
	}
	
	
	
	//	useful for pinpointing coordinates
//	MouseArea {
//		anchors.fill: parent
//		onClicked: console.debug("Clicked:", mouseX, mouseY)
//	}
	
}
