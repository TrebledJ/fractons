//	Fractons.qml

pragma Singleton
import QtQuick 2.0

Item {
	signal levelUp(int level, int previous)
	
	property int fractons: -1
	property int levelingConstant: -1	//	also the fractons threshold for Level 1
	
	//	== JS FUNCTIONS ==
	
	function addFractons(amount) {
		if (amount === '' || isNaN(amount))
		{
			console.error("Fractons:/game/singles/Storage.qml:addFractons(amount) ::: Expected integer, got", "'" + amount + "'");
			return;
		}
		
		//	add amount
		fractons += amount;
		
		//	STATS : add daily fractons
		JGameStatistics.addDailyFractons(amount);
		
		//	QUEST : key = fractons
		JQuests.addQuestProgressByKey("fractons", amount);
		
		
		//	check if difference caused level-up
		var previous = levelAt(fractons - amount);
		var current = currentLevel();
		if (previous < current)
			levelUp(current, previous);	//	emit the level up signal
	}
	
	function levelAt(f) {
		if (f === '' || isNaN(f))
			f = fractons;
		
		/*
		  XP Polynomial Equation:
		  
			y = I*x*(x + 1)/2
			
			where
				x = level,
				y = minimum fractons required to reach level x,
				I = fractons init/increment (fractonsLevelingConstant here)
		  */
		/*
		  Solving for x, by the quadratic equation, etc, we get
		  
		  x = -1/2 + √((I + 8y) / 4I)
		  x = -0.5 + √(0.25 + 2*y/I)
		  */
		
		//	implements quadratic formula from equation above. +1 for a 1-based index
		return Math.floor(-0.5 + Math.sqrt(0.25 + 2 * f / levelingConstant)) + 1;
	}
	
	function currentLevel() { return levelAt(); }
	function currentThresh() { return thresh(currentLevel()); }
	function nextThresh() { return thresh(currentLevel() + 1); }
	function progress() { var fThreshAbove = nextThresh(); return 1 - (fThreshAbove - fractons) / (fThreshAbove - currentThresh()); }
	
	//	y = I*x*(x + 1)/2
	function thresh(lvl) { return (levelingConstant * (lvl - 1) * lvl / 2); }
	
	function loadFractons() {
		var fC = JStorage.getValue("fractons");
		if (fC === undefined) console.error("[Fractons] Key: 'fractons' returned undefined from storage.");
		fractons = fC !== undefined ? fC : 0;
		
		var fLC = JStorage.getValue("leveling_constant");
		if (fLC === undefined) console.error("[Fractons] Key: 'leveling_constant' returned undefined from storage.");
		levelingConstant = fLC !== undefined ? fLC : 25;
	}
	
	//	centralised function, don't need to bother with remembering the key (i.e. fCurrent)
	function setFractons(f) { JStorage.setValue("fractons", f); }
	
	function debug() {
		console.debug("State of Fractons:");
		console.debug(" • Current Fractons [fractons]:", fractons);
		console.debug(" • Current Threshold [currentThresh()]:", currentThresh());
		console.debug(" • Next Threshold [nextThresh()]:", nextThresh());
		console.debug(" • Current Level [currentLevel()]:", currentLevel());
		console.debug(" • Current Progress [progress()]:", progress());
	}
	
	
	//	== ATTACHED PROPERTIES & SIGNALS ==
	
	Component.onCompleted: {
		console.warn("Reloading JFractons...");
		loadFractons();
		debug();
	}
	
	onFractonsChanged: setFractons(fractons);
	
	onLevelUp: /*int level, int previous*/ {
		console.warn("Player leveled up!");
		
		//	push a notification
		//	add tokens for each level surpassed
		for (var l = previous + 1; l <= level; l++)
		{
			JStorage.addTokens(l);
			
			var unlocked = {
				1: 'Balance Mode',
				5: 'Conversion Mode',
				10: 'Operations Mode',
				15: 'Fill Mode',
				20: 'Truth Mode',
				25: 'The Lottery',
			}[l];
			unlocked = unlocked ? 'Unlocked ' + unlocked : '';
			
			JGameNotifications.notify('Level Up!', "Congratulations, you've levelled up to Level " + l + '!', unlocked);
		}
		
		//	QUEST : key = level
		JQuests.addQuestProgressByKey("level", 1);
		
		//	ACVM : leveller
		JGameAchievements.setProgressByName("leveller i", level);
		JGameAchievements.setProgressByName("leveller ii", level);
		JGameAchievements.setProgressByName("leveller iii", level);
		JGameAchievements.setProgressByName("leveller iv", level);
		JGameAchievements.setProgressByName("leveller v", level);
		
	}
}
