import Felgo 3.0
import QtQuick 2.11
import QtQuick.Controls 2.2

import "../backdrops"
import "../../common"
import "../../game/singles"
//	TODO implement stars/mastery

SceneBase {
	id: scene
	
	signal modeClicked(string mode)
	
//	useDefaultBackButton: false
	
	ListModel {
		id: modeModel
		ListElement { role_stars: 0; role_min_level: 1; role_mode: "Standard" }	//	Standard equation solving, given two fractions on the lhs and an operation
		ListElement { role_stars: 0; role_min_level: 3; role_mode: "Balance" }		//	balance or simplify a given fraction
		
		//		ListElement { role_stars: 0; role_mode: "Bar" }	//	deprecated ?
		
		ListElement { role_stars: 0; role_min_level: 5; role_mode: "Conversion" }	//	convert between decimals and fractions
		ListElement { role_stars: 0; role_min_level: 7; role_mode: "Truth" }		//	given an equation or inequality, tell if it is True or False
		
		//	TODO implement these other modes
		ListElement { role_stars: 0; role_min_level: 9; role_mode: "Word" }		//	solve a word exercise, giving a fractional answer
		
		ListElement { role_stars: 0; role_min_level: 12; role_mode: "Fill" }		//	create a grid of tiles and highlight tiles to create a fraction out of the whole
		ListElement { role_stars: 0; role_min_level: 15; role_mode: "Rush" }		//	timed ... what exercise?
	}
	
	ListView {
		id: modeView
		
		anchors {
			fill: parent
			leftMargin: 80; rightMargin: 10
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
//		header: headerDelegate
		
		ScrollBar.vertical: ScrollBar {
			id: scrollbar
			anchors.left: modeView.right
			active: true

		}
		
//		Component {
//			id: headerDelegate
			
//			Item {
//				z: 3
//				width: modeView.width - 10; height: 40
				
//				Rectangle {
//					anchors.fill: parent
//					color: "yellow"
					
//					TextBase {
//						anchors.centerIn: parent
//						text: "Exercise Modes"
//					}
//				}
//			}
			
//		}	//	Component: headerDelegate
		
		Component {
			id: modeDelegate
			
			//	a row for each list element
			Row {
				id: row
				width: modeView.width; height: 40
				spacing: 20
				
				opacity: JFractons.currentLevel() < role_min_level ? 0.5 : 1
				
				clip: true
				
				//	TODO use another Row to hold stars
				//	displays stars (mastery)
				//	TODO define mastery
				Rectangle {
					id: starsRect
					width: 100; height: parent.height
					
					color: "black"	//	4 DEBUG
					opacity: 0.6
				}
				
				//	displays mode name with button function
				BubbleButton {
					id: modeRect
					width: parent.width - parent.spacing - starsRect.width - 15; height: parent.height
					color: "yellow"
					
					background.border.width: 3
					
					text: "<b>" + role_mode + "</b> Mode"
					textObj.textFormat: Text.StyledText
					textObj.horizontalAlignment: Text.AlignRight
					textObj.anchors.rightMargin: 10
					textObj.animate: false
					
					onEntered: {
						modeView.currentIndex = index;
					}
					
					onClicked: {
						if (JFractons.currentLevel() < role_min_level)
							return;
						
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
	

}
