import Felgo 3.0
import QtQuick 2.0

import "../../common"
import "../../game/singles"

Scene {
	id: scene
	
	//	"logical size"
	width: 480
	height: 320
	
	signal queueModified
	property var queue: []
	
	Timer {
		id: notificationTimer
		interval: 5000
		running: true
		
		onTriggered: {
			runNextQueueItem();
		}
	}
	
	Connections {
		target: JGameNotifications
		onMessage: /*string title, string message, int seconds*/ {
			
			//	push an object into the queue
			queue.push({
						   title: title,
						   message: message,
						   seconds: seconds
					   });
			queueModified();
			
		}
	}
	
	Component {
		id: notificationComponent
		
		Rectangle {
			id: notificationRect
			x: scene.width; y: scene.height / 2
			width: 150
			height: titleText.contentHeight + messageText.contentHeight + 20
			radius: 5

			property string title
			property string message
			property int seconds
			property real speed: 30 / 1000
			
			border.width: 3
			border.color: "lightgoldenrodyellow"
			
			color: "navy"
			opacity: 0.4
			
			Behavior on opacity {
				NumberAnimation {
					duration: 300
					easing.type: Easing.Linear
				}
			}
			
			onOpacityChanged: {
				if (opacity == 0)
					notificationRect.destroy();
			}
			
			SequentialAnimation {
				running: true
				NumberAnimation {
					target: notificationRect
					property: "x"
					from: scene.width; to: scene.width - notificationRect.width
					duration: 500
					easing.type: Easing.InOutBack
					
					onStarted: {
						console.log("x-animation has started")
					}
				}
				
				ParallelAnimation {
					NumberAnimation {
						target: notificationRect
						property: "y"
						to: 0 - notificationRect.height
						duration: (notificationRect.y + notificationRect.height) / notificationRect.speed
						easing.type: Easing.Linear
					}
					SequentialAnimation {
						PauseAnimation {
							duration: (notificationRect.y + notificationRect.height) / notificationRect.speed * 0.9
						}

						NumberAnimation {
							target: notificationRect
							property: "opacity"
							to: 0
							duration: (notificationRect.y + notificationRect.height) / notificationRect.speed * 0.1
							easing.type: Easing.InExpo
						}
					}
				}
			}
			
			Column {
				id: textColumn
				anchors.fill: parent
				anchors.centerIn: parent
				anchors.margins: 8
				spacing: 5
				
				TextBase {
					id: titleText
					width: parent.width
					
					text: notificationRect.title
					color: "yellow"
					font.pointSize: 12
				}
				
				TextBase {
					id: messageText
					width: parent.width
					
					text: notificationRect.message
					color: "yellow"
					font.pointSize: 8
					wrapMode: Text.WordWrap
				}
			}
			
			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				onClicked: notificationRect.opacity = 0
				onEntered: notificationRect.opacity = 0.9
				onExited: notificationRect.opacity = 0.4
			}
		}
	}
	
	onQueueModified: {
		if (notificationTimer.running)
			return;
		
		runNextQueueItem();
	}
	
	function runNextQueueItem() {
		if (queue.length == 0)
			return;
		
		var obj = queue[0];
		queue = queue.slice(1);	//	pop the front of the queue
		
		console.warn("Notify:", JSON.stringify(obj));
		
		obj.seconds *= 1000;
		var notification = notificationComponent.createObject(scene, obj);
		
		var v = notification.speed;
		var d = notification.height;
		notificationTimer.interval = d/v + 50;
		notificationTimer.start();
		
		//	emit a signal
		queueModified();
	}
	
}
