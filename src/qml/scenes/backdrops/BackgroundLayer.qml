import Felgo 3.0
import QtQuick 2.0

import "../../game/singles"
import "../../js/Math.js" as JMath

Scene {
	id: scene
	
	//	"logical size"
	width: 480
	height: 320
	
	property var animationQueue: []
	
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
		property var buttonComponent: Qt.createComponent("../../common/AnimatedButton.qml")
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
			var isText = false;
			
			//	choose animations from the animation queue
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
			
			//	default animations
			if (!readySpawn)
			{
				//	TODO increase to oneIn(1000)
				var mathOrImage = (JMath.oneIn(100) ? "image" : "math");
				
				parent = scene;
				visibleListener = scene;
				readySpawn = true;
				
				if (mathOrImage === "math")
				{
					component = mathComponent;
					fontSize = counter % 2 == 0 ? 60 : 30;
					
					if (counter % 2 == 0)
					{
						text = JMath.choose(['+', '-', '*', '/']);
					}
					else
					{
						var d = JMath.randI(2, 10);
						text = JMath.randI(1, d) + '/' + d;
					}
					
					counter++;
				}
				else if (mathOrImage === "image")
				{
					component = buttonComponent;
				}
				else 
				{
					console.error("Unknown animation format:", mathOrImage);
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
			if (isText)
				obj.y = JMath.randI(animationSmallerYBound, animationLargerYBound - obj.height);
			else /* !isText */
				obj.y = JMath.randI(0, parent.height - obj.height);	//	set y after creating obj to determine height
			
			obj.opacity = visibleListener === scene ? 0.1 : Qt.binding(function() { return visibleListener.state !== "show" || (visibleListener.state === "show" && obj.opacity !== 0.1) ? 0 : 0.1; });
			
			if (component === buttonComponent)
			{
				//  ACVM : euler, newton, gauss (secret)
				var person = JMath.choose(["euler", "newton", "gauss"])
				
				var imageSource = "qrc:/assets/icons/" + person;
				obj.button.image.source = imageSource;
				
				obj.button.entered.connect(function()
				{
					console.log("Image of", person, "entered!");
					obj.opacity = 1;
					JGameAchievements.addProgressByName(person, 1);
				});
			}
													  
			obj.start();
			
			//	reset timer interval to a random time
			spawnTimer.interval = JMath.randI(6000, 8000);
		}
	}
	
}
