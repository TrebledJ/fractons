import QtQuick 2.11
import QtQuick.Controls 2.2

import "../backdrops"
import "../../common"

SceneBase {
	id: sceneBase
	
	signal lessonClicked(string lesson)
	
	useDefaultTopBanner: true
	
	ListModel {
		id: lessonModel
		
		ListElement { role_stars: 0; role_shorthand: "intro"; role_lesson: "Introduction to Fractions" }
//		ListElement { role_stars: 0; role_shorthand: "parts-of-a-whole"; role_lesson: "Fractions as Parts of a Whole" }	//	introduce more fractions, images of blocks and parts of whole
		ListElement { role_stars: 0; role_shorthand: "balancing"; role_lesson: "Balancing Fractions" }			//	introduce to balancing fractions, what we do to one side must also be done to the other
//		ListElement { role_stars: 0; role_shorthand: "simplify-gcd"; role_lesson: "Simplifying Fractions by the GCD" }  // introduce the gcd and using it to simplify fractions
//		ListElement { role_stars: 0; role_shorthand: "div-by-zero"; role_lesson: "Division by Zero" }	//	discuss the caveats of division by 0
//		ListElement { role_stars: 0; role_shorthand: "improper"; role_lesson: "Improper Fractions" }		//	discuss improper fractions (numerator > denominator)
//		ListElement { role_stars: 0; role_shorthand: "fractions-to-decimals"; role_lesson: "Converting from Fractions to Decimals" }	//	connect fractions with decimals and discuss conversion
//		ListElement { role_stars: 0; role_shorthand: "decimals-to-fractions"; role_lesson: "Converting from Decimals to Fractions" }
//		ListElement { role_stars: 0; role_shorthand: "checking-equality"; role_lesson: "Checking the Equality of Fractions" }
		ListElement { role_stars: 0; role_shorthand: "adding-subtracting-like"; role_lesson: "Adding and Subtracting Fractions of Like Denominators" }	//	introduce operations (addition/subtraction) with fractions
//		ListElement { role_stars: 0; role_shorthand: "multiplying-dividing"; role_lesson: "Multiplying and Dividing Fractions" }	//	introduce multiplication and division with fractions
//		ListElement { role_stars: 0; role_shorthand: "adding-subtracting-unlike"; role_lesson: "Adding and Subtracting Fractions of Unlike Denominators" }	//	introduce addition/subtraction with fractions
//		ListElement { role_stars: 0; role_shorthand: "probability"; role_lesson: "Basic Probabilty" }	//	introduce probability
	}
	
	ListView {
		id: lessonView
		
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
		
		headerPositioning: ListView.OverlayHeader
		boundsBehavior: Flickable.StopAtBounds
		
		focus: true
		model: lessonModel
		delegate: lessonDelegate
		
		ScrollBar.vertical: ScrollBar {
			anchors.left: lessonView.right
			active: true
		}
		
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
					background.border.width: 3
					text: "" + role_lesson + ""
					textObj.horizontalAlignment: Text.AlignRight
					textObj.anchors.margins: 10
					textObj.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
					textObj.animate: false
					textObj.firmAnchor: true
					font.pointSize: 10
					
					onEntered: lessonView.currentIndex = index;
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
