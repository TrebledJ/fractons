//	SceneBase.qml

import Felgo 3.0
import QtQuick 2.0

import "../../common"
import "../../js/Math.js" as JMath

Scene {
	id: scene
	
	//	"logical size"
	width: 480
	height: 320
	z: -1
	signal backButtonClicked
	
	property alias backgroundAnimationTimer: backgroundAnimationTimer
	
	property bool useDefaultBackButton: true
	
	property int animationSmallerYBound: 0
	property int animationLargerYBound: height
	
	
	opacity: 0
	visible: opacity != 0
	enabled: state == "show"
	
	Behavior on opacity {
		NumberAnimation { easing.type: Easing.Linear; duration: 300 }
	}
	
	state: "hide"
	states: [
		State {
			name: "show"
			when: gameWindow.activeScene === scene
			PropertyChanges { target: scene; opacity: 1 }
		},
		State {
			name: "hide"
			when: gameWindow.activeScene !== scene
			PropertyChanges { target: scene; opacity: 0 }
		}
	]
	
	BubbleButton {
		width: 60; height: 30
		anchors {
			top: parent.top
			left: parent.left
			margins: 10
		}
		
		z: 1
		
		visible: useDefaultBackButton
		
		text: "Back"
		
		onClicked: backButtonClicked();
	}
	
	
	Timer {
		id: backgroundAnimationTimer
		
		property var messageQueue: []
		
		property string message
		property var parent_
		property var visibleListener
		property int fontSize
		
		//	use a timer to prevent spammy messages
		interval: 1000
		
		onTriggered: {
			if (state === "show")
			{
				var front = messageQueue[0];
				messageQueue = messageQueue.slice(1);
				pushBackgroundAnimation(front.message, front.parent, front.visibleListener, front.fontSize);	//	animate the mode name onto the background
			}
			
			check();
		}
		
		function check() {
			if (messageQueue.length > 0 && !running)
				start();
		}
		
		function run(message, parent_, visibleListener, fontSize) {
			console.log("Pushing message:", message);
			messageQueue.push({
								 message: message,
								  parent: parent_,
								  visibleListener: visibleListener,
								  fontSize: fontSize
							  });
			
			check();
		}
		
		function cancel(message) {
			stop();
			
			console.log("Cancel message:", message);
			var index = messageQueue.map(function(item){ return item.message }).lastIndexOf(message);
			messageQueue = messageQueue.slice(0, index).concat(messageQueue.slice(index + 1));	//	remove index "index"
			
			check();
		}
	}
}
