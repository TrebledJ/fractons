import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../game/singles"

SceneBase {
	id: sceneBase
	
	property alias musicEnabled: musicButton.checked
	property alias soundEnabled: soundButton.checked
	property alias bgAnimationEnabled: bgAnimationButton.checked
	property alias numberPadEnabled: numberPadButton.checked
	
	useDefaultTopRibbon: true
	
	onShownChanged: {
		if (shown)
		{
			deleteDataButton.isSafetyOn = true;
		}
	}
	
	GridLayout {
		anchors.centerIn: parent
		
		columns: 5
		columnSpacing: 10
		rowSpacing: 10
		
		TextBase {
			width: 40; height: 30
			text: "Music"
			Layout.alignment: Qt.AlignRight
			verticalAlignment: Text.AlignVCenter
		}
		
		BubbleButton {
			id: musicButton
			width: 60; height: 30
			isCheckButton: true
			text: checked ? "On" : "Off"
		}
		
		Item {
			width: 40; height: 1
		}
		
		TextBase {
			width: 100; height: 30
			text: "Background Animations"
			Layout.alignment: Qt.AlignRight
			verticalAlignment: Text.AlignVCenter
		}
		
		BubbleButton {
			id: bgAnimationButton
			width: 60; height: 30
			isCheckButton: true
			text: checked ? "On" : "Off"
		}
		
		TextBase {
			width: 40; height: 30
			text: "Sound"
			verticalAlignment: Text.AlignVCenter
			Layout.alignment: Qt.AlignRight
		}
		
		BubbleButton {
			id: soundButton
			width: 60; height: 30
			isCheckButton: true
			text: checked ? "On" : "Off"
		}
		
		Item {
			width: 40; height: 1
		}
		
		TextBase {
			width: 100; height: 30
			text: "Number Pad"
			Layout.alignment: Qt.AlignRight
			verticalAlignment: Text.AlignVCenter
		}
		
		BubbleButton {
			id: numberPadButton
			width: 60; height: 30
			isCheckButton: true
			text: checked ? "On" : "Off"
		}
		
		Repeater {
			model: 3
			Item { width: 40; height: 1 }
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
			
			Layout.topMargin: 50	//	place the delete button a bit further
			Layout.columnSpan: 2
			Layout.alignment: Qt.AlignRight
			
			property bool isSafetyOn: true
			
			text: isSafetyOn ? "Delete Data" : "Confirm?"
			defaultColor: "crimson"
			hoverColor: "red"
			
			onClicked: {
				if (isSafetyOn)
					timer.start();	//	start the timer. Once the timer times out, reverts back to the safety state.
				
				if (!isSafetyOn)
				{
					JStorage.clearData();	//	clear the data. Bye bye data.
					backButtonClicked();	//	go back to home
				}
				
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
