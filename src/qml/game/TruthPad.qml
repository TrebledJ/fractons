import Felgo 3.0
import QtQuick 2.0

import "../common"

Item {
	id: item
	
	signal keyPressed(string key)
	property var keys: ['T', 'F', 'back']
	
	
	Rectangle {
		id: background
		
		anchors.fill: parent
		radius: 5
		
		opacity: focus ? 0.4 : 0.95
		
		color: "navy"
	}
	
	
	Column {
		id: column
		
		anchors.fill: background
		anchors.margins: spacing
		
		spacing: 5
		
		Repeater {
			id: gridRepeater
			model: item.keys
			
			BubbleButton {
				width: column.width; height: (column.height - 2*column.spacing)/3
				background.radius: 5
				color: "yellow"
				
				text: modelData === 'back' ? '⬅' : modelData
				
				onClicked: {
					item.keyPressed('' + modelData);
				}
				
				Connections {
					target: mouseArea
					onPressAndHold: {
						console.debug("Press and held! Key:", modelData);
					}
				}
				
			}
			
		}
	}
	
	function animate() {
		for (var i = 0; i < gridRepeater.count; i++)
		{
			gridRepeater.itemAt(i).animateScalar(0.8, 1);
		}
	}
	
}
