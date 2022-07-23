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
	property color primaryColor: "secret,classified".includes(group) ? "mediumblue" : "yellow";
	property color secondaryColor: "secret,classified".includes(group) ? "gold" : "navy"
	
	property var	achievement
	property string name: achievement ? achievement.name : ''
	property string description: achievement ? achievement.description : ''
	property string	hint: achievement ? achievement.hint : ''
	property string	group: achievement ? achievement.group : ''
	property int	reward: achievement ? achievement.reward : 0
	property int	progress: achievement ? achievement.progress : 0
	property int	maxProgress: achievement ? achievement.maxProgress : 0
	property bool	isCollected: achievement ? achievement.isCollected : false
	
	BubbleButton {
		id: background
		anchors.fill: parent
		
		text: ''
		textObj.animate: false
		color: primaryColor

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
			id: descriptionText
			Layout.fillWidth: true
			
			text: "secret,classified".includes(group) ? hint : description.length > 45 ? description.substr(0, 30) + '...' : description
			horizontalAlignment: Text.AlignRight
			font.pointSize: 6
			color: secondaryColor
			wrapMode: Text.WordWrap
		}
		
		//	filler, see [1]
		Item { Layout.fillHeight: true }
		
		TextBase {
			id: nameText
			Layout.fillHeight: true
			
			text: achievement === undefined ? "<name>" : name
			horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignBottom
			font.pointSize: 10
			color: secondaryColor
		}

	}
}
