import VPlay 2.0
import QtQuick 2.0

import "backdrops"
import "../common"

SceneBase {
	id: sceneBase
	
//	signal backButtonClicked
	
//	BubbleButton {
//		width: 50; height: 30
//		anchors {
//			top: parent.top
//			left: parent.left
//			margins: 10
//		}

//		text: "Back"
//		color: "yellow"
		
//		onClicked: backButtonClicked();
//	}
	
	TextBase {
		anchors.centerIn: parent
		text: "There ain't no study notes at this time. Check back later. :-)"
	}
	
}
