import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../../game/singles"
import "../backdrops"
import "../../common"

SceneBase {
	id: sceneBase
	
	property alias musicEnabled: musicButton.checked
	property alias soundEnabled: soundButton.checked
	
	Component.onCompleted: {
		//	load saved settings
		musicButton.checked = gameWindow.settings.getValue("musicEnabled");
		soundButton.checked = gameWindow.settings.getValue("soundEnabled");
	}
	
	onShownChanged: {
		if (shown)
		{
			deleteDataButton.isSafetyOn = true;
		}
	}
	
	GridLayout {
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		anchors.margins: 0.2 * parent.width
		
		columns: 2
		columnSpacing: 10
		rowSpacing: 10
		
		TextBase {
			width: 50
			height: 30
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
		
		TextBase {
			width: 50
			height: 30
			text: "SFX"
			verticalAlignment: Text.AlignVCenter
			Layout.alignment: Qt.AlignRight
		}
		
		BubbleButton {
			id: soundButton
			width: 60; height: 30
			isCheckButton: true
			text: checked ? "On" : "Off"
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
			
			Layout.topMargin: 60	//	place the delete button a bit further
			Layout.columnSpan: 2
			
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
