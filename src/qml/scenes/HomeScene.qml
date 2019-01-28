//	HomeScene.qml

import VPlay 2.0
import QtQuick 2.0

import "backdrops"
import "../common"
import "../game"

import fractureuns 1.0

SceneBase {
	id: scene
	
	signal exercisesButtonClicked
	signal studyButtonClicked
	signal achievementsButtonClicked
	signal statisticsButtonClicked
	signal patchNotesButtonClicked
	
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
		width: parent.width; height: levelFracDisplay.height + 10
		anchors.bottom: parent.bottom
		color: "yellow"
		
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
			text: 'Level ' + JFractureuns.level() + '   ' + JFractureuns.fCurrent + '/' + JFractureuns.fNextThresh() + " F"
			verticalAlignment: Text.AlignVCenter
		}
		
		//	displays the frac progress
		Rectangle {
			id: fractureunOuterBar
			width: parent.width - parent.spacing - fractureunDisplay.width; height: parent.height
			radius: 5
			
			anchors {
				top: parent.top
				bottom: parent.bottom
			}
			
			color: "lightgoldenrodyellow"
			
			Rectangle {
				id: xpMeter
				width: (parent.width - 4.0) * JFractureuns.fProgress(); height: 4
				radius: 4
				anchors {
					left: parent.left
					top: parent.top
					bottom: parent.bottom
					margins: 2
				}
				
				color: "navy"
			}
		}	//	Rectangle: fractureunOuterBar
	}

	
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
			
			text: 'A'
			
			onClicked: achievementsButtonClicked();
		}
		
		BubbleButton {
			id: statisticsButton
			width: height; height: 40
			color: "yellow"
			
			text: 'S'
			
			onClicked: statisticsButtonClicked();
		}
		
		BubbleButton {
			id: patchNotesButton
			width: height; height: 40
			color: "yellow"
			
			text: 'PN'
			
			onClicked: patchNotesButtonClicked();
		}
	}
	
	
	
	//	useful for pinpointing coordinates
//	MouseArea {
//		anchors.fill: parent
//		onClicked: console.debug("Clicked:", mouseX, mouseY)
//	}
	
}
