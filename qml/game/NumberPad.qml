import QtQuick 2.0

import "../common"

Item {
	id: item
	
	signal keyPressed(string key)
	
	property var keys: [7, 8, 9, 4, 5, 6, 1, 2, 3, '/', 0, 'back']
	property alias grid: grid
	
	function animate() {
		animator.begin();
	}
	
	width: 150; height: 200
	
	Rectangle {
		id: background
		anchors.fill: parent
		radius: 5
		color: "navy"
		opacity: focus ? 0.4 : 0.95
	}
	
	Grid {
		id: grid
		anchors { fill: background; margins: spacing }
		columns: 3; rows: Math.ceil(item.keys.length / columns)
		spacing: 5
		
		Repeater {
			id: gridRepeater
			model: item.keys
			
			BubbleButton {
				width: (grid.width - (grid.columns - 1)*grid.spacing) / grid.columns; height: (grid.height - (grid.rows - 1)*grid.spacing) / grid.rows
				text: modelData === 'back' ? '←' : modelData
				onReleased: item.keyPressed('' + modelData);
			}
		}
	}
	
	Timer {
		id: animator
		property int index: 0
		
		repeat: false
		running: false
		
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
	
	//	TODO
	//	Add a states/transitions with a genie-like effect, popping up from below
}
