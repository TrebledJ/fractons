import QtQuick 2.11
import QtQuick.Controls 2.2

import "../backdrops"
import "../../common"
import "../../game/singles"

//	TODO implement stars/mastery
SceneBase {
	id: scene
	
	signal modeClicked(string mode)
	
	useDefaultTopBanner: true
	
	ListModel {
		id: modeModel
		
		
		ListElement { role_stars: 0; role_min_level: 1; role_mode: "Balance" }		//	balance or simplify a given fraction
		
		//		ListElement { role_stars: 0; role_mode: "Bar" }	//	deprecated ?
		
		ListElement { role_stars: 0; role_min_level: 4; role_mode: "Conversion" }	//	convert between decimals and fractions
		
		ListElement { role_stars: 0; role_min_level: 8; role_mode: "Operations" }	//	Standard equation solving, given two fractions on the lhs and an operation
		ListElement { role_stars: 0; role_min_level: 12; role_mode: "Fill" }			//	create a grid of tiles and highlight tiles to create a fraction out of the whole
		
		ListElement { role_stars: 0; role_min_level: 16; role_mode: "Truth" }		//	given an equation or inequality, tell if it is True or False
		//	TODO implement these other modes
//		ListElement { role_stars: 0; role_min_level: 9; role_mode: "Word" }		//	solve a word exercise, giving a fractional answer
		
//		ListElement { role_stars: 0; role_min_level: 12; role_mode: "Fill" }		//	create a grid of tiles and highlight tiles to create a fraction out of the whole
//		ListElement { role_stars: 0; role_min_level: 15; role_mode: "Token" }		//	?
//		ListElement { role_stars: 0; role_min_level: 15; role_mode: "Rush" }		//	timed ... what exercise?
		
//		ListElement { role_stars: 0; role_min_level: -1; role_mode: "Pie" }		//	hidden mode, accessible from lottery but not from menu
	}
	
	ListView {
		id: modeView
		
		anchors {
			top: banner.bottom; bottom: parent.bottom
			left: parent.left; leftMargin: 80
			right: parent.right; rightMargin: 10
		}
		
		topMargin: 10
		bottomMargin: 10
		leftMargin: 10
		rightMargin: 10
		
		spacing: 5
		
		boundsBehavior: Flickable.StopAtBounds
		
		focus: true
		model: modeModel
		delegate: modeDelegate
		
		//	TODO add when other modes are implemented
//		ScrollBar.vertical: ScrollBar {
//			id: scrollbar
//			anchors.left: modeView.right
//			active: true
//		}
		
		Component {
			id: modeDelegate
			
			//	a row for each list element
			Row {
				id: row
				width: modeView.width; height: 40
				spacing: 20
				
				property bool unlocked: JFractons.currentLevel() >= role_min_level
				
				enabled: unlocked
				opacity: unlocked ? 1 : 0.5
				
				clip: true
				
				Component.onCompleted: {
					modeRect.background.border.color = Qt.binding(function() {
						return ListView.isCurrentItem ? "navy" : "transparent";
					});
				}
				
				//	TODO use another Row to hold stars
				//	displays stars (mastery)
				//	TODO define mastery
				Rectangle {
					id: starsRect
					width: 100; height: parent.height
					
//					color: "black"	//	4 DEBUG
					opacity: 0.6
					color: "transparent"
					
//					visible: false
				}
				
				//	displays mode name with button function
				BubbleButton {
					id: modeRect
					width: parent.width - parent.spacing - starsRect.width - 15; height: parent.height
					
					background.border.width: 3
					
					text: (row.unlocked ? role_mode : "Level " + role_min_level)
					textObj.textFormat: Text.StyledText
					textObj.horizontalAlignment: Text.AlignRight
					textObj.anchors.rightMargin: 10
					textObj.animate: false
					
					image.source: row.unlocked ? "" : "qrc:/assets/icons/padlock-closed"
					
					onEntered: modeView.currentIndex = index;
					
					onClicked: {
						if (!row.unlocked)
							return;
						
						console.debug(role_mode + " Mode clicked.");
						modeClicked(role_mode);
					}
				}
				
			}	//	Row: row
		}	//	Component: modelDelegate
	}	//	ListView: modeView
	
}
