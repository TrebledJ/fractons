import Felgo 3.0
import QtQuick 2.0

import "../../js/Math.js" as JMath

Scene {
	id: scene
	
	//	"logical size"
	width: 480
	height: 320
	
	Rectangle {
		id: background
		anchors.fill: parent
		color: "#00dcff"
	}
	
	//	spawns math in the background
	Timer {
		id: spawnTimer
		
		property var component: Qt.createComponent("../../game/AnimatedMath.qml")
		property int counter: 0
		
		interval: 10000
		repeat: true
		running: true
		triggeredOnStart: true
		
		onTriggered: {
			if (component.status !== Component.Ready)
			{
				console.debug("Component not ready.");
				console.error(component.errorString());
				return;
			}
			
			var text;
			if (counter % 2 == 0)
			{
				text = JMath.choose(['+', '-', '*', '/']);
			}
			else
			{
				var d = JMath.randI(2, 10);
				var n = JMath.randI(1, d);
				text = n + '/' + d;
			}
			
			var props = {
				y: JMath.randI(0, parent.height),
				z: 1,
				visible: Qt.binding(function() { return scene.visible; }),
				opacity: 0.1,
				
				text: text,
				fontSize: counter % 2 == 0 ? 60 : 30,
				
				from: parent.width,
				property: "x",
				speed: 10,
			};
			
			var obj = component.createObject(scene, props);
			obj.y = JMath.randI(0, scene.height - obj.height);	//	set y after creating obj to determine height
			obj.to = -obj.width;	//	set to after creating obj to determine width
			obj.start();
			
			counter++;
			
			//	reset timer interval to a random time
			spawnTimer.interval = JMath.randI(8000, 10000);
			
			//	TODO add secret achievement: when player click an animation (euler?)
		}
	}
}
