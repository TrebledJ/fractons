//	GameAchievements.qml
//	Singleton for managing achievements

pragma Singleton
import VPlay 2.0
import QtQuick 2.0

import "../common"

import fractureuns 1.0


/**
  
  From the docs:
  
	Achievements have the following properties:
		`name`: string
		`description`: string
		`reward`: int
		`isSecret`: bool
		`progress`: int
		`maxProgress`: int
		`isCollected`: bool
  
  Sources and Citations
  [1]: Qml/JS Dynamic Object Creation w/ Qml String
		http://doc.qt.io/qt-5/qtqml-javascript-dynamicobjectcreation.html#creating-an-object-from-a-string-of-qml
		
  For setting default achievement values, go to Storage.qml
*/

Item {
	id: item
	
	
	function encodeAchievements() {
		var ret = [];
		
		for (var i = 0; i < achievementsManager.achievements.length; i++)
		{
			var obj = {
				name: achievementsManager.achievements[i].name,
				description: achievementsManager.achievements[i].description,
				reward: achievementsManager.achievements[i].reward,
				isSecret: achievementsManager.achievements[i].isSecret,
				progress: achievementsManager.achievements[i].progress,
				maxProgress: achievementsManager.achievements[i].maxProgress,
				isCollected: achievementsManager.achievements[i].isCollected,
			};
			
			ret.push(obj);
		}
		
		return ret;
	}
	
	//	creates JAchievement objects
	function addAchievement(name, description, reward, isSecret, progress, maxProgress, isCollected) {
		if (arguments.length < 7)
		{
			console.warn("Not enough arguments provided to GameAchievements.qml:addAchievement");
			return;
		}
		
		//	see [1]
		var str = "
import fractureuns 1.0
JAchievement { name:'"+name+"'; description:'"+description+"'; reward:"+reward+"; isSecret:"+isSecret+"; progress:"+progress+"; maxProgress:"+maxProgress+"; isCollected:"+isCollected+" }";
		
		var obj = Qt.createQmlObject(str, achievementsManager, 'achievementObject' + achievementsManager.achievements.length)
		
		achievementsManager.achievements.push(obj);	//	add to achievements array in achievementsManager
	}
		
	Component.onCompleted: {
		//	basic setup and data retrieval
		console.warn("Reloading GameAchievements...");
		
		//	connect onChanged signal after setting achievements
		//	whenever achievements changes, update storage
		var listener = function() {
			console.warn("GameAchievements.qml: Achievements changed!");
			
			var encoded = encodeAchievements();
			console.debug(JSON.stringify(encoded));
			
			JStorage.setValue("achievements", encoded);
		}
		achievementsManager.achievementsChanged.connect(listener);
		
		//	connect signal that will remove listener later on
//		achievementsManager.destroyed.connect(function() {	//	sidenote: this doesn't work
//			achievementsManager.achievementsChanged.disconnect(listener);
//		});
		
		
		//	retrieve achievements from storage
		var achievements = JStorage.getValue("achievements")
		if (achievements === undefined)
		{
			console.error("Key: 'achievements' returned undefined from storage.")
			return;
		}
		
		//	clear previous list
		achievementsManager.achievements = [];
		
		//	add achievements to manager
		for (var name in achievements)
		{
			var acvm = achievements[name];
			addAchievement(acvm.name, acvm.description, acvm.reward, acvm.isSecret, acvm.progress, acvm.maxProgress, acvm.isCollected);
		}
		
		
		//	for testing purposes
//		achievementsManager.testNotify();
	}
	
	function debug() {
		console.warn("GameAchievements.qml: Running GameAchievements Debug Function");
		achievementsManager.debug();
	}
	
	function getByIndex(i) {
		if (i < 0 || achievementsManager.achievements.length <= i)
		{
			console.error("Achievement with index", i, "is out of range in GameAchievements.qml::getByIndex");
			return undefined;
		}
		
		return achievementsManager.achievements[i];
	}
	
	function getByName(name) {
		for (var i = 0; i < achievementsManager.achievements.length; i++)
		{
			if (achievementsManager.achievements[i].name === name)
				return achievementsManager.achievements[i];
		}
		
		console.error("Achievement", name, "not found in GameAchievements.qml::getByName");
		return undefined;
	}
	
	function addProgressByIndex(i, amount) {
		var acvm = getByIndex(i);
		if (acvm === undefined)
			return;
		
		acvm.progress += amount;
		
		if (acvm.progress >= acvm.maxProgress && !acvm.isCollected)
		{
			acvm.achievementGet();
			JFractureuns.addFractureuns(acvm.reward);
		}
	}
	
	function addProgressByName(name, amount) {
		var acvm = getByName(name);
		if (acvm === undefined)
			return;
		
		acvm.progress += amount;
		
		if (acvm.progress >= acvm.maxProgress && !acvm.isCollected)
		{
			acvm.achievementGet();
			JFractureuns.addFractureuns(acvm.reward);
		}
	}
	
	function resetAchievements() {
		
	}
}
