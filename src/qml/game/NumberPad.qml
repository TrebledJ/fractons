import VPlay 2.0
import QtQuick 2.0

import "../common"

Item {
	id: item
	width: 150; height: 200
	
	signal keyPressed(string key)

	Rectangle {
		id: background
		
		anchors.fill: parent
		radius: 5
		
		opacity: focus ? 0.4 : 0.95
		
		color: "navy"
	}
	
	
	Grid {
		id: grid
		
		anchors.fill: background
		anchors.margins: spacing
		
		columns: 3
		spacing: 5
		
		Repeater {
			id: gridRepeater
			model: [7, 8, 9, 4, 5, 6, 1, 2, 3, '/', 0, 'back']
			
			BubbleButton {
//				id: tempBubble
				width: (grid.width - 2*grid.spacing) / 3; height: (grid.height - 3*grid.spacing) / 4
				background.radius: 5
				
				text: modelData === 'back' ? '⬅' : modelData
				color: "yellow"
				
				onClicked: {
					item.keyPressed('' + modelData);
//					console.debug("Key Pressed:", modelData);
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
