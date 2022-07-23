import QtQuick 2.0

Item {
	id: animatedButton
	
	property alias button: button
	property alias from: animatedButton.x
	property alias to: animation.to
	property alias property: animation.property
	property real speed: 30
	readonly property alias duration: animation.duration
	
	function start() { animation.start(); }
	
	width: 80; height: 80
	
	BubbleButton { id: button; anchors.fill: parent; color: "transparent" }
	
	NumberAnimation {
		id: animation
		target: animatedButton
		property: 'x'
		duration: Math.abs(to - animatedButton.from)/speed * 1000	//	speed = distance / time
		onStopped: animatedButton.destroy();	//	self-destruct
	}
	
	Behavior on opacity { NumberAnimation { duration: 1000; easing.type: Easing.InSine } }
}
