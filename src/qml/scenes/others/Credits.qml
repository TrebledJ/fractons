import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"

import "../../js/Math.js" as JMath
import "../../js/Utils.js" as JUtils

SceneBase {
	id: scene
	
	useDefaultBackButton: false
	
	property var objects: []
	property var messages: [
		{
			text: 'ƒractons was brought to you by TrebledJ.'
		},
		{
			text: 'Originally made with Flash/Actionscript 2.0 in 9<sup>th</sup> grade.'
		},
		{
			text: 'Now returning with Qt/QML and the Felgo SDK.'
		},
//		{
//			text: 'Icons, sounds, and music were gathered from a variety of online sources.'
//		},
		{
			text: 'Thanks for playing and enjoy!'
		}
	]
	
	Component {
		id: textComponent
		AnimatedText {
			fontsize: 32
			from: scene.width
			speed: 100
			opacityAnimation.duration: 250
		}
	}
	
	
	onShownChanged: {
		if (shown)
		{
			releaseTimer.begin();
		}
		else
		{
			
			for (var i = 0; i < objects.length; i++)
			{
				if (objects[i] !== undefined)
					objects[i].opacity = 0;
			}
			
			objects = [];
		}
	}
	
	Timer {
		id: releaseTimer
		
		property var releaseQueue: []
		
		onTriggered: {
			if (releaseQueue.length === 0)
			{
				backButtonClicked();
				return;
			}
			
			var text = releaseQueue[0].text;
			
			var obj = textComponent.createObject(scene);
			obj.text = text;
			obj.y = JMath.randI(20, scene.height - obj.height - 20);
			obj.to = -obj.width;
			obj.start();
			objects.push(obj);
			
			
			//	test for final item
			if (releaseQueue.length === 1)
			{
				//	t = d/v
				interval = (scene.width + obj.width + 200) / (obj.speed / 1000);
			}
			else
			{
				interval = (scene.width + obj.width - 150) / (obj.speed / 1000);
			}
			
			if (releaseQueue.length > 0)
			{
				releaseQueue = JUtils.popArray(releaseQueue, 0);
				start();
			}
		}
		
		function begin() {
			releaseQueue = JUtils.copyArray(messages);
			start();
		}
		
	}
	
	
	
	MouseArea {
		anchors.fill: parent
		onClicked: backButtonClicked()
	}
	
}	//	SceneBase
