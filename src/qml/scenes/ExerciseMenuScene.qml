//	ExerciseMenuScene.qml

import VPlay 2.0
import QtQuick 2.11
import QtQuick.Controls 2.2

import "backdrops"
import "../common"

SceneBase {
	id: scene
	
	signal backButtonClicked()
	signal modeClicked(string mode)
	
	ListModel {
		id: modeModel
		ListElement { role_stars: 0; role_mode: "Standard" }
		ListElement { role_stars: 0; role_mode: "Bar" }
		ListElement { role_stars: 0; role_mode: "Match" }
		ListElement { role_stars: 0; role_mode: "Conversion" }
		ListElement { role_stars: 0; role_mode: "Truth" }
		ListElement { role_stars: 0; role_mode: "Rush" }
		ListElement { role_stars: 0; role_mode: "Word" }
	}
	
	ListView {
		id: modeView
		
		anchors {
			fill: parent
			leftMargin: 30; rightMargin: 10
		}
		
		topMargin: 10
		bottomMargin: 10
		leftMargin: 10
		rightMargin: 10
		
		spacing: 5
		
		headerPositioning: ListView.OverlayHeader
		
		boundsBehavior: Flickable.StopAtBounds
		
		focus: true
		model: modeModel
		delegate: modeDelegate
		header: headerDelegate
		
		Component {
			id: headerDelegate
			
			Item {
				z: 3
				width: modeView.width - 10; height: 40
				
				Rectangle {
					anchors.fill: parent
//					anchors.bottomMargin: 20
					
					radius: 5
					
					color: "yellow"
					
					TextBase {
						anchors.centerIn: parent
						text: "Exercise Modes"
					}
				}
			}
			
		}	//	Component: headerDelegate
		
		Component {
			id: modeDelegate
			
			//	a row for each list element
			Row {
				id: row
				width: modeView.width; height: 40
				spacing: 20
				
				clip: true
				
				//	TODO use another Row to hold stars
				//	displays stars (mastery)
				//	TODO define mastery
				Rectangle {
					id: starsRect
					width: 80; height: parent.height
					
					color: "black"
					opacity: 0.6
				}
				
				//	displays mode name with button function
				BubbleButton {
					id: modeRect
					
					width: parent.width - parent.spacing - starsRect.width - 15; height: parent.height
					
					defaultColor: "yellow"
					
					background.radius: 5
					background.border.width: 3
					
					text: "<b>" + role_mode + "</b> Mode"
					textBase.horizontalAlignment: Text.AlignRight
					textBase.anchors.rightMargin: 10
					animateText: false
					
					onEntered: {
						modeView.currentIndex = index;
					}
					
					onClicked: {
						console.debug(role_mode + " Mode clicked.");
						modeClicked(role_mode);
					}
				}
				
				Component.onCompleted: {
					
					modeRect.background.border.color = Qt.binding(function() {
						return ListView.isCurrentItem ? "navy" : "transparent";
					});
				}
				
			}	//	Row: row
		}	//	Component: modelDelegate
	}	//	ListView: modeView
	
	
	BubbleButton {
		id: backButton
		width: 30
		anchors {
			left: scene.left
			top: scene.top
			bottom: scene.bottom
		}
		
		text: backButton.mouseArea.pressed ? "◄" : "◁";
		animateText: false
		color: "yellow"
		
		
		defaultDiagonal: 1.1
		
		enteredFrom: 1; // enteredTo: 1.2
		pressedFrom: defaultDiagonal; pressedTo: 1.3
		
		onClicked: backButtonClicked();
	}
}
