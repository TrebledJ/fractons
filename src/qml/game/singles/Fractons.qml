//	Fractons.qml

pragma Singleton
import QtQuick 2.0

Item {
//	id: item
	
	signal levelUp(int level)
	
	property int fCurrent: -1
	property int fLevelingConstant: -1	//	also the fractons threshold for Level 1
	
	Component.onCompleted: {
		//	basic setup and data retrieval
		console.warn("Reloading JFractons...");
		
		loadFractons();
	}
	
	onFCurrentChanged: {
		setFractons(fCurrent);
	}
	
	onFLevelingConstantChanged: {
		//	should need this
		//	JStorage.setValue("fLevelingConstant", fLevelingConstant);
	}
	
	onLevelUp: {
		console.warn("Player leveled up!");
//		jNotifications.notify("Level Up!", "Congratulations! You've reached level " + level + "!", 3);
		
		//	ACVM : leveller
		JGameAchievements.setProgressByName("leveller i", level);
		JGameAchievements.setProgressByName("leveller ii", level);
		JGameAchievements.setProgressByName("leveller iii", level);
		JGameAchievements.setProgressByName("leveller iv", level);
		JGameAchievements.setProgressByName("leveller v", level);
		
	}
	
	function addFractons(amount) {
		if (amount === '' || isNaN(amount))
		{
			console.error("Fractons:/game/singles/Storage.qml:addFractons(amount) ::: Expected integer, got", "'" + amount + "'");
			return;
		}
		
		//	add amount
		fCurrent += amount;
		JGameStatistics.addDailyFractons(amount);
		
		//	check if difference caused level-up
		if (levelAt(fCurrent - amount) < levelAt(fCurrent))
			levelUp(levelAt(fCurrent));	//	emit the level up signal
		
	}
	
	function levelAt(fractons) {
		if (fractons === '' || isNaN(fractons))
			fractons = fCurrent;
		
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
		return Math.floor(-0.5 + Math.sqrt(0.25 + 2 *fractons / fLevelingConstant)) + 1;
	}
	
	function currentLevel() {
		return levelAt();
	}
	
	function fCurrentThresh() {
		return fThresh(currentLevel());
	}
	
	function fNextThresh() {
		return fThresh(currentLevel() + 1);
	}
	
	function fProgress() {
		var fThreshAbove = fNextThresh();
		var fThreshBelow = fCurrentThresh();
		return 1 - (fThreshAbove - fCurrent) / (fThreshAbove - fThreshBelow);
	}
	
	function fThresh(lvl) {
		//	y = I*x*(x + 1)/2
		return (fLevelingConstant * (lvl - 1) * lvl / 2);
	}
	
	function loadFractons() {
		var fC = JStorage.getValue("fCurrent");
		if (fC === undefined) console.error("[Fractons] Key: 'fCurrent' returned undefined from storage.");
		fCurrent = fC !== undefined ? fC : 0;
		
		var fLC = JStorage.getValue("fLevelingConstant");
		if (fLC === undefined) console.error("[Fractons] Key: 'fLevelingConstant' returned undefined from storage.");
		fLevelingConstant = fLC !== undefined ? fLC : 25;
	}
	
	//	centralised function, don't need to bother with remembering the key (i.e. fCurrent)
	function setFractons(ftn) {
		JStorage.setValue("fCurrent", ftn);
	}
	
	
	
	
	//	========================  //
	
	function debug() {
		console.debug("State of Fractons:");
		console.debug(" • Current Amount [fCurrent]:", fCurrent);
		console.debug(" • Current Threshold [fCurrentThresh()]:", fCurrentThresh());
		console.debug(" • Next Threshold [fNextThresh()]:", fNextThresh());
		console.debug(" • Current Level [currentLevel()]:", currentLevel());
		console.debug(" • Current Progress [fProgress()]:", fProgress());
		
		
	}
	
}
