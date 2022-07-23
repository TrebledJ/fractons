import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "backdrops"
import "../common"
import "../game"
import "../game/singles"

SceneBase {
	id: scene
	
	signal studyButtonClicked
	signal exercisesButtonClicked
	signal lotteryButtonClicked
	signal achievementsButtonClicked
	signal statisticsButtonClicked
	signal questsButtonClicked
	signal notificationsButtonClicked
	signal settingsButtonClicked
	signal creditsButtonClicked
	
	property var hoveredQuest
	
	useDefaultBackButton: false
	
	TextBase {
		anchors { bottom: mainButtonsRow.top; bottomMargin: 30; horizontalCenter: parent.horizontalCenter }
		text: "ƒRACTONS"
		font { bold: true; italic: true; pointSize: 48 }
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
			visible: false					//	TODO rest of implement study notes
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
			anchors.verticalCenter: parent.verticalCenter
			width: height; height: 60
			
			property bool unlocked: JFractons.currentLevel() >= 20	//	LOTTERY
//			property bool unlocked: true
			
			text: unlocked ? "Lottery" : "Level 20"	//	LOTTERY
			textObj.verticalAlignment: Text.AlignBottom
			font.pointSize: 12
			opacity: unlocked ? 1 : 0.6
			enabled: unlocked
			
			image.source: unlocked ? "qrc:/assets/icons/slot" : "qrc:/assets/icons/padlock-closed"
			image.anchors.bottomMargin: 15
			
			onClicked: lotteryButtonClicked()
		}
	}
	
	//	level + frac display
	Rectangle {
		id: ribbonBackground
		anchors.bottom: parent.bottom
		width: parent.width; height: levelFracDisplay.height + 10
		color: "navy"
		
		TextBase {
			anchors { verticalCenter: parent.verticalCenter; right: parent.right; margins: 3 }
			text: '<font color="yellow"><a href="link"><i><u>credits</u></i></a></font>'
			font.pointSize: 8
			color: 'yellow'
			onLinkActivated: creditsButtonClicked();
		}
	}
	
	Row {
		id: levelFracDisplay
		anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; margins: 5 }
		width: 250; height: 10
		spacing: 10
		
		TextBase {
			id: fractonDisplay
			width: contentWidth + 10; height: parent.height
			text: 'Level ' + JFractons.currentLevel() + '   ' + JFractons.fractons + '/' + JFractons.nextThresh() + " ƒ"
			verticalAlignment: Text.AlignVCenter
			color: "yellow"
		}
		
		//	displays the frac progress
		Rectangle {
			id: fractonOuterBar
			width: parent.width - parent.spacing - fractonDisplay.width; height: parent.height
			radius: 5
			color: "lightgoldenrodyellow"
			
			Rectangle {
				id: xpMeter
				anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 2 }
				width: (parent.width - 6) * JFractons.progress() + 2; height: parent.height - 4
				radius: 5
				color: "navy"
			}
		}	//	Rectangle: fractonOuterBar
		
		//	INFO
		//	I tried using a ProgressBar from QtQuick.Controls 2.4 but it showed incorrect results (bar was full even though progress should be halfway through).
		//	So I reverted to manual rectangles.

		
	}	//	Row

	
	RowLayout {
		id: otherButtons
		anchors { top: parent.top; left: parent.left; right: parent.right; margins: 5 }
		spacing: 10
		
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
		
		Item { Layout.fillWidth: true }
		
		NotificationButton {
			id: notificationsButton
			width: height; height: 40
			nCircleText: JGameNotifications.unread
			nCircleVisible: JGameNotifications.unread > 0
			image.source: "qrc:/assets/icons/bell"
			onClicked: notificationsButtonClicked();
		}
		
		BubbleButton {
			id: settingsButton
			width: height; height: 40
			image.source: "qrc:/assets/icons/gear"
			onClicked: settingsButtonClicked();
		}
		
	}
	
	Column {
		id: questColumn
		anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
		spacing: 10
		
//		visible: JFractons.currentLevel() >= 5	//	quests begin from level 5
		
		Repeater {
			id: repeater
			
			function updateDelegate() {
				for (let i = 0; i < repeater.count; i++)
					itemAt(i).quest = JQuests.getQuestByIndex(i);
			}
			
			model: 3
			delegate: questButton
		}
		
		Connections {
			target: JQuests
			onQuestsChanged: repeater.updateDelegate();
			onQuestsModified: repeater.updateDelegate();
		}
		
		Component {
			id: questButton
			BubbleButton {
				property bool completed: quest.progress >= quest.maxProgress
				property var quest: JQuests.getQuestByIndex(modelData)
				property bool isEntered: mouseArea.containsMouse
				
				width: height; height: 30
				
				image.anchors.margins: 0
				image.source: completed ? "qrc:/assets/icons/cowboy-hat-tick.png" : "qrc:/assets/icons/cowboy-hat.png"
				
				onEntered: hoveredQuest = quest
			}
		}
		
	}
	
	//	holds the quest box, quest text, and corresponding progress bar and text
	Rectangle {
		id: questBox
		anchors {
			//	anchor to the left and vary margin depending on whether quest buttons have been entered
			left: parent.left
			leftMargin: {
				for (let i = 0; i < repeater.count; i++)
					if (repeater.itemAt(i).isEntered)
						return 5;
				return -width;
			}
			bottom: newQuestsInfo.top; bottomMargin: 5; margins: 2
		}
		width: questText.contentWidth + 10; height: 35
		radius: 5
		
		color: "navy"; visible: anchors.leftMargin > -width	//	semi-hardcoded
		
		Column {
			anchors { fill: parent; margins: 5 }
			spacing: 2
			
			//	displays the quest as text
			TextBase {
				id: questText
				text: hoveredQuest === undefined ? "" : hoveredQuest.text
				font.pixelSize: 10
				color: "yellow"
			}
			
			//	holds the progress bar and progress text
			Row {
				id: progressRow
				
				property int progress: hoveredQuest === undefined ? 0 : hoveredQuest.progress
				property int maxProgress: hoveredQuest === undefined ? 1 : hoveredQuest.maxProgress
				
				width: parent.width; height: 8
				spacing: 1
				
				Rectangle {
					width: parent.width - progressText.width - progressRow.spacing; height: parent.height
					radius: 4
					color: "lightgoldenrodyellow"
					
					Rectangle {
						anchors { left: parent.left; top: parent.top; margins: 2 }
						width: (parent.width - 4) * progressRow.progress/progressRow.maxProgress; height: 4
						radius: 2
						color: "navy"
					}
				}
				
				TextBase {
					id: progressText
					width: contentWidth + 10; height: parent.height
					
					text: progressRow.progress + '/' + progressRow.maxProgress
					horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
					font.pointSize: 6
					color: "yellow"
				}
			}
		}	//	Column
		
		//	animate changes to anchors.leftMargin by a quadratic
		Behavior on anchors.leftMargin { NumberAnimation { duration: 500; easing.type: Easing.InOutBack } }
		
	}	//	Rectangle: questBox

	
	
	TextBase {
		id: newQuestsInfo
		anchors { left: parent.left; leftMargin: 3; bottom: ribbonBackground.top; margins: 1 }
		font.pointSize: 8
		visible: questColumn.visible
		
		//	updates text every minute
		Timer {
			interval: 60000
			repeat: true
			running: true
			triggeredOnStart: true
			onTriggered: parent.text = 'New quests arrive in ' + JQuests.timeToPurge() + '.'
		}
	}
	
}
