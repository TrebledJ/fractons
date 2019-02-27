//	GameAchievements.qml
//	Singleton for managing achievements

pragma Singleton
import QtQuick 2.0

import Fractons 1.0

import "../../common"


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
		
	Component.onCompleted: {
		//	basic setup and data retrieval
		console.warn("Reloading GameAchievements...");
		
		//	connect onChanged signal after setting achievements
		//	whenever achievements changes, update storage
		var listener = function() {
			console.warn("[GameAchievements] Achievements changed!");
			
			var encoded = priv.encodeAchievements();
//			console.debug(JSON.stringify(encoded));
			
			JStorage.setValue("achievements", encoded);
		}
		jAchievementsManager.achievementsChanged.connect(listener);
		
		//	connect signal that will remove listener later on
//		jAchievementsManager.destroyed.connect(function() {	//	sidenote: this doesn't work
//			jAchievementsManager.achievementsChanged.disconnect(listener);
//		});
		
		
		loadAchievements();
		
		//	for testing purposes
//		jAchievementsManager.testNotify();
	}
	
	QtObject {
		id: priv
		
		function encodeAchievements() {
			var ret = [];
			
			for (var i = 0; i < jAchievementsManager.achievements.length; i++)
			{
				var obj = {
					name: jAchievementsManager.achievements[i].name,
					description: jAchievementsManager.achievements[i].description,
					reward: jAchievementsManager.achievements[i].reward,
					isSecret: jAchievementsManager.achievements[i].isSecret,
					secret: jAchievementsManager.achievements[i].secret,
					isClassified: jAchievementsManager.achievements[i].isClassified,
					progress: jAchievementsManager.achievements[i].progress,
					maxProgress: jAchievementsManager.achievements[i].maxProgress,
					isCollected: jAchievementsManager.achievements[i].isCollected,
				};
				
				ret.push(obj);
			}
			
			return ret;
		}
		
	}
	
	function loadAchievements() {
		//	retrieve achievements from storage
		var achievements = JStorage.getValue("achievements")
		if (achievements === undefined)
		{
			console.error("[GameAchievments] Key: 'achievements' returned undefined from storage.")
			return;
		}
		
		//	clear previous list
		jAchievementsManager.achievements = [];
		
		//	add achievements to manager
		for (var name in achievements)
		{
			var acvm = achievements[name];
			console.log("[GameAchievements] Adding achievement [" + acvm.name + "]")
			addAchievement(acvm.name, acvm.description, acvm.reward, acvm.isSecret, acvm.secret,
						   acvm.isClassified, acvm.progress, acvm.maxProgress, acvm.isCollected);
		}
	}
	
	//	creates JAchievement objects
	function addAchievement(name, description, reward, isSecret, secret, isClassified, progress, maxProgress, isCollected) {
		if (arguments.length !== 9)
		{
			console.warn("[GameAchievements] Incorrect number of arguments provided to GameAchievements.qml::addAchievement");
			return;
		}
		
		//	see [1]
		var str = "
import Fractons 1.0 
JAchievement {
	name: '"+name+"';
	description: '"+description+"';
	reward: "+reward+";
	isSecret: "+isSecret+";
	secret: '"+secret+"';
	isClassified: "+isClassified+";
	progress: "+progress+";
	maxProgress: "+maxProgress+";
	isCollected: "+isCollected+";
}";
		
		var obj = Qt.createQmlObject(str, jAchievementsManager, 'achievementObject' + jAchievementsManager.achievements.length)
		
		jAchievementsManager.achievements.push(obj);	//	add to achievements array in jAchievementsManager
	}
	
	function getByIndex(i) {
		if (i < 0 || jAchievementsManager.achievements.length <= i)
		{
			console.error("[GameAchievements] Achievement with index", i, "is out of range in GameAchievements.qml::getByIndex");
			return undefined;
		}
		
		return jAchievementsManager.achievements[i];
	}
	
	function getByName(name) {
		for (var i = 0; i < jAchievementsManager.achievements.length; i++)
		{
			if (jAchievementsManager.achievements[i].name.toLowerCase() === name.toLowerCase())
				return jAchievementsManager.achievements[i];
		}
		
		console.error("[GameAchievements] Achievement", name, "not found in GameAchievements.qml::getByName");
		return undefined;
	}
	
	function getNames(filter) {
		filter = filter === undefined ? filter = [] : filter.split(' ');
		
		var passesFilters = function(acvm)
		{
			for (var i in filter)
			{
				var req = filter[i];
				if (req === "secret" && !acvm.isSecret)
					return false;
				if (req === "!secret" && acvm.isSecret)
					return false;
				if (req === "classified" && !acvm.isClassified)
					return false;
				if (req === "!classified" && acvm.isClassified)
					return false;
				if (req === "collected" && !acvm.isCollected)
					return false;
				if (req === "!collected" && acvm.isCollected)
					return false;
			}
			
			return true;
		}
		
		var ret = [];
		for (var i = 0; i < jAchievementsManager.achievements.length; i++)
		{
			var acvm = jAchievementsManager.achievements[i];
			if (passesFilters(acvm))
				ret.push(acvm.name);
		}
		
		return ret;
	}
	
	function addProgressByIndex(i, amount) {
		addProgress(getByIndex(i), amount);
	}

	function addProgressByName(name, amount) {
		addProgress(getByName(name), amount);
	}
	
	function addProgress(acvm, amount) {
		//	error-checking
		if (acvm === undefined)
			return;
		if (amount === undefined)
			amount = 1;
		if (acvm.progress >= acvm.maxProgress)
			return;
		
		//	add the amount
		acvm.progress += amount;
		
		if (acvm.progress >= acvm.maxProgress && !acvm.isCollected)
		{
			//	set progress to maxProgress as maximum
			acvm.progress = acvm.maxProgress;
			
			//	emit the achievementGet signal
			acvm.achievementGet();
			
			//	add the reward
			JFractons.addFractons(acvm.reward);
		}
	}
	
	
	//	TODO Deprecate
	function resetAchievements() {
		
	}
}
