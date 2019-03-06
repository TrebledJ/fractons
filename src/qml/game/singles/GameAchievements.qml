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
	
	signal achievementGet(string name, int reward)
		
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
	
	Connections {
		target: jAchievementsManager
		onAchievementGet: achievementGet(name, reward);
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
					hint: jAchievementsManager.achievements[i].hint,
					group: jAchievementsManager.achievements[i].group,
					reward: jAchievementsManager.achievements[i].reward,
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
		
		
		var recursiveAdd = function(root)
		{
			for (var i in root)
			{
				var sub = root[i];
				if (sub.name === undefined)
					recursiveAdd(sub);
				else
				{
					var acvm = sub;
					console.log("[GameAchievements] Adding achievement [" + acvm.name + "]")
					addAchievement(acvm.name, acvm.description, acvm.hint, acvm.group, acvm.reward,
								   acvm.progress, acvm.maxProgress, acvm.isCollected);
				}
			}
		}
		
		//	add achievements to manager
		recursiveAdd(achievements);
//		for (var name in achievements)
//		{
//			var acvm = achievements[name];
//			console.log("[GameAchievements] Adding achievement [" + acvm.name + "]")
//			addAchievement(acvm.name, acvm.description, acvm.hint, acvm.group, acvm.reward,
//						   acvm.progress, acvm.maxProgress, acvm.isCollected);
//		}
	}
	
	//	creates JAchievement objects
	function addAchievement(name, description, hint, group, reward, progress, maxProgress, isCollected) {
		if (arguments.length !== 8)
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
	hint: '"+hint+"';
	group: '"+group+"';
	reward: "+reward+";
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
		//	filters should be whitespace-delimited
		filter = filter === undefined ? filter = [] : filter.split(' ');
		
		var passesFilters = function(acvm)
		{
			//	checks filters to see if it matches an achievement
			for (var i in filter)
			{
				var req = filter[i];
				if (req.length === 0)
					continue;
				if (req[0] === '!' && req.substr(1) === acvm.class)	//	tests for a 'not'-filter
					return false;
				if (req[0] !== '!' && req !== acvm.class)	//	tests for an affirmative filter
					return false;
			}
			
			return true;
		}
		
		//	iterate through achievements and collect those that pass the filters
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
