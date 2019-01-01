//	ExerciseMenuScene.qml

import VPlay 2.0
import QtQuick 2.11

import "../common"

SceneBase {
	id: scene
	
	signal modeClicked(string mode)
	
	Text {
		text: "ExerciseMenuScene"
		anchors.horizontalCenter: parent.horizontalCenter
		opacity: 0.5
	}
	
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
		
		anchors.fill: parent
		anchors.margins: 20
		
		contentHeight: 1
		
		spacing: 5
		
		headerPositioning: ListView.OverlayHeader
		boundsMovement: Flickable.StopAtBounds
		boundsBehavior: Flickable.DragOverBounds
		
		focus: true
		model: modeModel
		delegate: modeDelegate
		header: headerDelegate
		
		topMargin: 10

		
		Component {
			id: headerDelegate
			
			Item {
				z: 3
				width: modeView.width; height: 40
				
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
				width: modeView.width; height: 25
				
				spacing: 20
				
				//	TODO use another Row to hold stars
				//	displays stars (mastery)
				//	TODO define mastery
				Rectangle {
					id: starsRect
					width: 80; height: parent.height
					
					color: "transparent"
					border.width: 1
					border.color: "black"
				}
				
				//	displays mode name with button function
				ButtonBase {
					id: modeRect
					
					width: parent.width - parent.spacing - starsRect.width; height: parent.height
					background.radius: 5
					defaultColor: "yellow"
					
					background.border.width: 3
					
					text: "<b>" + role_mode + "</b> Mode"
					textBase.horizontalAlignment: Text.AlignRight
					
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
				
			}	//	Row
			
		}	//	Component: modelDelegate
		
//		Component {
//			id: highlightDelegate
			
//			Rectangle {
//				id: hlight
				
//				x: 100
//				y: modeView.currentItem.y; z: 2
				
//				width: modeView.width - 100; height: 25
//				radius: 5
				
//				color: "transparent"
				
//				border.width: 3
//				border.color: "navy"
				
//				//	force width to 100
//				onWidthChanged: {
//					if (width != modeView.width - 100)
//						width = modeView.width - 100;
//				}
				
//				Behavior on y {
//					NumberAnimation {
//						target: hlight
//						property: 'y'
//						duration: 150
//						easing.type: Easing.InOutQuad
//					}
//				}
//			}
			
//		}	//	Component: highlightDelegate
		
	}	//	ListView: modeView
}
