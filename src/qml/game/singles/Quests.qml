pragma Singleton
import QtQuick 2.0

import "../../js/Math.js" as JMath
import "../../js/Utils.js" as JUtils

//	N.B. all quests reward 25 fractons
//	daily quests unlock from level 5
Item {
	id: item
	
	signal questsModified
	signal updateQuests
	
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
			loadNewQuests();
			return;
		}
		
		//	else, unpack quests
		quests = today;
		
		questsModified();
	}
	
	Connections {
		target: jQuestEngine
		
		onLoadNewQuests: loadNewQuests();
	}
	
	onQuestsModified: {
		console.log("Quests Modified:");
		debug();
		
		JStorage.setValue("todays_quests", quests);
	}
	
	function debug() {
		console.log("Quests:", JSON.stringify(quests));
	}
	
	function loadNewQuests() {
		console.log("Loading new quests...");
		
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
//		questObj.achievement
		values.push("achievement");
		
		//	only allow the lottery beginning at a certain level
		if (JFractons.currentLevel() >= 15)
		{
			questObj.questions.maxProgress = JMath.randI(5, 10);
			questObj.lottery.name = questObj.lottery.name.arg(questObj.questions.maxProgress);
			values.push("lottery");
		}
		
		//	allow the levelling quest up to a certain level
		if (JFractons.currentLevel() < 25)
		{
//			questObj.level
			values.push("level");
		}
		
		//	map to a list of pairs of keys and values
		var keys = JMath.choose(values, 3);
		
		quests = {};	//	clear previous quests
		for (var i in keys)
		{
			quests[keys[i]] = questObj[keys[i]];
		}

		//	emit signals
		questsModified();
		updateQuests();
	}
	
	function getQuestByIndex(index) {
		return quests[Object.keys(quests)[index]];
	}
	
	function addQuestProgressByKey(key, amount) {
		//	error-checking
		if (key === undefined)
		{
			console.error("Expected key in Quests::addQuestProgresByKey but got undefined.");
			return;
		}
		if (amount === undefined)
		{
			console.error("Expected amount in Quests::addQuestProgresByKey but got undefined.");
			return;
		}
		if (quests[key].progress >= quests[key].maxProgress)
			return;
		
		//	add the amount
		quests[key].progress += amount;
		
		//	notify by signal
		questsModified();
		
		if (quests[key].progress >= quests[key].maxProgress && !quests[key].isCollected)
		{
			//	set progress to maxProgress as maximum
			quests[key].progress = quests[key].maxProgress;
			
			//	add the reward
			JFractons.addFractons(20);	//	HARDCODE 20 fractons reward
		}
	}
	
}
