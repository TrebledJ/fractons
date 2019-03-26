pragma Singleton
import QtQuick 2.0

import "../../js/Math.js" as JMath
import "../../js/Utils.js" as JUtils

//	N.B. all quests reward 25 fractons
//	daily quests unlock from level 5

/**
  The quest keys are given by
  
  * fractons
  * level
  * questions
  * achievement
  * lottery
  
  */

Item {
	id: item
	
	signal questsModified	//	when inner elements of each quest have been changed
//	signal questsPurged		//	when entire quest objects have been changed
	
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
		
		/*
		//	retrieve LPT
			if LPT is less than most recent midnight:
				-> purge quests
					-> choose 3 random quests
					-> store quests
					-> update quests into local property
				
				-> calculate time remaining
				-> update time remaining into local property
			
		*/
		var lpt = JStorage.getValue("quests/last_purge_time");
		console.warn("Last Purge Time:", lpt);
		if (lpt === undefined)
		{
			console.error("[Quests] quests/last_purge_time returned undefined from storage.");
			return;
		}
		
		lpt = new Date(lpt);
		
		var midnight = toMidnight(new Date());

		//	check lpt is before midnight
		if (lpt < midnight)
		{
			//	1. purge quests
			purgeQuests();
			
			//	a. choose 3 random quests
			//	b. store new quests
			//	c. update quests into local property
		}
		else
		{
			//	retrieve quests from storage
			quests = JStorage.getValue("quests/current");
		}
		
		//	2. calculate time remaining
		//	3. update remaining time into local property and store
		
	}
	
	onQuestsChanged: {
		console.log("Quests Changed");
//		debug();
	}
	
	onQuestsModified: {
		console.log("Quests Modified");
//		debug();
		
		JStorage.setValue("quests/current", quests);
	}
	
	onQuestCompleted: /*string text, int reward*/ {
		JGameNotifications.sendMessage('Quest Completed!',
									   'You just completed a quest and got ' + reward + ' ' + JUtils.nounify(reward, 'fracton') + '!',
									   5);
	}
	
	function debug() {
		console.log("Quests:", JSON.stringify(quests));
	}
	
	function toMidnight(date) {
		date.setHours(0); date.setMinutes(0); date.setSeconds(0); date.setMilliseconds(0);
		
		return date;
	}
	
	function purgeQuests() {
		console.warn("Purging Quests");
		
		//	i. retrieve all quests from storage
		var questObj = JStorage.getValue("quests/all");
		
		var values = [];
		
		//	fractons quest
		questObj.fractons.maxProgress = 5*JMath.randI(12, 20);
		questObj.fractons.text = questObj.fractons.text.arg(questObj.fractons.maxProgress);
		values.push("fractons");

		//	questions quest
		//	var randomMode = JMath.choose(["any", "balance", "conversion", "truth", "operations"]);	//	TODO implement other modes
		//	values.push(questObj.questions.arg(5*JMath.randI(3,5)).arg(randomMode));
		questObj.questions.maxProgress = 5*JMath.randI(5, 10);
		questObj.questions.text = questObj.questions.text.arg(questObj.questions.maxProgress).arg("any");
		values.push("questions");
		
		//	get-one achievements quest
		//	TODO check that at least one (5 or 10 mb?) achievements are still uncollected
		//	questObj.achievement
		values.push("achievement");
		
		//	only allow the lottery beginning at a certain level
		if (JFractons.currentLevel() >= 15)
		{
			questObj.lottery.maxProgress = JMath.randI(5, 10);
			questObj.lottery.text = questObj.lottery.text.arg(questObj.lottery.maxProgress);
			values.push("lottery");
		}
		
		//	allow the levelling quest up to a certain level
		if (JFractons.currentLevel() < 25)
		{
			//	questObj.level
			values.push("level");
		}
		
		//	A. choose 3 random quests
		//	map to a list of pairs of keys and values
		var keys = JMath.choose(values, 3);
		
		var temp = {};	//	clear previous quests
		for (var i in keys)
		{
			temp[keys[i]] = questObj[keys[i]];
		}
		
		//	B. store new quests
		JStorage.setValue("quests/current", temp);
		
		JStorage.setValue("quests/last_purge_time", new Date().toISOString());
		
		//	C. update quests into local property
		quests = temp;
		
		console.warn("New Quests:", JSON.stringify(quests));
		
	}
	
	function timeToPurge() {
		//	2. calculate time remaining
		//	3. update remaining time into local property and store
		var midnight = toMidnight(new Date());
		var nextMidnight = midnight.setDate(midnight.getDate() + 1);
		var currentTime = new Date();
		
		var interval = new Date(nextMidnight - currentTime);
		
		var h = interval.getUTCHours();
		var m = interval.getUTCMinutes();
		var ret = '';
		
		if (h != 0)
		{
			ret += h + ' hour';
			if (h != 1)
				ret += 's';
		}

		if (m != 0)
		{
			ret += ' ' + m + ' minute';
			if (m != 1)
				ret += 's';
		}

		return ret;
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
