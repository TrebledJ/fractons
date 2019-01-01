//	ButtonBase.qml

import QtQuick 2.0
import VPlay 2.0

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
	property alias textBase: buttonText
	
	property real diagonalScalar: 1
	property bool animateText: true
	
	//	private variables
	QtObject {
		id: priv
		property bool isPressedFlag: false
		property real tempScalar: -1
	}
	
	// button background
	Rectangle {
		id: background
		color: mouseArea.containsMouse ? hoverColor : defaultColor
//		anchors.fill: parent
		
		x: -((diagonalScalar - 1) * parent.width / 2)
		y: -((diagonalScalar - 1) * parent.height / 2)
		width: parent.width * diagonalScalar
		height: parent.height * diagonalScalar
	}
	
	// button text
	TextBase {
		id: buttonText
		anchors.fill: parent
		anchors.centerIn: background
		
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		
		font.pixelSize: animateText ? 14 * diagonalScalar : 14
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
	
	//	animates a bubble
	onPressed: {
		//	check animations
		if (scalarAnimation.running)
			return;
		
		if (priv.isPressedFlag)
		{
			console.error("ButtonBase.qml:onPressed :: Unexpected value for priv.isPressed: true; expected: false.");
			return;
		}
		
		priv.isPressedFlag = true;	//	turns on flag
		priv.tempScalar = diagonalScalar;	//	stores the original radius in a private variable just in case
		animateScalar(1, 1.05);	//	animate
	}
	
	onReleased: {
		//	check was pressed (might change later on)
		if (!priv.isPressedFlag)
			return;
		
		priv.isPressedFlag = false;	//	turn off pressed flag
		
		//	check animation is running
		if (scalarAnimation.running)
		{
			if (priv.tempScalar === -1)
			{
				console.error("CircleButton.qml:onReleased :: Unexpected value for priv.tempRadius: -1; expected: <positive_real_value>.")
				return;
			}
			
			scalarAnimation.stop();	//	stop the animation
			animateScalar(diagonalScalar, priv.tempScalar);	//	animate to tempScalar
			priv.tempScalar = 1;	//	reset to 1
			return;
		}
		
		animateScalar(1.05, 1);	//	animate normally
	}
	
	onEntered: {
		animateScalar(0.75, 1);
	}
	
	NumberAnimation on diagonalScalar {
		id: scalarAnimation
	}
	
	//	convenience function to use above animation to animate radius
	function animateScalar(from, to, duration, type, overshoot) {
		if (scalarAnimation.running)
			return;
		
		from = (from !== undefined ? from : 0.75);
		to = (to !== undefined ? to : 1);
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
}
