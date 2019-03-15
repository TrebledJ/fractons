pragma Singleton
import QtQuick 2.0

import "../../js/Math.js" as JMath
import "../../js/Utils.js" as JUtils

//	N.B. all quests reward 25 fractons
//	daily quests unlock from level 5

/**
  The quest keys are given by
  
  * fractons	//	increment implemented
  * level		//	increment implemented
  * questions	//	TODO problem
  * achievement	//	increment implemented
  * lottery		//	increment implemented
  
  */

Item {
	id: item
	
	signal questsModified	//	when inner elements of each quest have been changed
	signal questsPurged		//	when entire quest objects have been changed
	
	signal questCompleted(string text, int reward)
	
	readonly property int questReward: 25	//	constant
	
	/**
	  Quests Storage Container:
	  
		{
			key: object {
				name: string,
				progress: int,
				maxProgress: int,
				isCollected: bool
			},
			.
			.
			.
		}
	  
	  
	  */
	property var quests: ({})
	
	Component.onCompleted: {
		console.warn("Reloading JQuests...");
		
		var today = JStorage.getValue("todays_quests");
		
		//	check if no quests were saught
		if (Object.keys(today).length === 0)
		{
			console.log("[Quests] Found 'today' to be an empty object. Loading new quests...")
			loadNewQuests();
			return;
		}
		
		var lastPurge = JStorage.getValue("last_quest_purge");
		if (lastPurge === undefined)
			console.error("[Quests] lastPurge is undefined...");
		jQuestEngine.checkLastPurge(lastPurge);
		
		//	else, unpack quests
		quests = today;
		
		questsModified();
	}
	
	Connections {
		target: jQuestEngine
		
		onLoadNewQuests: {
			loadNewQuests();
		}
	}
	
	onQuestsModified: {
		console.log("Quests Modified");
//		debug();
		console.warn("Modified Quests:", JSON.stringify(quests));
		
		JStorage.setValue("todays_quests", quests);
	}
	
	onQuestsPurged: {
		console.log("Quests Purged");
		
		var lastPurge = jQuestEngine.getLastPurge();
		console.log("[Quests] Setting last quest purge to", lastPurge);
		JStorage.setValue("last_quest_purge", lastPurge);
	}
	
	onQuestCompleted: /*string text, int reward*/ {
		JGameNotifications.sendMessage('Quest Completed!',
									   'You just completed a quest and got ' + reward + ' ' + JUtils.nounify(reward, 'fracton') + '!',
									   5);
	}
	
	function debug() {
		console.log("Quests:", JSON.stringify(quests));
	}
	
	function loadNewQuests() {
		console.log("[Quests.loadNewQuests] Loading new quests...");
		
		var questObj = JStorage.getValue("quests");
		
		var values = [];
		
		//	fractons quest
		questObj.fractons.maxProgress = 5*JMath.randI(12, 20);
		questObj.fractons.name = questObj.fractons.name.arg(questObj.fractons.maxProgress);
		values.push("fractons");

		//	questions quest
//		var randomMode = JMath.choose(["any", "balance", "conversion", "truth", "operations"]);	//	TODO implement other modes
//		values.push(questObj.questions.arg(5*JMath.randI(3,5)).arg(randomMode));
		questObj.questions.maxProgress = 5*JMath.randI(5, 10);
		questObj.questions.name = questObj.questions.name.arg(questObj.questions.maxProgress).arg("any");
		values.push("questions");
		
		//	get-one achievements quest
		//	TODO check that at least one (5 or 10 mb?) achievements are still uncollected
		//	questObj.achievement
		values.push("achievement");
		
		//	only allow the lottery beginning at a certain level
		if (JFractons.currentLevel() >= 15)
		{
			questObj.lottery.maxProgress = JMath.randI(5, 10);
			questObj.lottery.name = questObj.lottery.name.arg(questObj.lottery.maxProgress);
			values.push("lottery");
		}
		
		//	allow the levelling quest up to a certain level
		if (JFractons.currentLevel() < 25)
		{
			//	questObj.level
			values.push("level");
		}
		
		//	map to a list of pairs of keys and values
		var keys = JMath.choose(values, 3);
		
		quests = {};	//	clear previous quests
		for (var i in keys)
		{
			quests[keys[i]] = questObj[keys[i]];
		}
		
		console.warn("New Quests:", JSON.stringify(quests));
		
		jQuestEngine.setLastPurge(new Date());

		//	emit signals
		questsModified();
		questsPurged();
	}
	
	function getQuestByIndex(index) {
		return quests[Object.keys(quests)[index]];
	}
	
	function addQuestProgressByKey(key, amount, param) {
		//	error-checking
		if (key === undefined)
		{
			console.error("Expected key in Quests::addQuestProgressByKey but got undefined.");
			return;
		}
		if (amount === undefined)
		{
			console.error("Expected amount in Quests::addQuestProgressByKey but got undefined.");
			return;
		}
		if (quests[key] === undefined)
		{
			console.warn("Key", key, "was not found in quests.");
			return;
		}
		if (amount === 0)
			return;
		
//		if (key === "questions")
//		{
//			var modeName = param;
//			if (modeName === "")
//		}
		
		
		
		//	check progress hasn't been exceeded
		if (quests[key].progress >= quests[key].maxProgress)
			return;
		
		//	add the amount
		quests[key].progress += amount;
		
		if (quests[key].progress >= quests[key].maxProgress && !quests[key].isCollected)
		{
			//	set progress to maxProgress as maximum
			quests[key].progress = quests[key].maxProgress;
			quests[key].isCollected = true;
			
			questCompleted(quests[key].name, questReward);
			
			//	ACVM : adventurer
			JGameAchievements.addProgressByName("adventurer i", 1);
			JGameAchievements.addProgressByName("adventurer ii", 1);
			JGameAchievements.addProgressByName("adventurer iii", 1);
			JGameAchievements.addProgressByName("adventurer iv", 1);
			JGameAchievements.addProgressByName("adventurer v", 1);
			
			//	add the reward
			JFractons.addFractons(questReward);	//	HARDCODE 25 fractons reward
		}
		
		//	notify by signal
		questsModified();
	}
	
}
