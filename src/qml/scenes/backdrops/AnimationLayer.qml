import Felgo 3.0
import QtQuick 2.0

import "../../js/Math.js" as JMath

Scene {
	id: scene
	
	//	"logical size"
	width: 480
	height: 320
	
	property var bannerQueue: []
	property var animationQueue: []
	property var currentBanner
	
	Rectangle {
		id: background
		anchors.fill: parent
		color: "#00dcff"
	}
	
	//	spawns math in the background
	Timer {
		id: spawnTimer
		
		property var mathComponent: Qt.createComponent("../../common/AnimatedMath.qml")
		property var textComponent: Qt.createComponent("../../common/AnimatedText.qml")
		property int counter: 0
		
		interval: 10000
		repeat: true
		running: true
		triggeredOnStart: true
		
		onTriggered: {
			if (mathComponent.status !== Component.Ready)
			{
				console.debug("Math Component not ready.");
				console.error(mathComponent.errorString());
				return;
			}
			
			if (textComponent.status !== Component.Ready)
			{
				console.debug("Text Component not ready.");
				console.error(textComponent.errorString());
				return;
			}
			
			var readySpawn = false;
			var text, fontSize = 10;
			var component, parent, visibleListener;
			var isBanner = false;
			var isText = false;
			
			if (bannerQueue.length > 0)
			{
				var bannerQueueObj = bannerQueue[0];
				
				if (!currentBanner)
				{
					bannerQueue = bannerQueue.slice(1);
					
					text = bannerQueueObj.text;
					parent = bannerQueueObj.parentObject ? bannerQueueObj.parentObject : scene;
					visibleListener = bannerQueueObj.visibleListener ? bannerQueueObj.visibleListener : scene;
					fontSize = bannerQueueObj.fontSize ? bannerQueueObj.fontSize : 40;
					component = textComponent;
					
					isBanner = true;
					readySpawn = true;
				}
			}
			
			if (!readySpawn && animationQueue.length > 0)
			{
				var queueObj = animationQueue[0];
				
				//	pop the object from the queue
				animationQueue = animationQueue.slice(1);
				
				text = queueObj.text;
				parent = queueObj.parentObject ? queueObj.parentObject : scene;
				visibleListener = queueObj.visibleListener ? queueObj.visibleListener : scene;
				fontSize = queueObj.fontSize ? queueObj.fontSize : 30;
				component = textComponent;
				
				
				if (text.substr(0, 5) === "#math")
				{
					text = text.substr(5);	//	strip the text
					component = mathComponent;	//	select a better component
				}
				
				isText = true;
				readySpawn = true;	//	ready to spawn!
					
			}
			
			if (!readySpawn)
			{
				component = mathComponent;
				parent = scene;
				visibleListener = scene;
				fontSize = counter % 2 == 0 ? 60 : 30;
				readySpawn = true;
				
				if (counter % 2 == 0)
				{
					text = JMath.choose(['+', '-', '*', '/']);
				}
				else
				{
					var d = JMath.randI(2, 10);
					text = JMath.randI(1, d) + '/' + d;
				}
			}
				
			
			
			var props = {
				z: parent === scene ? 1 : -1,
//				opacity: visibleListener === scene ? 0.1 : Qt.binding(function() { return visibleListener.state === "show" && opacity != 0 ? 0.1 : 0; }),
				opacity: 0.1,
				
				text: text,
				fontSize: fontSize,
				
				from: parent.width,
				property: "x",
				speed: 15,
			};
			
			var obj = component.createObject(parent, props);
			obj.to = -obj.width;	//	set to after creating obj to determine width
			
			//	set a random y position
			if (isBanner)
				obj.y = animationLargerYBound - obj.height;	//	fixed for banners
			else if (isText)
				obj.y = JMath.randI(animationSmallerYBound, animationLargerYBound - obj.height - (currentBanner ? 40 : 0));
			else if (!isText && !isBanner)
				obj.y = JMath.randI(0, parent.height - obj.height);	//	set y after creating obj to determine height
			
			if (isBanner) { currentBanner = obj; bannerTimer.run(obj.duration); }
			
			obj.opacity = visibleListener === scene ? 0.1 : Qt.binding(function() { return visibleListener.state !== "show" || (visibleListener.state === "show" && obj.opacity !== 0.1) ? 0 : 0.1; }),
			
			
			obj.start();
			
			counter++;
			
			//	reset timer interval to a random time
			spawnTimer.interval = JMath.randI(6000, 8000);
			
			//	TODO add secret achievement: when player click an animation (euler?)
		}
	}
	
	Timer {
		id: bannerTimer
		
		
		function run(duration) {
			interval = duration;
			start();
		}
		
		onTriggered: {
			currentBanner = undefined;
		}
	}
}
