import QtQuick 2.0

Item {
	id: animatedText
	width: text.contentWidth; height: text.contentHeight
	
	property alias text: text.text
	property alias fontSize: text.font.pointSize
	
	property alias from: animatedText.x
	property alias to: animation.to
	property alias property: animation.property
	property real speed: 30
	readonly property alias duration: animation.duration
	
	property alias opacityAnimation: opacityAnimation
	
	TextBase {
		id: text
	}
	
	NumberAnimation {
		id: animation
		target: animatedText
		property: 'x'
		
		duration: Math.abs(to - animatedText.from)/speed * 1000	//	speed = distance / time
		
		onStopped: animatedText.destroy();	//	self-destruct
	}
	
	Behavior on opacity {
		PropertyAnimation {
			id: opacityAnimation
			duration: 3000
		}
	}
	
	
	function start() {
		animation.start();
	}
}
