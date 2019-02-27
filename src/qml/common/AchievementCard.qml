import Felgo 3.0
import QtQuick 2.0

import QtQuick.Layouts 1.3

/**
  
  Sources and Citations
  [1]: Spacer Item for QML Layouts:
		https://stackoverflow.com/questions/41545643/spacer-item-in-qml-layouts
  
		
  TODO
   + incorporate display of other information (e.g. progress)
   + consider making cards clickable so that player can then view information
   
*/

import "../common"

Item {
	id: item
	
	signal clicked
	
	property alias color: background.color
	
	property var achievement
	
	property color primaryColor: achievement.isSecret ? "mediumblue" : "yellow";
	property color secondaryColor: achievement.isSecret ? "gold" : "navy"
	
	property string name: achievement.name
	property string description: achievement.description
	property int	reward: achievement.reward
	property bool	isSecret: achievement.isSecret
	property string secret: achievement.secret
	property bool	isClassified: achievement.isClassified
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
			id: descriptionText
			Layout.fillWidth: true
			color: secondaryColor
			
			text: achievement.description.length > 45 ? achievement.description.substr(0, 30) + '...' : achievement.description
			font.pointSize: achievement.description.length > 30 ? 6 : 8
			
			horizontalAlignment: Text.AlignRight
			wrapMode: Text.WordWrap
		}
		
		//	filler, see [1]
		Item {
			Layout.fillHeight: true
		}
		
		//	bottom ribbon
		RowLayout {
			width: parent.width
			
			//	name at bottom left
			TextBase {
				id: nameText
				Layout.fillHeight: true
				color: secondaryColor
				
				text: achievement === undefined ? "<name>" : achievement.name
				font.pointSize: achievement.name.length < 8 ? 12 : 11
				
				horizontalAlignment: Text.AlignLeft
				verticalAlignment: Text.AlignBottom
			}
			
			//	filler, see [1]
			Item {
				Layout.fillWidth: true
			}
			
			//	reward at bottom right
			TextBase {
				id: rewardText
				Layout.fillHeight: true
				color: secondaryColor
				
				text: achievement === undefined || achievement.isSecret && !achievement.isCollected ? "???" : achievement.reward + 'ƒ'
				font.pointSize: 8
				
				verticalAlignment: Text.AlignBottom
			}
		}

	}
}
