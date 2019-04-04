import QtQuick 2.0
import QtQuick.Controls 2.4

import "backdrops"
import "../common"
import "../game"
import "../game/singles"

//import Fractons 1.0

SceneBase {
	id: scene
	
	
	signal studyButtonClicked
	signal exercisesButtonClicked
	signal lotteryButtonClicked
	signal achievementsButtonClicked
	signal statisticsButtonClicked
	signal questsButtonClicked
	signal settingsButtonClicked
	
	property var hoveredQuest
	
	useDefaultBackButton: false
	
	TextBase {
		anchors.bottom: mainButtonsRow.top
		anchors.bottomMargin: 30
		anchors.horizontalCenter: parent.horizontalCenter
//		color: "yellow"
		text: "ƒRACTONS"
		font.bold: true
		font.italic: true
		font.pointSize: 48
	}
	
	Row {
		id: mainButtonsRow
		anchors.centerIn: parent
		spacing: 20
		
		BubbleButton {
			id: studyNotesButton
			width: height; height: 80
			
			text: "Study"
			textObj.verticalAlignment: Text.AlignBottom
			
			//	TODO rest of implement study notes
			visible: false
			
			image.source: "qrc:/assets/icons/book-open"
			image.anchors.bottomMargin: 20
			
			onClicked: studyButtonClicked()
		}
		
		BubbleButton {
			id: exercisesButton
			width: height; height: 80
			
			text: "Exercises"
			textObj.verticalAlignment: Text.AlignBottom
			
			image.source: "qrc:/assets/icons/star"
			image.anchors.bottomMargin: 20
			
			onClicked: exercisesButtonClicked()
		}
		
		BubbleButton {
			id: lotteryButton
			width: height; height: 60
			
			anchors.verticalCenter: parent.verticalCenter
			
			property bool unlocked: JFractons.currentLevel() >= 20
//			property bool unlocked: true
			
			enabled: unlocked
			
			text: unlocked ? "Lottery" : "Level 20"
			textObj.verticalAlignment: Text.AlignBottom
			
			opacity: unlocked ? 1 : 0.6
			
			image.source: unlocked ? "qrc:/assets/icons/slot" : "qrc:/assets/icons/padlock-closed"
			image.anchors.bottomMargin: 15
			
			font.pointSize: 12
			
			onClicked: lotteryButtonClicked()
		}
	}
	
	//	level + frac display
	Rectangle {
		id: ribbonBackground
		width: parent.width; height: levelFracDisplay.height + 10
		anchors.bottom: parent.bottom
		color: "navy"
		
	}
	
	Row {
		id: levelFracDisplay
		width: 250; height: 10
		anchors {
			bottom: parent.bottom
			horizontalCenter: parent.horizontalCenter
			margins: 5
		}
		
		spacing: 10
		
		TextBase {
			id: fractonDisplay
			width: contentWidth + 10; height: parent.height
			color: "yellow"
			text: 'Level ' + JFractons.currentLevel() + '   ' + JFractons.fractons + '/' + JFractons.nextThresh() + " ƒ"
			verticalAlignment: Text.AlignVCenter
		}
		
		//	displays the frac progress
		Rectangle {
			id: fractonOuterBar
			width: parent.width - parent.spacing - fractonDisplay.width; height: parent.height
			radius: 5
			
			color: "lightgoldenrodyellow"
			
			Rectangle {
				id: xpMeter
				width: (parent.width - 6) * JFractons.progress() + 2; height: parent.height - 4
				radius: 5
				anchors {
					left: parent.left
					top: parent.top
					bottom: parent.bottom
					margins: 2
				}
				
				color: "navy"
			}
		}	//	Rectangle: fractonOuterBar
		
		//	INFO
		//	I tried using a ProgressBar from QtQuick.Controls 2.4 but it showed incorrect results (bar was full even though progress should be halfway through).
		//	So I reverted to manual rectangles.

		
	}	//	Row

	
	Row {
		id: otherButtons
		spacing: 10
		
		anchors {
			top: parent.top
			left: parent.left; right: parent.right
			margins: 5
		}
		
		BubbleButton {
			id: achievementsButton
			width: height; height: 40
			
			image.source: "qrc:/assets/icons/trophy"
			
			onClicked: achievementsButtonClicked();
		}
		
		BubbleButton {
			id: statisticsButton
			width: height; height: 40
			
			image.source: "qrc:/assets/icons/line-chart"
			onClicked: statisticsButtonClicked();
		}
		
	}
	
	Column {
		id: questColumn
		spacing: 10
		
		anchors {
			left: parent.left; leftMargin: 10
			verticalCenter: parent.verticalCenter
		}
		
		visible: JFractons.currentLevel() >= 5	//	quests begin from level 5
		
		/**
		  Quest Ideas
		  
		  * Earn X Fractons
		  * Level Up (or) Gain 1 Level
		  * Solve X Exercises
		  * Solve X Questions in Y Mode
		  * Unlock/Earn 1 Achievement
		  * Spin the Lottery [Wheel] X Times
		  
		  
		  */
		
		QuestButton {
			id: questButton1
			quest: JQuests.getQuestByIndex(0)
			onEntered: {
				hoveredQuest = quest;
			}
		}
		
		QuestButton {
			id: questButton2
			quest: JQuests.getQuestByIndex(1)
			onEntered: {
				hoveredQuest = quest;
			}
		}
		
		QuestButton {
			id: questButton3
			quest: JQuests.getQuestByIndex(2)
			onEntered: {
				hoveredQuest = quest;
			}
		}
		
		Connections {
			target: JQuests
			
			onQuestsChanged: {
				//	automatically update quests when modified
				questButton1.quest = JQuests.getQuestByIndex(0);
				questButton2.quest = JQuests.getQuestByIndex(1);
				questButton3.quest = JQuests.getQuestByIndex(2);
			}
			
			onQuestsModified: {
				questButton1.quest = JQuests.getQuestByIndex(0);
				questButton2.quest = JQuests.getQuestByIndex(1);
				questButton3.quest = JQuests.getQuestByIndex(2);
			}
		}
		
	}
	
	//	holds the quest box, quest text, and corresponding progress bar and text
	Rectangle {
		id: questBox
		width: questText.contentWidth + 10; height: 35
		radius: 5
		
		anchors {
			//	anchor to the left and vary margin depending on whether quest buttons have been entered
			left: parent.left; leftMargin: questButton1.isEntered || questButton2.isEntered || questButton3.isEntered ? 0 + 5 : -width
			bottom: newQuestsInfo.top; bottomMargin: 5
			margins: 2
		}
		
		visible: anchors.leftMargin > -width	//	semi-hardcoded
		
		color: "navy"
		
		//	animate changes to anchors.leftMargin by a quadratic
		Behavior on anchors.leftMargin {
			NumberAnimation {
				duration: 500
				easing.type: Easing.InOutBack
			}
		}
		
		Column {
			anchors.fill: parent
			anchors.margins: 5
			spacing: 2
			
			//	displays the quest as text
			TextBase {
				id: questText
				
				font.pixelSize: 10
				color: "yellow"
				
				text: hoveredQuest === undefined ? "" : hoveredQuest.text
			}
			
			//	holds the progress bar and progress text
			Row {
				id: progressRow
				
				width: parent.width; height: 8
				spacing: 1
				
				property int progress: hoveredQuest === undefined ? 0 : hoveredQuest.progress
				property int maxProgress: hoveredQuest === undefined ? 1 : hoveredQuest.maxProgress
				
				Rectangle {
					width: parent.width - progressText.width - progressRow.spacing; height: parent.height
					radius: 4
					color: "lightgoldenrodyellow"
					
					Rectangle {
//						width: (parent.width - 4) * quest.progress / quest.maxProgress; height: 4
						width: (parent.width - 4) * progressRow.progress/progressRow.maxProgress; height: 4
						radius: 2
						
						anchors.left: parent.left
						anchors.top: parent.top
						anchors.margins: 2
						
						
						color: "navy"
					}
				}
				
				TextBase {
					id: progressText
					width: contentWidth + 10; height: parent.height
					
					font.pointSize: 6
					text: progressRow.progress + '/' + progressRow.maxProgress
					color: "yellow"
					
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
			}
		}
	}

	
	
	TextBase {
		id: newQuestsInfo
		
		//	anchor to bottom left above ribbon
		anchors {
			left: parent.left; leftMargin: 3
			bottom: ribbonBackground.top
			margins: 1
		}
		
		font.pointSize: 8
		
		visible: questColumn.visible
		
		//	updates text every minute
		Timer {
			running: true
			triggeredOnStart: true
			interval: 60000
			repeat: true
			onTriggered: parent.text = 'New quests arrive in ' + JQuests.timeToPurge() + '.'
		}
	}
	
	BubbleButton {
		id: settingsButton
		width: height; height: 40
		anchors {
			top: parent.top
			right: parent.right
			margins: 5
		}
		
		image.source: "qrc:/assets/icons/gear"
		onClicked: settingsButtonClicked();
	}
	
	
	
	//	useful for pinpointing coordinates
//	MouseArea {
//		anchors.fill: parent
////		onClicked: console.debug("Clicked:", mouseX, mouseY)
//		onClicked: JGameNotifications.sendMessage("Hi", "Hullo", 10)
//	}
	
}
