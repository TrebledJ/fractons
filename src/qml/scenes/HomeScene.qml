//	HomeScene.qml

import VPlay 2.0
import QtQuick 2.0

import "backdrops"
import "../common"

SceneBase {
	id: scene
	
	signal exercisesButtonClicked
	signal studyButtonClicked
	
	//	TODO animate "Circle" to pop up on entrance
	CircleButton {
		id: exercisesButton
		
		x: 300
		y: 200
		radius: 50
		
		defaultColor: "lightgoldenrodyellow"
		hoverColor: "yellow"
		
		//	TODO replace text with image
		text: "Exercises"
		
//		onEntered: console.debug("Radius:", radius)
		onClicked: exercisesButtonClicked()
	}
	
	CircleButton {
		id: studyNotesButton
		
		x: 180
		y: 140
		radius: 40
		
		defaultColor: "lightgoldenrodyellow"
		hoverColor: "yellow"
		
		//	TODO replace text with image
		text: "Study"
		
//		onEntered: console.debug("Radius:", radius)
		onClicked: studyButtonClicked()
	}
	
	BubbleButton {
		id: exitButton
		
		width: height; height: 30
		
		anchors {
			top: scene.top
			left: scene.left
			margins: 10
		}
		
		text: "X"
		color: "yellow"
		
		onClicked: {
			Qt.quit();
		}
	}
	
	//	useful for pinpointing coordinates
//	MouseArea {
//		anchors.fill: parent
//		onClicked: console.debug("Clicked:", mouseX, mouseY)
//	}
	
}
