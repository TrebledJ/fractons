import QtQuick 2.0

import "../graphicmath"

Item {
	id: animatedMath
	
	property alias text: math.text
	property alias fontsize: math.fontsize
	property alias from: animatedMath.x
	property alias to: animation.to
	property alias property: animation.property
	property real speed: 30
	readonly property alias duration: animation.duration
	
	function start() {
		animation.duration = Math.abs(to - animatedMath.from)/speed * 1000;	//	speed = distance / time
		animation.start();
	}
	
	width: math.contentWidth; height: math.contentHeight
	
	Equation { id: math }
	
	NumberAnimation {
		id: animation
		target: animatedMath
		property: 'x'
		onStopped: animatedMath.destroy();	//	self-destruct
	}
}
