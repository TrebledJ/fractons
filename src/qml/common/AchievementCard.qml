import QtQuick 2.0

import QtQuick.Layouts 1.3

/**
  
  Sources and Citations
  [1]: Spacer Item for QML Layouts:
		https://stackoverflow.com/questions/41545643/spacer-item-in-qml-layouts
*/

import "../common"

Item {
	id: item
	
	signal clicked
	
	property alias color: background.color
	
	property var achievement
	
	property color primaryColor: "secret,classified".includes(achievement.group) ? "mediumblue" : "yellow";
	property color secondaryColor: "secret,classified".includes(achievement.group) ? "gold" : "navy"
	
	property string name: achievement.name
	property string description: achievement.description
	property string	hint: achievement.hint
	property string	group: achievement.group
	property int	reward: achievement.reward
	property int	progress: achievement.progress
	property int	maxProgress: achievement.maxProgress
	property bool	isCollected: achievement.isCollected
	
	BubbleButton {
		id: background
		anchors.fill: parent
		color: primaryColor
		
		text: ''
		textObj.animate: false

		enteredFrom: 0.9
		pressedFrom: 0.95
		pressedTo: 1.1
		
		onClicked: item.clicked();
	}
	
	ColumnLayout {
		anchors.fill: background
		anchors.margins: 2 * (3/background.diagonalScalar)	//	inversely proportional
		
		spacing: 0
		
		//	description at top right
		TextBase {
//			id: rewardText
			id: descriptionText
			Layout.fillWidth: true
			color: secondaryColor
			
			text: "secret,classified".includes(group) ? hint : description.length > 45 ? description.substr(0, 30) + '...' : description
//			text: achievement === undefined || (group === "secret" && !isCollected) ? "???" : reward + 'ƒ'
//			font.pointSize: description.length > 30 ? 6 : 8
			font.pointSize: 6
			
//			visible: false
			
			horizontalAlignment: Text.AlignRight
			wrapMode: Text.WordWrap
		}
		
		//	filler, see [1]
		Item {
			Layout.fillHeight: true
		}
		
		TextBase {
			id: nameText
			Layout.fillHeight: true
			color: secondaryColor
			
			text: achievement === undefined ? "<name>" : name
			font.pointSize: 10
			
			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignBottom
		}

	}
}
