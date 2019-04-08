//	ButtonBase.qml

import QtQuick 2.11

import "../game/singles"

Item {
	id: button
	
	//	== SIGNAL & PROPERTY DECLARATIONS ==
	
	// public events
	signal clicked
	signal pressed
	signal released
	signal entered
	signal exited
	
	property string color
	property string defaultColor: "yellow"
	property string hoverColor: "yellow"
	property alias text: buttonText.text
	property alias font: buttonText.font
	property alias background: background
	property alias mouseArea: mouseArea
	property alias textObj: buttonText
	property alias image: image
	
	property bool bubbleOn: true
	property real diagonalScalar: defaultDiagonal
	
	//	these From-To values will be used for animation purposes
	property real enteredFrom: bubbleOn ? 0.75 : 1
	property real enteredTo: bubbleOn ? defaultDiagonal : 1
	
	property real pressedFrom: bubbleOn ? 0.9  : 1
	property real pressedTo: bubbleOn ? 1.05 : 1
	
	property real releasedFrom: bubbleOn ? pressedTo : 1
	property real releasedTo: bubbleOn ? defaultDiagonal : 1
	
	//	the diagonal is crucial in bubbling
	property real defaultDiagonal: 1
	
	property bool isCheckButton: false
	property bool checked: false
	
	
	//	== JS FUNCTIONS ==
	
	//	convenience function to use above animation to animate radius
	function animateScalar(from, to, duration, type, overshoot) {
		if (scalarAnimation.running)
			return;
		
		from = (from !== undefined ? from : pressedFrom);
		to = (to !== undefined ? to : pressedTo);
		duration = (duration !== undefined ? duration : 400);
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
	
	
	//	== OBJECT PROPERTIES & SIGNAL-HANDLERS ==
	
	state: checked ? "on" : "off"
	
	onColorChanged: defaultColor = hoverColor = color;
	
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
		
		if (!bubbleOn)
			return;
		
		priv.isPressedFlag = true;	//	turns on flag
		
		animateScalar(pressedFrom, pressedTo);	//	animate
	}
	
	onReleased: {
		//	ACVM : buttons?
		JGameAchievements.addProgressByName("buttons?", 1);
		
		if (isCheckButton) checked = !checked;
		if (!bubbleOn) return;
		animateExitPress();
	}
	
	onEntered: {
		if (!bubbleOn) return;
		animateScalar(enteredFrom, enteredTo);
	}
	
	//	private variables
	QtObject {
		id: priv
		property bool isPressedFlag: false
	}
	
	// button background
	Rectangle {
		id: background
		x: -((diagonalScalar - 1) * parent.width / 2); y: -((diagonalScalar - 1) * parent.height / 2)
		width: parent.width * diagonalScalar; height: parent.height * diagonalScalar
		radius: 5
		color: mouseArea.containsMouse ? hoverColor : defaultColor
		opacity: isCheckButton ? checked ? 1 : 0.6 : parent.opacity
	}
	
	//	button image
	Image {
		id: image
		anchors { fill: background; margins: 5 }
		visible: source !== ""
		fillMode: Image.PreserveAspectFit
		mipmap: true
	}
	
	// button text
	TextBase {
		id: buttonText
		anchors { fill: firmAnchor ? parent: background; centerIn: background }
		horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
		font.pointSize: animate ? 14 * diagonalScalar : 14
		animate: true
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
			if (!bubbleOn) return;
			if (!containsPress) animateExitPress();
		}
	}
	
	NumberAnimation on diagonalScalar { id: scalarAnimation }
	
}
