//	ButtonBase.qml

import QtQuick 2.11
import Felgo 3.0

/*
  
// EXAMPLE USAGE:
// add this piece of code in your Scene to display the Button

BubbleButton {
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
	signal exited
	
	property string color
	property string defaultColor: "navy"
	property string hoverColor: "yellow"
	property alias text: buttonText.text
	property alias font: buttonText.font
	property alias background: background
	property alias mouseArea: mouseArea
	property alias textBase: buttonText
	
	property real diagonalScalar: defaultDiagonal
	property bool animateText: true
	
	//	these From-To values will be used for animation purposes
	property real enteredFrom: 0.75
	property real enteredTo: defaultDiagonal
	
	property real pressedFrom: 0.9
	property real pressedTo: 1.05
	
	property real releasedFrom: pressedTo
	property real releasedTo: defaultDiagonal
	
	property real defaultDiagonal: 1
	
	property bool checked: false
	property bool isCheckButton: false
	state: checked ? "on" : "off"
	
	//	private variables
	QtObject {
		id: priv
		property bool isPressedFlag: false
	}
	
	// button background
	Rectangle {
		id: background

		x: -((diagonalScalar - 1) * parent.width / 2)
		y: -((diagonalScalar - 1) * parent.height / 2)
		width: parent.width * diagonalScalar
		height: parent.height * diagonalScalar
		radius: 5
		
		color: mouseArea.containsMouse ? hoverColor : defaultColor
		opacity: isCheckButton ? checked ? 1 : 0.5 : parent.opacity
	}
	
	// button text
	TextBase {
		id: buttonText
		anchors.fill: parent
		anchors.centerIn: background
		
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
		onExited: button.exited()
		
		onContainsPressChanged: {
			if (!containsPress)
				animateExitPress();
		}
	}
	
	onColorChanged: {
		defaultColor = color;
		hoverColor = color;
	}
	
	//	animates a bubble
	onPressed: {
		//	check animations
		if (scalarAnimation.running)
			return;
		
		if (priv.isPressedFlag)
		{
			console.error("BubbleButton.qml:onPressed :: Unexpected value for priv.isPressed: true; expected: false.");
			return;
		}
		
		priv.isPressedFlag = true;	//	turns on flag
		animateScalar(pressedFrom, pressedTo);	//	animate
	}
	
	onReleased: {
		if (isCheckButton)
			checked = !checked;
		
		animateExitPress();
	}
	
	onEntered: {
		animateScalar(enteredFrom, enteredTo);
	}
	
	NumberAnimation on diagonalScalar {
		id: scalarAnimation
	}
	
	//	convenience function to use above animation to animate radius
	function animateScalar(from, to, duration, type, overshoot) {
		if (scalarAnimation.running)
			return;
		
		from = (from !== undefined ? from : pressedFrom);
		to = (to !== undefined ? to : pressedTo);
		duration = (duration !== undefined ? duration : 500);
		type = (type !== undefined ? type : Easing.OutBack);
		overshoot = (overshoot!== undefined ? overshoot : 3);
		
		scalarAnimation.from = from;
		scalarAnimation.to = to;
		scalarAnimation.duration = duration;
		scalarAnimation.easing.type = type;
		scalarAnimation.easing.overshoot = overshoot;
		
		scalarAnimation.start();
	}
	
	function animateExitPress() {
		//	check was pressed (might change later on)
		if (!priv.isPressedFlag)
			return;
		
		priv.isPressedFlag = false;	//	turn off pressed flag
		
		//	check animation is running
		if (scalarAnimation.running)
		{
			scalarAnimation.stop();	//	stop the animation
			animateScalar(diagonalScalar, releasedTo);
			return;
		}
		
		animateScalar(releasedFrom, releasedTo);	//	animate normally
	}
	
}
