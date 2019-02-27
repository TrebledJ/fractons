//	SceneBase.qml

import Felgo 3.0
import QtQuick 2.0

import "../../common"
import "../../js/Math.js" as JMath

Scene {
	id: scene
	//	TODO add background animation
	//	TODO find/create math symbols for background animation
	
	//	"logical size"
	width: 480
	height: 320
	z: -1
	signal backButtonClicked
	
	property bool useDefaultBackButton: true
	
	
	opacity: 0
//	opacity: 1
	visible: opacity != 0
	enabled: visible
	
//	state: visible ? "in" : "out"
	state: "hide"
	states: [
		State {
			name: "show"
			when: gameWindow.activeScene === scene
			PropertyChanges { target: scene; opacity: 1 }
		},
		State {
			name: "hide"
			PropertyChanges { target: scene; opacity: 0 }
		}
	]
	
	BubbleButton {
		width: 60; height: 30
		anchors {
			top: parent.top
			left: parent.left
			margins: 10
		}
		color: "yellow"
		
		visible: useDefaultBackButton
		
		text: "Back"
		
		onClicked: backButtonClicked();
	}
	
	
}
