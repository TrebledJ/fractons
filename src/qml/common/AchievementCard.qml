import VPlay 2.0
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
	
	
	BubbleButton {
		id: background
//		radius: 5
		anchors.fill: parent
		
		color: "yellow"
		
		text: ''
		
//		border.color: "navy"
//		border.width: 1
		
		onClicked: item.clicked();
	}
	
	ColumnLayout {
		anchors.fill: background
		anchors.margins: 2 * (3/background.diagonalScalar)
		
		spacing: 0
		
		//	description at top right
		TextBase {
			id: descriptionText
			Layout.fillWidth: true
			
			text: achievement === undefined ? "<description>" : achievement.description
			font.pixelSize: 8
			
			horizontalAlignment: Text.AlignRight
			wrapMode: Text.WordWrap
		}
		
		//	filler, see [1]
//		Item {
//			Layout.fillHeight: true
//		}
		
		//	bottom ribbon
		RowLayout {
			
			//	name at bottom left
			TextBase {
				id: nameText
				
				text: achievement === undefined ? "<name>" : achievement.name
				font.pixelSize: 12
				
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
				
				text: achievement === undefined ? "???" : achievement.reward
				font.pixelSize: 8
				
				verticalAlignment: Text.AlignBottom
			}
		}

	}
}
