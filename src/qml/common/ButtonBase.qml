//	ButtonBase.qml

import QtQuick 2.0
import Felgo 3.0

/*
  
// EXAMPLE USAGE:
// add this piece of code in your Scene to display the Button

ButtonBase {
  text: "Click Me!"
  width: 80
  height: 40
  anchors.centerIn: parent
  
  onClicked: {
	console.log("Clicked!")
  }
}

*/

Item {
	id: button
	
	// public events
	signal clicked
	signal pressed
	signal released
	signal entered
	
	property string color
	property string defaultColor: "navy"
	property string hoverColor: "yellow"
	property alias text: buttonText.text
	property alias font: buttonText.font
	property alias background: background
	property alias mouseArea: mouseArea
	property alias textObj: buttonText
	
	property real diagonalScalar: 1
	property bool animateText: false
	property real padding: 2
	
	// button background
	Rectangle {
		id: background
		color: mouseArea.containsMouse ? hoverColor : defaultColor
		anchors.fill: parent
	}
	
	// button text
	TextBase {
		id: buttonText
		anchors.fill: parent
		anchors.centerIn: background
		anchors.margins: padding
		
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		
		font.pointSize: animateText ? 14 * diagonalScalar : 14
	}
	
	// mouse area to handle click events
	MouseArea {
		id: mouseArea
		anchors.fill: background
		hoverEnabled: true
		
		onPressed: button.pressed()
		onReleased: button.released()
		onClicked: button.clicked()
		onEntered: button.entered()
	}
	
	onColorChanged: {
		defaultColor = color;
		hoverColor = color;
	}
	
	// change opacity on pressed and released events, so we have a "pressed" state
	onPressed: {
		opacity = 0.9
	}
	
	onReleased: {
		opacity = 1.0
	}
	
}
