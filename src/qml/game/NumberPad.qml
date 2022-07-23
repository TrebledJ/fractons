import QtQuick 2.0

import "../common"

Item {
	id: item
	width: 150; height: 200
	
	signal keyPressed(string key)
	property var keys: [7, 8, 9, 4, 5, 6, 1, 2, 3, '/', 0, 'back']
	
	property alias grid: grid
	
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
		rows: Math.ceil(item.keys.length / columns)
		spacing: 5
		
		Repeater {
			id: gridRepeater
			model: item.keys
			
			BubbleButton {
				width: (grid.width - (grid.columns - 1)*grid.spacing) / grid.columns; height: (grid.height - (grid.rows - 1)*grid.spacing) / grid.rows
				
//				text: modelData === 'back' ? '⬅' : modelData
				text: modelData === 'back' ? '←' : modelData
				onReleased: {
					item.keyPressed('' + modelData);
				}
				
				Connections {
					target: mouseArea
					onPressAndHold: {
						console.debug("Press and held! Key:", modelData);
					}
				}
				
				
				Component.onCompleted:{
//					console.log("Item", modelData, "has grid.columns, grid.rows of", grid.columns, grid.rows)
				}
			}
			
		}
	}
	
	Timer {
		id: animator
		property int index: 0
		
		running: false
		repeat: false
		
		onTriggered: {
			if (index >= gridRepeater.count)
			{
				stop();
				repeat = false;
				return;
			}
			
			gridRepeater.itemAt(index).animateScalar(1.1, 1, 2000);
			index++;
			interval *= 0.9;
		}
		
		function begin() {
			index = 0;
			interval = 150;
			repeat = true;
			start();
		}
	}
	
	function animate() {
		animator.begin();
	}
	
	//	TODO
	//	Add a states/transitions with a genie-like effect, popping up from below
}
