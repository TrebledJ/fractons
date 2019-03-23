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
	property bool readyNotify: false
	
	Rectangle {
		id: notification
		width: Math.max(titleText.contentWidth+20, messageText.contentWidth+20, 150)
		height: titleText.contentHeight + messageText.contentHeight + 20
		radius: 5
		anchors {
			top: parent.top
			right: parent.right
			rightMargin: hide ? -width : 5
			margins: 5
		}
		
		property string title
		property string message
		property int seconds
		property bool hide: true
		
		border.width: 3
		border.color: "lightgoldenrodyellow"
		
		color: "navy"
		
		visible: anchors.rightMargin > -width
		
		onVisibleChanged: {
			if (visible === false)
				readyNotify = true;
		}
		
		Behavior on anchors.rightMargin {
			NumberAnimation {
				duration: 1000
				easing.type: Easing.InOutQuad
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
				
				text: notification.title
				color: "yellow"
				font.pointSize: 12
			}
			
			TextBase {
				id: messageText
				width: parent.width
				
				text: notification.message
				color: "yellow"
				font.pointSize: 8
				wrapMode: Text.WordWrap
			}
		}
		
		MouseArea {
			anchors.fill: parent
			onClicked: notification.hide = true
		}
	}
	
	Timer {
		id: notificationTimer
		interval: notification.seconds
		repeat: false
		
		onTriggered: {
			notification.hide = true;
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
	
	onReadyNotifyChanged: {
		//	run the queue if notifications are ready
		if (readyNotify)
			runNextQueueItem();
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
		
		notification.title = obj.title;
		notification.message = obj.message;
		notification.seconds = obj.seconds * 1000 * 2;
		
		notification.hide = false;
		notificationTimer.start();
		
		readyNotify = false;
		
		//	emit a signal
		queueModified();
	}
	
}
