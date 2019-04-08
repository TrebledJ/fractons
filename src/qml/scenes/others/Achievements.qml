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
	
	useDefaultTopBanner: true
	
	ListModel {
		id: groupModel
		ListElement { role_group: "explorer"; role_isActive: function() { return true; } }
		ListElement { role_group: "studious"; role_isActive: function() { return true; } }
		ListElement { role_group: "sprinter"; role_isActive: function() { return true; } }
		ListElement { role_group: "leveller"; role_isActive: function() { return true; } }
		ListElement { role_group: "adventurer"; role_isActive: function() { return true; } }
//		ListElement { role_group: "seasoned" }	//	TODO not yet implemented
		
		//	TODO all mastery not yet implemented
//		ListElement { role_group: "balance" }	
//		ListElement { role_group: "conversion" }
//		ListElement { role_group: "truth" }
//		ListElement { role_group: "operations" }
//		ListElement { role_group: "pie" }
//		ListElement { role_group: "token" }
		
		ListElement { role_group: "lottery"; role_isActive: function() { return JFractons.currentLevel() >= 20 } }
		ListElement { role_group: "lucky-lottery"; role_isActive: function() { return JFractons.currentLevel() >= 20 } }
		
		ListElement { role_group: "secret"; role_isActive: function() { return true; } }
		ListElement { 
			role_group: "classified"
			role_isActive: function() { 
				var achievements = JGameAchievements.getNames("classified");
				for (var i in achievements)
					if (JGameAchievements.getByName(achievements[i]).isCollected)
						return true;
				
				return false;
			}
		}
	}
	
	ListView {
		id: groupList
		anchors { top: banner.bottom; bottom: parent.bottom }
		z: -10
		width: parent.width
		
		topMargin: 10; leftMargin: 20; rightMargin: 20
		
		ScrollBar.vertical: ScrollBar { active: true }
		
		model: groupModel
		delegate: Item {
			height: visible ? 100 : 0
			visible: role_isActive()
			
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
							
							visible: {
								if (group === "classified" && !isCollected)
									return false;
								
								if (name === "Lessons?")	//	TODO implement lessons
									return false;
								
								return true;
							}
							opacity: isCollected ? 1 : 0.6
							
							achievement: JGameAchievements.getByName(modelData);
							
							onClicked: {
								popup.achievement = card;	//	set property to this item
								popup.open();
							}
						}
					}
				}	//	Row
			}	//	Column
		}	//	delegate: Item
	}	//	ListView
	
	onShownChanged: {
		if (shown)
			JGameAchievements.addProgressByName("achievements?", 1);	//	ACVM : achievements?
	}
	
	Popup {
		id: popup

		//	stores the achievement currently inspected
		property var achievement
		
		width: parent.width - 2*margins; height: parent.height - 2*margins
		
		background: Item { visible: false }
		margins: JStorage.isMobile ? 0 : 150
		modal: true	//	shadows the rest of the app
		parent: Overlay.overlay	//	popup is relative to window
		
		enter: Transition { NumberAnimation { property: "opacity"; easing.type: Easing.InOutSine; duration: 1000; from: 0; to: 1 } }
		exit: Transition { NumberAnimation { property: "opacity"; easing.type: Easing.OutQuad; duration: 300; to: 0 } }
		
		Rectangle {
			id: background
			anchors.fill: parent
			radius: 10
			color: popup.achievement ? popup.achievement.primaryColor : ""; opacity: 0.9
		}

		Image {
			anchors { top: parent.top; right: parent.right; margins: 20 }
			width: height; height: 60
			
			source: "qrc:/assets/icons/tick.png"
			visible: popup.achievement ? popup.achievement.isCollected : false
		}
		
		Column {
			anchors.centerIn: background
			spacing: 10
			
			TextBase {
				text: popup.achievement ? "<b>" + popup.achievement.name + "</b>" : ""
				font.pixelSize: 36
				color: popup.achievement ? popup.achievement.secondaryColor : ""
			}
			
			TextBase {
				id: descriptionText
				width: parent.width
				
				text: {
					if (!popup.achievement)
						return "";
					
					if ("secret,classified".includes(popup.achievement.group)) 
					{
						var s = popup.achievement.hint;
						if (popup.achievement.isCollected && popup.achievement.description)
							s += "\n\n" + popup.achievement.description
						return s;
					}
					
					return popup.achievement.description;
				}
				font.pixelSize: 20
				wrapMode: Text.WordWrap
				
				color: popup.achievement ? popup.achievement.secondaryColor : ""
			}
			
			Item { width: 1; height: 50 - descriptionText.contentHeight / 4; }
			
			//	Row [ Progress: (######__) 75% ]
			Row {
				spacing: 10
				
				TextBase {
					text: "Progress:"
					color: popup.achievement ? popup.achievement.secondaryColor : ""
					font.pixelSize: 16
				}
				
				ProgressBar {
					id: progressBar
					anchors.verticalCenter: parent.verticalCenter
					width: 150; height: 10
					from: 0; to: popup.achievement ? popup.achievement.maxProgress : 1
					value: popup.achievement ? popup.achievement.progress : 0
					
					background: Rectangle {
						radius: 5
						color: "lightgoldenrodyellow"
					}
					
					contentItem: Rectangle {
						width: progressBar.visualPosition * progressBar.width; height: parent.height
						radius: 5
						color: popup.achievement ? popup.achievement.secondaryColor : ""
					}
				}	//	ProgressBar
				
				TextBase {
					text: {
						if (!popup.achievement) 
							return "";
						
						return popup.achievement.progress + '/' + popup.achievement.maxProgress + 
								' (' + Math.round(popup.achievement.progress / popup.achievement.maxProgress * 100) + '%)';
					}
					font.pixelSize: 18
					color: popup.achievement ? popup.achievement.secondaryColor : ""
				}
			}	//	Row
			
			TextBase {
				text: {
					if (!popup.achievement)
						return "";
					
					var s;
					if (popup.achievement.group === "secret" && !popup.achievement.isCollected)
						s = "???";
					else
						s = popup.achievement.reward + 'ƒ';
					
					return "Reward: " + s;
				}
				font.pixelSize: 16
				color: popup.achievement ? popup.achievement.secondaryColor : ""
			}	//	TextBase
			
		}	//	Column
		
		MouseArea { anchors.fill: parent; onClicked: popup.close() }
		onClosed: achievement = undefined;
		
	}	//	Popup
	
}
