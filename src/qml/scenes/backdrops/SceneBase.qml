//	SceneBase.qml

import Felgo 3.0
import QtQuick 2.0

import "../../common"
import "../../js/Math.js" as JMath

Scene {
	id: scene
	//	TODO add background animation
	//	TODO find/create math symbols for background animation
	
	//	"logical size"
	width: 480
	height: 320
	
	signal backButtonClicked
	
	property bool useDefaultBackButton: true
	
	property alias color: background.color
	
	
	opacity: 0
//	opacity: 1
	visible: !(opacity == 0)
	enabled: visible
	
//	state: visible ? "in" : "out"
	states: [
		State {
			name: "show"
			PropertyChanges { target: scene; opacity: 1 }
		},
		State {
			name: "hide"
			PropertyChanges { target: scene; opacity: 0 }
		}
	]
	
	Rectangle {
		id: background
		z: -10
		anchors.fill: parent
		
		color: "#00dcff"
	}
	
	
	BubbleButton {
		width: 60; height: 30
		anchors {
			top: parent.top
			left: parent.left
			margins: 10
		}
		color: "yellow"
		
		visible: useDefaultBackButton
		
		text: "Back"
		
		onClicked: backButtonClicked();
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
				z: -1,
				visible: Qt.binding(function() { return scene.visible; }),
				opacity: 0.1,
				
//				text: JMath.choose(counter % 2 == 0 ? ['+', '-', '*', '/'] : ['1/2', '1/3', '2/3', '1/4', '1/5']),
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
