//	SceneBase.qml

import VPlay 2.0
import QtQuick 2.0

Scene {
	//	TODO add background animation
	//	TODO find/create math symbols for background animation
	
	//	"logical size"
	width: 480
	height: 320
	
	opacity: 0
	visible: opacity > 0
	enabled: visible
	
	property alias color: background.color
	
	Rectangle {
		id: background
		
		anchors.fill: parent
		color: "#00dcff"
	}

}
