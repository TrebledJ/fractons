//	Achievements.qml
/*	Achievements provides a Scene for displaying achievements, 
	opening achievements for details, and viewing progress.
*/

import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"

import "../../game/singles"

import "../../js/Utils.js" as JUtils

import Fractons 1.0

SceneBase {
	id: sceneBase
	
	ListModel {
		id: groupModel
		ListElement { role_group: "explorer" }	//	all implemented
		ListElement { role_group: "studious" }	//	all implemented
		ListElement { role_group: "sprinter" }	//	all implemented
		ListElement { role_group: "leveller" }	//	all implemented
		ListElement { role_group: "adventurer" }	//	TODO not yet implemented
//		ListElement { role_group: "seasoned" }	//	TODO not yet implemented
		
		//	TODO all mastery not yet implemented
//		ListElement { role_group: "balance" }	
//		ListElement { role_group: "conversion" }
//		ListElement { role_group: "truth" }
//		ListElement { role_group: "operations" }
//		ListElement { role_group: "pie" }
//		ListElement { role_group: "token" }
		
		ListElement { role_group: "lottery" }	//	all implemented EXCEPT lucky ( TODO )
		
		ListElement { role_group: "secret" }	//	all implemented
//		ListElement { role_group: "classified" }	//	all implemented
	}
	
	ListView {
		id: groupList
		anchors.top: banner.bottom
		anchors.bottom: parent.bottom
		width: parent.width
		
		topMargin: 10
		leftMargin: 20
		rightMargin: 20
		
		ScrollBar.vertical: ScrollBar {
			id: scrollbar
			active: true
		}
		
		model: groupModel
		delegate: Item {
			height: 100
			Column {
				id: column
				
				spacing: 5
				TextBase {
					text: JUtils.toTitleCase(role_group)
					font.pointSize: 24
				}
				
				Row {
					spacing: 10
					
					Repeater {
						id: repeater
						
						model: JGameAchievements.getNames(role_group)

						AchievementCard {
							id: card
							width: 80; height: 50
							opacity: isCollected ? 1 : 0.6
							visible: group === "classified" ? isCollected ? 1 : 0 : 1
							
							achievement: JGameAchievements.getByName(modelData);
							
							onClicked: {
								infoPopup.achievementCard = card;	//	set property to this item
								infoPopup.open();
							}
						}
					}
				}
			}

			
		}
	}
	
	Rectangle {
		id: banner
		width: parent.width; height: 50
		anchors.top: parent.top
		color: "navy"
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
	
	onStateChanged: {
		//	turn on safety when user enters scene
		if (state === "show")
		{
			//	ACVM : achievements?
			JGameAchievements.addProgressByName("achievements?", 1);
			
			deleteDataButton.isSafetyOn = true;
		}
	}
	
	Popup {
		id: infoPopup
		width: parent.width - 2*margins; height: parent.height - 2*margins
//		margins: 0
		margins: JStorage.isMobile ? 0 : 150
		
		//	stores the achievement currently inspected
		property var achievementCard
		
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
			NumberAnimation { property: "opacity"; easing.type: Easing.Linear; duration: 600; to: 0 }
		}
		
		Rectangle {
			id: infoBackground
			anchors.fill: parent
			radius: 10
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
				width: parent.width
				font.pixelSize: 20
				wrapMode: Text.WordWrap
			}
			
			Item {
				width: 1; height: 50
			}
			
			Row {
				spacing: 10
				
				TextBase {
					id: progressText
					text: "Progress:"
					font.pixelSize: 16
				}
				
				ProgressBar {
					id: progressBar
					width: 150; height: 10
					anchors.verticalCenter: parent.verticalCenter
					from: 0
					value: 0
					
					background: Rectangle {
						radius: 5
//						color: Qt.lighter(progressBar.contentItem.color, 3)
						color: "lightgoldenrodyellow"
					}
					
					contentItem: Rectangle {
						width: progressBar.visualPosition * progressBar.width; height: parent.height
						radius: 5
					}
				}	//	ProgressBar
				
				
				TextBase {
					id: percentText
					font.pixelSize: 18
				}
			}	//	Row
			
			TextBase {
				id: rewardText
				text: "Reward: XXX"
				font.pixelSize: 16
			}
			
		}	//	Column
		
		MouseArea {
			anchors.fill: parent
			onClicked: infoPopup.close()
		}
		
		onAchievementCardChanged: {
			if (achievementCard === undefined)
				return;
			
			
			infoBackground.color = infoPopup.achievementCard.primaryColor;
			nameText.color = 
			descriptionText.color = 
			progressText.color = 
			progressBar.contentItem.color =
			percentText.color = 
			rewardText.color = infoPopup.achievementCard.secondaryColor;
			
			nameText.text = "<b>" + achievementCard.name + "</b>";
			descriptionText.text = achievementCard.group === "secret" ? achievementCard.hint : achievementCard.description;
			if (achievementCard.group === "secret" && achievementCard.isCollected)
				descriptionText.text += '\n\n' + achievementCard.description;
//				descriptionText.text += achievementCard.description;
			
			if (achievementCard.group === "secret" && !achievementCard.isCollected)
				rewardText.text = 'Reward: ???'
			else
				rewardText.text = 'Reward: ' + achievementCard.reward + 'ƒ';

			
			progressBar.to = achievementCard.maxProgress;
			progressBar.value = achievementCard.progress;
			percentText.text = achievementCard.progress + '/' + achievementCard.maxProgress +
					' (' + Math.round(achievementCard.progress / achievementCard.maxProgress * 100) + '%)'
			
		}	//	onAchievementCardChanged
		
		onClosed: {
			achievementCard = undefined;
		}
	}	//	Popup
	
}
