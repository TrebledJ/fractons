//	CircleButton.qml

import Felgo 3.0
import QtQuick 2.0

/**
  Note, when using CircleButton, don't specify width/height
  
  Only specify the radius
  */

Item {
	id: button
	
	// public events
	signal clicked
	signal pressed
	signal released
	signal entered
	
	property real radius
	width: 2 * radius
	height: width
	
	property string color
	property string defaultColor: "navy"
	property string hoverColor: "yellow"
	property alias text: buttonText.text
	property alias background: background
	
	//	private variables
	QtObject {
		id: priv
		property bool isPressedFlag: false
		property real tempRadius: -1
	}
	
	// button background
	Rectangle {
		id: background
		color: mouseArea.containsMouse ? hoverColor : defaultColor
		
		width: parent.width
		height: parent.height
		
		radius: button.radius
		
		x: -radius
		y: -radius
	}
	
	// button text
	TextBase {
		id: buttonText
		anchors.centerIn: background
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
		if (radiusAnimation.running)
			return;
		
		if (priv.isPressedFlag)
		{
			console.error("CircleButton.qml:onPressed :: Unexpected value for priv.isPressed: true; expected: false.");
			return;
		}
		
		priv.isPressedFlag = true;	//	turns on flag
		priv.tempRadius = radius;	//	stores the original radius in a private variable just in case
		animateRadius(radius, radius+5);	//	animate
	}
	
	onReleased: {
		//	check was pressed (might change later on)
		if (!priv.isPressedFlag)
			return;
		
		priv.isPressedFlag = false;	//	turn off pressed flag
		
		//	check animation is running
		if (radiusAnimation.running)
		{
			if (priv.tempRadius === -1)
			{
				console.error("CircleButton.qml:onReleased :: Unexpected value for priv.tempRadius: -1; expected: <positive_real_value>.")
				return;
			}
			
			radiusAnimation.stop();	//	stop the animation
			animateRadius(radius, priv.tempRadius);	//	animate to tempRadius
			priv.tempRadius = -1;	//	reset to -1
			return;
		}
		
		animateRadius(radius, radius-5);	//	animate normally
	}
	
	onEntered: {
		animateRadius(radius/2, radius);
	}
	
	NumberAnimation on radius {
		id: radiusAnimation
	}
	
	//	convenience function to use above animation to animate radius
	function animateRadius(from, to, duration, type, overshoot) {
		if (radiusAnimation.running)
			return;
		
		from = (from !== undefined ? from : radius / 2);
		to = (to !== undefined ? to : radius);
		duration = (duration !== undefined ? duration : 500);
		type = (type !== undefined ? type : Easing.OutBack);
		overshoot = (overshoot!== undefined ? overshoot : 3);
		
		radiusAnimation.from = from;
		radiusAnimation.to = to;
		radiusAnimation.duration = duration;
		radiusAnimation.easing.type = type;
		radiusAnimation.easing.overshoot = overshoot;
		
		radiusAnimation.start();
	}
}
