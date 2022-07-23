//	GameAchievements.qml
//	Singleton for managing achievements

pragma Singleton
import QtQuick 2.0
import Felgo 3.0 as Felgo

import Fractons 1.0			//	for JAchievement

import "../../common"
import "../../js/Utils.js" as JUtils

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
		console.warn("Reloading JGameAchievements...");
		
		//	connect onChanged signal after setting achievements
		//	whenever achievements changes, update storage
		var listener = function() {
//			console.warn("[GameAchievements] Achievements changed!");
			
			var encoded = JSON.parse(jAchievementsManager.jsonAchievements());
//			console.debug(JSON.stringify(encoded));
			
			JStorage.setValue("achievements", encoded);
		}
		jAchievementsManager.achievementsChanged.connect(listener);
		
		//	connect signal that will remove listener later on
//		jAchievementsManager.destroyed.connect(function() {	//	sidenote: this doesn't work
//			jAchievementsManager.achievementsChanged.disconnect(listener);
//		});
		
//		console.log("[GameAchievements] Loading achievements...");
		loadAchievements();
	}
	
	Connections {
		target: jAchievementsManager
		onAchievementGet: {
			//	QUEST : key = achievement
			JQuests.addQuestProgressByKey("achievement", 1);
			
			//	emit signal
			achievementGet(name, reward);
		}
	}
	
	Component {
		id: achievementComponent
		
		JAchievement {
		}
	}
	
	onAchievementGet: /*string name, int reward*/ {
		JGameNotifications.sendMessage('Achievement Get!', 
									   'You got <i>' + name + '</i> ' +
									   'and earned ' + reward + ' ' + JUtils.nounify(reward, 'ƒracton') + '!', 
									   5);
	}
	
	function loadAchievements() {
		console.warn("[GameAchievements] Loading Achievements")
		
		//	retrieve achievements from storage
		var achievements = JStorage.getValue("achievements");
//		console.log("[GameAchievements] Loading gave", JSON.stringify(achievements));
		if (achievements === undefined)
		{
			console.error("[GameAchievments] Key: 'achievements' returned undefined from storage.")
			return;
		}
		
		//	clear previous list
		jAchievementsManager.clearAchievements();
		
		
		var recursiveAdd = function(root)
		{
			for (var i in root)
			{
				var sub = root[i];
				if (sub.name === undefined)
					recursiveAdd(sub);
				else
				{
//					console.warn("Found achievement", acvm.name, "... Adding...");
//					console.log("[GameAchievements] Adding achievement [" + acvm.name + "] to manager.")
					
					//	add to achievements array in jAchievementsManager
					jAchievementsManager.addAchievement(achievementComponent.createObject(jAchievementsManager, sub))
				}
			}
		}
		
		//	add achievements to manager
		recursiveAdd(achievements);
	}
	
	function getByName(name) {
		var acvm = jAchievementsManager.getByName(name);
		if (acvm === null)
			console.warn("[GameAchievements] Achievement", name, "not found in GameAchievements.qml::getByName");
		
		return acvm;
	}
	
	function getNames(filter) {
		return jAchievementsManager.getNames(filter);
	}
	
	function addProgressByName(name, amount) {
		addProgress(getByName(name), amount);
	}
	
	function setProgressByName(name, amount) {
		setProgress(getByName(name), amount);
	}
	
	function addProgress(acvm, amount) {
		setProgress(acvm, acvm.progress + amount);
	}
	
	function setProgress(acvm, amount) {
		//	error-checking
		if (acvm === undefined)
		{
			console.error("Expected key in GameAchievements::setProgress but got undefined.");
			return;
		}
		if (amount === undefined)
		{
			console.error("Expected amount in GameAchievements::setProgress but got undefined.");
			return;
		}
		if (acvm.progress >= acvm.maxProgress)
			return;
		
		//	set the amount
		acvm.progress = amount;
		
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
	
}
