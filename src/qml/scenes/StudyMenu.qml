import VPlay 2.0
import QtQuick 2.0

import "backdrops"
import "../common"

SceneBase {
	id: sceneBase
	
	signal lessonClicked(string lesson)
	
	ListModel {
		id: lessonModel
		
		ListElement { role_stars: 0; role_shorthand: "zero"; role_lesson: "Introduction to Fractions" }
		ListElement { role_stars: 0; role_shorthand: "one"; role_lesson: "Adding and Subtracting Fractions of Like Denominators" }
		ListElement { role_stars: 0; role_shorthand: "two"; role_lesson: "Multiplying and Dividing Fractions" }
		ListElement { role_stars: 0; role_shorthand: "three"; role_lesson: "Adding and Subtracting Fractions of Unlike Denominators" }
		ListElement { role_stars: 0; role_shorthand: "four"; role_lesson: "Converting from Fractions to Decimals" }
		ListElement { role_stars: 0; role_shorthand: "five"; role_lesson: "Converting from Decimals to Fractions" }
		ListElement { role_stars: 0; role_shorthand: "six"; role_lesson: "Balancing Equations" }
		ListElement { role_stars: 0; role_shorthand: "seven"; role_lesson: "Checking the Equality of Fractions" }
		ListElement { role_stars: 0; role_shorthand: "eight"; role_lesson: "Comparing Fractions" }
	}
	
	ListView {
		id: lessonView
		
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
		model: lessonModel
		delegate: lessonDelegate
		header: headerDelegate
		
		ScrollBar.vertical: ScrollBar {
			anchors.left: lessonView.right
			active: true
		}
		
		Component {
			id: headerDelegate
			
			Item {
				z: 3
				width: lessonView.width - 10; height: 40
				
				Rectangle {
					anchors.fill: parent
					color: "yellow"
					
					TextBase {
						anchors.centerIn: parent
						text: "Lessons"
					}
				}
			}
			
		}	//	Component: headerDelegate
		
		Component {
			id: lessonDelegate
			
			//	a row for each list element
			Row {
				id: row
				width: lessonView.width; height: 40
				spacing: 20
				
				clip: true
				
				Rectangle {
					id: starsRect
					width: 100; height: parent.height
					
					color: "black"	//	4 DEBUG
					opacity: 0.6
				}
				
				//	displays lesson name with button function
				BubbleButton {
					id: lessonRect
					width: parent.width - parent.spacing - starsRect.width - 15; height: parent.height
					color: "yellow"
					
					background.radius: 5
					background.border.width: 3
					
					text: "" + role_lesson + ""
					textBase.horizontalAlignment: Text.AlignRight
					textBase.anchors.margins: 10
					textBase.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
					font.pointSize: 10
					animateText: false
					
					
					onEntered: {
						lessonView.currentIndex = index;
					}
					
					onClicked: {
						console.debug('"' + role_lesson + '" (aka ' + role_shorthand + ')', " Lesson clicked.");
						lessonClicked(role_shorthand);
					}
				}
				
				Component.onCompleted: {
					
					lessonRect.background.border.color = Qt.binding(function() {
						return ListView.isCurrentItem ? "navy" : "transparent";
					});
				}
				
			}	//	Row: row
		}	//	Component: lessonDelegate
	}	//	ListView: lessonView
}
