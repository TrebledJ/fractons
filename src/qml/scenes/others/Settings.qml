import Felgo 3.0
import QtQuick 2.0

import "../../game/singles"
import "../backdrops"
import "../../common"

SceneBase {
	id: sceneBase
	
	Component.onCompleted: {
		//	load saved settings
		soundButton.checked = gameWindow.settings.getValue("soundEnabled");
		musicButton.checked = gameWindow.settings.getValue("musicEnabled");
	}
	
	onStateChanged: {
		if (state === "show")
		{
			deleteDataButton.isSafetyOn = true;
		}
	}
	
	Grid {
		anchors.centerIn: parent
//		spacing: 20
		columns: 2
		columnSpacing: 10
		rowSpacing: 20
		
		TextBase {
			width: 100
			height: 30
			text: "Music:"
			horizontalAlignment: Text.AlignRight
			verticalAlignment: Text.AlignVCenter
		}
		
		BubbleButton {
			id: musicButton
			width: 60; height: 30
			isCheckButton: true
			text: checked ? "On" : "Off"
			
			onCheckedChanged: gameWindow.musicEnabled = checked
		}
		
		TextBase {
			width: 100
			height: 30
			text: "Sound:"
			horizontalAlignment: Text.AlignRight
			verticalAlignment: Text.AlignVCenter
		}
		
		BubbleButton {
			id: soundButton
			width: 60; height: 30
			isCheckButton: true
			text: checked ? "On" : "Off"
			
			onCheckedChanged: gameWindow.soundEnabled = checked
		}
		
		TextBase {
//			anchors.verticalCenter: deleteDataButton.verticalCenter
			width: 100; height: 30
			text: "Danger Zone:"
			horizontalAlignment: Text.AlignRight
			verticalAlignment: Text.AlignVCenter
		}
		
		BubbleButton {
			id: deleteDataButton
			/*
			  The delete button will alternate between 2 states: "Delete Data" and "Confirm?".
			  The first state is a safety catch and switches over to the second state.
			  After clicking the button in the second state, the previous game data will be 
			  deleted and refreshed. After a while, if no action is taken while in the second 
			  state, the button will revert back to the first state.
			*/
			
			width: 100; height: 30
//			anchors {
//				top: parent.top
//				right: parent.right
//				margins: 10
//			}
			
			property bool isSafetyOn: true
			
			text: isSafetyOn ? "Delete Data" : "Confirm?"
			defaultColor: "crimson"
			hoverColor: "red"
			
			onClicked: {
				if (isSafetyOn)
					timer.start();	//	start the timer. Once the timer times out, reverts back to the safety state.
				
				if (!isSafetyOn)
					JStorage.clearData();	//	clear the data. Bye bye data.
				
				isSafetyOn = !isSafetyOn;
			}
			
			//	automatically turn on safety
			Timer {
				id: timer
				interval: 5000
				running: false
				repeat: false
				
				onTriggered: deleteDataButton.isSafetyOn = true;	//	reverts back to the safety state
			}
		}	
		
	}
	
}
