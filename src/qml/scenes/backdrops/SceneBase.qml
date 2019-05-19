//	SceneBase.qml

import Felgo 3.0
import QtQuick 2.0

import "../../common"
import "../../game/singles"

import "../../js/Math.js" as JMath
import "../../js/Utils.js" as JUtils

Scene {
	id: scene
	
	signal backButtonClicked
	
	property alias backgroundAnimationTimer: backgroundAnimationTimer
	property alias banner: banner
	property bool useDefaultTopBanner: false
	property bool useDefaultBackButton: true
	property int animationSmallerYBound: 0
	property int animationLargerYBound: height
	readonly property bool shown: shownState.state === "show"
	
	z: -1
	width: 480; height: 320
	
	visible: opacity != 0
	opacity: 0
	enabled: shown
	
	function show() {
		shownState.state = "show";
	}
	
	function hide() {
		shownState.state = "hide";
	}
	
	Item {
		id: shownState
		state: "hide"
		states: [
			State { name: "show"; when: gameWindow.activeScene === scene; PropertyChanges { target: scene; opacity: 1 } },
			State { name: "hide"; when: gameWindow.activeScene !== scene; PropertyChanges { target: scene; opacity: 0 } }
		]
	}
	
	Rectangle {
		id: banner
		anchors.top: parent.top
		z: 1
		width: parent.width; height: 50
		color: "navy"; visible: useDefaultTopBanner
	}
	
	NotificationButton {
		anchors { top: parent.top; left: parent.left; margins: 10 }
		z: 1
		width: 60; height: 30
		
		text: "Back"
		nCircleText: JGameNotifications.unread
		visible: useDefaultBackButton
		nCircleVisible: JGameNotifications.unread > 0
		
		onClicked: backButtonClicked();
	}
	
	
	Timer {
		id: backgroundAnimationTimer
		
		property var messageQueue: []
		
		
		//	== JS FUNCTIONS ==
		
		function check() {
			if (messageQueue.length > 0 && !running)
				start();
		}
		
		function run(message, parent_, visibleListener, fontsize) {
			console.log("Pushing message:", message);
			messageQueue.push({
								 message: message,
								  parent: parent_,
								  visibleListener: visibleListener,
								  fontsize: fontsize
							  });
			check();
		}
		
		function cancel(message) {
			stop();
			
			console.log("Cancel message:", message);
			var index = messageQueue.map(function(item){ return item.message; }).lastIndexOf(message);
			messageQueue = JUtils.popArray(messageQueue, index);	//	remove index "index"
			
			check();
		}
		
		//	use a timer to prevent spammy messages
		interval: 1000
		
		onTriggered: {
			if (shown)
			{
				let front = messageQueue[0];
				messageQueue = messageQueue.slice(1);
				pushBackgroundAnimation(front.message, front.parent, front.visibleListener, front.fontsize);	//	animate the mode name onto the background
			}
			
			check();
		}
	}
	
	Behavior on opacity { NumberAnimation { easing.type: Easing.Linear; duration: 300 } }
}
