//	Achievements.qml
/*	Achievements provides a Scene for displaying achievements, 
	opening achievements for details, and viewing progress.
*/

import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"

import "../../game/singles"

import Fractureuns 1.0

SceneBase {
	id: sceneBase
	
	Component.onCompleted: {
		var temp = GameAchievements.getByIndex(0);
		if (temp === undefined)
			return;
	}
	
	Grid {
		anchors.centerIn: parent
		spacing: 10
		columns: 4
		
		Repeater {
			model: JGameAchievements.getNames()
			
			AchievementCard {
				width: 80; height: 50
				
				achievement: JGameAchievements.getByName(modelData)
				
				onClicked: {
					console.debug("[Achievements.qml]", "Achievement", modelData, "was clicked!");
					
					infoPopup.achievement = JGameAchievements.getByName(modelData);
					infoPopup.open();
				}
			}
			
		}
	}

	BubbleButton {
		id: deleteDataButton
		width: 100; height: 30
		anchors {
			top: parent.top
			right: parent.right
			margins: 10
		}
		
		property bool isSafetyOn: true
		
		text: isSafetyOn ? "Delete Data" : "Confirm?"
		defaultColor: "crimson"
		hoverColor: "red"
		
		onClicked: {
			if (isSafetyOn)
				timer.start();
			
			if (!isSafetyOn)
				JStorage.clearData();
			
			isSafetyOn = !isSafetyOn;
		}
		
		//	automatically turn on safety
		Timer {
			id: timer
			interval: 5000
			running: false
			repeat: false
			
			onTriggered: deleteDataButton.isSafetyOn = true;
		}
	}	
	
	Popup {
		id: infoPopup
		width: parent.width - 2*margins; height: parent.height - 2*margins
		margins: 0
		
		//	stores the achievement currently inspected
		property var achievement
		
		//	custom background
		background: Item { visible: false }
		
		//	shadows the rest of the app
		modal: true
		
		//	popup is relative to window
		parent: Overlay.overlay
		
		enter: Transition {
			ParallelAnimation {
				NumberAnimation { property: "opacity"; easing.type: Easing.InOutSine; duration: 1000; from: 0; to: 1 }
				NumberAnimation { property: "width"; from: 0; to: infoPopup.width }
				NumberAnimation { property: "height"; from: 0; to: infoPopup.height }
				NumberAnimation { property: "x"; from: infoPopup.width / 2; to: 0 }
				NumberAnimation { property: "y"; from: infoPopup.height / 2; to: 0 }
			}
			
		}
		
		exit: Transition {
			NumberAnimation { property: "opacity"; easing.type: Easing.OutSine; duration: 2000; to: 0 }
		}
		
		Rectangle {
			id: infoBackground
			anchors.fill: parent
			radius: 10
			color: "yellow"
			opacity: 0.9
		}

		Column {
			anchors.centerIn: infoBackground
			spacing: 10
			
			//	TODO place a checkmark next to achievements that have already been earned
			TextBase {
				id: nameText
				font.pixelSize: 36
			}
			
			//	TODO add a banner (maybe slanted on a corner) showing that an achievement is secret
			TextBase {
				id: descriptionText
				font.pixelSize: 20
			}
			
			Item {
				width: 1; height: 50
			}
			
			Row {
				spacing: 10
				
				ProgressBar {
					id: progressBar
					width: 200; height: 10
					anchors.verticalCenter: parent.verticalCenter
					from: 0
					value: 0
					
					background: Rectangle {
						radius: 5
						color: Qt.lighter("navy", 4)
					}
					
					contentItem: Rectangle {
						width: progressBar.visualPosition * progressBar.width; height: parent.height
						radius: 5
						
						color: "navy"
					}
				}	//	ProgressBar
				
				
				TextBase {
					id: percentText
					font.pixelSize: 18
				}
			}	//	Row
			
			TextBase {
				id: rewardText
				font.pixelSize: 16
			}
			
		}	//	Column
		
		MouseArea {
			anchors.fill: parent
			onClicked: infoPopup.close()
		}
		
		onAchievementChanged: {
			if (achievement === undefined)
				return;
			
//			infoBackground.color = achievement.isSecret ? "mediumblue" : "yellow"
			nameText.text = achievement.name;
			descriptionText.text = achievement.description;
			
			if (achievement.isSecret)
			{
				rewardText.text = 'Reward: ???'
			}
			else
			{
				rewardText.text = 'Reward: ' + achievement.reward + 'ƒ';
			}

			
			progressBar.to = achievement.maxProgress;
			progressBar.value = achievement.progress;
			percentText.text = Math.round(achievement.progress / achievement.maxProgress * 100) + '%'
		}
		
		onClosed: {
			achievement = undefined;
		}
	}	//	Popup
	
	onVisibleChanged: {
		//	turn on safety when user enters scene
		deleteDataButton.isSafetyOn = true;
		
		
	}
}
