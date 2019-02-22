//	Fractureuns.qml

pragma Singleton
import Felgo 3.0
import QtQuick 2.0

//import "../../game/singles"

Item {
//	id: item
	
	signal levelUp(int level)
	
	property int fCurrent: -1
	property int fLevelingConstant: -1	//	also the fractureuns threshold for Level 1
	
	Component.onCompleted: {
		//	basic setup and data retrieval
		console.warn("Reloading JFractureuns...");
		
		loadFractureuns();
	}
	
	onFCurrentChanged: {
		setFractureuns(fCurrent);
	}
	
	onFLevelingConstantChanged: {
		//	should need this
		//	JStorage.setValue("fLevelingConstant", fLevelingConstant);
	}
	
	onLevelUp: {
		console.warn("Player leveled up!");
		jNotifications.notify("Level Up!", "Congratulations! You've reached level " + level + "!", 5);
	}
	
	function addFractureuns(amount) {
		if (amount === '' || isNaN(amount))
		{
			console.error("Fractureuns:/game/singles/Storage.qml:addFractureuns(amount) ::: Expected integer, got", "'" + amount + "'");
			return;
		}
		
		//	add amount
		fCurrent += amount;
		
		//	check if difference caused level-up
		if (levelAt(fCurrent - amount) < levelAt(fCurrent))
			levelUp(levelAt(fCurrent));	//	emit the level up signal
	}
	
	function levelAt(fractureuns) {
		if (fractureuns === '' || isNaN(fractureuns))
			fractureuns = fCurrent;
		
		/*
		  XP Polynomial Equation:
		  
			y = I*x*(x + 1)/2
			
			where
				x = level,
				y = minimum fractureuns required to reach level x,
				I = fractureuns init/increment (fractureunsLevelingConstant here)
		  */
		/*
		  Solving for x, by the quadratic equation, etc, we get
		  
		  x = -1/2 + √((I + 8y) / 4I)
		  x = -0.5 + √(0.25 + 2*y/I)
		  */
		
		//	implements quadratic formula from equation above. +1 for a 1-based index
		return Math.floor(-0.5 + Math.sqrt(0.25 + 2 *fractureuns / fLevelingConstant)) + 1;
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
	
	function loadFractureuns() {
		var fC = JStorage.getValue("fCurrent");
		fCurrent = fC !== undefined ? fC : 0;
		
		var fLC = JStorage.getValue("fLevelingConstant");
		fLevelingConstant = fLC !== undefined ? fLC : 25;
	}
	
	//	centralised function, don't need to bother with remembering the key (i.e. fCurrent)
	function setFractureuns(ftn) {
		JStorage.setValue("fCurrent", ftn);
	}
	
	
	
	
	//	========================  //
	
	function debug() {
		console.debug("State of Fractureuns:");
		console.debug(" • Current Amount [fCurrent]:", fCurrent);
		console.debug(" • Current Threshold [fCurrentThresh()]:", fCurrentThresh());
		console.debug(" • Next Threshold [fNextThresh()]:", fNextThresh());
		console.debug(" • Current Level [currentLevel()]:", currentLevel());
		console.debug(" • Current Progress [fProgress()]:", fProgress());
		
		
	}
	
}
