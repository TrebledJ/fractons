import VPlay 2.0
import QtQuick 2.0

import "../graphicmath"

Item {
	id: animatedMath
	width: math.contentWidth; height: math.contentHeight
	
	property alias text: math.text
	property alias fontSize: math.fontSize
	
	property alias from: animatedMath.x
	property alias to: animation.to
	property alias property: animation.property
	property real speed: 30
	
	Equation {
		id: math
	}
	
	NumberAnimation {
		id: animation
		target: animatedMath
		property: 'x'
		
		onStopped: animatedMath.destroy();	//	self-destruct
	}
	
	function start() {
		animation.duration = Math.abs(to - animatedMath.from)/speed * 1000;	//	speed = distance / time
		animation.start();
	}
}
