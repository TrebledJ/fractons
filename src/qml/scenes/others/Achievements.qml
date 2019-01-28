//	Achievements.qml
//	Scene for displaying achievements

import VPlay 2.0
import QtQuick 2.0

import "../backdrops"
import "../../common"

import "../../game"

import fractureuns 1.0

SceneBase {
	id: sceneBase
	
	Component.onCompleted: {
		GameAchievements.debug();
		
		var temp = GameAchievements.getByIndex(0);
		if (temp === undefined)
			return;
		
//		temp.description = 'NOO U!';	//	ok, this works
	}
	
	Row {
		anchors.centerIn: parent
		
		spacing: 10
		
		AchievementCard {
			id: acvm0
			width: 80; height: 50
			
			achievement: GameAchievements.getByIndex(0)
			
			onClicked: {
				console.debug("acvm0 clicked!");
			}
		}
		
		AchievementCard {
			id: nou
			width: 80; height: 50
			
			achievement: GameAchievements.getByIndex(1)
			
			onClicked: {
				console.debug("No u clicked!");
			}
		}
	}

	
	
}
